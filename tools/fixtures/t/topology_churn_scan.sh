#!/bin/sh
# tools/fixtures/t/topology_churn_scan.sh -- what one departure costs a network that agreed on one
# routing table. The sibling instrument priced the DECISION; this one prices the DEPARTURE.
#
# WHY. `topology_routing_scan.sh` measured that the exact routing table for a 720-node Cayley graph
# is 270 bytes and is the SAME 270 bytes at every node, because the graph is vertex-transitive and a
# route depends on the difference rather than on the pair. That is a beautiful reading and it rests
# on a condition a real network breaks the first afternoon it runs: the graph has to be the WHOLE
# group. Remove one point and vertex-transitivity is gone, so the argument that produced the shared
# table no longer applies to the graph the survivors are standing on. Its own coverage section named
# the gap plainly -- "how either shape behaves when a node leaves" -- and left it outside.
#
# THE QUESTION, IN THE FORM THAT DECIDES SOMETHING. Nobody rebuilds global state per departure, so
# the design question is not what a rebuilt table would say. It is whether the survivors can keep
# using the table they already agreed on, and what that costs them:
#
#   1. How much longer is the walk once a point is gone, at all, even routed perfectly?
#   2. How much of that damage does the STALE shared table actually deliver?
#   3. How many nodes need a different table -- the blast radius, counted in nodes rather than pairs?
#   4. How does the answer bend as departures accumulate, and does clustering matter?
#
# TWO PIECES OF NODE STATE, PRICED AGAINST EACH OTHER. The sibling's table holds a GENERATOR INDEX
# per difference -- 719 entries at 3 bits, 270 bytes -- and it is a projection of the walk that built
# it. The same walk also yields a DISTANCE per difference -- 719 entries at 4 bits, 360 bytes -- from
# which the generator index is recoverable by picking the neighbour whose distance is one less. On
# the intact graph the two route identically. Under puncture they part company, and the 90 bytes are
# exactly what the parting costs:
#
#   table     270 bytes. At a dead next hop there is nothing else to read, so the packet is dropped.
#   distance  360 bytes. At any node, descend to the LIVE neighbour whose stale distance to the
#             destination is smallest. On the intact graph this is exact; punctured it is a
#             heuristic that may stall or cycle, and the leg counts both.
#
# WHY ONE REMOVED POINT IS REPRESENTATIVE, AND WHY IT IS STILL CHECKED. G minus v is isomorphic to
# G minus w for any two points of a vertex-transitive graph, so the single-departure readings do not
# depend on WHICH point left. That is an argument, and the `hole` leg checks it by removing three
# different points and requiring the readings to agree exactly.
#
# WHAT IT PRINTS, in seven legs and a claims line:
#
#   hole    -- the same single-departure reading taken at three different removed points, proving
#              the choice immaterial rather than assuming it. The sample TRANSLATES with the hole,
#              since the isomorphism between two punctured copies is a translation and a sample
#              fixed in absolute numbering names a different relative set at each probe.
#   blast   -- exact all-pairs distance on the punctured graph against the intact one. Damaged
#              pairs, disconnected pairs, extra hops, worst increase, diameter before and after,
#              and the increase histogram, since a bipartite shape pays its detours in twos.
#              This is the floor: what a PERFECT rebuild would still cost.
#   predict -- the drop count computed from the intact walk BEFORE it is measured. A departure kills
#              the routes that crossed it, so the share lost is (mean hops - 1) / (n - 1). The
#              residual is what says the mechanism is that one rather than something else.
#   stale   -- every surviving ordered pair routed with the intact table, both readings, against the
#              punctured optimum from `blast`. Arrivals, drops, stalls, cycles, and stretch.
#   entry   -- how many of the shared table's own entries stop naming a first hop on a shortest
#              punctured walk, split by CAUSE: a dead first hop, which a node sees for itself, and
#              a live hop whose onward path broke, which it cannot.
#   patch   -- how many surviving nodes route every destination at the punctured optimum with the
#              stale state, and how many destinations the rest miss. The blast radius in NODES,
#              which is a different count from the entry one and disagrees with it by 7x.
#   curve   -- k departures for k in 1,2,4,8,16,32,64, spread and clustered, arrival rate and mean
#              hops under the distance reading. Sources are sampled and the sample is named.
#   claims  -- the named findings, each as one key=value line a witness can bind.
#
# WHAT IS MEASURED AND WHAT IS NOT. Every distance, arrival, drop, and stretch here is measured on a
# graph this script builds and walks. The two fallback readings ARE DEFINITIONS -- the most natural
# rule each piece of state supports -- and a better rule for the same state would move its numbers.
# The removal patterns are definitions too, both stated in the leg that uses them. Nothing here
# implements anything: `comlink/topology.rye` publishes the seated three-ring reading, and this tree
# holds no routing code at all.
#
# ONE KNOB. `SCAN_LEGS` (all|fast|hole|curve, default all), for the control, which runs eleven
# copies of this script and would otherwise spend twenty-five minutes proving ten plants. `fast`
# runs one shape at k=1 and skips the hole and curve legs; `hole` and `curve` run one leg alone.
# An UNKNOWN word refuses at zero rather than running a reduced pass under a name nobody meant --
# a knob that silently narrows is how a green comes to measure less than its reader believes.
# Every run prints its own `legs=` line, so each reading announces its reach.
#
#   sh tools/fixtures/t/topology_churn_scan.sh
#   SCAN_LEGS=fast sh tools/fixtures/t/topology_churn_scan.sh

