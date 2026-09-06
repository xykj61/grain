#!/bin/sh
# tools/fixtures/t/topology_graph_census.sh -- whether the sky's hop count is a hop count:
# the graph the metric's own unit distance defines, walked, and a toroidal reading of the
# same three coordinates measured beside it.
#
# WHY. `comlink/topology.rye` publishes `route_hops` as "the hop count from a to b". A hop
# count is a claim about a GRAPH: it says there is a walk of that many edges. Nothing in the
# tree had ever built that graph and walked it. This script builds it from the metric itself
# -- the edges are exactly the pairs the metric puts at distance one, so no edge set is
# assumed -- runs a breadth-first walk from every point, and compares what the walk finds to
# what the metric claims. Its sibling `topology_metric_census.sh` priced what the metric
# DISTINGUISHES; this one prices whether the metric is REALIZABLE.
#
# WHAT IT PRINTS, per sky, in three legs:
#
#   agreement   -- the five pairs the module asserts, plus the elder census`s published
#                  compass readings (diameter 5, entropy 1.0461, diameter share 0.7703).
#                  A disagreement refuses before any new number is reported.
#   sponsor     -- `route_hops`, the ADDRESS-space metric, read as a graph: edges, degree
#                  spread, isolated points, components, and the three ways a metric can meet
#                  its own graph -- agree, differ, or unreachable.
#   point       -- `point_hops`, the NUMBER-space metric that landed `20260906.092125`, read
#                  the same way. THE MODULE PUBLISHES BOTH, and this leg exists because for
#                  eight hours this script measured one of two shipping readings while a
#                  paper cited its numbers as the hierarchy`s. Its own five asserted pairs
#                  are bound here, so the module and this script cannot drift apart.
#   torus       -- the SAME three coordinates read as three rings rather than three rungs.
#                  Distance is the Lee distance, min(|d|, N-|d|) summed over the rings. The
#                  same graph check runs on it, and it must agree on every pair or this
#                  script is wrong about one of the two metrics.
#
# WHAT IS MEASURED AND WHAT IS PROPOSED. The sponsor and point legs both measure code that
# ships; they are two readings of one hierarchy and neither supersedes the other. The torus
# leg measures a metric NOTHING IN THE TREE IMPLEMENTS -- it is arithmetic over the module`s
# own coordinates, reported so a design argument can cite a number rather than an adjective.
# Two Rooms: the sponsor and point readings are checkable, the torus readings are proposed.
#
# WHICH LEG A COMPARISON SHOULD CITE. The point leg, whenever the question is about hierarchy
# as a shape. `route_hops` answers a question about outfits and leaves 132 points with nothing
# one hop away (REDS %454); `point_hops` walks the same chain where a star of index zero and
# its galaxy are one point, and answers connected. A design argument that cites the sponsor
# leg against the torus is comparing a torus to a graph nobody routes on.
#
# WHAT THE CUT LEG NAMES. A count says how brittle a shape is; the tier says where. Both
# hierarchy legs read 59 cut points on the compass sky and both decompose the same way --
# 11 galaxies and 48 stars and zero planets, against 12 and 48 and 660 standing. Every
# interior point is an articulation vertex and no leaf is; the twelfth galaxy is missing only
# because the walk starts there. The torus reads zero of 720.
#
# EFFICIENCY, AND WHY THE COMPARISON IS NORMALIZED. A metric with more distinct values carries
# more entropy for free, so raw bits would flatter whichever metric has the wider range. Every
# entropy here is reported beside its own ceiling, log2 of its distinct-value count, and as the
# ratio of the two. The ratio is the honest comparison; the bits alone are not.
#
# THE INSTRUMENT CAN RED, proven three ways on metal in a pen. A hop model answering 3 where
# the module asserts 5 failed the agreement leg four ways at once -- the selftest pair and all
# three elder readings, faults=1900. A torus leg that dropped one of the three rings called
# 2,880 distinct pairs zero apart and disagreed with its own graph on the same 2,880. A ring
# gap counting each step twice left no pair at unit distance, so the graph held zero edges and
# 517,680 ordered pairs went unreachable.
#
# THE POINT LEG CAN RED, proven three ways in a pen `20260906.105235`, each from a different
# angle, with an unbroken copy proving the pen innocent at exit 0. A search starting at one
# rather than zero stopped a point being zero hops from itself and disagreed with its own
# graph on all 720. A sponsor that sends an index-zero planet up to a star rather than its
# galaxy -- the `%454` fault, planted back -- missed on the chain, the depth and the sponsor
# pair at once. A chain read one rung short answered 4 for cousins and disagreed on 33,264
# pairs. Run a pen copy with `TOPOLOGY_SRC` set, since the root walk starts from `$0`.
#
# A FOURTH PLANT TAUGHT MORE BY PASSING. A ring gap that forgot to wrap -- the plain absolute
# difference -- sails through the self-check, because it is still a graph metric: it is the
# Manhattan distance on a MESH, and a mesh realizes it exactly, at diameter 26 against the
# torus 14. The wrap buys the diameter; it does not buy the honesty. This script was written
# expecting that plant to red, and it was right not to.
#
# A CENSUS GATES NOTHING ELSE. It reports; a paper cites it; a witness may later bind one of
# its readings. `verdict=ok` unless an agreement leg fails, or the torus or point leg
# disagrees with its own graph -- the sponsor leg`s disagreements are the finding and are
# reported, never a fault of this script. The point leg self-checks like the torus one
# because it, unlike the sponsor metric, claims to be realizable everywhere.
#
# Instrument: `awk` alone (POSIX-granted). No temporary files, no `mktemp`.
#
# Read against: active-designing/20260906-010402_a-third-of-the-sky-has-no-road.md and the
# errata of external-research/20260906-010402_the-ring-and-the-ladder.md, whose narrower
# falsifier the point leg`s connected reading is.
set -eu

