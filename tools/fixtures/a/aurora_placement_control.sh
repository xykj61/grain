#!/bin/sh
# tools/fixtures/a/aurora_placement_control.sh -- the pen for aurora_placement_scan.sh.
#
# Two populations, proven apart. The GEOMETRY half is arithmetic and opens no file, so its legs
# assert closed forms a reader can check by hand: a k x k mesh has diameter 2(k-1), a k x k torus
# 2*floor(k/2), and at k = 2 the two are one graph because the wrap link duplicates the mesh link.
# The OPERAND half reads the tree, so its legs run the scan inside a real git repository built in
# a throwaway pen -- two rooms, a cross-room import SYMLINK, and a session log carrying loom keys
# -- where every count is known in advance.
#
# Four mutations are planted and each is asserted to bite, because a refusal proven only in the
# passing direction cannot be told from a bypass.
set -u

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
SCAN="$ROOT/tools/fixtures/a/aurora_placement_scan.sh"
legs=0
fails=0

PEN=$(mktemp -d "${TMPDIR:-/tmp}/aurora-placement-control.XXXXXX") || exit 1
cleanup() { [ -n "${PEN:-}" ] && [ -d "$PEN" ] && rm -rf "$PEN"; }
trap cleanup EXIT INT TERM HUP

leg() {
  name=$1; want=$2; got=$3
  legs=$((legs + 1))
  if [ "$want" = "$got" ]; then
    echo "leg $name ok"
  else
    fails=$((fails + 1))
    echo "leg $name FAILED want=$want got=$got"
  fi
}

key() { printf '%s\n' "$1" | grep -m1 "^$2=" | cut -d= -f2-; }
gridkey() { printf '%s\n' "$1" | grep -m1 "^grid k=$2 " | tr ' ' '\n' | grep -m1 "^$3=" | cut -d= -f2-; }

# ---- the scan stands -------------------------------------------------------------------------
[ -f "$SCAN" ] && leg scan_present yes yes || leg scan_present yes no
[ -x "$SCAN" ] && leg scan_executable yes yes || leg scan_executable yes no

OUT=$(sh "$SCAN" 2>&1)
status=$?
leg scan_exits_zero 0 "$status"
leg verdict_read read "$(key "$OUT" verdict)"
leg names_its_row 7 "$(key "$OUT" row)"

# ---- the geometry, against closed forms -------------------------------------------------------
leg four_core_same_graph yes "$(key "$OUT" four_core_same_graph)"
leg four_core_falsifier_silent no "$(key "$OUT" four_core_falsifier_can_fire)"
leg sixteen_core_falsifier_fires yes "$(key "$OUT" sixteen_core_falsifier_can_fire)"
leg sixteen_core_diameter_cut 2 "$(key "$OUT" sixteen_core_diameter_cut)"
leg sixteen_core_mean_cut 0.2000 "$(key "$OUT" sixteen_core_mean_cut_share)"

leg k2_torus_diameter 2 "$(gridkey "$OUT" 2 torus_diameter)"
leg k2_mesh_diameter 2 "$(gridkey "$OUT" 2 mesh_diameter)"
leg k2_links_equal "$(gridkey "$OUT" 2 mesh_links)" "$(gridkey "$OUT" 2 torus_links)"
leg k4_torus_diameter 4 "$(gridkey "$OUT" 4 torus_diameter)"
leg k4_mesh_diameter 6 "$(gridkey "$OUT" 4 mesh_diameter)"
leg k4_torus_links 32 "$(gridkey "$OUT" 4 torus_links)"
leg k4_mesh_links 24 "$(gridkey "$OUT" 4 mesh_links)"
leg k8_torus_diameter 8 "$(gridkey "$OUT" 8 torus_diameter)"
leg k8_mesh_diameter 14 "$(gridkey "$OUT" 8 mesh_diameter)"
leg k3_falsifier_fires yes "$(gridkey "$OUT" 3 falsifier_can_fire)"
leg grids_graded 4 "$(key "$OUT" grids_graded)"
leg grids_within_bound 0 "$(key "$OUT" grids_over_bound)"

# ---- the bounds are named --------------------------------------------------------------------
for b in max_grids max_rooms max_imports max_keys; do
  v=$(key "$OUT" "$b")
  case "$v" in
    ''|*[!0-9]*) leg "bound_named_$b" number "$v" ;;
    *) leg "bound_named_$b" number number ;;
  esac
done

