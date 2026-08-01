#!/bin/sh
# Equinox e137 — historical seat; living edge corrected at e138 (accretion).
# Exit 0 when e137 counsel remains as dated testimony, amber kept,
# and living pins name e138 breach-withdrawn / accretion.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e137_amber_amphora_unify_scan.sh
#   sh tools/fixtures/equinox_e137_amber_amphora_unify_scan.sh prove-red
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/20260801-011942_e137-amber-amphora-unify-breach.md
E138=counsel/20260801-012557_e138-amber-retire-by-accretion.md
LEXICON=context/LEXICON.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
AMBER_README=amber/README.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_e137_breach_still_living_cut_plan"
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

for p in "$COUNSEL" "$E138" "$LEXICON" "$MAP" "$REMEMBER" "$AMBER_README" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# e137 counsel kept as dated over-seat testimony
rg -qi 'unify breach approved' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_e137_dated_seat"
  echo "verdict=misread"
  exit 1
}
echo "counsel=honored"
echo "e137_counsel=dated_testimony_kept"

# Living edge is e138 accretion
rg -qi 'withdrawn' "$E138" "$LEXICON" "$REMEMBER" || {
  echo "living=failed"
  echo "detail=want_e138_withdrawn"
  echo "verdict=misread"
  exit 1
}
rg -qi 'accretion' "$E138" "$LEXICON" || {
  echo "living=failed"
  echo "detail=want_accretion"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"
echo "breach=withdrawn_at_e138"
echo "pause=amber_pause"

AMBER_COUNT=$(git ls-files 'amber/*' | wc -l | tr -d ' ')
if test "$AMBER_COUNT" -lt 1; then
  echo "amber_kept=failed"
  echo "verdict=misread"
  exit 1
fi
echo "amber_kept=honored"
echo "amber_tracked=${AMBER_COUNT}"
echo "cut=none_this_stamp"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$REMEMBER" "$MAP" || {
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

echo "story=e137_dated>e138_accretion>amber_kept>shred_held>128_reserved"
echo "verdict=ok"
