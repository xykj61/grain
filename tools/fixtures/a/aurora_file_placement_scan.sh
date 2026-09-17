#!/bin/sh
# tools/fixtures/a/aurora_file_placement_scan.sh -- THE UNIT THE CAPACITY FORCED.
#
# Row 7 of active-designing/20260910-060204_the-bounded-torus-moonshots.md proposes Aurora on a
# small torus of cores with a placement map as its first witness. Its SECOND erratum
# (`20260916.095958`, active-designing/20260916-095958_the-two-ways-a-proxy-drifts.md) closed on a
# named next step and nothing had taken it:
#
#   "name which FILES sit on which node rather than which modules, since the coarsening the first
#    erratum called the harder half is forced rather than optional"
#
# The force is capacity. Tracked Rye bytes over sixteen nodes leave an equal share smaller than the
# largest room, so every assignment of MODULES to nodes overflows a node. The erratum then noted
# that the largest single FILE is about a quarter of a node's share, and stopped there. This scan
# reads what that unit actually costs, in three readings.
#
#   READING 1 -- WHERE THE UNIT STOPS FITTING. For each grid the scan divides total tracked
#   non-symlink Rye bytes by the node count and compares the largest single file against that equal
#   share. The erratum's "one level down" has its own ceiling, and the scan names the grid where it
#   arrives. It also names how many ROOMS overflow, which is the erratum's own finding re-read on
#   today's bytes. Every figure here is FREE: the tree grows.
#
#   READING 2 -- WHAT THE FINER GRAPH HOLDS. Import edges are resolved at FILE granularity through
#   the symlinks this tree files by hand, since Zig refuses an import escaping the root file's
#   directory. The reading that matters is the split: an edge whose two files sit in one room is
#   INVISIBLE to a room-level graph and FREE by construction under any module placement, because
#   both endpoints land on one node. Capacity forbids that placement, so those edges become real
#   costs the room graph never had to price. Every figure here is FREE.
#
#   READING 3 -- THE PLACEMENT. A capacity-constrained greedy assignment of files to nodes,
#   ordered by weighted degree, each file taking the feasible node minimising its cost against
#   already-placed neighbours. It is compared against random feasible assignments packed by the
#   same capacity rule, so the only thing separating them is whether the graph was consulted. A
#   layout that cannot beat that baseline has learned nothing from the graph.
#
#   READING 4 -- THE BORROWED TOLERANCE, RE-MEASURED. The layout above is computed on the static
#   import graph, which is STRUCTURE read as a lower bound on coupling. The sibling reading
#   (`20260916.095958`) measured how far a run-time weight may depart from that structure before
#   the layout stops beating chance, and answered `60` percent over 67 ROOM pairs. The paper that
#   took the file unit BORROWED that number and named the borrowing as its own weakest joint. A
#   tolerance is a property of a graph rather than of an idea, so it is read again here on this
#   tree's file edges, by the sibling's own method and at the sibling's own threshold: with
#   probability p a real import edge carries no run-time traffic at all, and the same COUNT of file
#   pairs carrying no import edge carry traffic the static graph cannot see. The computed layout is
#   held FIXED and costed under the distorted edges, against a count-matched floor costed under the
#   same distorted edges. Every figure here is FREE: the tree grows.
#
# THE FALSIFIERS, each one command away: `unit_fits_sixteen=no` would refute the erratum's own
# claim that the file unit fits where the module unit does not; `intra_room_edge_share` near zero
# would say the finer unit reveals nothing a room graph lacked; and `gain_share` at or below zero
# at any fitting grid would say a file placement reads no better than chance. For reading 4,
# `file_structure_drift_bites=no` would say the sweep distorts nothing a layout can feel, and
# `drift pct=0` reading a gain share far from `sixteen_matched_gain_share` would say the sweep is
# measuring a different placement than the one the scan computed.
#
# THE LAYOUT IS A PROPERTY OF THE TREE RATHER THAN OF A LISTING ORDER. Files are placed in order
# of degree descending with the file name breaking every tie, so a shuffled input gives the same
# map. The control reads the same tree twice and compares.
#
# Emits key=value lines and a verdict. Bounds are named at the top. Exit 0 always; the witness
# reads the keys. Reads the tree it is run in, so a pen tree is read exactly as this one is.
set -u

