#!/bin/sh
# tools/fixtures/t/topology_occupied_control.sh -- proves tools/fixtures/t/topology_occupied_scan.sh
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
#   THE ANCHOR, because every number here rests on it. This file carries its own copy of the
#   builder and the chain rule, so the anchor is what binds that copy to the sibling scan's
#   published readings. If the builder drifted, S(6,5) would stop reproducing diameter 7 at 720
#   points and every occupancy reading below would be a measurement of the wrong graph.
#
#   PURITY, because it is the only fault the output cannot show. A rule consulting the
#   breadth-first distance array would print perfect delivery and zero stretch and would be exactly
#   the table-bound case wearing the table-free answer. Planted in a body and on a declaration
#   line, and its WORD BOUNDARY proven from the other side too: `CAND[` ends in the same two
#   characters as the distance array, and the first draft of the check refused a clean file on it.
#
#   THE HOLE CREDIT, because it produced an impossible number rather than a wrong one. Crediting
#   `blind` with a delivery it made THROUGH a dead member makes its route shorter than the shortest
#   path in the live subgraph, so the mean stretch comes out NEGATIVE. That is how the fault was
#   caught while this file was being written, and the plant restores it so the reading stays
#   guarded rather than remembered.
#
#   THE FULL NEIGHBOURHOOD, because it is what makes the retreating rule complete. Ranking only the
#   moves the published rule prefers leaves a SUBGRAPH of the live graph, and a depth-first walk
#   over a subgraph dead-ends while the graph around it is connected. Planted by dropping the
#   unpreferred neighbours; the pen must then show dead ends the tree does not.
#
#   THE PARTITION COUNT, because a partition reads as perfection. Removing one door class from
#   S(7,4) leaves four components, every surviving pair routes flawlessly, and the delivery line
#   says 837 of 837. The `unreachable` count is the only number that says otherwise, so it is
#   proven present and non-zero exactly where the partition is.
#
#   sh tools/fixtures/t/topology_occupied_control.sh

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

SCAN=tools/fixtures/t/topology_occupied_scan.sh
PEN="${TMPDIR:-/tmp}/topology_occupied_control.$$"
trap 'rm -rf "$PEN"' EXIT INT TERM
mkdir -p "$PEN" || exit 1
pass=0; fail=0

note() { printf '%s %s\n' "$1" "$2"; if [ "$1" = "ok" ]; then pass=$((pass+1)); else fail=$((fail+1)); fi }
copy_pen() { cp "$SCAN" "$PEN/$1.sh"; }
plant() {
  if plant_apply "$PEN/$1.sh" "$2" "$3"; then note ok "plant $3 landed"
  else note RED "plant $3 matched nothing -- the line it names has moved"; fi
}
# A plant is read at ONE small size rather than at both. The scan's own knobs make a planted run
# cost under a second instead of a minute, which is what lets every refusal here be shown from both
# sides rather than only from the side that fires.
PSIZ="6,3"
PFILL="90"
run_pen() { SCAN_LEGS="${2:-all}" SCAN_SIZES="${3:-$PSIZ}" SCAN_FILL="${4:-$PFILL}" sh "$PEN/$1.sh" 2>&1; }
run_tree() { SCAN_LEGS="${1:-all}" SCAN_SIZES="${2:-$PSIZ}" SCAN_FILL="${3:-$PFILL}" sh "$SCAN" 2>&1; }

expect_red() {
  out=$(run_pen "$1" "${3:-all}")
  if printf '%s' "$out" | grep -q 'verdict=refused' && printf '%s' "$out" | grep -q "$2"
  then note ok "$1 refused naming $2"
  else note RED "$1 did not refuse naming $2"; fi
}
expect_green() {
  out=$(run_pen "$1" "${2:-all}")
  if printf '%s' "$out" | grep -q 'verdict=ok'
  then note ok "$1 green"
  else note RED "$1 not green"; fi
}

# ---- the pen is innocent -----------------------------------------------------------------------
copy_pen innocent
TREE=$(run_tree all "$PSIZ" "$PFILL")
PENOUT=$(run_pen innocent all "$PSIZ" "$PFILL")
if [ "$TREE" = "$PENOUT" ]; then note ok "pen copy reads exactly what the tree reads"
else note RED "pen copy disagrees with the tree"; fi
expect_green innocent

