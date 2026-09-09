#!/bin/sh
# tools/fixtures/t/tally_caller_map_scan.sh -- every mark that reaches Tally, and how.
#
# WHY THIS READING EXISTS. Zig admits an import only from the root file's own directory, so a room
# that wants `tally/copy.rye` keeps its own path to it. The canon prose -- tally/README.md section
# "Who calls Tally" -- states the rule in one line: callers reach marks through their own SYMLINKS
# or IMPORTS, not copies. This scan reads whether the tree still holds that.
#
# WHAT CHANGED, AND WHY IT IS A UNION RATHER THAN A SWAP (20260908.090000). The elder scan carried a
# hand-written list of 19 paths and tested each with `-e`. Two faults stood in that, and they pull
# in opposite directions, so both are repaired here and neither repair replaces the other:
#
#   REACH -- 19 of 69. Deriving the population from the index reads every tracked symlink whose
#   resolved target is a file under tally/: 69 paths on 20260908, against the 19 spelled by hand.
#   Six of them reach the canon through ANOTHER room's link (granary/parse_int.rye ->
#   ../linengrow/parse_int.rye -> tally/parse_int.rye), which a one-hop reading of the link text
#   misses entirely -- the chain is lawful and is counted rather than refused.
#
#   PREDICATE -- `-e` passes on the one thing the canon forbids. `-e` follows a symlink, so it
#   proves a link resolves; it also passes, silently, on a regular-file COPY standing where the
#   canon says a link belongs. The guard's stated subject was the one state it could not see.
#
# WHY THE HAND LIST STAYS. Derivation has its own blind spot, and it is the mirror of the hand
# list's: a mark whose link is RETARGETED out of tally/ simply leaves a derived population, and a
# reading that shrinks in silence is the fault this file exists to name. So the 19 named paths --
# the closed sample the canon table describes -- are checked BY NAME under the canon's own rule
# (a symlink, resolving to a real file under tally/), and the derived 69 are checked beside them.
# Union, never a trade: nothing the elder held is dropped, and 50 further marks are read.
#
# TABLE RECOVERY. The parked caller-map draft also checked each room named in
# tally/README.md against the derived callers. Keep that check beside the named
# sample: a table room without a tracked caller is stale_named, while a named
# link retargeted outside Tally still refuses as named_escaped_canon.
#
# WHAT THIS DOES NOT READ, named so the split between guards stays single-stranded:
#   a COPY standing where siblings link -- tools/fixtures/c/copy_lag_scan.sh owns that, deriving
#     each canon by resolving its own symlinks, and telling a lagging copy from a lawful sibling
#     module that merely shares a word. A copy cannot be seen by listing links, by construction.
#   tally_copy.rye against the canon's bytes -- tools/fixtures/c/copy_sameness_scan.sh owns that.
#   whether a mark is IMPORTED and therefore load-bearing -- the compiler owns that. Every mark
#     basename here is imported (measured 20260908: tally_copy 217 files, kumara 228, parse_int
#     117), so a break also fails `rye build` for its room; that is a second reading of the same
#     fact rather than a reason to drop this one, since a room's build is not on every clock.
#
# BOUNDS. max_marks 1024, far above the measured 69, and it refuses rather than truncates -- a
# silently short reading is exactly the fault the hand list was already making. max_hops 8 bounds
# the symlink walk, so a link loop answers unresolvable rather than spinning; the deepest chain the
# tree holds is 2.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# USAGE
#   sh tools/fixtures/t/tally_caller_map_scan.sh [named-sample-file]
# Driven by tools/t/tally_caller_map_witness.rish. Run from anywhere; it finds its own root.
#
# The optional argument names a file of paths to use as the named sample INSTEAD of the built-in
# 19. It exists for one reason: a sample spelled inside a script cannot be exercised in a pen, so
# every refusal the named half can make would be provable only by breaking the real tree. The
# control passes its own pen sample here; ordinary runs pass nothing and read the canon's own.
set -u

