#!/bin/sh
# tools/fixtures/t/topology_attained_scan.sh -- the floor a hand can actually reach, measured by
# building the graphs and walking them rather than by solving an inequality.
#
# WHY. Its sibling `topology_floor_scan` lives inside `topology_graph_census.sh` and reports the
# Moore floor -- the smallest diameter ANY graph of a given order and degree could hold. That is a
# lower bound over all graphs, and almost no graph attains it: the known attainers are the cycles,
# the complete graphs, Petersen, Hoffman-Singleton, and one open case at degree 57. So a ratio
# against the Moore floor bounds the room from above and promises nothing at the bottom of it. This
# script asks the question a designer actually holds -- WHAT DIAMETER CAN I BUILD -- and answers it
# by exhibiting graphs on exactly 720 points and walking every one of their ordered pairs.
#
# WHAT IT PRINTS, in four legs:
#
#   l1ball3     -- the count of integer points within L1 distance k of the origin in Z^3, computed
#                  in closed form AND by enumeration, for k=0..10. The closed form is the whole
#                  basis of the abelian floor below, so it is checked against a count rather than
#                  trusted. A draft of this script had `(2.0/3.0)*k*(k+1)*(2*k+1)`, which divides
#                  before it multiplies and reads 574 at k=7 where the truth is 575 -- right at ten
#                  radii of eleven, and wrong at the one nobody would have checked alone.
#
#   abelian     -- the ABELIAN floor. In a Cayley graph over an abelian group, every point within k
#                  hops is a word of length at most k in the generators, and the generators commute,
#                  so the point is named by an exponent vector. The ball is therefore no larger than
#                  the number of exponent vectors of L1 weight at most k. For degree d the generating
#                  multiset splits into s involutions and t inverse-pairs with s + 2t = d, and this
#                  leg reports every split so the widest one is visible rather than assumed. A degree
#                  the ball cannot reach is a diameter no abelian shape of that degree can hold.
#
#   shape       -- six graphs on 720 points, each built here and walked by breadth-first search from
#                  EVERY vertex. Vertex-transitivity would let one walk stand for all 720, and every
#                  graph here is vertex-transitive, yet the shortcut is a claim about the graph and
#                  this leg is what the claim would be checked against -- so it is not taken. Each
#                  reports its diameter and its mean hop count over all 517,680 ordered distinct
#                  pairs, because a design that cares about the typical hop and one that cares about
#                  the worst hop are not the same design and the two numbers move differently.
#
#   sweep       -- every circulant C_720(1,b,c) with 2 <= b < c <= 359: 63,903 graphs. One generator
#                  is fixed at 1 because C_n(S) is isomorphic to C_n(uS) for any unit u, so a
#                  connection set meeting the units normalizes to this form -- and having 1 present
#                  makes every graph in the sweep connected, so no connectivity leg is needed. It
#                  reports the best diameter, how many triples attain it, the median, and the share
#                  that beat the seated torus. The share is the design number: an optimum nobody can
#                  find is worth less than a floor three random draws in four already clear.
#
# WHAT IS MEASURED AND WHAT IS PROPOSED. Every diameter and mean here is MEASURED, on a graph this
# script builds. The abelian floor is DERIVED, and its derivation is checked against enumeration.
# Nothing here implements anything: `comlink/topology.rye` publishes the seated three-ring reading
# and no other shape on this list. Two Rooms -- these are numbers a design argument may cite, not a
# behavior the tree performs.
#
# THE ONE COVERAGE GAP, NAMED. The sweep covers circulants with a unit generator. A connection set
# of three non-units can still generate Z_720 -- {16, 9, 5} does -- and no such triple is walked
# here. That family is not claimed, and the sweep's numbers are ACHIEVABILITY: a graph exhibited at
# diameter 9 proves 9 is reachable whatever else is. Only the "no circulant reaches 8" reading is
# bounded by the gap, and it is worded as the sweep's own reach rather than as a fact about
# circulants.
#
# COST. Measured `20260906.152821` on this pier: the sweep walks 63,903 graphs and the shape leg
# walks 3,106,080 ordered pairs. Around two minutes end to end, which is why its witness is
# `tier cadence` -- the answer moves only when this script moves.
#
# TWO KNOBS, AND WHY THEY EXIST. `SCAN_LEGS` (floors|all, default all) and `SWEEP_BMAX` (default
# 359) let a caller run a subset. They exist for the control, which runs eleven copies of this
# script and would otherwise cost fourteen minutes to prove seven plants. Every reduced run PRINTS
# `legs=` and `sweep_bmax=` on its own line, so a reduced reading can never be mistaken for a full
# one; the witness runs the default and binds the full numbers.
#
#   sh tools/fixtures/t/topology_attained_scan.sh
#   SCAN_LEGS=floors sh tools/fixtures/t/topology_attained_scan.sh

