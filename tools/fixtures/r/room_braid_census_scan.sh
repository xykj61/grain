#!/bin/sh
# tools/fixtures/r/room_braid_census_scan.sh -- which rooms stand free, and which are braided.
#
# WHY. `foundations/20260823-204456_single-stranded.md` makes this tree's central architectural
# claim: each module is about one thing, and "you can check it by trying to pull one part out."
# That is a tactile test the air row's threshold page repeats -- pull gently, and if other things
# move with it the strand was a braid. The claim stood in a foundation for eighteen days, was read
# on every air lap, and no instrument in the tree had ever performed the pull. This performs it.
#
# THE CHANNEL, and why a grep for `@import` cannot see it. Zig refuses an import that escapes the
# root file's directory, so a Rye module reaches another room's code by a SYMLINK carrying the
# target's basename into its own directory. Measured on the seating lap: 296 tracked cross-room
# symlinks, and exactly ONE relative escaping `@import` in the whole tree
# (`tools/rye/enrich/blocks_audit.rye`), which stays inside its own room. There is no root
# `build.zig` adding a second channel. So the symlink set IS the cross-room dependency graph, whole.
#
# WHAT IT READS, in four steps.
#   1. Every tracked symlink whose basename ends `.rye`, resolved to the room it points into.
#   2. Cross-room edges only -- a link inside one room is filing, never a dependency.
#   3. IMPORTED edges only. A symlink nobody names in an `@import` is dead weight, and counting it
#      would publish a dependency that does not exist. The grep follows symlinks (`grep -R`),
#      because a link imported only by another link is still a live edge; reading it without -R
#      called 70 links dead where 20 are.
#   4. The cyclic components. A room in a cycle CANNOT be lifted out alone: pull it and every other
#      room of its component comes along. That is the braid, and its size is what this gates.
#
# WHAT IT DOES NOT SAY, named rather than implied.
#   - That a braid is a defect. `pond/` composes the whole tree on purpose and its outward reach is
#     its job. What the reading publishes is that something reaches BACK into it, which is the part
#     no design intended.
#   - That an edge is expensive. The gate counts edges; a single symlink may carry sixty-two
#     importers behind it. Cost is a hand's reading, never this one's.
#   - Anything about a language but Rye. `.rye` is where the claim was made and where the symlink
#     channel exists.
#
# THE GATE. `braid_max` -- the largest cyclic component -- under a ceiling that only falls, so a
# room joining the braid reds on the lap it arrives and a repair is rewarded. `braid_rooms` and
# `edges_dead` report beside it.

set -eu
# The root is the repository the scan is RUN IN, never the one this file happens to live in. A
# root resolved from `$0` reads the real tree from inside a throwaway pen, so every control leg
# would measure this tree and two of them would "pass" by matching its refusal -- which is what
# the first draft did, and what proving both directions caught.
root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "detail: not inside a git repository -- the census reads tracked symlinks"
  echo "verdict=no_repo"; exit 1
}
cd "$root"

ceiling=${ROOM_BRAID_MAX:-9}

edges=$(mktemp); dead=$(mktemp); tmp=$(mktemp)
trap 'rm -f "$edges" "$dead" "$tmp"' EXIT INT TERM

n_links=0; n_cross=0; n_dead=0
git ls-files -s | awk '$1=="120000"{print $4}' | while IFS= read -r p; do
  case "$p" in *.rye) ;; *) continue ;; esac
  printf '%s\n' "$p"
done > "$tmp"

while IFS= read -r p; do
  n_links=$((n_links + 1))
  d=$(dirname "$p"); b=$(basename "$p")
  t=$(git cat-file -p "$(git rev-parse ":$p")" 2>/dev/null) || continue
  abs=$(cd "$d" 2>/dev/null && readlink -m "$t") || continue
  case "$abs" in "$root"/*) rel=${abs#"$root"/} ;; *) continue ;; esac
  src=${p%%/*}; dst=${rel%%/*}
  [ "$src" = "$dst" ] && continue
  [ -d "$src" ] && [ -d "$dst" ] || continue
  n_cross=$((n_cross + 1))
  if grep -qRF "@import(\"$b\")" "$d" --include=*.rye 2>/dev/null; then
    printf '%s %s\n' "$src" "$dst" >> "$edges"
  else
    n_dead=$((n_dead + 1))
    printf '%s %s->%s\n' "$p" "$src" "$dst" >> "$dead"
  fi
  printf 'links=%s cross=%s dead=%s\n' "$n_links" "$n_cross" "$n_dead" > "$tmp.counts"
done < "$tmp"

# The while loop above runs in this shell, yet the counts are re-read from the side file so the
# reading survives a future refactor that pipes into it -- a subshell would drop them silently.
if [ -f "$tmp.counts" ]; then
  # shellcheck disable=SC2046
  set -- $(cat "$tmp.counts"); n_links=${1#links=}; n_cross=${2#cross=}; n_dead=${3#dead=}
  rm -f "$tmp.counts"
fi

sort -u "$edges" -o "$edges"
n_edges=$(wc -l < "$edges" | tr -d ' ')

if [ "$n_cross" -eq 0 ]; then
  echo "links=$n_links cross=0"
  echo "detail: no cross-room symlink was read -- an empty corpus cannot find a braid"
  echo "verdict=empty_corpus"
  exit 1
fi

# Transitive closure by relaxation, then a room is CYCLIC when it reaches itself. The graph holds
# tens of nodes, so the cubic closure is free and needs no Tarjan; two rooms sit in one component
# exactly when each reaches the other.
awk -v ceiling="$ceiling" -v dead="$n_dead" -v edges="$n_edges" -v cross="$n_cross" -v links="$n_links" '
  { e[$1 SUBSEP $2] = 1; node[$1] = 1; node[$2] = 1 }
  END {
    changed = 1
    while (changed) {
      changed = 0
      for (a in node) for (b in node) {
        if (!( (a SUBSEP b) in e )) continue
        for (c in node) if ((b SUBSEP c) in e && !((a SUBSEP c) in e)) { e[a SUBSEP c] = 1; changed = 1 }
      }
    }
    nrooms = 0; nbraid = 0; maxc = 0
    for (a in node) {
      nrooms++
      if ((a SUBSEP a) in e) { nbraid++; cyc[a] = 1 }
      if (!((a SUBSEP a) in e)) { out = 0; for (b in node) if ((a SUBSEP b) in e) out++; if (out == 0) sinks++ }
    }
    for (a in cyc) {
      if (seen[a]) continue
      size = 0; members = ""
      for (b in cyc) if ((a SUBSEP b) in e && (b SUBSEP a) in e) { seen[b] = 1; size++; members = members " " b }
      if (size > maxc) { maxc = size; biggest = members }
      printf "component size=%d rooms:%s\n", size, members
    }
    printf "links=%d cross=%d edges_live=%d edges_dead=%d\n", links, cross, edges, dead
    printf "rooms=%d rooms_free=%d rooms_braided=%d sinks=%d\n", nrooms, nrooms - nbraid, nbraid, sinks
    printf "braid_max=%d ceiling=%d\n", maxc, ceiling
    if (maxc > ceiling) {
      printf "detail: the largest braid is%s -- pull any one and the rest come with it\n", biggest
      print "verdict=braid_over_ceiling"; exit 1
    }
    print "verdict=under_ceiling"
  }
' "$edges" || exit 1

if [ "$n_dead" -gt 0 ]; then
  echo "detail: $n_dead cross-room symlinks are imported by nothing -- read but never counted as edges"
  head -5 "$dead" | while IFS= read -r l; do echo "dead: $l"; done
fi
exit 0
