#!/bin/sh
# Equinox e135 — MantraPod living Radiant pass + affordable-witness law.
# Exit 0 when pitch/kin speak living names, REDS 46 seats, e112 stays fast-green.
# Does NOT run e115 (too slow for a casual seat — that is the law).
# No backtick characters.
#
#   sh tools/fixtures/equinox_e135_mantrapod_affordable_scan.sh
#   sh tools/fixtures/equinox_e135_mantrapod_affordable_scan.sh prove-red
#
# Law: a witness nobody can afford to run is a witness that stops being run.
# Law: foundations first · on-touch never campaign.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/20260801-005200_e135-mantrapod-affordable-witness.md
LEXICON=context/LEXICON.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
REDS=work-in-progress/REDS.md
PITCH=foundations/20260629-020012_mantrapod-venture-pitch.md
KIN=foundations/20260628-133212_the-device-that-forgets.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
E112=tools/fixtures/equinox_e112_date_dialect_witness_scan.sh
E115=tools/fixtures/equinox_e115_instrument_suite_scan.sh

if test "$MODE" = "prove-red"; then
  echo "detail=RED_pitch_still_reya_kaeden_rye_os"
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

for p in "$COUNSEL" "$LEXICON" "$MAP" "$REMEMBER" "$REDS" "$PITCH" "$KIN" \
  "$PRIN" "$E112" "$E115"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Pitch living voice / coauthor / umbrella
rg -q '^\*\*Voice:\*\* Riyo' "$PITCH" || {
  echo "pitch=failed"
  echo "detail=want_voice_riyo"
  echo "verdict=misread"
  exit 1
}
rg -q 'Keaton Livermore' "$PITCH" || {
  echo "pitch=failed"
  echo "detail=want_keaton_livermore"
  echo "verdict=misread"
  exit 1
}
rg -q 'siloed except for the Mantrapod and Grain names' "$PITCH" || {
  echo "pitch=failed"
  echo "detail=want_grain_silo_status"
  echo "verdict=misread"
  exit 1
}
rg -q 'Reya 2|Kaeden Reyklah|Rye OS' "$PITCH" && {
  echo "pitch=failed"
  echo "detail=stale_reya_kaeden_rye_os_still_present"
  echo "verdict=misread"
  exit 1
}
rg -q 'runs Grain on an open processor' "$PITCH" || {
  echo "pitch=failed"
  echo "detail=want_grain_on_open_processor"
  echo "verdict=misread"
  exit 1
}
echo "pitch=honored"
echo "pitch_living=riyo_keaton_grain"

# Kin essay living voice
rg -q '^\*\*Voice:\*\* Riyo' "$KIN" || {
  echo "kin=failed"
  echo "detail=want_voice_riyo"
  echo "verdict=misread"
  exit 1
}
rg -q 'Keaton Livermore' "$KIN" || {
  echo "kin=failed"
  echo "detail=want_keaton_livermore"
  echo "verdict=misread"
  exit 1
}
rg -q 'Reya 2|Kaeden Reyklah' "$KIN" && {
  echo "kin=failed"
  echo "detail=stale_reya_kaeden_still_present"
  echo "verdict=misread"
  exit 1
}
echo "kin=honored"

# Lexicon seats
rg -qi 'affordable witness' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_affordable_witness"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Mantrapod' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_mantrapod_entry"
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

# Counsel + living pins name the law
rg -qi 'afford to run|affordable witness' "$COUNSEL" "$REMEMBER" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# Fast elder still green — the scan that stayed honest because it is cheap
E112_OUT=$(sh "$E112")
echo "$E112_OUT" | rg -q '^verdict=ok$' || {
  echo "e112=failed"
  echo "verdict=misread"
  exit 1
}
echo "e112=honored"
echo "e112_note=fast_elder_still_green"

# e115 remains tracked; this seat refuses to nest it (law in action)
echo "e115=tracked_not_nested"
echo "e115_note=too_slow_for_casual_seat"

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

echo "story=mantrapod_living>affordable_witness>reds_46>e112_fast>e115_not_nested>shred_held>128_reserved"
echo "verdict=ok"
