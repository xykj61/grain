#!/bin/sh
# Equinox e138 -- Cellar retire by accretion - e137 breach withdrawn.
# Exit 0 when Lexicon keeps cellar/vessel complements, cellar witness greens,
# breach withdrawn, no shred plan for cellar, shred RED, 128 reserved.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e138_cellar_accretion_scan.sh
#   sh tools/fixtures/equinox_e138_cellar_accretion_scan.sh prove-red
#
# Law: retire by accretion - breach after consumers is owed - build nothing that destroys.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-012557_e138-cellar-retire-by-accretion.md
ELDER=counsel/date/20260801/20260801-011942_e137-cellar-amphora-unify-breach.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
REDS=construction/REDS.md
SHRED=construction/SHRED_PREP.md
ROADMAP=construction/ROADMAP.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
CELLAR_README=cellar/README.md
CELLAR_WITNESS=tools/ce/cellar_first_ring.rish
RISHI=rishi/bin/rishi

if test "$MODE" = "prove-red"; then
  echo "detail=RED_cellar_shred_plan_still_living"
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

for p in "$COUNSEL" "$ELDER" "$LEXICON" "$MAP" "$ITINERARY" "$REDS" "$SHRED" \
  "$ROADMAP" "$CELLAR_README" "$CELLAR_WITNESS" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Counsel -- accretion - breach withdrawn
rg -qi 'retire by accretion|retired by accretion' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_accretion"
  echo "verdict=misread"
  exit 1
}
rg -qi 'withdrawn' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_breach_withdrawn"
  echo "verdict=misread"
  exit 1
}
rg -qi 'build nothing that destroys|custody first' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_custody_first"
  echo "verdict=misread"
  exit 1
}
echo "counsel=honored"
echo "breach=withdrawn_to_accretion"
echo "retirement=by_accretion"

# Lexicon -- Cellar accretion - Amphora vessel (not cellar absorb)
rg -qi 'accretion|Retired by accretion|retire by accretion' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_accretion_in_lexicon"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Absorbs cellar|cellar \*\*and\*\* vessel under one living name|Unified under Amphora' "$LEXICON" && {
  echo "lexicon=failed"
  echo "detail=living_still_folds_cellar_into_amphora"
  echo "verdict=misread"
  exit 1
}
rg -q '^\| \*\*Amphora\*\* \| \*\*Vessel software\*\*' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_amphora_vessel_row"
  echo "verdict=misread"
  exit 1
}
rg -qi 'complements|in place|in motion' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_pair_complements"
  echo "verdict=misread"
  exit 1
}
echo "lexicon=honored"

# REDS 48
sh tools/fixtures/reds_row_present.sh 48 >/dev/null || {
  echo "reds=failed"
  echo "detail=want_row_48"
  echo "verdict=misread"
  exit 1
}
sh tools/fixtures/reds_spine_grep.sh -i 'accretion|outside consumer|complements' >/dev/null || {
  echo "reds=failed"
  echo "detail=want_accretion_law"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_48_retire_by_accretion"

# SHRED_PREP -- Cellar shred plan refused
rg -qi 'refused|accretion|no shred of Cellar|Cellar kept whole' "$SHRED" || {
  echo "shred_prep=failed"
  echo "detail=want_cellar_shred_refused"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Plan \| redact Cellar|shred `cellar/`' "$SHRED" && {
  echo "shred_prep=failed"
  echo "detail=living_cellar_shred_plan_still_present"
  echo "verdict=misread"
  exit 1
}
echo "shred_prep=honored"

# Living pins
rg -qi 'accretion|breach withdrawn|retire by accretion' "$ITINERARY" "$MAP" "$ROADMAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# cellar/ kept
CELLAR_COUNT=$(git ls-files 'cellar/*' | wc -l | tr -d ' ')
if test "$CELLAR_COUNT" -lt 1; then
  echo "cellar_kept=failed"
  echo "verdict=misread"
  exit 1
fi
echo "cellar_kept=honored"
echo "cellar_tracked=${CELLAR_COUNT}"

# cellar witness green
if ! test -x "$RISHI" && ! test -f "$RISHI"; then
  echo "cellar_witness=failed"
  echo "detail=rishi_absent"
  echo "verdict=misread"
  exit 1
fi
WIT_OUT=$("$RISHI" run "$CELLAR_WITNESS" 2>&1) || {
  echo "cellar_witness=failed"
  echo "detail=exit_nonzero"
  echo "verdict=misread"
  exit 1
}
echo "$WIT_OUT" | rg -qi 'GREEN: cellar first lap witness passed|GREEN: cellar first ring' || {
  echo "cellar_witness=failed"
  echo "detail=want_green"
  echo "verdict=misread"
  exit 1
}
echo "cellar_witness=honored"
echo "cellar_witness_note=parity_144_green"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$ITINERARY" "$MAP" "$COUNSEL" "$SHRED" || {
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

echo "story=accretion_retirement>breach_withdrawn>cellar_whole>witness_green>shred_held>128_reserved"
echo "verdict=ok"
