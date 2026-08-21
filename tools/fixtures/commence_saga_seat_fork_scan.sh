#!/bin/sh
# Commence saga seat + fork scan — control gate, then seating + fork limbs.
# Exit 0 only when control reads and seating honors without consuming the fork.
# No backtick characters in patterns.
#
#   sh tools/fixtures/commence_saga_seat_fork_scan.sh
#
# Law: no duty reports a total until its planted control reads correctly.
# Seating: Keaton's word approve · fork waits · return_surface_p59 not consumed.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
SAGA_PROSE=saga/20260731-130200_saga-of-the-commence-arc.md
SAGA_README=saga/README.md
PRIN=tools/gen/season/prin_scope.rish
GEODE=counsel/date/20260730/20260730-162222_e50-dual-equinox-geode-expedition-breach.md
M9_WAYMARK=waymarks/date/20260731/20260731-131407_e100-commence-m9-ascent-green.md

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi

CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT"
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  echo "detail=control_must_read_before_totals"
  exit 1
}
echo "control_gate=honored"

# --- prose saga seated (Keaton approve) ---
git ls-files --error-unmatch "$SAGA_PROSE" >/dev/null 2>&1 || {
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=commence_saga_untracked"
  exit 1
}
rg -q 'trust the tree, test the instrument' "$SAGA_PROSE" || {
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=saga_motto_missing"
  exit 1
}
# Header status and pane 7 both carry Seated + approve stamp.
rg -q '\*\*Seated\*\* `20260731.131240`' "$SAGA_PROSE" || {
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=want_seated_stamp_20260731.131240"
  exit 1
}
SEATED_COUNT=$(rg -c '\*\*Seated\*\* `20260731.131240`' "$SAGA_PROSE" || true)
if test "$SEATED_COUNT" -lt 2; then
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=want_both_status_panes_seated"
  exit 1
fi
rg -q "Keaton's word \*approve\*" "$SAGA_PROSE" || {
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=want_approve_word"
  exit 1
}
# Must not still claim Proposed as living status in header/pane7.
if rg -q '^\*\*Status:\*\* \*\*Proposed\*\*' "$SAGA_PROSE"; then
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=header_still_proposed"
  exit 1
fi
rg -q 'Season Close Narratives' "$SAGA_README" || {
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=saga_home_missing"
  exit 1
}
rg -q '\*\*Seated\*\*' "$SAGA_README" || {
  echo "seat_saga=failed"
  echo "verdict=misread"
  echo "detail=saga_readme_must_name_seated"
  exit 1
}
echo "seat_saga=honored"
echo "seat_saga_status=SEATED"
echo "seat_saga_stamp=20260731.131240"

# --- M9 measurement still present (witness complements narrative) ---
git ls-files --error-unmatch "$M9_WAYMARK" >/dev/null 2>&1 || {
  echo "seat_m9=failed"
  echo "verdict=misread"
  echo "detail=m9_waymark_absent"
  exit 1
}
echo "seat_m9=honored"
echo "seat_m9_role=measurement_complements_narrative"

# --- fork: nested handback not consumed · geode breach names the choice ---
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "seat_fork=failed"
  echo "verdict=misread"
  echo "detail=missing_equinox_handback_line"
  exit 1
}
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "seat_fork=failed"
  echo "verdict=misread"
  echo "detail=nested_handback_must_stay_unconsumed"
  exit 1
fi
# File wraps the handback name in markdown code marks; avoid backticks in patterns.
rg -q 'return_surface_p59' "$GEODE" || {
  echo "seat_fork=failed"
  echo "verdict=misread"
  echo "detail=geode_handback_missing"
  exit 1
}
rg -q 'remains available if Keaton names' "$GEODE" || {
  echo "seat_fork=failed"
  echo "verdict=misread"
  echo "detail=geode_fork_line_missing"
  exit 1
}
rg -q -F 'prefer extend +128 geode expedition' "$PRIN" || {
  echo "seat_fork=failed"
  echo "verdict=misread"
  echo "detail=extend_lean_missing"
  exit 1
}
# Saga must name the fork without spending it.
rg -q 'The fork' "$SAGA_PROSE" || {
  echo "seat_fork=failed"
  echo "verdict=misread"
  echo "detail=saga_fork_pane_missing"
  exit 1
}
echo "seat_fork=honored"
echo "seat_fork_nested=return_surface_p59"
echo "seat_fork_status=not_consumed"
echo "seat_fork_choices=RETURN|EXTEND_+128"

# --- almanac seats 97-104 · ch7 at least 8/16 ---
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*)
    echo "seat_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_seat_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "seat_almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "seat_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "seat_almanac=honored"
echo "seat_ch7_line=$CH7_LINE"
echo "seat_seats=97-104"

# --- shelf end · shred standing ---
EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "seat_shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "seat_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "seat_shelf=honored"
echo "seat_shelf_end=ep045"
echo "seat_ep046=absent"
echo "shred=RED"

echo "seat_story=M8_witness+M8_narrative>M9_ascent_measured>saga_SEATED>fork_awaits_Keaton"
echo "e101_saga_seat_fork=ok"
echo "verdict=ok"
