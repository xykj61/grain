#!/bin/sh
# tools/fixtures/w/witness_own_build_scan.sh -- a witness builds what it runs, or it proves nothing
# on a clone.
#
# WHY. comlink/bin/ is gitignored (.gitignore:185), so a fresh clone carries no Comlink binary at
# all. tools/co/comlink_handshake_turn_witness.rish and tools/co/comlink_turn_route_witness.rish
# each named their build in a HEADER COMMENT -- "Build first:  rye build ..." -- and then invoked
# the path directly with `run ["comlink/bin/handshake-turn" "selftest"]`. A comment builds nothing.
# On this pier both passed, because a lap in August left binaries behind; on a clone both died on a
# missing file rather than on a handshake fact.
#
# Their sibling tools/co/comlink_topology_witness.rish already carries the repair, and its own
# comment records the same discovery in this tree's words: "on any clone without that build it died
# with a bare CommandFailed naming no cause -- a refusal a reader cannot act on is the fault this
# tree calls a guard that guards nothing." One of three was repaired; the other two were left, and
# nothing counted them. This is the meter that counts them.
#
# WHAT IS READ. Every tracked *_witness.rish, for paths in DIRECT invocation position -- the first
# quoted element of a `run [ ... ]` array, on a non-comment line. For each such path that GIT ITSELF
# ignores, the witness is asked whether it also carries a build naming that artifact on a
# non-comment line of its own.
#
#   witnesses            every tracked *_witness.rish on disk
#   invoked_ignored      (witness, artifact) pairs where the artifact is a path git ignores
#   self_built           of those, the pairs whose witness builds the artifact itself
#   unbuilt_pairs        the rest. THIS IS THE RATCHETED NUMBER, under a ceiling that only falls
#   unbuilt_witnesses    distinct witnesses in the unbuilt set, reported
#   absent_now           unbuilt artifacts missing from THIS filesystem right now, reported and
#                        never gated: it is a fact about one machine, and a machine that has been
#                        building for weeks reads lower than a clone. Gating it would make the
#                        guard answer differently on two honest trees.
#   built_elsewhere      unbuilt artifacts some OTHER tracked file builds, reported. A build kept
#                        by a caller is real, and it is still not the promise a witness makes: every
#                        one of these headers tells a reader to run the witness directly.
#
# WHAT PASSES FREE, by named rule.
#   rishi/bin/rishi and rye/bin/rye -- the interpreter running the witness and the compiler that
#     builds everything else. If either is absent nothing runs at all, so their presence is a
#     bootstrap fact (SOURCE.md) rather than a promise any single witness makes.
#   vendor/** -- submodules and the toolchain, provisioned by `git submodule update` and the
#     toolchain fetch. The same rule tools/fixtures/p/phantom_path_scan.sh keeps, for the same reason.
#   A path the repository TRACKS. The clone carries it, so nobody has to build it.
#   COMMENT lines, on both sides. A comment naming a build is documentation, and the gap between
#     documentation and a build is exactly the defect this scan reads.
#
# THE HONEST LIMIT. Only a DIRECT invocation is read -- `run ["path" ...]`. A binary reached through
# `run ["sh" "-c" "... path ..."]` is invisible here, and so is one a suite builds before calling
# this witness. Both are named rather than guessed: `built_elsewhere` reports the second, and the
# first is left to the reader. A narrow reading that is exactly right beats a wide one that argues.
#
# USAGE
#   sh tools/fixtures/w/witness_own_build_scan.sh
#   sh tools/fixtures/w/witness_own_build_scan.sh --list    # the unbuilt pairs, one per line
#
# Driven by tools/w/witness_own_build_witness.rish. Run from the repository root.

set -eu

# WHY THIS NUMBER. 46 is the reading on 20260828 after the two Comlink witnesses took the build
# their sibling already carried, down from 48. It only ever falls: a witness repaired lowers it,
# and a new witness invoking an unbuilt artifact raises it past the ceiling on the lap it arrives.
CEILING=46

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

git ls-files > "$pen/tracked"
grep -E '_witness\.rish$' "$pen/tracked" > "$pen/wits" || : > "$pen/wits"
witnesses=$(wc -l < "$pen/wits" | tr -d ' ')
grep -E '^tools/.*\.(rish|sh)$' "$pen/tracked" > "$pen/runners" || : > "$pen/runners"