if [ -n "${TOPOLOGY_SRC:-}" ]; then
  SRC="$TOPOLOGY_SRC"
else
  ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
  _steps=0
  while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
    _steps=$((_steps + 1))
    if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
      echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
      exit 2
    fi
    ROOT=$(dirname "$ROOT")
  done
  SRC="$ROOT/comlink/topology.rye"
fi

if [ ! -f "$SRC" ]; then
  echo "topology_graph_census: the topology source is missing at $SRC" >&2
  exit 2
fi

command -v awk >/dev/null 2>&1 || {
  echo "topology_graph_census: needs awk, and this host has none" >&2
  exit 2
}

G=$(awk -F'= *' '/^pub const galaxies_per_universe/ {gsub(/;.*/,"",$2); print $2; exit}' "$SRC")
S=$(awk -F'= *' '/^pub const stars_per_galaxy/     {gsub(/;.*/,"",$2); print $2; exit}' "$SRC")
P=$(awk -F'= *' '/^pub const planets_per_star/     {gsub(/;.*/,"",$2); print $2; exit}' "$SRC")
CG=$(awk '/^pub const council_sky/ {match($0,/\.galaxies = [0-9]+/); print substr($0,RSTART+12,RLENGTH-12); exit}' "$SRC")
CS=$(awk '/^pub const council_sky/ {match($0,/\.stars = [0-9]+/);    print substr($0,RSTART+9,RLENGTH-9);   exit}' "$SRC")
CP=$(awk '/^pub const council_sky/ {match($0,/\.planets = [0-9]+/);  print substr($0,RSTART+11,RLENGTH-11); exit}' "$SRC")

for v in G S P CG CS CP; do
  eval "val=\$$v"
  case "$val" in
    ''|*[!0-9]*)
      echo "topology_graph_census: could not read $v from $SRC -- refusing rather than assuming a geometry" >&2
      exit 2 ;;
  esac
done

echo "source $SRC"
echo "compass_sky galaxies=$G stars=$S planets=$P"
echo "council_sky galaxies=$CG stars=$CS planets=$CP"

# NOTE TO A FUTURE EDITOR: the awk program below is single-quoted, so an apostrophe anywhere
# inside it -- in a comment as readily as in a string -- ends the program. Its comments are
# written without them on purpose.
awk -v g1="$G" -v s1="$S" -v p1="$P" -v g2="$CG" -v s2="$CS" -v p2="$CP" '
# --- the two metrics, over one coordinate load -------------------------------

# route_hops, as the module computes it: up to the deepest shared level and back down, or
# one bridge between galaxy admins.
function hops(a, b,   sh) {
  if (gal[a] != gal[b]) return d[a] + d[b] + 1
  sh = 0
  if (d[a] >= 1 && d[b] >= 1 && st[a] == st[b]) {
    sh = 1
    if (d[a] >= 2 && d[b] >= 2 && pl[a] == pl[b]) sh = 2
  }
  return (d[a] - sh) + (d[b] - sh)
}

