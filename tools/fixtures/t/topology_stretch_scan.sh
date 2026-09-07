#!/bin/sh
# tools/fixtures/t/topology_stretch_scan.sh -- a diameter is a promise about a road; this asks
# whether a router can find that road without being handed a map.
#
# WHY. Its sibling `topology_attained_scan.sh` measured what diameter a hand can BUILD on 720
# points, and found a circulant that walks 9 where the seated three-ring torus walks 14. That
# reading is true and it is half an answer. A shortest path exists in a graph the moment the graph
# does; a packet still has to be told which edge to take, and the two shapes answer that question
# in very different ways. A torus subtracts coordinates -- the next hop is arithmetic on the
# destination address, and it needs nothing precomputed. A circulant's shortest path is not a
# closed form in anything, so reaching its diameter means consulting a table someone built by
# walking the whole graph first. This script prices that difference in the same unit the diameter
# is quoted in: HOPS.
#
# THE DISTINCTION, stated once. A rule is TABLE-FREE when the next hop is computed from the two
# addresses and the generating set alone, in work bounded by the degree, with nothing precomputed
# per topology. A rule is TABLE-BOUND when it reads an entry indexed by the difference between the
# addresses -- 719 entries here, three bits apiece, 270 bytes, which is cheap in memory and is not
# where its cost lives. The cost is that the table is built by a breadth-first walk of the whole
# graph and is specific to one vertex count and one generating set, so a membership change
# invalidates it. A table-free rule survives that change; a table-bound one is recomputed and
# redistributed.
#
# WHAT IT PRINTS, in three legs:
#
#   shape    -- six graphs on 720 points, each built here, walked by breadth-first search, and then
#               ROUTED by a named table-free rule from every one of the 719 differences. It reports
#               the true diameter and mean beside the rule's diameter and mean, the count of
#               differences the rule routes optimally, and the STRETCH -- how many hops the rule
#               gives back. A shape whose stretch is zero publishes a diameter a router can reach
#               with no map; a shape with positive stretch publishes one that must be bought.
#
#               The rules, named so a reader can check them rather than trust them. Torus: reduce
#               each coordinate the short way round its own ring, any axis, any order. Circulant,
#               two rules because one would be a straw man -- (A) take the generator leaving the
#               smallest residual circular distance, (B) take the largest generator that does not
#               overshoot. Star: if position one holds a symbol that is not its own, swap it home;
#               otherwise swap in any misplaced symbol. Pancake: bring the largest out-of-place
#               symbol to the front, then flip it home. Bubble-sort: swap any adjacent pair out of
#               order, which is bubble sort and takes exactly the inversion count.
#
#   transit  -- the vertex-transitivity check that lets the shape leg walk from one source instead
#               of 720. Every graph here is Cayley and therefore vertex-transitive, so the distance
#               multiset from any vertex is the same -- yet that is a claim ABOUT the graph, and a
#               leg that assumed it would be assuming exactly what a build error would break. Six
#               sources per shape, eccentricity and distance sum compared against vertex zero.
#
#               THE SOURCES ARE SPREAD BY A COPRIME STRIDE, and that is the whole reason this leg
#               works. A first draft picked them at `i * 720 / SOURCES`, which is 120, 240, 360 and
#               so on -- every one a multiple of the twelve-long third ring, so every source sat at
#               the same z. A plant that turned that ring into a path was invisible to all six of
#               them. A sampler aligned to the period of the thing it samples is blind along that
#               period, so the stride is 271, which shares no factor with 720.
#
#   scale    -- one second point on the curve, at 5,040 = 7! points. Both abelian floors on this
#               leg are CALLED rather than spelled: a first draft printed `abelian_floor=8` as a
#               literal for the 720 line, because the answer was already known, and its own control
#               caught it -- a number that cannot move when its derivation moves is a recital. The star graph's vertex count
#               is a factorial and admits no size between 720 and 5,040, which is the family's real
#               wall and is reported rather than buried. The best degree-6 three-ring torus at each
#               size is found by searching every three-factorization rather than by picking one.
#
# WHAT IS MEASURED AND WHAT IS DERIVED. Every diameter, mean, stretch and branch count is MEASURED
# on a graph this script builds and routes. The abelian floor carried in the scale leg is DERIVED,
# by the closed form its sibling `topology_attained_scan.sh` checks against a direct enumeration at
# every radius; it is quoted here rather than re-derived. Nothing here implements anything --
# `comlink/topology.rye` publishes the seated three-ring reading and no other shape on this list.
# Two Rooms: these are numbers a design argument may cite, not a behavior the tree performs.
#
# THE COVERAGE GAPS, NAMED. First, table-free is measured by exhibiting rules rather than by
# proving none better exists: two rules are run on the circulant and both give back three hops or
# more, which bounds what THOSE rules reach and leaves open whether some third rule reaches 9. That
# is this script's own falsifier and it is cheap to fire -- a rule reaching diameter 9 on
# C_720(1,8,75) refutes the circulant reading here. Second, the star rule is proven optimal by
# exhaustion at 720 and 5,040 points; 40,320 is not walked, so "optimal" is bounded by those two
# sizes. Third, hops are counted and instructions are not: the branch measurement in the shape leg
# reports how much work each hop of the star rule costs, which is the nearest this script comes to
# a wall-clock reading and is not one.
#
# COST. Measured `20260906.173015` on this pier: under a second for the 720 legs and under a second
# for 5,040, since vertex-transitivity is checked rather than paid for. Its witness is `tier lap`.
#
# TWO KNOBS. `SCAN_LEGS` (shapes|scale|all, default all) and `SCAN_SOURCES` (default 6) bound the
# transitivity check. Every reduced run PRINTS `legs=` and `sources=` on its own line, so a reduced
# reading can never be mistaken for a full one; the witness runs the default and binds the full
# numbers.
#
#   sh tools/fixtures/t/topology_stretch_scan.sh
#   SCAN_LEGS=scale sh tools/fixtures/t/topology_stretch_scan.sh