# Root by upward walk (seated 20260828): the letter fold moved this script one directory deeper,
# and fixed ../.. depth arithmetic is what broke. The walk finds the first ancestor holding
# rishi/bin and tools/fixtures -- git-free so pen copies outside a repository still resolve --
# bounded at 8 steps, loud past the bound.
#
# THE WALK STARTS AT THE CURRENT DIRECTORY, then falls back to the script's own (20260908). A walk
# from $0 alone resolves the tree the SCRIPT lives in, which is the real tree even when the caller
# has cd'd into a pen -- so every pen leg silently measured this tree instead of its plant, and the
# control read `no` on all of them while claiming to have proven the guard.
walk_up() {
  _wu=$1
  _wu_steps=0
  while [ ! -d "$_wu/rishi/bin" ] || [ ! -d "$_wu/tools/fixtures" ]; do
    _wu_steps=$((_wu_steps + 1))
    if [ "$_wu_steps" -gt 8 ] || [ "$_wu" = "/" ] || [ -z "$_wu" ]; then
      return 1
    fi
    _wu=$(dirname "$_wu")
  done
  printf '%s\n' "$_wu"
}

ROOT=$(walk_up "$(pwd -P)") || ROOT=$(walk_up "$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)") || {
  echo "$0: no tree root within 8 steps of the working directory or the script (needs rishi/bin and tools/fixtures)" >&2
  exit 2
}
cd "$ROOT" || exit 2
root=$(pwd -P)

max_marks=1024
max_hops=8

