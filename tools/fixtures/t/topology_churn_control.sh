#!/bin/sh
# tools/fixtures/t/topology_churn_control.sh -- the churn cost, broken on purpose.
#
#   sh tools/fixtures/t/topology_churn_control.sh
#
# WHY. `tools/fixtures/t/topology_churn_scan.sh` prints numbers a design would act on: that one
# departure leaves 99.8 percent of a shared routing table exactly right, that the wrong part is a
# derivable 713 entries held by six nodes, and that a scattered loss hurts more than a clustered one
# of the same size. A number a reader can watch go wrong is a number a reader can trust, so this
# copies the scan into a pen, breaks it ten ways, watches each break show, and lifts every break. It
# proves the pen innocent first, so each plant reads as the break speaking rather than as the pen.
#
# EVERY PLANT IS PROVEN TO HAVE APPLIED, and the count is printed. A `sed` whose pattern no longer
# matches builds the UNMUTATED module, and the phase then reads exactly like a law that holds -- so
# each plant is compared against the source with `cmp -s` before its reading is believed, and
# `plants_applied=` is the number the witness binds.
#
# TWO PLANTS PASS, ON PURPOSE. Plant 7 probes one point three times: three probes of one thing agree
# trivially, and only the printed `removed=` says otherwise. Plant 10 carries a real break with the
# leg that catches it skipped. Both are what a silent wrong answer looks like from outside.
#
# WHY IT IS CHEAP. The full scan takes 135s, and eleven copies of that would be twenty-five minutes.
# The scan takes `SCAN_LEGS` (all|fast|hole|curve), so each plant runs only the leg it breaks -- and
# each reduced run prints its own `legs=` line, so every reading here announces its own reach and
# only the full one the witness binds can claim to be it.
#
# WHAT EACH PLANT DEFENDS:
#
#   1  bfs-keeps-dead    -- the punctured walk stepping through the removed point, so the punctured
#                           distance equals the intact one and the graph reads undamaged. This is
#                           the shape of a failure model that never fails.
#   2  table-through-hole-- the stale table walking through the removed point rather than dropping.
#                           The drop count FALLS and stretch appears from nowhere, which is the
#                           direction a flattering number moves.
#   3  distance-through-hole -- the same break one rule over. Its tell is arithmetically impossible:
#                           a NEGATIVE mean stretch, since a route through a point that is gone can
#                           be shorter than the punctured graph allows.
#   4  no-cycle-check    -- the distance rule losing its revisit test. The cycles become cap-outs and
#                           the two failure modes stop being told apart.
#   5  nr-allows-revisit -- the packet's visited set ignored, so `distance_nr` collapses back into
#                           `distance` and stops arriving everywhere.
#   6  entry-always-valid-- the entry test never firing, so the changed-entry count reads zero and
#                           the derivation it is checked against has nothing to disagree with.
#   7  hole-one-point    -- all three transitivity probes taking the SAME removed point. It PASSES,
#                           and the printed `removed=0,0,0` is the only thing that says otherwise.
#   8  hole-absolute     -- the transitivity sample taken in absolute numbering rather than
#                           translated with the hole. This is the fault the first draft of that leg
#                           actually carried, and it reads `agree=no` on a graph that is genuinely
#                           vertex-transitive.
#   9  ball-is-spread    -- the clustered removal replaced by the scattered one, so the two patterns
#                           become one and the finding that separates them disappears.
#   10 legless           -- plant 8, with the leg that catches it skipped. It PASSES. That is what
#                           every unchecked number in every instrument looks like.

set -eu

PEN="${TMPDIR:-/tmp}/topology-churn-control.$$"
trap 'rm -rf "$PEN"' EXIT INT TERM
rm -rf "$PEN"
mkdir -p "$PEN"

SRC="tools/fixtures/t/topology_churn_scan.sh"
[ -f "$SRC" ] || { echo "refused: $SRC is absent -- the control has nothing to copy"; exit 1; }

behaviors=0
fails=0
applied=0
note() { behaviors=$((behaviors + 1)); printf '  %s\n' "$1"; }
bad()  { fails=$((fails + 1)); printf '  FAULT %s\n' "$1"; }