set -u
LEGS="${SCAN_LEGS:-all}"
SOURCES="${SCAN_SOURCES:-6}"

awk -v LEGS="$LEGS" -v SOURCES="$SOURCES" -v SELF="$0" 'BEGIN {
  N = 720
  bad = 0
  printf "legs=%s\n", LEGS
  printf "sources=%d\n", SOURCES

  if (LEGS == "all" || LEGS == "shapes") {
    # ---- leg one: six shapes on 720 points, walked and then routed ---------------------------
    delete NB; torus(12,5,12,NB)
    report_ring("torus_12x5x12", 6, NB, "torus", 12,5,12)
    delete NB; torus(8,9,10,NB)
    report_ring("torus_8x9x10", 6, NB, "torus", 8,9,10)
    delete NB; circulant(N,1,8,75,NB)
    report_ring("circulant_1_8_75_A", 6, NB, "ringA", 1,8,75)
    delete NB; circulant(N,1,8,75,NB)
    report_ring("circulant_1_8_75_B", 6, NB, "ringB", 1,8,75)
    report_perm("star_S6", 6, "star")
    report_perm("pancake_P6", 6, "pancake")
    report_perm("bubble_B6", 6, "bubble")
    branch_cost(6)
  }

  if (LEGS == "all" || LEGS == "scale") {
    # ---- leg three: one second point on the curve, at 5,040 = 7! ------------------------------
    report_perm("star_S7", 7, "star")
    branch_cost(7)
    best_torus(720);  printf "factor points=720 best=%dx%dx%d degree=6 diameter=%d abelian_floor=%d\n", BP,BQ,BR,BD, abelian_floor(720)
    best_torus(5040); printf "factor points=5040 best=%dx%dx%d degree=6 diameter=%d abelian_floor=%d\n", BP,BQ,BR,BD, abelian_floor(5040)
    printf "wall star_sizes_between_720_and_5040=0 reason=vertex_count_is_a_factorial\n"
  }

  if (rule_purity(SELF) < 0) bad++
  printf "refusals=%d\n", bad
  printf "verdict=%s\n", (bad ? "refused" : "ok")
  exit (bad ? 1 : 0)
}

function circ(x, n) { x = ((x % n) + n) % n; return (x < n - x) ? x : n - x }

