#!/bin/sh
# tools/fixtures/t/topology_partial_scan.sh -- the holes a membership cannot round off.
#
# WHY. Its sibling `topology_occupied_scan.sh` measured four hole geometries on the (n,k)-star
# family and found that WHICH addresses you leave empty is a design variable worth choosing: at
# S(7,4), removing a whole far-end symbol class -- 120 of 840 vertices -- cost nothing at all, and
# the published memoryless rule delivered every surviving pair at zero stretch. That paper closed
# by naming its own falsifier and leaving it unfired:
#
#   "A membership landing between whole classes -- 800 on 840, say -- leaves 40 holes with no class
#    to hide them in, and the finding above is silent on the best partial-class arrangement."
#
# This script fires it. The falsifier is the ordinary case: a class of S(7,4) holds exactly 120
# members, and no supervision tree ever arrives at a multiple of 120.
#
# THE HYPOTHESIS UNDER TEST, stated so a reading can refuse it. The classes of an (n,k)-star NEST.
# Fixing the last position gives 840/7 = 120 vertices; fixing the last two gives 120/6 = 20; the
# last three, 20/5 = 4; all four, 1. So the sizes a hole set can be built from are a MIXED-RADIX
# NUMERAL -- 120, 20, 4, 1 -- and 40 holes are two whole classes of 20 rather than forty scattered
# losses. The hypothesis is that the greedy decomposition of any hole count into whole nested
# classes costs what the whole class cost: nothing measurable.
#
# THE ARRANGEMENT THAT TESTS IT IS ONE LINE OF CODE, and that is the finding rather than a
# convenience. Sort the addresses by their FAR END first -- position k, then k-1, down to the door
# at position 1 -- and every whole nested class becomes a CONTIGUOUS RUN in that order. The greedy
# decomposition is then exactly "take the first h addresses in far-end order", which is what a
# sequential allocator already does; it simply reads the address from the other end. So the
# arrangements measured here are, deliberately, the SAME contiguous allocation under two orderings:
#
#   nested   -- the first h addresses in FAR-END-major order (position k most significant)
#   block    -- the first h addresses in DOOR-major order (position 1 most significant), which is
#               ordinary lexicographic and is what a sequential allocator does today
#   nested_at -- the same far-end-major run, started a third of the way in rather than at the head,
#               because a reading taken only from index zero is a reading about the identity's own
#               neighbourhood
#   spread   -- a deterministic hash over the vertex index; the baseline the sibling measured
#   class_partial -- h addresses taken from INSIDE one far-end class in door-major order, which is
#               the arrangement a builder reaches for who has heard "keep the holes in one class"
#               and stopped there. It is the control on the hypothesis: if nesting is what pays,
#               this must cost more than `nested` at the same h.
#
# WHAT IT PRINTS, in four legs:
#
#   anchor  -- the sibling's published readings, reproduced from this file's own copy of the
#              builder and the chain rule, so a divergence in the copy reds rather than hides.
#   radix   -- the nested class sizes of each shape, DERIVED by the closed form and then MEASURED
#              by counting the vertices sharing each suffix. A derived ladder nobody counted is a
#              claim; this leg is what makes it a reading.
#   arrange -- the five arrangements above at equal hole counts, each reporting components, live
#              diameter, and what each of the three routing rules delivers.
#   offset  -- every whole level-2 class of S(7,4) emptied in turn, 42 of them, scored by the blind
#              rule against ONE fixed target list. The arrange leg raises the question this leg
#              answers: two hole sets of equal size, both whole nested classes, read three times
#              apart, so whole classes are not interchangeable and the table says by how much.
#
#   sweep   -- hole counts h across a range on the small shape, `nested` against `block` and
#              `spread`, so the finding is a curve rather than three points.
#
# THE THREE RULES are the sibling's, carried here with the same names and the same meanings:
# `blind` is the published chain rule, which cannot see liveness and steps into holes; `local`
# filters its own preference order by neighbour liveness and is memoryless; `trace` carries the
# vertices it has already stood on and retreats. Stretch is measured against a breadth-first walk
# THROUGH LIVE MEMBERS ONLY, since a packet may not pass through a member that is not there.
#
# WHAT IS MEASURED AND WHAT IS DERIVED. Every live count, component count, diameter, delivery and
# stretch is MEASURED on a graph this script builds. The radix ladder is DERIVED and then counted.
# Nothing here implements anything: `comlink/topology.rye` publishes the seated three-ring reading
# and no shape on this list. Two Rooms -- numbers a design argument may cite, not a behavior the
# tree performs.
#
# THE COVERAGE GAPS, NAMED.
#
#   First, THIS FILE CARRIES ITS OWN COPY of the builder, the neighbour functions and the chain
#   rule, exactly as its sibling does and for the same reason: a shell fixture has no import. The
#   `anchor` leg binds the copy to the published numbers. Factoring the shared core into one
#   `awk -f` include that all three scans load is the right repair and is named here as work
#   rather than taken, since it would edit two green guards for a reason unrelated to this reading.
#
#   Second, FIVE ARRANGEMENTS ARE NOT A DISTRIBUTION. They are five named allocation policies,
#   chosen because a builder can actually implement each. An adversary choosing holes to cut the
#   shape would do better than any of them: the connectivity of S(n,k) is n-1.
#
#   Third, VERTEX-TRANSITIVITY IS GONE the moment a hole set exists, so every configuration routes
#   to SEVERAL targets sampled by a stride coprime to the live count, and prints how many.
#
#   Fourth, HOPS ARE COUNTED AND INSTRUCTIONS ARE NOT.
#
# FOUR KNOBS. `SCAN_LEGS` (anchor|radix|arrange|offset|sweep|all, default all), `SCAN_TARGETS` (default 3),
# `SCAN_SIZES` -- a semicolon-separated `n,k` list replacing the defaults -- and `SCAN_HOLES` -- a
# semicolon-separated hole-count list for the arrange leg. Every reduced run PRINTS `legs=`,
# `targets=`, `sizes=` and `holes=` on its own line, so a reduced reading can never be mistaken for
# a full one; the witness runs the defaults.
#
#   sh tools/fixtures/t/topology_partial_scan.sh
#   SCAN_LEGS=radix sh tools/fixtures/t/topology_partial_scan.sh
#   SCAN_SIZES=6,3 SCAN_HOLES=10 SCAN_LEGS=arrange sh tools/fixtures/t/topology_partial_scan.sh

