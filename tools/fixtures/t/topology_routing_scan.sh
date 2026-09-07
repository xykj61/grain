#!/bin/sh
# tools/fixtures/t/topology_routing_scan.sh -- what it costs a node to DECIDE the next hop, on the
# same 720 points its sibling walked. The elder instrument priced the walk; this one prices the
# decision.
#
# WHY. `topology_attained_scan.sh` measured that a circulant on 720 points walks at diameter 9
# where the seated three-ring torus walks at 14, on the same six edges per point, and closed by
# naming a trade it could not price: a torus's coordinates mean something and route by subtraction,
# while a circulant's jumps are arithmetic that happens to work. That sentence hides two separable
# questions, and only one of them is a judgment:
#
#   1. Can a node route with NO table, by a local rule, and how much longer is that walk?
#   2. If it wants exact routing, what does the table COST?
#
# Both are measurable. The judgment left over -- whether a ring reading is worth paying for -- is
# smaller once they are answered, and this script answers them.
#
# THE ONE STRUCTURAL FACT THIS LEANS ON. Every shape here is a Cayley graph under RIGHT
# multiplication, so it is vertex-transitive: the graph looks the same from every point, and a
# shortest walk depends on the DIFFERENCE between source and destination rather than on the pair.
# One walk from the identity therefore produces the whole answer, and one table indexed by
# difference serves EVERY node rather than each node holding its own. That is leg one's finding,
# and legs four through seven check the shortcut rather than trusting it -- including a leg that
# routes from every one of the 720 sources with the identity's own table.
#
# WHAT IT PRINTS, in seven legs:
#
#   table    -- the exact shared next-hop table per shape. One breadth-first walk from the identity
#               yields both the distance to every point and which of the identity's neighbours
#               starts a shortest path there. Reports entries, bits per entry, and total bytes,
#               against the naive per-node cost of n tables of n-1 entries.
#
#   greedy   -- the table-free local rule per shape, walked to every destination. Reports how many
#               destinations the rule reaches optimally, mean and worst stretch, and the longest
#               walk it produces -- the GREEDY DIAMETER, which is what a design pays if it refuses
#               the table. A rule that fails to arrive inside a hop cap is counted as a miss rather
#               than silently truncated.
#
#   state    -- what a node holds to route at all: its own address in bits, plus the shared table.
#
#   route    -- the table used, from the identity, to every destination, on every shape. Each walk
#               must arrive in exactly the breadth-first distance. This is the table's own proof.
#
#   transit  -- vertex-transitivity itself, checked where it is relied on: a full breadth-first walk
#               from all 720 sources of one shape, every distance compared against the translated
#               from-identity table over all 517,680 ordered pairs.
#
#   anynode  -- the identity's table used from every one of the 720 sources, all ordered pairs, on
#               the shape whose difference is one subtraction. This is the end-to-end claim -- ONE
#               table, EVERY node -- rather than a property argued from the group.
#
#   claims   -- the named findings, each as one key=value line a witness can bind.
#
# WHAT IS MEASURED AND WHAT IS NOT. Every hop count, stretch, and table size here is MEASURED on a
# graph this script builds. The greedy RULES ARE DEFINITIONS -- each is the most natural table-free
# rule for its address space, named in the leg that uses it -- and a better rule for the same shape
# would move that shape's numbers. The circulant is therefore given two rules rather than one, so
# the reading shows what a second unit of local computation buys instead of resting on a single
# heuristic. Nothing here implements anything: `comlink/topology.rye` publishes the seated
# three-ring reading, and no routing code exists in this tree yet.
#
# THE PANCAKE GRAPH IS ABSENT ON PURPOSE. Its sibling measured it at diameter 7, tying the star
# graph. Finding a shortest prefix-reversal walk is the pancake-sorting problem, NP-hard for
# general inputs; naming a greedy rule for it would be inventing a research result rather than
# measuring one. Its exact table is computable and its greedy rule is not, so it would make one leg
# honest and one leg fiction.
#
# ONE KNOB. `SCAN_LEGS` (fast|all, default all). `fast` skips the three checking legs, which are
# the only expensive ones -- it exists for the control, which runs many copies of this script.
#
#   sh tools/fixtures/t/topology_routing_scan.sh
#   SCAN_LEGS=fast sh tools/fixtures/t/topology_routing_scan.sh

set -eu

