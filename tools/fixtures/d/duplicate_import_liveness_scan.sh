#!/bin/sh
# Resolves every exact-path @import("...") against the tree's duplicate-content
# groups, and splits duplicate bytes into LIVE (both copies independently
# reached by a live import) and INERT (one or both copies unreached).
#
# This is the buildable next step named by
# active-designing/date/20260918/20260918-072000_the-duplicate-content-census-overstates-its-own-case.md
# step 3-4: a basename grep over-collects (color.rye alone matches 73 files
# across unrelated rooms), so liveness is decided by resolving each import
# string against the IMPORTING FILE'S OWN DIRECTORY, the rule Zig itself
# applies and this tree's own stamp-and-name.md already states for the
# hand-filed-symlink family.
#
# A digest match by filesystem content (sha256sum follows symlinks) is not
# the same claim as duplicate STORAGE: a tracked git symlink (mode 120000)
# stores only its target string as its blob -- a handful of bytes -- and the
# OS resolves it to the one real file on every read, so it is never a second
# compilation to avoid. Groups whose members are not ALL regular files
# (mode 100644/100755) are excluded from the byte arithmetic and reported
# separately as symlink_only_groups.
#
# Usage: sh tools/fixtures/d/duplicate_import_liveness_scan.sh [--list]

set -eu

cd "$(git rev-parse --show-toplevel)"

LIST=0
if [ "${1:-}" = "--list" ]; then
  LIST=1
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Step 1-2: hash every tracked .rye file, group by digest, keep groups >= 2.
git ls-files -z -- '*.rye' \
  | xargs -0 -I{} sh -c 'test -f "{}" && sha256sum "{}"' \
  > "$WORK/hashes.txt"

awk '{ h=$1; $1=""; sub(/^ /,""); print h, $0 }' "$WORK/hashes.txt" \
  | sort > "$WORK/hashes_sorted.txt"

awk '{ print $1 }' "$WORK/hashes_sorted.txt" | uniq -c \
  | awk '$1 >= 2 { print $2 }' > "$WORK/dup_digests.txt"

DUP_DIGESTS=$(wc -l < "$WORK/dup_digests.txt" | tr -d ' ')

# Members of each duplicate group, one "digest path" per line.
grep -Ff "$WORK/dup_digests.txt" "$WORK/hashes_sorted.txt" > "$WORK/dup_members.txt" || true
DUP_MEMBER_FILES=$(wc -l < "$WORK/dup_members.txt" | tr -d ' ')

# Which tracked .rye paths are symlinks (mode 120000) rather than regular
# files -- read from git's own index, ground truth for what a blob stores.
git ls-files -s -- '*.rye' | awk '$1=="120000" { print $4 }' | sort -u > "$WORK/symlink_paths.txt"

# Step 3: resolve every @import("....rye") string against its importer's own
# directory -- the same rule Zig applies -- and record the resolved target.
: > "$WORK/resolved_targets.txt"
git ls-files -- '*.rye' | while IFS= read -r f; do
  dir=$(dirname -- "$f")
  grep -oE '@import\("[^"]+\.rye"\)' -- "$f" 2>/dev/null | sed -E 's/@import\("([^"]+)"\)/\1/' | while IFS= read -r target; do
    resolved=$(realpath -m --relative-to=. -- "$dir/$target" 2>/dev/null) || continue
    printf '%s\n' "$resolved" >> "$WORK/resolved_targets.txt"
  done
done
sort -u "$WORK/resolved_targets.txt" > "$WORK/resolved_targets_sorted.txt"
RESOLVED_TARGETS=$(wc -l < "$WORK/resolved_targets_sorted.txt" | tr -d ' ')

# Step 4: for each duplicate-group member, mark live if its exact path is a
# resolved import target of some other file. A group with any symlink member
# is excluded from the byte arithmetic (it stores no real duplicate bytes)
# and counted separately.
LIVE_BYTES=0
INERT_BYTES=0
LIVE_GROUPS=0
INERT_GROUPS=0
SYMLINK_ONLY_GROUPS=0
GROUP_DETAIL=""

for digest in $(cat "$WORK/dup_digests.txt"); do
  members=$(awk -v d="$digest" '$1==d {print $2}' "$WORK/dup_members.txt")
  count=$(printf '%s\n' "$members" | grep -c .)

  has_symlink=0
  for m in $members; do
    if grep -qxF "$m" "$WORK/symlink_paths.txt"; then
      has_symlink=1
    fi
  done

  if [ "$has_symlink" = "1" ]; then
    SYMLINK_ONLY_GROUPS=$((SYMLINK_ONLY_GROUPS + 1))
    [ "$LIST" = "1" ] && GROUP_DETAIL="$GROUP_DETAIL
SYMLINK digest=${digest:0:12} count=$count $(printf '%s' "$members" | tr '\n' ' ')"
    continue
  fi

  # git's own blob size, ground truth for what this repository stores.
  first=$(printf '%s\n' "$members" | head -1)
  size=$(git cat-file -s "HEAD:$first" 2>/dev/null || echo 0)

  live_count=0
  for m in $members; do
    if grep -qxF "$m" "$WORK/resolved_targets_sorted.txt"; then
      live_count=$((live_count + 1))
    fi
  done
  extra=$(( (count - 1) * size ))
  if [ "$live_count" -ge 2 ]; then
    LIVE_GROUPS=$((LIVE_GROUPS + 1))
    LIVE_BYTES=$((LIVE_BYTES + extra))
    [ "$LIST" = "1" ] && GROUP_DETAIL="$GROUP_DETAIL
LIVE  digest=${digest:0:12} count=$count live=$live_count extra_bytes=$extra $(printf '%s' "$members" | tr '\n' ' ')"
  else
    INERT_GROUPS=$((INERT_GROUPS + 1))
    INERT_BYTES=$((INERT_BYTES + extra))
    [ "$LIST" = "1" ] && GROUP_DETAIL="$GROUP_DETAIL
INERT digest=${digest:0:12} count=$count live=$live_count extra_bytes=$extra $(printf '%s' "$members" | tr '\n' ' ')"
  fi
done

echo "tracked_rye_files=$(git ls-files -- '*.rye' | wc -l | tr -d ' ')"
echo "duplicate_rye_digests=$DUP_DIGESTS"
echo "duplicate_rye_members=$DUP_MEMBER_FILES"
echo "resolved_import_targets=$RESOLVED_TARGETS"
echo "symlink_only_groups=$SYMLINK_ONLY_GROUPS"
echo "live_groups=$LIVE_GROUPS"
echo "inert_groups=$INERT_GROUPS"
echo "live_duplicate_extra_bytes=$LIVE_BYTES"
echo "inert_duplicate_extra_bytes=$INERT_BYTES"
if [ "$LIST" = "1" ]; then
  printf '%s\n' "$GROUP_DETAIL"
fi
