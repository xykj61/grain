#!/bin/sh
# tools/fixtures/a/aurora_placement_scan.sh -- CAN ROW 7 BE PLACED? Row 7 of
# active-designing/20260910-060204_the-bounded-torus-moonshots.md proposes Aurora on a 4-core or
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
echo "page=active-designing/20260910-060204_the-bounded-torus-moonshots.md"
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

echo "verdict=read"