SCAN_LEGS="${SCAN_LEGS:-all}"

awk -v LEGS="$SCAN_LEGS" '
# ---- shape construction: neighbours at nb[v*8 + k] ----------------------------------------------
# Generator order is fixed per shape, since a next-hop table names a generator INDEX.
function circ(n, g1, g2, g3, nb,   v) {
  for (v = 0; v < n; v++) {
    nb[v*8+0] = (v+g1)%n; nb[v*8+1] = (v-g1+n)%n
    nb[v*8+2] = (v+g2)%n; nb[v*8+3] = (v-g2+n)%n
    nb[v*8+4] = (v+g3)%n; nb[v*8+5] = (v-g3+n)%n
  }
}
function torus(p, q, r, nb,   x, y, z, v) {
  for (x = 0; x < p; x++) for (y = 0; y < q; y++) for (z = 0; z < r; z++) {
    v = (x*q + y)*r + z
    nb[v*8+0] = (((x+1)%p)*q + y)*r + z; nb[v*8+1] = (((x-1+p)%p)*q + y)*r + z
    nb[v*8+2] = (x*q + (y+1)%q)*r + z;   nb[v*8+3] = (x*q + (y-1+q)%q)*r + z
    nb[v*8+4] = (x*q + y)*r + (z+1)%r;   nb[v*8+5] = (x*q + y)*r + (z-1+r)%r
  }
}
# The star graph on S_6: swap position 1 with position j, j = 2..6. A permutation is held both as a
# string (for ranking) and as six integers (for composition), so the difference u^-1 t is six
# lookups rather than a re-parse.
function build_perms(   a, i, s, n) {
  n = 0
  for (a[1] = 1; a[1] <= 6; a[1]++)
  for (a[2] = 1; a[2] <= 6; a[2]++) { if (a[2]==a[1]) continue
  for (a[3] = 1; a[3] <= 6; a[3]++) { if (a[3]==a[1]||a[3]==a[2]) continue
  for (a[4] = 1; a[4] <= 6; a[4]++) { if (a[4]==a[1]||a[4]==a[2]||a[4]==a[3]) continue
  for (a[5] = 1; a[5] <= 6; a[5]++) { if (a[5]==a[1]||a[5]==a[2]||a[5]==a[3]||a[5]==a[4]) continue
  for (a[6] = 1; a[6] <= 6; a[6]++) { if (a[6]==a[1]||a[6]==a[2]||a[6]==a[3]||a[6]==a[4]||a[6]==a[5]) continue
    s = ""; for (i = 1; i <= 6; i++) s = s a[i]
    PERM[n] = s; RANK[s] = n
    for (i = 1; i <= 6; i++) PA[n*8+i] = a[i]
    n++
  }}}}}
  return n
}
function swap1(p, j,   arr, t, i, o) {
  split(p, arr, ""); t = arr[1]; arr[1] = arr[j]; arr[j] = t
  o = ""; for (i = 1; i <= 6; i++) o = o arr[i]; return o
}
function star(nb,   v, j) {
  for (v = 0; v < 720; v++) for (j = 2; j <= 6; j++) nb[v*8 + (j-2)] = RANK[swap1(PERM[v], j)]
}

# ---- one breadth-first walk from vertex 0: exact distance AND exact shared next-hop table --------
# BRANCH[v] is the generator index of the identity neighbour that starts a shortest path to v. That
# array IS the shared table: at node u routing to t, the difference d indexes it and the answer is
# a generator index. DIST0[v] is the exact hop count; BFS_DIA is the largest of them.
function bfs0(n, nb, deg,   i, v, w, k, cur, nxt, nc, nn, lev, seen) {
  delete DIST0; delete BRANCH
  DIST0[0] = 0; BRANCH[0] = -1; seen = 1
  delete cur; cur[0] = 0; nc = 1; lev = 0; BFS_DIA = 0
  while (nc > 0) {
    lev++; nn = 0; delete nxt
    for (i = 0; i < nc; i++) {
      v = cur[i]
      for (k = 0; k < deg; k++) {
        w = nb[v*8 + k]
        if (!(w in DIST0)) {
          DIST0[w] = lev
          BRANCH[w] = (lev == 1 ? k : BRANCH[v])
          if (lev > BFS_DIA) BFS_DIA = lev
          nxt[nn++] = w; seen++
        }
      }
    }
    if (nn == 0) break
    delete cur; for (i = 0; i < nn; i++) cur[i] = nxt[i]; nc = nn
  }
  BFS_SEEN = seen
  return seen
}
# eccentricity of one source, used only by the transitivity leg
function bfs_from(s, n, nb, deg, out,   i, v, w, k, cur, nxt, nc, nn, lev, seen) {
  delete out; out[s] = 0; seen = 1
  delete cur; cur[0] = s; nc = 1; lev = 0
  while (nc > 0) {
    lev++; nn = 0; delete nxt
    for (i = 0; i < nc; i++) {
      v = cur[i]
      for (k = 0; k < deg; k++) {
        w = nb[v*8 + k]
        if (!(w in out)) { out[w] = lev; nxt[nn++] = w; seen++ }
      }
    }
    if (nn == 0) break
    delete cur; for (i = 0; i < nn; i++) cur[i] = nxt[i]; nc = nn
  }
  return seen
}
function bits_for(x,   b) { b = 0; while ((2^b) < x) b++; return (b < 1 ? 1 : b) }