# The first quoted element of each `run [ ... ]`, on a non-comment line, when it looks like a path.
# One awk over the whole population: 1,729 interpreter starts cost more than the reading does.
: > "$pen/pairs"
if [ -s "$pen/wits" ]; then
  xargs awk '
    FNR == 1 { F = FILENAME }
    /^[[:space:]]*#/ { next }
    {
      s = $0
      while (match(s, /run[[:space:]]*\[[[:space:]]*"[^"]+"/)) {
        seg = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        if (match(seg, /"[^"]+"/)) {
          t = substr(seg, RSTART + 1, RLENGTH - 2)
          sub(/^\.\//, "", t)
          if (t ~ /\//) print F "\t" t
        }
      }
    }' < "$pen/wits" | sort -u > "$pen/pairs"
fi

# Ask git which artifacts it ignores, in one batch rather than one call per token.
cut -f2 "$pen/pairs" | sort -u > "$pen/toks"
git check-ignore --stdin < "$pen/toks" > "$pen/ignored" 2>/dev/null || :

# A READING OF ZERO IS A BROKEN READING, not a clean tree. This scan printed verdict=ok over an
# empty extraction on 20260828, because `xargs -a` is a GNU flag and this bench carries a BSD
# xargs: the pipeline died, every count read 0, and the guard passed. A guard reading nothing
# passes as readily as a guard reading everything, so the empty case refuses instead.
path_tokens=$(wc -l < "$pen/toks" | tr -d ' ')
if [ "$witnesses" -gt 0 ] && [ "$path_tokens" -eq 0 ]; then
  echo "verdict=extraction_empty"
  echo "refused: $witnesses witnesses and not one invoked path -- the reading is broken" >&2
  exit 1
fi

: > "$pen/invoked"
while IFS="$(printf '\t')" read -r w tok; do
  [ -n "${tok:-}" ] || continue
  case "$tok" in
    rishi/bin/rishi|rye/bin/rye) continue ;;
    vendor/*) continue ;;
  esac
  grep -qxF -- "$tok" "$pen/tracked" && continue
  grep -qxF -- "$tok" "$pen/ignored" || continue
  printf '%s\t%s\n' "$w" "$tok" >> "$pen/invoked"
done < "$pen/pairs"
invoked=$(sort -u "$pen/invoked" | wc -l | tr -d ' ')

: > "$pen/unbuilt"; : > "$pen/self"
while IFS="$(printf '\t')" read -r w tok; do
  [ -n "${tok:-}" ] || continue
  grep -v '^[[:space:]]*#' "$w" | grep -E "(rye build|zig build|emit-bin)" > "$pen/bl" 2>/dev/null || : > "$pen/bl"
  if grep -qF -- "$(basename "$tok")" "$pen/bl"; then
    printf '%s\t%s\n' "$w" "$tok" >> "$pen/self"
  else
    printf '%s\t%s\n' "$w" "$tok" >> "$pen/unbuilt"
  fi
done < "$pen/invoked"

sort -u "$pen/unbuilt" > "$pen/unbuilt.s"; mv "$pen/unbuilt.s" "$pen/unbuilt"
self_built=$(sort -u "$pen/self" | wc -l | tr -d ' ')
unbuilt=$(wc -l < "$pen/unbuilt" | tr -d ' ')
unbuilt_witnesses=$(cut -f1 "$pen/unbuilt" | sort -u | wc -l | tr -d ' ')

absent=0
cut -f2 "$pen/unbuilt" | sort -u > "$pen/targets"
while IFS= read -r t; do
  [ -n "$t" ] || continue
  [ -e "$t" ] || absent=$((absent + 1))
done < "$pen/targets"

# built_elsewhere: some OTHER tracked runner carries a build for this artifact. Real, and still not
# the promise the witness itself makes -- reported so the number is visible rather than argued.
# Every build line in the tree is collected once; asking per target would be a grep per pair.
elsewhere=0
xargs grep -hv '^[[:space:]]*#' < "$pen/runners" 2>/dev/null \
  | grep -E "(rye build|zig build|emit-bin)" > "$pen/buildlines" 2>/dev/null || : > "$pen/buildlines"
while IFS= read -r t; do
  [ -n "$t" ] || continue
  grep -qF -- "$(basename "$t")" "$pen/buildlines" && elsewhere=$((elsewhere + 1))
done < "$pen/targets"

if [ "${1:-}" = "--list" ]; then cat "$pen/unbuilt"; fi

echo "witnesses=$witnesses"
echo "invoked_ignored=$invoked"
echo "self_built=$self_built"
echo "unbuilt_pairs=$unbuilt ceiling=$CEILING"
echo "unbuilt_witnesses=$unbuilt_witnesses"
echo "absent_now=$absent"
echo "built_elsewhere=$elsewhere"
if [ "$unbuilt" -le "$CEILING" ]; then
  echo "verdict=ok"
else
  echo "verdict=witness_without_build"
  exit 1
fi