set -eu

SCAN_LEGS="${SCAN_LEGS:-all}"

awk -v LEGS="$SCAN_LEGS" '
# ---- shape construction: neighbours at nb[v*8 + k] ----------------------------------------------
# Generator order is fixed per shape, since a next-hop table names a generator INDEX. These three
# builders match the sibling scan generator for generator, so a table built there indexes here.
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

# ---- the difference the shape defines, so one table indexes from any node ------------------------
# invariant: every shape here is a Cayley graph under right multiplication, so diff(v,t) is the
# group element carrying v to t and the table is indexed by it. These three cases match the sibling
# scan exactly; a disagreement would make the two instruments measure different tables.
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

# ---- one breadth-first walk from vertex 0 on the INTACT graph ------------------------------------
# DIST0[d] is the exact hop count to difference d, and BRANCH[d] the generator index of the identity
# neighbour that starts a shortest path there. Those two arrays ARE the node state this scan prices.
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
# breadth-first from one source with a set of points removed. DEAD[] is the removal set.
function bfs_punct(s, n, nb, deg, out,   i, v, w, k, cur, nxt, nc, nn, lev, seen) {
  delete out; out[s] = 0; seen = 1
  delete cur; cur[0] = s; nc = 1; lev = 0; PUNCT_ECC = 0
  while (nc > 0) {
    lev++; nn = 0; delete nxt
    for (i = 0; i < nc; i++) {
      v = cur[i]
      for (k = 0; k < deg; k++) {
        w = nb[v*8 + k]
        if (w in DEAD) continue
        if (!(w in out)) { out[w] = lev; PUNCT_ECC = lev; nxt[nn++] = w; seen++ }
      }
    }
    if (nn == 0) break
    delete cur; for (i = 0; i < nn; i++) cur[i] = nxt[i]; nc = nn
  }
  return seen
}
function bits_for(x,   b) { b = 0; while ((2^b) < x) b++; return (b < 1 ? 1 : b) }