# ---- the table-free rules, one per address space, each named where it is used --------------------
# TORUS. The address is three ring coordinates; the rule reduces the first axis still wrong, taking
# the shorter way round that ring. This is coordinate subtraction and holds no table.
function greedy_torus(src, dst, p, q, r,   x,y,z, tx,ty,tz, hops, cap) {
  z = src % r; y = int(src / r) % q; x = int(src / (q*r))
  tz = dst % r; ty = int(dst / r) % q; tx = int(dst / (q*r))
  hops = 0; cap = 4 * (int(p/2)+int(q/2)+int(r/2)) + 8
  while ((x != tx || y != ty || z != tz) && hops < cap) {
    if (x != tx)      x = ((((tx - x + p) % p) * 2 <= p) ? (x+1)%p : (x-1+p)%p)
    else if (y != ty) y = ((((ty - y + q) % q) * 2 <= q) ? (y+1)%q : (y-1+q)%q)
    else              z = ((((tz - z + r) % r) * 2 <= r) ? (z+1)%r : (z-1+r)%r)
    hops++
  }
  return ((x==tx && y==ty && z==tz) ? hops : -1)
}
# CIRCULANT, rule one. The address is one integer; the only local reading a single integer supports
# is "take the neighbour whose ring distance to the destination is smallest." Ties break toward the
# lower generator index, so the rule is deterministic.
function ring_gap(a, b, n,   d) { d = (b - a + n) % n; return (d*2 <= n ? d : n - d) }
function step_of(v, k, n, g1, g2, g3) {
  if (k == 0) return (v+g1)%n; if (k == 1) return (v-g1+n)%n
  if (k == 2) return (v+g2)%n; if (k == 3) return (v-g2+n)%n
  if (k == 4) return (v+g3)%n; return (v-g3+n)%n
}
function greedy_circ(src, dst, n, g1, g2, g3,   v, hops, cap, k, cand, best, bestv, gap) {
  # invariant: a walk longer than four diameters has failed by any reading, and the leg counts it
  # as a miss rather than letting a broken rule run to 4n hops with 216 evaluations at each one
  v = src; hops = 0; cap = WALK_CAP
  while (v != dst && hops < cap) {
    best = GAP_MAX; bestv = -1
    for (k = 0; k < 6; k++) {
      cand = step_of(v, k, n, g1, g2, g3)
      gap = ring_gap(cand, dst, n)
      if (gap < best) { best = gap; bestv = cand }
    }
    if (bestv < 0) return -1
    v = bestv; hops++
  }
  return (v == dst ? hops : -1)
}
# CIRCULANT, rule two. The same reading with one more unit of local computation: score each first
# hop by the best ring distance reachable in a SECOND hop, thirty-six evaluations rather than six.
# It holds no table either, so the pair prices what lookahead buys against what a table buys.
function best_gap(v, depth, dst, n, g1, g2, g3,   k, c, g, best) {
  # A gap of -1 marks "the destination itself," which beats any real gap. The sentinel is a large
  # number rather than a negative one, because a negative sentinel and a negative reading are the
  # same value, and the comparison then keeps the last candidate rather than the best one.
  if (depth == 0) return ring_gap(v, dst, n)
  best = GAP_MAX
  for (k = 0; k < 6; k++) {
    c = step_of(v, k, n, g1, g2, g3)
    g = (c == dst ? -1 : best_gap(c, depth-1, dst, n, g1, g2, g3))
    if (g < best) best = g
  }
  return best
}
function greedy_circ_d(src, dst, depth, n, g1, g2, g3,   v, hops, cap, k, c, g, best, bestv) {
  v = src; hops = 0; cap = WALK_CAP
  while (v != dst && hops < cap) {
    best = GAP_MAX; bestv = -1
    for (k = 0; k < 6; k++) {
      c = step_of(v, k, n, g1, g2, g3)
      if (c == dst) { bestv = c; break }
      g = best_gap(c, depth-1, dst, n, g1, g2, g3)
      if (g < best) { best = g; bestv = c }
    }
    if (bestv < 0) return -1
    v = bestv; hops++
  }
  return (v == dst ? hops : -1)
}
# STAR. The address is a permutation; the standard rule holds no table -- if position 1 carries a
# symbol that is not home, swap it home; otherwise swap in any symbol that is not home. Routing
# from u to t means sorting the difference u^-1 t, so the rule reads that permutation.
function perm_diff(u, t, out,   i, iv) {
  for (i = 1; i <= 6; i++) iv[PA[u*8+i]] = i
  for (i = 1; i <= 6; i++) out[i] = iv[PA[t*8+i]]
}
function greedy_star(src, dst,   arr, i, hops, cap, s, moved) {
  perm_diff(src, dst, arr); hops = 0; cap = 32
  while (hops < cap) {
    moved = 0
    for (i = 1; i <= 6; i++) if (arr[i] != i) { moved = 1; break }
    if (!moved) break
    s = arr[1]
    if (s != 1) { arr[1] = arr[s]; arr[s] = s }
    else { for (i = 2; i <= 6; i++) if (arr[i] != i) break; arr[1] = arr[i]; arr[i] = 1 }
    hops++
  }
  for (i = 1; i <= 6; i++) if (arr[i] != i) return -1
  return hops
}
# The first hop each depth would take, read through the SAME scoring the walk uses, so a change to
# one can never leave the other measuring a different rule.
function first_hop_circ(dst, depth, n, g1, g2, g3,   k, c, g, best, bestv) {
  best = GAP_MAX; bestv = -1
  for (k = 0; k < 6; k++) {
    c = step_of(0, k, n, g1, g2, g3)
    if (c == dst) return c
    g = (depth <= 1 ? ring_gap(c, dst, n) : best_gap(c, depth-1, dst, n, g1, g2, g3))
    if (g < best) { best = g; bestv = c }
  }
  return bestv
}
function greedy_call(kind, src, dst, n, a, b, c) {
  if (kind == "torus") return greedy_torus(src, dst, a, b, c)
  if (kind == "circ")  return greedy_circ(src, dst, n, a, b, c)
  if (kind == "circ2") return greedy_circ_d(src, dst, 2, n, a, b, c)
  if (kind == "circ3") return greedy_circ_d(src, dst, 3, n, a, b, c)
  return greedy_star(src, dst)
}
function greedy_leg(tag, rule, n, kind, a, b, c,   v, g, d, opt, worst, sum, miss, gdia, st) {
  opt = 0; worst = 0; sum = 0; miss = 0; gdia = 0; hopsum = 0
  for (v = 1; v < n; v++) {
    g = greedy_call(kind, 0, v, n, a, b, c)
    d = DIST0[v]
    if (g < 0) { miss++; continue }
    if (g > gdia) gdia = g
    hopsum += g
    st = g - d
    if (st == 0) opt++
    if (st > worst) worst = st
    sum += st
  }
  printf "greedy shape=%s rule=%s destinations=%d optimal=%d exact_share=%.4f total_hops=%d mean_hops=%.4f mean_stretch=%.4f worst_stretch=%d greedy_diameter=%d true_diameter=%d unreached=%d\n", \
    tag, rule, n-1, opt, opt/(n-1), hopsum, hopsum/(n-1), sum/(n-1), worst, gdia, BFS_DIA, miss
  G_OPT = opt; G_MISS = miss; G_DIA = gdia; G_WORST = worst; G_SUM = hopsum
}
# ---- routing WITH the table, from one source, using the difference the shape defines -------------
function route_hops(kind, src, dst, n, a, b, c, deg, nb,   v, hops, cap, d, k, dx,dy,dz, tmp) {
  v = src; hops = 0; cap = 4 * n
  while (v != dst && hops < cap) {
    if (kind == "circ") d = (dst - v + n) % n
    else if (kind == "torus") {
      dx = (int(dst/(b*c)) - int(v/(b*c)) + a) % a
      dy = (int(dst/c)%b - int(v/c)%b + b) % b
      dz = (dst%c - v%c + c) % c
      d = (dx*b + dy)*c + dz
    } else { perm_diff(v, dst, tmp); d = RANK[tmp[1] tmp[2] tmp[3] tmp[4] tmp[5] tmp[6]] }
    k = BRANCH[d]
    if (k < 0 || k >= deg) return -1
    v = nb[v*8 + k]; hops++
  }
  return (v == dst ? hops : -1)
}

