#!/bin/sh
# Equinox e122 — roots ≠ Bench · name the Bench when a measurement is reported.
# Exit 0 only when control reads and kinds limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e122_roots_bench_kinds_scan.sh
#   sh tools/fixtures/equinox_e122_roots_bench_kinds_scan.sh prove-red
#
# Law: when two roofs carry one name, either they agree or the name does two jobs.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
LEXICON=context/LEXICON.md
COUNSEL=counsel/date/20260731/20260731-221131_e122-roots-bench-kinds.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
ELDER=tools/gen/season/equinox_e121_roots_bench_amend_witness.rish

if test "$MODE" = "prove-red"; then
  echo "kinds=blurred"
  echo "detail=RED_claimed_bench_is_raised_root"
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

# ITINERARY must not be empty (e121 wipe lesson)
REM_BYTES=$(wc -c < "$ITINERARY" | tr -d ' ')
if test "$REM_BYTES" -lt 1000; then
  echo "remember=failed"
  echo "verdict=misread"
  echo "detail=remember_empty_or_thin"
  exit 1
fi
echo "remember_bytes=$REM_BYTES"
echo "remember=honored"

ROW=$(rg -F '| **roots** |' "$LEXICON" || true)
if test -z "$ROW"; then
  echo "roots=failed"
  echo "verdict=misread"
  exit 1
fi
echo "$ROW" | rg -q 'Claude web' || { echo "roots=failed"; echo "detail=want_claude_web"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Claude iOS' || { echo "roots=failed"; echo "detail=want_claude_ios"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Cursor AppImage desktop' || { echo "roots=failed"; echo "detail=want_cursor_appimage"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Cursor iOS' || { echo "roots=failed"; echo "detail=want_cursor_ios"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -qi 'hand sits to send words|where the hand sits' || {
  echo "roots=failed"
  echo "detail=want_hand_sits"
  echo "verdict=misread"
  exit 1
}
# Must NOT fold Framework / counsel container into roots members
if echo "$ROW" | rg -qi 'Framework itself|counsel container in the cloud'; then
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=roots_must_not_fold_framework_or_container"
  exit 1
fi
# Must NOT claim bench is a raised root / subtype
if echo "$ROW" | rg -qi 'holds a raise|raised root|is a \*\*Bench\*\*'; then
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=roots_must_not_claim_bench_subtype"
  exit 1
fi
# Must distinguish Bench · pier · Pond
echo "$ROW" | rg -qi 'not the \*\*Bench\*\*|not the Bench' || {
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=want_not_bench"
  exit 1
}
echo "$ROW" | rg -qi 'pier' || { echo "kinds=failed"; echo "detail=want_pier"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -qi 'Pond' || { echo "kinds=failed"; echo "detail=want_pond"; echo "verdict=misread"; exit 1; }

BENCH=$(rg -F '| **Bench** |' "$LEXICON" || true)
echo "$BENCH" | rg -qi 'claims become evidence' || {
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=want_bench_evidence"
  exit 1
}
# Bench must not say it is a root that holds a raise
if echo "$BENCH" | rg -qi 'root that holds a raise|Narrower than \*\*roots\*\*'; then
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=bench_must_not_be_root_subtype"
  exit 1
fi
echo "$BENCH" | rg -qi 'Name the \*\*Bench\*\* when a measurement|Name the Bench when a measurement' || {
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=want_name_the_bench_law"
  exit 1
}
echo "roots=honored"
echo "kinds=honored"
echo "roots_members=claude_web·claude_ios·cursor_appimage_desktop·cursor_ios"
echo "law=name_the_bench_when_a_measurement_is_reported"

rg -qi 'name the Bench|roots ≠ Bench|different kind|kinds restored|un-blur|refused' "$COUNSEL" "$ITINERARY" "$MAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
# Living pins must not keep e121 blur as current truth
if rg -qi 'bench = raised root|bench equals raised root' "$ITINERARY" "$MAP" "$PRIN"; then
  echo "living=failed"
  echo "verdict=misread"
  echo "detail=stale_e121_blur_still_standing"
  exit 1
fi
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

echo "elder=honored"
echo "elder_seat=e121"
echo "elder_note=e121_blur_dated_e122_corrects"

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
echo "bench_used=Cursor_Cloud_root"

echo "story=roots_four>kinds_restored>name_the_bench>128_reserved"
echo "verdict=ok"
