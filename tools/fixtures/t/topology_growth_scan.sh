#!/bin/sh
# topology_growth_scan.sh -- what an address space costs while it is still filling.
#
# WHAT THIS MEASURES, AND WHAT IT DOES NOT.
# The sibling churn scan (tools/fixtures/t/topology_churn_scan.sh) prices a FULL address space
# losing a few points. This one prices the opposite and much longer regime: a space that is mostly
# dark and filling up. Every network spends its whole early life here, and the elder papers'
# central object -- one shared routing table, identical at every node because the graph is
# vertex-transitive -- is built for the FULL space and is therefore stale from the first day.
#
# The live set is chosen by an ALLOCATION POLICY, which is the whole subject. Four policies:
#   lowfree     the lowest unused address wins. One shared counter; no knowledge of the graph.
#   random      a pseudorandom subset. What hashing a public key into the space gives you.
#   grow_ball   the lowest free address ADJACENT to a live one, taken breadth-first from a queue.
#   grow_snake  the same rule taken depth-first from a stack.
# The last two are graph-aware and the first two are not; that difference is the finding.
#
# CONNECTIVITY UNDER THE GROW POLICIES IS A TAUTOLOGY, NOT A RESULT. Each grown point attaches to
# a point already live, so the induced subgraph is connected by construction and `components=1`
# carries no information. It is printed anyway so a reader can see it hold, and the readings that
# actually decide something are the stale table's arrival share and the stretch.
#
# NOTHING HERE IMPLEMENTS ANYTHING. comlink/topology.rye publishes the seated three-ring reading;
# this tree holds no routing code and no allocator. Every number below is a measurement of a graph.
set -u

ROOT=$(cd "$(dirname "$0")/../../.." 2>/dev/null && pwd)
[ -n "${ROOT:-}" ] || ROOT=$(pwd)

SCAN_LEGS="${1:-all}"

awk -v LEGS="$SCAN_LEGS" '
# ---- deterministic pseudorandomness, written out rather than borrowed --------------------------
# awk s own rand() is implementation-defined and differs between gawk, mawk and busybox awk, so a
# witness resting on it would read one number on this bench and another on a peer. MINSTD is four
# lines and identical everywhere: the product 16807 * 2147483646 is about 3.6e13, comfortably
# inside the 2^53 an IEEE double holds exactly, so there is no rounding to disagree about.
function srnd(s) { RS_STATE = (s % 2147483647); if (RS_STATE <= 0) RS_STATE += 2147483646 }
function rnd(   ) { RS_STATE = (RS_STATE * 16807) % 2147483647; return RS_STATE / 2147483647 }
function rndint(n) { return int(rnd() * n) % n }

# ---- shape construction: neighbours at nb[v*8 + k] ---------------------------------------------
# Generator order is fixed per shape, since a next-hop table names a generator INDEX. These three
# builders match tools/fixtures/t/topology_churn_scan.sh generator for generator, so the table one
# scan builds indexes correctly in the other. A disagreement would make the two instruments price
# different tables while appearing to price one.
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

# ---- the difference the shape defines, so one table indexes from any node ----------------------
function perm_diff(u, t, out,   i, iv) {
  for (i = 1; i <= 6; i++) iv[PA[u*8+i]] = i
  for (i = 1; i <= 6; i++) out[i] = iv[PA[t*8+i]]
}
function diff_of(kind, v, t, n, a, b, c,   dx, dy, dz, tmp) {
  if (kind == "circ") return (t - v + n) % n
  if (kind == "torus") {
    dx = (int(t/(b*c)) - int(v/(b*c)) + a) % a
    dy = (int(t/c)%b - int(v/c)%b + b) % b
    dz = (t%c - v%c + c) % c
    return (dx*b + dy)*c + dz
  }
  perm_diff(v, t, tmp); return RANK[tmp[1] tmp[2] tmp[3] tmp[4] tmp[5] tmp[6]]
}