set -u
LEGS="${SCAN_LEGS:-all}"
TARGETS="${SCAN_TARGETS:-12}"
SIZES="${SCAN_SIZES:-default}"
HOLES="${SCAN_HOLES:-default}"

awk -v LEGS="$LEGS" -v TARGETS="$TARGETS" -v SIZES="$SIZES" -v HOLESL="$HOLES" -v SELF="$0" 'BEGIN {
  bad = 0
  printf "legs=%s\n", LEGS
  printf "targets=%d\n", TARGETS
  printf "sizes=%s\n", SIZES
  printf "holes=%s\n", HOLESL

  NK = 0
  if (SIZES == "default") { add_nk(6,3); add_nk(7,4) }
  else { np = split(SIZES, SL, ";")
    for (si = 1; si <= np; si++) if (SL[si] != "") { split(SL[si], pk, ","); add_nk(pk[1]+0, pk[2]+0) } }

  if (LEGS == "all" || LEGS == "anchor") bad += anchor_leg()
  if (LEGS == "all" || LEGS == "radix") { for (t = 0; t < NK; t++) bad += radix_leg(NKN[t], NKK[t]) }

  if (LEGS == "all" || LEGS == "arrange") {
    split("nested block nested_at spread class_partial", AR, " ")
    for (t = 0; t < NK; t++) { build_star(NKN[t], NKK[t]); pick_targets(NKN[t], NKK[t])
      NH = 0
      if (HOLESL == "default") default_holes(NKN[t], NKK[t])
      else { np = split(HOLESL, HL, ";"); for (si = 1; si <= np; si++) if (HL[si] != "") { HV[NH] = HL[si]+0; NH++ } }
      for (hi = 0; hi < NH; hi++)
        for (ai = 1; ai <= 5; ai++) {
          make_holes(NKN[t], NKK[t], AR[ai], HV[hi])
          bad += occupy_leg(NKN[t], NKK[t], AR[ai], HV[hi])
          bad += deliver_leg(NKN[t], NKK[t], AR[ai], HV[hi]) } } }

  # THE OFFSET LEG asks the question the arrange leg raises rather than answers: two hole sets of
  # the same size, both whole nested classes, read three times apart. So every level-2 class of the
  # shape is emptied in turn -- 42 of them at S(7,4) -- and the blind rule is scored against the one
  # fixed target list. If whole classes were interchangeable this table would be flat.
  if (LEGS == "all" || LEGS == "offset") {
    build_star(7, 4); pick_targets(7, 4)
    cls = int(NV / (7 * 6))
    for (ci = 0; ci * cls < NV; ci++) { make_holes_at(7, 4, ci * cls, cls); offset_leg(7, 4, ci, cls) } }

  if (LEGS == "all" || LEGS == "sweep") {
    build_star(6, 3); pick_targets(6, 3)
    split("nested block spread", AR2, " ")
    for (h = 4; h <= 60; h += 4)
      for (ai = 1; ai <= 3; ai++) {
        make_holes(6, 3, AR2[ai], h)
        sweep_leg(6, 3, AR2[ai], h) } }

  # THE ABSENCES, PRINTED AS PRESENCES. A reader -- and a witness -- can bind a line that says
  # zero; neither can bind a line that is missing. So the readings whose whole meaning is "this
  # never happened" are counted and printed rather than inferred from silence.
  printf "offset_range classes=%d best_holehit=%d worst_holehit=%d\n", OFFN + 0, OFFMIN + 0, OFFMAX + 0
  printf "summary configs=%d anchors=%d radix_rows=%d partitioned=%d nested_blind_lost=%d block_blind_lost=%d spread_blind_lost=%d trace_undelivered=%d unreachable_pairs=%d max_visited=%d\n",
    CONFIGS + 0, ANCHORS + 0, RADIXROWS + 0, PARTITIONED + 0,
    ARLOST["nested"] + 0, ARLOST["block"] + 0, ARLOST["spread"] + 0,
    UNDELIV["trace"] + 0, UNREACH_TOTAL + 0, MAXVIS + 0

  if (rule_purity(SELF) < 0) bad++
  printf "refusals=%d\n", bad
  printf "verdict=%s\n", (bad ? "refused" : "ok")
  exit (bad ? 1 : 0)
}

