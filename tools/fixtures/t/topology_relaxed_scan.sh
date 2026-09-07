#!/bin/sh
# tools/fixtures/t/topology_relaxed_scan.sh -- the star graph wins every measurement and exists
# only at factorial sizes. This asks what the two families that relax that factorial keep, and
# what they give back.
#
# WHY. Its sibling `topology_stretch_scan.sh` measured seven shapes on 720 and 5,040 points and
# found one that reaches a low diameter AND routes optimally from the two addresses alone: the
# star graph. It also named that shape's wall in the same breath. A star graph's vertex count is
# n!, so between 720 and 5,040 the family offers NO SIZE AT ALL, and a supervision tree takes its
# member count from its membership rather than from a factorial. That paper closed by naming two
# doors from the literature and calling either one future work. This script walks both.
#
#   (n,k)-STAR, written S(n,k). A vertex is an ordered arrangement of k distinct symbols drawn
#   from n. Two arrangements are adjacent when one is the other with position 1 swapped against
#   some position i (k-1 such edges), or with the symbol at position 1 replaced by one of the
#   n-k symbols the arrangement does not carry. Degree is n-1 and the vertex count is n!/(n-k)!,
#   so the size grid is far denser than a factorial. At k = n-1 the family IS the star graph,
#   which is why two of the sizes below are the sibling paper's own two readings: they are the
#   anchor that proves this script builds the same graphs.
#
#   ARRANGEMENT GRAPH, written A(n,k). Same vertices. Adjacent when they differ in exactly one
#   position. Degree is k(n-k), which buys a shorter diameter with markedly more wire.
#
# THE QUESTION, in one line: does the optimal table-free rule survive the relaxation? A rule is
# TABLE-FREE when the next hop is computed from the two addresses and the generating set alone,
# in work bounded by the size of the address, with nothing precomputed per topology. The star's
# rule is one indexed read and a swap. The question is whether a rule that cheap still finds a
# SHORTEST path once k falls below n-1 and unwanted symbols enter the arrangement.
#
# WHAT IT PRINTS, in six legs:
#
#   window   -- the density claim, derived rather than recited. Every (n,k) with n at or under
#               WINDOW_N whose vertex count falls strictly between 720 and 5,040, which is the
#               window the star family leaves empty. Prints the count and each size with its
#               degree, so a reader can check the arithmetic by hand.
#
#   nkstar   -- eleven S(n,k) graphs, each built here, walked breadth-first from the identity
#               arrangement, and then ROUTED from every other vertex by THREE named rules. It
#               reports the true diameter beside each rule's diameter and the count of vertices
#               each rule reaches by a shortest path.
#
#               The three rules, named so a reader can check them rather than trust them, and
#               ordered as they were actually found:
#
#               naive -- the star rule read literally. If position 1 holds a symbol whose home is
#                 position j, swap it there. If it holds a symbol the target does not want, replace
#                 it with the lowest-numbered wanted symbol the arrangement lacks. If it is already
#                 home, swap it against the first position that is wrong.
#               door -- the same, with one correction: never seat the symbol that belongs at
#                 position 1 by a replacement, and prefer to swap in a symbol whose own home
#                 currently holds an unwanted one, so the swap places a symbol AND evacuates junk.
#               chain -- the same, choosing by where the chain ENDS. From a candidate symbol s,
#                 walk s -> the symbol at position s -> and so on, at most k steps. A chain ending
#                 in an unwanted symbol is a free eviction and is preferred; a chain ending at
#                 symbol 1 drags the one symbol already home back to the door and is refused last.
#
#   arrange  -- four A(n,k) graphs under their own natural rule: if some position is wrong and the
#               symbol it wants is absent, place it; otherwise evict one wrong position to an
#               unwanted symbol, which opens the hole the first branch needs.
#
#   transit  -- the vertex-transitivity check that lets the routing legs walk from ONE target
#               instead of from every vertex. Both families are vertex-transitive, and that is a
#               claim ABOUT the graph which a build error would break, so it is checked: several
#               sources per shape, eccentricity and distance sum compared against the identity.
#               The sources are spread by a stride chosen COPRIME to the vertex count, since a
#               sampler aligned to a factor of the thing it samples is blind along that factor.
#
#   branch   -- what the chain rule costs, in the same spirit the sibling priced the star's rule.
#               It reports the share of hops taking each of the three branches, and the mean and
#               maximum number of chain steps walked. A rule whose worst chain is k steps is
#               table-free by the definition above; one that had to walk the graph would not be.
#
#   compare  -- the honest side-by-side at 840 and at 5,040 points: the best three-ring torus of
#               the same vertex count, and the abelian floor at degree six, both DERIVED here by
#               the same closed form `topology_attained_scan.sh` checks against enumeration.
#
# WHAT IS MEASURED AND WHAT IS DERIVED. Every diameter, rule diameter, optimal count and branch
# count is MEASURED on a graph this script builds and routes. The window sizes are DERIVED from
# n!/(n-k)!, and the abelian floor and best three-ring torus are DERIVED by closed form. Nothing
# here implements anything: `comlink/topology.rye` publishes the seated three-ring reading and no
# shape on this list. Two Rooms -- these are numbers a design argument may cite, not a behavior
# the tree performs.
#
# THE COVERAGE GAPS, NAMED. First, optimality is proven by EXHAUSTION at the eleven sizes walked
# and nowhere else; the largest is 6,720 points, and nothing here says what happens at 40,320.
# Second, table-free is measured by exhibiting rules rather than by proving none better exists --
# the naive rule's failure bounds THAT rule and leaves open whether some fourth rule beats the
# chain rule's cost. Third, hops are counted and instructions are not: the branch leg is the
# nearest this script comes to a wall-clock reading and is not one. Fourth, the window leg is
# bounded at n = WINDOW_N, so its count is a floor on the family's density rather than a total.
#
# THREE KNOBS. `SCAN_LEGS` (window|nkstar|arrange|transit|branch|compare|all, default all),
# `SCAN_SOURCES` (default 6) bounding the transitivity check, and `SCAN_SIZES` -- a
# semicolon-separated `n,k` list replacing the thirteen readings, so a control can plant a fault
# and read the answer in a second rather than in ten. Every reduced run PRINTS `legs=`,
# `sources=` and `sizes=` on its own line, so a reduced reading can never be mistaken for a full
# one; the witness runs the defaults and binds the full numbers.
#
#   sh tools/fixtures/t/topology_relaxed_scan.sh
#   SCAN_LEGS=window sh tools/fixtures/t/topology_relaxed_scan.sh
#   SCAN_SIZES=6,3 SCAN_LEGS=nkstar sh tools/fixtures/t/topology_relaxed_scan.sh