# ---- builders. Each writes an integer neighbour table, eight slots per vertex ------------------
function torus(p, q, r, nb,   x, y, z, v) {
  for (x = 0; x < p; x++) for (y = 0; y < q; y++) for (z = 0; z < r; z++) {
    v = (x*q + y)*r + z
    nb[v*8+0] = (((x+1)%p)*q + y)*r + z; nb[v*8+1] = (((x-1+p)%p)*q + y)*r + z
    nb[v*8+2] = (x*q + (y+1)%q)*r + z;   nb[v*8+3] = (x*q + (y-1+q)%q)*r + z
    nb[v*8+4] = (x*q + y)*r + (z+1)%r;   nb[v*8+5] = (x*q + y)*r + (z-1+r)%r } }
function circulant(n, a, b, c, nb,   v) {
  for (v = 0; v < n; v++) {
    nb[v*8+0] = (v+a)%n; nb[v*8+1] = (v-a+n)%n
    nb[v*8+2] = (v+b)%n; nb[v*8+3] = (v-b+n)%n
    nb[v*8+4] = (v+c)%n; nb[v*8+5] = (v-c+n)%n } }

# One breadth-first walk. Fills D[] with distances from src and returns the eccentricity, or -1
# when the graph is not connected. SUMD carries the distance sum, which the transitivity leg
# compares across sources -- an equal eccentricity with an unequal sum would still be a build error.
function bfs_int(n, deg, nb, src,   i, q, head, tail, v, k, u, far) {
  for (i = 0; i < n; i++) D[i] = -1
  D[src] = 0; q[0] = src; head = 0; tail = 1; far = 0; SUMD = 0
  while (head < tail) { v = q[head++]
    for (k = 0; k < deg; k++) { u = nb[v*8+k]
      if (D[u] < 0) { D[u] = D[v]+1; SUMD += D[u]; if (D[u] > far) far = D[u]; q[tail++] = u } } }
  for (i = 0; i < n; i++) if (D[i] < 0) return -1
  return far }

# ---- the table-free rules, each a pure function of the difference and the generating set -------
# Torus: reduce each coordinate the short way round its own ring. Any axis, any order, and the
# total is the sum of the three circular distances -- which is the L1 metric on the product, and
# therefore the shortest path. The leg below proves that equality rather than resting on it.
function route_torus(v, p, q, r,   x, y, z) {
  z = v % r; y = int(v/r) % q; x = int(v/(q*r))
  return circ(x,p) + circ(y,q) + circ(z,r) }
# Circulant rule A: step to the generator leaving the smallest residual circular distance.
function route_ring_a(n, a, b, c, d, cap,   hops, best, bestv, cand, cv, i, gg) {
  gg[0]=a; gg[1]=b; gg[2]=c; hops = 0
  while (d != 0) { if (hops > cap) return -1
    bestv = -1; best = -1
    for (i = 0; i < 3; i++) {
      cand = (d - gg[i] + n) % n; cv = circ(cand,n); if (bestv<0||cv<bestv){bestv=cv;best=cand}
      cand = (d + gg[i]) % n;     cv = circ(cand,n); if (bestv<0||cv<bestv){bestv=cv;best=cand} }
    if (bestv >= circ(d,n)) return -2
    d = best; hops++ }
  return hops }
# Circulant rule B: take the largest generator that does not overshoot the short way round.
function route_ring_b(n, a, b, c, d, cap,   hops, i, gg, r0, took, cand) {
  gg[0]=c; gg[1]=b; gg[2]=a; hops = 0
  while (d != 0) { if (hops > cap) return -1
    r0 = circ(d,n); took = 0
    for (i = 0; i < 3; i++) {
      cand = (d - gg[i] + n) % n; if (circ(cand,n) < r0) { d = cand; took = 1; break }
      cand = (d + gg[i]) % n;     if (circ(cand,n) < r0) { d = cand; took = 1; break } }
    if (!took) return -2
    hops++ }
  return hops }

