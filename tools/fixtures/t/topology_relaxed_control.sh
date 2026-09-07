#!/bin/sh
# tools/fixtures/t/topology_relaxed_control.sh -- proves tools/fixtures/t/topology_relaxed_scan.sh
# refuses what it claims to refuse and reports what it claims to report, by planting each fault in
# a throwaway copy and watching the copy read RED, then lifting the plant and watching it read
# GREEN again.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a
# bypass. Every plant here is therefore run twice -- once bitten, once lifted -- and the lifted run
# must return the pen copy to the unmodified reading, so no plant can leave the scan quietly
# damaged.
#
# WHY A PEN COPY RATHER THAN THE TREE. The plants corrupt the scan. Corrupting the tracked file
# even briefly would put a lap one interrupt away from committing a broken instrument, so every
# plant is applied to a copy under a temporary directory named with this process id -- a constant
# name would be a second ship's file on a pier that eight of them share -- and removed on exit.
#
# THE PEN IS PROVEN INNOCENT FIRST. An unmodified copy must read exactly what the tracked scan
# reads. A pen that changed the answer by itself would make every later reading meaningless.
#
# THE THREE PLANTS THAT MATTER MOST, and why each is here:
#
#   PURITY, because it is the only fault the scan cannot see in its own output. A rule that reads
#   the breadth-first distance array prints stretch=0 and optimal=all and is, in fact, the
#   table-bound case wearing the table-free answer. Planted three ways -- in a body, on the
#   declaration line where a hand would actually put it, and by DELETING a rule so the check
#   passes with nothing left to read.
#
#   THE COMMENT EXEMPTION, because it is a hole a plant could hide in. The purity check skips
#   comment lines, since a comment cannot execute. That exemption is proven from both sides: a
#   comment naming the distance array must NOT refuse, and the same text one line lower, as code,
#   must.
#
#   THE ANCHOR, because the whole scan rests on it. S(6,5) and S(7,6) are the star graphs the
#   sibling paper already measured at 720 and 5,040 points. If this script's builder drifted, its
#   own two anchors would stop reproducing 7 and 9, and every other number here would be a
#   measurement of the wrong graph.
#
#   sh tools/fixtures/t/topology_relaxed_control.sh

set -u

# THE PLANTS ARE APPLIED THROUGH `plant.sh`, FOR TWO REASONS AT ONCE. A bare `sed -i` is a GNU
# spelling that BSD reads as a backup suffix, which the tree's own portability gate holds at zero;
# and a `sed` naming a literal line is a CLAIM that the line is spelled that way today, which is
# the one part of a control nothing checks. When a line moves, the plant matches nothing, the copy
# runs unmutated, and the phase reads green for a fault it never planted -- which happened here
# while this file was being written, when a rename plant rewrote the checker's own two string
# literals and proved nothing. `plant_apply` refuses by name when a plant lands nowhere.
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

SCAN=tools/fixtures/t/topology_relaxed_scan.sh
PEN="${TMPDIR:-/tmp}/topology_relaxed_control.$$"
trap 'rm -rf "$PEN"' EXIT INT TERM
mkdir -p "$PEN" || exit 1
pass=0; fail=0

note() { printf '%s %s\n' "$1" "$2"; if [ "$1" = "ok" ]; then pass=$((pass+1)); else fail=$((fail+1)); fi }
copy_pen() { cp "$SCAN" "$PEN/$1.sh"; }
# plant <name> <sed-program> <label> -- rewrite the pen copy in place, portably, and count a plant
# that matched nothing as a fault rather than letting it read as a passing law.
plant() {
  if plant_apply "$PEN/$1.sh" "$2" "$3"; then note ok "plant $3 landed"
  else note RED "plant $3 matched nothing -- the line it names has moved"; fi
}
# A plant is read at ONE small size rather than at all thirteen. The scan's own `SCAN_SIZES` knob
# makes a planted run cost fifty milliseconds instead of ten seconds, which is what lets every
# refusal here be shown from both sides rather than only from the side that fires.
PSIZ="6,3"
run_pen() { SCAN_LEGS="${2:-all}" SCAN_SIZES="${3:-$PSIZ}" sh "$PEN/$1.sh" 2>&1; }
run_full() { sh "$PEN/$1.sh" 2>&1; }

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

