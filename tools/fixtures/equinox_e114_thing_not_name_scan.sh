#!/bin/sh
# Equinox e114 — thing-not-name law + REDS 39.
# Exit 0 only when control reads and all limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e114_thing_not_name_scan.sh
#
# Law: look for the thing, not for the name of the thing.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
THING_SCAN=tools/fixtures/thing_not_name_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
MAP=construction/EQUINOX_SEAT_MAP.md
REDS=construction/REDS.md
ELDER=tools/gen/season/equinox_e113_fascia_health_witness.rish

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
  "$THING_SCAN" \
  tools/fixtures/thing_not_name_emitter.sh \
  tools/gen/season/thing_not_name_witness.rish \
  tools/fixtures/shed_census_scan.sh \
  tools/fixtures/fascia_health_scan.sh
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

THING_OUT=$(sh "$THING_SCAN")
echo "$THING_OUT" | sed 's/^/thing_/'
echo "$THING_OUT" | rg -q '^verdict=ok$' || {
  echo "thing_not_name=failed"
  echo "verdict=misread"
  exit 1
}
echo "$THING_OUT" | rg -q '^roofs=2$' || {
  echo "thing_not_name=failed"
  echo "verdict=misread"
  echo "detail=want_roofs_2"
  exit 1
}
echo "thing_not_name=honored"

RED_OUT=$(sh "$THING_SCAN" prove-red || true)
echo "$RED_OUT" | rg -q 'RED_looked_for_name_not_thing' || {
  echo "thing_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "$RED_OUT" | rg -q '^verdict=ok$' && {
  echo "thing_prove_red=failed"
  echo "verdict=misread"
  exit 1
}
echo "thing_prove_red=honored"

# --- REDS row 39 ---
git ls-files --error-unmatch "$REDS" >/dev/null 2>&1 || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '^\| 39 \|' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_row_39"
  exit 1
}
rg -qi 'look for the thing, not for the name' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_thing_not_name_law"
  exit 1
}
rg -q '^\| 38 \|' "$REDS" || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_row_38_kept"
  exit 1
}
MONO=$(sh tools/fixtures/reds_ledger_monotone_scan.sh)
echo "$MONO"
echo "$MONO" | rg -q '^verdict=ok$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
# Accrete-never-break: pin row 39's presence, not the living ledger total.
ROWS=$(printf '%s\n' "$MONO" | sed -n 's/^rows=//p' | head -1)
EXPECT=$(printf '%s\n' "$MONO" | sed -n 's/^expect_next=//p' | head -1)
if test "${ROWS:-0}" -lt 39; then
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_rows_at_least_39"
  exit 1
fi
if test "${EXPECT:-0}" -lt 40; then
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_expect_next_at_least_40"
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
echo "reds_row_n=39"
echo "reds_rows_living=${ROWS}"
echo "reds_law=look_for_the_thing_not_the_name"

git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e113"

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

rg -q '^### 117\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=117"

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

echo "story=thing_not_name>reds_39>two_roofs>128_reserved>census_six>fork_waiting"
echo "e114_thing_not_name=ok"
echo "verdict=ok"
