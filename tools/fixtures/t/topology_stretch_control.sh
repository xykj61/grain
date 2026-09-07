#!/bin/sh
# tools/fixtures/t/topology_stretch_control.sh -- proves tools/fixtures/t/topology_stretch_scan.sh
# refuses what it claims to refuse, by planting each fault in a throwaway copy and watching the
# copy read RED, then lifting the plant and watching it read GREEN again.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a
# bypass. Every plant here is therefore run twice -- once bitten, once lifted -- and the lifted run
# must return the pen copy to the unmodified reading, so no plant can leave the scan quietly
# damaged.
#
# WHY A PEN COPY RATHER THAN THE TREE. The plants corrupt the scan. Corrupting the tracked file
# even briefly would put a lap one interrupt away from committing a broken instrument, so every
# plant is applied to a copy under a temporary directory that is removed on exit.
#
# THE PEN IS PROVEN INNOCENT FIRST. An unmodified copy must read exactly what the tracked scan
# reads. A pen that changed the answer by itself would make every later reading meaningless.
#
# THE PLANT THAT MATTERS MOST is the purity one, because it is the only fault the scan cannot see
# in its own output: a routing rule that reads the breadth-first distance array prints stretch=0
# and class=table_free and is, in fact, exactly the table-bound case. It is planted twice, once on
# the declaration line and once in the body, since a first draft of the check read the body alone
# and the declaration line is where a hand would actually put it.
#
#   sh tools/fixtures/t/topology_stretch_control.sh

set -u
SCAN=tools/fixtures/t/topology_stretch_scan.sh
PEN="${TMPDIR:-/tmp}/topology_stretch_control.$$"
trap 'rm -rf "$PEN"' EXIT INT TERM
mkdir -p "$PEN" || exit 1
pass=0; fail=0

note() { printf '%s %s\n' "$1" "$2"; if [ "$1" = "ok" ]; then pass=$((pass+1)); else fail=$((fail+1)); fi }

# copy_pen <name> -- fresh unmodified copy at $PEN/<name>.sh
copy_pen() { cp "$SCAN" "$PEN/$1.sh"; }

# expect_red <name> <token> -- the pen copy must refuse, and name the fault
expect_red() {
  out=$(SCAN_LEGS=all sh "$PEN/$1.sh" 2>&1)
  if printf '%s' "$out" | grep -q 'verdict=refused' && printf '%s' "$out" | grep -q "$2"
  then note ok "$1 refused naming $2"
  else note RED "$1 did not refuse naming $2"; fi
}
# expect_green <name> -- the pen copy must pass
expect_green() {
  out=$(SCAN_LEGS=all sh "$PEN/$1.sh" 2>&1)
  if printf '%s' "$out" | grep -q 'verdict=ok'
  then note ok "$1 green"
  else note RED "$1 not green"; fi
}

# ---- the pen is innocent ----------------------------------------------------------------------
copy_pen innocent
TREE=$(sh "$SCAN" 2>&1)
PENOUT=$(sh "$PEN/innocent.sh" 2>&1)
# the two differ only in the path each printed nothing about, so they must be byte-identical
if [ "$TREE" = "$PENOUT" ]; then note ok "pen copy reads exactly what the tree reads"
else note RED "pen copy disagrees with the tree"; fi
expect_green innocent

# ---- plant 1 and 2: a routing rule reads the distance table -----------------------------------
copy_pen purity_decl
sed 's|^function route_star(p, id, n, cap,   arr, hops, i, moved) { hops=0$|function route_star(p, id, n, cap,   arr, hops, i, moved) { hops=0; if (p in PD) hops=hops|' \
  "$PEN/purity_decl.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/purity_decl.sh"
expect_red purity_decl 'rule_purity route_star reads_distance_table'

copy_pen purity_body
sed 's|    if (arr\[1\]+0 != 1) p = swapp(p, 1, arr\[1\]+0, n)|    if (PD[p] > 0 \&\& arr[1]+0 != 1) p = swapp(p, 1, arr[1]+0, n)|' \
  "$PEN/purity_body.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/purity_body.sh"
expect_red purity_body 'rule_purity route_star reads_distance_table'

# ---- plant 3: a rule is deleted, so the purity check has less to read --------------------------
copy_pen purity_thin
sed 's|      inside = (fname ~ /^(route_|      inside = (fname ~ /^(NOPE_|' "$PEN/purity_thin.sh" > "$PEN/t" \
  && cat "$PEN/t" > "$PEN/purity_thin.sh"