# ---- the pen is innocent ----------------------------------------------------------------------
copy_pen innocent
TREE=$(sh "$SCAN" 2>&1)
PENOUT=$(run_full innocent)
if [ "$TREE" = "$PENOUT" ]; then note ok "pen copy reads exactly what the tree reads"
else note RED "pen copy disagrees with the tree"; fi
out=$(run_full innocent)
if printf '%s' "$out" | grep -q 'verdict=ok'; then note ok "innocent green over the full thirteen sizes"
else note RED "innocent not green"; fi

# ---- the anchor: the two star graphs the sibling paper already measured ------------------------
if printf '%s\n' "$TREE" | grep -q 'nkstar n=6 k=5 points=720 degree=5 diameter=7 rule=chain rule_diameter=7 stretch=0 optimal=720/720'
then note ok "anchor S(6,5) reproduces the sibling star reading -- 720 points, degree 5, diameter 7, routed whole"
else note RED "anchor S(6,5) does not reproduce 720/5/7"; fi
if printf '%s\n' "$TREE" | grep -q 'nkstar n=7 k=6 points=5040 degree=6 diameter=9 rule=chain rule_diameter=9 stretch=0 optimal=5040/5040'
then note ok "anchor S(7,6) reproduces the sibling star reading -- 5,040 points, degree 6, diameter 9, routed whole"
else note RED "anchor S(7,6) does not reproduce 5040/6/9"; fi

# ---- the finding, stated as a pair of readings that must both hold ------------------------------
# The naive rule is exact at k = n-1 and gives hops back at every k below it. Both halves are
# asserted, because "the naive rule fails" proven only where it fails would not tell a reader
# whether the rule was ever right.
if printf '%s\n' "$TREE" | grep 'rule=naive' | grep 'k=5 points=720' | grep -q 'stretch=0'
then note ok "naive rule is exact at k=n-1, where the family is the star graph"
else note RED "naive rule not exact at k=n-1"; fi
naive_bad=$(printf '%s\n' "$TREE" | grep 'rule=naive' | grep -vc 'stretch=0')
if [ "$naive_bad" -ge 9 ]
then note ok "naive rule gives hops back at $naive_bad of the eleven sizes below k=n-1"
else note RED "naive rule stretch positive at only $naive_bad sizes, expected 9 or more"; fi
chain_bad=$(printf '%s\n' "$TREE" | grep 'rule=chain' | grep -cv 'stretch=0 optimal=\([0-9]*\)/\1 ')
if [ "$chain_bad" -eq 0 ]
then note ok "chain rule routes every vertex of every size by a shortest path"
else note RED "chain rule suboptimal on $chain_bad sizes"; fi
door_res=$(printf '%s\n' "$TREE" | grep 'rule=door' | grep -cv 'optimal=\([0-9]*\)/\1 ')
if [ "$door_res" -ge 1 ]
then note ok "door rule leaves a measured residue on $door_res size(s) -- the chain rule is not decoration"
else note RED "door rule leaves no residue, so the chain step is unmotivated"; fi

# ---- the summary line is a count of the legs above, not a second opinion ------------------------
# A summary that disagreed with the lines it summarises would be the worst kind of green, so it is
# checked against them rather than merely read.
star_lines=$(printf '%s\n' "$TREE" | grep -c '^nkstar ')
arr_lines=$(printf '%s\n' "$TREE" | grep -c '^arrange ')
sum_line=$(printf '%s\n' "$TREE" | grep '^summary ')
sum_star=$(printf '%s' "$sum_line" | sed 's/.*star_readings=\([0-9]*\).*/\1/')
sum_arr=$(printf '%s' "$sum_line" | sed 's/.*arrangement_readings=\([0-9]*\).*/\1/')
if [ "$star_lines" = "$sum_star" ] && [ "$arr_lines" = "$sum_arr" ]
then note ok "the summary counts exactly the readings printed above it"
else note RED "summary claims $sum_star/$sum_arr readings against $star_lines/$arr_lines printed"; fi
if printf '%s' "$sum_line" | grep -q 'suboptimal_sizes naive=11 door=2 chain=0 hole=0'
then note ok "the summary reads the finding: naive short at 11 sizes, door at 2, chain and hole at none"
else note RED "the summary's per-rule tally moved"; fi

