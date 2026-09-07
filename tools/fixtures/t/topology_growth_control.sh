#!/bin/sh
# tools/fixtures/t/topology_growth_control.sh -- the growth-regime cost, broken on purpose.
#
#   sh tools/fixtures/t/topology_growth_control.sh
#
# WHY. `tools/fixtures/t/topology_growth_scan.sh` prints numbers a design would act on: that a
# lowest-free counter leaves a star graph in 36 pieces of one point each while the same counter over
# a breadth-first numbering leaves it whole, that the first 120 lexicographic ranks of S_6 form an
# independent set, and that a random address space has no giant component below a third full. A
# number a reader can watch go wrong is a number a reader can trust, so this copies the scan into a
# pen, breaks it eleven ways, watches each break show, and lifts every break. It proves the pen
# innocent first, so each plant reads as the break speaking rather than as the pen.
#
# EVERY PLANT IS PROVEN TO HAVE APPLIED, through `tools/fixtures/p/plant.sh` rather than through a
# byte comparison written fresh here. A `sed` whose pattern no longer matches copies the scan
# unmutated, and the phase then reads exactly like a law that holds. The helper answers
# `plant_matched_nothing:<label>` in that case -- a word, never an exit code -- and it also catches
# the fault a local `cmp -s` cannot: a program `sed` REJECTS leaves a partial file that differs, and
# a byte comparison calls that landed (REDS %519, one room over).
#
# TWO PLANTS PASS, ON PURPOSE. Plant 10 breaks the growth rule and then runs `legs=indep`, which
# does not read it; plant 11 breaks the seeds leg and runs `legs=growth`. Both read green, and that
# is what a silent wrong answer looks like from outside -- the reason each reading here prints its
# own `legs=` word and only the full pass the witness binds may claim to be the whole scan.
#
# WHY IT IS CHEAP. The full pass is 21s and eleven copies would be four minutes. The scan takes a
# leg word (all|shape|growth|indep|seeds), so each plant runs only the leg it breaks: `indep` is
# 0.09s and `seeds` is 0.36s, so only the plants that genuinely need the 21s growth leg pay it.
set -u

_fd_root=$(cd "$(dirname "$0")/../../.." 2>/dev/null && pwd)
[ -n "${_fd_root:-}" ] || _fd_root=$(pwd)
. "$_fd_root/tools/fixtures/p/plant.sh"

SRC="$_fd_root/tools/fixtures/t/topology_growth_scan.sh"
PEN=$(mktemp -d 2>/dev/null || echo "/tmp/growth-control-$$")
mkdir -p "$PEN"
trap 'rm -rf "$PEN"' EXIT INT HUP TERM

FAULTS=0
PLANTS=0
CHECKS=0

note() { printf '%s\n' "$*"; }
fail() { FAULTS=$((FAULTS + 1)); printf 'FAULT %s\n' "$*"; }

# expect_shows LABEL LEG PROGRAM PATTERN -- plant the break, run the named leg, require the pattern
# to STOP appearing. Every plant is lifted by rebuilding the pen from source on the next call, so a
# break can never leak into the plant after it.
expect_shows() {
  _lbl=$1; _leg=$2; _prog=$3; _pat=$4
  plant_write "$SRC" "$PEN/scan.sh" "$_prog" "$_lbl" || { fail "$_lbl plant_matched_nothing"; return 1; }
  PLANTS=$((PLANTS + 1))
  _out=$(sh "$PEN/scan.sh" "$_leg" 2>&1)
  CHECKS=$((CHECKS + 1))
  if printf '%s' "$_out" | grep -q -- "$_pat"; then
    fail "$_lbl broke nothing -- the reading [$_pat] stood under the break"
  else
    note "  $_lbl -- the break shows: [$_pat] is gone under legs=$_leg"
  fi
}