# The gap along one ring of N seats: the shorter of the two ways around. This is the whole
# of the torus reading, applied once per coordinate.
function ring_gap(x, y, n,   raw) {
  raw = x - y
  if (raw < 0) raw = -raw
  return (raw < n - raw) ? raw : n - raw
}

# The toroidal distance over the same three coordinates, read as three rings.
function lee(a, b) {
  return ring_gap(gal[a], gal[b], RG) + ring_gap(st[a], st[b], RS) + ring_gap(pl[a], pl[b], RP)
}

# point_hops, as the module computes it: the walk up the sponsor chain in NUMBER space to
# the nearest shared ancestor and down the other side, or one bridge between galaxy admins.
# sponsor_num is Address.parent then Sky.encode, resolved to arithmetic: a galaxy sponsors
# itself, a star drops to its galaxy, and a planet drops to its own star -- which for star
# index zero IS the galaxy number, because encode puts that star on it. That collapse is the
# whole difference between this metric and the one above.
function sponsor_num(n,   SC) {
  SC = RG * RS
  if (n < RG) return n
  if (n < SC) return n % RG
  return n % SC
}

# The chains and depths, computed once per load rather than once per metric call, since the
# graph build asks for every ordered pair.
function chains(PC,   n, h, steps) {
  delete a1; delete a2; delete pdep
  for (n = 0; n < PC; n++) {
    a1[n] = sponsor_num(n)
    a2[n] = sponsor_num(a1[n])
    h = n; steps = 0
    while (h >= RG) { h = sponsor_num(h); steps++ }
    pdep[n] = steps
  }
}

# The rising-sum search the module runs, unrolled over max_tier_depth = 2. Rising by i + j
# reaches the FIRST occurrence first, which is the nearest shared ancestor.
function anc(n, i) { return (i == 0) ? n : ((i == 1) ? a1[n] : a2[n]) }

function phops(a, b,   sum, i, j) {
  for (sum = 0; sum <= 4; sum++)
    for (i = 0; i <= sum; i++) {
      j = sum - i
      if (i > 2 || j > 2) continue
      if (anc(a, i) == anc(b, j)) return sum
    }
  return pdep[a] + pdep[b] + 1
}

function metric(kind, a, b) {
  if (kind == "sponsor") return hops(a, b)
  if (kind == "point") return phops(a, b)
  return lee(a, b)
}

# decode, as the module computes it: a point number to three coordinates and a depth. The
# coordinate extraction is shared by both metrics on purpose -- only the distance differs.
function load(G, S, P,   SC, PC, n) {
  SC = G * S; PC = SC * P
  RG = G; RS = S; RP = P
  delete gal; delete st; delete pl; delete d
  for (n = 0; n < PC; n++) {
    gal[n] = n % G
    st[n]  = int((n % SC) / G)
    pl[n]  = int(n / SC)
    d[n]   = (n < G) ? 0 : ((n < SC) ? 1 : 2)
  }
  chains(PC)
  return PC
}

function put(i, g, s, p, t) { gal[i] = g; st[i] = s; pl[i] = p; d[i] = t; return i }

function check(name, a, b, want,   got) {
  got = hops(a, b)
  if (got == want) { printf "  selftest_pair %s hops=%d ok\n", name, got; return 0 }
  printf "  selftest_pair %s hops=%d wanted=%d MISMATCH\n", name, got, want
  return 1
}

# The elder census published three compass readings. Binding to them here means a change to
# either script that moves a number is caught by the other, rather than by a reader.
function elder(name, got, want,   lo, hi) {
  lo = want - 0.00005; hi = want + 0.00005
  if (got >= lo && got <= hi) { printf "  elder_reading %s=%.4f ok\n", name, got; return 0 }
  printf "  elder_reading %s=%.4f wanted=%.4f MISMATCH\n", name, got, want
  return 1
}