# ---- the two readings, hoisted per DESTINATION so a walk step is an array read ------------------
# The scan loops destinations on the outside and precomputes, for one destination t, the stale
# distance D2T[v] and the stale branch B2T[v] at every point. A walk then costs array reads rather
# than a group operation per hop, which is what makes an all-pairs pass affordable on a permutation
# address where a difference is fifteen operations.
function route_table_t(u, t, deg, nb, B2T,   v, hops, k, w) {
  v = u; hops = 0
  while (v != t && hops < WALK_CAP) {
    k = B2T[v]
    # invariant: a generator index outside the shape degree means the table was misbuilt, and the
    # walk reports a drop rather than indexing a neighbour that does not exist
    if (k < 0 || k >= deg) return -1
    w = nb[v*8 + k]
    if (w in DEAD) return -1
    v = w; hops++
  }
  return (v == t ? hops : -1)
}
function route_dist_t(u, t, deg, nb, D2T,   v, hops, k, w, e, best, bestw, seenv) {
  v = u; hops = 0; delete seenv; seenv[v] = 1
  while (v != t && hops < WALK_CAP) {
    best = GAP_MAX; bestw = -1
    for (k = 0; k < deg; k++) {
      w = nb[v*8 + k]
      if (w in DEAD) continue
      e = D2T[w]
      if (e < best) { best = e; bestw = w }
    }
    if (bestw < 0) return -1
    v = bestw; hops++
    # invariant: a shortest walk never revisits a point, so a revisit is a cycle rather than a
    # slow arrival, and it is counted apart from a stall because the two want different repairs
    if (v in seenv) return -2
    seenv[v] = 1
  }
  return (v == t ? hops : -1)
}
# RULE "distance_nr": the same 360 bytes of NODE state plus a visited set the PACKET carries -- a
# different resource, named as one. Among live neighbours not yet on this walk, descend to the
# smallest stale distance. A packet that has visited every live neighbour stalls; it can never
# cycle, because the rule forbids it by construction.
function route_dist_nr(u, t, deg, nb, D2T,   v, hops, k, w, e, best, bestw, seenv) {
  v = u; hops = 0; delete seenv; seenv[v] = 1
  while (v != t && hops < WALK_CAP) {
    best = GAP_MAX; bestw = -1
    for (k = 0; k < deg; k++) {
      w = nb[v*8 + k]
      if (w in DEAD || (w in seenv)) continue
      e = D2T[w]
      if (e < best) { best = e; bestw = w }
    }
    if (bestw < 0) return -1
    v = bestw; hops++; seenv[v] = 1
  }
  return (v == t ? hops : -1)
}

# ---- the removal sets, both named where they are built ------------------------------------------
# SPREAD. Points i*137 mod 720 for i in 0..k-1. 137 is coprime to 720, so the set is even around the
# circulant ring and an arbitrary scattering on the other two address spaces. This is the
# independent-departure model: k nodes leave for k unrelated reasons.
function dead_spread(k, n,   i) { delete DEAD; for (i = 0; i < k; i++) DEAD[(i*137) % n] = 1 }
# CLUSTER. A breadth-first ball around point 0: point 0, then its neighbours, then theirs, until k
# points are taken. This is clustered in EVERY shape rather than in the index, which is what makes it
# the correlated-failure model -- one region, one rack, one operator going dark together.
function dead_ball(k, n, nb, deg,   i, v, w, kk, q, qh, qt, taken) {
  delete DEAD; delete q; qh = 0; qt = 0; q[qt++] = 0; DEAD[0] = 1; taken = 1
  while (qh < qt && taken < k) {
    v = q[qh++]
    for (kk = 0; kk < deg && taken < k; kk++) {
      w = nb[v*8 + kk]
      if (w in DEAD) continue
      DEAD[w] = 1; q[qt++] = w; taken++
    }
  }
  return taken
}