# expect_stands LABEL LEG PROGRAM PATTERN -- plant a break the named leg does not read, and require
# the reading to STAND. This is the silent-wrong-answer shape, proven rather than described.
expect_stands() {
  _lbl=$1; _leg=$2; _prog=$3; _pat=$4
  plant_write "$SRC" "$PEN/scan.sh" "$_prog" "$_lbl" || { fail "$_lbl plant_matched_nothing"; return 1; }
  PLANTS=$((PLANTS + 1))
  _out=$(sh "$PEN/scan.sh" "$_leg" 2>&1)
  CHECKS=$((CHECKS + 1))
  if printf '%s' "$_out" | grep -q -- "$_pat"; then
    note "  $_lbl -- reads green under legs=$_leg while broken, which is the point"
  else
    fail "$_lbl was expected to pass unnoticed under legs=$_leg and did not"
  fi
}

note "topology-growth-control: the pen is proven innocent before any plant is believed."
cp "$SRC" "$PEN/scan.sh"
INNOCENT=$(sh "$PEN/scan.sh" all 2>&1)
CHECKS=$((CHECKS + 1))
printf '%s' "$INNOCENT" | grep -q 'verdict=ok legs=all faults=0' \
  || fail "the unmutated pen did not reach its own green -- every plant below would be unreadable"
for want in \
  'indep shape=star prefix_edgeless_max=120' \
  'indep shape=circ prefix_edgeless_max=1' \
  'growth shape=star policy=lowfree live=36 occupancy=0.0500 components=36 largest=1' \
  'growth shape=star policy=lowfree_bfs live=36 occupancy=0.0500 components=1 largest=36' \
  'aware rows=72 connected=72' \
  'nongeodesic_rows=0'
do
  CHECKS=$((CHECKS + 1))
  printf '%s' "$INNOCENT" | grep -q -- "$want" || fail "innocent pen missing [$want]"
done
note "  the pen reads the scan's own numbers, so a plant below speaks for itself."

note "topology-growth-control: eleven breaks, each watched and then lifted."

# 1 -- the independence leg counting the wrong direction. It would then measure edges LEAVING the
#      prefix rather than edges inside it, and the star's 120 would move. This defends the one
#      reading in the scan that is a theorem.
expect_shows indep-wrong-direction indep \
  's/if (w < i) edges++/if (w > i) edges++/' \
  'indep shape=star prefix_edgeless_max=120'

# 2 -- the star graph rebuilt from ADJACENT transpositions, which is the bubble-sort graph: a real
#      Cayley graph on the same 720 points, and the wrong one. The a1=1 argument dies with it, since
#      swapping positions 2 and 3 leaves a1 alone and keeps the neighbour inside the prefix. The
#      tell is the prefix reading itself, which is what makes the theorem a check and not a belief.
expect_shows star-is-bubble-sort indep \
  's/t = arr\[1\]; arr\[1\] = arr\[j\]; arr\[j\] = t/t = arr[j-1]; arr[j-1] = arr[j]; arr[j] = t/' \
  'indep shape=star prefix_edgeless_max=120'

# 3 -- the grower losing its free-neighbour test, so it re-selects addresses it already holds and
#      the live set stalls at TWO points while the counter believes it grew. THE TELL IS THE LIVE
#      COUNT AND NOTHING ELSE: the broken row still prints `components=1 connected=yes` and a
#      `table_arrival_share=1.000000`, which is a perfect score on a network of two. Connectivity
#      and arrival share are both meaningless on a degenerate input, and this plant is here to say
#      so out loud -- it was first aimed at the connectivity reading and passed clean, which is how
#      the wrong tell was found.
expect_shows grow-stalls-at-two growth \
  's/if (w in LIVE) continue/if (0) continue/' \
  'growth shape=circ policy=grow_ball live=36 occupancy=0.0500'

# 4 -- the component counter walking dark addresses, so every live set reads as one piece and the
#      whole partition finding disappears. This is the shape of a failure model that never fails.
expect_shows components-walk-the-dark growth \
  's/if (!(u in LIVE) || (u in seen)) continue/if (u in seen) continue/' \
  'growth shape=star policy=lowfree live=36 occupancy=0.0500 components=36 largest=1'

