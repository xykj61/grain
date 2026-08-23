#!/bin/sh
# Equinox e116 — one dated definition + roof divergence + REDS 40.
# Exit 0 only when control reads and all limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e116_dated_one_definition_scan.sh
#
# Law: when two roofs carry one name, either they agree or the name is doing two jobs.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
PATTERN=tools/fixtures/dated_pattern_scan.sh
DIVERGE=tools/fixtures/dated_roof_divergence_scan.sh
CLASSIFY=tools/fixtures/dated_classify.py
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
MAP=construction/EQUINOX_SEAT_MAP.md
REDS=construction/REDS.md
ELDER=tools/gen/season/equinox_e115_instrument_suite_witness.rish

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
  "$PATTERN" \
  "$DIVERGE" \
  "$CLASSIFY" \
  tools/gen/season/dated_pattern_witness.rish \
  tools/gen/season/dated_roof_divergence_witness.rish \
  tools/fixtures/shed_census_scan.sh \
  tools/fixtures/fascia_health_scan.sh \
  context/specs/living-vs-dated.md
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

PATTERN_OUT=$(sh "$PATTERN")
echo "$PATTERN_OUT" | sed 's/^/pattern_/'
echo "$PATTERN_OUT" | rg -q '^verdict=ok$' || {
  echo "dated_pattern=failed"
  echo "verdict=misread"
  exit 1
}
echo "$PATTERN_OUT" | rg -q '^definition=one$' || {
  echo "dated_pattern=failed"
  echo "verdict=misread"
  echo "detail=want_definition_one"
  exit 1
}
echo "dated_pattern=honored"

RED_OUT=$(sh "$PATTERN" prove-red || true)
echo "$RED_OUT" | rg -q 'RED_dated_definition_blind' || {
  echo "pattern_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "pattern_prove_red=honored"

DIV_OUT=$(sh "$DIVERGE")
echo "$DIV_OUT" | sed 's/^/div_/'
echo "$DIV_OUT" | rg -q '^verdict=ok$' || {
  echo "roof_divergence=failed"
  echo "verdict=misread"
  exit 1
}
echo "$DIV_OUT" | rg -q '^divergence=absent$' || {
  echo "roof_divergence=failed"
  echo "verdict=misread"
  echo "detail=want_divergence_absent"
  exit 1
}
echo "$DIV_OUT" | rg -q '^roofs_agree=honored$' || {
  echo "roof_divergence=failed"
  echo "verdict=misread"
  exit 1
}
echo "roof_divergence=honored"

DIV_RED=$(sh "$DIVERGE" prove-red || true)
echo "$DIV_RED" | rg -q 'RED_roofs_diverge' || {
  echo "diverge_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "diverge_prove_red=honored"

# Both roofs source the shared classifier (string presence in scan bodies)
rg -q 'dated_classify\.py' tools/fixtures/shed_census_scan.sh || {
  echo "shared_source=failed"
  echo "verdict=misread"
  echo "detail=shed_missing_shared_classify"
  exit 1
}
rg -q 'dated_classify\.py' tools/fixtures/fascia_health_scan.sh || {
  echo "shared_source=failed"
  echo "verdict=misread"
  echo "detail=health_missing_shared_classify"
  exit 1
}
echo "shared_source=honored"
echo "shared_classify=tools/fixtures/dated_classify.py"

# --- REDS row 40 ---
git ls-files --error-unmatch "$REDS" >/dev/null 2>&1 || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '^\| 40 \|' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_row_40"
  exit 1
}
rg -qi 'when two roofs carry one name' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_two_roofs_law"
  exit 1
}
rg -q '^\| 39 \|' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_row_39_kept"
  exit 1
}
MONO=$(sh tools/fixtures/reds_ledger_monotone_scan.sh)
echo "$MONO"
echo "$MONO" | rg -q '^verdict=ok$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
ROWS=$(printf '%s\n' "$MONO" | sed -n 's/^rows=//p' | head -1)
EXPECT=$(printf '%s\n' "$MONO" | sed -n 's/^expect_next=//p' | head -1)
if test "${ROWS:-0}" -lt 40; then
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_rows_at_least_40"
  exit 1
fi
if test "${EXPECT:-0}" -lt 41; then
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_expect_next_at_least_41"
  exit 1
fi
LEDGER=$(sh tools/fixtures/reds_ledger_scan.sh)
echo "$LEDGER"
echo "$LEDGER" | rg -q '^verdict=ok$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
echo "reds_row=honored"
echo "reds_row_n=40"
echo "reds_rows_living=${ROWS}"
echo "reds_law=when_two_roofs_carry_one_name_they_agree_or_the_name_does_two_jobs"

git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e115"

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

rg -q '^### 119\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=119"

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

echo "story=one_dated_definition>roofs_agree>reds_40>128_reserved>census_six>fork_waiting"
echo "e116_dated_one_definition=ok"
echo "verdict=ok"
