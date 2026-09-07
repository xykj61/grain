#!/bin/sh
# tools/fixtures/t/topology_occupied_scan.sh -- the free-routing claim meets a real membership.
#
# WHY. Its sibling `topology_relaxed_scan.sh` measured seventeen (n,k)-star and arrangement graphs
# and found a table-free rule -- the chain rule -- that routes every vertex of every size by a
# shortest path. That paper closed by naming its own second falsifier and leaving it unfired:
#
#   "Every reading here assumes all n!/(n-k)! vertices are occupied. A supervision tree with 800
#    members on an 840-vertex shape has 40 holes, and a rule that walks into one has to do
#    something. If the answer needs a table of live members, the free-routing claim does not
#    survive contact with a real membership."
#
# This script fires it. A membership never lands on a factorial and rarely lands on a falling
# factorial either, so holes are the ordinary case rather than the edge.
#
# WHAT A HOLE COSTS, AND WHAT IT DOES NOT. A node knows which of its own n-1 neighbours answer.
# That is DEGREE-many bits held locally, refreshed by the supervision the shape exists to carry --
# it is not a table of live members, and it does not grow with the membership. So the honest
# question is not "does routing need a table" but "is NEIGHBOUR LIVENESS enough", and that is a
# question with a number.
#
# WHAT IT PRINTS, in six legs:
#
#   anchor   -- the sibling's own published readings, reproduced here at full occupancy. This file
#               carries its own copy of the builder and the chain rule (see COVERAGE GAPS), so the
#               anchor is what proves the copy is the same graph and the same rule: S(6,5) must
#               walk 7 on degree 5 at 720 points, S(7,4) must walk 7 on degree 6 at 840, and the
#               chain rule must route every vertex of both optimally.
#
#   occupy   -- what a hole set does to the SHAPE, before any routing. For each graph, hole mode
#               and occupancy: how many vertices live, how many components the live induced
#               subgraph has, how large the biggest is, and the live diameter. A rule cannot
#               deliver across a partition no matter how clever it is, so this leg bounds every
#               reading below it.
#
#   deliver  -- what the hole set does to the RULE. Three rules, each routing every live vertex to
#               each sampled live target, reporting delivery, dead ends, and stretch against the
#               shortest path IN THE LIVE SUBGRAPH -- which is the honest baseline, since a packet
#               may not walk through a member that is not there.
#
#               blind -- the chain rule exactly as published, which cannot see liveness. It steps
#                 into holes. Present to measure the falsifier as it was actually written.
#               local -- the chain rule's own preference order, filtered to live neighbours: take
#                 the best-preferred move whose destination answers. Memoryless, so it may cycle.
#               trace -- local, plus the set of vertices this packet has already visited, carried
#                 IN THE PACKET. On a dead end it retreats and takes the next-preferred unvisited
#                 live neighbour. The state is bounded by the path, never by the membership.
#
#   cluster  -- the same readings under holes that are CORRELATED rather than spread. A real
#               membership loses a rack, a region, or a version cohort; it does not lose a random
#               sample. Three hole modes are measured: `spread` (a deterministic hash over the
#               vertex index), `class` (every vertex carrying one symbol in the last position --
#               exactly V/n vertices, a whole sub-star), and `block` (a lexicographic run, which is
#               what a contiguous address allocation loses).
#
#   cost     -- what the rules cost per hop: candidates scanned, and for `trace` the largest
#               visited set any packet carried. That last number is the whole claim. A packet
#               carrying tens of entries is a path record; one carrying hundreds is a table of
#               live members wearing a different coat, and the free-routing claim would not
#               survive it.
#
#   compare  -- the same occupancy applied to the best three-ring torus of the same vertex count,
#               routed by its own coordinate rule under the same local-liveness filter. A torus is
#               what a builder reaches for when a factorial size is unavailable, so it is the
#               shape this reading is against.
#
# WHAT IS MEASURED AND WHAT IS DERIVED. Every live count, component count, diameter, delivery,
# stretch and cost is MEASURED on a graph this script builds, holes and all. The torus dimensions
# are DERIVED by the same closed form the sibling scans use. Nothing here implements anything:
# `comlink/topology.rye` publishes the seated three-ring reading and no shape on this list. Two
# Rooms -- these are numbers a design argument may cite, not a behavior the tree performs.
#
# THE COVERAGE GAPS, NAMED.
#
#   First, VERTEX-TRANSITIVITY IS GONE. The sibling walked from one source because both families
#   are vertex-transitive; a hole set breaks that, and every reading here would be a reading about
#   one lucky target if it were taken from one. So each configuration routes to SEVERAL targets,
#   sampled by a stride coprime to the live count, and prints how many. It is a sample, and the
#   script says so on every line rather than in this comment alone.
#
#   Second, THE HOLE SETS ARE THREE SHAPES, NOT A DISTRIBUTION. Spread, class and block are three
#   named failure geometries, chosen because a real membership meets each. They are not a proof
#   about all hole sets, and an adversary choosing holes to cut the shape would do better than any
#   of them -- the connectivity of S(n,k) is n-1, so n-1 well-chosen holes can isolate a vertex,
#   and the `class` mode is the nearest this script comes to that adversary.
#
#   Third, THIS FILE CARRIES ITS OWN COPY of the builder, the neighbour functions and the chain
#   rule, because a shell fixture has no import. The `anchor` leg exists precisely to bind that
#   copy to the sibling's published numbers, so a divergence reds rather than hides. Factoring the
#   shared core into one `awk -f` include that both scans load is the right repair and is named
#   here as work rather than taken, since it would edit a green guard for a reason unrelated to
#   this reading.
#
#   Fourth, HOPS ARE COUNTED AND INSTRUCTIONS ARE NOT, exactly as in the sibling. The cost leg
#   counts candidate evaluations, which is the nearest this script comes to a wall-clock number
#   and is not one.
#
# FOUR KNOBS. `SCAN_LEGS` (anchor|occupy|deliver|cluster|cost|compare|all, default all),
# `SCAN_TARGETS` (default 3) bounding the target sample, `SCAN_SIZES` -- a semicolon-separated
# `n,k` list replacing the defaults -- and `SCAN_FILL` -- a semicolon-separated occupancy list in
# percent. Every reduced run PRINTS `legs=`, `targets=`, `sizes=` and `fill=` on its own line, so a
# reduced reading can never be mistaken for a full one; the witness runs the defaults.
#
#   sh tools/fixtures/t/topology_occupied_scan.sh
#   SCAN_LEGS=anchor sh tools/fixtures/t/topology_occupied_scan.sh
#   SCAN_SIZES=6,3 SCAN_FILL=90 SCAN_LEGS=deliver sh tools/fixtures/t/topology_occupied_scan.sh