# ---- the full pass: blast, stale, and patch in one walk of the destinations ----------------------
# One breadth-first search per destination on the punctured graph gives the exact punctured distance
# from every survivor, since the graph is undirected. Everything else is read against that.
function full_pass(tag, kind, n, a, b, c, deg, nb,   t, u, d0, dp, rt, rd, rn, w, i,
                   D2T, B2T, PD, pairs, damaged, disc, extra, worst, dia_p,
                   t_arr, t_drop, t_opt, t_extra, d_arr, d_stall, d_cyc, d_opt, d_extra, d_worst,
                   n_arr, n_stall, n_opt, n_extra, n_worst, ent_bad, ent_nodes, ent_max,
                   ent_dead, ent_path, ering, deadv0, dhist, meanh, predicted,
                   clean, missnodes, ring, deadv, dsum, tclean, tmiss) {
  pairs = 0; damaged = 0; disc = 0; extra = 0; worst = 0; dia_p = 0
  t_arr = 0; t_drop = 0; t_opt = 0; t_extra = 0
  d_arr = 0; d_stall = 0; d_cyc = 0; d_opt = 0; d_extra = 0; d_worst = 0
  n_arr = 0; n_stall = 0; n_opt = 0; n_extra = 0; n_worst = 0
  ent_bad = 0; ent_nodes = 0; ent_max = 0; ent_dead = 0; ent_path = 0; delete ering; delete dhist
  delete SRC_MISS; delete TAB_MISS; delete ENT_BAD
  deadv0 = -1; for (i = 0; i < n; i++) if (i in DEAD) { deadv0 = i; break }
  for (t = 0; t < n; t++) {
    if (t in DEAD) continue
    bfs_punct(t, n, nb, deg, PD)
    for (u = 0; u < n; u++) {
      if (u in DEAD) continue
      D2T[u] = DIST0[diff_of(kind, u, t, n, a, b, c)]
      B2T[u] = BRANCH[diff_of(kind, u, t, n, a, b, c)]
    }
    for (u = 0; u < n; u++) {
      if (u in DEAD || u == t) continue
      pairs++
      d0 = D2T[u]
      if (!(u in PD)) { disc++; SRC_MISS[u]++; continue }
      dp = PD[u]
      if (dp > dia_p) dia_p = dp
      if (dp > d0) { damaged++; extra += dp - d0; dhist[dp - d0]++; if (dp - d0 > worst) worst = dp - d0 }
      # THE ENTRY QUESTION, asked directly: is the shared table entry for this difference
      # still a first hop on a shortest PUNCTURED walk? A live neighbour one step closer is the
      # whole test, and a destination no longer reachable makes the entry meaningless rather than
      # merely long, so it counts as changed.
      # And the CAUSE is split, because the two want different repairs. A dead first hop is
      # something the node can see for itself -- its own neighbour stopped answering. A live first
      # hop whose onward path broke is invisible from here, and needs word from further away.
      w = nb[u*8 + B2T[u]]
      if (w in DEAD) {
        ent_bad++; ENT_BAD[u]++; ent_dead++
        ering[DIST0[diff_of(kind, deadv0, u, n, a, b, c)]]++
      } else if (!(w in PD) || PD[w] != dp - 1) {
        ent_bad++; ENT_BAD[u]++; ent_path++
        ering[DIST0[diff_of(kind, deadv0, u, n, a, b, c)]]++
      }
      rt = route_table_t(u, t, deg, nb, B2T)
      if (rt < 0) { t_drop++; TAB_MISS[u]++ }
      else { t_arr++; if (rt == dp) t_opt++; else { t_extra += rt - dp; TAB_MISS[u]++ } }
      rn = route_dist_nr(u, t, deg, nb, D2T)
      if (rn < 0) n_stall++
      else { n_arr++; if (rn > n_worst) n_worst = rn; if (rn == dp) n_opt++; else n_extra += rn - dp }
      rd = route_dist_t(u, t, deg, nb, D2T)
      if (rd == -1) { d_stall++; SRC_MISS[u]++ }
      else if (rd == -2) { d_cyc++; SRC_MISS[u]++ }
      else {
        d_arr++
        if (rd == dp) d_opt++
        else { d_extra += rd - dp; SRC_MISS[u]++; if (rd - dp > d_worst) d_worst = rd - dp }
      }
    }
  }
  printf "blast shape=%s removed=%d pairs=%d damaged=%d disconnected=%d extra_hops=%d worst_increase=%d diameter_intact=%d diameter_punctured=%d by1=%d by2=%d by3plus=%d\n", \
    tag, ndead(), pairs, damaged, disc, extra, worst, BFS_DIA, dia_p, \
    (1 in dhist ? dhist[1] : 0), (2 in dhist ? dhist[2] : 0), histtail(dhist)
  # THE DROP COUNT IS PREDICTED BEFORE IT IS READ. A departure kills exactly the routes that crossed
  # it, so the share of pairs lost is the share of a route that is an INTERMEDIATE point: a walk of
  # h hops passes through h-1 of them, spread over the n-1 points that are not its own endpoints.
  # The prediction is therefore pairs x (mean_hops - 1) / (n - 1), computed from the INTACT walk and
  # compared against the measured drop. A residual larger than a few would mean the mechanism is
  # something other than "the routes that crossed it."
  meanh = 0; for (i = 1; i < n; i++) meanh += DIST0[i]
  meanh = meanh / (n - 1)
  predicted = pairs * (meanh - 1) / (n - 1)
  printf "predict shape=%s mean_hops_intact=%.4f predicted_drops=%.1f measured_drops=%d residual=%.1f residual_share=%.6f\n", \
    tag, meanh, predicted, t_drop, t_drop - predicted, (t_drop - predicted)/pairs
  printf "stale shape=%s rule=table bytes=%d arrived=%d dropped=%d optimal=%d arrival_share=%.6f extra_hops=%d\n", \
    tag, int((n-1)*bits_for(deg)/8)+1, t_arr, t_drop, t_opt, t_arr/pairs, t_extra
  printf "stale shape=%s rule=distance bytes=%d arrived=%d stalled=%d cycled=%d optimal=%d arrival_share=%.6f extra_hops=%d worst_stretch=%d\n", \
    tag, int((n-1)*bits_for(BFS_DIA+1)/8)+1, d_arr, d_stall, d_cyc, d_opt, d_arr/pairs, d_extra, d_worst
  printf "stale shape=%s rule=distance_nr bytes=%d packet_state=visited_set arrived=%d stalled=%d cycled=0 optimal=%d arrival_share=%.6f extra_hops=%d worst_walk=%d packet_bits=%d\n", \
    tag, int((n-1)*bits_for(BFS_DIA+1)/8)+1, n_arr, n_stall, n_opt, n_arr/pairs, n_extra, n_worst, n_worst*bits_for(n)
  for (u = 0; u < n; u++) if (!(u in DEAD) && (u in ENT_BAD)) {
    ent_nodes++; if (ENT_BAD[u] > ent_max) ent_max = ENT_BAD[u]
  }
  printf "entry shape=%s entries_per_node=%d nodes=%d changed_entries=%d changed_share=%.6f nodes_with_a_change=%d clean_nodes=%d worst_node_changes=%d mean_changes=%.4f cause_dead_hop=%d cause_stale_path=%d ring1=%d ring2=%d ring3=%d ring4plus=%d\n", \
    tag, n - ndead() - 1, n - ndead(), ent_bad, ent_bad/((n-ndead())*(n-ndead()-1)), ent_nodes, \
    (n - ndead()) - ent_nodes, ent_max, ent_bad/(n - ndead()), ent_dead, ent_path, \
    (1 in ering ? ering[1] : 0), (2 in ering ? ering[2] : 0), (3 in ering ? ering[3] : 0), ringtail(ering)
  # the blast radius counted in NODES: how many survivors the stale distance state routes at the
  # punctured optimum to every destination, and where the rest sit relative to the hole
  clean = 0; missnodes = 0; tclean = 0; tmiss = 0; delete ring
  for (u = 0; u < n; u++) if (!(u in DEAD)) { if (u in TAB_MISS) tmiss++; else tclean++ }
  deadv = -1; for (i = 0; i < n; i++) if (i in DEAD) { deadv = i; break }
  dsum = 0
  for (u = 0; u < n; u++) {
    if (u in DEAD) continue
    if (!(u in SRC_MISS)) { clean++; continue }
    missnodes++
    d0 = DIST0[diff_of(kind, deadv, u, n, a, b, c)]
    ring[d0]++
    dsum += d0
  }
  printf "patch shape=%s survivors=%d rule=table clean_nodes=%d patch_nodes=%d patch_share=%.6f\n", \
    tag, n - ndead(), tclean, tmiss, tmiss/(n - ndead())
  printf "patch shape=%s survivors=%d rule=distance clean_nodes=%d patch_nodes=%d patch_share=%.6f mean_hole_distance=%.4f ring1=%d ring2=%d ring3=%d ring4plus=%d\n", \
    tag, n - ndead(), clean, missnodes, missnodes/(n - ndead()), (missnodes ? dsum/missnodes : 0), \
    (1 in ring ? ring[1] : 0), (2 in ring ? ring[2] : 0), (3 in ring ? ring[3] : 0), ringtail(ring)
  P_DAMAGED = damaged; P_DISC = disc; P_TDROP = t_drop; P_DARR = d_arr; P_DOPT = d_opt
  P_PATCH = missnodes; P_PAIRS = pairs; P_DEXTRA = d_extra; P_TARR = t_arr
  P_ENT = ent_bad; P_ENTNODES = ent_nodes; P_ENTMAX = ent_max
  P_ENTDEAD = ent_dead; P_ENTPATH = ent_path; P_NWORST = n_worst
  P_PRED = predicted; P_BY1 = (1 in dhist ? dhist[1] : 0); P_BY2 = (2 in dhist ? dhist[2] : 0)
  P_NARR = n_arr; P_NSTALL = n_stall; P_NOPT = n_opt; P_TMISS = tmiss
}
function ndead(   i, c) { c = 0; for (i in DEAD) c++; return c }
function ringtail(ring,   i, c) { c = 0; for (i in ring) if (i+0 >= 4) c += ring[i]; return c }
function histtail(h,   i, c) { c = 0; for (i in h) if (i+0 >= 3) c += h[i]; return c }

