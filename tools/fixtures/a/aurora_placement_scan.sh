#!/bin/sh
# tools/fixtures/a/aurora_placement_scan.sh -- CAN ROW 7 BE PLACED? Row 7 of
# active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md proposes Aurora on a 4-core or
# 16-core network-on-chip "whose topology Grain knows to be a torus", with a placement map naming
# which module sits on which node as its first witness, and this falsifier: "the reachable boards
# are mesh rather than torus, which would leave the wrap-around hops the map depends on
# unavailable." It was the last of the twelve rows carrying no erratum.
#
# Both halves are gradeable with no board at all, and this scan reads them separately.
#
#   READING 1 -- THE GEOMETRY, in arithmetic. For a k x k grid the scan builds both graphs and
#   measures diameter, distinct link count, and mean pair distance. At k = 2 the wrap link is a
#   DUPLICATE of the mesh link, since i+1 mod 2 and i-1 mod 2 name the same node, so the 2 x 2
#   torus and the 2 x 2 mesh are one graph. The row's falsifier therefore cannot fire at the
#   4-core grid the row names first: there is nothing a mesh board would take away. At k = 4 it
#   fires with something real behind it. Every figure here is HELD -- the scan opens no file for
#   this reading, so nothing in the tree can move it.
#
#   READING 2 -- THE OPERAND. A placement map minimizes sum over pairs of w(i,j) x hops(i,j), so
#   it needs a module-to-module communication WEIGHT. The scan asks what this tree holds. Rye
#   rooms are counted from tracked sources. Cross-room edges are resolved through the import
#   SYMLINKS this tree files by hand, since Zig refuses an import escaping the root file's
#   directory and every cross-room dependency therefore arrives as a bare name pointing at a
#   symlink. That graph is STRUCTURE: one edge per importing source file, a startup read and a
#   hot loop indistinguishable. For traffic the scan reads every `loom` key in the tracked session
#   journal and asks how many name a module room, and how many name TWO -- a pair being the
#   shape a weight must wear. Every figure here is FREE: the tree grows.
#
# Emits key=value lines and a verdict. Bounds are named at the top. Exit 0 always; the witness
# reads the keys.
set -u

MAX_GRIDS=8                 # grids graded per run; each costs O(n^2) pair readings
MAX_ROOMS=256               # tracked top-level rooms admitted to the room census
MAX_IMPORTS=8192            # import sites read before the reading refuses to grow
MAX_KEYS=65536              # distinct loom keys admitted

GRIDS="2 3 4 8"
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
cd "$ROOT" || exit 0

echo "scan=aurora_placement"
echo "row=7"
echo "page=active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md"
echo "max_grids=$MAX_GRIDS"
echo "max_rooms=$MAX_ROOMS"
echo "max_imports=$MAX_IMPORTS"
echo "max_keys=$MAX_KEYS"

# ---- READING 1 -- the geometry, in arithmetic ------------------------------------------------
# A k x k mesh links (x,y) to (x +/- 1, y) and (x, y +/- 1) where those stay on the grid. A torus
# adds the wrap. Distinct link count is what a board would actually have to build: at k = 2 the
# forward and backward wrap name one pair, so the torus builds no link the mesh lacks.
echo "$GRIDS" | tr ' ' '\n' | awk -v maxg="$MAX_GRIDS" '
  BEGIN { graded = 0; fire_at_four = "unset" }
  NF == 0 { next }
  {
    k = $1 + 0
    if (k < 2) next
    if (graded >= maxg) { over++; next }
    graded++
    n = k * k
    tdia = 2 * int(k / 2)
    mdia = 2 * (k - 1)
    mlinks = 2 * k * (k - 1)
    # a torus builds 2 links per node per dimension, halved for direction, EXCEPT at k = 2 where
    # the wrap duplicates the mesh link and the distinct count collapses onto the mesh figure
    if (k == 2) tlinks = mlinks; else tlinks = 2 * k * k
    ts = 0; ms = 0; pairs = 0
    for (a = 0; a < n; a++) for (b = 0; b < n; b++) {
      if (a == b) continue
      ax = int(a / k); ay = a % k; bx = int(b / k); by = b % k
      dx = ax > bx ? ax - bx : bx - ax
      dy = ay > by ? ay - by : by - ay
      wx = k - dx; if (wx < dx) tdx = wx; else tdx = dx
      wy = k - dy; if (wy < dy) tdy = wy; else tdy = dy
      ts += tdx + tdy; ms += dx + dy; pairs++
    }
    same = (tdia == mdia && tlinks == mlinks && ts == ms) ? "yes" : "no"
    fire = (same == "yes") ? "no" : "yes"
    printf "grid k=%d nodes=%d torus_diameter=%d mesh_diameter=%d torus_links=%d mesh_links=%d torus_mean=%.4f mesh_mean=%.4f same_graph=%s falsifier_can_fire=%s\n", \
      k, n, tdia, mdia, tlinks, mlinks, ts / pairs, ms / pairs, same, fire
    if (k == 2) { four_same = same; four_fire = fire }
    if (k == 4) { sixteen_fire = fire; cut = mdia - tdia; meancut = (ms - ts) / ms }
  }
  END {
    printf "grids_graded=%d\n", graded
    printf "grids_over_bound=%d\n", over + 0
    printf "four_core_same_graph=%s\n", (four_same == "") ? "unread" : four_same
    printf "four_core_falsifier_can_fire=%s\n", (four_fire == "") ? "unread" : four_fire
    printf "sixteen_core_falsifier_can_fire=%s\n", (sixteen_fire == "") ? "unread" : sixteen_fire
    printf "sixteen_core_diameter_cut=%d\n", cut + 0
    printf "sixteen_core_mean_cut_share=%.4f\n", meancut + 0
  }'

