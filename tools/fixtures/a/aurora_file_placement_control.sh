#!/bin/sh
# tools/fixtures/a/aurora_file_placement_control.sh -- the pen for aurora_file_placement_scan.sh.
#
# Every reading in that scan is taken on a tree, so every leg here runs it inside a real git
# repository built in a throwaway pen where the counts are known before the scan is asked.
#
# TWO PENS, because the two halves of the unit question want opposite trees. PEN ONE holds one
# file too large for any node's equal share, so the capacity reading answers `no` and is proven
# from the refusing side; it also holds a cross-room import SYMLINK, a self-import, an import
# naming a file that is not there, and a MUTUAL pair -- each a way an edge list goes wrong.
# PEN TWO holds thirty-two even files in four tight rooms, so the unit fits at every grid and a
# placement that consults the graph has something to find.
#
# Eight mutations are planted and each is asserted to bite, because a refusal proven only in the
# passing direction cannot be told from a bypass. Each is preceded by `cmp` proving the edit
# changed a byte, since a sed that matched nothing leaves a mutation that passes for free.
#
# THE DRIFT SWEEP IS PROVEN BY DISAGREEMENT AS WELL AS BY MUTATION. Its straight-line verdict reads
# `yes` on this tree's ~7,500 edges and `no` on pen two's 32, so the reading is a property of the
# graph handed to it rather than a constant it prints. That pair is worth more than either alone.
set -u

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
SCAN="$ROOT/tools/fixtures/a/aurora_file_placement_scan.sh"
legs=0
fails=0

PEN=$(mktemp -d "${TMPDIR:-/tmp}/aurora-file-placement-control.XXXXXX") || exit 1
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

# a key may share a line with its siblings, so the reading is tokenized on whitespace first and
# the whole key is matched, never a prefix of one
key() { printf '%s\n' "$1" | tr ' ' '\n' | grep -m1 "^$2=" | cut -d= -f2-; }
inline() { printf '%s\n' "$1" | tr ' ' '\n' | grep -m1 "^$2=" | cut -d= -f2-; }
# a grid prints several lines under one prefix, so the wanted key picks the line as well
gridline() { printf '%s\n' "$1" | grep "^$2 k=$3 " | grep -m1 " $4="; }

# ---- the scan stands ---------------------------------------------------------------------------
[ -f "$SCAN" ] && leg scan_present yes yes || leg scan_present yes no
[ -x "$SCAN" ] && leg scan_executable yes yes || leg scan_executable yes no

OUT=$(sh "$SCAN" 2>&1)
status=$?
leg scan_exits_zero 0 "$status"
leg verdict_read read "$(key "$OUT" verdict)"
leg names_its_row 7 "$(key "$OUT" row)"
leg names_the_page_it_answers \
  active-designing/20260916-095958_the-two-ways-a-proxy-drifts.md "$(key "$OUT" answers)"

# ---- the bounds are named ----------------------------------------------------------------------
for b in max_files max_edges max_grids max_samples cap_slack_pct; do
  v=$(key "$OUT" "$b")
  case "$v" in
    ''|*[!0-9]*) leg "bound_named_$b" number "$v" ;;
    *) leg "bound_named_$b" number number ;;
  esac
done

# ---- this tree, read as a live reading ---------------------------------------------------------
files=$(key "$OUT" rye_files)
edges=$(key "$OUT" import_edges)
[ "$files" -ge 2 ] 2>/dev/null && leg tree_files_read yes yes || leg tree_files_read yes no
[ "$edges" -ge 1 ] 2>/dev/null && leg tree_edges_read yes yes || leg tree_edges_read yes no
leg tree_files_within_bound "" "$(key "$OUT" files_over_bound)"
leg tree_edges_within_bound "" "$(key "$OUT" edges_over_bound)"
leg tree_reading3_read read "$(key "$OUT" reading3)"
leg tree_reading4_read read "$(key "$OUT" reading4)"
# the straight-line reading on THIS tree, where ~7,500 edges average. The same key reads `no` on
# the 32-edge pen below, which is what proves it a measurement of the graph rather than a constant.
leg tree_drift_linear yes "$(key "$OUT" drift_decay_linear)"