function add_nk(n, k) { NKN[NK] = n; NKK[NK] = k; NK++ }
# THE FIXED TARGET LIST, chosen once per shape from the WHOLE address space by a stride coprime to
# the vertex count, so every arrangement of holes is scored against the same destinations. The
# identity is first because it is the address the chain rule is written against; the stride carries
# the rest across the shape rather than along one class.
function pick_targets(n, k,   stride, pos, i) { delete TG
  stride = coprime_stride(NV)
  TG[0] = ID; pos = VX[ID]
  for (i = 1; i < TARGETS; i++) { pos = (pos + stride) % NV; TG[i] = VL[pos] } }
# THE DEFAULT HOLE COUNTS ARE CHOSEN AGAINST THE RADIX, not round numbers. For each shape: one
# whole second-level class, two of them -- which at S(7,4) is the falsifier own 40 holes on 840 --
# and two plus a remainder of 2 that no class can hold, which is the case the whole paper is about.
#
# THE TARGET DEFAULT IS TWELVE RATHER THAN THREE, and the number was measured rather than chosen.
# At three targets this leg ranked `class_partial` best of the five arrangements; at fifteen it
# ranked it worst, by a factor of fourteen. Three targets is enough to see that holes cost
# something and far too few to say which arrangement costs less, so a reading meant for a ranking
# pays for the targets that make the ranking stable.
function default_holes(n, k,   c2) { c2 = int(NV / (n * (n - 1)))
  HV[NH++] = c2; HV[NH++] = 2 * c2; HV[NH++] = 2 * c2 + 2 }

