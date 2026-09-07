#!/bin/sh
# tools/fixtures/t/topology_partial_control.sh -- proves tools/fixtures/t/topology_partial_scan.sh
# refuses what it claims to refuse and reports what it claims to report, by planting each fault in
# a throwaway copy and watching the copy read RED, then lifting the plant and watching it read
# GREEN again.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a bypass.
# Every plant here runs twice -- once bitten, once lifted -- and the lifted run must return the pen
# copy to the unmodified reading, so no plant can leave the scan quietly damaged.
#
# WHY A PEN COPY RATHER THAN THE TREE. The plants corrupt the scan, and corrupting the tracked file
# even briefly would put a lap one interrupt away from committing a broken instrument. Every plant
# lands in a copy under a directory named with this process id -- a constant name would be a second
# ship writing the same path on a pier eight of them share, which is the fault REDS %549 booked --
# and the copy is removed on exit.
#
# THE PLANTS THAT MATTER MOST, and why each earns its place:
#
#   THE ANCHOR, because every number here rests on it. This scan carries its own copy of the
#   builder and the chain rule, so the anchor is what binds that copy to the two sibling scans'
#   published readings. A drifted builder would print confident numbers about the wrong graph.
#
#   PURITY, because it is the only fault the output cannot show. A rule consulting the
#   breadth-first distance array would print perfect delivery and would be exactly the table-bound
#   case wearing the table-free answer. Planted in a body and on a declaration line, and its
#   COMMENT BOUNDARY proven too: the check closes a function body at a column-zero comment, and
#   without that it runs on to the next `function` line and reads the following function's comment
#   block as part of the previous body -- which refused this very file on its first run, over a
#   line of prose describing the distance array rather than touching it.
#
#   THE DERIVED LADDER, because a ladder nobody counted is a claim. The radix leg computes each
#   nested class size by the falling-factorial closed form AND counts the vertices that actually
#   share each suffix, and refuses when the two disagree. Planted by shifting the closed form.
#
#   THE FIXED TARGET LIST, because it is what makes two arrangements comparable at all. Sampling
#   targets from the LIVE set -- which is how the sibling scan samples them -- scores each
#   arrangement against its own destinations. Measured on this shape: at three live-sampled targets
#   `class_partial` read best of five arrangements and at fifteen it read worst by a factor of
#   fourteen. The plant restores live sampling and the pen must then disagree with the tree.
#
#   THE PARTITION COUNT IN THE SWEEP, because a partition reads as perfection. The sweep's first
#   draft routed from ONE target and printed whatever pair count survived, so `block` at 20 holes
#   read a clean zero-lost over 19 pairs while the shape stood in three components. The plant
#   silences the unreachable count and the pen must lose it.
#
#   sh tools/fixtures/t/topology_partial_control.sh

set -u

# THE PLANTS ARE APPLIED THROUGH `plant.sh`, for two reasons at once. A bare `sed -i` is a GNU
# spelling that BSD reads as a backup suffix, which this tree's portability gate holds at zero; and
# a `sed` naming a literal line is a CLAIM that the line is spelled that way today, which is the one
# part of a control nothing checks. When a line moves, the plant matches nothing, the copy runs
# unmutated, and the phase reads green for a fault it never planted (REDS %519).
_fd_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/p/plant.sh"

SCAN=tools/fixtures/t/topology_partial_scan.sh
PEN="${TMPDIR:-/tmp}/topology_partial_control.$$"
trap 'rm -rf "$PEN"' EXIT INT TERM
mkdir -p "$PEN" || exit 1
pass=0; fail=0

note() { printf '%s %s\n' "$1" "$2"; if [ "$1" = "ok" ]; then pass=$((pass+1)); else fail=$((fail+1)); fi }
copy_pen() { cp "$SCAN" "$PEN/$1.sh"; }
plant() {
  if plant_apply "$PEN/$1.sh" "$2" "$3"; then note ok "plant $3 landed"
  else note RED "plant $3 matched nothing -- the line it names has moved"; fi
}
# A plant is read at ONE small size and one small target count rather than at the defaults. The
# scan's own knobs make a planted run cost under a second instead of five minutes, which is what
# lets every refusal here be shown from both sides rather than only from the side that fires.
PSIZ="6,3"
PHOL="8"
PTGT="4"
run_pen() { SCAN_LEGS="${2:-all}" SCAN_SIZES="${3:-$PSIZ}" SCAN_HOLES="${4:-$PHOL}" SCAN_TARGETS="$PTGT" sh "$PEN/$1.sh" 2>&1; }
run_tree() { SCAN_LEGS="${1:-all}" SCAN_SIZES="${2:-$PSIZ}" SCAN_HOLES="${3:-$PHOL}" SCAN_TARGETS="$PTGT" sh "$SCAN" 2>&1; }