# ---- the curve: how the answer bends as departures accumulate ------------------------------------
# Sources are every survivor; DESTINATIONS ARE SAMPLED at 60 points, i*211 mod 720 with the dead
# skipped, because the pass costs one breadth-first search per destination and the curve runs 56
# configurations. 211 is prime and does not divide 720, so the sample is spread rather than local.
# The sample is named here rather than left implicit: a curve read from a local sample would say
# more about the sample than about the shape.
function curve_row(tag, kind, pattern, k, n, a, b, c, deg, nb,   i, t, u, rd, dp, live, reach,
                   D2T, PD, pairs, arr, stall, cyc, opt, hops, optsum, optn, first) {
  live = n - ndead()
  first = -1; for (i = 0; i < n; i++) if (!(i in DEAD)) { first = i; break }
  bfs_punct(first, n, nb, deg, PD)
  reach = 0; for (i in PD) reach++
  pairs = 0; arr = 0; stall = 0; cyc = 0; opt = 0; hops = 0; optsum = 0; optn = 0
  for (i = 0; i < 60; i++) {
    t = (i * 211) % n
    if (t in DEAD) continue
    bfs_punct(t, n, nb, deg, PD)
    for (u = 0; u < n; u++) if (!(u in DEAD)) D2T[u] = DIST0[diff_of(kind, u, t, n, a, b, c)]
    for (u = 0; u < n; u++) {
      if (u in DEAD || u == t) continue
      pairs++
      dp = (u in PD ? PD[u] : -1)
      # the optimum is accumulated for EVERY pair the punctured graph still connects, rather than
      # only for the pairs that arrived. Accumulating on arrival alone drops exactly the long pairs
      # -- they are the ones that cycle -- so the mean would fall as k rose and read like a network
      # getting shorter while it was getting worse.
      if (dp >= 0) { optsum += dp; optn++ }
      rd = route_dist_t(u, t, deg, nb, D2T)
      if (rd == -1) { stall++; continue }
      if (rd == -2) { cyc++; continue }
      arr++; hops += rd
      if (dp >= 0 && rd == dp) opt++
    }
  }
  printf "curve shape=%s pattern=%s removed=%d live=%d connected=%s pairs=%d arrived=%d stalled=%d cycled=%d optimal=%d arrival_share=%.6f mean_hops=%.4f mean_optimum=%.4f\n", \
    tag, pattern, k, live, (reach == live ? "yes" : "no"), pairs, arr, stall, cyc, opt, \
    (pairs ? arr/pairs : 0), (arr ? hops/arr : 0), (optn ? optsum/optn : 0)
  if (reach != live) C_SPLIT++
  C_ROWS++
}