# ---- one breadth-first walk from vertex 0 on the INTACT graph -----------------------------------
# DIST0[d] is the exact hop count to difference d on the FULL space. This array is the stale global
# table: every node holds it, it was computed when the space was designed, and it describes a graph
# that is mostly dark. Pricing what it still buys is the point of the scan.
function bfs0(n, nb, deg,   v, w, k, cur, nxt, nc, nn, lev) {
  delete DIST0; delete BRANCH
  DIST0[0] = 0; BRANCH[0] = 0; cur[0] = 0; nc = 1; lev = 0
  while (nc > 0) {
    nn = 0; lev++
    for (k = 0; k < nc; k++) {
      v = cur[k]
      for (w = 0; w < deg; w++) {
        u = nb[v*8+w]
        if (u in DIST0) continue
        DIST0[u] = lev
        # BRANCH[d] is the generator index the IDENTITY takes to start a shortest walk to difference
        # d. At level 1 that is the generator just used; deeper it is inherited from the parent, so
        # one array serves every node once the difference is formed. This is the 3-bit-per-entry
        # next-hop table the elder papers priced at 270 bytes.
        BRANCH[u] = (v == 0 ? w : BRANCH[v])
        nxt[nn++] = u
      }
    }
    delete cur; for (k = 0; k < nn; k++) cur[k] = nxt[k]; delete nxt; nc = nn
  }
}

# ---- the four allocation policies ---------------------------------------------------------------
# Each fills LIVE[] with exactly m addresses out of n. The policies differ in ONE thing: what they
# know. lowfree knows a counter. random knows nothing at all. The two grow policies know the graph.
#
# lowfree -- the lowest unused address. This is what a registry with a counter hands out, and it is
# contiguous IN THE NUMBERING. Whether that means contiguous in the GRAPH is exactly the question:
# a torus numbers by ravelling coordinates, so a block of consecutive indices is a slab; a star
# graph numbers permutations by lexicographic rank, which the transpositions know nothing about.
function fill_lowfree(m, n, LIVE,   i) {
  delete LIVE
  for (i = 0; i < m; i++) LIVE[i] = 1
}
# random -- a pseudorandom m-subset by partial Fisher-Yates over a scratch permutation. This is the
# live set you get when an address is derived from a public key, which is what a self-sovereign
# identity system wants: nobody assigns it, so nobody can withhold it.
function fill_random(m, n, seed, LIVE,   i, j, t, ord) {
  delete LIVE
  srnd(seed)
  for (i = 0; i < n; i++) ord[i] = i
  for (i = 0; i < m; i++) {
    j = i + rndint(n - i)
    t = ord[i]; ord[i] = ord[j]; ord[j] = t
    LIVE[ord[i]] = 1
  }
}
# lowfree_bfs -- the lowest unused address IN A BREADTH-FIRST NUMBERING of the same graph. The
# allocator is still one counter and still knows nothing; the KNOWLEDGE has moved into the
# numbering, which is published once when the space is designed. This is the policy that decides
# whether the disaster below is a fact about lowest-free or a fact about the numbering it inherited.
function fill_lowfree_bfs(m, n, deg, nb, LIVE,   i, v, w, k, cur, nxt, nc, nn, seen, ord, cnt) {
  delete LIVE
  delete seen; cnt = 0
  seen[0] = 1; ord[cnt++] = 0; cur[0] = 0; nc = 1
  while (nc > 0 && cnt < n) {
    nn = 0
    for (k = 0; k < nc; k++) {
      v = cur[k]
      # neighbours are taken in generator order, which is fixed per shape, so the numbering is
      # reproducible rather than dependent on how an array happens to be walked.
      for (w = 0; w < deg; w++) {
        u = nb[v*8+w]
        if (u in seen) continue
        seen[u] = 1; ord[cnt++] = u; nxt[nn++] = u
      }
    }
    delete cur; for (k = 0; k < nn; k++) cur[k] = nxt[k]; delete nxt; nc = nn
  }
  for (i = 0; i < m && i < cnt; i++) LIVE[ord[i]] = 1
}
# grow -- the lowest free address ADJACENT to a live one. mode=ball takes the frontier from the head
# of a queue, mode=snake from the top of a stack. Both are graph-aware; the tie-break is the only
# difference between them, and it decides the SHAPE of what grows -- a compact ball or a long thin
# path. That difference is a second finding rather than a detail.
#
# The seed point is address 0 on every shape. Every shape here is vertex-transitive, so the choice
# of seed cannot matter for lowfree-free policies; it is fixed rather than sampled so the scan
# reproduces byte for byte.
function fill_grow(m, n, deg, nb, mode, LIVE,   i, k, v, w, head, tail, cnt, F, best) {
  delete LIVE
  LIVE[0] = 1; cnt = 1
  head = 0; tail = 0; F[0] = 0
  while (cnt < m && head <= tail) {
    if (mode == "ball") v = F[head]
    else                v = F[tail]
    best = -1
    for (k = 0; k < deg; k++) {
      w = nb[v*8+k]
      if (w in LIVE) continue
      if (best < 0 || w < best) best = w
    }
    if (best < 0) {
      # this frontier point has no free neighbour left; retire it and take the next.
      if (mode == "ball") head++
      else                tail--
      continue
    }
    LIVE[best] = 1; cnt++
    tail++; F[tail] = best
  }
  return cnt
}

