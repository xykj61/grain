#!/bin/sh
# Equinox e127 — shell ratchet on-touch, never a campaign.
# Exit 0 only when Lexicon carries the correction and hard lines hold.
# No backtick characters. No git history walks.
#
#   sh tools/fixtures/equinox_e127_on_touch_scan.sh
#   sh tools/fixtures/equinox_e127_on_touch_scan.sh prove-red
#
# Law: foundations first — sh is where work correctly begins.
# Law: shell ratchet on-touch — never a rish-first campaign.
# Law: kg / best path name leans; they do not circle shred yes.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
LEXICON=context/LEXICON.md
COUNSEL=counsel/date/20260731/20260731-231509_e127-on-touch-never-campaign.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
REDS=construction/REDS.md
PRIN=tools/gen/season/prin_scope.rish
ELDER_START=tools/fixtures/equinox_e126_start_rung_scan.sh
ELDER_STACK=tools/fixtures/equinox_e125_build_stack_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_on_touch_rish_first_campaign"
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

for p in "$LEXICON" "$COUNSEL" "$MAP" "$ITINERARY" "$REDS" "$PRIN" "$ELDER_START" "$ELDER_STACK"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

ROW=$(rg -F '| **build stack** |' "$LEXICON" || true)
if test -z "$ROW"; then
  echo "stack=failed"
  echo "verdict=misread"
  exit 1
fi
echo "$ROW" | rg -qi 'on-touch' || {
  echo "on_touch=failed"
  echo "detail=want_on_touch_in_lexicon"
  echo "verdict=misread"
  exit 1
}
echo "$ROW" | rg -qi 'never a campaign|never campaign' || {
  echo "on_touch=failed"
  echo "detail=want_never_a_campaign"
  echo "verdict=misread"
  exit 1
}
echo "$ROW" | rg -qi 'start rung' || {
  echo "on_touch=failed"
  echo "detail=want_start_rung_kept"
  echo "verdict=misread"
  exit 1
}
echo "on_touch=honored"
echo "on_touch_law=shell_ratchet_on_touch_never_campaign"

rg -qi 'on-touch|never a campaign|sh is where work correctly begins|circled shred' "$COUNSEL" "$ITINERARY" "$MAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# REDS row 42 owns the backwards reading
rg -q '^\| 42 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_42"
  echo "verdict=misread"
  exit 1
}
rg -qi 'on-touch|campaign|ladder|foundations first' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_42_lesson"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_42_counsel_ladder_direction"

# Elders still GREEN
for elder in "$ELDER_STACK" "$ELDER_START"; do
  ELDER_OUT=$(sh "$elder")
  echo "$ELDER_OUT" | rg -q '^verdict=ok$' || {
    echo "elder=failed"
    echo "detail=want_elder_ok"
    echo "elder_path=$elder"
    echo "verdict=misread"
    exit 1
  }
done
echo "elder=honored"
echo "elder_note=e125_e126_kept"

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

# shred still RED — this sitting does not cut
rg -qi 'shred.*RED|shred \*\*RED\*\*|circled shred yes' "$ITINERARY" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
if rg -qi 'shred=GREEN|shred YES circled|Amphora cut opened' "$ITINERARY" "$MAP"; then
  echo "shred_gate=failed"
  echo "detail=shred_must_stay_red"
  echo "verdict=misread"
  exit 1
fi
echo "shred_gate=honored"
echo "shred=RED"
echo "shred_note=kg_best_path_does_not_circle_shred_yes"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"

echo "story=on_touch>never_campaign>shred_held>128_reserved"
echo "verdict=ok"