# ---- permutation shapes. A vertex is an arrangement; a generator acts on POSITIONS, which is
# right multiplication in the symmetric group, so routing a vertex to the identity is sorting it.
function swapp(p, a, b, n,   arr, t, i, o) { split(p,arr,""); t=arr[a]; arr[a]=arr[b]; arr[b]=t
  o=""; for (i=1;i<=n;i++) o = o arr[i]; return o }
function revp(p, m, n,   arr, i, o) { split(p,arr,""); o=""
  for (i=m;i>=1;i--) o = o arr[i]; for (i=m+1;i<=n;i++) o = o arr[i]; return o }
function nbr(p, kind, k, n) {
  if (kind=="star")    return swapp(p, 1, k+1, n)
  if (kind=="pancake") return revp(p, k+1, n)
  return swapp(p, k, k+1, n) }
function bfs_perm(n, kind, src,   q, head, tail, p, k, u, far) {
  delete PD; delete PQ; PD[src]=0; q[0]=src; PQ[0]=src; head=0; tail=1; far=0; PSEEN=1; SUMD=0
  while (head<tail) { p=q[head++]
    for (k=1;k<=n-1;k++) { u=nbr(p,kind,k,n)
      if (!(u in PD)) { PD[u]=PD[p]+1; SUMD += PD[u]; if (PD[u]>far) far=PD[u]
                        q[tail]=u; PQ[tail]=u; tail++; PSEEN++ } } }
  return far }
function route_star(p, id, n, cap,   arr, hops, i, moved) { hops=0
  while (p != id) { if (hops>cap) return -1
    split(p,arr,"")
    if (arr[1]+0 != 1) p = swapp(p, 1, arr[1]+0, n)
    else { moved=0; for (i=2;i<=n;i++) if (arr[i]+0 != i) { p = swapp(p,1,i,n); moved=1; break }
           if (!moved) return -2 }
    hops++ }
  return hops }
function route_pancake(p, id, n, cap,   arr, hops, m, j, i) { hops=0
  while (p != id) { if (hops>cap) return -1
    split(p,arr,""); m=0
    for (i=n;i>=1;i--) if (arr[i]+0 != i) { m=i; break }
    if (m==0) return -2
    if (arr[1]+0 == m) p = revp(p, m, n)
    else { for (j=1;j<=n;j++) if (arr[j]+0 == m) { p = revp(p, j, n); break } }
    hops++ }
  return hops }
function route_bubble(p, id, n, cap,   arr, hops, i, took) { hops=0
  while (p != id) { if (hops>cap) return -1
    split(p,arr,""); took=0
    for (i=1;i<=n-1;i++) if (arr[i]+0 > arr[i+1]+0) { p = swapp(p,i,i+1,n); took=1; break }
    if (!took) return -2
    hops++ }
  return hops }

# ---- reporters. Each walks, routes every difference, and prints one line ----------------------
function report_ring(tag, deg, nb, rule, a, b, c,   dia, v, h, w, s, opt, stuck, over, cnt, tsum, i, src, e2) {
  dia = bfs_int(720, deg, nb, 0)
  if (dia < 0) { printf "refused %s not_connected\n", tag; bad++; return }
  tsum = SUMD
  w=0; s=0; opt=0; stuck=0; over=0; cnt=0
  for (v = 1; v < 720; v++) {
    if (rule == "torus") h = route_torus(v, a, b, c)
    else if (rule == "ringA") h = route_ring_a(720, a, b, c, v, 400)
    else h = route_ring_b(720, a, b, c, v, 400)
    if (h == -1) { over++; continue }
    if (h == -2) { stuck++; continue }
    if (h < D[v]) { printf "refused %s route_below_shortest at=%d hops=%d dist=%d\n", tag, v, h, D[v]; bad++; return }
    if (h > w) w = h
    s += h; cnt++
    if (h == D[v]) opt++ }
  if (stuck || over) { printf "refused %s rule_incomplete stuck=%d overran=%d\n", tag, stuck, over; bad++; return }
  printf "shape %s degree=%d diameter=%d mean=%.4f routed_diameter=%d routed_mean=%.4f optimal=%d of=719 stretch=%d class=%s\n", \
    tag, deg, dia, tsum/719, w, s/cnt, opt, w - dia, (w == dia ? "table_free" : "table_bound")
  # transitivity: the shape leg walks from one source, so prove the graph does not care which
  for (i = 1; i < SOURCES; i++) {
    src = (i * 271 + 37) % 720
    e2 = bfs_int(720, deg, nb, src)
    if (e2 != dia || SUMD != tsum) {
      printf "refused %s not_vertex_transitive src=%d ecc=%d want=%d sum=%d want_sum=%d\n", tag, src, e2, dia, SUMD, tsum
      bad++; return } }
  printf "transit %s sources=%d eccentricity=%d distance_sum=%d agreed=yes\n", tag, SOURCES, dia, tsum }