# ---- READING 2 -- the operand ------------------------------------------------------------------
work=$(mktemp -d) || exit 0
trap 'rm -rf "$work"' EXIT INT TERM HUP

git ls-files '*.rye' 2>/dev/null | grep / > "$work/rye.txt" || true
rye_sources=$(wc -l < "$work/rye.txt" | tr -d ' ')
cut -d/ -f1 < "$work/rye.txt" | sort -u > "$work/rooms.txt"
rooms=$(wc -l < "$work/rooms.txt" | tr -d ' ')
echo "rye_sources=$rye_sources"
echo "rooms=$rooms"
if [ "$rooms" -gt "$MAX_ROOMS" ]; then
  echo "rooms_over_bound=yes"
else
  echo "rooms_over_bound=no"
fi

# every `@import("<name>.rye")` site, with the importing room and the path as written
awk '{
  f = $0; dir = f; sub(/\/[^\/]*$/, "", dir); room = f; sub(/\/.*/, "", room)
  while ((getline line < f) > 0) {
    while (match(line, /@import\("[^"]+\.rye"\)/)) {
      s = substr(line, RSTART + 9, RLENGTH - 11)
      line = substr(line, RSTART + RLENGTH)
      print room "\t" dir "/" s
    }
  }
  close(f)
}' "$work/rye.txt" | sort -u | head -"$MAX_IMPORTS" > "$work/imports.txt"
import_sites=$(wc -l < "$work/imports.txt" | tr -d ' ')
echo "import_sites=$import_sites"

# resolve each site: a symlink is followed to the room it lands in, a plain file keeps its own.
#
# THE WALK IS BOUNDED AND SPELLED HERE (seated 20260916, REDS %762). This read `readlink -f` until
# that stamp, whose resolve flag is GNU-only, so the `shell_dialect` gate counted an eighth site and
# reds on every ship. The canonical spelling is `resolve_path` in tools/fixtures/s/shell_portable.sh
# and this file may not reach it: `aurora_placement_control.sh` plants its four mutations by COPYING
# this scan into a pen and running the copy, so neither the git root nor a walk up from $0 lands
# anywhere a helper stands. A control that mutates by copying forbids its subject from sourcing.
#
# ONE HOP IS THE WRONG ANSWER HERE, which is why the bound matters rather than the portability
# alone. This tree files 41 chains longer than one hop and one of three, and this scan resolves an
# import symlink to THE ROOM IT LANDS IN -- so a link pointing at another link names the wrong room.
# Measured: a single hop moves room_pairs 75 to 74 and a top pair's weight 15 to 10, silently, with
# every leg of the control still green.
#
# MAX_LINK_HOPS is the helper's number and its reason travels with it: 40 is the depth this host's
# kernel itself enforces, so a chain past it names a path nothing here could open, and the tree's
# own deepest chain is 3. A cycle spends the budget and refuses instead of hanging.
MAX_LINK_HOPS=40           # symlink hops walked per site; the kernel's own SYMLOOP_MAX