function agree(G, S, P,   bad, pt, sp, sib, cou, far) {
  bad = 0
  if (G * S == 60 && G * S * P == 720)
    printf "  derived_counts star_count=60 universe_points=720 ok\n"
  else {
    printf "  derived_counts star_count=%d universe_points=%d wanted=60,720 MISMATCH\n", G*S, G*S*P
    bad = 1
  }
  delete gal; delete st; delete pl; delete d
  pt  = put(1, 3, 2, 7, 2)
  sp  = put(2, 3, 2, 0, 1)
  sib = put(3, 3, 2, 9, 2)
  cou = put(4, 3, 4, 1, 2)
  far = put(5, 8, 0, 0, 2)
  bad += check("self", pt, pt, 0)
  bad += check("planet_to_its_star", pt, sp, 1)
  bad += check("siblings", pt, sib, 2)
  bad += check("cousins", pt, cou, 4)
  bad += check("across_galaxies", pt, far, 5)
  return bad
}

# The six pairs comlink/topology.rye asserts of point_hops, checked here in the same numbers
# the module writes. A change to either side that moves one of them is caught by the other
# rather than by a reader, which is the same binding the elder() function does for the
# sponsor readings.
function pcheck(name, a, b, want,   got) {
  got = phops(a, b)
  if (got == want) { printf "  point_pair %s hops=%d ok\n", name, got; return 0 }
  printf "  point_pair %s hops=%d wanted=%d MISMATCH\n", name, got, want
  return 1
}

function pointagree(PC,   bad) {
  bad = 0
  if (sponsor_num(60) == 0) printf "  point_chain sponsor_of_60=0 ok\n"
  else { printf "  point_chain sponsor_of_60=%d wanted=0 MISMATCH\n", sponsor_num(60); bad++ }
  if (pdep[60] == 1) printf "  point_chain depth_of_60=1 ok\n"
  else { printf "  point_chain depth_of_60=%d wanted=1 MISMATCH\n", pdep[60]; bad++ }
  bad += pcheck("self", 0, 0, 0)
  bad += pcheck("outfit_is_one_point", 8, 8, 0)
  bad += pcheck("planet_to_its_sponsor", 60, 0, 1)
  bad += pcheck("cousins", 60, 72, 3)
  bad += pcheck("bridge", 60, 61, 3)
  return bad
}

# --- the graph the metric defines, and the walk across it --------------------

# Edges are exactly the pairs the metric places at distance one. Nothing is assumed about
# what a link is; the metric is asked, and its own answer builds the graph.
function build(kind, PC,   a, b, e) {
  delete deg; delete adj
  e = 0
  for (a = 0; a < PC; a++) deg[a] = 0
  for (a = 0; a < PC; a++) for (b = a + 1; b < PC; b++) {
    if (metric(kind, a, b) != 1) continue
    adj[a, deg[a]++] = b
    adj[b, deg[b]++] = a
    e++
  }
  return e
}

# One breadth-first walk from `src`, filling dist[]. Returns how many points it reached.
function bfs(src, PC,   head, tail, i, u, v, seen) {
  delete dist
  for (i = 0; i < PC; i++) dist[i] = -1
  dist[src] = 0; q[0] = src; head = 0; tail = 1; seen = 1
  while (head < tail) {
    u = q[head++]
    for (i = 0; i < deg[u]; i++) {
      v = adj[u, i]
      if (dist[v] >= 0) continue
      dist[v] = dist[u] + 1
      q[tail++] = v
      seen++
    }
  }
  return seen
}

# One walk with a single point removed, so a cut point can be counted rather than argued.
function bfs_minus(src, PC, banned,   head, tail, i, u, v, seen) {
  delete dist
  for (i = 0; i < PC; i++) dist[i] = -1
  if (src == banned) return 0
  dist[src] = 0; q[0] = src; head = 0; tail = 1; seen = 1
  while (head < tail) {
    u = q[head++]
    for (i = 0; i < deg[u]; i++) {
      v = adj[u, i]
      if (v == banned || dist[v] >= 0) continue
      dist[v] = dist[u] + 1
      q[tail++] = v
      seen++
    }
  }
  return seen
}

# How much of the reachable graph one failed point takes with it. The start point is held
# fixed inside the largest component, so every reading is against one baseline.
function cutpoints(kind, name, PC,   a, src, base, seen, stranded, cuts, worst, cg, cs, cp) {
  src = -1
  for (a = 0; a < PC; a++) if (deg[a] > 0) { src = a; break }
  if (src < 0) { printf "  %s_cuts no_edges\n", name; return }
  base = bfs(src, PC)
  cuts = 0; worst = 0
  for (a = 0; a < PC; a++) {
    if (a == src || deg[a] == 0) continue
    seen = bfs_minus(src, PC, a)
    stranded = base - seen - 1
    if (stranded > 0) {
      cuts++
      if (stranded > worst) worst = stranded
      # A count says how brittle; the tier says WHERE the brittleness sits, which is the
      # half a reader can act on. d[] is the address tier the point was loaded with.
      if (d[a] == 0) cg++; else if (d[a] == 1) cs++; else cp++
    }
  }
  printf "  %s_cuts component_size=%d cut_points_excluding_start=%d worst_case_stranded=%d worst_share_of_component=%.4f\n",
    name, base, cuts, worst, worst / base
  printf "  %s_cuts_by_tier galaxies=%d stars=%d planets=%d of_that_tier=%d/%d/%d\n",
    name, cg, cs, cp, RG, RG * RS - RG, RG * RS * RP - RG * RS
}