# ---- builders. VL[] is the vertex list in door-major (lexicographic) order, VX[] its reverse
# index, and FE[] the SAME vertices in far-end-major order: position k most significant, the door
# at position 1 least. That second ordering is the whole experiment -- a whole nested class is a
# contiguous run in it, and in door-major order it is a stride.
function build_star(n, k) { KK = k; NN = n; delete VL; delete VX; delete FE; NV = 0
  gen_arr(n, k, "", 0)
  ID = ident(k)
  far_order(k) }
function ident(k,   i, s) { s = ""; for (i = 1; i <= k; i++) s = s sprintf("%02d,", i); return s }
function gen_arr(n, k, pre, depth,   s) {
  if (depth == k) { VL[NV] = pre; VX[pre] = NV; NV++; return }
  for (s = 1; s <= n; s++) if (!sym_in(pre, s)) gen_arr(n, k, pre sprintf("%02d,", s), depth + 1) }
function sym_in(p, s) { return index(p, sprintf("%02d,", s)) > 0 }
# The far-end ordering, built by sorting on the REVERSED address string. A string sort suffices
# because every symbol is written in a fixed two-digit field, so lexicographic order on the
# reversed field sequence is exactly the mixed-radix order this experiment needs.
function far_order(k,   i, key, keys, j, tmp, m) {
  for (i = 0; i < NV; i++) { keys[i] = revkey(VL[i], k); FE[i] = VL[i] }
  # Insertion sort: NV is 840 at the largest shape here, so quadratic is bounded and honest.
  for (i = 1; i < NV; i++) { tmp = FE[i]; key = keys[i]; j = i - 1
    while (j >= 0 && keys[j] > key) { FE[j+1] = FE[j]; keys[j+1] = keys[j]; j-- }
    FE[j+1] = tmp; keys[j+1] = key } }
function revkey(p, k,   a, i, out) { split(p, a, ","); out = ""
  for (i = k; i >= 1; i--) out = out sprintf("%02d", a[i] + 0)
  return out }
function nbrs_star(n, k, p,   i, a, s, tmp, j, cnt) { cnt = 0; split(p, a, ",")
  for (i = 2; i <= k; i++) NBB[cnt++] = swap_one(k, a, i)
  for (s = 1; s <= n; s++) if (!sym_in(p, s)) {
    tmp = sprintf("%02d,", s); for (j = 2; j <= k; j++) tmp = tmp a[j] ","; NBB[cnt++] = tmp }
  return cnt }
function swap_one(k, a, i,   tmp, j) { tmp = ""
  for (j = 1; j <= k; j++) tmp = tmp (j == 1 ? a[i] : (j == i ? a[1] : a[j])) ","
  return tmp }
function last_sym(p, k,   a) { split(p, a, ","); return a[k] + 0 }
function first_sym(p,   a) { split(p, a, ","); return a[1] + 0 }
function hash_idx(i,   h) { h = (i * 2654435761) % 4294967296; h = int(h / 7) + i * 40503; return h % 4294967296 }