while IFS="$(printf '\t')" read -r room path; do
  [ -n "$room" ] || continue
  if [ -L "$path" ]; then
    cur=$path
    hops=0
    while [ -L "$cur" ] && [ "$hops" -lt "$MAX_LINK_HOPS" ]; do
      hops=$((hops + 1))
      hop=$(readlink "$cur" 2>/dev/null) || break
      case "$hop" in
        /*) cur=$hop ;;
        *)  cur=$(dirname "$cur")/$hop ;;
      esac
    done
    if [ -L "$cur" ]; then
      target=""            # budget spent: a cycle or a chain past the kernel's own limit
    else
      # `cd -P`: a logical `cd` collapses `..` before resolving symlinks, and dash refuses
      # exactly the relative target a multi-hop walk produces where bash accepts it.
      dir=$(CDPATH= cd -P "$(dirname "$cur")" 2>/dev/null && pwd -P) || dir=""
      if [ -n "$dir" ]; then target="$dir/$(basename "$cur")"; else target=""; fi
    fi
    case "$target" in
      "$ROOT"/*) target=${target#"$ROOT"/} ;;
      *) target="" ;;
    esac
  else
    target=$path
  fi
  [ -n "$target" ] || continue
  troom=${target%%/*}
  [ "$troom" = "$room" ] && continue
  printf '%s -> %s\n' "$room" "$troom"
done < "$work/imports.txt" | sort | uniq -c | sort -rn > "$work/edges.txt"

room_pairs=$(wc -l < "$work/edges.txt" | tr -d ' ')
room_edges=$(awk '{ s += $1 } END { print s + 0 }' "$work/edges.txt")
echo "room_pairs=$room_pairs"
echo "room_edges=$room_edges"
awk 'NR <= 5 { printf "top_pair %s %s %s weight=%s\n", $2, $3, $4, $1 }' "$work/edges.txt"

# a weight needs traffic. read every loom key the journal carries and ask which name a room pair.
git grep -h '^loom ' -- 'session-logs/date/*/*.kyri' 2>/dev/null \
  | tr ' ' '\n' | grep '=' | cut -d= -f1 | sort -u | head -"$MAX_KEYS" > "$work/keys.txt"
loom_keys=$(wc -l < "$work/keys.txt" | tr -d ' ')
echo "loom_keys=$loom_keys"

awk -F'\t' 'NR == FNR { r[$1] = 1; next }
  {
    n = split($0, a, "_"); c = 0; names = ""
    delete seen
    for (i = 1; i <= n; i++) if (a[i] in r && !(a[i] in seen)) { seen[a[i]] = 1; c++; names = names " " a[i] }
    if (c >= 1) print c "\t" $0 "\t" names
  }' "$work/rooms.txt" "$work/keys.txt" > "$work/keyrooms.txt"
keys_one_room=$(wc -l < "$work/keyrooms.txt" | tr -d ' ')
keys_two_rooms=$(awk -F'\t' '$1 >= 2' "$work/keyrooms.txt" | wc -l | tr -d ' ')
echo "loom_keys_naming_a_room=$keys_one_room"
echo "loom_keys_naming_two_rooms=$keys_two_rooms"
awk -F'\t' '$1 >= 2 { printf "pair_key %s names%s\n", $2, $3 }' "$work/keyrooms.txt"

if [ "$keys_two_rooms" -eq 0 ]; then
  echo "weight_operand=absent"
else
  echo "weight_operand=named_only"
fi

# the coarsening the row never states: 43 rooms do not sit on 4 nodes one apiece
for k in 2 4; do
  n=$((k * k))
  if [ "$rooms" -gt "$n" ]; then
    echo "coarsening_needed k=$k nodes=$n rooms=$rooms verdict=needed"
  else
    echo "coarsening_needed k=$k nodes=$n rooms=$rooms verdict=free"
  fi
done

# ---- READING 3 -- the capacity term, which this tree DOES hold ---------------------------------
# Reading 2 found the traffic term absent. A placement has a SECOND operand and nobody asks for it:
# a node holds a bounded amount of code, so a map from rooms to nodes is feasible only if no room
# is larger than a node. That term is present here -- tracked Rye bytes per room -- so the question
# "can this be placed at all" is answerable today, ahead of any weight.
#
# SYMLINKS ARE EXCLUDED, and the exclusion is the reading rather than a detail: a cross-room
# `.rye` symlink is an import EDGE, and `wc -c` follows it, so counting one bills the importing
# room for the imported room's bytes. This tree files 233 of them.
#
# The bytes stand for instruction memory by assumption. A compiled size is not a source size, and
# the reading below turns on a ratio near six rather than near one, which no uniform constant
# factor moves.
MAX_ROOM_BYTES=17179869184   # bound: total tracked Rye bytes admitted to the capacity reading