# ---- no vertex goes unrouted, at any size, under any rule --------------------------------------
if printf '%s\n' "$TREE" | grep -q 'unrouted=[1-9]'
then note RED "some vertex hit the hop cap"
else note ok "no vertex hit the hop cap at any size under any rule"; fi

# ---- the window count is derived from the falling factorial, never recited ---------------------
if printf '%s\n' "$TREE" | grep -q 'window between=720_and_5040 star_family_sizes=0 nkstar_sizes=8 bound_n=14'
then note ok "window reports 8 relaxed sizes where the star family offers 0"
else note RED "window count is not 8"; fi
copy_pen window_bound
plant window_bound 's/^  WINDOW_N = 14$/  WINDOW_N = 8/' window_bound
wout=$(run_pen window_bound window "$PSIZ")
if printf '%s' "$wout" | grep -q 'nkstar_sizes=8'
then note RED "window count did not move when its bound moved -- it is a recital"
else note ok "window count moves with its bound, so it is derived rather than spelled"; fi
copy_pen window_bound
expect_green window_bound window

# ---- the abelian floor and the best torus are called, not spelled -------------------------------
if printf '%s\n' "$TREE" | grep -q 'compare points=840 torus=7x8x15 torus_degree=6 torus_diameter=14 abelian_floor_degree6=9'
then note ok "840 points: best three-ring torus walks 14 on degree 6, abelian floor 9"
else note RED "840 comparison line changed"; fi
copy_pen floor_moved
plant floor_moved 's|ball = (4\*k\*k\*k + 6\*k\*k + 8\*k + 3) / 3|ball = (4*k*k*k + 6*k*k + 8*k + 3) / 6|' floor_moved
fout=$(run_pen floor_moved compare "$PSIZ")
if printf '%s' "$fout" | grep -q 'abelian_floor_degree6=9'
then note RED "abelian floor did not move when its closed form moved -- it is a recital"
else note ok "abelian floor moves with its closed form, so it is derived"; fi
copy_pen floor_moved
expect_green floor_moved compare

# ---- purity: three plants, each lifted ----------------------------------------------------------
copy_pen purity_body
plant purity_body 's|^function route_arr(n, k, p,   hops|function route_arr(n, k, p,   dd, hops|' purity_body
plant purity_body 's|^  cap = 3 \* k + 4; hops = 0$|  cap = 3 * k + 4; hops = 0; if (p in D) dd = 1|' purity_body_2
expect_red purity_body reads_distance_table
copy_pen purity_body
expect_green purity_body

copy_pen purity_decl
plant purity_decl 's|^function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = 0$|function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = 0; if (start in D) cur = start|' purity_decl
expect_red purity_decl reads_distance_table
copy_pen purity_decl
expect_green purity_decl

# The rules are renamed at their DEFINITIONS AND their call sites, so the script still parses and
# still prints a verdict. A plant that merely broke the file would prove nothing about the check:
# a scan that cannot run is not a scan that passed.
copy_pen purity_deleted
plant purity_deleted 's/route_arr/gone_arr/g; s/terminus/gone_terminus/g' purity_deleted
# AND THE PLANT MUST NOT EDIT THE CHECKER. A blind rename rewrote the filter's own two string
# literals, so the check went on admitting the renamed rules and the plant proved nothing. The
# filter line is restored to the tracked text before the copy is read.
plant purity_deleted 's|fname == "gone_terminus"|fname == "terminus"|' purity_deleted_2
expect_red purity_deleted functions_found
copy_pen purity_deleted
expect_green purity_deleted

# ---- the comment exemption, proven from both sides ----------------------------------------------
copy_pen purity_comment
plant purity_comment 's|^  cap = 6 \* k + 8; hops = 0$|  # a comment naming D must not refuse, since a comment cannot execute\n  cap = 6 * k + 8; hops = 0|' purity_comment
expect_green purity_comment
copy_pen purity_comment_code
plant purity_comment_code 's|^  cap = 6 \* k + 8; hops = 0$|  cap = 6 * k + 8; hops = 0; if (p in D) cap = cap|' purity_comment_code
expect_red purity_comment_code reads_distance_table