# ---- READING 5 on this tree: the ladder graded, the shape fitted, the re-seat proven ------------
leg tree_reading5_read read "$(key "$OUT" reading5)"
# the full rung is every edge, so the layout it seats must cost exactly what reading 3 computed.
# Without this the rungs below could be measuring a layout the scan never produced.
leg tree_size_reseat_matches yes "$(key "$OUT" size_full_rung_matches_placement)"
leg tree_size_scales_inverse_sqrt yes "$(key "$OUT" drift_scatter_scales_as_inverse_sqrt)"
leg tree_size_slope_near_half yes "$(key "$OUT" drift_scatter_slope_near_half)"
treerungs=$(key "$OUT" size_rungs_graded)
if [ "$treerungs" -ge 4 ] 2>/dev/null; then leg tree_size_rungs_graded yes yes; else leg tree_size_rungs_graded yes no; fi
# the fitted slope is the anchor-free reading, and it must be NEGATIVE: a departure that grew with
# the graph would be the opposite of an average's scatter
treeslope=$(key "$OUT" drift_scatter_loglog_slope)
case "$treeslope" in -*) leg tree_size_slope_negative yes yes ;; *) leg tree_size_slope_negative yes no ;; esac
# the crossing is measured from the bracketing rungs rather than extrapolated from the anchor, and
# the two are printed apart so a reader can see how much the anchor carries
treemc=$(key "$OUT" drift_linearity_measured_crossing_edges)
if awk -v c="$treemc" 'BEGIN { exit !(c > 0) }' 2>/dev/null; then leg tree_size_crossing_measured yes yes; else leg tree_size_crossing_measured yes no; fi
leg tree_size_anchor_pair_named yes "$(printf '%s\n' "$OUT" | grep -q '^drift_scatter_anchor_full=' && echo yes || echo no)"

# ---- PEN ONE: every way an edge list goes wrong, and a file too big for a node ------------------
mkdir -p "$PEN/one/alpha" "$PEN/one/beta" "$PEN/one/gamma"
cd "$PEN/one" || exit 1
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
# a1 imports: a2 (intra), shared through a symlink (cross), a1 itself (dropped), and a name that
# is not there (dropped). a2 imports a1, which is the SAME adjacency as a1 -> a2.
printf 'const a2 = @import("a2.rye");\nconst sh = @import("shared.rye");\nconst me = @import("a1.rye");\nconst no = @import("missing.rye");\n' > alpha/a1.rye
printf 'const a1 = @import("a1.rye");\n' > alpha/a2.rye
printf 'const std = @import("std");\n' > beta/shared.rye
ln -s ../beta/shared.rye alpha/shared.rye
# one file larger than a quarter of the tree, so no grid's equal share can hold it
awk 'BEGIN { printf "// "; for (i = 0; i < 4000; i++) printf "x"; printf "\n" }' > gamma/big.rye
git add -A >/dev/null 2>&1
git commit -q -m "pen one: a big file and four broken edges" >/dev/null 2>&1

P1=$(sh "$SCAN" 2>&1)
leg p1_verdict read "$(key "$P1" verdict)"
leg p1_files 4 "$(key "$P1" rye_files)"
leg p1_symlinks 1 "$(key "$P1" rye_symlinks)"
leg p1_edges 2 "$(key "$P1" import_edges)"
leg p1_importing_files 1 "$(key "$P1" importing_files)"
leg p1_endpoint_files 3 "$(key "$P1" endpoint_files)"
leg p1_intra_edges 1 "$(key "$P1" intra_room_edges)"
leg p1_cross_edges 1 "$(key "$P1" cross_room_edges)"
leg p1_intra_share 0.500000 "$(key "$P1" intra_room_edge_share)"
leg p1_room_pairs 1 "$(key "$P1" room_pairs_with_an_edge)"
leg p1_graph_rooms 2 "$(key "$P1" graph_rooms)"
leg p1_rooms 3 "$(key "$P1" rooms)"
leg p1_largest_file gamma/big.rye "$(key "$P1" largest_file)"
# the capacity reading, from the refusing side
leg p1_fit_k2_no no "$(inline "$(gridline "$P1" fit 2 file_fits)" file_fits)"
leg p1_fits_sixteen_no no "$(key "$P1" unit_fits_sixteen)"
leg p1_ceiling_zero 0 "$(key "$P1" unit_ceiling_nodes)"
leg p1_first_overflow_four 4 "$(key "$P1" first_overflowing_nodes)"
# a node must still be able to hold the largest file, or the packer cannot place it at all
leg p1_no_infeasible 0 "$(inline "$(gridline "$P1" place 2 infeasible_files)" infeasible_files)"