git ls-files -s '*.rye' 2>/dev/null \
  | awk '$1 != "120000" { $1=$2=$3=""; sub(/^[ \t]+/, ""); print }' | grep / > "$work/regular.txt" || true
: > "$work/bytes.txt"
if [ -s "$work/regular.txt" ]; then
  # xargs runs its command once on empty input under one dialect and never under the other, so the
  # emptiness is tested above rather than left to either. `total` can repeat, since xargs batches.
  # `-0` rather than the `-a`/`-d`/`--null` family the `shell_dialect` gate holds at zero: both
  # dialects carry `-0`, and `\000` is the portable spelling of the NUL `tr` writes.
  tr '\n' '\000' < "$work/regular.txt" | xargs -0 wc -c 2>/dev/null \
    | awk 'NF >= 2 && $NF != "total" { print }' > "$work/bytes.txt"
fi

room_bytes_total=$(awk '{ s += $1 } END { print s + 0 }' "$work/bytes.txt")
largest_file_bytes=$(awk 'BEGIN { m = 0 } { if ($1 + 0 > m) m = $1 + 0 } END { print m + 0 }' "$work/bytes.txt")
echo "room_bytes_total=$room_bytes_total"
echo "largest_file_bytes=$largest_file_bytes"
if [ "$room_bytes_total" -gt "$MAX_ROOM_BYTES" ]; then
  echo "room_bytes_over_bound=yes"
else
  echo "room_bytes_over_bound=no"
fi

awk '{ room = $2; sub(/\/.*/, "", room); b[room] += $1 } END { for (r in b) print b[r], r }' \
  "$work/bytes.txt" | sort -k1,1nr -k2,2 > "$work/roombytes.txt"
largest_room=$(awk 'NR == 1 { print $2 }' "$work/roombytes.txt")
largest_room_bytes=$(awk 'NR == 1 { print $1 }' "$work/roombytes.txt")
echo "largest_room=$largest_room"
echo "largest_room_bytes=$largest_room_bytes"
awk -v t="$room_bytes_total" -v b="$largest_room_bytes" \
  'BEGIN { printf "largest_room_share=%.4f\n", (t > 0) ? b / t : 0 }'
awk 'NR <= 5 { printf "room_bytes %s %s\n", $2, $1 }' "$work/roombytes.txt"

for k in 2 4; do
  n=$((k * k))
  awk -v k="$k" -v n="$n" -v t="$room_bytes_total" -v b="$largest_room_bytes" -v f="$largest_file_bytes" '
    BEGIN {
      share = (n > 0) ? t / n : 0
      over = (share > 0) ? b / share : 0
      fover = (share > 0) ? f / share : 0
      # a tree carrying no Rye reads `unread` rather than `feasible`: an empty population fits
      # every node trivially, and a verdict that cannot tell that from a real fit teaches nothing
      verdict_room = (share <= 0) ? "unread" : (over <= 1 ? "feasible" : "infeasible")
      verdict_file = (share <= 0) ? "unread" : (fover <= 1 ? "feasible" : "infeasible")
      printf "capacity k=%d nodes=%d equal_share_bytes=%d largest_room_over=%.4f room_granularity=%s file_granularity=%s\n",
        k, n, share, over, verdict_room, verdict_file
    }'
done

# ---- READING 4 -- what the static proxy actually buys, and how wrong it may be -----------------
# The landed reading of `20260916.042700` raised one question and declined it: whether the static
# import graph, read as a LOWER BOUND on coupling rather than as a weight, is enough to start.
# This reading answers it, and the answer turns on a distinction the question did not carry.
#
#   THE LAYOUT. Rooms are coarsened onto the nodes by heavy-edge merging -- repeatedly join the
#   group pair carrying the most import weight -- and the groups are then laid on the grid by a
#   bounded search over 27 deterministic orders. Cost is the weight of every cross-node pair times
#   its hop count.
#
#   THE BASELINE IS SIZE-MATCHED, and that is the whole of what makes the number mean anything. A
#   node holding many rooms pays nothing for the traffic inside it, so a layout free to pile rooms
#   up beats a baseline that spreads them under ANY weights, including weights carrying no
#   information at all. The baseline therefore deals the rooms out at random into the SAME
#   node-occupancy profile the computed layout produced. Measured on this tree: the unmatched
#   reading credits the graph with a share the matched one does not.
#
#   THE TWO ERRORS. A run-time weight would differ from the static graph two ways, and only one of
#   them is the one a reader names. SCALE drift keeps the edges and scales the numbers. STRUCTURE
#   error moves the edges: an import read once at startup carries no traffic, and two rooms that
#   never import each other may still speak through a third. The sweeps below cost the computed
#   layout under each distortion against the same matched baseline, also distorted.
#
# Every figure here is FREE -- the room graph grows with the tree -- so run the scan.
MAX_SAMPLES=8192            # bound: random layouts drawn per grid
MAX_DRAWS=64                # bound: distortion draws per rung of a sweep
SAMPLES=800                 # the headline floor
DSAMPLES=80                 # the sweep floor, drawn afresh at every rung
DRAWS=20                    # distortion draws averaged per rung; twenty is what steadied
                            # the crossing rung across five seeds, eight left it moving