# ---- transitivity: the leg must bite when the graph stops being vertex-transitive ---------------
copy_pen transit_broken
plant transit_broken 's|^  for (i = 2; i <= k; i++) NBB\[cnt++\] = swap_one(k, a, i)$|  for (i = 2; i <= k; i++) if (p != "01,02,03,") NBB[cnt++] = swap_one(k, a, i)|' transit_broken
expect_red transit_broken not_vertex_transitive
copy_pen transit_broken
expect_green transit_broken

# ---- the stride is coprime to the vertex count at every size -------------------------------------
bad_stride=0
printf '%s\n' "$TREE" | grep '^transit ' | while read -r _ _ _ _ pts st _; do :; done
for line in $(printf '%s\n' "$TREE" | grep '^transit ' | sed 's/.*points=\([0-9]*\) stride=\([0-9]*\).*/\1:\2/'); do
  pts=${line%%:*}; st=${line##*:}
  if [ "$st" -le 1 ] || [ $((pts % st)) -eq 0 ]; then bad_stride=$((bad_stride+1)); fi
done
if [ "$bad_stride" -eq 0 ]
then note ok "every transitivity stride is above one and coprime to its vertex count"
else note RED "$bad_stride transitivity strides align with a factor of the graph"; fi

# ---- the arrangement family routes optimally under its own rule ----------------------------------
arr_bad=$(printf '%s\n' "$TREE" | grep '^arrange ' | grep -cv 'stretch=0 optimal=\([0-9]*\)/\1 ')
arr_n=$(printf '%s\n' "$TREE" | grep -c '^arrange ')
if [ "$arr_bad" -eq 0 ] && [ "$arr_n" -eq 4 ]
then note ok "all four arrangement graphs route optimally under the hole rule"
else note RED "arrangement leg: $arr_bad of $arr_n suboptimal"; fi

# ---- the chain rule's cost is bounded by k, which is what table-free means here -------------------
br_bad=0
for line in $(printf '%s\n' "$TREE" | grep '^branch ' | sed 's/.*max_candidates=\([0-9]*\) bound=k=\([0-9]*\)/\1:\2/'); do
  mx=${line%%:*}; kk=${line##*:}
  [ "$mx" -le "$kk" ] || br_bad=$((br_bad+1))
done
if [ "$br_bad" -eq 0 ]
then note ok "the chain rule never scans more candidates than the address is long"
else note RED "$br_bad branch readings exceed their own bound"; fi

# ---- a reduced run announces itself, so it cannot be read as a full one ---------------------------
rout=$(run_pen innocent window "$PSIZ")
if printf '%s' "$rout" | grep -q '^legs=window' && ! printf '%s' "$rout" | grep -q '^nkstar '
then note ok "a reduced run prints its legs and omits what it did not measure"
else note RED "reduced run does not announce itself"; fi
sout=$(SCAN_SOURCES=3 SCAN_SIZES="$PSIZ" sh "$PEN/innocent.sh" 2>&1)
if printf '%s' "$sout" | grep -q '^sources=3' && printf '%s' "$sout" | grep -q 'sources=2 agree=2'
then note ok "the sources knob is honored and printed"
else note RED "sources knob not honored"; fi

# ---- a refusal leaves a nonzero exit status --------------------------------------------------------
copy_pen exit_status
plant exit_status 's|^  cap = 3 \* k + 4; hops = 0$|  cap = 3 * k + 4; hops = 0; if (p in D) cap = cap|' exit_status
if SCAN_SIZES="$PSIZ" sh "$PEN/exit_status.sh" >/dev/null 2>&1
then note RED "a refused run exited zero"
else note ok "a refused run exits nonzero"; fi

printf 'behaviors=%d passed=%d failed=%d\n' "$((pass+fail))" "$pass" "$fail"
[ "$fail" -eq 0 ] || exit 1