# ---- PEN TWO: the unit fits, and the graph has something to find --------------------------------
mkdir -p "$PEN/two"
cd "$PEN/two" || exit 1
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
for r in alpha beta gamma delta; do
  mkdir -p "$r"
  i=0
  while [ "$i" -lt 8 ]; do
    j=$(( (i + 1) % 8 ))
    printf 'const nxt = @import("f%s.rye");\n// %s\n' "$j" "$r" > "$r/f$i.rye"
    i=$((i + 1))
  done
done
git add -A >/dev/null 2>&1
git commit -q -m "pen two: four tight rings" >/dev/null 2>&1

P2=$(sh "$SCAN" 2>&1)
leg p2_verdict read "$(key "$P2" verdict)"
leg p2_files 32 "$(key "$P2" rye_files)"
leg p2_symlinks 0 "$(key "$P2" rye_symlinks)"
leg p2_edges 32 "$(key "$P2" import_edges)"
leg p2_all_intra 32 "$(key "$P2" intra_room_edges)"
leg p2_no_cross 0 "$(key "$P2" cross_room_edges)"
leg p2_intra_share 1.000000 "$(key "$P2" intra_room_edge_share)"
leg p2_no_room_pairs 0 "$(key "$P2" room_pairs_with_an_edge)"
leg p2_fits_sixteen yes "$(key "$P2" unit_fits_sixteen)"
# four rooms of eight even files: a room is a quarter of the tree and a node's share a
# sixteenth, so the MODULE unit overflows here exactly as it does on the real tree
leg p2_modules_overflow_sixteen yes "$(key "$P2" module_unit_overflows_sixteen)"
leg p2_rooms_over_share 4 "$(key "$P2" rooms_over_share_sixteen)"
leg p2_k4_infeasible 0 "$(inline "$(gridline "$P2" place 4 infeasible_files)" infeasible_files)"
# four rings of eight on four nodes: the graph is findable, so the layout must beat both floors
leg p2_beats_floor yes "$(inline "$(gridline "$P2" place 2 beats_floor)" beats_floor)"
p2gain=$(key "$P2" sixteen_gain_share)
p2mgain=$(key "$P2" sixteen_matched_gain_share)
case "$p2gain" in -*) leg p2_gain_positive yes no ;; *) leg p2_gain_positive yes yes ;; esac
case "$p2mgain" in -*) leg p2_matched_gain_positive yes no ;; *) leg p2_matched_gain_positive yes yes ;; esac
# the same tree read twice gives the same layout. The ordering rule is degree descending with the
# file name breaking every tie, so the reading is a property of the tree rather than of the order
# `git ls-files` happened to hand back -- a thing easy to assume and cheap to check.
P2B=$(sh "$SCAN" 2>&1)
if [ "$P2" = "$P2B" ]; then leg p2_reading_repeats yes yes; else leg p2_reading_repeats yes no; fi
# ---- PEN TWO, READING 4: the sweep on a graph small enough to be noisy -------------------------
leg p2_reading4_read read "$(key "$P2" reading4)"
leg p2_drift_bites yes "$(key "$P2" file_structure_drift_bites)"
leg p2_drift_grid 16 "$(key "$P2" drift_grid_nodes)"
# the same key that reads `yes` on this tree reads `no` here, on 32 edges rather than ~7,500. A
# straight-line verdict that never says no would be a constant wearing a measurement's clothes.
leg p2_drift_not_linear no "$(key "$P2" drift_decay_linear)"
# the undistorted rung must reproduce the placement the scan already computed, or every rung after
# it is costing a layout nobody asked about. Compared with a tolerance rather than for equality,
# since the two draw their floors from different points of the same generator.
p2z=$(key "$P2" drift_undistorted_gain_share)
p2m=$(key "$P2" sixteen_matched_gain_share)
p2agree=$(awk -v a="$p2z" -v b="$p2m" 'BEGIN { d = a - b; if (d < 0) d = -d; print (d <= 0.02) ? "yes" : "no" }')
leg p2_drift_zero_matches_placement yes "$p2agree"
# the crossing is reported at finer resolution than the ladder, so it must be a real number rather
# than the -1 the scan prints when no rung pair brackets the threshold
p2c=$(key "$P2" file_drift_crossing_pct)
case "$p2c" in ''|-*) leg p2_crossing_bracketed yes no ;; *) leg p2_crossing_bracketed yes yes ;; esac
# ---- PEN TWO, READING 5: a graph under the ladder grades nothing, and SAYS so -------------------
# Every rung of the size ladder stands at or above this pen's whole edge count, so there is nothing
# to subsample. The verdict must read `ungraded` rather than `no`: a reading that says no when it
# means it could not look is a finding nobody made.
leg p2_size_ungraded ungraded "$(key "$P2" drift_scatter_scales_as_inverse_sqrt)"
leg p2_size_slope_ungraded ungraded "$(key "$P2" drift_scatter_slope_near_half)"
leg p2_size_rungs_zero 0 "$(key "$P2" size_rungs_graded)"
# and the full rung still runs on a 32-edge graph, so the re-seat proof holds at both ends of the
# size range this scan ever sees
leg p2_size_reseat_matches yes "$(key "$P2" size_full_rung_matches_placement)"
leg p2_reading5_read read "$(key "$P2" reading5)"