set -u
LEGS="${SCAN_LEGS:-all}"
SOURCES="${SCAN_SOURCES:-6}"
SIZES="${SCAN_SIZES:-default}"

awk -v LEGS="$LEGS" -v SOURCES="$SOURCES" -v SIZES="$SIZES" -v SELF="$0" 'BEGIN {
  WINDOW_N = 14
  bad = 0
  printf "legs=%s\n", LEGS
  printf "sources=%d\n", SOURCES
  printf "sizes=%s\n", SIZES

  # The eleven S(n,k) readings. The first two are the sibling paper own two star graphs, present
  # as an anchor: S(6,5) must walk 7 on degree 5 at 720 points and S(7,6) must walk 9 on degree 6
  # at 5,040, or this script is not building the graphs it says it builds.
  NK = 0
  if (SIZES == "default") {
    add_nk(6,5); add_nk(7,6)
    add_nk(6,3); add_nk(7,3); add_nk(9,3); add_nk(11,3); add_nk(12,3)
    add_nk(7,4); add_nk(8,4); add_nk(9,4); add_nk(10,4)
    add_nk(7,5); add_nk(8,5) }
  else { np = split(SIZES, SL, ";")
    for (si = 1; si <= np; si++) if (SL[si] != "") { split(SL[si], pk, ","); add_nk(pk[1]+0, pk[2]+0) } }

  if (LEGS == "all" || LEGS == "window") window_leg(WINDOW_N)

  if (LEGS == "all" || LEGS == "nkstar" || LEGS == "transit" || LEGS == "branch") {
    for (t = 0; t < NK; t++) {
      build_star(NKN[t], NKK[t])
      if (LEGS == "all" || LEGS == "nkstar") bad += report_star(NKN[t], NKK[t])
      if (LEGS == "all" || LEGS == "transit") bad += transit_leg("nkstar", NKN[t], NKK[t])
    }
    if (LEGS == "all" || LEGS == "branch") {
      if (SIZES == "default") { build_star(8,5); branch_leg(8,5); build_star(10,4); branch_leg(10,4) }
      else for (t = 0; t < NK; t++) { build_star(NKN[t], NKK[t]); branch_leg(NKN[t], NKK[t]) } }
  }

  if (LEGS == "all" || LEGS == "arrange") {
    if (SIZES == "default") { bad += report_arr(6,3); bad += report_arr(7,3); bad += report_arr(7,4); bad += report_arr(8,4) }
    else for (t = 0; t < NK; t++) bad += report_arr(NKN[t], NKK[t]) }

  if (LEGS == "all" || LEGS == "compare") {
    best_torus(840);  printf "compare points=840 torus=%dx%dx%d torus_degree=6 torus_diameter=%d abelian_floor_degree6=%d\n", BP,BQ,BR,BD, abelian_floor(840)
    best_torus(5040); printf "compare points=5040 torus=%dx%dx%d torus_degree=6 torus_diameter=%d abelian_floor_degree6=%d\n", BP,BQ,BR,BD, abelian_floor(5040)
  }

  # THE ABSENCES, PRINTED AS PRESENCES. A reader -- and a witness -- can bind a line that says
  # zero; neither can bind a line that is missing. So the three readings whose whole meaning is
  # "this never happened" are counted and printed rather than left to be inferred from silence.
  printf "summary star_readings=%d arrangement_readings=%d unrouted_total=%d transit_checked=%d transit_disagreements=%d suboptimal_sizes naive=%d door=%d chain=%d hole=%d\n",
    WALKED_STAR, WALKED_ARR, UNROUTED, TRANSIT_CHECKED, TRANSIT_DISAGREE,
    SUBOPT["naive"] + 0, SUBOPT["door"] + 0, SUBOPT["chain"] + 0, SUBOPT["hole"] + 0

  if (rule_purity(SELF) < 0) bad++
  printf "refusals=%d\n", bad
  printf "verdict=%s\n", (bad ? "refused" : "ok")
  exit (bad ? 1 : 0)
}

