#!/bin/sh
# tools/fixtures/t/topology_revocation_census.sh -- what a revocation costs, and what it
# reaches, in the two shapes the sky can be read as.
#
# WHY. Sponsorship is the one question a ladder answers that a ring does not: who vouches for
# you, and who may take it back. Its sibling `topology_graph_census.sh` priced the ladder as a
# ROUTING metric and found a third of the sky unreachable. This one asks the other half of the
# trade, which that census named in a sentence and left unmeasured: what does it cost to
# revoke a point, and how far does one revocation reach?
#
# THE TWO COSTS, kept apart because they are different acts.
#
#   refuse-as-endpoint -- every neighbor refuses traffic whose end is `p`. `p` is cut off and
#                         transit THROUGH `p` still works. Cost is exactly `deg(p)` refusals,
#                         and it reaches exactly one point.
#   refuse-as-peer     -- the links to `p` come down. `p` goes, and so does its transit, so
#                         whatever routed only through `p` goes with it. Cost is the same
#                         `deg(p)` teardowns; what it REACHES is the question this measures.
#
# THE THIRD LEG, and what it closes. `point_hops` is the metric the module publishes beside
# `route_hops`, walking the sponsor chain in NUMBER space where a star of index zero and its
# galaxy are one point. Its sibling published that graphs cut points as 59 and said plainly
# that the figure was measured ONCE, because this census carried no point leg. It carries one
# now, and the two independent algorithms here agree at 60 -- the same 59 plus the walks own
# start, which the siblings sweep excludes by construction and this one does not.
#
# WHAT THE THIRD LEG MEASURED THAT NOBODY HAD. The repair that made the ladder connected
# also made revocation dearer per refusal spent: the best dividend falls 3.20 to 2.27 on the
# compass sky and 1.12 to 1.08 on the council sky, because collapsing the index-zero star
# hands a galaxy its planets directly and its degree rises 15 to 26 while its reach rises
# only 48 to 59. One repair, read as a gain by the routing census and as a cost by this one.
#
# WHAT IT PRINTS, per sky, per metric:
#
#   degree      -- min, mean, max: the price of one revocation in enforcement points.
#   cascade     -- how many points a single removal strands, and where. `cascade(p)` counts
#                  the points of `p`s own component cut off from that components largest
#                  surviving piece. Zero everywhere means no revocation reaches past itself.
#   dividend    -- stranded per refusal spent, the largest in the sky. A high dividend is
#                  cheap transitive revocation AND a wide blast radius; they are one number.
#
# THE SELF-CHECK IS TWO ALGORITHMS, NOT ONE. The cascade sweep finds cut points by removing
# each point and walking what is left. A second, independent pass finds them by the standard
# depth-first lowlink criterion -- a root with two or more children in the search tree, or a
# point with a child whose subtree reaches no further up. The two sets must be identical. One
# algorithm measuring itself proves nothing; two disagreeing means this script is wrong, and
# it refuses rather than reporting.
#
# IT ALSO BINDS TO ITS SIBLING, IN SIZE AND IN SHAPE. `topology_graph_census.sh` published,
# for the compass sponsor graph, 642 edges, 132 isolated points and a worst cascade of 48, and
# for the point graph 774 edges, 0 isolated and a worst cascade of 59. Those are asserted here
# before any new number prints, so a change that moves either script is caught by the other
# rather than by a reader.
#
# SIZE ALONE IS NOT ENOUGH, and the control proves it rather than this comment asserting it.
# Delete the star tier from the point metric -- every planet sponsored by its galaxy directly
# -- and edges stay 774, isolated stays 0, max_stranded stays 59, and BOTH cut-point
# algorithms agree on the wrong answer. Three size binds and the agreement leg, all silent,
# over a graph missing an entire tier. So degree_max and the cut count are bound as well, and
# they are what bites: 26 to 70, and 60 to 12.
#
# WHAT IS MEASURED AND WHAT IS PROPOSED. The sponsor leg measures the metric that ships. The
# torus leg measures a metric NOTHING IN THE TREE IMPLEMENTS -- arithmetic over the modules
# own three coordinates, reported so a design argument can cite a number rather than an
# adjective. Two Rooms: sponsor readings checkable, torus readings proposed.
#
# WHAT IT DOES NOT MEASURE. Whether a revocation SHOULD cascade. That is a policy question
# and the answer differs by what is being revoked; this prints the price of each choice.
#
# AND WHAT IT CANNOT SEE, WITH THE READING THAT COVERS IT. This census builds its graph from
# the metrics UNIT distance alone, so an error that moves no distance-one pair is invisible
# here. Measured `20260906.130000`: spelling the cross-galaxy bridge with the ADDRESS depth
# instead of the point depth -- the natural slip, since `hops` two functions up does exactly
# that -- leaves every number on every leg identical and `verdict=ok`, because the only
# cross-galaxy pairs at distance one are root-to-root, where the two depths agree at zero.
# The same plant in `topology_graph_census.sh` bites four ways at once, `point_pair bridge
# hops=5 wanted=3` and `metric_differs=158268` among them, because that census compares the
# metric against a walk over ALL 518,400 ordered pairs. Two censuses, two questions: this one
# asks what one removal costs, that one asks whether the published distance is a road.
#
# A CENSUS GATES NOTHING. It reports; a paper cites it; a witness may later bind one reading.
# `verdict=ok` unless an agreement leg fails or the two cut-point algorithms disagree.
#
# Instrument: `awk` alone (POSIX-granted). No temporary files, no `mktemp`.
#
# Read against: active-designing/20260906-034951_the-revocation-and-the-fault-ride-one-edge.md
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
  echo "topology_revocation_census: the topology source is missing at $SRC" >&2
  exit 2