LCG_SEED=20260916           # fixed: a reading must not move between hosts
KEEP_SHARE=0.10             # a placement pass earns its keep at a tenth of the average cost
SCALE_LADDER="1 4 16 64 256"
DRIFT_LADDER="0 20 40 60 80 100"

if [ "$SAMPLES" -gt "$MAX_SAMPLES" ] || [ "$DRAWS" -gt "$MAX_DRAWS" ]; then
  echo "reading4=unreadable"
else
  cat > "$work/reading4.awk" <<'AWKBODY'
# reading 4 -- what the static import graph buys as a placement, and how wrong it may be.
# Written to $work by aurora_placement_scan.sh; every bound arrives as a -v and is named there.
# MINSTD rather than the usual 1103515245 multiplier: awk carries numbers as doubles, and
# 2^31 * 1103515245 is 2.4e18, far past the 2^53 where a double stops holding integers exactly,
# so that LCG loses its low bits and stops being a generator at all. 2^31 * 48271 is 1.0e14.
function lcg() { state = (state * 48271) % 2147483647; if (state < 1) state = 1; return state }
function rnd(m) { return int(lcg() % m) }
function uni() { return lcg() / 2147483648.0 }

function hop(u, v, k, topo,    n, ux, uy, vx, vy, dx, dy, d) {
  n = k * k
  if (topo == "ring") { d = u > v ? u - v : v - u; if (n - d < d) d = n - d; return d }
  ux = u % k; uy = int(u / k); vx = v % k; vy = int(v / k)
  dx = ux > vx ? ux - vx : vx - ux
  dy = uy > vy ? uy - vy : vy - uy
  if (topo == "torus") { if (k - dx < dx) dx = k - dx; if (k - dy < dy) dy = k - dy }
  return dx + dy
}

# cost of a room -> node map under the weights in FW[] (distorted or not)
function cost_of(node, k, topo,    e, a, b, c) {
  c = 0
  for (e = 1; e <= nactive; e++) {
    a = node[eA[e]]; b = node[eB[e]]
    if (a == b) continue
    c += FW[e] * hop(a, b, k, topo)
  }
  return c
}

# heavy-edge coarsening: merge the heaviest-joined group pair until `want` groups remain.
# ties break on the name order, so the reading does not depend on awk's array traversal.
function coarsen(want, grp,    i, j, e, x, y, best, bx, by, gw, live, m, changed) {
  for (i = 1; i <= nr; i++) grp[rn[i]] = rn[i]
  m = nr
  while (m > want) {
    for (x in gw) delete gw[x]
    best = -1; bx = ""; by = ""
    for (e = 1; e <= ne; e++) {
      x = grp[eA[e]]; y = grp[eB[e]]
      if (x == y) continue
      if (x > y) { i = x; x = y; y = i }
      gw[x SUBSEP y] += W[e]
    }
    for (x in gw) {
      split(x, f, SUBSEP)
      if (gw[x] > best || (gw[x] == best && (f[1] < bx || (f[1] == bx && f[2] < by)))) {
        best = gw[x]; bx = f[1]; by = f[2]
      }
    }
    if (best < 0) {
      # no cross-group edge remains: merge the two lexicographically smallest live groups,
      # so the reading still reaches `want` deterministically
      delete live
      for (i = 1; i <= nr; i++) live[grp[rn[i]]] = 1
      bx = ""; by = ""
      for (i = 1; i <= nr; i++) {
        x = rn[i]
        if (!(x in live)) continue
        if (bx == "") { bx = x; continue }
        if (by == "") { by = x; break }
      }
      if (by == "") break
    }
    for (i = 1; i <= nr; i++) if (grp[rn[i]] == by) grp[rn[i]] = bx
    m--
    merges++
  }
  return m
}