expect_red() {
  out=$(run_pen "$1" "${3:-arrange}")
  if printf '%s' "$out" | grep -q 'verdict=refused' && printf '%s' "$out" | grep -q "$2"
  then note ok "$1 refused naming $2"
  else note RED "$1 did not refuse naming $2"; fi
}
expect_green() {
  out=$(run_pen "$1" "${2:-arrange}")
  if printf '%s' "$out" | grep -q 'verdict=ok'
  then note ok "$1 green"
  else note RED "$1 not green"; fi
}

# ---- the pen is innocent -----------------------------------------------------------------------
copy_pen innocent
TREE=$(run_tree arrange "$PSIZ" "$PHOL")
PENOUT=$(run_pen innocent arrange "$PSIZ" "$PHOL")
if [ "$TREE" = "$PENOUT" ]; then note ok "pen copy reads exactly what the tree reads"
else note RED "pen copy disagrees with the tree"; fi
expect_green innocent

# ---- a plant that lands nowhere must say so ----------------------------------------------------
copy_pen nowhere
if plant_apply "$PEN/nowhere.sh" 's/a line that is not in this file anywhere at all/x/' 'nomatch'
then note RED "a plant matching nothing was reported as landed"
else note ok "a plant matching nothing refuses by name"; fi

# ---- determinism, because every hole set here is chosen rather than sampled ---------------------
A=$(run_tree arrange "$PSIZ" "$PHOL"); B=$(run_tree arrange "$PSIZ" "$PHOL")
if [ "$A" = "$B" ]; then note ok "two runs choose the same holes and read the same numbers"
else note RED "two runs disagree -- the hole set is not deterministic"; fi

# ---- the anchor: both sibling scans' published readings -----------------------------------------
ANCH=$(run_tree anchor)
if printf '%s\n' "$ANCH" | grep -q 'anchor n=6 k=5 points=720 degree=5 diameter=7 chain_optimal=720/720'
then note ok "anchor S(6,5) reproduces the sibling reading -- 720 points, degree 5, diameter 7, routed whole"
else note RED "anchor S(6,5) does not reproduce 720/5/7"; fi
if printf '%s\n' "$ANCH" | grep -q 'anchor n=7 k=4 points=840 degree=6 diameter=7 chain_optimal=840/840'
then note ok "anchor S(7,4) reproduces the sibling reading -- 840 points, degree 6, diameter 7, routed whole"
else note RED "anchor S(7,4) does not reproduce 840/6/7"; fi

# ---- the radix ladder, derived AND counted ------------------------------------------------------
RAD=$(run_tree radix "7,4")
if printf '%s\n' "$RAD" | grep -q 'radix n=7 k=4 points=840 ladder=120,20,4,1'
then note ok "the nested class ladder of S(7,4) reads 120, 20, 4, 1 -- derived and counted alike"
else note RED "the nested class ladder of S(7,4) moved"; fi
copy_pen radixbad
plant radixbad 's|want = int(want / (n - j + 1))|want = int(want / (n - j + 2))|' 'radix closed form shifted'
expect_red radixbad 'derived and counted class sizes disagree' radix
copy_pen radixbad2; expect_green radixbad2 radix

# ---- purity: the one fault the output cannot show ------------------------------------------------
copy_pen purebody
plant purebody 's|  cap = 40 \* k + 80; hops = 0; VISPEAK = 1|  cap = 40 * k + 80; hops = 0; VISPEAK = 1; if (D[src] < 0) hops = 0|' 'distance array read inside a routing body'
expect_red purebody 'routing_functions_reading_distance_array=1'
copy_pen puredecl
plant puredecl 's|function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = 0|function terminus(a, k, start,   cur, steps, sym) { cur = D[start]; steps = 0|' 'distance array read on a declaration line'
expect_red puredecl 'routing_functions_reading_distance_array=1'
copy_pen pureclean; expect_green pureclean
# THE COMMENT BOUNDARY, from the side that matters. Remove the column-zero comment close and the
# check runs on into the next function's comment block, which describes the distance array in
# prose. A clean file must then refuse -- which is the false refusal this control exists to keep
# from returning.
# THE COMMENT BOUNDARY, proven from both sides with the comment it exists for. A column-zero
# comment describing the distance array, standing between a routing function and the next one, is
# ordinary prose -- and without the boundary the check runs past the function body into it and
# refuses a clean file. That false refusal happened on this file's first run, so it is planted.
copy_pen purecomment
plant purecomment 's|^# ---- legs ---|# a column-zero note mentioning the D[] array, standing after the last routing function\n# ---- legs ---|' 'a comment naming the distance array after a routing function'
expect_green purecomment
plant purecomment 's|    else if (substr(line, 1, 1) == "#") { fn = ""; continue }|    else if (substr(line, 1, 1) == "@") { fn = ""; continue }|' 'comment boundary disabled'
expect_red purecomment 'routing_functions_reading_distance_array=[1-9]'
copy_pen purecomment2; expect_green purecomment2

