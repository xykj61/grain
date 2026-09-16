#!/bin/sh
# tools/fixtures/m/bearing_quorum_control.sh -- proves the behaviors of
# tools/fixtures/m/bearing_quorum_scan.sh in a throwaway pen, every reading shown from both sides.
#
# WHY MUTATIONS RATHER THAN PLANTED DATA. This scan reads no population: its subject is a topology
# it builds in arithmetic, so there is nothing to plant. What CAN be planted is the reading itself.
# Each mutation below cuts one line out of a COPY of the scan and asserts the verdict moves, so a
# refusal is shown from both sides and a bypass cannot pass for a pass. A mutation that no longer
# applies reads exactly like one that passed, so each asserts it was applied before it is run.
#
#   sh tools/fixtures/m/bearing_quorum_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/m/bearing_quorum_scan.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
legs=0
LEGS_EXPECTED=37

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }
gt()  { if [ "$2" -gt "$3" ] 2>/dev/null; then ok "$1"; else no "$1 -- wanted over $3, read [$2]"; fi; }

field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$2" | tail -1; }
word()  { awk -v k="$1" '{ for (i = 1; i <= NF; i++) { split($i, a, "="); if (a[1] == k) print a[2] } }' "$2" | tail -1; }

# --- the reading as it stands -------------------------------------------------------------------
sh "$SCAN" > "$PEN/real.out" 2>&1 || true
check "instrument names itself"        "$(field instrument "$PEN/real.out")" "bearing_quorum"
check "the four-grid reading lands"    "$(field verdict "$PEN/real.out")"    "rendezvous"
check "the cost half stands"           "$(word cost_half "$PEN/real.out")"   "stands"
check "every pair meets exactly once"  "$(word meet_guarantee "$PEN/real.out")" "yes"
check "the wrap is worth one cut"      "$(word wrap_worth_one_cut "$PEN/real.out")" "yes"
check "the closed form holds at every grid" "$(word closed_form_misses "$PEN/real.out")" "0"
check "the cost ratio never rises"     "$(word cost_ratio_rises "$PEN/real.out")" "0"
check "the smallest intersection is one" "$(word cross_min "$PEN/real.out")" "1"
check "the largest intersection is one"  "$(word cross_max "$PEN/real.out")" "1"
check "a cycle loses no coverage to one cut" \
  "$(word cycle_cut1_coverage_losses "$PEN/real.out")" "0"
check "a cycle answers nothing silently under one cut" \
  "$(word cycle_cut1_silent_answers "$PEN/real.out")" "0"
gt "a path loses coverage to a single cut" \
  "$(word path_cut1_coverage_losses "$PEN/real.out")" 0
gt "a path answers silently under a single cut" \
  "$(word path_cut1_silent_answers "$PEN/real.out")" 0
check "every two-cut case splits the cycle" \
  "$(word cycle_cut2_splits "$PEN/real.out")" "$(word cycle_cut2_cases "$PEN/real.out")"

# The coverage share is the sentence row 8's own word "consensus" collides with, so it is read
# rather than left in prose: at the largest grid a vanishing share of nodes holds the value.
COV=$(awk '/^grid=32 announce_coverage=/ { split($2, a, "="); print a[2] }' "$PEN/real.out")
check "the largest grid covers one row"  "$COV" "32"

# --- the arguments ------------------------------------------------------------------------------
sh "$SCAN" --grids "16 32" > "$PEN/two.out" 2>&1 || true
check "two grids still read"            "$(field verdict "$PEN/two.out")" "rendezvous"

sh "$SCAN" --grids "8" > "$PEN/one.out" 2>&1 || true
check "one grid gives no exponent"      "$(field verdict "$PEN/one.out")" "unreadable"

sh "$SCAN" --grids "2 8" > "$PEN/small.out" 2>&1 || true
check "a grid under the floor refuses"  "$(field verdict "$PEN/small.out")" "unreadable"

sh "$SCAN" --grids "8 128" > "$PEN/big.out" 2>&1 || true
check "a grid over the ceiling refuses" "$(field verdict "$PEN/big.out")" "unreadable"

sh "$SCAN" --grids "8 8" > "$PEN/flat.out" 2>&1 || true
check "two equal grids give no tail"    "$(field verdict "$PEN/flat.out")" "unreadable"

if sh "$SCAN" --nonsense >/dev/null 2>&1; then
  no "an unknown flag refuses"
else
  ok "an unknown flag refuses"
fi

if sh "$SCAN" --grids "four eight" >/dev/null 2>&1; then
  no "a grid that is not a count refuses"
else
  ok "a grid that is not a count refuses"