leg p2_free_traffic_named yes "$(printf '%s\n' "$P2" | grep -q '^room_layout_same_node_share=' && echo yes || echo no)"

# ---- PEN FOUR: a graph whose placement actually COSTS something ---------------------------------
# Pen two's four rings each sit whole on one node, so its layout costs zero and any two orderings
# of it cost zero alike -- which makes it useless for proving reading 5's re-seat check bites. This
# pen is a single chain across files large enough that capacity spreads them, so the layout pays
# real hops and a wrong re-seat reads a different number.
mkdir -p "$PEN/four"
cd "$PEN/four" || exit 1
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
mkdir -p chain
i=0
while [ "$i" -lt 16 ]; do
  j=$((i + 1))
  if [ "$j" -lt 16 ]; then
    printf 'const nxt = @import("f%s.rye");\n' "$j" > "chain/f$i.rye"
  else
    printf 'const std = @import("std");\n' > "chain/f$i.rye"
  fi
  # padding, so the equal share cannot hold many files and the packer must spread the chain
  k=0
  while [ "$k" -lt 40 ]; do printf '// pad %s\n' "$k" >> "chain/f$i.rye"; k=$((k + 1)); done
  i=$((i + 1))
done
git add -A >/dev/null 2>&1
git commit -q -m "pen four: one chain, spread by capacity" >/dev/null 2>&1

P4=$(sh "$SCAN" 2>&1)
leg p4_verdict read "$(key "$P4" verdict)"
leg p4_edges 15 "$(key "$P4" import_edges)"
leg p4_reading5_read read "$(key "$P4" reading5)"
leg p4_size_reseat_matches yes "$(key "$P4" size_full_rung_matches_placement)"
# the check can only bite where the layout costs something, so the pen's own cost is asserted
# positive before the plant below is read as proof of anything
p4cost=$(key "$P4" size_full_rung_cost)
if [ "$p4cost" -gt 0 ] 2>/dev/null; then leg p4_cost_positive yes yes; else leg p4_cost_positive yes no; fi

