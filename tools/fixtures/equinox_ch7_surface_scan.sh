#!/bin/sh
# Equinox ch7 surface scan — e109 · fifteen limbs · itinerary modes.
# Exit 0 only when control reads and surface limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_ch7_surface_scan.sh
#
# Law: a duty is not a seat unless the almanac says so.
# Bundle and shred are modes; only the close choir was a seat (112).
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
MAP=construction/EQUINOX_SEAT_MAP.md
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
REDS=construction/REDS.md

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

# --- map: close landed · bundle/shred modes · shred not displaced to ch8 ---
git ls-files --error-unmatch "$MAP" >/dev/null 2>&1 || {
  echo "itinerary=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'CLOSE CHOIR' "$MAP" || {
  echo "itinerary=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'LANDED' "$MAP" || {
  echo "itinerary=failed"
  echo "verdict=misread"
  echo "detail=want_112_landed"
  exit 1
}
rg -q 'crossing mode' "$MAP" || {
  echo "itinerary=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'Keaton-gated' "$MAP" || {
  echo "itinerary=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'A duty is not a seat unless the almanac says so|duty is not a seat unless the almanac says so' "$MAP" || {
  echo "itinerary=failed"
  echo "verdict=misread"
  echo "detail=want_duty_not_seat_law"
  exit 1
}
rg -q 'only the close is a seat|Only the close choir is a seat|only the close choir is a seat' "$MAP" || {
  echo "itinerary=failed"
  echo "verdict=misread"
  echo "detail=want_close_is_one_seat"
  exit 1
}
# Must not claim shred opens Chapter Eight as the arithmetic fix
if rg -q 'shred opens Chapter Eight|SHRED lap \(n-1\) — \*\*opens Chapter Eight\*\*' "$MAP"; then
  echo "itinerary=failed"
  echo "verdict=misread"
  echo "detail=shred_must_not_displace_to_ch8"
  exit 1
fi
if rg -q 'return_surface_p59 CONSUMED' "$MAP"; then
  echo "itinerary=failed"
  echo "verdict=misread"
  exit 1
fi
echo "itinerary=honored"
echo "itinerary_bundle=crossing_mode"
echo "itinerary_shred=keaton_gated_mode"
echo "itinerary_close=one_seat"
echo "seat_map_112=close_choir_landed"
echo "seat_map_113=ch7_surface_this_sitting"

# --- REDS zero-view law kept · rows at least 33 · monotone ---
rg -q '^\| 33 \|' "$REDS" || {
  echo "ledger=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'A zero in a report is a claim about the instrument' "$REDS" || {
  echo "ledger=failed"
  echo "verdict=misread"
  exit 1
}
MONO=$(sh tools/fixtures/reds_ledger_monotone_scan.sh)
echo "$MONO"
echo "$MONO" | rg -q '^verdict=ok$' || {
  echo "ledger=failed"
  echo "verdict=misread"
  exit 1
}
ROWS=$(echo "$MONO" | rg -o '^rows=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$ROWS" || test "$ROWS" -lt 33; then
  echo "ledger=failed"
  echo "verdict=misread"
  echo "detail=want_rows_at_least_33"
  exit 1
fi
echo "ledger=honored"
echo "reds_rows=${ROWS}"

# --- almanac ch7 FULL · seats 97-112 · ch8 not yet required before append ---
rg -q '^## Chapter Seven \(16 of 16\)$' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  echo "detail=want_ch7_full"
  exit 1
}
for n in 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "almanac=honored"
echo "ch7_status=FULL"
echo "seats=97-112"
echo "limbs=15"
echo "limb_span=97-111"

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

echo "story=fifteen_limbs>itinerary_modes>close_one_seat>ch7_full>ch8_opens"
echo "ch7_surface=ok"
echo "verdict=ok"
