#!/bin/sh
# Equinox e128 — Class O word-scope (class/rooms, not per-path).
# Exit 0 only when the framing is seated and the cut stays closed.
# No backtick characters. No git history walks.
#
#   sh tools/fixtures/equinox_e128_class_o_word_scope_scan.sh
#   sh tools/fixtures/equinox_e128_class_o_word_scope_scan.sh prove-red
#
# Law: Class O membership is a measured property; the census is authority.
# Law: Keaton's word is on the class and/or rooms — not on each filename.
# Law: kg with approvals seats the framing; it does not open the cut.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
SHED=tools/fixtures/shed_census_scan.sh
LEXICON=context/LEXICON.md
COUNSEL=counsel/date/20260731/20260731-232004_e128-class-o-word-scope.md
PREP=work-in-progress/SHRED_PREP.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
PRIN=tools/gen/season/prin_scope.rish
ELDER=tools/fixtures/equinox_e127_on_touch_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_class_o_per_path_tax"
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

for p in "$LEXICON" "$COUNSEL" "$PREP" "$MAP" "$REMEMBER" "$PRIN" "$ELDER" "$SHED"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Living pins carry word-scope
rg -qi 'word-scope|class and/or the rooms|class/rooms|not on each|not per-path|not on eight' "$COUNSEL" "$PREP" "$REMEMBER" "$MAP" || {
  echo "word_scope=failed"
  echo "detail=want_class_room_framing"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Class O' "$PREP" || {
  echo "word_scope=failed"
  echo "detail=want_class_o_in_prep"
  echo "verdict=misread"
  exit 1
}
echo "word_scope=honored"
echo "word_scope_law=class_and_rooms_not_per_path"

# Lexicon or living pins name the opening words / held cut
rg -qi 'Class O yes|shred Class O|shed .*room|circled shred yes|opening word' "$COUNSEL" "$PREP" "$REMEMBER" || {
  echo "opening=failed"
  echo "verdict=misread"
  exit 1
}
echo "opening=honored"
echo "opening_note=awaits_class_or_room_word"

# Fresh rooms named in SHRED_PREP
rg -q 'session-logs' "$PREP" || {
  echo "rooms=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'counsel' "$PREP" || {
  echo "rooms=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'waymarks' "$PREP" || {
  echo "rooms=failed"
  echo "verdict=misread"
  exit 1
}
rg -qi 'planted orphan control|keeps' "$PREP" "$COUNSEL" || {
  echo "rooms=failed"
  echo "detail=want_tools_control_keeps"
  echo "verdict=misread"
  exit 1
}
echo "rooms=honored"

# Elder on-touch still GREEN
ELDER_OUT=$(sh "$ELDER")
echo "$ELDER_OUT" | rg -q '^verdict=ok$' || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_note=e127_on_touch_kept"

# Cut still closed
rg -qi 'shred \*\*RED\*\*|shred=RED|shred RED|Amphora cut not opened' "$PREP" "$REMEMBER" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
if rg -qi 'shred=GREEN|Amphora cut opened|Class O cut LANDED' "$PREP" "$REMEMBER" "$MAP"; then
  echo "shred_gate=failed"
  echo "detail=cut_must_stay_closed"
  echo "verdict=misread"
  exit 1
fi
echo "shred_gate=honored"
echo "shred=RED"
echo "shred_note=approvals_seat_framing_not_the_cut"

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

rg -q '^### 127\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "verdict=misread"
  echo "detail=seat_128_must_stay_unspent"
  exit 1
fi
echo "almanac=honored"
echo "seats_through=127"
echo "no_content_seat_claimed=honored"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"
echo "campaign_climb=refused"

echo "story=class_o_word_scope>rooms_named>cut_held>128_reserved"
echo "verdict=ok"
