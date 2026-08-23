#!/bin/sh
# Equinox e136 — supersede MantraPod pitch; restore dated elder; seat REDS 47.
# Exit 0 when elder is whole testimony, new dated pitch names Grain, dated_guard clean.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e136_mantrapod_supersede_scan.sh
#   sh tools/fixtures/equinox_e136_mantrapod_supersede_scan.sh prove-red
#
# Law: a dated artifact is immutable unless it declares living or freezes.
# Law: accrete-never-break — supersede rather than silent claim rewrite.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
DATED_GUARD=tools/fixtures/dated_guard_scan.sh
COUNSEL=counsel/date/20260801/20260801-005853_e136-mantrapod-supersede.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
REMEMBER=construction/REMEMBER.md
REDS=construction/REDS.md
README=foundations/README.md
ELDER=foundations/20260629-020012_mantrapod-venture-pitch.md
KIN=foundations/20260628-133212_the-device-that-forgets.md
NEW=foundations/20260801-005853_mantrapod-venture-pitch.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
E135=tools/fixtures/equinox_e135_mantrapod_affordable_scan.sh

if test "$MODE" = "prove-red"; then
  echo "detail=RED_dated_vision_claim_rewritten_in_place"
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

for p in "$COUNSEL" "$LEXICON" "$MAP" "$REMEMBER" "$REDS" "$README" \
  "$ELDER" "$KIN" "$NEW" "$DATED_GUARD" "$E135" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Elder pitch — dated testimony restored
rg -q '^\*\*Stamp:\*\* `20260629.020012`' "$ELDER" || {
  echo "elder=failed"
  echo "detail=want_stamp_20260629"
  echo "verdict=misread"
  exit 1
}
rg -q '^\*\*Voice:\*\* Reya 2' "$ELDER" || {
  echo "elder=failed"
  echo "detail=want_reya_2"
  echo "verdict=misread"
  exit 1
}
rg -q 'Kaeden Reyklah' "$ELDER" || {
  echo "elder=failed"
  echo "detail=want_kaeden"
  echo "verdict=misread"
  exit 1
}
rg -q 'Rye OS' "$ELDER" || {
  echo "elder=failed"
  echo "detail=want_rye_os_testimony"
  echo "verdict=misread"
  exit 1
}
rg -q '^\*\*Voice:\*\* Riyo|Keaton Livermore|runs Grain on' "$ELDER" && {
  echo "elder=failed"
  echo "detail=elder_still_carries_living_rewrite"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_note=dated_vision_kept_whole"

# Kin essay restored (same e135 breach surface)
rg -q '^\*\*Voice:\*\* Reya 2' "$KIN" || {
  echo "kin=failed"
  echo "detail=want_reya_2"
  echo "verdict=misread"
  exit 1
}
rg -q 'Kaeden Reyklah' "$KIN" || {
  echo "kin=failed"
  echo "detail=want_kaeden"
  echo "verdict=misread"
  exit 1
}
rg -q 'Keaton Livermore' "$KIN" && {
  echo "kin=failed"
  echo "detail=kin_still_carries_living_rewrite"
  echo "verdict=misread"
  exit 1
}
rg -q '20260629-020012_mantrapod-venture-pitch' "$KIN" || {
  echo "kin=failed"
  echo "detail=want_kin_pointer_to_elder_pitch"
  echo "verdict=misread"
  exit 1
}
echo "kin=honored"
echo "kin_note=dated_essay_kept_whole"

# New dated pitch — living speech of Grain
rg -q '^\*\*Stamp:\*\* `20260801.005853`' "$NEW" || {
  echo "new_pitch=failed"
  echo "detail=want_stamp_20260801_005853"
  echo "verdict=misread"
  exit 1
}
rg -q '^\*\*Voice:\*\* Riyo' "$NEW" || {
  echo "new_pitch=failed"
  echo "detail=want_voice_riyo"
  echo "verdict=misread"
  exit 1
}
rg -q 'Keaton Livermore' "$NEW" || {
  echo "new_pitch=failed"
  echo "detail=want_keaton"
  echo "verdict=misread"
  exit 1
}
rg -q 'Supersedes:' "$NEW" || {
  echo "new_pitch=failed"
  echo "detail=want_supersedes_pointer"
  echo "verdict=misread"
  exit 1
}
rg -q '20260629-020012_mantrapod-venture-pitch' "$NEW" || {
  echo "new_pitch=failed"
  echo "detail=want_supersedes_elder_path"
  echo "verdict=misread"
  exit 1
}
rg -q 'runs Grain on an open processor' "$NEW" || {
  echo "new_pitch=failed"
  echo "detail=want_grain"
  echo "verdict=misread"
  exit 1
}
rg -q 'Rye OS' "$NEW" && {
  echo "new_pitch=failed"
  echo "detail=new_pitch_must_not_say_rye_os"
  echo "verdict=misread"
  exit 1
}
echo "new_pitch=honored"
echo "new_pitch_living=riyo_keaton_grain"

# README points at superseding pitch
rg -q '20260801-005853_mantrapod-venture-pitch' "$README" || {
  echo "readme=failed"
  echo "detail=want_new_pitch_listed"
  echo "verdict=misread"
  exit 1
}
rg -q '20260629-020012_mantrapod-venture-pitch' "$README" || {
  echo "readme=failed"
  echo "detail=want_elder_kept_listed"
  echo "verdict=misread"
  exit 1
}
echo "readme=honored"

# Lexicon points at superseding pitch
rg -q '20260801-005853_mantrapod-venture-pitch' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_new_pitch_in_lexicon"
  echo "verdict=misread"
  exit 1
}
rg -qi 'supersede|accrete-never-break' "$LEXICON" "$COUNSEL" || {
  echo "lexicon=failed"
  echo "detail=want_supersede_law_named"
  echo "verdict=misread"
  exit 1
}
echo "lexicon=honored"

# REDS 47 — in-place dated claim rewrite
rg -q '^\| 47 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_47"
  echo "verdict=misread"
  exit 1
}
rg -qi 'dated|immutable|supersede' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_dated_breach_law"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_47_dated_vision_in_place"

rg -qi 'supersede|dated artifact|kept whole' "$COUNSEL" "$REMEMBER" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# e135 still greens with corrected asserts
E135_OUT=$(sh "$E135")
echo "$E135_OUT" | rg -q '^verdict=ok$' || {
  echo "e135=failed"
  echo "verdict=misread"
  exit 1
}
echo "e135=honored"

# dated_guard — with elders restored and no unlawful claim rewrite staged as living speech
GUARD_OUT=$(sh "$DATED_GUARD")
echo "$GUARD_OUT" | sed 's/^/dated_guard_/'
echo "$GUARD_OUT" | rg -q 'OK   dated-guard clean|OK   no staged MODIFIED dated paths' || {
  echo "dated_guard=failed"
  echo "verdict=misread"
  exit 1
}
echo "dated_guard=honored"

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

echo "story=supersede_pitch>elder_kept>kin_kept>reds_47>dated_guard>e135_green>shred_held>128_reserved"
echo "verdict=ok"
