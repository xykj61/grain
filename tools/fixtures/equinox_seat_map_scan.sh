#!/bin/sh
# Equinox seat map scan -- e107 corrected close path after seat 110 spent.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_seat_map_scan.sh
#
# Law: look at spent seats before naming the remaining map.
# Propose close choir on 112 as check-test-prepare; do not consume the fork.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
MAP=construction/EQUINOX_SEAT_MAP.md
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
FASCIA_SH=tools/fixtures/fascia_metric_v0.sh

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
  exit 1
}
echo "control_gate=honored"

# --- map pin present and tracked ---
git ls-files --error-unmatch "$MAP" >/dev/null 2>&1 || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=map_not_tracked"
  exit 1
}

rg -q 'seats \*\*97–112\*\*|seats \*\*97-112\*\*|97–112' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_ch7_span"
  exit 1
}
rg -q 'seat \*\*110\*\*.*e106|110.*e106|e106.*110' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_110_spent_named"
  exit 1
}
rg -q 'SPENT' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'CLOSE CHOIR' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_112_close_choir"
  exit 1
}
rg -q 'check · test · prepare' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_check_prepare"
  exit 1
}
rg -q 'BUNDLE SEND' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'crossing mode' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_bundle_as_crossing_mode"
  exit 1
}
rg -q 'SHRED' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'Keaton' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'close-seat row' "$MAP" || {
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=want_ch5_ch6_park_named"
  exit 1
}
# Must not claim fork consumed
if rg -q 'return_surface_p59 CONSUMED' "$MAP"; then
  echo "seat_map=failed"
  echo "verdict=misread"
  echo "detail=map_must_not_consume_fork"
  exit 1
fi
echo "seat_map=honored"
echo "seat_map_path=${MAP}"
echo "seat_map_110=spent_e106"
echo "seat_map_111=this_map"
echo "seat_map_112=close_choir_proposed"
echo "seat_map_bundle=crossing_mode"
echo "seat_map_shred=keaton_gated"

# --- almanac: seat 110 present - ch7 at least 14/16 - not yet 111 ---
rg -q '^### 110\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  echo "detail=want_seat_110"
  exit 1
}
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*|*"Chapter Seven (8 of 16)"*|*"Chapter Seven (9 of 16)"*|*"Chapter Seven (10 of 16)"*|*"Chapter Seven (11 of 16)"*|*"Chapter Seven (12 of 16)"*|*"Chapter Seven (13 of 16)"*)
    echo "almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_e107_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104 105 106 107 108 109 110; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "almanac=honored"
echo "ch7_line=$CH7_LINE"
echo "seats=97-110"
echo "seats_remaining_before_choir=111-112"

# --- fascia keep ---
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'law=hold_not_exclude' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
FASCIA_GRADE=$(echo "$FASCIA_OUT" | rg -o 'fascia=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -ne 92; then
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fascia_keep=honored"
echo "fascia_keep_grade=${FASCIA_GRADE}"

# --- fork ---
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "fork=honored"
echo "fork_status=not_consumed"

EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
fi
echo "shelf=honored"
echo "shelf_end=ep045"
echo "shred=RED"

echo "story=seat_110_spent>map_corrected>112_close_choir_proposed>bundle_crossing_mode>shred_keaton_gated>fork_waiting"
echo "e107_seat_map=ok"
echo "verdict=ok"