# greedy placement of the groups named in ORD[1..gc] onto `n` nodes
function lay(gc, n, k, topo, node,    i, r, v, c, best, bestc, taken, gnode) {
  for (v = 0; v < n; v++) taken[v] = 0
  for (i in gnode) delete gnode[i]
  for (i = 1; i <= gc; i++) {
    best = -1; bestc = -1
    for (v = 0; v < n; v++) {
      if (taken[v]) continue
      c = 0
      for (r = 1; r <= ne; r++) {
        if (GRP[eA[r]] == ORD[i] && (GRP[eB[r]] in gnode)) c += FW[r] * hop(v, gnode[GRP[eB[r]]], k, topo)
        else if (GRP[eB[r]] == ORD[i] && (GRP[eA[r]] in gnode)) c += FW[r] * hop(v, gnode[GRP[eA[r]]], k, topo)
      }
      if (bestc < 0 || c < bestc) { bestc = c; best = v }
    }
    gnode[ORD[i]] = best; taken[best] = 1
  }
  for (i = 1; i <= nr; i++) node[rn[i]] = gnode[GRP[rn[i]]]
  return cost_of(node, k, topo)
}

# bounded search over deterministic group orders; a single order is a guess
function place(gc, n, k, topo, node,    s, i, j, t, c, bc, cand) {
  bc = -1
  for (s = 0; s < 3 + ORDER_SHUFFLES; s++) {
    if (s == 0)      { for (i = 1; i <= gc; i++) ORD[i] = gw_desc[i] }
    else if (s == 1) { for (i = 1; i <= gc; i++) ORD[i] = gw_desc[gc + 1 - i] }
    else if (s == 2) { for (i = 1; i <= gc; i++) ORD[i] = gname[i] }
    else {
      for (i = 1; i <= gc; i++) ORD[i] = gw_desc[i]
      for (i = gc; i > 1; i--) { j = 1 + rnd(i); t = ORD[i]; ORD[i] = ORD[j]; ORD[j] = t }
    }
    c = lay(gc, n, k, topo, cand)
    if (bc < 0 || c < bc) { bc = c; for (i in node) delete node[i]; for (i in cand) node[i] = cand[i] }
  }
  return bc
}

function group_orders(gc,    i, j, t, x, gwt) {
  for (x in gwt) delete gwt[x]
  delete seen_g
  gc = 0
  for (i = 1; i <= nr; i++) {
    x = GRP[rn[i]]
    if (x in seen_g) continue
    seen_g[x] = 1; gc++; gname[gc] = x
  }
  for (i = 1; i <= gc; i++) for (j = i + 1; j <= gc; j++)
    if (gname[j] < gname[i]) { t = gname[i]; gname[i] = gname[j]; gname[j] = t }
  for (i = 1; i <= ne; i++) if (GRP[eA[i]] != GRP[eB[i]]) { gwt[GRP[eA[i]]] += W[i]; gwt[GRP[eB[i]]] += W[i] }
  for (i = 1; i <= gc; i++) gw_desc[i] = gname[i]
  for (i = 1; i <= gc; i++) for (j = i + 1; j <= gc; j++)
    if (gwt[gw_desc[j]] > gwt[gw_desc[i]]) { t = gw_desc[i]; gw_desc[i] = gw_desc[j]; gw_desc[j] = t }
  return gc
}

# the deterministic random baseline: every room lands on a node by chance, which is a
# coarsening and a placement chosen at once -- the same space of maps the computed layout
# searches, so the two are comparable
# the SIZE-MATCHED baseline: the computed layout is free to pile many rooms onto one node, and
# a node holding many rooms pays nothing for the traffic inside it -- so a baseline whose nodes
# hold one or two rooms apiece loses to it under ANY weights, including weights carrying no
# information at all. This baseline deals the rooms out at random into the SAME node-occupancy
# profile the computed layout produced, so the only thing left to compare is where the graph put
# them.
function sample_floor_matched(count, n, k, topo, out,    s, i, v, lo, tot, c, node, idx) {
  lo = -1; tot = 0
  for (s = 1; s <= count; s++) {
    for (i = 1; i <= nr; i++) node[rn[i]] = MSMP[s, i]
    c = cost_of(node, k, topo)
    tot += c
    if (lo < 0 || c < lo) lo = c
  }
  out["min"] = lo; out["mean"] = tot / count
}

function sample_floor(count, n, k, topo, out,    s, i, lo, tot, c, node) {
  lo = -1; tot = 0
  for (s = 1; s <= count; s++) {
    for (i = 1; i <= nr; i++) node[rn[i]] = SMP[s, i]
    c = cost_of(node, k, topo)
    tot += c
    if (lo < 0 || c < lo) lo = c
  }
  out["min"] = lo; out["mean"] = tot / count
}

