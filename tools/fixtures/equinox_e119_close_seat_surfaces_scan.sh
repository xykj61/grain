#!/bin/sh
# Equinox e119 — close-seat answered · ch5+ch6 surfaces as tools · park lifted.
# Exit 0 only when control reads and close-seat limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e119_close_seat_surfaces_scan.sh
#   sh tools/fixtures/equinox_e119_close_seat_surfaces_scan.sh prove-red
#
# Law: a surface witness claims no seat of its own.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260731/20260731-214426_e119-close-seat-surfaces.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
ELDER=tools/gen/season/equinox_e118_metal_corrections_witness.rish
CH5=tools/gen/season/equinox_ch5_surface_witness.rish
CH6=tools/gen/season/equinox_ch6_surface_witness.rish
CH5_SCAN=tools/fixtures/equinox_ch5_surface_scan.sh
CH6_SCAN=tools/fixtures/equinox_ch6_surface_scan.sh

if test "$MODE" = "prove-red"; then
  echo "surface_count=4"
  echo "detail=RED_claimed_four_while_six"
  echo "census=withheld"
  echo "verdict=misread"
  exit 1
fi

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

for p in "$COUNSEL" "$MAP" "$REMEMBER" "$PRIN" "$ELDER" "$CH5" "$CH6" "$CH5_SCAN" "$CH6_SCAN"; do
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

CH5_OUT=$(sh "$CH5_SCAN")
echo "$CH5_OUT" | sed 's/^/ch5_/'
echo "$CH5_OUT" | rg -q '^verdict=ok$' || {
  echo "ch5=failed"
  echo "verdict=misread"
  exit 1
}
CH6_OUT=$(sh "$CH6_SCAN")
echo "$CH6_OUT" | sed 's/^/ch6_/'
echo "$CH6_OUT" | rg -q '^verdict=ok$' || {
  echo "ch6=failed"
  echo "verdict=misread"
  exit 1
}
echo "surfaces=honored"

COUNT=$(git ls-files 'tools/gen/season/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$COUNT" -ne 6; then
  echo "surface_count=$COUNT"
  echo "surface_keep=failed"
  echo "verdict=misread"
  echo "detail=want_surface_count_6"
  exit 1
fi
echo "surface_keep=honored"
echo "surface_count=6"
echo "census_names=ch2·ch3·ch4·ch5·ch6·ch7"

rg -qi 'close-seat|no seat of its own|park lifted|surfaces as tools' "$COUNSEL" || {
  echo "close_seat=failed"
  echo "verdict=misread"
  echo "detail=want_close_seat_answer_in_counsel"
  exit 1
}
rg -qi 'park lifted|close-seat answered|census finds six|surfaces as tools' "$REMEMBER" "$MAP" || {
  echo "close_seat=failed"
  echo "verdict=misread"
  echo "detail=want_park_lifted_in_living_pins"
  exit 1
}
# Must not still claim ch5/ch6 surfaces absent under living park
if rg -qi 'ch5 · ch6 surfaces \| still \*\*absent\*\*|close-seat row \(ch5 \+ ch6\) \| still parked' "$MAP"; then
  echo "close_seat=failed"
  echo "verdict=misread"
  echo "detail=stale_park_still_standing"
  exit 1
fi
echo "close_seat=honored"
echo "e92_park=lifted"
echo "law=a_surface_witness_claims_no_seat_of_its_own"

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

git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e118"

rg -q '^### 123\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=123"

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
echo "fork_word=EXTEND"
echo "handback_status=not_consumed"

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

if test -x rishi/bin/rishi; then
  echo "local_rishi=PRESENT"
else
  echo "local_rishi=ABSENT"
fi
if test -x vendor/zig-toolchain/zig; then
  echo "local_zig=PRESENT"
else
  echo "local_zig=ABSENT"
fi
echo "tool_presence=per_bench_recut"
echo "local_note=binaries_gitignored_each_bench_proves"

echo "story=close_seat_answered>ch5_ch6_tools>census_six>e92_park_lifted>128_reserved"
echo "verdict=ok"