# ---- the five arrangements ---------------------------------------------------------------------
# Each takes an EXACT hole count and reports it, so two arrangements are compared at equal loss
# rather than at equal intent. LIVE[vertex] is 1 when a member sits at that address.
function make_holes(n, k, mode, want,   i, killed, start, cls, taken) {
  delete LIVE; LIVEN = 0; HOLES = 0
  for (i = 0; i < NV; i++) LIVE[VL[i]] = 1
  killed = 0
  if (mode == "nested") {
    # The first `want` addresses in far-end-major order: the greedy decomposition into whole
    # nested classes, with any remainder landing as adjacent singletons inside one class.
    for (i = 0; i < NV && killed < want; i++) if (FE[i] != ID) { LIVE[FE[i]] = 0; killed++ } }
  else if (mode == "nested_at") {
    start = int(NV / 3)
    for (i = start; i < NV && killed < want; i++) if (FE[i] != ID) { LIVE[FE[i]] = 0; killed++ }
    for (i = 0; i < NV && killed < want; i++) if (LIVE[FE[i]] && FE[i] != ID) { LIVE[FE[i]] = 0; killed++ } }
  else if (mode == "block") {
    # Ordinary lexicographic order -- door-major -- which is what a sequential allocator hands out.
    start = int(NV / 3)
    for (i = start; i < NV && killed < want; i++) if (VL[i] != ID) { LIVE[VL[i]] = 0; killed++ }
    for (i = 0; i < NV && killed < want; i++) if (LIVE[VL[i]] && VL[i] != ID) { LIVE[VL[i]] = 0; killed++ } }
  else if (mode == "class_partial") {
    # Inside ONE far-end class, taken in door-major order. This is the arrangement a builder
    # reaches for having heard "keep the holes in one class" -- correct at the first level and
    # blind to every level below it.
    cls = n
    for (i = 0; i < NV && killed < want; i++)
      if (LIVE[VL[i]] && VL[i] != ID && last_sym(VL[i], k) == cls) { LIVE[VL[i]] = 0; killed++ }
    for (i = 0; i < NV && killed < want; i++) if (LIVE[VL[i]] && VL[i] != ID) { LIVE[VL[i]] = 0; killed++ } }
  else {
    # spread: hash order over the vertex index, head first, skipping the identity.
    for (m = 0; m < 65536 && killed < want; m++)
      for (i = 0; i < NV && killed < want; i++)
        if (LIVE[VL[i]] && VL[i] != ID && hash_idx(i) % 65536 == m) { LIVE[VL[i]] = 0; killed++ } }
  HOLES = killed
  for (i = 0; i < NV; i++) if (LIVE[VL[i]]) LIVEN++
  return LIVEN }
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


# ---- the radix ladder --------------------------------------------------------------------------
# DERIVED then MEASURED. The sizes are computed by the falling-factorial closed form; the counts
# are obtained by counting the vertices that actually share each suffix. A ladder nobody counted
# is a claim, and the two must agree or this leg refuses.
function radix_leg(n, k,   j, want, seen, i, key, cnt, mism, sizes) {
  build_star(n, k)
  mism = 0
  want = NV
  sizes = ""
  for (j = 1; j <= k; j++) {
    want = int(want / (n - j + 1))
    delete seen
    for (i = 0; i < NV; i++) { key = suffix_key(VL[i], k, j); seen[key]++ }
    cnt = -1
    for (key in seen) { if (cnt < 0) cnt = seen[key]; else if (seen[key] != cnt) mism++ }
    sizes = sizes (j > 1 ? "," : "") cnt
    if (cnt != want) mism++
    printf "radix n=%d k=%d level=%d fixed_positions=%d classes=%d class_size_derived=%d class_size_counted=%d\n",
      n, k, j, j, length(seen), want, cnt
    RADIXROWS++ }
  printf "radix n=%d k=%d points=%d ladder=%s\n", n, k, NV, sizes
  if (mism) { printf "refused radix n=%d k=%d derived and counted class sizes disagree=%d\n", n, k, mism; return 1 }
  return 0 }
