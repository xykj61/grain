#!/bin/sh
# Equinox e125 -- build stack seated (layer order - foundations first).
# Exit 0 only when Lexicon carries the stack and hard lines hold.
# No backtick characters. No git history walks.
#
#   sh tools/fixtures/equinox_e125_build_stack_scan.sh
#   sh tools/fixtures/equinox_e125_build_stack_scan.sh prove-red
#
# Law: do not prioritize an upper layer over the one beneath it.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
LEXICON=context/LEXICON.md
COUNSEL=counsel/date/20260731/20260731-230116_e125-build-stack.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
PRIN=tools/gen/season/prin_scope.rish
ELDER=tools/fixtures/equinox_e123_living_pin_guard_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_build_stack_mantra_first"
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
  echo "detail=want_build_stack_row"
  exit 1
fi
echo "$ROW" | rg -q 'sh' || { echo "stack=failed"; echo "detail=want_sh"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'rish' || { echo "stack=failed"; echo "detail=want_rish"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -qi 'glow' || { echo "stack=failed"; echo "detail=want_glow"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -qi 'tend' || { echo "stack=failed"; echo "detail=want_tend"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'docs-geode' || { echo "stack=failed"; echo "detail=want_docs_geode"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Aurora' || { echo "stack=failed"; echo "detail=want_aurora"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Caravan' || { echo "stack=failed"; echo "detail=want_caravan"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Tally' || { echo "stack=failed"; echo "detail=want_tally"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Mantra' || { echo "stack=failed"; echo "detail=want_mantra"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -q 'Weave' || { echo "stack=failed"; echo "detail=want_weave"; echo "verdict=misread"; exit 1; }
echo "$ROW" | rg -qi 'Distinct from \*\*priority cycle\*\*|Distinct from priority cycle' || {
  echo "stack=failed"
  echo "detail=want_distinct_from_priority_cycle"
  echo "verdict=misread"
  exit 1
}
# Order markers in the row -- sh before rish before glow (string positions)
SH_AT=$(printf '%s' "$ROW" | python3 -c 'import sys; s=sys.stdin.read(); print(s.find("sh"))')
RISH_AT=$(printf '%s' "$ROW" | python3 -c 'import sys; s=sys.stdin.read(); print(s.find("rish"))')
GLOW_AT=$(printf '%s' "$ROW" | python3 -c 'import sys; s=sys.stdin.read().lower(); print(s.find("glow"))')
DOCS_AT=$(printf '%s' "$ROW" | python3 -c 'import sys; s=sys.stdin.read(); print(s.find("docs-geode"))')
MANTRA_AT=$(printf '%s' "$ROW" | python3 -c 'import sys; s=sys.stdin.read(); print(s.find("Mantra"))')
if test "$SH_AT" -lt 0 || test "$RISH_AT" -lt 0 || test "$GLOW_AT" -lt 0 || test "$DOCS_AT" -lt 0 || test "$MANTRA_AT" -lt 0; then
  echo "stack=failed"
  echo "detail=order_marker_missing"
  echo "verdict=misread"
  exit 1
fi
if test "$SH_AT" -ge "$RISH_AT" || test "$RISH_AT" -ge "$GLOW_AT" || test "$GLOW_AT" -ge "$DOCS_AT" || test "$DOCS_AT" -ge "$MANTRA_AT"; then
  echo "stack=failed"
  echo "detail=layer_order_wrong"
  echo "verdict=misread"
  exit 1
fi
echo "stack=honored"
echo "stack_order=sh>rish>glow_tend>docs-geode>aurora_caravan_tally>mantra_weave"

rg -qi 'build stack|five refusals|not prioritizing rish over sh|layer order' "$COUNSEL" "$ITINERARY" "$MAP" || {
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

# Elder one-roof still GREEN
ELDER_OUT=$(sh "$ELDER")
echo "$ELDER_OUT" | rg -q '^one_roof=honored$' || {
  echo "elder=failed"
  echo "verdict=misread"
  echo "detail=want_one_roof"
  exit 1
}
echo "elder=honored"
echo "elder_note=one_roof_kept"

rg -q '^### 127\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
# Must NOT have spent 128
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
echo "shred=RED"

echo "story=build_stack>foundations_first>128_reserved"
echo "verdict=ok"