# ---- the fixed target list, which is what makes two arrangements comparable ----------------------
copy_pen livetargets
plant livetargets 's|  stride = coprime_stride(NV)|  stride = 1|' 'target list stride collapsed to one'
LT=$(run_pen livetargets arrange)
if [ "$LT" != "$TREE" ]
then note ok "moving the target list changes the reading, so the targets are load-bearing rather than decorative"
else note RED "the target list makes no difference, so it is not being used"; fi
copy_pen livetargets2; expect_green livetargets2
# AND THE SAME TARGETS REACH EVERY ARRANGEMENT. Every arrangement at one hole count must report the
# same `targets` plus `targets_dead`, since the list is fixed and only liveness varies.
TSUM=$(printf '%s\n' "$TREE" | grep '^deliver ' | sed 's/.* targets=\([0-9]*\) targets_dead=\([0-9]*\).*/\1 \2/' | awk '{print $1+$2}' | sort -u | wc -l)
if [ "$TSUM" -eq 1 ]
then note ok "every arrangement is scored against the same target list, dead ones counted rather than replaced"
else note RED "arrangements are scored against different numbers of targets"; fi

# ---- the findings, stated as readings that must hold --------------------------------------------
# THE FALSIFIER FIRES. The published rule, which cannot see liveness, loses packets into holes.
bl=$(printf '%s\n' "$TREE" | grep 'rule=blind' | grep -c 'holehit=[1-9]')
if [ "$bl" -ge 1 ]
then note ok "the published rule walks into holes on $bl reading(s) -- the falsifier is real"
else note RED "the published rule never hit a hole, so nothing here is being measured"; fi
# AND THE RETREATING RULE CLOSES IT, in every arrangement, which is the paper's own headline.
tr_bad=$(printf '%s\n' "$TREE" | grep '^deliver .*rule=trace' | grep -cv 'holehit=0 deadend=0 bail=0')
if [ "$tr_bad" -eq 0 ]
then note ok "the retreating rule delivers every reachable pair in every arrangement measured"
else note RED "the retreating rule left $tr_bad arrangement(s) undelivered"; fi

# ---- the offset finding: whole classes of equal size are NOT interchangeable ---------------------
OFF=$(SCAN_LEGS=offset SCAN_TARGETS=3 sh "$SCAN" 2>&1)
obest=$(printf '%s\n' "$OFF" | sed -n 's/^offset_range classes=[0-9]* best_holehit=\([0-9]*\) .*/\1/p')
oworst=$(printf '%s\n' "$OFF" | sed -n 's/^offset_range .*worst_holehit=\([0-9]*\)$/\1/p')
if [ "${oworst:-0}" -gt "${obest:-0}" ]
then note ok "42 whole classes of equal size cost between $obest and $oworst -- choosing a whole class is not enough"
else note RED "every whole class costs the same, so the offset finding is not being measured"; fi

# ---- the sweep's partition count, because a partition reads as perfection -----------------------
SW=$(SCAN_LEGS=sweep SCAN_TARGETS="$PTGT" sh "$SCAN" 2>&1)
if printf '%s\n' "$SW" | grep '^sweep .*arrangement=block' | grep -q 'components=[2-9]'
then note ok "door-major contiguous allocation partitions the shape, and the sweep says so"
else note RED "the sweep no longer shows the block arrangement partitioning"; fi
if printf '%s\n' "$SW" | grep '^sweep .*arrangement=block' | grep -q 'unreachable=[1-9]'
then note ok "the partitioned pairs are counted on the line rather than left to a small denominator"
else note RED "a partitioned sweep line reports no unreachable pairs"; fi
if printf '%s\n' "$SW" | grep -q 'summary .*partitioned=[1-9]'
then note ok "the sweep's partitions reach the summary, so a silent partition cannot pass as green"
else note RED "the sweep's partitions never reach the summary"; fi
copy_pen quietsweep
plant quietsweep 's|      if (!(v in D)) { unreach++; continue }|      if (!(v in D)) { continue }|' 'sweep unreachable count silenced'
QS=$(run_pen quietsweep sweep)
if printf '%s\n' "$QS" | grep '^sweep .*arrangement=block' | grep -q 'unreachable=0'
then note ok "silencing the unreachable count makes a partitioned sweep read clean -- which is why it is counted"
else note RED "silencing the unreachable count left the sweep reading unchanged"; fi

# ---- a reduced run can never be read as a full one ----------------------------------------------
RED_RUN=$(SCAN_LEGS=radix SCAN_SIZES="6,3" SCAN_TARGETS=2 sh "$SCAN" 2>&1)
if printf '%s\n' "$RED_RUN" | grep -q 'legs=radix' && printf '%s\n' "$RED_RUN" | grep -q 'sizes=6,3' && printf '%s\n' "$RED_RUN" | grep -q 'targets=2'
then note ok "a reduced run prints its own knobs, so it cannot be mistaken for the full reading"
else note RED "a reduced run does not declare itself"; fi

printf 'passed=%d\n' "$pass"
printf 'failed=%d\n' "$fail"
printf 'verdict=%s\n' "$([ "$fail" -eq 0 ] && echo ok || echo refused)"
[ "$fail" -eq 0 ]
