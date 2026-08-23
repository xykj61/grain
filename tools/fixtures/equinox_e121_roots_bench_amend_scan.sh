#!/bin/sh
# Equinox e121 — roots amended · bench = raised root.
# Exit 0 only when control reads and amend limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e121_roots_bench_amend_scan.sh
#   sh tools/fixtures/equinox_e121_roots_bench_amend_scan.sh prove-red
#
# Law: name the root when a measurement is reported.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
LEXICON=context/LEXICON.md
COUNSEL=counsel/date/20260731/20260731-220432_e121-roots-bench-amend.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
ELDER=tools/gen/season/equinox_e120_lexicon_roots_witness.rish

if test "$MODE" = "prove-red"; then
  echo "bench_kinship=absent"
  echo "detail=RED_claimed_bench_not_raised_root"
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

for p in "$LEXICON" "$COUNSEL" "$MAP" "$ITINERARY" "$PRIN" "$ELDER"; do
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

ROW=$(rg -F '| **roots** |' "$LEXICON" || true)
if test -z "$ROW"; then
  echo "roots=failed"
  echo "verdict=misread"
  exit 1
fi
echo "$ROW" | rg -q 'Claude web' || { echo "roots=failed"; echo "verdict=misread"; echo "detail=want_claude_web"; exit 1; }
echo "$ROW" | rg -q 'Claude iOS' || { echo "roots=failed"; echo "verdict=misread"; echo "detail=want_claude_ios"; exit 1; }
echo "$ROW" | rg -q 'Cursor AppImage desktop' || { echo "roots=failed"; echo "verdict=misread"; echo "detail=want_cursor_appimage"; exit 1; }
echo "$ROW" | rg -q 'Cursor iOS' || { echo "roots=failed"; echo "verdict=misread"; echo "detail=want_cursor_ios"; exit 1; }
echo "$ROW" | rg -qi 'Framework' || { echo "roots=failed"; echo "verdict=misread"; echo "detail=want_framework"; exit 1; }
echo "$ROW" | rg -qi 'counsel container' || { echo "roots=failed"; echo "verdict=misread"; echo "detail=want_counsel_container"; exit 1; }
echo "$ROW" | rg -qi 'work reaches the tree|client surface' || {
  echo "roots=failed"
  echo "verdict=misread"
  echo "detail=want_tree_touch_category"
  exit 1
}
# Load-bearing: bench is a raised root; only a bench runs witnesses
echo "$ROW" | rg -qi 'holds a raise|raised' || {
  echo "bench_kinship=failed"
  echo "verdict=misread"
  echo "detail=want_raise_in_roots_row"
  exit 1
}
echo "$ROW" | rg -qi 'only a bench runs witnesses|only a Bench runs witnesses' || {
  echo "bench_kinship=failed"
  echo "verdict=misread"
  echo "detail=want_only_bench_runs_witnesses"
  exit 1
}
echo "$ROW" | rg -qi 'Name the root when a measurement' || {
  echo "bench_kinship=failed"
  echo "verdict=misread"
  echo "detail=want_name_the_root_law"
  exit 1
}
BENCH=$(rg -F '| **Bench** |' "$LEXICON" || true)
echo "$BENCH" | rg -qi 'root that holds a raise|Narrower than \*\*roots\*\*' || {
  echo "bench_kinship=failed"
  echo "verdict=misread"
  echo "detail=want_bench_row_kinship"
  exit 1
}
echo "roots=honored"
echo "bench_kinship=honored"
echo "roots_members=claude_web·claude_ios·cursor_appimage_desktop·cursor_ios·framework·counsel_container"
echo "law=name_the_root_when_a_measurement_is_reported"

rg -qi 'bench|raised root|roots amend' "$COUNSEL" "$ITINERARY" "$MAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

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

COUNT=$(git ls-files 'tools/gen/season/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$COUNT" -ne 6; then
  echo "surface_keep=failed"
  echo "verdict=misread"
  echo "surface_count=$COUNT"
  exit 1
fi
echo "surface_keep=honored"
echo "surface_count=6"

rg -q '^### 125\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=125"

git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e120"

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

echo "story=roots_amended>bench_raised_root>six_members>128_reserved"
echo "verdict=ok"