set -eu

SCAN_LEGS="${SCAN_LEGS:-all}"
SWEEP_BMAX="${SWEEP_BMAX:-359}"

awk -v LEGS="$SCAN_LEGS" -v BMAX="$SWEEP_BMAX" '
# ---- the ball of radius k in Z^3 under L1, closed and enumerated -------------------------------
function l1ball3(k) { return 1 + (2*k*(k+1)*(2*k+1))/3 + 2*k }   # multiply first: k(k+1)(2k+1) has a factor 6
function l1ball2(k) { return 2*k*k + 2*k + 1 }
function l1ball1(k) { return 2*k + 1 }
function l1ball(t, k) { if (t==3) return l1ball3(k); if (t==2) return l1ball2(k); if (t==1) return l1ball1(k); return 1 }
function enum3(k,   x, y, z, ax, ay, az, n) {
  n = 0
  for (x=-k; x<=k; x++) for (y=-k; y<=k; y++) for (z=-k; z<=k; z++) {
    ax = x<0?-x:x; ay = y<0?-y:y; az = z<0?-z:z
    if (ax+ay+az <= k) n++
  }
  return n
}
# The widest ball a degree-d abelian Cayley graph can hold at radius k, over every split of the
# generating multiset into s involutions and t inverse-pairs.
function abelian_ball(d, k,   t, s, j, r, c, i, tot, best) {
  best = 0
  for (t = 0; 2*t <= d; t++) {
    s = d - 2*t; tot = 0
    for (j = 0; j <= s && j <= k; j++) {
      r = k - j
      c = 1; for (i = 0; i < j; i++) c = c*(s-i)/(i+1)
      tot += c * l1ball(t, r)
    }
    if (tot > best) { best = tot; BEST_S = s; BEST_T = t }
  }
  return best
}
function abelian_floor(n, d, kmax,   k) {
  for (k = 1; k <= kmax; k++) if (abelian_ball(d, k) >= n) return k
  return -1
}
function moore_cap(d, k,   m, p, i) {
  if (d == 2) return 2*k + 1
  m = 1; p = 1
  for (i = 0; i < k; i++) { m += d*p; p *= (d-1) }
  return m
}
function moore_floor(n, d, kmax,   k) {
  for (k = 1; k <= kmax; k++) if (moore_cap(d, k) >= n) return k
  return -1
}

# ---- all-pairs breadth-first walk, no vertex-transitivity assumed ------------------------------
function walk(n, nb, deg, tag,   s,i,v,w,k,d,cur,nxt,nc,nn,lev,seen,ecc,dia,sum,cnt) {
  dia = 0; sum = 0; cnt = 0
  for (s = 0; s < n; s++) {
    delete d; d[s] = 0; seen = 1; delete cur; cur[0] = s; nc = 1; lev = 0; ecc = 0
    while (nc > 0) {
      lev++; nn = 0; delete nxt
      for (i = 0; i < nc; i++) {
        v = cur[i]
        for (k = 0; k < deg; k++) {
          w = nb[v*8 + k]
          if (!(w in d)) { d[w] = lev; nxt[nn++] = w; seen++; sum += lev; cnt++ }
        }
      }
      if (nn == 0) break
      ecc = lev; delete cur; for (i = 0; i < nn; i++) cur[i] = nxt[i]; nc = nn
    }
    if (seen != n) { printf "shape %s not_connected reached=%d of=%d\n", tag, seen, n; return -1 }
    if (ecc > dia) dia = ecc
  }
  DIA = dia; MEAN = sum/cnt; PAIRS = cnt
  return dia
}
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
function swap_pos(p, a, b,   arr, t, i, o) {
  split(p, arr, ""); t = arr[a]; arr[a] = arr[b]; arr[b] = t
  o = ""; for (i = 1; i <= 6; i++) o = o arr[i]; return o
}
function rev_prefix(p, m,   arr, i, o) {
  split(p, arr, ""); o = ""
  for (i = m; i >= 1; i--) o = o arr[i]
  for (i = m+1; i <= 6; i++) o = o arr[i]; return o
}
# One breadth-first walk from vertex 0, capped. Used only by the sweep, where a circulant IS
# vertex-transitive and the shape leg above is what proves that reading against an all-pairs walk.
function ecc0(n, g1, g2, g3, cap,   d,i,v,w,cur,nxt,nc,nn,lev,seen) {
  delete d; d[0] = 0; seen = 1; delete cur; cur[0] = 0; nc = 1; lev = 0
  while (nc > 0 && lev < cap) {
    lev++; nn = 0; delete nxt
    for (i = 0; i < nc; i++) {
      v = cur[i]
      w=(v+g1)%n;   if(!(w in d)){d[w]=lev;nxt[nn++]=w;seen++}
      w=(v-g1+n)%n; if(!(w in d)){d[w]=lev;nxt[nn++]=w;seen++}
      w=(v+g2)%n;   if(!(w in d)){d[w]=lev;nxt[nn++]=w;seen++}
      w=(v-g2+n)%n; if(!(w in d)){d[w]=lev;nxt[nn++]=w;seen++}
      w=(v+g3)%n;   if(!(w in d)){d[w]=lev;nxt[nn++]=w;seen++}
      w=(v-g3+n)%n; if(!(w in d)){d[w]=lev;nxt[nn++]=w;seen++}
    }
    if (seen == n) return lev
    delete cur; for (i = 0; i < nn; i++) cur[i] = nxt[i]; nc = nn
  }
  return -1
}