fi

command -v awk >/dev/null 2>&1 || {
  echo "topology_revocation_census: needs awk, and this host has none" >&2
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
      echo "topology_revocation_census: could not read $v from $SRC -- refusing rather than assuming a geometry" >&2
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

# route_hops, as comlink/topology.rye computes it.
function hops(a, b,   sh) {
  if (gal[a] != gal[b]) return d[a] + d[b] + 1
  sh = 0
  if (d[a] >= 1 && d[b] >= 1 && st[a] == st[b]) {
    sh = 1
    if (d[a] >= 2 && d[b] >= 2 && pl[a] == pl[b]) sh = 2
  }
  return (d[a] - sh) + (d[b] - sh)
}

# The gap along one ring of N seats: the shorter of the two ways around.
function ring_gap(x, y, n,   raw) {
  raw = x - y
  if (raw < 0) raw = -raw
  return (raw < n - raw) ? raw : n - raw
}

function lee(a, b) {
  return ring_gap(gal[a], gal[b], RG) + ring_gap(st[a], st[b], RS) + ring_gap(pl[a], pl[b], RP)
}

# --- the third metric: point_hops, in NUMBER space ---------------------------

# sponsor_of, as the module computes it: decode, take the parent, encode. A star of index
# zero encodes onto its own galaxys own number, so the sponsor of such a planet IS the
# galaxy. That collapse is what makes this metric connected where route_hops is not.
function point_sponsor(n) {
  if (d[n] == 2) return gal[n] + st[n] * RG
  return gal[n]
}

# point_depth, walked in number space rather than read off the address. The two disagree
# exactly where the collapse bites: a planet under a star of index zero stands at address
# depth 2 and at point depth 1, and the bridge below wants the second.
function point_depth_of(n,   here, steps) {
  here = n; steps = 0
  while (here >= RG) { steps++; here = point_sponsor(here) }
  return steps
}

# point_hops, as Sky.point_hops computes it: the walk up the sponsor chain to the nearest
# shared ancestor, rising by the SUM of the two indices so the first meeting found is the
# nearest one; across galaxies, up to each root and one bridge hop between them. The module
# pins max_tier_depth at 2, so a chain is three entries and the last is always a galaxy.
function point_hops(a, b,   i, j, sum, ca, cb) {
  ca[0] = a; ca[1] = point_sponsor(a); ca[2] = point_sponsor(ca[1])
  cb[0] = b; cb[1] = point_sponsor(b); cb[2] = point_sponsor(cb[1])
  for (sum = 0; sum <= 4; sum++)
    for (i = 0; i <= sum; i++) {
      j = sum - i
      if (i > 2 || j > 2) continue
      if (ca[i] == cb[j]) return sum
    }
  return point_depth_of(a) + point_depth_of(b) + 1
}

# An unknown kind REFUSES rather than falling through. The elder form spelled this as a
# ternary whose else-branch was the torus, so any name but sponsor measured the torus and
# wore the name it was given -- a census mislabelling its own subject in silence.
function metric(kind, a, b) {
  if (kind == "sponsor") return hops(a, b)
  if (kind == "point")   return point_hops(a, b)
  if (kind == "torus")   return lee(a, b)
  printf "topology_revocation_census: unknown metric kind %s -- refusing rather than measuring a shape nobody named\n", kind > "/dev/stderr"
  exit 2
}

# decode, as the module computes it: a point number to three coordinates and a depth.
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
  return PC
}