set -u
LEGS="${SCAN_LEGS:-all}"
TARGETS="${SCAN_TARGETS:-3}"
SIZES="${SCAN_SIZES:-default}"
FILL="${SCAN_FILL:-default}"

awk -v LEGS="$LEGS" -v TARGETS="$TARGETS" -v SIZES="$SIZES" -v FILL="$FILL" -v SELF="$0" 'BEGIN {
  bad = 0
  printf "legs=%s\n", LEGS
  printf "targets=%d\n", TARGETS
  printf "sizes=%s\n", SIZES
  printf "fill=%s\n", FILL

  NK = 0
  if (SIZES == "default") { add_nk(6,3); add_nk(7,4) }
  else { np = split(SIZES, SL, ";")
    for (si = 1; si <= np; si++) if (SL[si] != "") { split(SL[si], pk, ","); add_nk(pk[1]+0, pk[2]+0) } }

  NF_ = 0
  if (FILL == "default") { add_fill(95); add_fill(90); add_fill(75) }
  else { np = split(FILL, FLl, ";")
    for (si = 1; si <= np; si++) if (FLl[si] != "") add_fill(FLl[si]+0) }

  if (LEGS == "all" || LEGS == "anchor") bad += anchor_leg()

  if (LEGS == "all" || LEGS == "occupy" || LEGS == "deliver" || LEGS == "cost") {
    for (t = 0; t < NK; t++) { build_star(NKN[t], NKK[t])
      for (fi = 0; fi < NF_; fi++) {
        make_holes(NKN[t], NKK[t], "spread", FILLP[fi])
        if (LEGS == "all" || LEGS == "occupy") bad += occupy_leg(NKN[t], NKK[t], "spread", FILLP[fi])
        if (LEGS == "all" || LEGS == "deliver" || LEGS == "cost")
          bad += deliver_leg(NKN[t], NKK[t], "spread", FILLP[fi], (LEGS == "cost" || LEGS == "all")) } } }

  if (LEGS == "all" || LEGS == "cluster") {
    for (t = 0; t < NK; t++) { build_star(NKN[t], NKK[t])
      split("class1 class2 door1", HM, " ")
      for (hi = 1; hi <= 3; hi++) {
        make_holes(NKN[t], NKK[t], HM[hi], 0)
        pc = int(LIVEN * 100 / NV)
        bad += occupy_leg(NKN[t], NKK[t], HM[hi], pc)
        bad += deliver_leg(NKN[t], NKK[t], HM[hi], pc, 0) }
      for (fi = 0; fi < NF_ && fi < 2; fi++) {
        make_holes(NKN[t], NKK[t], "block", FILLP[fi])
        bad += occupy_leg(NKN[t], NKK[t], "block", FILLP[fi])
        bad += deliver_leg(NKN[t], NKK[t], "block", FILLP[fi], 0) } } }

  if (LEGS == "all" || LEGS == "compare") { for (fi = 0; fi < NF_; fi++) bad += torus_leg(840, FILLP[fi]) }

  # THE ABSENCES, PRINTED AS PRESENCES. A reader -- and a witness -- can bind a line that says
  # zero; neither can bind a line that is missing. So the readings whose whole meaning is "this
  # never happened" are counted and printed rather than inferred from silence.
  printf "summary configs=%d anchors=%d partitioned=%d trace_undelivered=%d local_undelivered=%d blind_undelivered=%d torus_trace_undelivered=%d unreachable_pairs=%d max_visited=%d\n",
    CONFIGS + 0, ANCHORS + 0, PARTITIONED + 0, UNDELIV["trace"] + 0, UNDELIV["local"] + 0, UNDELIV["blind"] + 0,
    TORUS_UNDELIV["trace"] + 0, UNREACH_TOTAL + 0, MAXVIS + 0

  if (rule_purity(SELF) < 0) bad++
  printf "refusals=%d\n", bad
  printf "verdict=%s\n", (bad ? "refused" : "ok")
  exit (bad ? 1 : 0)
}

