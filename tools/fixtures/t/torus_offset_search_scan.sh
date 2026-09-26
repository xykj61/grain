#!/bin/sh
# tools/fixtures/t/torus_offset_search_scan.sh -- does a SEARCH over offsets beat the two
# hand-picked ones round one already measured? Round two's proposal 1
# (active-designing/20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md)
# asked this in so many words: torus_place_scan.sh's reading 3 compared exactly two members of
# ONE family -- five copies at offsets {d, -d, 2d, -2d} mod C -- d=1 (ring4adj, measured
# run-kill 5) and d=g (ring4wide, measured run-kill 33) -- and never asked whether some OTHER d
# in that same family does better than either hand-picked point.
#
# WHY THIS FAMILY RATHER THAN A FULLY GENERIC ONE. Round one's own two points already share this
# shape (five copies: the cell itself plus +-d and +-2d), so sweeping d is the smallest change
# that answers the question actually asked -- "some choices of k offsets beat others" -- without
# opening a second free parameter (an arbitrary four-offset set) that round one's own reading
# never measured a baseline for. A generic four-offset search is a different, larger question
# and is named as future work rather than answered here.
#
# THE ARITHMETIC BOUND ON WHAT A SEARCH CAN FIND. Five points on a ring of C cells (the cell
# itself plus four offsets) can split the ring into at most five gaps; the run-kill length is
# C minus the widest gap plus one, so it is maximized when the gaps are as even as possible --
# each near C/5. The theoretical ceiling is therefore near C - ceil(C/5) + 1, named here so a
# reading close to it is read as "found the ceiling" rather than treated as an open question.
#
# WHAT THIS DOES. For grid g (cells C = g*g), sweeps d from 1 to floor(C/2) -- every d that can
# give a distinct offset from its own negation -- computing run_kill(d) with the SAME
# shortest-circular-run algorithm torus_place_scan.sh already uses, read at cell 0 alone. A
# circulant offset set (every offset applied to every cell by the same modular shift) gives the
# identical span at every cell by translation symmetry, so reading cell 0 is the whole
# population rather than a sample -- named here so the search is honest about NOT re-checking
# every cell the way the elder scan's reading 3 does.
#
# WHAT WOULD FALSIFY THE READING. The best d found reads at or below 33 (round one's ring4wide),
# which would mean the two hand-picked points already stood at the family's own maximum by
# chance. The two known points (d=1, d=g) must reproduce their elder closed forms (5 and 4g+1)
# under this scan's own algorithm, or the two scans disagree about one arithmetic fact and
# neither reading can be trusted until that disagreement is resolved.
#
# WHAT THIS DOES NOT READ. Any real store. A fully generic (non-circulant) four-offset search,
# named above as open. Whether five copies is the right replica count for this tree's own store
# -- that is round one's own assumption, carried forward unchanged.
#
# USAGE
#   sh tools/fixtures/t/torus_offset_search_scan.sh                # grid 8, round one's own g
#   sh tools/fixtures/t/torus_offset_search_scan.sh --grid G       # cells per axis
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

GRID="${TORUS_OFFSET_GRID:-8}"      # reproduces round one's own reading 3 population, g=8, cells=64
MAX_CELLS=65536                     # bounded: g*g must stay under this or the sweep is refused

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/src" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

while [ $# -gt 0 ]; do
  case "$1" in
    --grid) GRID="${2:?--grid wants a count}"; shift 2 ;;
    *) echo "$0: unknown flag $1" >&2; exit 2 ;;
  esac
done

echo "instrument=torus_offset_search"
echo "grid=$GRID"

CELLS=$((GRID * GRID))
echo "cells=$CELLS"
if [ "$CELLS" -lt 5 ] || [ "$CELLS" -gt "$MAX_CELLS" ]; then
  echo "detail: cells=$CELLS out of the bounded range [5, $MAX_CELLS]"
  echo "verdict=unreadable"
  exit 0
fi

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

awk -v cells="$CELLS" -v g="$GRID" '
  # The shortest circular run covering all five copies of cell 0 under offset d: the five points
  # are {0, d, cells-d, 2d mod cells, cells-(2d mod cells)} mod cells, deduplicated; the run-kill
  # length is cells minus the widest gap between consecutive sorted points, plus one. A d whose
  # offsets alias into fewer than five distinct copies is not comparable and reads -1.
  function run_kill(d,    n, i, j, key, v, widest, gap, span, seen, o) {
    n = 0
    delete seen
    o = 0;                             if (!(o in seen)) { seen[o]=1; v[n++]=o }
    o = d % cells;                     if (!(o in seen)) { seen[o]=1; v[n++]=o }
    o = (cells - d % cells) % cells;   if (!(o in seen)) { seen[o]=1; v[n++]=o }
    o = (2 * d) % cells;               if (!(o in seen)) { seen[o]=1; v[n++]=o }
    o = (cells - (2 * d) % cells) % cells; if (!(o in seen)) { seen[o]=1; v[n++]=o }
    if (n < 5) return -1
    for (i = 1; i < n; i++) { key = v[i]; j = i - 1; while (j >= 0 && v[j] > key) { v[j+1]=v[j]; j-- } v[j+1]=key }
    widest = v[0] + cells - v[n-1]
    for (i = 1; i < n; i++) { gap = v[i] - v[i-1]; if (gap > widest) widest = gap }
    span = cells - widest + 1
    return span
  }
  BEGIN {
    best = -1; best_d = -1
    max_d = int(cells / 2)
    for (d = 1; d <= max_d; d++) {
      s = run_kill(d)
      if (s > best) { best = s; best_d = d }
    }
    d1 = run_kill(1)
    dg = run_kill(g)
    printf "swept_d_from=1\n"
    printf "swept_d_to=%d\n", max_d
    printf "best_d=%d\n", best_d
    printf "best_run_kill=%d\n", best
    printf "d1_run_kill=%d\n", d1
    printf "dg_run_kill=%d\n", dg
    printf "d1_closed_form_5=%s\n", (d1 == 5 ? "match" : "mismatch")
    printf "dg_closed_form_4g1=%s\n", (dg == 4 * g + 1 ? "match" : "mismatch")
    ceil5 = int((cells + 4) / 5)
    printf "theoretical_ceiling=%d\n", cells - ceil5 + 1
  }
' > "$PEN/out"

cat "$PEN/out"

# --- the verdict --------------------------------------------------------------------------------
# GATED: the instrument's own arithmetic (both elder closed forms reproduce, best is never below
# the two known points). WHETHER THE BEST BEATS 33 is reported rather than gated, since round
# one's own number is a fact about this one family's geometry that no lap can repair by trying
# harder -- the falsifier lives in the reading, not in a pass/fail bit.
read_field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$PEN/out"; }

closed_ok=yes
[ "$(read_field d1_closed_form_5)" = match ] || closed_ok=no
[ "$(read_field dg_closed_form_4g1)" = match ] || closed_ok=no
echo "closed_forms_hold=$closed_ok"

best=$(read_field best_run_kill)
dg=$(read_field dg_run_kill)
if [ "$best" -ge "$dg" ]; then
  monotone_ok=yes
else
  monotone_ok=no
fi
echo "search_at_least_matches_elder=$monotone_ok"

if [ "$best" -gt 33 ]; then
  echo "search_beats_round_one=yes"
else
  echo "search_beats_round_one=no"
fi

if [ "$closed_ok" = yes ] && [ "$monotone_ok" = yes ]; then
  echo "verdict=ok"
else
  echo "verdict=refused"
fi