OUT=""; VERDICT=""; CODE=""
run_pen() {
  _file="$1"; _legs="$2"
  if OUT=$(SCAN_LEGS="$_legs" sh "$_file" 2>&1); then CODE=ok; else CODE=refused; fi
  VERDICT=$(printf '%s\n' "$OUT" | sed -n 's/^verdict=\([a-z_]*\).*$/\1/p' | tail -1)
  [ -n "$VERDICT" ] || VERDICT=none
}
# A plant that matches nothing builds the unmutated module, and its phase then measures the pen
# rather than the break. `cmp -s` is what tells those two apart.
plant() {
  _name="$1"; _expr="$2"; _out="$PEN/$_name.sh"
  sed "$_expr" "$SRC" > "$_out"
  if cmp -s "$SRC" "$_out"; then bad "$_name did not apply -- the scan is spelled differently now"; return 1; fi
  applied=$((applied + 1))
  return 0
}
has() { printf '%s\n' "$OUT" | grep -q "$1"; }

echo "topology-churn-control: ten plants, each lifted, in $PEN"
echo ""

# ---- the pen, unbroken --------------------------------------------------------------------------
cp "$SRC" "$PEN/clean.sh"
run_pen "$PEN/clean.sh" all
echo "clean_verdict $VERDICT $CODE"
if [ "$VERDICT" = ok ] && [ "$CODE" = ok ]; then note "the unbroken pen passes, so a plant below speaks for itself"
else bad "the unbroken pen did not pass -- every plant below is unreadable"; fi
if has '^entry shape=circ .*cause_dead_hop=713 cause_stale_path=212 ring1=713 '; then
  note "and the dead-hop count is the derived n-1-degree, all of it at ring 1"
else bad "the unbroken pen did not read the entry claim this control was built around"; fi
if has '^predict shape=circ mean_hops_intact=6.3004 predicted_drops=3805.7 measured_drops=3811 '; then
  note "and the drop count predicted from the intact walk lands within six pairs of the measurement"
else bad "the unbroken pen did not read the drop prediction"; fi
if has '^curve shape=circ pattern=cluster removed=64 .*arrival_share=0.949449'; then
  note "and a clustered loss of 64 points arrives at 0.9494 where a scattered one arrives at 0.7672"
else bad "the unbroken pen did not read the pattern finding"; fi
echo ""

# ---- plant 1: the punctured walk steps through the hole -------------------------------------------
if plant p1 's|^        if (w in DEAD) continue$|        if (0) continue|'; then
  run_pen "$PEN/p1.sh" fast
  echo "plant1_bfs_keeps_dead $VERDICT $CODE"
  if has '^blast shape=circ removed=1 pairs=516242 damaged=0 '; then
    note "a failure model that never fails reads zero damage, and the blast leg prints it"
  else bad "plant 1 left the damage count where it stood -- the punctured walk is not what produces it"; fi
fi
echo ""

# ---- plant 2: the stale table walks through the hole ----------------------------------------------
if plant p2 's|^    if (w in DEAD) return -1$|    if (0) return -1|'; then
  run_pen "$PEN/p2.sh" fast
  echo "plant2_table_through_hole $VERDICT $CODE"
  if has '^stale shape=circ rule=table bytes=270 arrived=512785 dropped=3457 optimal=512751 arrival_share=0.993304 extra_hops=37$'; then
    note "the drop count falls 3,811 to 3,457 and 37 hops of stretch appear from nowhere -- packets delivered THROUGH a point that is gone"
  else bad "plant 2 left the drop count where it stood"; fi
fi
echo ""

# ---- plant 3: the distance rule walks through the hole --------------------------------------------
if plant p3 's|^      if (w in DEAD) continue$|      if (0) continue|'; then
  run_pen "$PEN/p3.sh" fast
  echo "plant3_distance_through_hole $VERDICT $CODE"
  if has '^stale shape=circ rule=distance bytes=360 arrived=496014 stalled=0 cycled=20228 optimal=495975 arrival_share=0.960817 extra_hops=-72 '; then
    note "and the giveaway is arithmetically impossible -- extra_hops=-72, a walk SHORTER than the punctured graph allows, which only a route through a point that is gone can produce"
  else bad "plant 3 left the distance rule's failures where they stood"; fi
fi
echo ""

# ---- plant 4: the distance rule loses its revisit test ---------------------------------------------
if plant p4 's|^    if (v in seenv) return -2$|    if (0) return -2|'; then
  run_pen "$PEN/p4.sh" fast
  echo "plant4_no_cycle_check $VERDICT $CODE"
  if has '^stale shape=circ rule=distance .* cycled=0 '; then
    note "a cycle becomes a cap-out, and the two failure modes stop being told apart"
  else bad "plant 4 left the cycle count where it stood"; fi
fi
echo ""

