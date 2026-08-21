#!/bin/sh
# Commence M9 ascent scan — control gate, then handback ascent + arc close.
# Exit 0 only when control reads and every ascent limb honors.
# No backtick characters in patterns.
#
#   sh tools/fixtures/commence_m9_ascent_scan.sh
#
# Law: no duty reports a total until its planted control reads correctly.
# Ascent: consumed handbacks outward · nested return still waiting · arc closes.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
SAGA_PROSE=saga/20260731-130200_saga-of-the-commence-arc.md
PRIN=tools/gen/season/prin_scope.rish
SAGA_README=saga/README.md

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
  echo "detail=control_must_read_before_totals"
  exit 1
}
echo "control_gate=honored"

# --- prose saga proposed (counsel cross) ---
git ls-files --error-unmatch "$SAGA_PROSE" >/dev/null 2>&1 || {
  echo "ascent_saga=failed"
  echo "verdict=misread"
  echo "detail=commence_saga_untracked"
  exit 1
}
rg -q 'trust the tree, test the instrument' "$SAGA_PROSE" || {
  echo "ascent_saga=failed"
  echo "verdict=misread"
  echo "detail=saga_motto_missing"
  exit 1
}
# Elder M9 accepted Proposed; after e101 seating, Seated also honors.
if rg -q '\*\*Seated\*\*' "$SAGA_PROSE"; then
  SAGA_STATUS=SEATED
elif rg -q '\*\*Proposed\*\*' "$SAGA_PROSE"; then
  SAGA_STATUS=PROPOSED
else
  echo "ascent_saga=failed"
  echo "verdict=misread"
  echo "detail=saga_status_missing"
  exit 1
fi
rg -q 'Season Close Narratives' "$SAGA_README" || {
  echo "ascent_saga=failed"
  echo "verdict=misread"
  echo "detail=saga_home_missing"
  exit 1
}
echo "ascent_saga=honored"
echo "ascent_saga_status=${SAGA_STATUS}"


# --- commence waymark chain through M8 (nine beats) ---
BEATS_OK=0
BEATS_WANT=9
while IFS='|' read -r label path; do
  test -n "$label" || continue
  if git ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    echo "ascent_beat_${label}=present"
    BEATS_OK=$((BEATS_OK + 1))
  else
    echo "ascent_beat_${label}=ABSENT"
    echo "ascent_chain=failed"
    echo "verdict=misread"
    echo "detail=missing_${path}"
    exit 1
  fi
done <<'BEATS'
M1|waymarks/date/20260731/20260731-014410_commence-m1-census-green.md
M2|waymarks/date/20260731/20260731-020306_commence-m2-glow-rune-census-green.md
e93|waymarks/date/20260731/20260731-114927_e93-ironbeetle-ep044-ch7-open-green.md
e94|waymarks/date/20260731/20260731-115725_e94-ironbeetle-ep045-green.md
M4b|waymarks/date/20260731/20260731-120704_e95-census-control-ch7-green.md
M5|waymarks/date/20260731/20260731-122009_e96-commence-m5-recut-green.md
M6|waymarks/date/20260731/20260731-124325_e97-commence-m6-see-green.md
M7|waymarks/date/20260731/20260731-124815_e98-commence-m7-shed-weave-green.md
M8|waymarks/date/20260731/20260731-130233_e99-commence-m8-saga-green.md
BEATS

if test "$BEATS_OK" -ne "$BEATS_WANT"; then
  echo "ascent_chain=failed"
  echo "verdict=misread"
  exit 1
fi
echo "ascent_chain=honored"
echo "ascent_beats=${BEATS_OK}"

# --- handback ascent (consumed outward · nested waiting) ---
for needle in \
  'voice_handback_consumed: return_equinox_e7' \
  'fascia_handback_consumed: return_voice_j4_d10' \
  'sunn_handback_consumed: return_equinox_e50' \
  'equinox_handback: return_surface_p59'
do
  rg -q -F "$needle" "$PRIN" || {
    echo "ascent_handbacks=failed"
    echo "verdict=misread"
    echo "detail=missing_prin_line"
    exit 1
  }
done
# Nested equinox handback must NOT read CONSUMED in prin_scope living line.
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "ascent_handbacks=failed"
  echo "verdict=misread"
  echo "detail=nested_handback_must_stay_unconsumed"
  exit 1
fi
rg -q 'return_sunn_sunn8 CONSUMED' "$PRIN" || {
  echo "ascent_handbacks=failed"
  echo "verdict=misread"
  echo "detail=pole_handback_missing"
  exit 1
}
echo "ascent_handbacks=honored"
echo "ascent_consumed=voice+fascia+sunn+pole"
echo "ascent_nested=return_surface_p59"
echo "ascent_nested_status=not_consumed"

# --- almanac seats 97-103 · ch7 at least 7/16 ---
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*)
    echo "ascent_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_ascent_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "ascent_almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "ascent_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "ascent_almanac=honored"
echo "ascent_ch7_line=$CH7_LINE"
echo "ascent_seats=97-103"

# --- shelf end · shred standing ---
EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "ascent_shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "ascent_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "ascent_shelf=honored"
echo "ascent_shelf_end=ep045"
echo "ascent_ep046=absent"
echo "shred=RED"

echo "ascent_story=handbacks_consumed_outward>nested_waiting>commence_M1-M8_complete>saga_proposed>M9_closes_arc"
echo "m9_ascent=ok"
echo "verdict=ok"