# ---- the operand, read on this tree ------------------------------------------------------------
rooms=$(key "$OUT" rooms)
pairs=$(key "$OUT" room_pairs)
edges=$(key "$OUT" room_edges)
sites=$(key "$OUT" import_sites)
keys=$(key "$OUT" loom_keys)
[ "$rooms" -ge 2 ] 2>/dev/null && leg rooms_counted yes yes || leg rooms_counted yes no
[ "$sites" -ge 1 ] 2>/dev/null && leg imports_read yes yes || leg imports_read yes no
[ "$pairs" -ge 1 ] 2>/dev/null && leg room_pairs_found yes yes || leg room_pairs_found yes no
[ "$edges" -ge "$pairs" ] 2>/dev/null && leg edges_at_least_pairs yes yes || leg edges_at_least_pairs yes no
[ "$keys" -ge 1 ] 2>/dev/null && leg loom_keys_read yes yes || leg loom_keys_read yes no
leg rooms_within_bound no "$(key "$OUT" rooms_over_bound)"
leg coarsening_at_four needed "$(printf '%s\n' "$OUT" | grep -m1 '^coarsening_needed k=2 ' | sed 's/.*verdict=//')"
leg coarsening_at_sixteen needed "$(printf '%s\n' "$OUT" | grep -m1 '^coarsening_needed k=4 ' | sed 's/.*verdict=//')"

# ---- the pen: a tree whose counts are known in advance -----------------------------------------
mkdir -p "$PEN/tree/alpha" "$PEN/tree/beta" "$PEN/tree/mand" "$PEN/tree/session-logs/date/20260101"
cd "$PEN/tree" || exit 1
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
printf 'const std = @import("std");\nconst shared = @import("shared.rye");\n' > alpha/main.rye
printf 'const std = @import("std");\nconst near = @import("near.rye");\n' > alpha/second.rye
printf 'const std = @import("std");\n' > alpha/near.rye
printf 'const std = @import("std");\n' > beta/shared.rye
printf 'const std = @import("std");\n' > mand/only.rye
ln -s ../beta/shared.rye alpha/shared.rye
# alpha_calls names one room; alpha_beta_hops names two; mandate_rows names NONE, since
# `mand` is a segment of no key here and substring matching would wrongly claim it
printf 'format session-log-v1\nloom alpha_calls=3 alpha_beta_hops=7\nloom mandate_rows=2\n' \
  > session-logs/date/20260101/20260101-000000_pen.kyri
git add -A >/dev/null 2>&1
git commit -q -m "pen: one cross-room symlink" >/dev/null 2>&1

PENOUT=$(sh "$SCAN" 2>&1)
leg pen_verdict read "$(key "$PENOUT" verdict)"
leg pen_rooms 3 "$(key "$PENOUT" rooms)"
leg pen_rye_sources 6 "$(key "$PENOUT" rye_sources)"
leg pen_import_sites 2 "$(key "$PENOUT" import_sites)"
leg pen_room_pairs 1 "$(key "$PENOUT" room_pairs)"
leg pen_room_edges 1 "$(key "$PENOUT" room_edges)"
leg pen_geometry_unmoved yes "$(key "$PENOUT" four_core_same_graph)"
leg pen_coarsening_free free "$(printf '%s\n' "$PENOUT" | grep -m1 '^coarsening_needed k=2 ' | sed 's/.*verdict=//')"
# proven by INPUT rather than by a mutation: `mandate_rows` holds `mand` as a substring and as
# no segment, so a reader matching substrings would count three keys where three rooms stand
leg pen_keys_naming_a_room 2 "$(key "$PENOUT" loom_keys_naming_a_room)"
leg pen_keys_naming_two_rooms 1 "$(key "$PENOUT" loom_keys_naming_two_rooms)"
leg pen_substring_room_refused yes "$(printf '%s\n' "$PENOUT" | grep -q '^pair_key mandate_rows' && echo no || echo yes)"
leg pen_weight_named_only named_only "$(key "$PENOUT" weight_operand)"

# ---- mutation 1: the wrap-duplicate collapse removed ------------------------------------------
M1="$PEN/m1.sh"
sed 's/if (k == 2) tlinks = mlinks; else tlinks = 2 \* k \* k/tlinks = 2 * k * k/' "$SCAN" > "$M1"
if cmp -s "$SCAN" "$M1"; then leg m1_planted yes no; else leg m1_planted yes yes; fi
M1OUT=$(sh "$M1" 2>&1)
if [ "$(key "$M1OUT" four_core_same_graph)" = yes ]; then leg m1_bites yes no; else leg m1_bites yes yes; fi