function report_perm(tag, n, kind,   id, i, dia, tsum, w, s, opt, over, stuck, cnt, p, h, cap, src, e2, want) {
  id = ""; for (i = 1; i <= n; i++) id = id i
  want = 1; for (i = 2; i <= n; i++) want = want * i
  dia = bfs_perm(n, kind, id)
  if (PSEEN != want) { printf "refused %s not_connected seen=%d of=%d\n", tag, PSEEN, want; bad++; return }
  tsum = SUMD; cap = 400
  w=0; s=0; opt=0; over=0; stuck=0; cnt=0
  for (i = 1; i < want; i++) { p = PQ[i]
    if (kind == "star")         h = route_star(p, id, n, cap)
    else if (kind == "pancake") h = route_pancake(p, id, n, cap)
    else                        h = route_bubble(p, id, n, cap)
    if (h == -1) { over++; continue }
    if (h == -2) { stuck++; continue }
    if (h < PD[p]) { printf "refused %s route_below_shortest at=%s hops=%d dist=%d\n", tag, p, h, PD[p]; bad++; return }
    if (h > w) w = h
    s += h; cnt++
    if (h == PD[p]) opt++ }
  if (stuck || over) { printf "refused %s rule_incomplete stuck=%d overran=%d\n", tag, stuck, over; bad++; return }
  printf "shape %s degree=%d diameter=%d mean=%.4f routed_diameter=%d routed_mean=%.4f optimal=%d of=%d stretch=%d class=%s\n", \
    tag, n-1, dia, tsum/(want-1), w, s/cnt, opt, want-1, w - dia, (w == dia ? "table_free" : "table_bound")
  for (i = 1; i < SOURCES; i++) {
    src = PQ[(i * 271 + 37) % want]
    e2 = bfs_perm(n, kind, src)
    if (e2 != dia || SUMD != tsum) {
      printf "refused %s not_vertex_transitive src=%s ecc=%d want=%d sum=%d want_sum=%d\n", tag, src, e2, dia, SUMD, tsum
      bad++; return } }
  printf "transit %s sources=%d eccentricity=%d distance_sum=%d agreed=yes\n", tag, SOURCES, dia, tsum
  bfs_perm(n, kind, id) }

# How much work one hop of the star rule costs. The rule has two branches: send the symbol in
# position one to its home, which is a single indexed read, or -- when position one already holds
# its own symbol -- scan for a misplaced position. Only the second branch scans, and this reports
# how often it fires and how far it reaches, so "table-free" is priced rather than asserted.
function branch_cost(n,   id, i, want, p, cur, arr, home, park, scan, smax, hops, sl, moved) {
  id = ""; for (i = 1; i <= n; i++) id = id i
  want = 1; for (i = 2; i <= n; i++) want = want * i
  bfs_perm(n, "star", id)
  # A disconnected walk leaves holes in the queue, and an empty vertex sorts forever. The control
  # found this by hanging: a plant that dropped a generator sent this leg into a loop no cap could
  # reach, since the cap lives in the routing rules and this leg walks the arrangement itself.
  if (PSEEN != want) { printf "refused star_branch_S%d not_connected seen=%d of=%d\n", n, PSEEN, want; bad++; return }
  home=0; park=0; scan=0; smax=0; hops=0
  for (i = 1; i < want; i++) { cur = PQ[i]
    while (cur != id) { split(cur,arr,"")
      if (arr[1]+0 != 1) { cur = swapp(cur,1,arr[1]+0,n); home++ }
      else { sl=0; moved=0
             for (p = 2; p <= n; p++) { sl++; if (arr[p]+0 != p) { cur=swapp(cur,1,p,n); moved=1; break } }
             if (!moved) { printf "refused star_branch_S%d stuck at=%s\n", n, cur; bad++; return }
             park++; scan += sl; if (sl > smax) smax = sl }
      hops++ } }
  printf "branch star_S%d hops=%d home_moves=%d scan_moves=%d scan_share=%.4f mean_scan=%.3f max_scan=%d\n", \
    n, hops, home, park, park/hops, (park ? scan/park : 0), smax }