function add_nk(n, k) { NKN[NK] = n; NKK[NK] = k; NK++ }

# ---- leg one: how dense the relaxed grid is where the factorial grid is empty -----------------
# The star family offers 720 and then 5,040 and nothing between. This counts what S(n,k) offers
# in that gap, derived from the falling factorial rather than quoted.
function window_leg(maxn,   n, k, v, count, line) {
  count = 0; line = ""
  for (n = 3; n <= maxn; n++) {
    v = 1
    for (k = 1; k < n; k++) { v = v * (n - k + 1)
      if (v > 720 && v < 5040) { count++; line = line sprintf(" %d(S%d,%d/deg%d)", v, n, k, n-1) } } }
  printf "window between=720_and_5040 star_family_sizes=0 nkstar_sizes=%d bound_n=%d\n", count, maxn
  printf "window sizes:%s\n", line }

# ---- builders. VL[] is the vertex list in lexicographic order, VX[] the reverse index ---------
# An ordered list matters twice: the transitivity leg needs a deterministic stride, and an
# unordered walk would make two runs of this script disagree about which sources it sampled.
function build_star(n, k) { KK = k; NN = n; delete VL; delete VX; NV = 0
  gen_arr(n, k, "", 0)
  ID = ident(k) }
function build_arr(n, k) { KK = k; NN = n; delete VL; delete VX; NV = 0
  gen_arr(n, k, "", 0)
  ID = ident(k) }