function walk(kind, name, PC,   a, b, edges, iso, mx, mn, agreeing, differ, unreach, comps, seen, gdiam) {
  edges = build(kind, PC)
  iso = 0; mx = 0; mn = PC
  for (a = 0; a < PC; a++) {
    if (deg[a] == 0) iso++
    if (deg[a] > mx) mx = deg[a]
    if (deg[a] < mn) mn = deg[a]
  }
  agreeing = 0; differ = 0; unreach = 0; comps = 0; gdiam = 0
  delete compseen
  for (a = 0; a < PC; a++) {
    seen = bfs(a, PC)
    if (!(a in compseen)) {
      comps++
      for (b = 0; b < PC; b++) if (dist[b] >= 0) compseen[b] = 1
    }
    for (b = 0; b < PC; b++) {
      if (dist[b] < 0) { unreach++; continue }
      if (dist[b] > gdiam) gdiam = dist[b]
      if (dist[b] == metric(kind, a, b)) agreeing++; else differ++
    }
  }
  printf "  %s_graph edges=%d degree_min=%d degree_max=%d degree_mean=%.4f isolated=%d components=%d\n",
    name, edges, mn, mx, 2 * edges / PC, iso, comps
  printf "  %s_graph walk_diameter=%d metric_agrees=%d metric_differs=%d metric_unreachable=%d share_unreachable=%.4f\n",
    name, gdiam, agreeing, differ, unreach, unreach / (PC * PC)
  return differ + unreach
}

# --- the distribution of one metric over every ordered pair ------------------

function spread(kind, name, PC,   a, b, h, T, sum, H, p, k, maxh, cross, zero) {
  delete hist; delete v
  T = 0; sum = 0; maxh = 0; zero = 0
  for (a = 0; a < PC; a++) for (b = 0; b < PC; b++) {
    h = metric(kind, a, b); hist[h]++; T++; sum += h
    if (h > maxh) maxh = h
    if (h == 0 && a != b) zero++
  }
  H = 0
  for (k in hist) { p = hist[k] / T; H -= p * log(p) / log(2) }
  cross = 0
  for (a = 0; a < PC; a++) for (b = 0; b < PC; b++) {
    if (d[a] != 2 || d[b] != 2) continue
    if (gal[a] != gal[b]) continue
    if (st[a] == st[b]) continue
    v[metric(kind, a, b)]++; cross++
  }
  CEIL = log(length(hist)) / log(2)
  ENT = H
  DIAM = maxh
  TOPSHARE = hist[maxh] / T
  printf "  %s points=%d pairs=%d diameter=%d mean=%.4f\n", name, PC, T, maxh, sum / T
  printf "  %s entropy_bits=%.4f ceiling_bits=%.4f distinct_values=%d efficiency=%.4f\n",
    name, H, CEIL, length(hist), (CEIL > 0 ? H / CEIL : 0)
  printf "  %s at_diameter_share=%.4f cross_star_planet_pairs=%d distinct_values_among_them=%d zero_distinct=%d\n",
    name, TOPSHARE, cross, length(v), zero
  return zero
}

# The number a point sponsor encodes to, exactly as Address.parent then Sky.encode compute it:
# a planet sponsors up to (galaxy, star), a star up to its galaxy, a galaxy to itself.
function sponsor_number(n) {
  if (d[n] == 2) return gal[n] + st[n] * RG
  if (d[n] == 1) return gal[n]
  return n
}