# 5 -- the stale table stepping onto a dark next hop rather than dropping. The arrival share rises
#      toward one everywhere, which is the direction a flattering number moves.
expect_shows table-routes-through-the-dark growth \
  's/if (!(w in LIVE)) return -1/if (0) return -1/' \
  'blind rows=48 connected=21 mean_table_arrival=0.378237'

# 6 -- the graceful rule accepting a sideways step instead of requiring a strict decrease. The
#      geodesic identity is exactly the strictness, so this is the plant that defends it: with the
#      comparison loosened the walk can wander and arrive off a shortest path.
expect_shows dist-drops-strictness growth \
  's/if (D2T\[w\] < bestd) { bestd = D2T\[w\]; bestv = w }/if (D2T[w] <= bestd) { bestd = D2T[w]; bestv = w }/' \
  'nongeodesic_rows=0'

# 7 -- the live-subgraph walk stepping through dark addresses, so the optimum becomes the FULL-space
#      distance and no pair ever reads unreachable. A partition would then be invisible.
expect_shows bfs-live-walks-the-dark growth \
  's/if (!(u in LIVE) || (u in PD)) continue/if (u in PD) continue/' \
  'growth shape=star policy=lowfree live=36 occupancy=0.0500 components=36 largest=1 connected=no unreachable=840'

# 8 -- the pseudorandom stream's multiplier moved. The subsets change, so this proves the seed rows
#      are a real draw from a reproducible stream rather than a constant nobody would notice.
expect_shows minstd-multiplier-moved seeds \
  's/RS_STATE = (RS_STATE \* 16807) % 2147483647/RS_STATE = (RS_STATE * 48271) % 2147483647/' \
  'seeds shape=star policy=random live=216 occupancy=0.3000 draws=8 components_min=46 components_max=58'

# 9 -- the seeds leg drawing the same subset eight times, so its min and max agree trivially and the
#      spread it reports is vacuous. The tell is the star's own spread closing.
expect_shows seeds-one-draw-eight-times seeds \
  's/fill_random(m, n, 7919 \* sd + 13, LIVE)/fill_random(m, n, 7919 + 13, LIVE)/' \
  'components_min=46 components_max=58'

# 10 -- A BREAK THAT PASSES. The growth rule is broken exactly as plant 3 breaks it, and then only
#       the independence leg is run. It reads green, because that leg never touches the policy. This
#       is why every reading prints its own `legs=` word.
expect_stands grow-broken-indep-blind indep \
  's/if (w in LIVE) continue/if (0) continue/' \
  'verdict=ok legs=indep faults=0'

# 11 -- A SECOND BREAK THAT PASSES. The seeds leg is disarmed and the growth leg is run, which never
#       reads it. Same lesson from the other side, so the pair cannot be mistaken for one accident.
expect_stands seeds-broken-growth-blind growth \
  's/fill_random(m, n, 7919 \* sd + 13, LIVE)/fill_random(m, n, 7919 + 13, LIVE)/' \
  'verdict=ok legs=growth faults=0'

note "topology-growth-control: every plant lifted -- the source on disk was never touched."
cp "$SRC" "$PEN/scan.sh"
LIFTED=$(sh "$PEN/scan.sh" all 2>&1)
CHECKS=$((CHECKS + 1))
printf '%s' "$LIFTED" | grep -q 'verdict=ok legs=all faults=0' \
  || fail "the pen did not return to green after the plants, so a break leaked"

printf 'growth_control plants_applied=%d checks=%d faults=%d verdict=%s\n' \
  "$PLANTS" "$CHECKS" "$FAULTS" "$([ "$FAULTS" -eq 0 ] && echo ok || echo broken)"
[ "$FAULTS" -eq 0 ]