function ident(k,   i, s) { s = ""; for (i = 1; i <= k; i++) s = s sprintf("%02d,", i); return s }
function gen_arr(n, k, pre, depth,   s) {
  if (depth == k) { VL[NV] = pre; VX[pre] = NV; NV++; return }
  for (s = 1; s <= n; s++) if (!sym_in(pre, s)) gen_arr(n, k, pre sprintf("%02d,", s), depth + 1) }
function sym_in(p, s) { return index(p, sprintf("%02d,", s)) > 0 }

# S(n,k) neighbours: k-1 swaps against position one, and n-k replacements of position one.
function nbrs_star(n, k, p,   i, a, s, tmp, j, cnt) { cnt = 0; split(p, a, ",")
  for (i = 2; i <= k; i++) NBB[cnt++] = swap_one(k, a, i)
  for (s = 1; s <= n; s++) if (!sym_in(p, s)) {
    tmp = sprintf("%02d,", s); for (j = 2; j <= k; j++) tmp = tmp a[j] ","; NBB[cnt++] = tmp }
  return cnt }
# A(n,k) neighbours: every position may take every absent symbol.
function nbrs_arr(n, k, p,   i, a, s, tmp, j, cnt) { cnt = 0; split(p, a, ",")
  for (i = 1; i <= k; i++) for (s = 1; s <= n; s++) if (!sym_in(p, s)) {
    tmp = ""; for (j = 1; j <= k; j++) tmp = tmp (j == i ? sprintf("%02d,", s) : a[j] ",")
    NBB[cnt++] = tmp }
  return cnt }
function swap_one(k, a, i,   tmp, j) { tmp = ""
  for (j = 1; j <= k; j++) tmp = tmp (j == 1 ? a[i] : (j == i ? a[1] : a[j])) ","
  return tmp }

# One breadth-first walk. Fills D[] and returns the eccentricity, or -1 when disconnected. SUMD
# carries the distance sum, which the transitivity leg compares across sources -- an equal
# eccentricity with an unequal sum would still be a build error.
function bfs(n, k, src, fam,   q, head, tail, v, c, i, u, far) {
  delete D; D[src] = 0; q[0] = src; head = 0; tail = 1; far = 0; SUMD = 0
  while (head < tail) { v = q[head++]
    c = (fam == "arr") ? nbrs_arr(n, k, v) : nbrs_star(n, k, v)
    for (i = 0; i < c; i++) { u = NBB[i]
      if (!(u in D)) { D[u] = D[v] + 1; SUMD += D[u]; if (D[u] > far) far = D[u]; q[tail++] = u } } }
  for (i = 0; i < NV; i++) if (!(VL[i] in D)) return -1
  return far }

# ---- the rules. Each is a pure function of the arrangement and the target, and the purity leg
# below reads their source to prove none of them consults the breadth-first distance array.
# TERMINUS is the whole finding. From a candidate symbol, follow the chain -- symbol s wants
# position s, and position s currently holds some symbol, which wants ITS own position -- for at
# most k steps. 2 means the chain ends in an unwanted symbol, which the next replacement evicts
# for free. 0 means it ends at symbol 1, which is already home and would be dragged back to the
# door. 1 is everything else. Preferring 2 over 1 over 0 is what closes the last three percent.
function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = 0
  while (steps++ <= k) { sym = a[cur] + 0
    if (sym > k) return 2
    if (sym == 1) return 0
    if (sym == cur) return 1
    cur = sym }
  return 1 }