function suffix_key(p, k, j,   a, i, out) { split(p, a, ","); out = ""
  for (i = k; i > k - j; i--) out = out sprintf("%02d", a[i] + 0)
  return out }

# ---- what a hole set does to the SHAPE, before any routing -------------------------------------
function occupy_leg(n, k, mode, want,   i, comps, seen, big, ecc, v) {
  comps = 0; big = 0; delete seen
  for (i = 0; i < NV; i++) { v = VL[i]
    if (!LIVE[v] || (v in seen)) continue
    ecc = bfs_live(n, k, v)
    for (u in D) seen[u] = 1
    comps++; if (REACHED > big) { big = REACHED; BIGECC = ecc } }
  printf "occupy n=%d k=%d points=%d arrangement=%s holes=%d live=%d killed=%d components=%d largest=%d live_diameter=%d\n",
    n, k, NV, mode, want, LIVEN, HOLES, comps, big, BIGECC
  CONFIGS++
  if (comps > 1) PARTITIONED++
  return 0 }

# ---- what the hole set does to the RULE --------------------------------------------------------
function deliver_leg(n, k, mode, want,   ti, tgt, i, v, h, rules, nr, del, dead, bail, hole, unreach,
                     stmax, ssum, sn, tried, tcount, tdead) {
  split("blind local trace", rules, " ")
  for (nr = 1; nr <= 3; nr++) { del = 0; dead = 0; bail = 0; hole = 0; unreach = 0; tried = 0; stmax = 0; ssum = 0; sn = 0
    MAXVIS = 0; tcount = 0; tdead = 0
    for (ti = 0; ti < TARGETS; ti++) { tgt = TG[ti]
      # THE TARGETS ARE THE SAME ADDRESSES FOR EVERY ARRANGEMENT, which is what makes two
      # arrangements comparable at all. Sampled from the LIVE set instead -- as the sibling scan
      # samples them -- each arrangement is scored against its own target list, and the comparison
      # carries whatever the target choice happened to be worth. Measured on this shape: at three
      # live-sampled targets `class_partial` read best of five arrangements, and at fifteen it read
      # worst by a factor of fourteen. A target that a hole set killed is SKIPPED AND COUNTED here,
      # never silently replaced.
      if (!LIVE[tgt]) { tdead++; continue }
      tcount++
      set_frame(tgt, n, k)
      bfs_live(n, k, tgt)
      for (i = 0; i < NV; i++) { v = VL[i]
        if (!LIVE[v] || v == tgt) continue
        # A PARTITIONED PAIR IS THE SHAPE REFUSING RATHER THAN THE RULE, so it is excluded from the
        # delivery arithmetic AND COUNTED. Excluding it silently is how a partition reads as
        # perfect, which is the fault the sibling caught on its own door-class line.
        if (!(v in D)) { unreach++; continue }
        tried++
        h = route_star(n, k, v, tgt, rules[nr])
        if (h == -3) { hole++; continue }
        if (h == -1) { dead++; continue }
        if (h == -2) { bail++; continue }
        del++
        if (h - D[v] > stmax) stmax = h - D[v]
        ssum += h - D[v]; sn++ } }
    printf "deliver n=%d k=%d arrangement=%s holes=%d rule=%s targets=%d targets_dead=%d pairs=%d delivered=%d holehit=%d deadend=%d bail=%d unreachable=%d stretch_max=%d stretch_mean=%.3f max_visited=%d\n",
      n, k, mode, want, rules[nr], tcount, tdead, tried, del, hole, dead, bail, unreach, stmax, (sn ? ssum / sn : 0), MAXVIS
    UNDELIV[rules[nr]] += (tried - del); UNREACH_TOTAL += unreach
    if (rules[nr] == "blind") ARLOST[mode] += (tried - del) }
  return 0 }

