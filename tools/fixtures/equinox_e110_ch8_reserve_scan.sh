#!/bin/sh
# Equinox e110 -- e92 surface census finds four - reserve ch8 seat 128.
# Exit 0 only when control reads and limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e110_ch8_reserve_scan.sh
#
# Law: a record that cannot be found by the census that will look for it
# is not yet a record. Reserve the close seat on day one.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
MAP=construction/EQUINOX_SEAT_MAP.md
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish

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

# --- e92-shaped census: chapter surface witnesses findable by name ---
# Pattern mirrors the census that made the e92 ruling: equinox_chN_surface_witness
SURFACES=$(git ls-files 'tools/gen/season/equinox_ch*_surface_witness.rish' | sort)
echo "surface_paths_begin"
echo "$SURFACES"
echo "surface_paths_end"
COUNT=$(printf '%s\n' "$SURFACES" | sed '/^$/d' | wc -l | tr -d ' ')
echo "surface_count=${COUNT}"
if test "$COUNT" -ne 4; then
  echo "surface_census=failed"
  echo "verdict=misread"
  echo "detail=want_four_chapter_surfaces"
  exit 1
fi
for n in 2 3 4 7; do
  PATH_N="tools/gen/season/equinox_ch${n}_surface_witness.rish"
  printf '%s\n' "$SURFACES" | rg -q -F "$PATH_N" || {
    echo "surface_census=failed"
    echo "verdict=misread"
    echo "detail=want_ch${n}_surface"
    exit 1
  }
  git ls-files --error-unmatch "$PATH_N" >/dev/null 2>&1 || {
    echo "surface_census=failed"
    echo "verdict=misread"
    exit 1
  }
done
# ch5 and ch6 must still be absent (parked close-seat row)
for n in 5 6; do
  PATH_N="tools/gen/season/equinox_ch${n}_surface_witness.rish"
  if git ls-files --error-unmatch "$PATH_N" >/dev/null 2>&1; then
    echo "surface_census=failed"
    echo "verdict=misread"
    echo "detail=ch${n}_must_remain_absent_until_close_seat_row"
    exit 1
  fi
done
echo "surface_census=honored"
echo "surface_chapters=2,3,4,7"
echo "surface_law=record_must_be_findable_by_census"

# --- map: ch8 span - seat 128 reserved for close choir ---
git ls-files --error-unmatch "$MAP" >/dev/null 2>&1 || {
  echo "reserve=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '113–128|113-128|seats \*\*113–128\*\*|seats \*\*113-128\*\*' "$MAP" || {
  echo "reserve=failed"
  echo "verdict=misread"
  echo "detail=want_ch8_span_113_128"
  exit 1
}
rg -q 'RESERVED' "$MAP" || {
  echo "reserve=failed"
  echo "verdict=misread"
  echo "detail=want_128_reserved"
  exit 1
}
rg -q 'seat \*\*128\*\*|128.*close|close.*128' "$MAP" || {
  echo "reserve=failed"
  echo "verdict=misread"
  echo "detail=want_128_close_named"
  exit 1
}
rg -q 'check · test · prepare' "$MAP" || {
  echo "reserve=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'close-seat row' "$MAP" || {
  echo "reserve=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'return_surface_p59 CONSUMED' "$MAP"; then
  echo "reserve=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reserve=honored"
echo "ch8_span=113-128"
echo "seat_128=reserved_close_choir"
echo "ch8_content_seats=114-127"

# --- almanac: ch7 FULL - ch8 open - seat 113 present ---
rg -q '^## Chapter Seven \(16 of 16\)$' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '^## Chapter Eight \([0-9]+ of 16\)$' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  echo "detail=want_ch8_heading"
  exit 1
}
rg -q '^### 113\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "ch7_status=FULL"
echo "ch8_open=yes"
echo "seats_through=113"

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

echo "story=census_finds_four>ch7_surface_findable>reserve_128>ch8_plan>fork_waiting"
echo "e110_ch8_reserve=ok"
echo "verdict=ok"