function route_star(n, k, p, rule,   hops, a, j, s, miss, tmp, cap, f, pick, best, t) {
  cap = 6 * k + 8; hops = 0
  while (p != ID) { if (hops > cap) return -1
    split(p, a, ","); f = a[1] + 0
    if (f == 1) { pick = 0
      if (rule == "chain") { best = -1
        for (j = 2; j <= k; j++) if (a[j] + 0 != j) { t = terminus(a, k, j); if (t > best) { best = t; pick = j } } }
      else if (rule == "door") { for (j = 2; j <= k; j++) if (a[j] + 0 <= k && a[j] + 0 != j) { pick = j; break } }
      if (!pick) for (j = 2; j <= k; j++) if (a[j] + 0 != j) { pick = j; break }
      p = swap_one(k, a, pick) }
    else if (f <= k) p = swap_one(k, a, f)
    else { miss = 0
      if (rule == "chain") { best = -1
        for (s = 2; s <= k; s++) if (!sym_in(p, s)) { t = terminus(a, k, s); if (t > best) { best = t; miss = s } } }
      else if (rule == "door") {
        for (s = 2; s <= k; s++) if (!sym_in(p, s) && a[s] + 0 > k) { miss = s; break }
        if (!miss) for (s = 2; s <= k; s++) if (!sym_in(p, s) && a[s] + 0 != 1) { miss = s; break }
        if (!miss) for (s = 2; s <= k; s++) if (!sym_in(p, s)) { miss = s; break } }
      if (!miss) for (s = 1; s <= k; s++) if (!sym_in(p, s)) { miss = s; break }
      tmp = sprintf("%02d,", miss); for (j = 2; j <= k; j++) tmp = tmp a[j] ","; p = tmp }
    hops++ }
  return hops }
# A(n,k): fill a hole when one is open, otherwise make one. A position whose wanted symbol is
# absent is filled in a single move; when every wrong position holds a symbol the target still
# wants, the wrong positions form cycles and one of them must be broken by evicting a symbol to
# an unwanted one, which is the second branch.
function route_arr(n, k, p,   hops, a, i, j, s, tmp, cap, done, pick) {
  cap = 3 * k + 4; hops = 0
  while (p != ID) { if (hops > cap) return -1
    split(p, a, ","); done = 0
    for (i = 1; i <= k; i++) if (a[i] + 0 != i && !sym_in(p, i)) {
      tmp = ""; for (j = 1; j <= k; j++) tmp = tmp (j == i ? sprintf("%02d,", i) : a[j] ",")
      p = tmp; done = 1; break }
    if (!done) { pick = 0
      for (i = 1; i <= k; i++) if (a[i] + 0 > k) { pick = i; break }
      if (!pick) for (i = 1; i <= k; i++) if (a[i] + 0 != i) { pick = i; break }
      for (s = k + 1; s <= n; s++) if (!sym_in(p, s)) {
        tmp = ""; for (j = 1; j <= k; j++) tmp = tmp (j == pick ? sprintf("%02d,", s) : a[j] ",")
        p = tmp; break } }
    hops++ }
  return hops }

# ---- reporters --------------------------------------------------------------------------------
function report_star(n, k,   ecc, i, v, h, r, rules, nr, worst, opt, fail, bail) {
  ecc = bfs(n, k, ID, "star")
  if (ecc < 0) { printf "refused nkstar n=%d k=%d disconnected\n", n, k; return 1 }
  split("naive door chain", rules, " ")
  for (nr = 1; nr <= 3; nr++) { worst = 0; opt = 0; fail = 0
    for (i = 0; i < NV; i++) { v = VL[i]; h = route_star(n, k, v, rules[nr])
      if (h < 0) { fail++; continue }
      if (h == D[v]) opt++
      if (h > worst) worst = h }
    printf "nkstar n=%d k=%d points=%d degree=%d diameter=%d rule=%s rule_diameter=%d stretch=%d optimal=%d/%d unrouted=%d\n",
      n, k, NV, n - 1, ecc, rules[nr], worst, worst - ecc, opt, NV, fail
    UNROUTED += fail
    if (opt < NV) SUBOPT[rules[nr]]++
    WALKED_STAR++
    if (fail) bail++ }
  return (bail ? 1 : 0) }