# ---- the empty tree refuses rather than reading zero --------------------------------------------
mkdir -p "$PEN/three"
cd "$PEN/three" || exit 1
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
printf 'nothing\n' > README.md
git add -A >/dev/null 2>&1
git commit -q -m "pen three: no Rye at all" >/dev/null 2>&1
P3=$(sh "$SCAN" 2>&1)
leg p3_empty_verdict empty "$(key "$P3" verdict)"
leg p3_files_zero 0 "$(key "$P3" rye_files)"
leg p3_reading1_unreadable unreadable "$(key "$P3" reading1)"

# ---- the mutations, each planted in pen one or two and asserted to bite --------------------------
cd "$PEN/one" || exit 1

# m1: the symlink map never consulted -- a cross-room import stops resolving
M1="$PEN/m1.sh"
sed 's/    if (tgt in link) tgt = link\[tgt\]/    if (0) tgt = link[tgt]/' "$SCAN" > "$M1"
if cmp -s "$SCAN" "$M1"; then leg m1_planted yes no; else leg m1_planted yes yes; fi
M1OUT=$(sh "$M1" 2>&1)
leg m1_bites 0 "$(key "$M1OUT" cross_room_edges)"

# m2: the self-import guard removed -- a file importing itself becomes an edge
M2="$PEN/m2.sh"
sed 's/    if (tgt == src) next/    if (0) next/' "$SCAN" > "$M2"
if cmp -s "$SCAN" "$M2"; then leg m2_planted yes no; else leg m2_planted yes yes; fi
M2OUT=$(sh "$M2" 2>&1)
m2e=$(key "$M2OUT" import_edges)
if [ "$m2e" -gt 2 ] 2>/dev/null; then leg m2_bites yes yes; else leg m2_bites yes no; fi

# m3: the unordered key sorted no longer -- a mutual import is priced twice
M3="$PEN/m3.sh"
sed 's/    if (src < tgt) key = src SUBSEP tgt; else key = tgt SUBSEP src/    key = src SUBSEP tgt/' "$SCAN" > "$M3"
if cmp -s "$SCAN" "$M3"; then leg m3_planted yes no; else leg m3_planted yes yes; fi
M3OUT=$(sh "$M3" 2>&1)
leg m3_bites 3 "$(key "$M3OUT" import_edges)"

# m4: the room comparison forced false -- every edge reads as crossing a room
M4="$PEN/m4.sh"
sed 's/{ a = room($1); b = room($2); if (a == b) intra++; else cross++/{ a = room($1); b = room($2); if (0) intra++; else cross++/' "$SCAN" > "$M4"
if cmp -s "$SCAN" "$M4"; then leg m4_planted yes no; else leg m4_planted yes yes; fi
M4OUT=$(sh "$M4" 2>&1)
leg m4_bites 0 "$(key "$M4OUT" intra_room_edges)"

# m5: the capacity test removed from the packer -- a node fills past its own bound
cd "$PEN/two" || exit 1
M5="$PEN/m5.sh"
sed 's/      if (rem\[v\] < SZ\[f\]) continue/      if (0) continue/' "$SCAN" > "$M5"
if cmp -s "$SCAN" "$M5"; then leg m5_planted yes no; else leg m5_planted yes yes; fi
M5OUT=$(sh "$M5" 2>&1)
m5line=$(gridline "$M5OUT" place 4 cap_bytes)
m5cap=$(inline "$m5line" cap_bytes)
m5full=$(inline "$(printf '%s\n' "$M5OUT" | grep -m1 '^place k=4 fullest_node_bytes=')" fullest_node_bytes)
if [ "$m5full" -gt "$m5cap" ] 2>/dev/null; then leg m5_bites yes yes; else leg m5_bites yes no; fi