# ---- components of the induced subgraph ---------------------------------------------------------
# A live set that is not connected is not a slow network, it is several networks. This counts the
# pieces and sizes the largest, because the difference between "routes badly" and "cannot route at
# all" is the difference a design has to know.
function components(n, deg, nb, LIVE,   i, v, w, k, seen, cur, nxt, nc, nn, comps, sz, big) {
  delete seen; comps = 0; big = 0
  for (i = 0; i < n; i++) {
    if (!(i in LIVE) || (i in seen)) continue
    comps++; sz = 0
    delete cur; delete nxt
    cur[0] = i; nc = 1; seen[i] = 1; sz = 1
    while (nc > 0) {
      nn = 0
      for (k = 0; k < nc; k++) {
        v = cur[k]
        for (w = 0; w < deg; w++) {
          u = nb[v*8+w]
          if (!(u in LIVE) || (u in seen)) continue
          seen[u] = 1; sz++; nxt[nn++] = u
        }
      }
      delete cur; for (k = 0; k < nn; k++) cur[k] = nxt[k]; delete nxt; nc = nn
    }
    if (sz > big) big = sz
  }
  C_BIG = big
  return comps
}

# ---- breadth-first walk on the LIVE subgraph, for the optimum a perfect router would find --------
function bfs_live(src, n, deg, nb, LIVE, PD,   v, w, k, cur, nxt, nc, nn, lev) {
  delete PD
  PD[src] = 0; cur[0] = src; nc = 1; lev = 0
  while (nc > 0) {
    nn = 0; lev++
    for (k = 0; k < nc; k++) {
      v = cur[k]
      for (w = 0; w < deg; w++) {
        u = nb[v*8+w]
        if (!(u in LIVE) || (u in PD)) continue
        PD[u] = lev; nxt[nn++] = u
      }
    }
    delete cur; for (k = 0; k < nn; k++) cur[k] = nxt[k]; delete nxt; nc = nn
  }
}

# ---- the two routing rules, matching the churn scan exactly --------------------------------------
# rule=table    : follow the generator the STALE full-space table names. A dark next hop is a drop.
# rule=distance : descend to the live neighbour whose STALE distance to t is smallest. No strict
#                 decrease available means a local minimum, which is a stall rather than a drop.
# Both read state computed for a space that is mostly dark, which is the honest condition of a
# growing network and the reason the readings differ from the intact case.
function route_table(u, t, deg, nb, LIVE, kind, n, a, b, c,   cur, hops, d, k, w) {
  cur = u; hops = 0
  while (cur != t) {
    if (hops > 4*n) return -2
    d = diff_of(kind, cur, t, n, a, b, c)
    k = BRANCH[d]
    w = nb[cur*8+k]
    if (!(w in LIVE)) return -1
    cur = w; hops++
  }
  return hops
}
function route_dist(u, t, deg, nb, LIVE, D2T,   cur, hops, k, w, bestv, bestd, curd) {
  cur = u; hops = 0
  while (cur != t) {
    if (hops > 4*720) return -2
    curd = D2T[cur]; bestd = curd; bestv = -1
    for (k = 0; k < deg; k++) {
      w = nb[cur*8+k]
      if (!(w in LIVE)) continue
      if (D2T[w] < bestd) { bestd = D2T[w]; bestv = w }
    }
    if (bestv < 0) return -1
    cur = bestv; hops++
  }
  return hops
}