# --- the graph the metric defines --------------------------------------------

# Edges are exactly the pairs the metric places at distance one. Nothing about a link is
# assumed; the metric is asked, and its own answer builds the graph.
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

# --- components, and the cascade a single removal causes ---------------------

# Label every point with its component id. Returns the component count.
function components(PC,   a, c, head, tail, u, i, v) {
  delete comp; delete csize
  for (a = 0; a < PC; a++) comp[a] = -1
  c = 0
  for (a = 0; a < PC; a++) {
    if (comp[a] >= 0) continue
    comp[a] = c; q[0] = a; head = 0; tail = 1; csize[c] = 1
    while (head < tail) {
      u = q[head++]
      for (i = 0; i < deg[u]; i++) {
        v = adj[u, i]
        if (comp[v] >= 0) continue
        comp[v] = c; csize[c]++; q[tail++] = v
      }
    }
    c++
  }
  return c
}

# How many points of `p`s own component are cut off from that components LARGEST surviving
# piece once `p` is removed. Zero when `p` is a leaf or its component stays whole.
function cascade(p,   mine, n, a, head, tail, u, i, v, big, reached, start, cs)
{
  mine = comp[p]
  cs = csize[mine]
  if (cs <= 2) return 0            # a component of one or two loses nothing but p itself
  delete seen
  big = 0; reached = 0
  for (a in idx) delete idx[a]
  # Walk each surviving piece of the component and keep the largest.
  for (start = 0; start < NPTS; start++) {
    if (comp[start] != mine || start == p || (start in seen)) continue
    n = 1; seen[start] = 1; q[0] = start; head = 0; tail = 1
    while (head < tail) {
      u = q[head++]
      for (i = 0; i < deg[u]; i++) {
        v = adj[u, i]
        if (v == p || (v in seen)) continue
        seen[v] = 1; n++; q[tail++] = v
      }
    }
    reached += n
    if (n > big) big = n
  }
  return reached - big
}

# --- the second, independent algorithm: articulation points by lowlink -------

# Standard Hopcroft-Tarjan, written iteratively so no recursion depth is assumed. A root of
# the search tree is a cut point when it has two or more children; any other point is one
# when some child subtree reaches no further up than that point itself.
function articulation(PC,   a, u, v, i, top, timer, root, kids) {
  delete artic; delete disc; delete low; delete par; delete it
  for (a = 0; a < PC; a++) { disc[a] = 0; artic[a] = 0 }
  timer = 0
  for (root = 0; root < PC; root++) {
    if (disc[root]) continue
    kids = 0
    par[root] = -1; it[root] = 0
    disc[root] = ++timer; low[root] = disc[root]
    stk[0] = root; top = 1
    while (top > 0) {
      u = stk[top - 1]
      if (it[u] < deg[u]) {
        v = adj[u, it[u]++]
        if (v == par[u]) continue
        if (disc[v]) {
          if (disc[v] < low[u]) low[u] = disc[v]
          continue
        }
        par[v] = u; it[v] = 0
        disc[v] = ++timer; low[v] = disc[v]
        if (u == root) kids++
        stk[top++] = v
      } else {
        top--
        if (top > 0) {
          a = stk[top - 1]
          if (low[u] < low[a]) low[a] = low[u]
          if (a != root && low[u] >= disc[a]) artic[a] = 1
        }
      }
    }
    if (kids >= 2) artic[root] = 1
  }
}

# --- the readings ------------------------------------------------------------

function bind(name, got, want) {
  if (got == want) { printf "  bound %s=%d ok\n", name, got; return 0 }
  printf "  bound %s=%d wanted=%d MISMATCH\n", name, got, want
  return 1
}