BEGIN {
  N = 720; SEATED = 14
  bad = 0
  print "topology-attained: the floor a hand can reach, on 720 points."
  if (LEGS != "all" && LEGS != "floors") { print "refused: SCAN_LEGS must be all or floors"; exit 1 }
  printf "legs=%s sweep_bmax=%d\n", LEGS, BMAX
  print ""

  # ---- leg one: the closed form, checked against a count ---------------------------------------
  for (k = 0; k <= 10; k++) {
    c = l1ball3(k); e = enum3(k)
    printf "l1ball3 k=%d closed=%d enumerated=%d %s\n", k, c, e, (c==e ? "agree" : "DISAGREE")
    if (c != e) { bad++; disagreements++ }
  }
  # A positive count rather than an absence: an absent line and a passing check read the same.
  printf "l1ball3_disagreements=%d radii=11\n", disagreements+0
  print ""

  # ---- leg two: the abelian floor, every split shown -------------------------------------------
  for (d = 5; d <= 6; d++) {
    af = abelian_floor(N, d, 60); mf = moore_floor(N, d, 60)
    printf "floor moore n=%d degree=%d floor=%d cap_at_floor=%d cap_below=%d\n", N, d, mf, moore_cap(d,mf), moore_cap(d,mf-1)
    b_at = abelian_ball(d, af); s_at = BEST_S; t_at = BEST_T
    b_bel = abelian_ball(d, af-1)
    printf "floor abelian n=%d degree=%d floor=%d ball_at_floor=%d ball_below=%d widest_split=involutions:%d,pairs:%d\n", \
      N, d, af, b_at, b_bel, s_at, t_at
    if (b_bel >= N || b_at < N) bad++
  }
  # every split at the degree-6 floor and one below it, so the widest is visible rather than asserted
  for (k = 7; k <= 8; k++) for (t = 0; 2*t <= 6; t++) {
    s = 6 - 2*t; tot = 0
    for (j = 0; j <= s && j <= k; j++) {
      r = k - j; c = 1; for (i = 0; i < j; i++) c = c*(s-i)/(i+1); tot += c*l1ball(t, r)
    }
    printf "abelian_split degree=6 k=%d involutions=%d pairs=%d ball=%d\n", k, s, t, tot
  }
  print ""

  if (LEGS == "floors") { printf "verdict=%s\n", (bad == 0 ? "ok" : "instrument_fault"); exit (bad == 0 ? 0 : 1) }

  # ---- leg three: six shapes, built and walked -------------------------------------------------
  af6 = abelian_floor(N, 6, 60); mf6 = moore_floor(N, 6, 60)
  af5 = abelian_floor(N, 5, 60); mf5 = moore_floor(N, 5, 60)

  delete NB; torus(12, 5, 12, NB)
  if (walk(N, NB, 6, "torus_12x5x12") < 0) bad++; else \
    printf "shape torus_12x5x12 degree=6 diameter=%d mean_hops=%.4f pairs=%d over_moore=%.2f over_abelian=%.2f\n", DIA, MEAN, PAIRS, DIA/mf6, DIA/af6

  delete NB; torus(8, 9, 10, NB)
  if (walk(N, NB, 6, "torus_8x9x10") < 0) bad++; else \
    printf "shape torus_8x9x10 degree=6 diameter=%d mean_hops=%.4f pairs=%d over_moore=%.2f over_abelian=%.2f\n", DIA, MEAN, PAIRS, DIA/mf6, DIA/af6

  delete NB; circ(N, 1, 8, 75, NB)
  if (walk(N, NB, 6, "circulant_1_8_75") < 0) bad++; else { WITNESS_DIA = DIA; \
    printf "shape circulant_1_8_75 degree=6 diameter=%d mean_hops=%.4f pairs=%d over_moore=%.2f over_abelian=%.2f\n", DIA, MEAN, PAIRS, DIA/mf6, DIA/af6 }

  # the permutations of six symbols: 720 of them, which is why S_6 sits at exactly our point count
  m = 0
  for (a=1;a<=6;a++) for (b=1;b<=6;b++) for (c=1;c<=6;c++) for (e=1;e<=6;e++) for (f=1;f<=6;f++) for (g=1;g<=6;g++) {
    if (a==b||a==c||a==e||a==f||a==g||b==c||b==e||b==f||b==g||c==e||c==f||c==g||e==f||e==g||f==g) continue
    p = a b c e f g; ID[p] = m; PERM[m] = p; m++
  }
  printf "symmetric_group order=%d expected=%d %s\n", m, N, (m==N ? "agree" : "DISAGREE")
  if (m != N) bad++

  delete NB; for (v=0; v<m; v++) for (i=2; i<=6; i++) NB[v*8 + (i-2)] = ID[swap_pos(PERM[v], 1, i)]
  if (walk(m, NB, 5, "star_S6") < 0) bad++; else \
    printf "shape star_S6 degree=5 diameter=%d mean_hops=%.4f pairs=%d over_moore=%.2f over_abelian=%.2f\n", DIA, MEAN, PAIRS, DIA/mf5, DIA/af5

  delete NB; for (v=0; v<m; v++) for (i=2; i<=6; i++) NB[v*8 + (i-2)] = ID[rev_prefix(PERM[v], i)]
  if (walk(m, NB, 5, "pancake_P6") < 0) bad++; else \
    printf "shape pancake_P6 degree=5 diameter=%d mean_hops=%.4f pairs=%d over_moore=%.2f over_abelian=%.2f\n", DIA, MEAN, PAIRS, DIA/mf5, DIA/af5

  delete NB; for (v=0; v<m; v++) for (i=1; i<=5; i++) NB[v*8 + (i-1)] = ID[swap_pos(PERM[v], i, i+1)]
  if (walk(m, NB, 5, "bubble_B6") < 0) bad++; else \
    printf "shape bubble_B6 degree=5 diameter=%d mean_hops=%.4f pairs=%d over_moore=%.2f over_abelian=%.2f\n", DIA, MEAN, PAIRS, DIA/mf5, DIA/af5
  print ""

  # ---- leg four: the sweep ---------------------------------------------------------------------
  tot = 0; best = 999; nbest = 0; bb = 0; cc = 0; beat = 0; tie = 0
  for (b = 2; b <= BMAX; b++) for (c = b+1; c <= BMAX; c++) {
    e = ecc0(N, 1, b, c, N)
    if (e < 0) { printf "sweep_open b=%d c=%d did_not_close_within=%d\n", b, c, N; bad++; continue }
    H[e]++; tot++
    if (e < best) { best = e; nbest = 1; bb = b; cc = c } else if (e == best) nbest++
    if (e < SEATED) beat++
    if (e == SEATED) tie++
  }
  cum = 0; med = -1; worst = 0
  for (k = 1; k <= N; k++) if (k in H) {
    cum += H[k]
    if (med < 0 && cum >= tot/2) med = k
    worst = k
  }
  printf "sweep family=circulant_unit_generator swept=%d best=%d attainers=%d median=%d worst=%d\n", tot, best, nbest, med, worst
  printf "sweep_first_attainer C%d(1,%d,%d)\n", N, bb, cc
  printf "sweep_against_seated seated_diameter=%d beat=%d tie=%d beat_share=%.4f\n", SEATED, beat, tie, beat/tot
  printf "sweep_reaches_abelian_floor floor=%d reached=%s\n", af6, (best <= af6 ? "yes" : "no")
  # The sweep walks once from vertex 0 and calls that the diameter; the shape leg walks from all 720.
  # Both read C720(1,8,75), so the two methods are held against each other rather than assumed equal.
  sh = ecc0(N, 1, 8, 75, N)
  printf "transitivity_crosscheck graph=C720(1,8,75) one_walk=%d all_pairs=%d %s\n", sh, WITNESS_DIA, (sh == WITNESS_DIA ? "agree" : "DISAGREE")
  if (sh != WITNESS_DIA) bad++
  print ""

  printf "verdict=%s\n", (bad == 0 ? "ok" : "instrument_fault")
  exit (bad == 0 ? 0 : 1)
}
'
