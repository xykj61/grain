#!/bin/sh
# Equinox e112 — planted date-dialect witness on already-compact tree.
# Exit 0 only when standing dialect instrument + keep limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e112_date_dialect_witness_scan.sh
#
# Law: a duty with no witness has no seat, and a duty with no seat never lands.
# Law: carry the transformation, never the claim that it was done.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
DIALECT_SCAN=tools/fixtures/date_dialect_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
MAP=construction/EQUINOX_SEAT_MAP.md
ELDER=tools/gen/season/equinox_e111_date_dialect_witness.rish

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

# --- standing dialect instrument (planted both ways) ---
git ls-files --error-unmatch "$DIALECT_SCAN" >/dev/null 2>&1 || {
  echo "dialect_instrument=failed"
  echo "verdict=misread"
  exit 1
}
DIALECT_OUT=$(sh "$DIALECT_SCAN")
echo "$DIALECT_OUT" | sed 's/^/dialect_/'
echo "$DIALECT_OUT" | rg -q '^verdict=ok$' || {
  echo "dialect_instrument=failed"
  echo "verdict=misread"
  exit 1
}
echo "$DIALECT_OUT" | rg -q '^verdict=one_dialect$' || {
  echo "dialect_instrument=failed"
  echo "verdict=misread"
  echo "detail=want_one_dialect"
  exit 1
}
echo "dialect_instrument=honored"
echo "dialect_verdict=one_dialect"

# prove-red path must still refuse when invoked on the standing scan
RED_OUT=$(sh "$DIALECT_SCAN" prove-red || true)
echo "$RED_OUT" | rg -q 'RED_C2-compact' || {
  echo "dialect_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "$RED_OUT" | rg -q '^verdict=ok$' && {
  echo "dialect_prove_red=failed"
  echo "verdict=misread"
  echo "detail=prove_red_must_not_ok"
  exit 1
}
echo "dialect_prove_red=honored"

# --- elder e111 still green on disk (accrete, never break) ---
git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'equinox_e111_date_dialect_scan' "$ELDER" || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e111"

# --- seat 128 still reserved · not spent ---
rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '128' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  echo "detail=128_must_stay_reserved"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

# --- surface census six (e119 ch5+ch6 tools; elder four is historical) ---
COUNT=$(git ls-files 'tools/gen/season/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$COUNT" -ne 6; then
  echo "surface_keep=failed"
  echo "verdict=misread"
  echo "detail=want_surface_count_6"
  echo "surface_count=${COUNT}"
  exit 1
fi
echo "surface_keep=honored"
echo "surface_count=6"

# --- almanac: seat 115 present · ch8 heading ---
rg -q '^### 115\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '^## Chapter Eight \([0-9]+ of 16\)$' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=115"

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

echo "story=planted_date_dialect_witness>one_dialect>128_reserved_kept>census_six_kept>fork_waiting"
echo "e112_date_dialect_witness=ok"
echo "verdict=ok"