# ---- the hole leg: prove the choice of removed point immaterial rather than assuming it -----------
# G minus v is isomorphic to G minus w for any two points of a vertex-transitive graph, so every
# single-departure reading below is independent of WHICH point left. That is an argument; this leg
# is the check. It probes three removed points over the same 60 sampled destinations and requires
# the four readings to agree exactly. A disagreement would mean the graph is not what it claims.
function hole_probe(kind, v, n, a, b, c, deg, nb,   i, t, u, rd, rt, dp, D2T, B2T, PD,
                    pairs, damaged, tdrop, darr, dopt) {
  delete DEAD; DEAD[v] = 1
  pairs = 0; damaged = 0; tdrop = 0; darr = 0; dopt = 0
  # THE SAMPLE IS TAKEN RELATIVE TO THE REMOVED POINT, and the first draft of this leg took it in
  # absolute numbering and read `agree=no` on a graph that is genuinely vertex-transitive. The
  # isomorphism carrying G minus v onto G minus w is translation by w minus v, so it carries
  # destination t to t plus that shift; a sample fixed in absolute numbering therefore names a
  # DIFFERENT relative set at each probe, and the three probes measured three different things
  # while looking like one. Translating the sample with the hole is what makes the comparison a
  # comparison. This leg runs on the circulant, whose group is Z_720, so the translation is one sum.
  for (i = 0; i < 60; i++) {
    t = (v + i * 211) % n
    if (t in DEAD) continue
    bfs_punct(t, n, nb, deg, PD)
    for (u = 0; u < n; u++) if (!(u in DEAD)) {
      D2T[u] = DIST0[diff_of(kind, u, t, n, a, b, c)]
      B2T[u] = BRANCH[diff_of(kind, u, t, n, a, b, c)]
    }
    for (u = 0; u < n; u++) {
      if (u in DEAD || u == t) continue
      pairs++
      dp = (u in PD ? PD[u] : -1)
      if (dp > D2T[u]) damaged++
      rt = route_table_t(u, t, deg, nb, B2T); if (rt < 0) tdrop++
      rd = route_dist_t(u, t, deg, nb, D2T)
      if (rd >= 0) { darr++; if (rd == dp) dopt++ }
    }
  }
  return pairs "/" damaged "/" tdrop "/" darr "/" dopt
}

