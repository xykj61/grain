#!/bin/sh
# Equinox e137 — Amber→Amphora unify breach approved · gated · Amber pause.
# Exit 0 when counsel seats the breach, Lexicon retires Amber living,
# amber/ still tracked (no cut), shred RED, seat 128 reserved.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e137_amber_amphora_unify_scan.sh
#   sh tools/fixtures/equinox_e137_amber_amphora_unify_scan.sh prove-red
#
# Law: breach by declaration · cut gated · approve does not open shred.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/20260801-011942_e137-amber-amphora-unify-breach.md
LEXICON=context/LEXICON.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
REDS=work-in-progress/REDS.md
SHRED=work-in-progress/SHRED_PREP.md
ROADMAP=work-in-progress/ROADMAP.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
AMBER_README=amber/README.md
AMPHORA_README=amphora/README.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_amber_cut_without_opening_word"
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

for p in "$COUNSEL" "$LEXICON" "$MAP" "$REMEMBER" "$SHRED" "$ROADMAP" \
  "$AMBER_README" "$AMPHORA_README" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Counsel verdict
rg -qi 'unify breach approved' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_approved_seated_gated"
  echo "verdict=misread"
  exit 1
}
rg -qi 'gated' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_gated"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Amber pause' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_amber_pause"
  echo "verdict=misread"
  exit 1
}
rg -qi 'no cut this stamp|does \*\*not\*\* begin the cut' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_cut_gated"
  echo "verdict=misread"
  exit 1
}
rg -qi 'redact and shred' "$COUNSEL" || {
  echo "counsel=failed"
  echo "detail=want_redact_shred_plan"
  echo "verdict=misread"
  exit 1
}
echo "counsel=honored"
echo "breach=approved_seated_gated"
echo "pause=amber_pause"

# Lexicon — Amber retired living · Amphora carries cellar
rg -qi 'retired|RETIRED|retires' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_amber_retired"
  echo "verdict=misread"
  exit 1
}
rg -q '^\| \*\*Amber\*\*' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_amber_row"
  echo "verdict=misread"
  exit 1
}
rg -qi 'Amphora.*cellar|cellar.*Amphora|absorbs cellar|cellar \+ vessel|cellar and vessel' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_amphora_absorbs_cellar"
  echo "verdict=misread"
  exit 1
}
rg -qi 'e137|20260801.011942' "$LEXICON" || {
  echo "lexicon=failed"
  echo "detail=want_e137_stamp"
  echo "verdict=misread"
  exit 1
}
echo "lexicon=honored"

# Living pins name the seat
rg -qi 'Amber pause|amber-amphora|Amphora unify|Amber→Amphora|Amber.Amphora unify' "$REMEMBER" "$MAP" "$ROADMAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# SHRED_PREP names Amber retirement prep · cut not opened
rg -qi 'Amber retirement|amber retirement' "$SHRED" || {
  echo "shred_prep=failed"
  echo "detail=want_amber_retirement_row"
  echo "verdict=misread"
  exit 1
}
rg -qi 'cut not opened|cut still RED|shred \*\*RED\*\*|shred RED' "$SHRED" || {
  echo "shred_prep=failed"
  echo "detail=want_cut_held"
  echo "verdict=misread"
  exit 1
}
echo "shred_prep=honored"

# amber/ still tracked — no cut this stamp
AMBER_COUNT=$(git ls-files 'amber/*' | wc -l | tr -d ' ')
if test "$AMBER_COUNT" -lt 1; then
  echo "amber_kept=failed"
  echo "detail=amber_paths_missing_cut_too_early"
  echo "verdict=misread"
  exit 1
fi
echo "amber_kept=honored"
echo "amber_tracked=${AMBER_COUNT}"
echo "cut=none_this_stamp"

# amphora still present
AMPHORA_COUNT=$(git ls-files 'amphora/*' | wc -l | tr -d ' ')
if test "$AMPHORA_COUNT" -lt 1; then
  echo "amphora=failed"
  echo "verdict=misread"
  exit 1
fi
echo "amphora=honored"
echo "amphora_tracked=${AMPHORA_COUNT}"

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
echo "gates_kept=shred_safe_geode_128_amber_cut"

echo "story=amber_pause>amphora_unify_breach>gated>amber_kept>shred_held>128_reserved"
echo "verdict=ok"