# ---- determinism, because every hole set here is chosen rather than sampled ---------------------
A=$(run_tree deliver "$PSIZ" "$PFILL"); B=$(run_tree deliver "$PSIZ" "$PFILL")
if [ "$A" = "$B" ]; then note ok "two runs choose the same holes and read the same numbers"
else note RED "two runs disagree -- the hole set is not deterministic"; fi

# ---- the anchor: the sibling scan's own two published readings ----------------------------------
ANCH=$(run_tree anchor)
if printf '%s\n' "$ANCH" | grep -q 'anchor n=6 k=5 points=720 degree=5 diameter=7 chain_optimal=720/720'
then note ok "anchor S(6,5) reproduces the sibling reading -- 720 points, degree 5, diameter 7, routed whole"
else note RED "anchor S(6,5) does not reproduce 720/5/7"; fi
if printf '%s\n' "$ANCH" | grep -q 'anchor n=7 k=4 points=840 degree=6 diameter=7 chain_optimal=840/840'
then note ok "anchor S(7,4) reproduces the sibling reading -- 840 points, degree 6, diameter 7, routed whole"
else note RED "anchor S(7,4) does not reproduce 840/6/7"; fi

# ---- the findings, stated as readings that must hold --------------------------------------------
# THE FALSIFIER FIRES. The published rule, which cannot see liveness, loses packets into holes.
bl=$(printf '%s\n' "$TREE" | grep 'rule=blind' | grep -c 'holehit=[1-9]')
if [ "$bl" -ge 1 ]
then note ok "the published rule walks into holes on $bl reading(s) -- the falsifier is real"
else note RED "the published rule never hit a hole, so nothing here is being measured"; fi
# AND THE RETREATING RULE CLOSES IT. Every pair, every configuration.
tr_bad=$(printf '%s\n' "$TREE" | grep '^deliver .*rule=trace' | grep -cv 'holehit=0 deadend=0 bail=0')
if [ "$tr_bad" -eq 0 ]
then note ok "the retreating rule delivers every reachable pair in every configuration measured"
else note RED "the retreating rule left $tr_bad configuration(s) undelivered"; fi
# AND MEMORYLESSNESS IS THE FAULT, not the missing table: the local rule loops where trace does not.
lo=$(printf '%s\n' "$TREE" | grep 'rule=local' | grep -c 'bail=[1-9]')
if [ "$lo" -ge 1 ]
then note ok "the memoryless rule cycles on $lo reading(s) -- a path record is what closes it, not a table"
else note RED "the memoryless rule never cycled, so the trace rule is unmotivated"; fi

# ---- the geometry finding, both ends, because only one of them is free --------------------------
CL=$(run_tree cluster "7,4" "$PFILL")
if printf '%s\n' "$CL" | grep 'mode=class1' | grep -q 'stretch_max=0 stretch_mean=0.000'
then note ok "a far-end symbol class costs nothing -- 120 of 840 gone, zero stretch"
else note RED "far-end class reading is not free, and the paper says it is"; fi
if printf '%s\n' "$CL" | grep -q 'occupy n=7 k=4 points=840 mode=door1 fill=85 live=720 holes=120 classes=1 components=4'
then note ok "a door class of the SAME size partitions the shape into four components"
else note RED "door class did not partition, so the two ends read alike"; fi
if printf '%s\n' "$CL" | grep 'mode=door1' | grep -q 'unreachable=[1-9]'
then note ok "the partition is named on the delivery line -- unreachable pairs counted, never inferred from silence"
else note RED "a partitioned reading printed no unreachable count, so it reads as perfect"; fi

# ---- plant: the hole credit, which produced an impossible number --------------------------------
copy_pen holecredit
plant holecredit 's|if (rule == "blind") { p = back; moved = 1; if (!LIVE\[p\]) return -3; break }|if (rule == "blind") { p = back; moved = 1; break }|' hole_credit
out=$(run_pen holecredit deliver)
if printf '%s\n' "$out" | grep 'rule=blind' | grep -q 'stretch_mean=-'
then note ok "crediting a route through a dead member reads as NEGATIVE stretch, which is impossible and therefore visible"
else note RED "the hole credit produced no negative stretch, so the reading would have hidden it"; fi
copy_pen holecredit
expect_green holecredit deliver