# ---- mutation 2: cyclic distance replaced by plain distance ------------------------------------
M2="$PEN/m2.sh"
sed 's/wx = k - dx; if (wx < dx) tdx = wx; else tdx = dx/tdx = dx/; s/wy = k - dy; if (wy < dy) tdy = wy; else tdy = dy/tdy = dy/' "$SCAN" > "$M2"
if cmp -s "$SCAN" "$M2"; then leg m2_planted yes no; else leg m2_planted yes yes; fi
M2OUT=$(sh "$M2" 2>&1)
if [ "$(gridkey "$M2OUT" 4 torus_mean)" = "$(gridkey "$M2OUT" 4 mesh_mean)" ]; then leg m2_bites yes yes; else leg m2_bites yes no; fi

# ---- mutation 3: symlinks left unfollowed ------------------------------------------------------
M3="$PEN/m3.sh"
sed 's/  if \[ -L "\$path" \]; then/  if false; then/' "$SCAN" > "$M3"
if cmp -s "$SCAN" "$M3"; then leg m3_planted yes no; else leg m3_planted yes yes; fi
M3OUT=$(sh "$M3" 2>&1)
if [ "$(key "$M3OUT" room_pairs)" -ge 1 ] 2>/dev/null; then leg m3_bites yes no; else leg m3_bites yes yes; fi

# ---- mutation 4: the self-edge guard removed ---------------------------------------------------
M4="$PEN/m4.sh"
sed 's/  \[ "\$troom" = "\$room" \] && continue/  :/' "$SCAN" > "$M4"
if cmp -s "$SCAN" "$M4"; then leg m4_planted yes no; else leg m4_planted yes yes; fi
M4OUT=$(sh "$M4" 2>&1)
base_pairs=$(key "$PENOUT" room_pairs)   # every mutation runs in the pen, so the baseline is the pen
mut_pairs=$(key "$M4OUT" room_pairs)
if [ "$mut_pairs" -gt "$base_pairs" ] 2>/dev/null; then leg m4_bites yes yes; else leg m4_bites yes no; fi

# ---- the second pen: a graph with more rooms than nodes ----------------------------------------
# The pen above proves the operand readings against counts known in advance, and it deliberately
# holds two rooms in its graph. A PLACEMENT needs more rooms than nodes, or the coarsening under
# test never runs, so reading 4 gets a pen of its own: six rooms and five weighted pairs, laid so
# that the right answer is computable by hand.
#
#   alpha -b- beta weight 3, beta -c- gamma 2, alpha -g- gamma 1, delta -e- epsilon 2,
#   epsilon -z- zeta 1.
#
# Heavy-edge merging at four nodes joins alpha+beta first (3), then gamma into them (2 + 1 = 3),
# leaving four groups after TWO merges with three rooms on the busiest node. The two edges left
# crossing a node boundary are delta-epsilon at 2 and epsilon-zeta at 1, and a 2 x 2 torus seats
# epsilon next to both, so the cost is exactly 3.
#
# A weight is a count of DISTINCT import names, since the scan reads each (room, path) site once --
# so three files importing one name make one edge, and the pen files three names.
mkdir -p "$PEN/tree2"
cd "$PEN/tree2" || exit 1
for r in alpha beta gamma delta epsilon zeta; do
  mkdir -p "$r"
  printf 'const std = @import("std");\n' > "$r/own.rye"
done
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
pen_edge() {   # importer target count prefix
  imp=$1; tgt=$2; cnt=$3; pre=$4; i=1
  while [ "$i" -le "$cnt" ]; do
    printf 'const std = @import("std");\nconst x = @import("%s%s.rye");\n' "$pre" "$i" > "$imp/src$pre$i.rye"
    ln -s "../$tgt/own.rye" "$imp/$pre$i.rye"
    i=$((i + 1))
  done
}
pen_edge alpha beta 3 b
pen_edge beta gamma 2 c
pen_edge alpha gamma 1 g
pen_edge delta epsilon 2 e
pen_edge epsilon zeta 1 z
git add -A >/dev/null 2>&1
git commit -q -m "pen: six rooms, five weighted pairs" >/dev/null 2>&1

P2=$(sh "$SCAN" 2>&1)
placekey() { printf '%s\n' "$1" | grep -m1 "^place k=$2 .*$3=" | tr ' ' '\n' | grep -m1 "^$3=" | cut -d= -f2-; }
capkey() { printf '%s\n' "$1" | grep -m1 "^capacity k=$2 " | tr ' ' '\n' | grep -m1 "^$3=" | cut -d= -f2-; }