function survey(sky, kind, PC,   a, e, nc, dmin, dmax, dsum, cuts, worst, tot,
                                 c, div, bestdiv, bestpt, alg2, both, only1, only2) {
  e = build(kind, PC)
  nc = components(PC)
  NPTS = PC

  dmin = -1; dmax = 0; dsum = 0
  for (a = 0; a < PC; a++) {
    dsum += deg[a]
    if (deg[a] > dmax) dmax = deg[a]
    if (dmin < 0 || deg[a] < dmin) dmin = deg[a]
  }

  cuts = 0; worst = 0; tot = 0; bestdiv = 0; bestpt = -1
  delete iscut
  for (a = 0; a < PC; a++) {
    c = cascade(a)
    if (c <= 0) continue
    iscut[a] = 1; cuts++; tot += c
    if (c > worst) worst = c
    if (deg[a] > 0) {
      div = c / deg[a]
      if (div > bestdiv) { bestdiv = div; bestpt = a }
    }
  }

  # The independent second opinion. A cut point by lowlink whose component holds two points
  # strands nothing measurable, so the comparison is over points that strand something.
  articulation(PC)
  alg2 = 0; both = 0; only1 = 0; only2 = 0
  for (a = 0; a < PC; a++) {
    if (artic[a] && csize[comp[a]] > 2) alg2++
    if ((a in iscut) && artic[a]) both++
    else if (a in iscut) only1++
    else if (artic[a] && csize[comp[a]] > 2) only2++
  }

  printf "%s %s edges=%d components=%d\n", sky, kind, e, nc
  # Degree and the price of refuse-as-endpoint are ONE number, which is the finding rather
  # than a shorthand: isolating a point takes a refusal from each of its neighbors and no
  # more, so the graph already publishes the enforcement bill.
  printf "%s %s degree_is_endpoint_cost min=%d mean=%.2f max=%d reaches=1\n", sky, kind, dmin, dsum / PC, dmax
  printf "%s %s cascade points=%d max_stranded=%d total_stranded=%d\n", sky, kind, cuts, worst, tot
  if (bestpt >= 0)
    printf "%s %s dividend best=%.2f at_point=%d degree=%d stranded=%d\n",
      sky, kind, bestdiv, bestpt, deg[bestpt], cascade(bestpt)
  else
    printf "%s %s dividend best=0.00 at_point=none -- no removal reaches past itself\n", sky, kind
  printf "%s %s cut_agreement sweep=%d lowlink=%d in_both=%d sweep_only=%d lowlink_only=%d same_set=%s\n",
    sky, kind, cuts, alg2, both, only1, only2, (only1 == 0 && only2 == 0) ? "yes" : "NO"

  LAST_EDGES = e; LAST_WORST = worst; LAST_DEGMAX = dmax; LAST_CUTS = cuts
  return (only1 == 0 && only2 == 0) ? 0 : 1
}

BEGIN {
  faults = 0

  # --- compass, the seated sky ---
  PC = load(g1, s1, p1)
  print "compass agreement -- bound to topology_graph_census.sh published readings"
  edges = build("sponsor", PC)
  isolated = 0
  for (a = 0; a < PC; a++) if (deg[a] == 0) isolated++
  faults += bind("compass_sponsor_edges", edges, 642)
  faults += bind("compass_sponsor_isolated", isolated, 132)
  pedges = build("point", PC)
  pisolated = 0
  for (a = 0; a < PC; a++) if (deg[a] == 0) pisolated++
  faults += bind("compass_point_edges", pedges, 774)
  faults += bind("compass_point_isolated", pisolated, 0)

  faults += survey("compass", "sponsor", PC)
  faults += bind("compass_sponsor_max_stranded", LAST_WORST, 48)
  faults += bind("compass_sponsor_degree_max", LAST_DEGMAX, 15)
  faults += bind("compass_sponsor_cut_points", LAST_CUTS, 60)
  faults += survey("compass", "point", PC)
  faults += bind("compass_point_max_stranded", LAST_WORST, 59)
  # THE TWO SHAPE BINDS, and why they are here rather than only the size ones. A plant that
  # deletes the star tier outright -- every planet sponsored by its galaxy directly -- leaves
  # edges at 774, isolated at 0 and max_stranded at 59, all three unmoved, because the same
  # 59 points are stranded however the tier beneath them is wired. What it moves is degree_max
  # 26 to 70 and the cut count 60 to 12, and both cut-point algorithms agree on the wrong
  # answer, so the agreement leg stays quiet too. The control plants exactly that.
  #
  # THE CUT COUNT IS 60 HERE AND 59 IN THE SIBLING, and the gap is the whole of it: the sibling
  # sweep excludes the walk it starts from and this one does not. One reading, one named offset.
  faults += bind("compass_point_degree_max", LAST_DEGMAX, 26)
  faults += bind("compass_point_cut_points", LAST_CUTS, 60)
  faults += survey("compass", "torus", PC)

  # --- council, the second seated sky ---
  PC = load(g2, s2, p2)
  faults += survey("council", "sponsor", PC)
  faults += survey("council", "point", PC)
  faults += survey("council", "torus", PC)

  printf "faults=%d\n", faults
  printf "verdict=%s\n", (faults == 0) ? "ok" : "refused"
  exit (faults == 0) ? 0 : 1
}

'
