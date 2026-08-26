#!/bin/sh
# Equinox e115 -- instrument-season suite seated as findable record.
# Exit 0 only when control reads and all limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e115_instrument_suite_scan.sh
#
# Law: seat the suite; do not manufacture meters.
# Remaining after this seat: Keaton-gated (fork - breach - shred - names).
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
SUITE=tools/fixtures/instrument_suite_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
MAP=construction/EQUINOX_SEAT_MAP.md
REDS=construction/REDS.md
ELDER=tools/gen/season/equinox_e114_thing_not_name_witness.rish

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

for p in \
  "$SUITE" \
  tools/gen/season/instrument_suite_witness.rish \
  tools/fixtures/sundial.sh \
  tools/fixtures/fascia_metric_v0.sh \
  tools/gen/season/census_control_witness.rish \
  tools/gen/season/shed_census_witness.rish \
  tools/gen/season/equinox_e111_date_dialect_witness.rish \
  tools/gen/season/oldness_census_witness.rish \
  tools/gen/season/radiant_h1_fence_witness.rish \
  tools/fixtures/radiant_lint_scan.sh \
  tools/fixtures/equinox_e113_fascia_health_scan.sh \
  tools/gen/season/thing_not_name_witness.rish
do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    if test -f "$p"; then
      echo "instrument=failed"
      echo "verdict=misread"
      echo "detail=on_disk_is_not_in_the_tree"
      echo "detail_path=$p"
      exit 1
    fi
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=control_absent"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

SUITE_OUT=$(sh "$SUITE")
echo "$SUITE_OUT" | sed 's/^/suite_/'
echo "$SUITE_OUT" | rg -q '^verdict=ok$' || {
  echo "instrument_suite=failed"
  echo "verdict=misread"
  exit 1
}
echo "$SUITE_OUT" | rg -q '^pass=10$' || {
  echo "instrument_suite=failed"
  echo "verdict=misread"
  echo "detail=want_pass_10"
  exit 1
}
echo "$SUITE_OUT" | rg -q '^fail=0$' || {
  echo "instrument_suite=failed"
  echo "verdict=misread"
  exit 1
}
echo "instrument_suite=honored"
echo "suite_pass=10"
echo "suite_fail=0"

RED_OUT=$(sh "$SUITE" prove-red || true)
echo "$RED_OUT" | rg -q 'RED_manufactured_suite_pass' || {
  echo "suite_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "suite_prove_red=honored"

# REDS 39 kept (thing-not-name law) -- no new red this seat
git ls-files --error-unmatch "$REDS" >/dev/null 2>&1 || {
  echo "reds_keep=failed"
  echo "verdict=misread"
  exit 1
}
sh tools/fixtures/reds_row_present.sh 39 >/dev/null || {
  echo "reds_keep=failed"
  echo "verdict=misread"
  exit 1
}
MONO=$(sh tools/fixtures/reds_ledger_monotone_scan.sh)
echo "$MONO"
echo "$MONO" | rg -q '^verdict=ok$' || {
  echo "reds_keep=failed"
  echo "verdict=misread"
  exit 1
}
ROWS=$(printf '%s\n' "$MONO" | sed -n 's/^rows=//p' | head -1)
if test "${ROWS:-0}" -lt 39; then
  echo "reds_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reds_keep=honored"
echo "reds_rows_living=${ROWS}"

git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e114"

rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

# surface census six (e119 ch5+ch6 tools; elder four is historical)
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

rg -q '^### 118\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=118"

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
echo "remaining=keaton_gated"
echo "remaining_note=fork_breach_shred_safe_close_seat_names"

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

echo "story=instrument_suite_10>counsel_nine_plus_thing_not_name>keaton_gated_remainder>128_reserved>fork_waiting"
echo "e115_instrument_suite=ok"
echo "verdict=ok"
