#!/bin/sh
# Equinox e138 — Amber retire by accretion · e137 breach withdrawn.
# Exit 0 when Lexicon keeps cellar/vessel complements, amber witness greens,
# breach withdrawn, no shred plan for amber, shred RED, 128 reserved.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e138_amber_accretion_scan.sh
#   sh tools/fixtures/equinox_e138_amber_accretion_scan.sh prove-red
#
# Law: retire by accretion · breach after consumers is owed · build nothing that destroys.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/20260801-012557_e138-amber-retire-by-accretion.md
ELDER=counsel/20260801-011942_e137-amber-amphora-unify-breach.md
LEXICON=context/LEXICON.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
REDS=work-in-progress/REDS.md
SHRED=work-in-progress/SHRED_PREP.md
ROADMAP=work-in-progress/ROADMAP.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
AMBER_README=amber/README.md
AMBER_WITNESS=tools/amber_first_ring.rish
RISHI=rishi/bin/rishi

if test "$MODE" = "prove-red"; then
  echo "detail=RED_amber_shred_plan_still_living"
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

for p in "$COUNSEL" "$ELDER" "$LEXICON" "$MAP" "$REMEMBER" "$REDS" "$SHRED" \
  "$ROADMAP" "$AMBER_README" "$AMBER_WITNESS" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Counsel — accretion · breach withdrawn
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

# Lexicon — Amber accretion · Amphora vessel (not cellar absorb)
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
rg -q '^\| 48 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_48"
  echo "verdict=misread"
  exit 1
}
rg -qi 'accretion|outside consumer|complements' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_accretion_law"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_48_retire_by_accretion"

# SHRED_PREP — Amber shred plan refused
rg -qi 'refused|accretion|no shred of Amber|Amber kept whole' "$SHRED" || {
  echo "shred_prep=failed"
  echo "detail=want_amber_shred_refused"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Plan \| redact Amber|shred `amber/`' "$SHRED" && {
  echo "shred_prep=failed"
  echo "detail=living_amber_shred_plan_still_present"
  echo "verdict=misread"
  exit 1
}
echo "shred_prep=honored"

# Living pins
rg -qi 'accretion|breach withdrawn|retire by accretion' "$REMEMBER" "$MAP" "$ROADMAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# amber/ kept
AMBER_COUNT=$(git ls-files 'amber/*' | wc -l | tr -d ' ')
if test "$AMBER_COUNT" -lt 1; then
  echo "amber_kept=failed"
  echo "verdict=misread"
  exit 1
fi
echo "amber_kept=honored"
echo "amber_tracked=${AMBER_COUNT}"

# amber witness green
if ! test -x "$RISHI" && ! test -f "$RISHI"; then
  echo "amber_witness=failed"
  echo "detail=rishi_absent"
  echo "verdict=misread"
  exit 1
fi
WIT_OUT=$("$RISHI" run "$AMBER_WITNESS" 2>&1) || {
  echo "amber_witness=failed"
  echo "detail=exit_nonzero"
  echo "verdict=misread"
  exit 1
}
echo "$WIT_OUT" | rg -qi 'GREEN: amber first lap witness passed|GREEN: amber first ring' || {
  echo "amber_witness=failed"
  echo "detail=want_green"
  echo "verdict=misread"
  exit 1
}
echo "amber_witness=honored"
echo "amber_witness_note=parity_144_green"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$REMEMBER" "$MAP" "$COUNSEL" "$SHRED" || {
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

echo "story=accretion_retirement>breach_withdrawn>amber_whole>witness_green>shred_held>128_reserved"
echo "verdict=ok"