# The module publishes the sponsor as one hop up the chain. This asks whether the metric
# agrees, for every point that has a sponsor, and names the points where it does not.
function sponsorleg(name, PC,   n, s, h, broken, sample, st0) {
  broken = 0; sample = -1; st0 = 0
  for (n = 0; n < PC; n++) {
    if (d[n] == 0) continue
    s = sponsor_number(n)
    h = hops(n, s)
    if (h == 1) continue
    broken++
    if (sample < 0) sample = n
    if (d[n] == 2 && st[n] == 0) st0++
  }
  printf "  %s_sponsor points_with_a_sponsor=%d hop_is_one=%d hop_is_not_one=%d all_of_them_star_index_zero=%s\n",
    name, PC - RG, PC - RG - broken, broken, (broken == st0 ? "yes" : "no")
  if (sample >= 0)
    printf "  %s_sponsor first_disagreeing_point=%d sponsor_number=%d metric_says=%d chain_says=1\n",
      name, sample, sponsor_number(sample), hops(sample, sponsor_number(sample))
  return broken
}

# Whether the isolated set IS the star-index-zero planet set, checked point by point rather
# than by matching two counts, which two different sets can also do.
function isolatedleg(name, PC,   n, iso, pred, both) {
  iso = 0; pred = 0; both = 0
  for (n = 0; n < PC; n++) {
    if (deg[n] == 0) iso++
    if (d[n] == 2 && st[n] == 0) pred++
    if (deg[n] == 0 && d[n] == 2 && st[n] == 0) both++
  }
  printf "  %s_isolated isolated=%d star_index_zero_planets=%d in_both=%d same_set=%s\n",
    name, iso, pred, both, (iso == pred && iso == both ? "yes" : "no")
}

BEGIN {
  faults = 0
  printf "model_agreement compass\n"
  faults += agree(g1, s1, p1)

  PC = load(g1, s1, p1)
  printf "leg sponsor compass\n"
  faults += spread("sponsor", "sponsor_compass", PC)
  faults += elder("compass_entropy_bits", ENT, 1.0461)
  faults += elder("compass_at_diameter_share", TOPSHARE, 0.7703)
  if (DIAM == 5) printf "  elder_reading compass_diameter=5 ok\n"
  else { printf "  elder_reading compass_diameter=%d wanted=5 MISMATCH\n", DIAM; faults++ }
  walk("sponsor", "sponsor_compass", PC)
  sponsorleg("sponsor_compass", PC)
  isolatedleg("sponsor_compass", PC)
  cutpoints("sponsor", "sponsor_compass", PC)

  printf "leg point compass\n"
  faults += pointagree(PC)
  spread("point", "point_compass", PC)
  point_bad = walk("point", "point_compass", PC)
  cutpoints("point", "point_compass", PC)
  if (point_bad != 0) { printf "  point_self_check disagreeing_pairs=%d MISMATCH\n", point_bad; faults++ }
  else printf "  point_self_check disagreeing_pairs=0 ok\n"

  printf "leg torus compass\n"
  spread("torus", "torus_compass", PC)
  torus_bad = walk("torus", "torus_compass", PC)
  cutpoints("torus", "torus_compass", PC)
  if (torus_bad != 0) { printf "  torus_self_check disagreeing_pairs=%d MISMATCH\n", torus_bad; faults++ }
  else printf "  torus_self_check disagreeing_pairs=0 ok\n"

  PC = load(g2, s2, p2)
  printf "leg sponsor council\n"
  faults += spread("sponsor", "sponsor_council", PC)
  walk("sponsor", "sponsor_council", PC)
  sponsorleg("sponsor_council", PC)
  isolatedleg("sponsor_council", PC)
  cutpoints("sponsor", "sponsor_council", PC)
  printf "leg point council\n"
  spread("point", "point_council", PC)
  point_bad = walk("point", "point_council", PC)
  cutpoints("point", "point_council", PC)
  if (point_bad != 0) { printf "  point_self_check disagreeing_pairs=%d MISMATCH\n", point_bad; faults++ }
  else printf "  point_self_check disagreeing_pairs=0 ok\n"

  printf "leg torus council\n"
  spread("torus", "torus_council", PC)
  torus_bad = walk("torus", "torus_council", PC)
  cutpoints("torus", "torus_council", PC)
  if (torus_bad != 0) { printf "  torus_self_check disagreeing_pairs=%d MISMATCH\n", torus_bad; faults++ }
  else printf "  torus_self_check disagreeing_pairs=0 ok\n"

  printf "faults=%d\n", faults
  printf "verdict=%s\n", (faults == 0 ? "ok" : "instrument_fault")
  exit (faults == 0 ? 0 : 1)
}'