BEGIN {
  N = 720
  GAP_MAX = 1000000
  # invariant: a walk longer than four diameters has failed by any reading, so the cap ends a
  # cycling heuristic rather than letting it run to 4n hops
  WALK_CAP = 64
  build_perms()

  # invariant: an unknown leg word refuses before any graph is built, rather than reading as a
  # narrower pass that still says ok.
  if (LEGS != "all" && LEGS != "fast" && LEGS != "hole" && LEGS != "curve") {
    printf "verdict=instrument_fault legs=%s faults=1 detail=unknown_leg_word\n", LEGS
    exit 1
  }
  do_pass  = (LEGS == "all" || LEGS == "fast")
  do_hole  = (LEGS == "all" || LEGS == "hole")
  do_curve = (LEGS == "all" || LEGS == "curve")
  nshapes = (LEGS == "fast" ? 1 : 4)
  SH_TAG[0] = "circ";    SH_KIND[0] = "circ";  SH_A[0] = 1;  SH_B[0] = 8; SH_C[0] = 75; SH_DEG[0] = 6
  SH_TAG[1] = "torus12"; SH_KIND[1] = "torus"; SH_A[1] = 12; SH_B[1] = 5; SH_C[1] = 12; SH_DEG[1] = 6
  SH_TAG[2] = "torus8";  SH_KIND[2] = "torus"; SH_A[2] = 8;  SH_B[2] = 9; SH_C[2] = 10; SH_DEG[2] = 6
  SH_TAG[3] = "star";    SH_KIND[3] = "star";  SH_A[3] = 0;  SH_B[3] = 0; SH_C[3] = 0;  SH_DEG[3] = 5

  C_ROWS = 0; C_SPLIT = 0; bad = 0
  for (s = 0; do_pass && s < nshapes; s++) {
    tag = SH_TAG[s]; kind = SH_KIND[s]; a = SH_A[s]; b = SH_B[s]; c = SH_C[s]; deg = SH_DEG[s]
    delete nb
    if (kind == "circ") circ(N, a, b, c, nb)
    else if (kind == "torus") torus(a, b, c, nb)
    else star(nb)
    seen = bfs0(N, nb, deg)
    # invariant: the intact graph is connected, or every reading below is measuring a different
    # object than the one the sibling paper priced
    if (seen != N) { printf "shape shape=%s VERDICT=disconnected seen=%d\n", tag, seen; bad++; continue }
    printf "shape shape=%s degree=%d diameter=%d table_bytes=%d distance_bytes=%d\n", \
      tag, deg, BFS_DIA, int((N-1)*bits_for(deg)/8)+1, int((N-1)*bits_for(BFS_DIA+1)/8)+1

    delete DEAD; DEAD[0] = 1
    full_pass(tag, kind, N, a, b, c, deg, nb)
    SV_PATCH[tag] = P_PATCH; SV_TDROP[tag] = P_TDROP; SV_DARR[tag] = P_DARR
    SV_DOPT[tag] = P_DOPT; SV_PAIRS[tag] = P_PAIRS; SV_DAM[tag] = P_DAMAGED; SV_DISC[tag] = P_DISC
    SV_TARR[tag] = P_TARR; SV_DEXTRA[tag] = P_DEXTRA
    SV_ENT[tag] = P_ENT; SV_ENTNODES[tag] = P_ENTNODES; SV_ENTMAX[tag] = P_ENTMAX
    SV_NARR[tag] = P_NARR; SV_NSTALL[tag] = P_NSTALL; SV_TMISS[tag] = P_TMISS
    SV_ENTDEAD[tag] = P_ENTDEAD; SV_ENTPATH[tag] = P_ENTPATH; SV_NWORST[tag] = P_NWORST
  }

  if (do_hole) {
    # the hole leg, run where a difference is one subtraction and the check is therefore cheap
    delete nb; circ(N, 1, 8, 75, nb); bfs0(N, nb, 6)
    # the three probed points are held in variables and PRINTED from them, so a copy that probes
    # one point three times says so in its own line. A literal in the printf would let a vacuous
    # check keep claiming three points while agreeing with itself.
    hv1 = 0; hv2 = 137; hv3 = 421
    h0 = hole_probe("circ", hv1, N, 1, 8, 75, 6, nb)
    h1 = hole_probe("circ", hv2, N, 1, 8, 75, 6, nb)
    h2 = hole_probe("circ", hv3, N, 1, 8, 75, 6, nb)
    agree = ((h0 == h1) && (h1 == h2)) ? "yes" : "no"
    printf "hole shape=circ probes=3 removed=%d,%d,%d signature=%s agree=%s\n", hv1, hv2, hv3, h0, agree
    if (agree != "yes") { printf "hole VERDICT=transitivity_broken a=%s b=%s c=%s\n", h0, h1, h2; bad++ }
    HOLE_AGREE = agree
  }

  if (do_curve) {
    split("1 2 4 8 16 32 64", KS, " ")
    for (s = 0; s < 4; s++) {
      tag = SH_TAG[s]; kind = SH_KIND[s]; a = SH_A[s]; b = SH_B[s]; c = SH_C[s]; deg = SH_DEG[s]
      delete nb
      if (kind == "circ") circ(N, a, b, c, nb)
      else if (kind == "torus") torus(a, b, c, nb)
      else star(nb)
      bfs0(N, nb, deg)
      for (ki = 1; ki <= 7; ki++) {
        k = KS[ki] + 0
        dead_spread(k, N); curve_row(tag, kind, "spread", k, N, a, b, c, deg, nb)
        dead_ball(k, N, nb, deg); curve_row(tag, kind, "cluster", k, N, a, b, c, deg, nb)
      }
    }
  }

  # ---- claims: one key=value line per named finding, each bindable by the witness ----------------
  for (s = 0; do_pass && s < nshapes; s++) {
    tag = SH_TAG[s]
    printf "claims shape=%s damaged_pairs=%d disconnected=%d table_drops=%d table_arrivals=%d distance_arrivals=%d distance_optimal=%d distance_extra=%d nr_arrivals=%d nr_stalled=%d nr_worst_walk=%d changed_entries=%d entry_nodes=%d worst_node_changes=%d cause_dead_hop=%d cause_stale_path=%d table_patch_nodes=%d patch_nodes=%d pairs=%d\n", \
      tag, SV_DAM[tag], SV_DISC[tag], SV_TDROP[tag], SV_TARR[tag], SV_DARR[tag], SV_DOPT[tag], SV_DEXTRA[tag], \
      SV_NARR[tag], SV_NSTALL[tag], SV_NWORST[tag], SV_ENT[tag], SV_ENTNODES[tag], SV_ENTMAX[tag], \
      SV_ENTDEAD[tag], SV_ENTPATH[tag], SV_TMISS[tag], SV_PATCH[tag], SV_PAIRS[tag]
  }
  printf "claims hole_agree=%s curve_rows=%d curve_splits=%d legs=%s bad=%d\n", \
    (do_hole ? HOLE_AGREE : "skipped"), C_ROWS, C_SPLIT, LEGS, bad
  printf "verdict=%s legs=%s faults=%d\n", (bad == 0 ? "ok" : "instrument_fault"), LEGS, bad
  exit (bad == 0 ? 0 : 1)
}
' /dev/null