# ---- one row: shape x policy x occupancy ---------------------------------------------------------
# DESTINATIONS ARE SAMPLED at up to SAMPLE points spread by a stride prime to n, because the pass
# costs one breadth-first walk per destination and the scan runs a few hundred configurations. The
# sample is named here rather than left implicit: a curve read from a local sample would say more
# about the sample than about the shape. Sources are EVERY live point.
function growth_row(tag, kind, policy, m, n, a, b, c, deg, nb,   i, t, u, k, rd, rt, dp,
                    LIVE, PD, D2T, comps, pairs, t_arr, t_drop, d_arr, d_stall, d_cyc, d_opt,
                    hops, optsum, optn, got, tried, unreach) {
  if (policy == "lowfree")          fill_lowfree(m, n, LIVE)
  else if (policy == "lowfree_bfs") fill_lowfree_bfs(m, n, deg, nb, LIVE)
  else if (policy == "random")      fill_random(m, n, 20260907 + m, LIVE)
  else if (policy == "grow_ball")   fill_grow(m, n, deg, nb, "ball", LIVE)
  else                              fill_grow(m, n, deg, nb, "snake", LIVE)

  got = 0; for (i in LIVE) got++
  comps = components(n, deg, nb, LIVE)

  pairs = 0; t_arr = 0; t_drop = 0; d_arr = 0; d_stall = 0; d_cyc = 0; d_opt = 0
  hops = 0; optsum = 0; optn = 0; tried = 0; unreach = 0
  for (i = 0; tried < SAMPLE && i < n; i++) {
    t = (i * STRIDE) % n
    if (!(t in LIVE)) continue
    tried++
    bfs_live(t, n, deg, nb, LIVE, PD)
    for (u = 0; u < n; u++) if (u in LIVE) D2T[u] = DIST0[diff_of(kind, u, t, n, a, b, c)]
    for (u = 0; u < n; u++) {
      if (!(u in LIVE) || u == t) continue
      pairs++
      dp = (u in PD ? PD[u] : -1)
      # the optimum is accumulated for EVERY pair the live subgraph connects, rather than only for
      # the pairs that arrived. Accumulating on arrival alone drops exactly the long pairs, so the
      # mean would fall as the space emptied and read like a network getting shorter while it was
      # getting worse. The churn scan learned this and the note travels with the arithmetic.
      if (dp >= 0) { optsum += dp; optn++ } else unreach++
      rt = route_table(u, t, deg, nb, LIVE, kind, n, a, b, c)
      if (rt >= 0) t_arr++; else t_drop++
      rd = route_dist(u, t, deg, nb, LIVE, D2T)
      if (rd == -1) { d_stall++; continue }
      if (rd == -2) { d_cyc++; continue }
      d_arr++; hops += rd
      if (dp >= 0 && rd == dp) d_opt++
    }
  }
  # THE TWO MEANS BELOW ARE OVER DIFFERENT POPULATIONS AND MUST NOT BE DIVIDED. mean_hops averages
  # the pairs that ARRIVED; mean_live_opt averages every pair the live subgraph CONNECTS, which
  # includes the long ones that stall. An early draft printed their ratio as a stretch and it read
  # BELOW ONE on 68 of 96 rows -- routing appearing to beat the optimum, which is the shape a
  # population mismatch takes when it is wrong rather than merely noisy. No stretch is printed
  # because, by the geodesic identity below, there is none to print.
  #
  # THE GEODESIC IDENTITY, proven rather than observed: every generator step changes the full-space
  # distance to t by at most one, since the generator set is symmetric and the shape is a Cayley
  # graph; the graceful rule requires a STRICT decrease; so a walk that arrives has length exactly
  # D2T[u]. A live path of that length cannot be longer than the live distance, and a subgraph
  # cannot be shorter than the full graph, so live distance = full distance = walk length. The rule
  # therefore NEVER routes around a hole -- it walks a fully-live full-space geodesic or it stalls.
  # dist_optimal is that identity restated, which is why it is asserted at zero exceptions below
  # rather than reported as a per-row finding.
  if (d_opt != d_arr) G_NONGEO++
  printf "growth shape=%s policy=%s live=%d occupancy=%.4f components=%d largest=%d connected=%s pairs=%d unreachable=%d table_arrived=%d table_arrival_share=%.6f dist_arrived=%d dist_stalled=%d dist_cycled=%d dist_arrival_share=%.6f geodesic=%s mean_hops=%.4f mean_live_opt=%.4f\n", \
    tag, policy, got, got/n, comps, C_BIG, (comps == 1 ? "yes" : "no"), pairs, unreach, \
    t_arr, (pairs ? t_arr/pairs : 0), \
    d_arr, d_stall, d_cyc, (pairs ? d_arr/pairs : 0), \
    (d_opt == d_arr ? "yes" : "no"), \
    (d_arr ? hops/d_arr : 0), (optn ? optsum/optn : 0)

  G_ROWS++
  if (comps != 1) G_SPLIT++
  # the two buckets split on ONE property: whether the live set was chosen using the graph. A
  # lowest-free counter over a breadth-first numbering counts as aware, because the graph is in the
  # numbering; that is the whole reason the policy is in the scan.
  if (policy == "lowfree" || policy == "random") {
    if (comps == 1) B_BLIND_CONN++
    B_BLIND++
    B_BLIND_TSHARE += (pairs ? t_arr/pairs : 0)
  } else {
    if (comps == 1) B_AWARE_CONN++
    B_AWARE++
    B_AWARE_TSHARE += (pairs ? t_arr/pairs : 0)
  }
}