# ---- plant 5: the packet forgets where it has been --------------------------------------------------
if plant p5 's|if (w in DEAD \|\| (w in seenv)) continue|if (w in DEAD) continue|'; then
  run_pen "$PEN/p5.sh" fast
  echo "plant5_nr_allows_revisit $VERDICT $CODE"
  if has '^stale shape=circ rule=distance_nr .* arrival_share=0.997383 '; then
    note "distance_nr collapses into distance and stops arriving everywhere -- 0.9974 rather than 1.0000"
  else bad "plant 5 left the packet-memory arrival share at one"; fi
fi
echo ""

# ---- plant 6: the entry test never fires --------------------------------------------------------
if plant p6 's|ent_bad++; ENT_BAD\[u\]++; ent_dead++|ent_dead += 0|; s|ent_bad++; ENT_BAD\[u\]++; ent_path++|ent_path += 0|'; then
  run_pen "$PEN/p6.sh" fast
  echo "plant6_entry_always_valid $VERDICT $CODE"
  if has '^entry shape=circ .*changed_entries=0 '; then
    note "the changed-entry count reads zero, and the derivation it is checked against has nothing to disagree with"
  else bad "plant 6 left the changed-entry count where it stood"; fi
fi
echo ""

# ---- plant 7: three probes of one point, which PASSES ---------------------------------------------
if plant p7 's|hv1 = 0; hv2 = 137; hv3 = 421|hv1 = 0; hv2 = 0; hv3 = 0|'; then
  run_pen "$PEN/p7.sh" hole
  echo "plant7_hole_one_point $VERDICT $CODE"
  if [ "$VERDICT" = ok ] && [ "$CODE" = ok ]; then
    note "three probes of ONE point agree trivially and the scan says ok -- this is the plant that passes"
  else bad "plant 7 refused, so the vacuity lesson it carries is gone"; fi
  if has '^hole shape=circ probes=3 removed=0,0,0 '; then
    note "and the printed removed= is the only thing that says otherwise, which is why it is printed from the variables"
  else bad "plant 7 did not name the points it actually probed"; fi
fi
echo ""

# ---- plant 8: the transitivity sample taken in absolute numbering -----------------------------------
if plant p8 's|    t = (v + i \* 211) % n|    t = (i * 211) % n|'; then
  run_pen "$PEN/p8.sh" hole
  echo "plant8_hole_absolute $VERDICT $CODE"
  if [ "$VERDICT" = instrument_fault ]; then
    note "an untranslated sample reads agree=no on a graph that IS vertex-transitive -- the fault this leg's first draft carried"
  else bad "plant 8 passed -- the transitivity check does not depend on comparing under one set of coordinates"; fi
  if has '^hole VERDICT=transitivity_broken '; then
    note "and it names the disagreement rather than only refusing"
  else bad "plant 8 refused without naming what disagreed"; fi
fi
echo ""

# ---- plant 9: the clustered removal becomes the scattered one ---------------------------------------
if plant p9 's|^  delete DEAD; delete q; qh = 0; qt = 0; q\[qt++\] = 0; DEAD\[0\] = 1; taken = 1$|  dead_spread(k, n); return k|'; then
  run_pen "$PEN/p9.sh" curve
  echo "plant9_ball_is_spread $VERDICT $CODE"
  if has '^curve shape=circ pattern=cluster removed=64 .*arrival_share=0.767232'; then
    note "the two patterns become one, and the finding that separates them disappears into a duplicate row"
  else bad "plant 9 left the clustered pattern distinct from the scattered one"; fi
fi
echo ""

# ---- plant 10: plant 8, with the leg that catches it skipped ----------------------------------------
if plant p10 's|    t = (v + i \* 211) % n|    t = (i * 211) % n|'; then
  run_pen "$PEN/p10.sh" fast
  echo "plant10_legless $VERDICT $CODE"
  if [ "$VERDICT" = ok ] && [ "$CODE" = ok ]; then
    note "the same break PASSES with its leg skipped -- what every unchecked number looks like from outside"
  else bad "plant 10 refused, so the legless lesson it carries is gone"; fi
  if has '^claims hole_agree=skipped '; then
    note "and the reduced run says its own reach, so only a full pass can claim to be one"
  else bad "plant 10 did not announce that it skipped the hole leg"; fi
fi
echo ""

echo "behaviors=$behaviors"
echo "plants_applied=$applied"
echo "failures=$fails"
if [ "$fails" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=instrument_fault"; fi
[ "$fails" -eq 0 ]
