#!/bin/sh
# tools/fixtures/r/readme_reach_control.sh -- the front-door crawl, proven from both sides.
#
# A reachability guard that only ever says "all doors open" cannot be told from a guard that never
# walked. This pen builds small trees in a temporary directory and checks fifteen behaviors.
#
# WHAT IS PROVEN
#   clean_free          -- a tree whose links all resolve passes
#   living_bitten       -- a broken link in a LIVING file is refused
#   living_named        -- and the refusal names the file and the target
#   testimony_ratchets  -- the same break inside a DATED file is counted, never gated
#   testimony_never_gates -- however high the testimony count climbs, it is reported and never refused
#   unreached_free      -- a break in a document README does not reach is out of scope
#   external_free       -- an http target is never followed or counted
#   depth_walked        -- the crawl follows links through several levels, not just one
#
# AND SEVEN FOR THE INDEX STORE, added 20260907 for REDS %524. The store changes where the bytes
# come from and nothing else, so the first case proves the two agree and the rest prove they
# disagree exactly where they should -- which is the whole reason the commit-time wall reads the
# index rather than disk.
#   index_agrees        -- on one clean tree both stores reach the same documents and verdict
#   index_bitten        -- a break the INDEX carries is refused by the index store
#   index_ignores_disk  -- a repair standing only in the worktree does NOT excuse the index
#   index_sees_deletion -- a target deleted from the index is refused though disk still holds it
#   index_dir_target    -- a link naming a directory resolves, though the index lists only files
#   index_needs_repo    -- outside a git repository the index store refuses by name
#   store_unknown       -- an unknown --store word refuses rather than falling back to a default
#
# USAGE
#   sh tools/fixtures/r/readme_reach_control.sh
#
# Driven by tools/r/readme_reach_witness.rish. Run from the repository root.

set -u

# The launch directory is the repository root; it is held by name so the close below returns to
# it directly rather than by depth arithmetic off the scan's path, which the letter fold
# (seated 20260828) moved one directory deeper.
ROOT=$(pwd)
SCAN=$ROOT/tools/fixtures/r/readme_reach_scan.sh
faults=0
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

check() {
  _n=$1; _w=$2; _g=$3
  if [ "$_w" = "$_g" ]; then echo "case=$_n ok ($_g)"
  else echo "case=$_n FAULT want=$_w got=$_g"; faults=$((faults + 1)); fi
}

# The scan reads paths relative to the working directory, so each case runs inside its own tree.
build() {
  rm -rf "$pen/t"; mkdir -p "$pen/t"; cd "$pen/t"
}

verdict_of() { printf '%s\n' "$1" | sed -n 's/^verdict=//p'; }
value_of() { printf '%s\n' "$1" | sed -n "s/^$2=//p"; }

# 1 -- every link resolves, and the crawl walks more than one level deep.
build
printf '# root\n[a](a.md)\n' > README.md
printf '# a\n[b](b.md)\n' > a.md
printf '# b\ndone\n' > b.md
out=$(sh "$SCAN" 2>&1); check clean_free ok "$(verdict_of "$out")"
check depth_walked 3 "$(value_of "$out" documents_reached)"

# 2 -- a broken link in a LIVING file is refused, and the refusal names it.
build
printf '# root\n[gone](missing.md)\n' > README.md
out=$(sh "$SCAN" 2>&1); code=$?
check living_bitten living_link_broken "$(verdict_of "$out")"
case "$out" in *"living: README.md -> missing.md"*) check living_named ok ok ;; *) check living_named ok unnamed ;; esac

# 3 -- the same break inside DATED testimony is counted rather than gated.
build
printf '# root\n[log](20260101-010101_a-log.md)\n' > README.md
printf '# log\n[gone](missing.md)\n' > 20260101-010101_a-log.md
out=$(sh "$SCAN" 2>&1)
if [ "$(verdict_of "$out")" = "ok" ] && [ "$(value_of "$out" broken_in_testimony)" = "1" ]; then
  check testimony_ratchets ok ok
else
  check testimony_ratchets ok "$(verdict_of "$out")/$(value_of "$out" broken_in_testimony)"
fi

# 4 -- testimony never gates, however much of it there is. Three dated files, three breaks apiece:
#      the count rises to nine and the verdict stays ok, because the LOST-reference duty belongs to
#      tools/d/dated_path_witness.rish and a second meter over one quantity is how two meters
#      come to disagree.
build
printf '# root\n[a](20260101-010101_a.md)\n[b](20260101-010102_b.md)\n[c](20260101-010103_c.md)\n' > README.md
for n in 1 2 3; do
  printf '# log\n[x](missing1.md)\n[y](missing2.md)\n[z](missing3.md)\n' > "2026010${n}-01010${n}_$(printf '%s' abc | cut -c${n}).md" 2>/dev/null || true
done
printf '# log\n[x](m1.md)\n[y](m2.md)\n[z](m3.md)\n' > 20260101-010101_a.md
printf '# log\n[x](m1.md)\n[y](m2.md)\n[z](m3.md)\n' > 20260101-010102_b.md
printf '# log\n[x](m1.md)\n[y](m2.md)\n[z](m3.md)\n' > 20260101-010103_c.md
out=$(sh "$SCAN" 2>&1)
if [ "$(verdict_of "$out")" = "ok" ] && [ "$(value_of "$out" broken_in_testimony)" = "9" ]; then
  check testimony_never_gates ok ok