fi

# --- mutation 1: the cycle walks one way only ---------------------------------------------------
# A cycle read as a one-way path is exactly what the wrap buys back, so cutting the backward leg
# must cost coverage. If it does not, the cycle reading was never reading the wrap.
sed 's/if (fwd || bwd) reach++/if (fwd) reach++/' "$SCAN" > "$PEN/m1.sh"
if cmp -s "$SCAN" "$PEN/m1.sh"; then no "mutation 1 applied"; else ok "mutation 1 applied"; fi
sh "$PEN/m1.sh" > "$PEN/m1.out" 2>&1 || true
check "one-way cycle loses the wrap"    "$(field verdict "$PEN/m1.out")" "wrap_fails"
gt "one-way cycle loses coverage"       "$(word cycle_cut1_coverage_losses "$PEN/m1.out")" 0

# --- mutation 2: the querier reads its ROW instead of its column --------------------------------
# Two lines of the same orientation meet in G cells or none, never in exactly one, so the meet
# guarantee must break. This is the mutation that proves the intersection is measured rather than
# assumed by construction.
sed 's|for (y = 0; y < G; y++) if ((y \* G + qx) in mark) c++|for (y = 0; y < G; y++) if ((ay * G + y) in mark) c++|' \
  "$SCAN" > "$PEN/m2.sh"
if cmp -s "$SCAN" "$PEN/m2.sh"; then no "mutation 2 applied"; else ok "mutation 2 applied"; fi
sh "$PEN/m2.sh" > "$PEN/m2.out" 2>&1 || true
check "a parallel line breaks the meet" "$(field verdict "$PEN/m2.out")" "meet_fails"
gt "a parallel line meets many times"   "$(word cross_max "$PEN/m2.out")" 1

# --- mutation 3: the announce costs the area ----------------------------------------------------
# Row 8's whole cost sentence is perimeter against area, so an announce that touches every node
# must read as the area and fail the cost half.
sed 's|for (x = 1; x < G; x++) msgs++|for (x = 1; x < G \* G; x++) msgs++|' "$SCAN" > "$PEN/m3.sh"
if cmp -s "$SCAN" "$PEN/m3.sh"; then no "mutation 3 applied"; else ok "mutation 3 applied"; fi
sh "$PEN/m3.sh" > "$PEN/m3.out" 2>&1 || true
check "an area-sized announce fails the cost half" "$(field verdict "$PEN/m3.out")" "cost_fails"
gt "an area-sized announce misses the closed form" "$(word closed_form_misses "$PEN/m3.out")" 0

# --- mutation 4: the second cut is not walked ---------------------------------------------------
# The bound the wrap buys is EXACTLY one cut, and a scan that asserts the second split rather than
# walking it would print the same number for a cycle that never splits.
sed 's/if (reach < G) cycle_cut2_split++/if (reach < 0) cycle_cut2_split++/' "$SCAN" > "$PEN/m4.sh"
if cmp -s "$SCAN" "$PEN/m4.sh"; then no "mutation 4 applied"; else ok "mutation 4 applied"; fi
sh "$PEN/m4.sh" > "$PEN/m4.out" 2>&1 || true
check "an unsplit second cut fails the wrap" "$(field verdict "$PEN/m4.out")" "wrap_fails"
check "an unsplit second cut counts none"    "$(word cycle_cut2_splits "$PEN/m4.out")" "0"

# --- mutation 5: the path never loses ------------------------------------------------------------
# The wrap reading is a CONTRAST, so a path that holds coverage under every cut must refuse too --
# otherwise the cycle's zero would be proving nothing beside it.
sed 's|if (a <= j) reach = j + 1; else reach = G - 1 - j|reach = G|' "$SCAN" > "$PEN/m5.sh"
if cmp -s "$SCAN" "$PEN/m5.sh"; then no "mutation 5 applied"; else ok "mutation 5 applied"; fi
sh "$PEN/m5.sh" > "$PEN/m5.out" 2>&1 || true
check "a lossless path fails the wrap"  "$(field verdict "$PEN/m5.out")" "wrap_fails"
check "a lossless path loses nothing"   "$(word path_cut1_coverage_losses "$PEN/m5.out")" "0"

echo "control_legs=$legs"
echo "control_legs_expected=$LEGS_EXPECTED"
echo "control_pass=$pass"
echo "control_failed=$fail"
if [ "$legs" -ne "$LEGS_EXPECTED" ]; then
  echo "detail: leg count moved -- a leg added or lost is a leg nobody heard"
  echo "control_verdict=leg_count"
  exit 0
fi
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