# ---- plant: the partial frame, which is not a function ------------------------------------------
copy_pen frame
plant frame 's|  for (s = 1; s <= n; s++) if (!(s in PERM)) { PERM\[s\] = nx; IPERM\[nx\] = s; nx++ }|  for (s = 1; s <= n; s++) if (!(s in PERM)) { PERM[s] = s; IPERM[s] = s }|' partial_frame
out=$(run_pen frame deliver "7,4" "95")
bad=$(printf '%s\n' "$out" | grep '^deliver .*rule=local' | grep -cv 'bail=229')
if [ "$bad" -ge 1 ]
then note ok "a relabel defined on only the target k symbols collides and the reading shows it"
else note RED "the partial frame changed nothing, so the full permutation is unproven"; fi
copy_pen frame
expect_green frame deliver

# ---- plant: the preferred-only candidate list, which makes the retreat incomplete ----------------
copy_pen subgraph
plant subgraph 's|    CAND\[CN\] = dest; SC\[CN\] = ((dest in PS) ? PS\[dest\] + 1000 : -i); CN++ }|    if (!(dest in PS)) continue; CAND[CN] = dest; SC[CN] = PS[dest] + 1000; CN++ }|' preferred_only
out=$(run_pen subgraph deliver "6,3" "75")
bad=$(printf '%s\n' "$out" | grep 'rule=trace' | grep -c 'deadend=[1-9]')
if [ "$bad" -ge 1 ]
then note ok "ranking only the preferred moves leaves a subgraph, and the retreat dead-ends inside it"
else note RED "the preferred-only list changed nothing, so the full neighbourhood is unproven"; fi
copy_pen subgraph
expect_green subgraph deliver

# ---- plant: purity, in a body and on a declaration line -----------------------------------------
copy_pen purebody
plant purebody 's|^function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = 0|function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = D[start]|' purity_body
expect_red purebody 'routing_functions_reading_distance_array=[1-9]' deliver
copy_pen purebody
expect_green purebody deliver

copy_pen puredecl
plant puredecl 's|^function to_frame(p, k,   a, i, out) { split(p, a, ","); out = ""|function to_frame(p, k,   a, i, out, z) { z = D[p]; split(p, a, ","); out = ""|' purity_declaration
expect_red puredecl 'routing_functions_reading_distance_array=[1-9]' deliver
copy_pen puredecl
expect_green puredecl deliver

# ---- the purity WORD BOUNDARY, proven from the side that would refuse a clean file ---------------
# `CAND[` ends in the same two characters as the distance array. The first draft of this check read
# a bare `D[`, counted eleven hits in a file with none, and refused every run. A looser pattern is a
# guard that cries wolf, which is the shape a hand switches off.
if printf '%s\n' "$TREE" | grep -q 'purity routing_functions_reading_distance_array=0'
then note ok "the clean scan reads zero -- CAND[ is not mistaken for the distance array"
else note RED "the clean scan does not read zero, so the boundary is too loose"; fi
copy_pen boundary
plant boundary 's%^    if (fn == "rule" .*hits++ }%    if (fn == "rule" \&\& line ~ /D\\[/) hits++ }%' loose_boundary
expect_red boundary 'routing_functions_reading_distance_array=[1-9]' deliver
copy_pen boundary
expect_green boundary deliver

# ---- the reduced-run labels, so a cheap reading can never pass for the full one -------------------
for lbl in 'legs=' 'targets=' 'sizes=' 'fill='; do
  if printf '%s\n' "$TREE" | grep -q "^$lbl"
  then note ok "reduced runs print $lbl so they cannot be mistaken for a full pass"
  else note RED "no $lbl line"; fi
done

# ---- a plant that lands nowhere is a fault, proven by aiming one at a line that does not exist ----
copy_pen nowhere
if plant_apply "$PEN/nowhere.sh" 's|function this_function_has_never_existed(|function x(|' deliberate_miss 2>/dev/null
then note RED "a plant matching nothing reported success"
else note ok "a plant matching nothing refuses by name rather than reading as a passing law"; fi

# ---- the exit code, because a verdict word nobody acts on is prose --------------------------------
copy_pen exitcode
plant exitcode 's|^function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = 0|function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = D[start]|' exit_code
SCAN_LEGS=deliver SCAN_SIZES="$PSIZ" SCAN_FILL="$PFILL" sh "$PEN/exitcode.sh" >/dev/null 2>&1
if [ "$?" -ne 0 ]; then note ok "a refused run exits non-zero"
else note RED "a refused run exited zero"; fi

printf 'behaviors=%d passed=%d failed=%d\n' "$((pass+fail))" "$pass" "$fail"
printf 'control_verdict=%s\n' "$([ "$fail" -eq 0 ] && echo ok || echo refused)"
[ "$fail" -eq 0 ]