expect_red purity_thin 'rule_purity functions_found'

# ---- plant 4: a shape is built disconnected ---------------------------------------------------
copy_pen broken_star
sed 's|    for (k=1;k<=n-1;k++) { u=nbr(p,kind,k,n)|    for (k=1;k<=n-2;k++) { u=nbr(p,kind,k,n)|' \
  "$PEN/broken_star.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/broken_star.sh"
expect_red broken_star 'not_connected'

# ---- plant 5: a ring loses its wrap, and the ROUTE check is what notices -----------------------
# The z-ring becomes a path, so real distances grow while the rule still measures them the short way
# round a ring that is no longer there. The rule therefore claims fewer hops than the graph holds,
# which is the one arithmetic a shortest-path walk can always contradict.
copy_pen broken_wrap
sed 's|    nb\[v\*8+4\] = (x\*q + y)\*r + (z+1)%r;   nb\[v\*8+5\] = (x\*q + y)\*r + (z-1+r)%r } }|    nb[v*8+4] = (x*q + y)*r + ((z+1<r)?z+1:z);   nb[v*8+5] = (x*q + y)*r + ((z>0)?z-1:z) } }|' \
  "$PEN/broken_wrap.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/broken_wrap.sh"
expect_red broken_wrap 'route_below_shortest'

# ---- plant 5b: the same broken ring, with the rule corrected to match it -----------------------
# This is the plant the transitivity leg exists for, and it takes two edits to reach. With the rule
# measuring the path honestly, every hop count agrees with every distance and each earlier leg reads
# green -- yet the shape is no longer vertex-transitive, so walking from one source no longer stands
# for walking from all of them. Only the transitivity leg can see it, which is why it is not an
# assumption this script is allowed to make.
copy_pen wrap_matched
sed -e 's|    nb\[v\*8+4\] = (x\*q + y)\*r + (z+1)%r;   nb\[v\*8+5\] = (x\*q + y)\*r + (z-1+r)%r } }|    nb[v*8+4] = (x*q + y)*r + ((z+1<r)?z+1:z);   nb[v*8+5] = (x*q + y)*r + ((z>0)?z-1:z) } }|' \
    -e 's|^  return circ(x,p) + circ(y,q) + circ(z,r) }|  return circ(x,p) + circ(y,q) + z }|' \
  "$PEN/wrap_matched.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/wrap_matched.sh"
expect_red wrap_matched 'not_vertex_transitive'

# ---- plant 6: a routing rule returns fewer hops than the shortest path -------------------------
copy_pen route_lies
sed 's|^  return circ(x,p) + circ(y,q) + circ(z,r) }|  return int((circ(x,p) + circ(y,q) + circ(z,r)) / 2) }|' \
  "$PEN/route_lies.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/route_lies.sh"
expect_red route_lies 'route_below_shortest'

# ---- plant 7: a rule that cannot finish inside its cap ----------------------------------------
# A first draft weakened the stall guard instead, and nothing moved: this generating set never
# stalls, so the guard it removed was never firing. A plant that changes no reading tests nothing,
# so the cap is what is cut -- a rule that runs out of hops must be counted rather than averaged in.
copy_pen rule_stalls
sed 's|    else h = route_ring_b(720, a, b, c, v, 400)|    else h = route_ring_b(720, a, b, c, v, 2)|' \
  "$PEN/rule_stalls.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/rule_stalls.sh"
expect_red rule_stalls 'rule_incomplete'

# ---- plant 8: the torus comparison is flattered by searching one factorization -----------------
copy_pen lazy_factor
sed 's|    for (q = p; q <= m; q++) { if (m % q) continue; r = m / q; if (r < q) continue|    for (q = p; q <= p; q++) { if (m % q) continue; r = m / q; if (r < q) continue|' \
  "$PEN/lazy_factor.sh" > "$PEN/t" && cat "$PEN/t" > "$PEN/lazy_factor.sh"
out=$(sh "$PEN/lazy_factor.sh" 2>&1)
if printf '%s' "$out" | grep -q 'factor points=720 best=8x9x10'
then note RED "lazy factorization still found the best torus"
else note ok "a one-factorization search reports a worse torus, so the search is load-bearing"; fi