else
  check testimony_never_gates ok "$(verdict_of "$out")/$(value_of "$out" broken_in_testimony)"
fi

# 5 -- a break in a document README never reaches is out of scope.
build
printf '# root\nnothing here\n' > README.md
printf '# orphan\n[gone](missing.md)\n' > orphan.md
out=$(sh "$SCAN" 2>&1); check unreached_free ok "$(verdict_of "$out")"

# 6 -- an http target is never followed and never counted.
build
printf '# root\n[out](https://example.invalid/nothing.md)\n' > README.md
out=$(sh "$SCAN" 2>&1)
if [ "$(verdict_of "$out")" = "ok" ] && [ "$(value_of "$out" broken_total)" = "0" ]; then
  check external_free ok ok
else
  check external_free ok "$(verdict_of "$out")/$(value_of "$out" broken_total)"
fi

# ---- the index store (REDS %524) --------------------------------------------------------------
#
# Each case below builds a real git repository in the pen, because the index is a git object and a
# stand-in for it would prove a shape git does not have.

git_pen() {
  build
  git init -q . 2>/dev/null
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
}

# 7 -- one clean tree, both stores, same reading. The store moves the bytes and nothing else.
git_pen
printf '# root\n[a](a.md)\n' > README.md
printf '# a\ndone\n' > a.md
git add -A >/dev/null 2>&1
w=$(sh "$SCAN" 2>&1)
i=$(sh "$SCAN" --store index 2>&1)
if [ "$(verdict_of "$w")" = ok ] && [ "$(verdict_of "$i")" = ok ] &&
   [ "$(value_of "$w" documents_reached)" = "$(value_of "$i" documents_reached)" ]; then
  check index_agrees ok ok
else
  check index_agrees ok "$(verdict_of "$w")/$(verdict_of "$i")"
fi

# 8 -- a break the index carries is refused by the index store.
git_pen
printf '# root\n[gone](missing.md)\n' > README.md
git add -A >/dev/null 2>&1
out=$(sh "$SCAN" --store index 2>&1)
check index_bitten living_link_broken "$(verdict_of "$out")"

# 9 -- the repair that stands only on disk. This is the live case that opened the round: the
#      worktree holds a repointed link and the index still holds the broken one, so the store is
#      the whole difference between "my tree is fine" and "this commit ships a broken promise."
git_pen
printf '# root\n[gone](missing.md)\n' > README.md
git add -A >/dev/null 2>&1
printf '# root\n[a](a.md)\n' > README.md
printf '# a\ndone\n' > a.md
w=$(sh "$SCAN" 2>&1)
i=$(sh "$SCAN" --store index 2>&1)
if [ "$(verdict_of "$w")" = ok ] && [ "$(verdict_of "$i")" = living_link_broken ]; then
  check index_ignores_disk ok ok
else
  check index_ignores_disk ok "worktree=$(verdict_of "$w") index=$(verdict_of "$i")"
fi

# 10 -- the mirror of case 9, and the false PASS a worktree reading would give: the target is
#       staged for deletion while disk still holds it.
git_pen
printf '# root\n[a](a.md)\n' > README.md
printf '# a\ndone\n' > a.md
git add -A >/dev/null 2>&1
git rm --cached -q a.md 2>/dev/null
w=$(sh "$SCAN" 2>&1)
i=$(sh "$SCAN" --store index 2>&1)
if [ "$(verdict_of "$w")" = ok ] && [ "$(verdict_of "$i")" = living_link_broken ]; then
  check index_sees_deletion ok ok
else
  check index_sees_deletion ok "worktree=$(verdict_of "$w") index=$(verdict_of "$i")"
fi

# 11 -- a link naming a directory. The index lists files alone, so a directory exists there only as
#       the prefix of something -- and a reader clicking `room/` still lands somewhere real.
git_pen
mkdir -p room
printf '# root\n[room](room)\n' > README.md
printf 'inside\n' > room/thing.md
git add -A >/dev/null 2>&1
out=$(sh "$SCAN" --store index 2>&1)
check index_dir_target ok "$(verdict_of "$out")"

# 12 -- outside a git repository the index store refuses by name. A wall that cannot measure says
#       so; falling back to disk would answer a question nobody asked.
build
printf '# root\n[a](a.md)\n' > README.md
printf '# a\ndone\n' > a.md
out=$(sh "$SCAN" --store index 2>&1)
case "$(verdict_of "$out")" in
  no_index|no_root) check index_needs_repo ok ok ;;
  *) check index_needs_repo ok "$(verdict_of "$out")" ;;
esac

# 13 -- an unknown store word refuses rather than quietly reading the default.
build
printf '# root\ndone\n' > README.md
out=$(sh "$SCAN" --store ledger 2>&1)
check store_unknown no_store "$(verdict_of "$out")"

cd "$ROOT" 2>/dev/null || cd /
if [ "$faults" -eq 0 ]; then echo "control=ok"; exit 0; fi
echo "control=faults faults=$faults"
exit 2