# Resolve a path through its symlink chain, bounded, in a spelling every pier accepts.
#
# `readlink -f` would say this in one call and is a GNU extension the tree already carries as an
# ADVISORY ratchet -- BSD readlink, which is what the Mac door ships, gained `-f` only recently, and
# a resolver that returns empty on the second pier would read as a tree holding no marks at all: a
# zero nobody planted looks exactly like a healthy tree (REDS %240). So the walk is spelled with
# bare `readlink` plus cd/pwd -P, which is what tools/fixtures/c/copy_lag_scan.sh already uses one
# room over. Bounded at max_hops, and a chain past the bound answers empty rather than looping.
# Echoes the resolved absolute path, or nothing when the chain leaves the filesystem or runs long.
resolve_link() {
  _rl=$1
  _rl_hops=0
  while [ -L "$_rl" ]; do
    _rl_hops=$((_rl_hops + 1))
    [ "$_rl_hops" -le "$max_hops" ] || return 1
    _rl_t=$(readlink "$_rl") || return 1
    case "$_rl_t" in
      /*) _rl=$_rl_t ;;
      *)  _rl=$(CDPATH= cd -- "$(dirname "$_rl")" 2>/dev/null && CDPATH= cd -- "$(dirname "$_rl_t")" 2>/dev/null && printf '%s/%s' "$(pwd -P)" "$(basename "$_rl_t")") || return 1 ;;
    esac
    [ -n "$_rl" ] || return 1
  done
  # A final component that is not itself a link still needs its directory made absolute, so a
  # dangling target reads as a real path under tally/ rather than dropping out of the population.
  _rl_d=$(CDPATH= cd -- "$(dirname "$_rl")" 2>/dev/null && pwd -P) || return 1
  printf '%s/%s\n' "$_rl_d" "$(basename "$_rl")"
}

# The closed sample the canon table describes. Kept BY NAME so a retarget out of tally/ reds here
# rather than dropping out of the derived population in silence.
named_marks="
caravan/tally_copy.rye
caravan/parse_int.rye
mantra/tally_copy.rye
mantra/parse_int.rye
comlink/tally_copy.rye
comlink/parse_int.rye
amphora/tally_copy.rye
amphora/kumara.rye
granary/tally_copy.rye
granary/parse_int.rye
linengrow/tally_copy.rye
linengrow/parse_int.rye
linengrow/kumara.rye
glow/tally_copy.rye
brushstroke/tally_copy.rye
rishi/src/tally_copy.rye
rishi/src/parse_int.rye
mandi/tally_copy.rye
tools/rye/kumara.rye
"

sample_file="${1:-}"
if [ -n "$sample_file" ]; then
  if [ ! -f "$sample_file" ]; then
    echo "detail: named sample file $sample_file does not exist"
    echo "verdict=no_sample_file"
    exit 2
  fi
  named_marks=$(cat "$sample_file")
fi

if [ ! -d "$root/tally" ]; then
  echo "marks=0"
  echo "detail: no tally/ room at $root"
  echo "verdict=no_canon_room"
  exit 2
fi

# The named sample, under the canon's own rule: a symlink, resolving to a real file under tally/.
named=0
named_missing=0
named_not_link=0
named_escaped=0
for p in $named_marks; do
  named=$((named + 1))
  if [ ! -L "$p" ]; then
    if [ -e "$p" ]; then
      echo "detail: named $p is a regular file where the canon says symlink or import"
      named_not_link=$((named_not_link + 1))
    else
      echo "detail: named $p is absent"
      named_missing=$((named_missing + 1))
    fi
    continue
  fi
  r=$(resolve_link "$p") || r=""
  case "$r" in
    "$root"/tally/*)
      if [ ! -f "$r" ]; then
        echo "detail: named $p resolves to $r, which is not a file"
        named_missing=$((named_missing + 1))
      fi
      ;;
    *)
      echo "detail: named $p resolves outside tally/ -- ${r:-unresolvable}"
      named_escaped=$((named_escaped + 1))
      ;;
  esac
done

# The derived population: every tracked symlink whose resolved target is a file under tally/.
# `git ls-files -s` reads the INDEX, so an unstaged working-tree link is deliberately unread --
# this guard measures the tree a commit would ship.
links=$(git ls-files -s 2>/dev/null | awk '$1=="120000"{ $1=""; $2=""; $3=""; sub(/^   /,""); print }')

marks=0
chained=0
dangling=0
caller_rooms=""
# A tracked symlink whose chain loops or runs past max_hops resolves to nothing, and nothing is
# indistinguishable here from a link pointing somewhere other than tally/ -- so it would leave the
# population in the silence this file exists to name. It is counted and named across ALL tracked
# links, and REPORTED rather than gated: a loop in a room that never calls Tally is a real fault and
# somebody else's lane, and a gate that reds on a neighbour's tree is a gate somebody turns off.
# The named half needs no such care -- an unresolvable named mark already refuses as named_escaped.
unresolvable=0
for p in $links; do
  [ -n "$p" ] || continue
  if ! r=$(resolve_link "$p"); then
    echo "detail: unresolvable $p -> $(readlink "$p") (loop, or a chain past max_hops $max_hops)"
    unresolvable=$((unresolvable + 1))
    continue
  fi
  case "$r" in
    "$root"/tally/*) ;;
    *) continue ;;
  esac
  marks=$((marks + 1))
  if [ "$marks" -gt "$max_marks" ]; then
    echo "marks=$marks"
    echo "detail: marks past max_marks $max_marks"
    echo "verdict=marks_over_bound"
    exit 2
  fi
  if [ ! -f "$r" ]; then
    echo "detail: dangling $p -> $(readlink "$p")"
    dangling=$((dangling + 1))
    continue
  fi
  caller_rooms="$caller_rooms
${p%%/*}"
  # A chain is a mark reaching the canon through another room's link. Lawful, and counted so the
  # shape stays visible: six stood on 20260908, all of them parse_int.rye through linengrow's.
  t=$(readlink "$p")
  d=$(dirname "$p")
  hop=$(CDPATH= cd -- "$d" 2>/dev/null && CDPATH= cd -- "$(dirname "$t")" 2>/dev/null && printf '%s/%s' "$(pwd -P)" "$(basename "$t")")
  if [ -n "$hop" ] && [ -L "$hop" ]; then
    echo "detail: chain $p -> $t -> ${r#$root/}"
    chained=$((chained + 1))
  fi
done

# The prose binding, which is this guard's own seat and is read by nothing else in the tree.
prose_tally=0
prose_saga=0
grep -Fq '## Who calls Tally' tally/README.md 2>/dev/null || prose_tally=1
grep -Fq 'Canon caller map' saga/README.md 2>/dev/null || prose_saga=1
[ "$prose_tally" -eq 0 ] || echo "detail: tally/README.md has lost its Who calls Tally section"
[ "$prose_saga" -eq 0 ] || echo "detail: saga/README.md no longer points at the canon caller map"

# Read the caller column in this section. File paths name their first room;
# repeated cells name one room. The population bound also caps unique table rooms,
# because more claimed rooms than possible callers cannot form a valid map.
table_rooms=""
if [ "$prose_tally" -eq 0 ]; then
  table_rooms=$(awk -F '[|]' -v limit="$max_marks" '
    /^## Who calls Tally/ { inside=1; next }
    inside && /^## / { exit }
    inside && /^\|/ {
      line=$2
      while (match(line, /`[A-Za-z0-9_.\/*-]+`/)) {
        path=substr(line, RSTART+1, RLENGTH-2)
        line=substr(line, RSTART+RLENGTH)
        if (index(path, "/") == 0) continue
        sub(/\/.*/, "", path)
        if (path == "" || path == "." || path == ".." || seen[path]) continue
        seen[path]=1
        count++
        if (count > limit) exit 2
        print path
      }
    }
  ' tally/README.md) || {
    echo "detail: caller table unreadable or past max_marks $max_marks unique rooms"
    echo "verdict=table_rooms_unreadable"
    exit 2
  }