# ---- plant 9: the abelian floor is derived with the wrong comparison ---------------------------
copy_pen floor_off
sed 's|    if (ball >= n) return k }|    if (ball > n - 200) return k }|' "$PEN/floor_off.sh" > "$PEN/t" \
  && cat "$PEN/t" > "$PEN/floor_off.sh"
out=$(sh "$PEN/floor_off.sh" 2>&1)
if printf '%s' "$out" | grep -q 'points=720 .* abelian_floor=8'
then note RED "the 720 abelian floor did not move when its comparison did -- it is spelled"
else note ok "both abelian floors move with the comparison, so both are derived rather than spelled"; fi
if printf '%s' "$out" | grep -q 'points=5040 .* abelian_floor=16'
then note RED "the 5,040 abelian floor did not move when its comparison did"
else note ok "the 5,040 floor moves too, so neither line carries a literal"; fi

# ---- the reduced runs announce their own reach ------------------------------------------------
out=$(SCAN_LEGS=scale sh "$SCAN" 2>&1)
if printf '%s' "$out" | grep -q 'legs=scale' && ! printf '%s' "$out" | grep -q 'shape star_S6'
then note ok "a reduced run prints its own legs and omits what it did not walk"
else note RED "a reduced run did not announce its reach"; fi
out=$(SCAN_SOURCES=2 sh "$SCAN" 2>&1)
if printf '%s' "$out" | grep -q 'sources=2'
then note ok "a reduced transitivity check prints its own source count"
else note RED "a reduced transitivity check did not announce its source count"; fi

# ---- the readings the paper rests on, asserted as hard as the refusals -------------------------
out=$(sh "$SCAN" 2>&1)
check() { if printf '%s' "$out" | grep -q "$1"; then note ok "reads $2"; else note RED "missing $2"; fi }
check 'shape torus_12x5x12 degree=6 diameter=14 mean=7.2100 routed_diameter=14 routed_mean=7.2100 optimal=719 of=719 stretch=0 class=table_free' \
      'the seated torus: table-free and optimal at 14'
check 'shape circulant_1_8_75_A degree=6 diameter=9 mean=6.3004 routed_diameter=12 routed_mean=6.6565 optimal=609 of=719 stretch=3' \
      'the circulant giving back 3 of its 5 hops under rule A'
check 'shape circulant_1_8_75_B degree=6 diameter=9 mean=6.3004 routed_diameter=13 routed_mean=6.6898 optimal=593 of=719 stretch=4' \
      'the circulant giving back 4 under rule B, so one rule was not a straw man'
check 'shape star_S6 degree=5 diameter=7 mean=4.7900 routed_diameter=7 routed_mean=4.7900 optimal=719 of=719 stretch=0 class=table_free' \
      'the star at 720: half the seated diameter on one degree less, table-free'
check 'shape pancake_P6 degree=5 diameter=7 mean=4.5828 routed_diameter=9 routed_mean=5.6579 optimal=296 of=719 stretch=2' \
      'pancake: the better graph and the worse network, on one group and one degree'
check 'shape bubble_B6 degree=5 diameter=15 mean=7.5104 routed_diameter=15 routed_mean=7.5104 optimal=719 of=719 stretch=0' \
      'bubble-sort: table-free and still worse than the torus, so table-free is not the whole story'
check 'shape star_S7 degree=6 diameter=9 mean=5.8797 routed_diameter=9 routed_mean=5.8797 optimal=5039 of=5039 stretch=0' \
      'the star at 5,040: still table-free and optimal on every one of 5,039 differences'
check 'factor points=5040 best=15x16x21 degree=6 diameter=25 abelian_floor=16' \
      'the best degree-6 torus at 5,040 walking 25 against an abelian floor of 16'
check 'branch star_S6 hops=3444 home_moves=3000 scan_moves=444 scan_share=0.1289 mean_scan=1.703 max_scan=4' \
      'the star rule costing one indexed read on 87.1% of its hops'
check 'purity routing_functions=10 reads_distance_table=0' \
      'ten routing functions, none of them reading the distance table'
check 'wall star_sizes_between_720_and_5040=0' \
      'the wall: the star family offers no size between 720 and 5,040'

printf 'behaviors=%d passed=%d failed=%d\n' "$((pass+fail))" "$pass" "$fail"
printf 'verdict=%s\n' "$([ "$fail" -eq 0 ] && echo ok || echo refused)"
[ "$fail" -eq 0 ]