leg pen2_reading4 read "$(key "$P2" reading4)"
leg pen2_graph_rooms 6 "$(printf '%s\n' "$P2" | grep -m1 '^graph_rooms=' | tr ' ' '\n' | grep -m1 '^graph_rooms=' | cut -d= -f2)"
leg pen2_graph_pairs 5 "$(printf '%s\n' "$P2" | grep -m1 '^graph_rooms=' | tr ' ' '\n' | grep -m1 '^graph_pairs=' | cut -d= -f2)"
leg pen2_graph_weight 9 "$(printf '%s\n' "$P2" | grep -m1 '^graph_rooms=' | tr ' ' '\n' | grep -m1 '^graph_weight=' | cut -d= -f2)"
leg pen2_groups_at_four 4 "$(placekey "$P2" 2 groups)"
leg pen2_merges_at_four 2 "$(placekey "$P2" 2 merges)"
leg pen2_busiest_node 3 "$(placekey "$P2" 2 busiest_node_rooms)"
leg pen2_torus_cost_by_hand 3 "$(placekey "$P2" 2 torus_cost)"
leg pen2_no_merge_at_sixteen 0 "$(placekey "$P2" 4 merges)"
leg pen2_groups_at_sixteen 6 "$(placekey "$P2" 4 groups)"

# the capacity term, on a pen whose largest room is known
leg pen2_largest_room alpha "$(key "$P2" largest_room)"
leg pen2_room_granularity infeasible "$(capkey "$P2" 4 room_granularity)"

# the finding, as two verdicts: scaling the weights costs the layout nothing, moving the edges
# costs it everything
leg pen2_scale_drift_silent no "$(key "$P2" scale_drift_bites)"
leg pen2_structure_drift_bites yes "$(key "$P2" structure_drift_bites)"

# ---- mutation 5: the size reading counts symlinks -----------------------------------------------
# A cross-room `.rye` symlink is an import EDGE, and `wc -c` follows it -- so counting one bills
# the importing room for the imported room's bytes, and the capacity reading measures the graph
# twice instead of the code once.
M5="$PEN/m5.sh"
sed 's/\$1 != "120000"/1/' "$SCAN" > "$M5"
if cmp -s "$SCAN" "$M5"; then leg m5_planted yes no; else leg m5_planted yes yes; fi
M5OUT=$(sh "$M5" 2>&1)
if [ "$(key "$M5OUT" room_bytes_total)" = "$(key "$P2" room_bytes_total)" ]; then
  leg m5_bites yes no
else
  leg m5_bites yes yes
fi

# ---- mutation 6: the baseline stops matching the occupancy profile -------------------------------
# A node holding many rooms pays nothing for the traffic inside it, so a layout free to pile rooms
# up beats a spread baseline under ANY weights. Dealing the baseline into the computed layout's own
# occupancy profile is what leaves the graph as the only thing being compared.
M6="$PEN/m6.sh"
sed 's/MSMP\[s, SHF\[idx\]\] = v/MSMP[s, SHF[idx]] = rnd(n)/' "$SCAN" > "$M6"
if cmp -s "$SCAN" "$M6"; then leg m6_planted yes no; else leg m6_planted yes yes; fi
M6OUT=$(sh "$M6" 2>&1)
if [ "$(placekey "$M6OUT" 2 matched_gain_share)" = "$(placekey "$P2" 2 matched_gain_share)" ]; then
  leg m6_bites yes no
else
  leg m6_bites yes yes
fi

# ---- the empty population, refused rather than called feasible ---------------------------------
# A tree carrying no Rye fits every node trivially, and a verdict unable to tell that from a real
# fit teaches nothing -- so both granularity readings answer `unread`, and the placement refuses.
mkdir -p "$PEN/tree3"
cd "$PEN/tree3" || exit 1
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
printf 'a tree with no Rye in it\n' > README.md
git add -A >/dev/null 2>&1
git commit -q -m "pen: no Rye at all" >/dev/null 2>&1
P3=$(sh "$SCAN" 2>&1)
leg pen3_capacity_unread unread "$(capkey "$P3" 4 room_granularity)"
leg pen3_file_granularity_unread unread "$(capkey "$P3" 4 file_granularity)"
leg pen3_reading4_refuses unreadable "$(key "$P3" reading4)"

cd "$ROOT" || exit 1
echo "legs=$legs"
echo "failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