fi
rooms_named=0
stale_named=0
for room in $table_rooms; do
  rooms_named=$((rooms_named + 1))
  if ! printf '%s\n' "$caller_rooms" | grep -Fxq "$room"; then
    stale_named=$((stale_named + 1))
    echo "detail: stale table room $room -- no tracked link into tally/"
  fi
done

echo "marks=$marks"
echo "named=$named"
echo "named_missing=$named_missing"
echo "named_not_link=$named_not_link"
echo "named_escaped=$named_escaped"
echo "chained=$chained"
echo "dangling=$dangling"
echo "unresolvable=$unresolvable"
echo "prose_tally_missing=$prose_tally"
echo "prose_saga_missing=$prose_saga"
echo "rooms_named=$rooms_named"
echo "stale_named=$stale_named"

# ORDER MATTERS, and the pen taught it (20260908). An empty derived population is the GENERIC
# reading and the named faults are the specific ones -- and each named fault empties the derived
# population as a side effect, since a copy, an absent path, and a retargeted link are all things
# a list of symlinks-into-tally cannot see. Refusing on `no_marks_found` first therefore answered
# every named refusal with the least useful of the two sentences. The specific verdicts come first;
# `no_marks_found` keeps its seat for the one case it alone reads -- the derivation itself broken,
# with the named sample intact.
if [ "$dangling" -gt 0 ]; then
  echo "verdict=dangling_mark"
  exit 1
fi
if [ "$named_missing" -gt 0 ]; then
  echo "verdict=named_missing"
  exit 1
fi
if [ "$named_not_link" -gt 0 ]; then
  echo "verdict=named_is_copy"
  exit 1
fi
if [ "$named_escaped" -gt 0 ]; then
  echo "verdict=named_escaped_canon"
  exit 1
fi
if [ "$prose_tally" -ne 0 ] || [ "$prose_saga" -ne 0 ]; then
  echo "verdict=prose_binding_lost"
  exit 1
fi
if [ "$marks" -eq 0 ]; then
  echo "verdict=no_marks_found"
  exit 2
fi
if [ "$stale_named" -gt 0 ]; then
  echo "verdict=stale_named"
  exit 1
fi
echo "verdict=ok"
exit 0