# ---- one named whole class, emptied where it sits ----------------------------------------------
function make_holes_at(n, k, start, want,   i, killed) {
  delete LIVE; LIVEN = 0; HOLES = 0
  for (i = 0; i < NV; i++) LIVE[VL[i]] = 1
  killed = 0
  for (i = start; i < NV && killed < want; i++) { LIVE[FE[i]] = 0
    if (!killed) { split(FE[i], SA, ","); FARSYM = SA[k] + 0; NEXTSYM = SA[k-1] + 0 }
    killed++ }
  HOLES = killed
  for (i = 0; i < NV; i++) if (LIVE[VL[i]]) LIVEN++
  return LIVEN }

function offset_leg(n, k, ci, cls,   ti, tgt, i, v, h, tried, del, hole, dead, tcount, tdead, comps, seen, ecc, big) {
  comps = 0; big = 0; delete seen
  for (i = 0; i < NV; i++) { v = VL[i]
    if (!LIVE[v] || (v in seen)) continue
    ecc = bfs_live(n, k, v)
    for (u in D) seen[u] = 1
    comps++; if (REACHED > big) { big = REACHED; BIGECC = ecc } }
  tried = 0; del = 0; hole = 0; dead = 0; tcount = 0; tdead = 0
  for (ti = 0; ti < TARGETS; ti++) { tgt = TG[ti]
    if (!LIVE[tgt]) { tdead++; continue }
    tcount++
    set_frame(tgt, n, k); bfs_live(n, k, tgt)
    for (i = 0; i < NV; i++) { v = VL[i]
      if (!LIVE[v] || v == tgt || !(v in D)) continue
      tried++; h = route_star(n, k, v, tgt, "blind")
      if (h == -3) { hole++; continue }
      if (h < 0) { dead++; continue }
      del++ } }
  # THE CLASS IS NAMED BY THE SYMBOLS IT FIXES, not only by its index, because the index is an
  # artefact of the ordering while the symbols are the thing a builder chooses. `far` is the symbol
  # at position k and `next` the one at position k-1; `spare` says whether both lie outside the
  # first k symbols, which is the distinction the readings turn out to rank on.
  printf "offset n=%d k=%d class_index=%d class_size=%d far=%d next=%d spare=%d live=%d components=%d live_diameter=%d targets=%d targets_dead=%d blind_pairs=%d blind_delivered=%d blind_holehit=%d\n",
    n, k, ci, cls, FARSYM, NEXTSYM, (FARSYM > k && NEXTSYM > k) ? 2 : ((FARSYM > k || NEXTSYM > k) ? 1 : 0),
    LIVEN, comps, BIGECC, tcount, tdead, tried, del, hole
  CONFIGS++
  if (comps > 1) PARTITIONED++
  if (hole > OFFMAX) OFFMAX = hole
  if (OFFMIN == 0 || hole < OFFMIN) OFFMIN = hole
  OFFN++
  return 0 }