BEGIN {
  N = 720
  GAP_MAX = 1000000
  WALK_CAP = 64
  bad = 0
  print "topology-routing: what the next hop costs to decide, on 720 points."
  if (LEGS != "all" && LEGS != "fast") { print "refused: SCAN_LEGS must be all or fast"; exit 1 }
  printf "legs=%s points=%d\n", LEGS, N
  print ""

  build_perms()

  S_TAG[0]="torus_12x5x12"; S_KIND[0]="torus"; S_A[0]=12; S_B[0]=5;  S_C[0]=12; S_DEG[0]=6; S_RULE[0]="axis_subtract"
  S_TAG[1]="torus_8x9x10";  S_KIND[1]="torus"; S_A[1]=8;  S_B[1]=9;  S_C[1]=10; S_DEG[1]=6; S_RULE[1]="axis_subtract"
  S_TAG[2]="circ_1_8_75";   S_KIND[2]="circ";  S_A[2]=1;  S_B[2]=8;  S_C[2]=75; S_DEG[2]=6; S_RULE[2]="ring_gap_min"
  S_TAG[3]="star_S6";       S_KIND[3]="star";  S_A[3]=0;  S_B[3]=0;  S_C[3]=0;  S_DEG[3]=5; S_RULE[3]="sort_the_difference"
  NS = 4

  # ---- leg one: the exact shared table ----------------------------------------------------------
  for (i = 0; i < NS; i++) {
    delete nb
    if (S_KIND[i] == "torus") torus(S_A[i], S_B[i], S_C[i], nb)
    else if (S_KIND[i] == "circ") circ(N, S_A[i], S_B[i], S_C[i], nb)
    else star(nb)
    if (bfs0(N, nb, S_DEG[i]) != N) { printf "table shape=%s not_connected reached=%d of=%d\n", S_TAG[i], BFS_SEEN, N; bad++; continue }
    esum = 0; for (v = 1; v < N; v++) esum += DIST0[v]
    bpe = bits_for(S_DEG[i])
    # invariant: an entry must be able to name every generator, or the table cannot route at all
    if (2^bpe < S_DEG[i]) { printf "table shape=%s entry_too_narrow bits=%d degree=%d\n", S_TAG[i], bpe, S_DEG[i]; bad++ }
    bytes = int((((N-1) * bpe) + 7) / 8)
    naive_bytes = int(((N * (N-1) * bpe) + 7) / 8)
    printf "table shape=%s degree=%d diameter=%d exact_mean_hops=%.4f entries=%d bits_per_entry=%d shared_bytes=%d naive_bytes=%d ratio=%d\n", \
      S_TAG[i], S_DEG[i], BFS_DIA, esum/(N-1), N-1, bpe, bytes, naive_bytes, N
    lo = 99; hi = -1
    for (v = 1; v < N; v++) { if (BRANCH[v] < lo) lo = BRANCH[v]; if (BRANCH[v] > hi) hi = BRANCH[v] }
    if (lo < 0 || hi >= S_DEG[i]) { printf "table shape=%s branch_out_of_range lo=%d hi=%d\n", S_TAG[i], lo, hi; bad++ }
    SHAPE_DIA[i] = BFS_DIA; SHAPE_BYTES[i] = bytes
    for (v = 0; v < N; v++) { KD[i "," v] = DIST0[v]; KB[i "," v] = BRANCH[v] }
  }
  print ""

  # ---- leg two: the table-free rule ---------------------------------------------------------------
  for (i = 0; i < NS; i++) {
    for (v = 0; v < N; v++) DIST0[v] = KD[i "," v]
    BFS_DIA = SHAPE_DIA[i]; WALK_CAP = 4 * SHAPE_DIA[i] + 8
    greedy_leg(S_TAG[i], S_RULE[i], N, S_KIND[i], S_A[i], S_B[i], S_C[i])
    SHAPE_GOPT[i] = G_OPT; SHAPE_GMISS[i] = G_MISS; SHAPE_GDIA[i] = G_DIA; SHAPE_GWORST[i] = G_WORST; SHAPE_GSUM[i] = G_SUM
    if (G_MISS > 0) bad++
  }
  # the circulant a second time, with one more unit of local computation and still no table
  for (v = 0; v < N; v++) DIST0[v] = KD["2," v]
  BFS_DIA = SHAPE_DIA[2]; WALK_CAP = 4 * SHAPE_DIA[2] + 8
  greedy_leg("circ_1_8_75", "ring_gap_min_depth2", N, "circ2", 1, 8, 75)
  C2_OPT = G_OPT; C2_DIA = G_DIA; C2_SUM = G_SUM; if (G_MISS > 0) bad++
  greedy_leg("circ_1_8_75", "ring_gap_min_depth3", N, "circ3", 1, 8, 75)
  C3_OPT = G_OPT; C3_DIA = G_DIA; C3_SUM = G_SUM; if (G_MISS > 0) bad++
  # The depths agree on the total, and the sharpest sentence in the paper is that they nonetheless walk
  # DIFFERENT paths. That is a separate reading and it is measured here rather than asserted: count
  # the destinations whose FIRST hop differs between depth 1 and depth 2, and the destinations whose
  # hop COUNT differs. A rule that agreed on both would make the insensitivity trivial.
  fh = 0; hc = 0
  for (v = 1; v < N; v++) {
    a1 = first_hop_circ(v, 1, N, 1, 8, 75); a2 = first_hop_circ(v, 2, N, 1, 8, 75)
    if (a1 != a2) fh++
    if (greedy_circ(0, v, N, 1, 8, 75) != greedy_circ_d(0, v, 2, N, 1, 8, 75)) hc++
  }
  printf "lookahead_paths shape=circ_1_8_75 destinations=%d first_hop_differs=%d hop_count_differs=%d\n", N-1, fh, hc
  print ""

  # ---- leg three: what a node holds ---------------------------------------------------------------
  printf "state shape=torus_12x5x12 address_bits=%d table_bytes=%d table_free_rule=%s\n", bits_for(12)+bits_for(5)+bits_for(12), SHAPE_BYTES[0], (SHAPE_GOPT[0] == N-1 ? "exact" : "approximate")
  printf "state shape=torus_8x9x10 address_bits=%d table_bytes=%d table_free_rule=%s\n",  bits_for(8)+bits_for(9)+bits_for(10), SHAPE_BYTES[1], (SHAPE_GOPT[1] == N-1 ? "exact" : "approximate")
  printf "state shape=circ_1_8_75 address_bits=%d table_bytes=%d table_free_rule=%s\n",   bits_for(N), SHAPE_BYTES[2], (SHAPE_GOPT[2] == N-1 ? "exact" : "approximate")
  # A permutation of six symbols carries log2(720) = 9.49 bits, so 10 bits addresses it. Routing
  # reads the symbols, so the working form is six of them unpacked; both are printed rather than
  # one chosen, since packing is free to store and costs an unranking to use.
  printf "state shape=star_S6 address_bits=%d address_bits_packed=%d table_bytes=%d table_free_rule=%s\n", 6*bits_for(6), bits_for(N), SHAPE_BYTES[3], (SHAPE_GOPT[3] == N-1 ? "exact" : "approximate")
  print ""

  # ---- leg four: the table used, from the identity, on every shape --------------------------------
  for (i = 0; i < NS; i++) {
    delete nb
    if (S_KIND[i] == "torus") torus(S_A[i], S_B[i], S_C[i], nb)
    else if (S_KIND[i] == "circ") circ(N, S_A[i], S_B[i], S_C[i], nb)
    else star(nb)
    for (v = 0; v < N; v++) { DIST0[v] = KD[i "," v]; BRANCH[v] = KB[i "," v] }
    ok = 0; wrong = 0
    for (v = 1; v < N; v++) {
      h = route_hops(S_KIND[i], 0, v, N, S_A[i], S_B[i], S_C[i], S_DEG[i], nb)
      if (h == DIST0[v]) ok++; else wrong++
    }
    printf "route shape=%s source=identity destinations=%d exact=%d wrong=%d\n", S_TAG[i], N-1, ok, wrong
    if (wrong > 0) bad++
  }
  print ""

  if (LEGS == "fast") { print "transit skipped legs=fast"; print "anynode skipped legs=fast"; print "" }
  else {
    # ---- leg five: vertex-transitivity, checked where it is relied on -----------------------------
    delete nb; circ(N, 1, 8, 75, nb); bfs0(N, nb, 6)
    WALK_CAP = 4 * BFS_DIA + 8
    for (v = 0; v < N; v++) D0[v] = DIST0[v]
    mism = 0; pairs = 0
    for (s = 0; s < N; s++) {
      bfs_from(s, N, nb, 6, DS)
      for (t = 0; t < N; t++) { if (s == t) continue; pairs++; if (DS[t] != D0[(t - s + N) % N]) mism++ }
    }
    printf "transit shape=circ_1_8_75 pairs=%d mismatches=%d %s\n", pairs, mism, (mism == 0 ? "agree" : "DISAGREE")
    if (mism > 0) bad++

    # ---- leg six: ONE table, EVERY node ------------------------------------------------------------
    for (v = 0; v < N; v++) { DIST0[v] = KD["2," v]; BRANCH[v] = KB["2," v] }
    ok = 0; wrong = 0
    for (s = 0; s < N; s++) for (t = 0; t < N; t++) {
      if (s == t) continue
      h = route_hops("circ", s, t, N, 1, 8, 75, 6, nb)
      if (h == DIST0[(t - s + N) % N]) ok++; else wrong++
    }
    printf "anynode shape=circ_1_8_75 sources=%d pairs=%d exact=%d wrong=%d\n", N, ok+wrong, ok, wrong
    if (wrong > 0) bad++

    # ---- leg seven: the greedy rule from a source that is not the identity -------------------------
    # This defends the IMPLEMENTATION, rather than an independent fact: the rule reads only the ring
    # gap, which is translation-invariant, so the from-identity reading is complete unless the code
    # says otherwise. A leg that can only agree is worth its seconds and nothing more, and it is
    # named that way rather than counted as evidence for the finding.
    dis = 0
    for (s = 0; s < N; s++) for (t = 0; t < N; t++) {
      if (s == t) continue
      if (greedy_circ(s, t, N, 1, 8, 75) != greedy_circ(0, (t - s + N) % N, N, 1, 8, 75)) dis++
    }
    printf "greedy_translation shape=circ_1_8_75 pairs=%d disagreements=%d defends=implementation_only\n", N*(N-1), dis
    if (dis > 0) bad++
    print ""
  }

  # ---- leg eight: the named claims ----------------------------------------------------------------
  printf "claim torus_greedy_exact=%s\n", (SHAPE_GOPT[0] == N-1 && SHAPE_GOPT[1] == N-1 ? "yes" : "no")
  printf "claim star_greedy_exact=%s\n", (SHAPE_GOPT[3] == N-1 ? "yes" : "no")
  printf "claim circulant_greedy_exact=%s share=%.4f\n", (SHAPE_GOPT[2] == N-1 ? "yes" : "no"), SHAPE_GOPT[2]/(N-1)
  printf "claim circulant_greedy_depth2_exact=%s share=%.4f\n", (C2_OPT == N-1 ? "yes" : "no"), C2_OPT/(N-1)
  printf "claim lookahead_total_hops depth1=%d depth2=%d depth3=%d buys=%d\n", SHAPE_GSUM[2], C2_SUM, C3_SUM, SHAPE_GSUM[2] - C3_SUM
  printf "claim shared_table_bytes=%d naive_ratio=%d\n", SHAPE_BYTES[2], N
  printf "claim circulant_greedy_diameter=%d depth2_diameter=%d true_diameter=%d seated_torus_diameter=%d\n", SHAPE_GDIA[2], C2_DIA, SHAPE_DIA[2], SHAPE_DIA[0]
  printf "claim tableless_circulant_beats_seated_torus=%s\n", (SHAPE_GDIA[2] < SHAPE_DIA[0] ? "yes" : "no")
  print ""
  printf "verdict=%s\n", (bad == 0 ? "ok" : "instrument_fault")
  exit (bad == 0 ? 0 : 1)
}
' </dev/null