MAX_FILES=8192              # tracked Rye sources admitted; past this the reading refuses to grow
MAX_EDGES=65536             # resolved import edges admitted
MAX_GRIDS=8                 # grids graded per run
MAX_SAMPLES=64              # random feasible baselines drawn per grid

GRIDS="2 4 8"
SAMPLES=24                  # baseline draws per grid; each costs one full cost pass
CAP_SLACK=125               # per-node capacity as a percentage of the equal share, so a packer
                            # has somewhere to put a file that will not fit an exact sixteenth
LCG_SEED=20260917           # fixed: a reading must not move between hosts

# READING 4's own bounds. The ladder, the keep threshold and the distorted grid are the SIBLING's
# numbers unchanged, because the whole point of this reading is that two numbers compare.
DRIFT_LADDER="0 20 40 60 70 80 90 100"   # percent of real edges silenced, each replaced by an
                            # unseen pair. The sibling's five rungs are kept exactly and TWO are
                            # added at 70 and 90, because a 20-point rung is a coarser readout than
                            # the effect it is being asked to resolve: both graphs answer 60 on the
                            # sibling's ladder while their interpolated crossings differ by several
                            # points, which a reader of the survival point alone cannot see.
MAX_DRIFT_RUNGS=8           # rungs graded per run
DRIFT_DRAWS=6               # distortion draws averaged per rung. The sibling averaged twenty over
                            # 67 room pairs; this graph carries ~7,500 edges, so a single draw is
                            # already an average over a hundredfold larger sample and six steadies
                            # it at a sixth of the wall time.
DRIFT_SAMPLES=10            # matched-floor draws per distortion draw, costed under the SAME
                            # distorted edges the layout is costed under
DRIFT_NODES=16              # the grid the row names, and the grid the sibling distorted
KEEP_SHARE=0.10             # a placement earns its keep at a tenth of the floor's average cost --
                            # the sibling's own threshold, kept so the two survival points compare

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
cd "$ROOT" || exit 0

echo "scan=aurora_file_placement"
echo "row=7"
echo "page=active-designing/20260910-060204_the-bounded-torus-moonshots.md"
echo "answers=active-designing/20260916-095958_the-two-ways-a-proxy-drifts.md"
echo "max_files=$MAX_FILES"
echo "max_edges=$MAX_EDGES"
echo "max_grids=$MAX_GRIDS"
echo "max_samples=$MAX_SAMPLES"
echo "cap_slack_pct=$CAP_SLACK"
echo "max_drift_rungs=$MAX_DRIFT_RUNGS"
echo "drift_draws=$DRIFT_DRAWS"
echo "drift_samples=$DRIFT_SAMPLES"
echo "keep_share=$KEEP_SHARE"

work=$(mktemp -d) || { echo "verdict=unreadable"; exit 0; }
trap 'rm -rf "$work"' EXIT INT TERM

# ---- the population: tracked Rye sources that are real files, with their sizes ----------------
# A symlink is a name rather than a body -- it carries no bytes to place and it is how a cross-room
# import is spelled here, so it is resolved rather than placed.
git ls-files -s -- '*.rye' 2>/dev/null | awk '$1 != "120000" { sub(/^[0-9]+ [0-9a-f]+ [0-9]+\t/, ""); print }' > "$work/real.txt"
git ls-files -s -- '*.rye' 2>/dev/null | awk '$1 == "120000" { sub(/^[0-9]+ [0-9a-f]+ [0-9]+\t/, ""); print }' > "$work/links.txt"

files=$(wc -l < "$work/real.txt" | tr -d ' ')
links=$(wc -l < "$work/links.txt" | tr -d ' ')
echo "rye_files=$files"
echo "rye_symlinks=$links"

if [ "$files" -eq 0 ]; then
  echo "reading1=unreadable"
  echo "verdict=empty"
  exit 0
fi
if [ "$files" -gt "$MAX_FILES" ]; then
  echo "files_over_bound=yes"
  echo "verdict=unreadable"
  exit 0
fi

# sizes, in batches rather than one process per file: 1,761 `wc` starts cost more than the whole
# rest of the reading, which is this fleet's own lesson from a publish that spent 28 seconds in
# `cp` starts. `wc -c` over many paths prints a `total` line per batch, dropped by name.
xargs -n 400 wc -c < "$work/real.txt" 2>/dev/null \
  | awk '$2 != "total" && NF >= 2 { size = $1; $1 = ""; sub(/^ /, ""); print size "\t" $0 }' \
  > "$work/sizes.txt"