BEGIN { nd = split(ladder, dl, " "); np_n = split(pladder, pl, " ") }

{ w = $1 + 0; a = $2; b = $4
  if (a > b) { t = a; a = b; b = t }
  key = a SUBSEP b
  if (!(key in seenpair)) { seenpair[key] = ++ne; eA[ne] = a; eB[ne] = b }
  W[seenpair[key]] += w
  room[a] = 1; room[b] = 1
}

END {
  ORDER_SHUFFLES = 24
  if (ne == 0) { print "reading4=unreadable"; exit }
  nr = 0
  for (r in room) { nr++; rn[nr] = r }
  for (i = 1; i <= nr; i++) for (j = i + 1; j <= nr; j++)
    if (rn[j] < rn[i]) { t = rn[i]; rn[i] = rn[j]; rn[j] = t }

  nactive = ne
  meanw = total_w() / ne
  printf "graph_rooms=%d graph_pairs=%d graph_weight=%d mean_pair_weight=%.3f\n", nr, ne, total_w(), meanw

  ng = split(grids, gl, " ")
  for (gi = 1; gi <= ng; gi++) {
    k = gl[gi] + 0
    n = k * k
    state = seed + k

    # one fixed sample set per grid, reused at every distortion so the comparison moves
    # only in the weights
    # a MATCHED baseline: the computed layout fills every node, so a baseline free to collapse
    # every room onto one node would win at cost zero and measure nothing. Each sample seats the
    # first n rooms of a shuffle one per node, then scatters the rest.
    for (s = 1; s <= samples; s++) {
      for (i = 1; i <= nr; i++) SHF[i] = i
      for (i = nr; i > 1; i--) { j = 1 + rnd(i); t = SHF[i]; SHF[i] = SHF[j]; SHF[j] = t }
      for (i = 1; i <= nr; i++) SMP[s, SHF[i]] = (i <= n) ? i - 1 : rnd(n)
    }

    for (e = 1; e <= ne; e++) FW[e] = W[e]
    gcount = coarsen(n, GRP)
    gc = group_orders()
    state = seed + k
    tcost = place(gc, n, k, "torus", TNODE)
    state = seed + k
    rcost = place(gc, n, k, "ring", RNODE)
    sample_floor(samples, n, k, "torus", FL)

    # the occupancy profile the computed layout produced, and the size-matched sample set
    for (v = 0; v < n; v++) occ[v] = 0
    for (i = 1; i <= nr; i++) occ[TNODE[rn[i]]]++
    biggest = 0; empty = 0
    for (v = 0; v < n; v++) { if (occ[v] > biggest) biggest = occ[v]; if (occ[v] == 0) empty++ }
    state = seed + k + 31
    for (s = 1; s <= samples; s++) {
      for (i = 1; i <= nr; i++) SHF[i] = i
      for (i = nr; i > 1; i--) { j = 1 + rnd(i); t = SHF[i]; SHF[i] = SHF[j]; SHF[j] = t }
      idx = 0
      for (v = 0; v < n; v++) for (q = 1; q <= occ[v]; q++) { idx++; MSMP[s, SHF[idx]] = v }
    }
    sample_floor_matched(samples, n, k, "torus", MFL)
    mgain = (MFL["mean"] > 0) ? (MFL["mean"] - tcost) / MFL["mean"] : 0

    gain = (FL["mean"] > 0) ? (FL["mean"] - tcost) / FL["mean"] : 0
    axis = (rcost > 0) ? (rcost - tcost) / rcost : 0
    printf "place k=%d nodes=%d groups=%d merges=%d\n", k, n, gc, merges
    printf "place k=%d torus_cost=%d random_min=%d random_mean=%.3f gain_share=%.6f beats_floor=%s\n",
      k, tcost, FL["min"], FL["mean"], gain, (tcost < FL["min"]) ? "yes" : "no"
    printf "place k=%d busiest_node_rooms=%d empty_nodes=%d\n", k, biggest, empty
    printf "place k=%d matched_min=%d matched_mean=%.3f matched_gain_share=%.6f beats_matched_floor=%s\n",
      k, MFL["min"], MFL["mean"], mgain, (tcost < MFL["min"]) ? "yes" : "no"
    printf "place k=%d ring_cost=%d second_axis_share=%.6f second_axis_pays=%s\n",
      k, rcost, axis, (tcost < rcost) ? "yes" : "no"
    merges = 0

    # ---- THE TWO WAYS A PROXY CAN BE WRONG -------------------------------------------------
    # The layout above is computed on the static import graph. A run-time weight would differ
    # from it in two independent ways, and only one of them is the one everybody names.
    #
    #   SCALE drift: the edges are the right edges and the numbers are wrong. Each weight is
    #   multiplied by a factor drawn uniformly from [1, R].
    #
    #   STRUCTURE drift: the edges themselves are wrong. With probability p a real import edge
    #   carries no run-time traffic at all (a module read once at startup), and the same count
    #   of room pairs with NO import edge carry traffic the static graph cannot see.
    #
    # Both sweeps cost the computed layout under the distorted weights and compare it against
    # the same matched baseline, also costed under those weights.
    if (k == distort_grid) {
      surv_scale = 0
      for (di = 1; di <= nd; di++) {
        R = dl[di] + 0
        tot = 0
        for (d = 1; d <= draws; d++) {
          state = seed + k + R * 7919 + d
          nactive = ne
          for (e = 1; e <= ne; e++) FW[e] = W[e] * (1 + uni() * (R - 1))
          c = cost_of(TNODE, k, "torus")
          sample_floor_matched(dsamples, n, k, "torus", FL2)
          tot += (FL2["mean"] > 0) ? (FL2["mean"] - c) / FL2["mean"] : 0
        }
        g = tot / draws
        ok = (g >= keep_share) ? "yes" : "no"
        printf "scale_drift k=%d factor=%d draws=%d mean_gain_share=%.6f still_worth=%s\n", k, R, draws, g, ok
        if (ok == "yes" && R > surv_scale) surv_scale = R
        if (di == 1) scale_first = g
        scale_last = g
      }
      printf "proxy_survives_scale_drift_upto=%d\n", surv_scale
      printf "scale_drift_bites=%s\n", ((scale_first - scale_last) >= keep_share) ? "yes" : "no"
      surv_struct = -1
      for (di = 1; di <= np_n; di++) {
        P = pl[di] + 0
        tot = 0
        for (d = 1; d <= draws; d++) {
          state = seed + k + P * 104729 + d
          nactive = ne
          kept = 0
          for (e = 1; e <= ne; e++) {
            if (uni() * 100 < P) FW[e] = 0; else { FW[e] = W[e]; kept++ }
          }
          # the same count of unseen pairs, carrying the graph's own mean weight
          phantoms = int(ne * P / 100 + 0.5)
          for (i = 1; i <= phantoms; i++) {
            a = rn[1 + rnd(nr)]; b = rn[1 + rnd(nr)]
            if (a == b) continue
            if (a > b) { t = a; a = b; b = t }
            if ((a SUBSEP b) in seenpair) continue
            nactive++
            eA[nactive] = a; eB[nactive] = b; FW[nactive] = meanw
          }
          c = cost_of(TNODE, k, "torus")
          sample_floor_matched(dsamples, n, k, "torus", FL2)
          tot += (FL2["mean"] > 0) ? (FL2["mean"] - c) / FL2["mean"] : 0
        }
        g = tot / draws
        ok = (g >= keep_share) ? "yes" : "no"
        printf "structure_drift k=%d pct=%d draws=%d mean_gain_share=%.6f still_worth=%s\n", k, P, draws, g, ok
        if (ok == "yes" && P > surv_struct) surv_struct = P
        if (di == 1) struct_first = g
        struct_last = g
      }
      printf "proxy_survives_structure_drift_upto_pct=%d\n", surv_struct
      # THE FINDING, as two verdicts a guard can hold: scaling the weights costs the layout
      # nothing, and moving the edges costs it everything. Both are read from the same sweep.
      printf "structure_drift_bites=%s\n", ((struct_first - struct_last) >= keep_share) ? "yes" : "no"
      printf "proxy_keep_share=%.2f\n", keep_share
      nactive = ne
    }
    for (e = 1; e <= ne; e++) FW[e] = W[e]
  }
  print "reading4=read"
}

function total_w(   e, s) { for (e = 1; e <= ne; e++) s += W[e]; return s }
AWKBODY
  awk -v grids="2 4" -v samples="$SAMPLES" -v dsamples="$DSAMPLES" -v draws="$DRAWS" \
      -v seed="$LCG_SEED" -v distort_grid=4 -v keep_share="$KEEP_SHARE" \
      -v ladder="$SCALE_LADDER" -v pladder="$DRIFT_LADDER" \
      -f "$work/reading4.awk" "$work/edges.txt"
fi

echo "verdict=read"