# m6: the phantom edges never added -- drift becomes pure thinning, which leaves a subgraph of the
# true graph that the layout is still good on, so the tolerance reads far too generous
cd "$PEN/two" || exit 1
M6="$PEN/m6.sh"
sed 's/  phantoms = int(ne \* P \/ 100 + 0.5)/  phantoms = 0/' "$SCAN" > "$M6"
if cmp -s "$SCAN" "$M6"; then leg m6_planted yes no; else leg m6_planted yes yes; fi
M6OUT=$(sh "$M6" 2>&1)
m6c=$(key "$M6OUT" file_drift_crossing_pct)
if awk -v c="$m6c" 'BEGIN { exit !(c > 90) }'; then leg m6_bites yes yes; else leg m6_bites yes no; fi

# m7: the matched floor costed under the TRUE edges while the layout is costed under the distorted
# ones -- two different graphs compared as if they were two placements
M7="$PEN/m7.sh"
sed 's/mt += drift_cost(DNODE, k)/mt += cost_of(DNODE, k)/' "$SCAN" > "$M7"
if cmp -s "$SCAN" "$M7"; then leg m7_planted yes no; else leg m7_planted yes yes; fi
M7OUT=$(sh "$M7" 2>&1)
leg m7_bites 100 "$(key "$M7OUT" file_proxy_survives_structure_drift_upto_pct)"

# m8: no real edge ever silenced -- the sweep only ADDS unseen pairs, so the layout keeps every
# edge it was built on and the tolerance reads a hundred percent
M8="$PEN/m8.sh"
sed 's/    if (rnd(100) < P) continue/    if (0) continue/' "$SCAN" > "$M8"
if cmp -s "$SCAN" "$M8"; then leg m8_planted yes no; else leg m8_planted yes yes; fi
M8OUT=$(sh "$M8" 2>&1)
leg m8_bites 100 "$(key "$M8OUT" file_proxy_survives_structure_drift_upto_pct)"

# m9: the full rung silently short of one edge -- the graph reading 5 re-seats is then not the
# graph reading 3 placed, and every rung below it would be measuring a layout this scan never
# computed. The self-check exists exactly to catch that, and here it is made to fire.
#
# TWO EARLIER PLANTS DID NOT BITE, and the reason is worth keeping: this pen's graph is regular,
# so disabling the placement order's sort left the order unchanged, and reversing the comparison
# produced a different order at the same cost. A pen whose placement is order-insensitive cannot
# exercise the ordering half of this check at all. That half is exercised on THIS TREE by
# `tree_size_reseat_matches`, where 1,561 files make the order load-bearing; the plant below
# reaches the half a small pen can prove -- a subsample that is not the graph it claims to be,
# planted in pen four because pen two's layout costs zero and two wrong answers there agree.
cd "$PEN/four" || exit 1
M9="$PEN/m9.sh"
sed 's/    if (deg\[b\] > deg\[a\] || (deg\[b\] == deg\[a\] \&\& b < a)) { EDGED\[i\] = b; EDGED\[j\] = a }/    if (deg[b] < deg[a] || (deg[b] == deg[a] \&\& b > a)) { EDGED[i] = b; EDGED[j] = a }/' "$SCAN" > "$M9"
if cmp -s "$SCAN" "$M9"; then leg m9_planted yes no; else leg m9_planted yes yes; fi
M9OUT=$(sh "$M9" 2>&1)
leg m9_bites no "$(key "$M9OUT" size_full_rung_matches_placement)"

# m10: the full edge list never kept beside the one reading 5 destroys -- the reading finds no
# graph to subsample and silently does not happen, which is the failure mode a missing key hides
M10="$PEN/m10.sh"
sed 's/  fne = ne; FA\[fne\] = a; FB\[fne\] = b/  FA[ne] = a; FB[ne] = b/' "$SCAN" > "$M10"
if cmp -s "$SCAN" "$M10"; then leg m10_planted yes no; else leg m10_planted yes yes; fi
M10OUT=$(sh "$M10" 2>&1)
leg m10_bites "" "$(key "$M10OUT" reading5)"

# ---- the control's own tally, derived rather than spelled ----------------------------------------
cd "$ROOT" || exit 1
echo "control_checks=$legs"
echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