# ---- the symlink map: a spelled name to the real file it names --------------------------------
: > "$work/linkmap.txt"
while IFS= read -r l; do
  t=$(readlink -f "$l" 2>/dev/null) || continue
  case "$t" in "$ROOT"/*) printf '%s\t%s\n' "$l" "${t#"$ROOT"/}" ;; esac
done < "$work/links.txt" > "$work/linkmap.txt"

# ---- READING 2 -- the file-level import graph -------------------------------------------------
# One edge per (importing file, imported file) pair. An import is spelled as a bare name resolved
# against the importing file's own directory, so the target path is computed rather than searched.
git grep -I -h -o -E '@import\("[^"]+\.rye"\)' -- '*.rye' > /dev/null 2>&1
git grep -I -n -o -E '@import\("[^"]+\.rye"\)' -- '*.rye' 2>/dev/null \
  | sed 's/:[0-9]*:@import("/\t/; s/")$//' > "$work/raw_imports.txt"

awk -F'\t' -v maxe="$MAX_EDGES" '
  function normalize(p,   parts, n, i, out, m) {
    n = split(p, parts, "/")
    m = 0
    for (i = 1; i <= n; i++) {
      if (parts[i] == "." || parts[i] == "") continue
      if (parts[i] == "..") { if (m > 0) m--; continue }
      out[++m] = parts[i]
    }
    p = ""
    for (i = 1; i <= m; i++) p = (i == 1) ? out[i] : p "/" out[i]
    return p
  }
  NR == FNR { real[$1] = 1; next }
  FILENAME ~ /linkmap/ { link[$1] = $2; next }
  {
    src = $1; name = $2
    if (!(src in real)) next
    dir = src
    if (sub(/\/[^\/]*$/, "", dir) == 0) dir = ""
    tgt = normalize(dir == "" ? name : dir "/" name)
    if (tgt in link) tgt = link[tgt]
    if (!(tgt in real)) next
    if (tgt == src) next
    # UNORDERED: cost is symmetric and a mutual import is one adjacency, so a -> b and b -> a
    # must not be priced twice. The printed order stays as found; only the key is sorted.
    if (src < tgt) key = src SUBSEP tgt; else key = tgt SUBSEP src
    if (key in seen) next
    seen[key] = 1
    if (++n > maxe) { over = 1; next }
    print src "\t" tgt
  }
  END { if (over) print "OVER\tOVER" }
' "$work/real.txt" "$work/linkmap.txt" "$work/raw_imports.txt" > "$work/edges.txt"

if grep -q '^OVER	OVER$' "$work/edges.txt" 2>/dev/null; then
  echo "edges_over_bound=yes"
  echo "verdict=unreadable"
  exit 0
fi

edges=$(wc -l < "$work/edges.txt" | tr -d ' ')
echo "import_edges=$edges"

awk -F'\t' '
  function room(p,   i) { i = index(p, "/"); return (i == 0) ? "." : substr(p, 1, i - 1) }
  { a = room($1); b = room($2); if (a == b) intra++; else cross++
    importing[$1] = 1; endpoint[$1] = 1; endpoint[$2] = 1
    if (a != b) { x = a; y = b; if (x > y) { t = x; x = y; y = t }; pair[x SUBSEP y] = 1 }
    rm[a] = 1; rm[b] = 1 }
  END {
    ni = 0; for (x in importing) ni++
    ne = 0; for (x in endpoint) ne++
    np = 0; for (x in pair) np++
    nr = 0; for (x in rm) nr++
    tot = intra + cross
    printf "importing_files=%d endpoint_files=%d\n", ni, ne
    printf "intra_room_edges=%d cross_room_edges=%d\n", intra + 0, cross + 0
    printf "intra_room_edge_share=%.6f\n", (tot > 0) ? intra / tot : 0
    printf "room_pairs_with_an_edge=%d graph_rooms=%d\n", np, nr
    printf "edges_per_room_pair=%.3f\n", (np > 0) ? tot / np : 0
  }
' "$work/edges.txt"

# ---- READING 1 and READING 3 ------------------------------------------------------------------
cat > "$work/place.awk" <<'AWKBODY'
# Written to $work by aurora_file_placement_scan.sh; every bound arrives as a -v and is named there.
# MINSTD, for the reason the sibling scan gives: awk carries numbers as doubles, so a multiplier
# whose product with 2^31 passes 2^53 stops being a generator at all.
function lcg() { state = (state * 48271) % 2147483647; if (state < 1) state = 1; return state }
function rnd(m) { return int(lcg() % m) }

function hop(u, v, k,    ux, uy, vx, vy, dx, dy) {
  ux = u % k; uy = int(u / k); vx = v % k; vy = int(v / k)
  dx = ux > vx ? ux - vx : vx - ux
  dy = uy > vy ? uy - vy : vy - uy
  if (k - dx < dx) dx = k - dx
  if (k - dy < dy) dy = k - dy
  return dx + dy
}

function cost_of(node, k,    e, c) {
  c = 0
  for (e = 1; e <= ne; e++) c += hop(node[eA[e]], node[eB[e]], k)
  return c
}

# greedy, capacity-constrained: each file takes the feasible node minimising its cost against the
# neighbours already placed. Ties go to the lowest node index, so the layout is deterministic.
function place(n, k, cap, node,    i, f, v, e, c, best, bestc, rem, ok) {
  for (v = 0; v < n; v++) rem[v] = cap
  for (i in node) delete node[i]
  infeasible = 0
  for (i = 1; i <= nf; i++) {
    f = ORD[i]
    best = -1; bestc = -1
    for (v = 0; v < n; v++) {
      if (rem[v] < SZ[f]) continue
      c = 0
      for (e = 1; e <= deg[f]; e++) {
        ob = ADJ[f, e]
        if (ob in node) c += hop(v, node[ob], k)
      }
      if (bestc < 0 || c < bestc) { bestc = c; best = v }
    }
    if (best < 0) { infeasible++; best = 0 }
    node[f] = best; rem[best] -= SZ[f]
  }
  return cost_of(node, k)
}

# a random feasible packing under the same capacity rule: the graph is never consulted, so the
# difference between this and the layout above is exactly what the graph bought.
function place_random(n, k, cap, node,    i, f, v, tries, rem, order, j, t) {
  for (v = 0; v < n; v++) rem[v] = cap
  for (i in node) delete node[i]
  for (i = 1; i <= nf; i++) order[i] = ORD[i]
  for (i = nf; i > 1; i--) { j = 1 + rnd(i); t = order[i]; order[i] = order[j]; order[j] = t }
  for (i = 1; i <= nf; i++) {
    f = order[i]
    v = rnd(n); tries = 0
    while (rem[v] < SZ[f] && tries < n) { v = (v + 1) % n; tries++ }
    node[f] = v; rem[v] -= SZ[f]
  }
  return cost_of(node, k)
}

# the COUNT-MATCHED baseline, and it is the reading that decides the lap. The computed layout is
# free to pile many files onto one node, and a node holding many files pays nothing for the traffic
# inside it -- so a baseline that spreads loses to it under ANY weights, including weights carrying
# no information at all. This one deals every file at random into the SAME per-node file count the
# computed layout produced, leaving only where the graph put them to compare. It ignores capacity
# on purpose: a baseline free of a constraint the layout obeyed can only do better than an
# achievable one, so the comparison is conservative in the direction that matters.
function place_matched(n, k, occ, node,    i, v, q, idx, order, j, t) {
  for (i = 1; i <= nf; i++) order[i] = ORD[i]
  for (i = nf; i > 1; i--) { j = 1 + rnd(i); t = order[i]; order[i] = order[j]; order[j] = t }
  for (i in node) delete node[i]
  idx = 0
  for (v = 0; v < n; v++) for (q = 1; q <= occ[v]; q++) { idx++; node[order[idx]] = v }
  return cost_of(node, k)
}

# ---- READING 4 -- STRUCTURE DRIFT, THE SIBLING'S METHOD ON THIS UNIT --------------------------
# With probability P a real import edge carries no run-time traffic at all -- a file read once at
# startup -- and the SAME COUNT of file pairs carrying no import edge carry traffic the static
# graph cannot see. The result is a hypothetical run-time graph of about the same size, sharing
# less and less structure with the one the layout was computed from.
function drift_build(P,   e, i, phantoms, a, b, t) {
  nde = 0
  for (e = 1; e <= ne; e++) {
    if (rnd(100) < P) continue
    nde++; dA[nde] = eA[e]; dB[nde] = eB[e]
  }
  phantoms = int(ne * P / 100 + 0.5)
  for (i = 1; i <= phantoms; i++) {
    a = fn[1 + rnd(nf)]; b = fn[1 + rnd(nf)]
    if (a == b) continue
    if (a > b) { t = a; a = b; b = t }
    if ((a SUBSEP b) in SEEN) continue
    nde++; dA[nde] = a; dB[nde] = b
  }
  return nde
}

function drift_cost(node, k,    e, c) {
  c = 0
  for (e = 1; e <= nde; e++) c += hop(node[dA[e]], node[dB[e]], k)
  return c
}

# the count-matched floor again, split so the seating and the costing are separate acts: the floor
# must be costed under the SAME distorted edges as the layout, or the comparison is between two
# different graphs rather than between two placements.
function seat_matched(n, occ, node,    i, v, q, idx, order, j, t) {
  for (i = 1; i <= nf; i++) order[i] = ORD[i]
  for (i = nf; i > 1; i--) { j = 1 + rnd(i); t = order[i]; order[i] = order[j]; order[j] = t }
  for (i in node) delete node[i]
  idx = 0
  for (v = 0; v < n; v++) for (q = 1; q <= occ[v]; q++) { idx++; node[order[idx]] = v }
}

NR == FNR { SZ[$2] = $1 + 0; fn[++nf] = $2; total += $1 + 0
            r = $2; if (sub(/\/.*$/, "", r) == 0) r = "."
            ROOMB[r] += $1 + 0; next }
{ a = $1; b = $2
  if (!(a in SZ) || !(b in SZ)) next
  ne++; eA[ne] = a; eB[ne] = b
  # the pair key is sorted, since the edge list prints each pair in the order it was found and a
  # phantom must not duplicate a real edge whichever way round it was written
  if (a < b) SEEN[a SUBSEP b] = 1; else SEEN[b SUBSEP a] = 1
  deg[a]++; ADJ[a, deg[a]] = b
  deg[b]++; ADJ[b, deg[b]] = a
  wdeg[a]++; wdeg[b]++ }

END {
  if (nf == 0) { print "reading1=unreadable"; exit }

  # the largest single file, and the largest room, both read rather than recalled
  big = 0; bigf = ""
  for (i = 1; i <= nf; i++) if (SZ[fn[i]] > big) { big = SZ[fn[i]]; bigf = fn[i] }
  bigroom = 0; bigroomn = ""
  for (r in ROOMB) if (ROOMB[r] > bigroom) { bigroom = ROOMB[r]; bigroomn = r }
  nrooms = 0; for (r in ROOMB) nrooms++

  printf "rye_bytes_total=%d\n", total
  printf "largest_file=%s largest_file_bytes=%d\n", bigf, big
  printf "largest_room=%s largest_room_bytes=%d rooms=%d\n", bigroomn, bigroom, nrooms

  # --- READING 1 -- where the unit stops fitting ---------------------------------------------
  ng = split(grids, gl, " ")
  if (ng > maxg) { print "grids_over_bound=yes"; ng = maxg }
  for (gi = 1; gi <= ng; gi++) {
    k = gl[gi] + 0
    n = k * k
    share = total / n
    over = 0
    for (r in ROOMB) if (ROOMB[r] > share) over++
    printf "fit k=%d nodes=%d equal_share_bytes=%d file_fits=%s rooms_over_share=%d largest_file_share=%.4f\n",
      k, n, int(share), (big <= share) ? "yes" : "no", over, (share > 0) ? big / share : 0
    if (n == 16) {
      sixteen_fits = (big <= share) ? "yes" : "no"
      sixteen_rooms_over = over
    }
    if (big <= share) last_fitting = n; else if (first_over == 0) first_over = n
  }
  printf "unit_fits_sixteen=%s\n", (sixteen_fits == "") ? "ungraded" : sixteen_fits
  printf "module_unit_overflows_sixteen=%s rooms_over_share_sixteen=%d\n",
    (sixteen_rooms_over > 0) ? "yes" : "no", sixteen_rooms_over + 0
  printf "unit_ceiling_nodes=%d first_overflowing_nodes=%d\n", last_fitting + 0, first_over + 0

  # --- READING 3 -- the placement --------------------------------------------------------------
  if (ne == 0) { print "reading3=unreadable"; exit }
  # the intra-room share, recomputed here off the same edge list, so the comparison below reads
  # one number rather than borrowing one from a sibling pass
  intracount = 0
  for (e = 1; e <= ne; e++) {
    ra = eA[e]; if (sub(/\/.*$/, "", ra) == 0) ra = "."
    rb = eB[e]; if (sub(/\/.*$/, "", rb) == 0) rb = "."
    if (ra == rb) intracount++
  }
  intrashare = intracount / ne
  # order by degree descending, name ascending on a tie, so the layout does not depend on the
  # order the filesystem happened to hand back
  for (i = 1; i <= nf; i++) ORD[i] = fn[i]
  for (i = 1; i <= nf; i++) for (j = i + 1; j <= nf; j++) {
    a = ORD[i]; b = ORD[j]
    if (wdeg[b] > wdeg[a] || (wdeg[b] == wdeg[a] && b < a)) { ORD[i] = b; ORD[j] = a }
  }

  for (gi = 1; gi <= ng; gi++) {
    k = gl[gi] + 0
    n = k * k
    cap = int(total / n * slack / 100) + 1
    if (cap < big) cap = big          # a node must be able to hold the largest single file
    c = place(n, k, cap, NODE)
    inf = infeasible
    state = seed + k
    lo = -1; tot = 0
    for (s = 1; s <= samples; s++) {
      rc = place_random(n, k, cap, RNODE)
      tot += rc
      if (lo < 0 || rc < lo) lo = rc
    }
    mean = tot / samples
    gain = (mean > 0) ? (mean - c) / mean : 0
    # occupancy, read off the computed layout
    for (v = 0; v < n; v++) { occf[v] = 0; occb[v] = 0 }
    for (i = 1; i <= nf; i++) { occf[NODE[fn[i]]]++; occb[NODE[fn[i]]] += SZ[fn[i]] }
    fullest = 0; empty = 0
    for (v = 0; v < n; v++) { if (occb[v] > fullest) fullest = occb[v]; if (occf[v] == 0) empty++ }
    # how many edges the layout kept on one node, which is the free traffic it managed to save
    same = 0
    for (e = 1; e <= ne; e++) if (NODE[eA[e]] == NODE[eB[e]]) same++
    printf "place k=%d nodes=%d cap_bytes=%d infeasible_files=%d\n", k, n, cap, inf
    printf "place k=%d cost=%d random_min=%d random_mean=%.3f gain_share=%.6f beats_floor=%s\n",
      k, c, lo, mean, gain, (c < lo) ? "yes" : "no"
    printf "place k=%d fullest_node_bytes=%d empty_nodes=%d same_node_edges=%d same_node_share=%.6f\n",
      k, fullest, empty, same, (ne > 0) ? same / ne : 0

    # the count-matched floor, drawn against the occupancy the computed layout produced
    state = seed + k + 31
    mlo = -1; mtot = 0
    for (s = 1; s <= samples; s++) {
      mc = place_matched(n, k, occf, MNODE)
      mtot += mc
      if (mlo < 0 || mc < mlo) mlo = mc
    }
    mmean = mtot / samples
    mgain = (mmean > 0) ? (mmean - c) / mmean : 0
    printf "place k=%d matched_min=%d matched_mean=%.3f matched_gain_share=%.6f beats_matched_floor=%s\n",
      k, mlo, mmean, mgain, (c < mlo) ? "yes" : "no"
    if (n == 16) { sixteen_gain = gain; sixteen_beats = (c < lo) ? "yes" : "no"; sixteen_inf = inf
                   sixteen_mgain = mgain; sixteen_mbeats = (c < mlo) ? "yes" : "no"
                   sixteen_same = (ne > 0) ? same / ne : 0 }

    # --- READING 4 -- the borrowed tolerance, re-read on this graph --------------------------
    if (n == dnodes && ne > 0) {
      nrungs = split(dladder, dl, " ")
      if (nrungs > maxrungs) { print "drift_rungs_over_bound=yes"; nrungs = maxrungs }
      surv = -1
      for (di = 1; di <= nrungs; di++) {
        P = dl[di] + 0
        tot = 0
        for (d = 1; d <= ddraws; d++) {
          state = seed + k + P * 104729 + d
          drift_build(P)
          dc = drift_cost(NODE, k)
          mt = 0
          for (ds = 1; ds <= dsamples; ds++) { seat_matched(n, occf, DNODE); mt += drift_cost(DNODE, k) }
          dm = mt / dsamples
          tot += (dm > 0) ? (dm - dc) / dm : 0
        }
        g = tot / ddraws
        ok = (g >= keep) ? "yes" : "no"
        printf "drift k=%d pct=%d draws=%d live_edges=%d mean_gain_share=%.6f still_worth=%s\n",
          k, P, ddraws, nde, g, ok
        if (ok == "yes" && P > surv) surv = P
        GV[di] = g; PV[di] = P
        if (di == 1) dfirst = g
        dlast = g
      }
      printf "drift_grid_nodes=%d drift_keep_share=%.2f\n", n, keep
      printf "file_proxy_survives_structure_drift_upto_pct=%d\n", surv
      # THE SURVIVAL POINT IS A LADDER RUNG, so it can only ever be as fine as the ladder. Where
      # the gain crosses the keep threshold BETWEEN two rungs, say so by interpolation -- and print
      # beside it how far the measured ladder departs from a straight line, since interpolating a
      # curve that is not straight is a guess wearing a decimal point.
      cross = -1
      for (di = 2; di <= nrungs; di++) {
        if (GV[di - 1] >= keep && GV[di] < keep) {
          span = GV[di - 1] - GV[di]
          cross = (span > 0) ? PV[di - 1] + (PV[di] - PV[di - 1]) * (GV[di - 1] - keep) / span : PV[di - 1]
          break
        }
      }
      printf "file_drift_crossing_pct=%.2f\n", cross
      dev = 0
      for (di = 1; di <= nrungs; di++) {
        lin = GV[1] * (1 - PV[di] / 100)
        d2 = GV[di] - lin; if (d2 < 0) d2 = -d2
        if (d2 > dev) dev = d2
      }
      printf "drift_linear_max_abs_dev=%.6f drift_decay_linear=%s\n", dev, (dev <= 0.05) ? "yes" : "no"
      # AND IF THE DECAY IS STRAIGHT, THE TOLERANCE HAS A CLOSED FORM. Gain falls as g0(1 - p), so
      # it reaches the keep threshold at p = 1 - keep/g0 -- the tolerance is set by the undistorted
      # gain and the threshold alone, and granularity enters only through g0. Printed beside the
      # measured crossing so the two can disagree out loud.
      closed = (GV[1] > 0) ? 100 * (1 - keep / GV[1]) : 0
      gap = closed - cross; if (gap < 0) gap = -gap
      printf "drift_crossing_closed_form_pct=%.2f drift_crossing_gap_pts=%.2f\n", closed, gap
      # the two verdicts a guard can hold, read from the same sweep: whether moving the edges costs
      # the layout anything at all, and how far they may move before it stops earning its keep.
      printf "file_structure_drift_bites=%s\n", ((dfirst - dlast) >= keep) ? "yes" : "no"
      printf "drift_undistorted_gain_share=%.6f\n", dfirst + 0
      print "reading4=read"
    }
  }
  printf "sixteen_gain_share=%.6f sixteen_beats_floor=%s sixteen_infeasible_files=%d\n",
    sixteen_gain + 0, (sixteen_beats == "") ? "ungraded" : sixteen_beats, sixteen_inf + 0
  printf "sixteen_matched_gain_share=%.6f sixteen_beats_matched_floor=%s\n",
    sixteen_mgain + 0, (sixteen_mbeats == "") ? "ungraded" : sixteen_mbeats
  # what the forbidden coarsening was buying, against what the unit that fits keeps: a room layout
  # keeps every intra-room edge on one node by construction, so its share IS the intra-room share.
  printf "room_layout_same_node_share=%.6f file_layout_same_node_share=%.6f free_traffic_lost=%.6f\n",
    intrashare + 0, sixteen_same + 0, intrashare - sixteen_same
  print "reading3=read"
}
AWKBODY

awk -v grids="$GRIDS" -v maxg="$MAX_GRIDS" -v samples="$SAMPLES" -v slack="$CAP_SLACK" \
    -v seed="$LCG_SEED" -v dladder="$DRIFT_LADDER" -v ddraws="$DRIFT_DRAWS" \
    -v dsamples="$DRIFT_SAMPLES" -v dnodes="$DRIFT_NODES" -v maxrungs="$MAX_DRIFT_RUNGS" \
    -v keep="$KEEP_SHARE" \
    -F'\t' -f "$work/place.awk" "$work/sizes.txt" "$work/edges.txt"

echo "verdict=read"
