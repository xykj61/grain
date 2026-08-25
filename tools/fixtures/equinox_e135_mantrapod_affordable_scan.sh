#!/bin/sh
# Equinox e135 -- affordable-witness law (REDS 46).
# Pitch claim rewrite was unlawful on a dated Vision artifact; e136 supersedes.
# This scan keeps the speed law and leaves MantraPod speech to e136.
# Exit 0 when REDS 46 seats, Lexicon names the law, e112 stays fast-green.
# Does NOT run e115 (too slow for a casual seat -- that is the law).
# No backtick characters.
#
#   sh tools/fixtures/equinox_e135_mantrapod_affordable_scan.sh
#   sh tools/fixtures/equinox_e135_mantrapod_affordable_scan.sh prove-red
#
# Law: a witness nobody can afford to run is a witness that stops being run.
# Law: foundations first - on-touch never campaign.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-005200_e135-mantrapod-affordable-witness.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
REDS=construction/REDS.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
E112=tools/fixtures/equinox_e112_date_dialect_witness_scan.sh
E115=tools/fixtures/equinox_e115_instrument_suite_scan.sh
ELDER_PITCH=foundations/20260629-020012_mantrapod-venture-pitch.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_affordable_witness_unseated"
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

for p in "$COUNSEL" "$LEXICON" "$MAP" "$ITINERARY" "$REDS" \
  "$PRIN" "$E112" "$E115" "$ELDER_PITCH"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Elder pitch must remain dated testimony (Reya - Kaeden - Rye OS) -- not rewritten
rg -q '^\*\*Voice:\*\* Reya 2' "$ELDER_PITCH" || {
  echo "elder_pitch=failed"
  echo "detail=want_elder_voice_reya_2"
  echo "verdict=misread"
  exit 1
}
rg -q 'Kaeden Reyklah' "$ELDER_PITCH" || {
  echo "elder_pitch=failed"
  echo "detail=want_elder_kaeden"
  echo "verdict=misread"
  exit 1
}
rg -q 'Rye OS' "$ELDER_PITCH" || {
  echo "elder_pitch=failed"
  echo "detail=want_elder_rye_os_testimony"
  echo "verdict=misread"
  exit 1
}
rg -q '^\*\*Voice:\*\* Riyo' "$ELDER_PITCH" && {
  echo "elder_pitch=failed"
  echo "detail=elder_must_not_carry_living_claim_rewrite"
  echo "verdict=misread"
  exit 1
}
echo "elder_pitch=honored"
echo "elder_pitch_note=dated_testimony_kept_whole"

# Lexicon seats affordable witness
rg -qi 'affordable witness' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_affordable_witness"
  echo "verdict=misread"
  exit 1
}
echo "lexicon=honored"

# REDS 46
rg -q '^\| 46 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_46"
  echo "verdict=misread"
  exit 1
}
rg -qi 'afford to run|stops being run' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_affordable_law"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_46_affordable_witness"

rg -qi 'afford to run|affordable witness' "$COUNSEL" "$ITINERARY" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

E112_OUT=$(sh "$E112")
echo "$E112_OUT" | rg -q '^verdict=ok$' || {
  echo "e112=failed"
  echo "verdict=misread"
  exit 1
}
echo "e112=honored"
echo "e112_note=fast_elder_still_green"

echo "e115=tracked_not_nested"
echo "e115_note=too_slow_for_casual_seat"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$ITINERARY" "$MAP" "$COUNSEL" || {
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

echo "story=affordable_witness>reds_46>elder_pitch_kept>e112_fast>e115_not_nested>shred_held>128_reserved"
echo "verdict=ok"