function add_nk(n, k) { NKN[NK] = n; NKK[NK] = k; NK++ }
function add_fill(p) { FILLP[NF_] = p; NF_++ }

# ---- builders. VL[] is the vertex list in lexicographic order, VX[] the reverse index ----------
function build_star(n, k) { KK = k; NN = n; delete VL; delete VX; NV = 0
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
function swap_one(k, a, i,   tmp, j) { tmp = ""
  for (j = 1; j <= k; j++) tmp = tmp (j == 1 ? a[i] : (j == i ? a[1] : a[j])) ","
  return tmp }

# ---- the hole sets ----------------------------------------------------------------------------
# LIVE[vertex] is 1 when a member sits at that address. Three named geometries, each producing an
# EXACT live count this script prints rather than an approximate one it hopes for, because a
# reading taken at "about 90 percent" cannot be compared against another taken the same way.
#
# spread -- a deterministic hash over the vertex INDEX, so two runs of this script kill the same
#   vertices. The hash is a multiply-and-mask over the index; holes are taken from the head of the
#   hash order until the target count is met, which makes the count exact rather than binomial.
# class  -- whole symbol classes: every vertex whose LAST position carries symbol s. Each class
#   holds exactly NV/n vertices and is the nearest thing this shape has to a rack. Classes are
#   removed whole until removing another would overshoot; the remainder is taken by spread, and
#   the line prints how many whole classes fell.
# block  -- a lexicographic run, which is what a contiguous address allocation loses. The run
#   starts at a fixed offset so the identity arrangement is never the first casualty.
function make_holes(n, k, mode, pct,   i, want, killed, h, s, cls, order, m, idx) {
  delete LIVE; LIVEN = 0; HOLES = 0; CLASSES = 0
  want = int(NV * pct / 100)
  if (want < 1) want = 1
  for (i = 0; i < NV; i++) LIVE[VL[i]] = 1
  killed = 0
  # A CLASS COUNT, NEVER A PERCENTAGE. A whole symbol class holds exactly NV/n vertices -- 120 of
  # S(7,4) 840, which is 14.3 percent -- so asking for "90 percent occupancy, clustered" asks for
  # something the geometry cannot give, and the first draft answered by falling through to the
  # spread hash and printing a line labelled `class` that was a spread reading. `class1` and
  # `class2` name the number of racks lost and let the occupancy come out where it comes out.
  if (mode == "class1" || mode == "class2" || mode == "door1") {
    cls = int(NV / n); want = NV - cls * (mode == "class2" ? 2 : 1)
    for (s = n; s >= 1 && CLASSES < (mode == "class2" ? 2 : 1); s--) {
      for (i = 0; i < NV; i++)
        if (LIVE[VL[i]] && (mode == "door1" ? first_sym(VL[i]) : last_sym(VL[i], k)) == s) { LIVE[VL[i]] = 0; killed++ }
      CLASSES++ } }
  else if (mode == "block") {
    idx = int(NV / 3)
    for (i = idx; i < NV && killed < NV - want; i++) if (LIVE[VL[i]]) { LIVE[VL[i]] = 0; killed++ }
    for (i = 0; i < NV && killed < NV - want; i++) if (LIVE[VL[i]]) { LIVE[VL[i]] = 0; killed++ } }
  # spread, and the remainder of every other mode: hash order, head first, skipping the identity.
  for (m = 0; m < 65536 && killed < NV - want; m++)
    for (i = 0; i < NV && killed < NV - want; i++)
      if (LIVE[VL[i]] && VL[i] != ID && hash_idx(i) % 65536 == m) { LIVE[VL[i]] = 0; killed++ }
  HOLES = killed
  for (i = 0; i < NV; i++) if (LIVE[VL[i]]) LIVEN++
  return LIVEN }
function last_sym(p, k,   a) { split(p, a, ","); return a[k] + 0 }
# WHICH END THE CLASS IS TAKEN FROM IS THE WHOLE QUESTION, so both ends are measured. Position 1 is
# the door every move in this family touches; position k is the far end. A reading that only ever
# removed one of them would report "clusters are free" when the honest finding may be narrower.
function first_sym(p,   a) { split(p, a, ","); return a[1] + 0 }
# A multiply-and-mask hash. Deterministic across runs and across awk implementations, since it
# stays inside 32 bits and uses only integer multiply, add and modulo.
function hash_idx(i,   h) { h = (i * 2654435761) % 4294967296; h = int(h / 7) + i * 40503; return h % 4294967296 }

# ---- one breadth-first walk over the LIVE induced subgraph -------------------------------------
# Fills D[] with distances from src through live vertices only, and returns the eccentricity over
# the reached set. REACHED carries how many were reached, which is what tells a partition from a
# long walk.
function bfs_live(n, k, src,   q, head, tail, v, c, i, u, far) {
  delete D; D[src] = 0; q[0] = src; head = 0; tail = 1; far = 0; REACHED = 1
  while (head < tail) { v = q[head++]
    c = nbrs_star(n, k, v)
    for (i = 0; i < c; i++) { u = NBB[i]
      if (LIVE[u] && !(u in D)) { D[u] = D[v] + 1; REACHED++; if (D[u] > far) far = D[u]; q[tail++] = u } } }
  return far }

# ---- the chain rule, in its own words ----------------------------------------------------------
# TERMINUS is the sibling paper finding, carried here byte for byte in meaning: from a candidate
# symbol, follow the chain -- symbol s wants position s, and position s holds some symbol, which
# wants ITS own position -- for at most k steps. 2 means the chain ends in an unwanted symbol,
# which the next replacement evicts for free. 0 means it ends at symbol 1, already home, which a
# swap would drag back to the door. 1 is everything else.
function terminus(a, k, start,   cur, steps, sym) { cur = start; steps = 0
  while (steps++ <= k) { sym = a[cur] + 0
    if (sym > k) return 2
    if (sym == 1) return 0
    if (sym == cur) return 1
    cur = sym }
  return 1 }

# CANDIDATES. The rule preference order over the WHOLE neighbourhood, ranked rather than reduced
# to a single choice, so a liveness filter has somewhere to fall back to. CAND[0..CN-1] holds every
# one of the n-1 neighbours, best first.
#
# THE FULL NEIGHBOURHOOD IS WHAT MAKES `trace` COMPLETE, and the first draft of this file left it
# out. The published rule names a handful of moves it likes -- seat the door symbol, swap out a
# symbol whose chain ends in junk -- and says nothing about the rest, so a candidate list holding
# only those is a SUBGRAPH of the live graph. A depth-first walk over a subgraph dead-ends while
# the graph it sits inside is connected, which is exactly what the reading showed before this was
# repaired: 48 dead ends at three-quarters occupancy on a shape with one component.
#
# So the preferred moves keep their scores and are lifted clear by a thousand; every other
# neighbour ranks below all of them, in the deterministic order the neighbour function emits. The
# three rules are then nested rather than separate: `blind` takes rank zero, `local` takes the
# best-ranked LIVE one, `trace` takes the best-ranked live one it has not stood on.
function candidates(n, k, p,   a, j, s, f, t, i, best, bi, tmp, c, dest) {
  split(p, a, ","); f = a[1] + 0
  delete PS
  if (f == 1) {
    for (j = 2; j <= k; j++) if (a[j] + 0 != j) PS[swap_one(k, a, j)] = terminus(a, k, j) * 10 + (k - j) }
  else if (f <= k) { PS[swap_one(k, a, f)] = 100
    # A door symbol with a home is seated first, always. The remaining swaps rank below it so a
    # dead neighbour has somewhere to fall back to rather than nowhere.
    for (j = 2; j <= k; j++) if (j != f) PS[swap_one(k, a, j)] = terminus(a, k, j) * 10 + (k - j) }
  else {
    for (s = 1; s <= k; s++) if (!sym_in(p, s)) {
      tmp = sprintf("%02d,", s); for (j = 2; j <= k; j++) tmp = tmp a[j] ","
      PS[tmp] = (s == 1 ? 5 : terminus(a, k, s) * 10 + 1) } }
  c = nbrs_star(n, k, p)
  CN = 0
  for (i = 0; i < c; i++) { dest = NBB[i]
    CAND[CN] = dest; SC[CN] = ((dest in PS) ? PS[dest] + 1000 : -i); CN++ }
  # Insertion sort by score, descending. CN is the degree, n-1, so this is bounded by the address.
  for (i = 1; i < CN; i++) { tmp = CAND[i]; best = SC[i]; bi = i - 1
    while (bi >= 0 && SC[bi] < best) { CAND[bi+1] = CAND[bi]; SC[bi+1] = SC[bi]; bi-- }
    CAND[bi+1] = tmp; SC[bi+1] = best }
  return CN }

# ONE PACKET, ONE RULE. Returns hops, or -1 for a dead end, -2 for a hop-cap bail, -3 for a blind
# packet that stepped into a hole. SCANNED accumulates candidate evaluations; VISPEAK carries the
# largest visited set this packet held, which is the number the whole free-routing claim turns on.
function route_star(n, k, src, dst, rule,   p, hops, c, i, cap, moved, back, sp) {
  cap = 40 * k + 80; hops = 0; VISPEAK = 1
  delete VIS; delete STK; sp = 0
  p = src; VIS[p] = 1; STK[sp++] = p
  while (p != dst) { if (hops > cap) return -2
    c = candidates(n, k, to_frame(p, k)); SCANNED += c
    moved = 0
    for (i = 0; i < c; i++) { back = from_frame(CAND[i], k)
      # BLIND IS THE FALSIFIER AS WRITTEN. It takes its first choice with no idea whether anyone
      # is there, so a hole ends the packet. Crediting it with a delivery made THROUGH a dead
      # member would credit a route the network cannot take, and the shortest-path baseline would
      # come out NEGATIVE -- which is how this was caught while the file was being written.
      if (rule == "blind") { p = back; moved = 1; if (!LIVE[p]) return -3; break }
      if (!LIVE[back]) continue
      if (rule == "trace" && (back in VIS)) continue
      p = back; moved = 1; break }
    if (moved) { hops++
      if (rule == "trace") { VIS[p] = 1; STK[sp++] = p; if (sp > VISPEAK) VISPEAK = sp }
      continue }
    # NOWHERE FORWARD. `local` is memoryless and has nothing to fall back on, so it stops here and
    # the reading counts a dead end. `trace` RETREATS: it steps back to the member it came from and
    # tries that one next-preferred live neighbour it has not already stood on. The retreat is a
    # real hop on a real wire, so it is counted as one.
    if (rule != "trace") return -1
    if (sp <= 1) return -1
    sp--; p = STK[sp - 1]; hops++ }
  if (VISPEAK > MAXVIS) MAXVIS = VISPEAK
  if (sp > MAXSTK) MAXSTK = sp
  return hops }

# THE FRAME. The chain rule is written against the identity target, and a hole set gives it many
# targets, so the packet relabels: apply the symbol permutation that carries the target to the
# identity, route there, and carry each step back.
#
# THE PERMUTATION IS OVER ALL n SYMBOLS, NEVER THE TARGET k. A relabel defined only on the k
# symbols the target carries leaves the other n-k untouched, and an untouched symbol collides with
# the image of a mapped one the moment it appears -- target 05,04,02 sends 5 to 1 while a vertex
# holding a real 1 keeps it, and two symbols now claim one name. A symbol permutation of S(n,k) is
# an automorphism; a partial one is not a function. This was measured as targets that dead-ended
# at eight times the rate of the identity, which is what sent a reader to look.
#
# It is set once per target rather than per hop: n entries, held by the frame the packet carries and by
# nobody in the network, so the rule stays table-free under it.
function set_frame(dst, n, k,   b, i, s, nx) {
  delete PERM; delete IPERM
  split(dst, b, ",")
  for (i = 1; i <= k; i++) { PERM[b[i] + 0] = i; IPERM[i] = b[i] + 0 }
  nx = k + 1
  for (s = 1; s <= n; s++) if (!(s in PERM)) { PERM[s] = nx; IPERM[nx] = s; nx++ } }
function to_frame(p, k,   a, i, out) { split(p, a, ","); out = ""
  for (i = 1; i <= k; i++) out = out sprintf("%02d,", PERM[a[i] + 0])
  return out }
function from_frame(q, k,   a, i, out) { split(q, a, ","); out = ""
  for (i = 1; i <= k; i++) out = out sprintf("%02d,", IPERM[a[i] + 0])
  return out }

# ---- legs --------------------------------------------------------------------------------------
function anchor_leg(   i, ecc, h, opt, v, fails) { fails = 0
  split("6,5 7,4", AN, " ")
  for (i = 1; i <= 2; i++) { split(AN[i], pk, ",")
    build_star(pk[1] + 0, pk[2] + 0)
    for (j = 0; j < NV; j++) LIVE[VL[j]] = 1
    set_frame(ID, pk[1] + 0, pk[2] + 0)
    ecc = bfs_live(pk[1] + 0, pk[2] + 0, ID)
    opt = 0
    for (j = 0; j < NV; j++) { v = VL[j]; h = route_star(pk[1] + 0, pk[2] + 0, v, ID, "blind")
      if (h >= 0 && h == D[v]) opt++ }
    printf "anchor n=%d k=%d points=%d degree=%d diameter=%d chain_optimal=%d/%d\n",
      pk[1] + 0, pk[2] + 0, NV, pk[1] - 1, ecc, opt, NV
    ANCHORS++
    if (opt != NV) { printf "refused anchor n=%d k=%d chain rule no longer routes every vertex optimally\n", pk[1]+0, pk[2]+0; fails++ } }
  return fails }

function occupy_leg(n, k, mode, pct,   i, comps, seen, big, ecc, v, tot) {
  comps = 0; big = 0; delete seen; tot = 0
  for (i = 0; i < NV; i++) { v = VL[i]
    if (!LIVE[v] || (v in seen)) continue
    ecc = bfs_live(n, k, v)
    for (u in D) seen[u] = 1
    comps++; if (REACHED > big) { big = REACHED; BIGECC = ecc } }
  printf "occupy n=%d k=%d points=%d mode=%s fill=%d live=%d holes=%d classes=%d components=%d largest=%d live_diameter=%d\n",
    n, k, NV, mode, pct, LIVEN, HOLES, CLASSES, comps, big, BIGECC
  CONFIGS++
  if (comps > 1) PARTITIONED++
  return 0 }

function deliver_leg(n, k, mode, pct, want_cost,   ti, tgt, i, v, h, r, rules, nr, del, dead, bail, hole, unreach,
                     stmax, ssum, sn, tried, stride, pos, tcount, pk_scan, pk_vis) {
  split("blind local trace", rules, " ")
  stride = coprime_stride(LIVEN)
  for (nr = 1; nr <= 3; nr++) { del = 0; dead = 0; bail = 0; hole = 0; unreach = 0; tried = 0; stmax = 0; ssum = 0; sn = 0
    SCANNED = 0; MAXVIS = 0; MAXSTK = 0; tcount = 0
    pos = 0
    for (ti = 0; ti < TARGETS; ti++) { tgt = nth_live(pos); pos = (pos + stride) % (LIVEN > 0 ? LIVEN : 1)
      if (tgt == "") continue
      tcount++
      set_frame(tgt, n, k)
      bfs_live(n, k, tgt)
      for (i = 0; i < NV; i++) { v = VL[i]
        if (!LIVE[v] || v == tgt) continue
        # A PARTITIONED PAIR IS THE SHAPE REFUSING RATHER THAN THE RULE, so it is excluded from the
        # delivery arithmetic -- AND COUNTED, because excluding it silently is how a partition
        # reads as perfect. Removing one door class from S(7,4) leaves four components and every
        # surviving pair routing flawlessly; the line said 837 of 837 delivered while half the
        # membership could not be reached at all. The number that says so is this one.
        if (!(v in D)) { unreach++; continue }
        tried++
        h = route_star(n, k, v, tgt, rules[nr])
        if (h == -3) { hole++; continue }
        if (h == -1) { dead++; continue }
        if (h == -2) { bail++; continue }
        del++
        if (h - D[v] > stmax) stmax = h - D[v]
        ssum += h - D[v]; sn++ } }
    printf "deliver n=%d k=%d mode=%s fill=%d rule=%s targets=%d pairs=%d delivered=%d holehit=%d deadend=%d bail=%d unreachable=%d stretch_max=%d stretch_mean=%.3f\n",
      n, k, mode, pct, rules[nr], tcount, tried, del, hole, dead, bail, unreach, stmax, (sn ? ssum / sn : 0)
    UNDELIV[rules[nr]] += (tried - del); UNREACH_TOTAL += unreach
    if (want_cost) printf "cost n=%d k=%d mode=%s fill=%d rule=%s candidates_per_pair=%.2f max_visited=%d max_stack=%d\n",
      n, k, mode, pct, rules[nr], (tried ? SCANNED / tried : 0), MAXVIS, MAXSTK }
  return 0 }

function nth_live(idx,   i, c) { c = 0
  for (i = 0; i < NV; i++) if (LIVE[VL[i]]) { if (c == idx) return VL[i]; c++ }
  return "" }
# A stride sharing a factor with the count samples along that factor and is blind across it, so the
# stride is walked up until it is coprime with the live count.
function coprime_stride(m,   s) { if (m < 3) return 1
  s = int(m / 7) + 1
  while (gcd(s, m) != 1) s++
  return s }
function gcd(a, b,   t) { while (b) { t = a % b; a = b; b = t }; return a }

# ---- the torus, under the same holes -----------------------------------------------------------
# Its rule is the coordinate one: on each of three rings independently, step the way that closes
# the shorter arc. Under liveness it takes the best live step among the six, which is the same
# local-liveness discipline the star rules get.
# THE TORUS, UNDER THE SAME HOLES AND THE SAME THREE RULES. A builder who cannot have a factorial
# size reaches for a three-ring torus, so it is the shape this reading is against -- and it earns a
# like-for-like comparison rather than a rigged one. Its `blind` is the coordinate rule as written,
# its `local` takes the best live step that closes an arc, and its `trace` retreats exactly as the
# star rule does. Giving the star a retreat and the torus none would have made the comparison say
# more about the two rules than about the two shapes.
function torus_leg(points, pct,   p, q, r, i, live, tot, del, dead, tried, want, killed, rules, nr, hole, bail, h, stmax, ssum, sn, d0) {
  best_torus(points); p = BP; q = BQ; r = BR
  delete TL; tot = p * q * r
  want = int(tot * pct / 100); killed = 0
  for (i = 0; i < tot; i++) TL[i] = 1
  for (i = 1; i < tot && killed < tot - want; i++) if (hash_idx(i) % 100 >= pct) { TL[i] = 0; killed++ }
  for (i = 1; i < tot && killed < tot - want; i++) if (TL[i]) { TL[i] = 0; killed++ }
  live = 0; for (i = 0; i < tot; i++) if (TL[i]) live++
  split("blind local trace", rules, " ")
  for (nr = 1; nr <= 3; nr++) { tried = 0; del = 0; dead = 0; hole = 0; bail = 0; stmax = 0; ssum = 0; sn = 0
    torus_bfs(p, q, r)
    for (i = 1; i < tot; i++) { if (!TL[i] || !(i in TD)) continue
      tried++; h = torus_route(i, p, q, r, rules[nr])
      if (h == -3) { hole++; continue }
      if (h == -1) { dead++; continue }
      if (h == -2) { bail++; continue }
      del++; if (h - TD[i] > stmax) stmax = h - TD[i]; ssum += h - TD[i]; sn++ }
    printf "compare shape=torus points=%d dims=%dx%dx%d degree=6 fill=%d live=%d rule=%s pairs=%d delivered=%d holehit=%d deadend=%d bail=%d stretch_max=%d stretch_mean=%.3f\n",
      tot, p, q, r, pct, live, rules[nr], tried, del, hole, dead, bail, stmax, (sn ? ssum / sn : 0)
    TORUS_UNDELIV[rules[nr]] += (tried - del) }
  return 0 }
# Distances from vertex 0 through LIVE torus vertices only -- the same honest baseline the star legs
# use, since a packet may not pass through a member that is not there.
function torus_bfs(p, q, r,   qq, head, tail, v, j, u, tot) { tot = p * q * r
  delete TD; TD[0] = 0; qq[0] = 0; head = 0; tail = 1
  while (head < tail) { v = qq[head++]
    for (j = 0; j < 6; j++) { u = torus_step(v, j, p, q, r)
      if (TL[u] && !(u in TD)) { TD[u] = TD[v] + 1; qq[tail++] = u } } } }
function torus_route(src, p, q, r, rule,   cur, h, cap, j, d, moved, sp, best, bj) {
  cap = 40 * (p + q + r); h = 0
  delete TVIS; delete TSTK; sp = 0
  cur = src; TVIS[cur] = 1; TSTK[sp++] = cur
  while (cur != 0) { if (h > cap) return -2
    moved = 0; best = -1; bj = -1
    # Ranked exactly as the star rule is: every neighbour that closes an arc ranks above every one
    # that does not, and ties break on the fixed direction order, so two runs agree.
    for (j = 0; j < 6 && !moved; j++) { d = torus_step(cur, j, p, q, r)
      if (!torus_closer(d, cur, p, q, r)) continue
      if (rule == "blind") { cur = d; moved = 1; if (!TL[cur]) return -3; break }
      if (!TL[d]) continue
      if (rule == "trace" && (d in TVIS)) continue
      cur = d; moved = 1 }
    if (!moved && rule != "blind") for (j = 0; j < 6 && !moved; j++) { d = torus_step(cur, j, p, q, r)
      if (torus_closer(d, cur, p, q, r) || !TL[d]) continue
      if (rule == "trace" && (d in TVIS)) continue
      if (rule == "local") continue
      cur = d; moved = 1 }
    if (moved) { h++
      if (rule == "trace") { TVIS[cur] = 1; TSTK[sp++] = cur }
      continue }
    if (rule != "trace") return -1
    if (sp <= 1) return -1
    sp--; cur = TSTK[sp - 1]; h++ }
  return h }
function torus_step(v, j, p, q, r,   x, y, z) { x = v % p; y = int(v / p) % q; z = int(v / (p * q))
  if (j == 0) x = (x + 1) % p; else if (j == 1) x = (x + p - 1) % p
  else if (j == 2) y = (y + 1) % q; else if (j == 3) y = (y + q - 1) % q
  else if (j == 4) z = (z + 1) % r; else z = (z + r - 1) % r
  return x + y * p + z * p * q }
function torus_closer(d, v, p, q, r) { return torus_dist(d, p, q, r) < torus_dist(v, p, q, r) }
function torus_dist(v, p, q, r,   x, y, z) { x = v % p; y = int(v / p) % q; z = int(v / (p * q))
  return ring(x, p) + ring(y, q) + ring(z, r) }
function ring(a, m) { return (a < m - a) ? a : m - a }
function best_torus(points,   p, q, r, d, bd) { bd = -1
  for (p = 1; p <= points; p++) { if (points % p) continue
    for (q = p; q <= points / p; q++) { if ((points / p) % q) continue
      r = points / (p * q); if (r < q) continue
      d = int(p / 2) + int(q / 2) + int(r / 2)
      if (bd < 0 || d < bd) { bd = d; BP = p; BQ = q; BR = r } } }
  BD = bd }

# ---- the one fault the output cannot show -------------------------------------------------------
# A rule that consulted the breadth-first distance array would print perfect delivery and zero
# stretch and would be exactly the table-bound case wearing the table-free answer. So the script
# reads its own source and refuses when any routing function mentions D[.
function rule_purity(self,   line, fn, saw, hits) { hits = 0; fn = ""
  while ((getline line < self) > 0) {
    # THE DECLARATION LINE IS READ, NOT CONSUMED. An awk function body may begin on its own head
    # line, so `function terminus(...) { steps = D[start]` puts the whole fault exactly where a
    # head-match that skipped ahead would never look -- and that is where a hand would put it, since
    # it is where the locals are declared. The control plants it there, and the first draft passed.
    if (line ~ /^function (candidates|terminus|route_star|to_frame|from_frame|set_frame|torus_step|torus_closer|torus_dist|torus_route)\(/) { fn = "rule" }
    else if (line ~ /^function /) { fn = ""; continue }
    # The word boundary is load-bearing: `CAND[` ends in `D[` and would read as the distance
    # array to a looser pattern, which would refuse a clean file every time.
    if (fn == "rule" && line ~ /(^|[^A-Za-z0-9_])D($|[^A-Za-z0-9_])/) hits++ }
  close(self)
  if (hits) { printf "refused purity routing_functions_reading_distance_array=%d\n", hits; return -1 }
  printf "purity routing_functions_reading_distance_array=0 checked=candidates,terminus,route_star,set_frame,to_frame,from_frame,torus\n"
  return 0 }
'
