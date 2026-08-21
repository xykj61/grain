#!/bin/sh
# Equinox e134 — surface census six through the elder chain.
# Exit 0 when living scans emit six, e113 witness path clears, suite 10/10.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e134_surface_count_scan.sh
#   sh tools/fixtures/equinox_e134_surface_count_scan.sh prove-red
#
# Law: an instrument that hardcodes a count ages faster than a format.
# Law: the tree is supposed to grow.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-003811_e134-surface-count-six.md
LEXICON=context/LEXICON.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
REDS=work-in-progress/REDS.md
SUITE=tools/fixtures/instrument_suite_scan.sh
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
E112=tools/fixtures/equinox_e112_date_dialect_witness_scan.sh
E114=tools/fixtures/equinox_e114_thing_not_name_scan.sh
E115=tools/fixtures/equinox_e115_instrument_suite_scan.sh
E116=tools/fixtures/equinox_e116_dated_one_definition_scan.sh
E117=tools/fixtures/equinox_e117_fork_extend_breach_close_scan.sh
E118=tools/fixtures/equinox_e118_metal_corrections_scan.sh
E119=tools/fixtures/equinox_e119_close_seat_surfaces_scan.sh

if test "$MODE" = "prove-red"; then
  echo "detail=RED_surface_count_still_four"
  echo "verdict=misread"
  exit 1
fi

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$COUNSEL" "$LEXICON" "$MAP" "$REMEMBER" "$REDS" "$SUITE" "$PRIN" \
  "$E112" "$E114" "$E115" "$E116" "$E117" "$E118" "$E119"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

SURFACES=$(git ls-files 'tools/gen/season/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$SURFACES" -ne 6; then
  echo "surfaces=failed"
  echo "detail=want_six_surface_witnesses"
  echo "surface_witnesses=${SURFACES}"
  echo "verdict=misread"
  exit 1
fi
echo "surfaces=honored"
echo "surface_witnesses=6"

# No living assert of four in the six scans (e119 prove-red may still print 4)
for s in "$E112" "$E114" "$E115" "$E116" "$E117" "$E118"; do
  if rg -q 'test "\$COUNT" -ne 4' "$s"; then
    echo "stale=failed"
    echo "detail=living_assert_still_four"
    echo "detail_path=$s"
    echo "verdict=misread"
    exit 1
  fi
  rg -q 'test "\$COUNT" -ne 6' "$s" || {
    echo "stale=failed"
    echo "detail=want_assert_six"
    echo "detail_path=$s"
    echo "verdict=misread"
    exit 1
  }
done
echo "stale=honored"
echo "living_asserts=six"

# e119 prove-red still names the false four (refuse fixture)
rg -q 'RED_claimed_four_while_six' "$E119" || {
  echo "e119_prove=failed"
  echo "detail=want_prove_red_four_claim"
  echo "verdict=misread"
  exit 1
}
echo "e119_prove=honored"
echo "e119_note=prove_red_prints_four_on_purpose"

# Spot-check e112 green (opens the e113 elder chain)
E112_OUT=$(sh "$E112")
echo "$E112_OUT" | rg -q '^verdict=ok$' || {
  echo "e112=failed"
  echo "verdict=misread"
  exit 1
}
echo "$E112_OUT" | rg -q '^surface_count=6$' || {
  echo "e112=failed"
  echo "detail=want_surface_6"
  echo "verdict=misread"
  exit 1
}
echo "e112=honored"

SUITE_OUT=$(sh "$SUITE")
echo "$SUITE_OUT" | rg -q '^verdict=ok$' || {
  echo "suite=failed"
  echo "verdict=misread"
  exit 1
}
echo "$SUITE_OUT" | rg -q '^pass=10$' || {
  echo "suite=failed"
  echo "detail=want_pass_10"
  echo "verdict=misread"
  exit 1
}
echo "$SUITE_OUT" | rg -q '^fail=0$' || {
  echo "suite=failed"
  echo "detail=want_fail_0"
  echo "verdict=misread"
  exit 1
}
echo "suite=honored"
echo "suite_pass=10"
echo "suite_fail=0"

rg -q '^\| 45 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_45"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_45_hardcoded_count_ages"

rg -qi 'hardcodes a count|surface census six|elder chain' "$COUNSEL" "$REMEMBER" "$LEXICON" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$REMEMBER" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"

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

if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "detail=seat_128_must_stay_unspent"
  echo "verdict=misread"
  exit 1
fi
echo "almanac=honored"
echo "no_content_seat_claimed=honored"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"

echo "story=surface_six>elder_chain>suite_10>reds_45>shred_held>128_reserved"
echo "verdict=ok"