# ---- the independence leg: why lowest-free fails, proven rather than observed --------------------
# A prefix of the numbering is edgeless exactly when consecutive indices are never adjacent in the
# graph. This leg measures, per shape, the LARGEST m whose first m addresses induce no edge at all,
# and it is the mechanism behind every lowfree row above.
#
# THE STAR GRAPH ANSWER IS A THEOREM AND THE LEG IS ITS CHECK. Lexicographic rank orders the string
# a1a2..a6, so the first 120 ranks are exactly the permutations with a1 = 1. Every star generator
# swaps position 1 with some position j, so a neighbour of such a permutation has a1 = aj which is
# not 1, hence rank at least 120. The first 120 ranks are therefore an independent set: a sixth of
# the space, allocated first by any lowest-free counter, mutually unreachable. The leg proves it by
# counting edges rather than by trusting the argument.
#
# THE MIRROR MATTERS AS MUCH. On the circulant and both tori the generator +1 or its ravel makes
# index i and index i+1 adjacent, so the largest edgeless prefix is 1 and the same allocator is
# accidentally graph-aware. A leg that only showed the star failing could not tell a real property
# from a scan that finds edges nowhere.
function indep_leg(tag, kind, n, deg, nb,   m, i, k, w, edges, best) {
  best = 1
  for (m = 2; m <= n; m++) {
    # only the newly added address m-1 can create an edge inside the prefix, so this is linear.
    edges = 0
    i = m - 1
    for (k = 0; k < deg; k++) { w = nb[i*8+k]; if (w < i) edges++ }
    if (edges > 0) { best = m - 1; break }
  }
  if (m > n) best = n
  printf "indep shape=%s prefix_edgeless_max=%d share_of_space=%.4f\n", tag, best, best/n
  I_ROWS++
  if (tag == "star") I_STAR = best
  else if (best > 1) I_OTHER_BAD++
  return best
}

# ---- the seeds leg: bound the random policy rather than quoting one draw -------------------------
# Every random row above is ONE pseudorandom subset. One draw is an anecdote; this leg redraws the
# same occupancy under several seeds and reports the spread, so a reader can tell a property of the
# policy from an accident of a seed. The seeds are fixed integers rather than clock-derived, so the
# leg reproduces byte for byte.
function seeds_leg(tag, kind, n, deg, nb, m,   sd, LIVE, comps, lo, hi, sum, cnt, big_lo) {
  lo = -1; hi = -1; sum = 0; cnt = 0; big_lo = -1
  for (sd = 1; sd <= 8; sd++) {
    fill_random(m, n, 7919 * sd + 13, LIVE)
    comps = components(n, deg, nb, LIVE)
    if (lo < 0 || comps < lo) lo = comps
    if (hi < 0 || comps > hi) hi = comps
    if (big_lo < 0 || C_BIG < big_lo) big_lo = C_BIG
    sum += comps; cnt++
  }
  printf "seeds shape=%s policy=random live=%d occupancy=%.4f draws=%d components_min=%d components_max=%d components_mean=%.2f largest_min=%d connected_draws=%d\n", \
    tag, m, m/n, cnt, lo, hi, sum/cnt, big_lo, (lo == 1 ? 1 : 0)
  S_ROWS++
  if (lo == 1) S_ANYCONN++
}

