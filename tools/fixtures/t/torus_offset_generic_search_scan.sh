#!/bin/sh
# tools/fixtures/t/torus_offset_generic_search_scan.sh -- does a FULLY GENERIC four-offset set
# beat the {d,-d,2d,-2d} family's own ceiling? tools/fixtures/t/torus_offset_search_scan.sh swept
# one free parameter inside a symmetric shape and found d=13 reaches the theoretical ceiling for
# five evenly-split points on a 64-cell ring (52 = 64 - ceil(64/5) + 1). Its own write-up
# (active-designing/20260918-005400_the-search-found-the-ceiling.md) named the open door in so
# many words: "the arithmetic bound above ... hints the generic search would land at the same
# ceiling by a different route, which stays a conjecture until it is run." This scan runs it.
#
# WHAT "GENERIC" MEANS HERE. The elder search held two offsets as forced negatives of the other
# two (+-d, +-2d) -- a symmetric shape inherited from the torus/ring axis it generalized. This
# scan drops that constraint and enumerates every 4-subset of {1, ..., C-1} directly: four
# offsets, no pairing, no sign relationship. The population searched strictly contains the elder
# family (every {d,-d,2d,-2d} is one particular 4-subset), so this reading can only match or beat
# it, never fall short by construction -- which is itself part of what the scan proves.
#
# THE ARITHMETIC CEILING IS UNCHANGED. Five points (the cell itself plus four offsets) split a
# ring of C cells into at most five gaps; run-kill length is C minus the widest gap plus one,
# maximized when the gaps are as even as the integers allow -- near C/5 each. That bound never
# assumed the offsets came in +-pairs, so C - ceil(C/5) + 1 is still the ceiling here. The
# question this scan answers is whether the exhaustive search reaches it too, or whether the
# elder search's ceiling read was a coincidence of the symmetric shape.
#
# THE COST IS BOUNDED, NAMED, AND WHY A NESTED LOOP RATHER THAN A LIBRARY. Exhaustive search over
# 4-subsets of {1..C-1} costs C(C-1, 4) evaluations -- 595,665 at C=64, the elder search's own
# grid. Four nested loops (i<j<k<l) generate each subset once with no combinatorics library, at a
# cost awk can carry in well under a minute for C=64. MAX_SUBSETS below is the explicit bound: a
# grid whose C(C-1,4) exceeds it is refused rather than left to run unbounded, per TAME's own
# "bound everything, name the budget, fail with a named error."
#
# WHAT THIS DOES NOT READ. Any real store. Six or more offsets (a higher replica count) -- this
# reads exactly the five-copy population round one and round two both inherited. Whether five
# copies is the right count for a real store stays untouched, carried forward as-is.
#
# USAGE
#   sh tools/fixtures/t/torus_offset_generic_search_scan.sh             # grid 8, C=64 (elder's own)
#   sh tools/fixtures/t/torus_offset_generic_search_scan.sh --grid G    # cells per axis, C=G*G
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

GRID="${TORUS_OFFSET_GRID:-8}"
MAX_SUBSETS=5000000    # bounded: C(C-1,4) must stay under this or the sweep is refused outright

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

echo "instrument=torus_offset_generic_search"
echo "grid=$GRID"

CELLS=$((GRID * GRID))
echo "cells=$CELLS"
if [ "$CELLS" -lt 5 ]; then
  echo "detail: cells=$CELLS too small for five distinct points"
  echo "verdict=unreadable"
  exit 0
fi

# C(C-1,4) named ahead of the sweep so an oversized grid is refused before any loop starts.
N=$((CELLS - 1))
SUBSETS=$(awk -v n="$N" 'BEGIN { if (n < 4) { print 0 } else { printf "%.0f\n", n*(n-1)*(n-2)*(n-3)/24 } }')
echo "candidate_subsets=$SUBSETS"
if [ "$SUBSETS" -gt "$MAX_SUBSETS" ]; then
  echo "detail: candidate_subsets=$SUBSETS exceeds the bounded budget $MAX_SUBSETS -- named refusal, not a hang"
  echo "verdict=too_large"
  exit 0
fi

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

awk -v cells="$CELLS" -v g="$GRID" '
  # run_kill_of(o1,o2,o3,o4): the five points are {0, o1, o2, o3, o4}; sort, take the widest gap
  # on the circle, span = cells - widest + 1. Offsets are already distinct and in [1, cells-1] by
  # construction of the enumeration below, so no dedup step is needed here (unlike the elder
  # circulant search, whose +-d, +-2d shape could alias into fewer than five distinct points).
  function run_kill(o1, o2, o3, o4,    v, i, j, key, widest, gap) {
    v[0] = 0; v[1] = o1; v[2] = o2; v[3] = o3; v[4] = o4
    for (i = 1; i <= 4; i++) { key = v[i]; j = i - 1; while (j >= 0 && v[j] > key) { v[j+1]=v[j]; j-- } v[j+1]=key }
    widest = v[0] + cells - v[4]
    for (i = 1; i <= 4; i++) { gap = v[i] - v[i-1]; if (gap > widest) widest = gap }
    return cells - widest + 1
  }
  BEGIN {
    best = -1; bo1 = -1; bo2 = -1; bo3 = -1; bo4 = -1
    for (a = 1; a <= cells - 4; a++) {
      for (b = a + 1; b <= cells - 3; b++) {
        for (c = b + 1; c <= cells - 2; c++) {
          for (d = c + 1; d <= cells - 1; d++) {
            s = run_kill(a, b, c, d)
            if (s > best) { best = s; bo1 = a; bo2 = b; bo3 = c; bo4 = d }
          }
        }
      }
    }
    printf "best_run_kill=%d\n", best
    printf "best_offsets=%d,%d,%d,%d\n", bo1, bo2, bo3, bo4
    ceil5 = int((cells + 4) / 5)
    printf "theoretical_ceiling=%d\n", cells - ceil5 + 1
  }
' > "$PEN/out"

cat "$PEN/out"

# --- the verdict --------------------------------------------------------------------------------
# GATED: the exhaustive best never exceeds the theoretical ceiling (the arithmetic bound is a
# true upper bound on ANY five-point split, generic or not -- a search reading above it would mean
# the ceiling's own derivation is wrong, which the witness's small hand-checkable grid rules out).
# REPORTED: whether the generic best reaches the ceiling exactly -- the conjecture this scan was
# built to check, not a controllable pass/fail bit.
read_field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$PEN/out"; }

best=$(read_field best_run_kill)
ceiling=$(read_field theoretical_ceiling)

if [ "$best" -le "$ceiling" ]; then
  bound_ok=yes
else
  bound_ok=no
fi
echo "bound_holds=$bound_ok"

if [ "$best" -eq "$ceiling" ]; then
  echo "reaches_ceiling=yes"
else
  echo "reaches_ceiling=no"
fi

if [ "$bound_ok" = yes ]; then
  echo "verdict=ok"
else
  echo "verdict=refused"
fi