# ---- the curve, on the small shape -------------------------------------------------------------
# One rule, one target, every live source: the sweep exists to show the SHAPE of the cost against
# hole count rather than to add precision at any one point, so it is deliberately cheaper than the
# arrange leg and says so by printing `targets=1`.
function sweep_leg(n, k, mode, want,   i, h, u, comps, seen, big, ecc, v, ti, tgt, tried, del, hole, dead, unreach, tcount, tdead) {
  comps = 0; big = 0; delete seen
  for (i = 0; i < NV; i++) { v = VL[i]
    if (!LIVE[v] || (v in seen)) continue
    ecc = bfs_live(n, k, v)
    for (u in D) seen[u] = 1
    comps++; if (REACHED > big) { big = REACHED; BIGECC = ecc } }
  # EVERY TARGET, AND THE PARTITION COUNTED. The first draft of this leg routed from ONE target and
  # printed whatever pair count survived, which is how `block` at 20 holes came to read a clean
  # `0 lost` over 19 pairs: the single target had been all but isolated, and a line saying nothing
  # went wrong is indistinguishable from a line saying nothing happened. So the sweep now uses the
  # same fixed target list every other leg uses, prints how many pairs the SHAPE refused, and
  # counts the partition in the summary rather than leaving it to a reader to notice a small
  # denominator.
  tried = 0; del = 0; hole = 0; dead = 0; unreach = 0; tcount = 0; tdead = 0
  for (ti = 0; ti < TARGETS; ti++) { tgt = TG[ti]
    if (!LIVE[tgt]) { tdead++; continue }
    tcount++
    set_frame(tgt, n, k); bfs_live(n, k, tgt)
    for (i = 0; i < NV; i++) { v = VL[i]
      if (!LIVE[v] || v == tgt) continue
      if (!(v in D)) { unreach++; continue }
      tried++; h = route_star(n, k, v, tgt, "blind")
      if (h == -3) { hole++; continue }
      if (h < 0) { dead++; continue }
      del++ } }
  printf "sweep n=%d k=%d arrangement=%s holes=%d live=%d targets=%d targets_dead=%d components=%d live_diameter=%d blind_pairs=%d blind_delivered=%d blind_holehit=%d unreachable=%d\n",
    n, k, mode, want, LIVEN, tcount, tdead, comps, BIGECC, tried, del, hole, unreach
  CONFIGS++
  UNREACH_TOTAL += unreach
  if (comps > 1) PARTITIONED++
  return 0 }

function nth_live(idx,   i, c) { c = 0
  for (i = 0; i < NV; i++) if (LIVE[VL[i]]) { if (c == idx) return VL[i]; c++ }
  return "" }
# A stride sharing a factor with the count samples along that factor and is blind across it, so the
# stride is walked up until it is coprime with the vertex count.
function coprime_stride(m,   s) { if (m < 3) return 1
  s = int(m / 7) + 1
  while (gcd(s, m) != 1) s++
  return s }
function gcd(a, b,   t) { while (b) { t = a % b; a = b; b = t }; return a }

# ---- the one fault the output cannot show -------------------------------------------------------
# A rule that consulted the breadth-first distance array would print perfect delivery and zero
# stretch and would be exactly the table-bound case wearing the table-free answer. So the script
# reads its own source and refuses when any routing function mentions the distance array.
function rule_purity(self,   line, fn, hits) { hits = 0; fn = ""
  while ((getline line < self) > 0) {
    # THE DECLARATION LINE IS READ, NOT CONSUMED. An awk function body may begin on its own head
    # line, so a fault placed there is exactly where a head-match that skipped ahead would never
    # look -- and where a hand would put it, since it is where the locals are declared.
    if (line ~ /^function (candidates|terminus|route_star|to_frame|from_frame|set_frame)\(/) { fn = "rule" }
    else if (line ~ /^function /) { fn = ""; continue }
    # A COMMENT AT COLUMN ZERO CLOSES THE BODY. Every in-body comment in this file is indented and
    # every between-function comment starts at column zero, so this is where one body
    # ends. Without it the scan runs on to the NEXT `function` line and reads the comment block
    # belonging to the following function as part of the previous one -- which refused this file on
    # its first run, over a line of prose describing the distance array rather than touching it.
    else if (substr(line, 1, 1) == "#") { fn = ""; continue }
    # The word boundary is load-bearing: `CAND[` ends in `D[` and would read as the distance array
    # to a looser pattern, which would refuse a clean file every time.
    if (fn == "rule" && line ~ /(^|[^A-Za-z0-9_])D($|[^A-Za-z0-9_])/) hits++ }
  close(self)
  if (hits) { printf "refused purity routing_functions_reading_distance_array=%d\n", hits; return -1 }
  printf "purity routing_functions_reading_distance_array=0 checked=candidates,terminus,route_star,set_frame,to_frame,from_frame\n"
  return 0 }
'