function report_arr(n, k,   ecc, i, v, h, worst, opt, fail) {
  build_arr(n, k)
  ecc = bfs(n, k, ID, "arr")
  if (ecc < 0) { printf "refused arrange n=%d k=%d disconnected\n", n, k; return 1 }
  worst = 0; opt = 0; fail = 0
  for (i = 0; i < NV; i++) { v = VL[i]; h = route_arr(n, k, v)
    if (h < 0) { fail++; continue }
    if (h == D[v]) opt++
    if (h > worst) worst = h }
  printf "arrange n=%d k=%d points=%d degree=%d diameter=%d rule=hole rule_diameter=%d stretch=%d optimal=%d/%d unrouted=%d\n",
    n, k, NV, k * (n - k), ecc, worst, worst - ecc, opt, NV, fail
  UNROUTED += fail
  if (opt < NV) SUBOPT["hole"]++
  WALKED_ARR++
  return (fail ? 1 : 0) }

# The transitivity check. A stride coprime to the vertex count is what makes the sample honest:
# a stride sharing a factor with NV walks a subgroup and is blind everywhere else, which is the
# exact fault the sibling script recorded when it sampled at multiples of a ring length.
function transit_leg(fam, n, k,   base, basesum, i, st, src, e, agree, tried) {
  base = bfs(n, k, ID, (fam == "arrange" ? "arr" : "star")); basesum = SUMD
  st = coprime_stride(NV)
  agree = 0; tried = 0
  for (i = 1; i < SOURCES; i++) { src = VL[(i * st) % NV]
    e = bfs(n, k, src, (fam == "arrange" ? "arr" : "star")); tried++
    if (e == base && SUMD == basesum) agree++ }
  printf "transit family=%s n=%d k=%d points=%d stride=%d sources=%d agree=%d eccentricity=%d\n",
    fam, n, k, NV, st, tried, agree, base
  TRANSIT_CHECKED++
  if (agree != tried) { TRANSIT_DISAGREE++
    printf "refused transit family=%s n=%d k=%d not_vertex_transitive\n", fam, n, k; return 1 }
  return 0 }
function coprime_stride(nv,   c, i, primes, np) {
  np = split("271 269 263 257 251 241 239 233 199 181 163 149 131 113 97 83 71 59 47 37 29 23 19 17 13 11 7", primes, " ")
  for (i = 1; i <= np; i++) { c = primes[i] + 0; if (nv % c != 0 && c < nv) return c }
  return 1 }

# What the chain rule costs per hop. Three branches: SWAP HOME is one indexed read and a swap and
# walks no chain at all; the other two walk the chain to choose, at most k steps. This is the leg
# that keeps table-free a priced claim rather than an asserted one.
function branch_leg(n, k,   i, v, p, a, f, hops, steps, tot, home, doorb, fill, sum, mx, t, j, s, best, pick, miss, tmp) {
  home = 0; doorb = 0; fill = 0; sum = 0; mx = 0; tot = 0
  for (i = 0; i < NV; i++) { p = VL[i]; hops = 0
    while (p != ID && hops <= 6 * k + 8) { split(p, a, ","); f = a[1] + 0; hops++; tot++
      if (f == 1) { doorb++; steps = 0; best = -1; pick = 0
        for (j = 2; j <= k; j++) if (a[j] + 0 != j) { steps++; t = terminus(a, k, j); if (t > best) { best = t; pick = j } }
        sum += steps; if (steps > mx) mx = steps
        p = swap_one(k, a, pick) }
      else if (f <= k) { home++; p = swap_one(k, a, f) }
      else { fill++; steps = 0; best = -1; miss = 0
        for (s = 2; s <= k; s++) if (!sym_in(p, s)) { steps++; t = terminus(a, k, s); if (t > best) { best = t; miss = s } }
        if (!miss) for (s = 1; s <= k; s++) if (!sym_in(p, s)) { miss = s; break }
        sum += steps; if (steps > mx) mx = steps
        tmp = sprintf("%02d,", miss); for (j = 2; j <= k; j++) tmp = tmp a[j] ","; p = tmp } } }
  printf "branch n=%d k=%d hops=%d swap_home=%.3f door=%.3f fill=%.3f mean_candidates=%.3f max_candidates=%d bound=k=%d\n",
    n, k, tot, home / tot, doorb / tot, fill / tot, sum / tot, mx, k }