# The best three-ring torus at a given point count, by searching every three-factorization rather
# than by picking one -- a comparison against a badly chosen torus would flatter the alternative.
function best_torus(n,   p, m, q, r, d) {
  BD = 999999
  for (p = 2; p <= n; p++) { if (n % p) continue; m = n / p
    for (q = p; q <= m; q++) { if (m % q) continue; r = m / q; if (r < q) continue
      d = int(p/2) + int(q/2) + int(r/2)
      if (d < BD) { BD = d; BP = p; BQ = q; BR = r } } } }

# The abelian floor at degree six: the smallest radius whose L1 ball in Z^3 holds n points. The
# closed form is the one `topology_attained_scan.sh` checks against a direct enumeration at every
# radius from 0 to 10, and the widest split at degree six is three inverse pairs, which is why
# three dimensions is the right ball.
function abelian_floor(n,   k, ball) {
  for (k = 0; k < 200; k++) { ball = (4*k*k*k + 6*k*k + 8*k + 3) / 3
    if (ball >= n) return k }
  return -1 }

# TABLE-FREE IS A PROPERTY OF THE RULE, NOT OF ITS OUTPUT, so this leg reads the rule. A routing
# function that secretly consulted the breadth-first distance array would print stretch=0 and
# class=table_free while being the table-bound case wearing the table-free answer -- the one fault
# every other leg here is blind to, since they all read hop counts and a hop count cannot say what
# the rule looked at. So the script opens its own source, isolates the body of each routing
# function and of every helper a rule may reach, and refuses when the bare token `D` or `PD` -- the
# two breadth-first distance arrays -- appears anywhere inside one. Local adjacency is not a table:
# a router knows its own neighbours by definition, and the forbidden thing is the precomputed
# global walk.
#
# THE DECLARATION LINE IS READ TOO. A first draft set the in-function flag and then skipped to the
# next line, so a plant appended to `function route_star(...) {` itself sat in the one place the
# check could not look -- and that is exactly where a hand editing a rule would put it.
#
# The check is a TOKEN match rather than a bracket match, and that is not a style choice. A first
# draft looked for `D[` and a planted rule reading `if (p in PD)` walked straight past it, because
# a set membership test reads the whole table without ever writing a bracket. So each line is
# padded, every character that cannot appear in an identifier becomes a space, and the search is
# for a standalone `D` or `PD`. No routing rule has a legitimate local by either name.
#
# The function count is held at ten from below, so a plant that DELETES a rule rather than
# corrupting it is refused as well -- a purity check that passes because there was nothing left to
# read would be the emptiest green in this file.
function rule_purity(self,   line, inside, fname, hits, checked, t) {
  hits = 0; checked = 0; inside = 0
  while ((getline line < self) > 0) {
    if (line ~ /^function [a-z_]+\(/) {
      fname = line; sub(/^function /, "", fname); sub(/\(.*/, "", fname)
      inside = (fname ~ /^(route_|swapp$|revp$|circ$|nbr$)/)
      if (inside) checked++ ; else continue }
    else if (!inside) continue
    t = " " line " "; gsub(/[^A-Za-z0-9_]/, " ", t)
    if (t ~ / (D|PD) /) { printf "refused rule_purity %s reads_distance_table\n", fname; hits++ } }
  close(self)
  if (checked < 10) { printf "refused rule_purity functions_found=%d want_at_least=10\n", checked; return -1 }
  if (hits) return -1
  printf "purity routing_functions=%d reads_distance_table=0\n", checked
  return 0 }
'