BEGIN {
  N = 720
  SAMPLE = 24
  STRIDE = 211        # prime, does not divide 720, so the destination sample is spread not local
  SH_TAG[0] = "circ";    SH_KIND[0] = "circ";  SH_A[0] = 1;  SH_B[0] = 8; SH_C[0] = 75; SH_DEG[0] = 6
  SH_TAG[1] = "torus12"; SH_KIND[1] = "torus"; SH_A[1] = 12; SH_B[1] = 5; SH_C[1] = 12; SH_DEG[1] = 6
  SH_TAG[2] = "torus8";  SH_KIND[2] = "torus"; SH_A[2] = 8;  SH_B[2] = 9; SH_C[2] = 10; SH_DEG[2] = 6
  SH_TAG[3] = "star";    SH_KIND[3] = "star";  SH_A[3] = 0;  SH_B[3] = 0; SH_C[3] = 0;  SH_DEG[3] = 5
  NPOL = 5
  POL[0] = "lowfree"; POL[1] = "random"; POL[2] = "grow_ball"; POL[3] = "grow_snake"
  POL[4] = "lowfree_bfs"
  NOCC = 6
  OCC[0] = 36; OCC[1] = 72; OCC[2] = 144; OCC[3] = 216; OCC[4] = 360; OCC[5] = 540

  build_perms()
  G_ROWS = 0; G_SPLIT = 0; G_NONGEO = 0
  I_ROWS = 0; I_STAR = 0; I_OTHER_BAD = 0
  S_ROWS = 0; S_ANYCONN = 0
  B_BLIND = 0; B_BLIND_CONN = 0; B_BLIND_TSHARE = 0
  B_AWARE = 0; B_AWARE_CONN = 0; B_AWARE_TSHARE = 0

  # A LEG WORD THIS SCAN DOES NOT KNOW REFUSES AT ZERO READINGS rather than quietly running `all`.
  # A typo that silently widened the reach would make a cheap control run the expensive pass and
  # read green for the wrong reason, which is the shape of a bypass.
  if (LEGS != "all" && LEGS != "shape" && LEGS != "growth" && LEGS != "indep" && LEGS != "seeds") {
    printf "verdict=instrument_fault legs=%s faults=1 detail=unknown_leg_word\n", LEGS
    exit 1
  }
  bad = 0

  for (s = 0; s < 4; s++) {
    tag = SH_TAG[s]; kind = SH_KIND[s]; a = SH_A[s]; b = SH_B[s]; c = SH_C[s]; deg = SH_DEG[s]
    delete nb
    if (kind == "circ") circ(N, a, b, c, nb)
    else if (kind == "torus") torus(a, b, c, nb)
    else star(nb)
    bfs0(N, nb, deg)
    # invariant: one walk from the identity must reach every point, or the shape is not the
    # connected Cayley graph the whole scan assumes and no reading below means anything.
    seen = 0; for (d in DIST0) seen++
    if (seen != N) { printf "shape shape=%s VERDICT=disconnected seen=%d\n", tag, seen; bad++; continue }
    dia = 0; for (d in DIST0) if (DIST0[d] > dia) dia = DIST0[d]
    printf "shape shape=%s degree=%d diameter=%d points=%d\n", tag, deg, dia, N
    if (LEGS == "shape") continue
    if (LEGS == "all" || LEGS == "indep") indep_leg(tag, kind, N, deg, nb)
    if (LEGS == "all" || LEGS == "growth")
      for (p = 0; p < NPOL; p++)
        for (o = 0; o < NOCC; o++)
          growth_row(tag, kind, POL[p], OCC[o], N, a, b, c, deg, nb)
    if (LEGS == "all" || LEGS == "seeds")
      for (o = 0; o < NOCC; o++) seeds_leg(tag, kind, N, deg, nb, OCC[o])
  }

  if (LEGS == "all" || LEGS == "growth") {
    printf "blind rows=%d connected=%d mean_table_arrival=%.6f\n", \
      B_BLIND, B_BLIND_CONN, (B_BLIND ? B_BLIND_TSHARE/B_BLIND : 0)
    printf "aware rows=%d connected=%d mean_table_arrival=%.6f\n", \
      B_AWARE, B_AWARE_CONN, (B_AWARE ? B_AWARE_TSHARE/B_AWARE : 0)
    # invariant: the graceful rule walks a fully-live full-space geodesic or stalls, proven in the
    # note beside the row printer. A row where it arrived off a geodesic would mean the argument is
    # wrong, so it is counted here and gated by the witness rather than left to a reader.
    if (G_NONGEO != 0) bad++
  }
  if (LEGS == "all" || LEGS == "indep")
    printf "indep star_prefix_edgeless_max=%d other_shapes_with_edgeless_prefix=%d rows=%d\n", \
      I_STAR, I_OTHER_BAD, I_ROWS
  printf "growth rows=%d split_rows=%d nongeodesic_rows=%d seed_rows=%d seed_rows_any_connected=%d shapes=4 policies=%d occupancies=%d sample=%d\n", \
    G_ROWS, G_SPLIT, G_NONGEO, S_ROWS, S_ANYCONN, NPOL, NOCC, SAMPLE
  printf "verdict=%s legs=%s faults=%d\n", (bad == 0 ? "ok" : "instrument_fault"), LEGS, bad
}
' </dev/null