# ---- derived comparisons, called rather than spelled -------------------------------------------
# A number that cannot move when its derivation moves is a recital, so both of these are computed.
function best_torus(n,   p, m, q, r, d) {
  BD = 999999
  for (p = 2; p <= n; p++) { if (n % p) continue; m = n / p
    for (q = p; q <= m; q++) { if (m % q) continue; r = m / q; if (r < q) continue
      d = int(p/2) + int(q/2) + int(r/2)
      if (d < BD) { BD = d; BP = p; BQ = q; BR = r } } } }
# The smallest radius whose L1 ball in Z^3 holds n points -- the closed form
# `topology_attained_scan.sh` checks against a direct enumeration at every radius.
function abelian_floor(n,   k, ball) {
  for (k = 0; k < 200; k++) { ball = (4*k*k*k + 6*k*k + 8*k + 3) / 3
    if (ball >= n) return k }
  return -1 }

# TABLE-FREE IS A PROPERTY OF THE RULE, NOT OF ITS OUTPUT, so this leg reads the rule. A routing
# function that secretly consulted the breadth-first distance array would print stretch=0 while
# being the table-bound case wearing the table-free answer -- the one fault every other leg here
# is blind to, since they all read hop counts and a hop count cannot say what the rule looked at.
# So the script opens its own source, isolates the body of each routing function and of every
# helper a rule may reach, and refuses when the bare token `D` appears anywhere inside one.
# The check is a TOKEN match rather than a bracket match: a plant reading `if (p in D)` writes no
# bracket at all, so each line is padded, every character that cannot appear in an identifier
# becomes a space, and the search is for a standalone `D`. The DECLARATION line is read too,
# since a plant appended to `function route_star(...) {` sits in the one place a skip-to-next-line
# check cannot look, and that is exactly where a hand editing a rule would put it. The function
# count is held from below so a plant that DELETES a rule is refused as well -- a purity check
# passing because there was nothing left to read would be the emptiest green in this file.
#
# THE FILTER IS A LIST OF PLAIN COMPARISONS rather than one alternation regex, so that a reader
# sees the admitted names at a glance and a plant cannot reach them by rewriting a pattern.
function rule_purity(self,   line, inside, fname, hits, checked, t) {
  hits = 0; checked = 0; inside = 0
  while ((getline line < self) > 0) {
    if (line ~ /^function [a-z_]+\(/) {
      fname = line; sub(/^function /, "", fname); sub(/\(.*/, "", fname)
      inside = (fname ~ /^route_/ || fname == "terminus" || fname == "swap_one" ||
                fname == "sym_in" || fname == "ident")
      if (inside) checked++ ; else continue }
    else if (!inside) continue
    if (line ~ /^[ \t]*#/) continue
    t = " " line " "; gsub(/[^A-Za-z0-9_]/, " ", t)
    if (t ~ / D /) { printf "refused rule_purity %s reads_distance_table\n", fname; hits++ } }
  close(self)
  if (checked < 5) { printf "refused rule_purity functions_found=%d want_at_least=5\n", checked; return -1 }
  if (hits) return -1
  printf "purity routing_functions=%d reads_distance_table=0\n", checked
  return 0 }
'
