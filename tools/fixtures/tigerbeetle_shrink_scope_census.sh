#!/bin/sh
# Census Shrink-scope / POCPOU law on held TigerStyle / TAME / clone / Grain.
# Clean-room study only -- prints presence; never copies into rye/.
set -eu
ROOT="${1:-gratitude/tigerbeetle}"
GUIDE=gratitude/TIGER_STYLE.md
TAME=external-research/TAME_GUIDANCE.md

if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 2
fi

REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)

GUIDE_SHRINK=no
if rg -q '\*\*Shrink the scope\*\*' "$GUIDE"; then
  GUIDE_SHRINK=yes
fi

GUIDE_POCPOU=no
if rg -q "Don't introduce variables before" "$GUIDE" \
  && rg -q 'POCPOU \(place-of-check to place-of-use\)' "$GUIDE"; then
  GUIDE_POCPOU=yes
fi

TAME_SHRINK=no
if rg -q '\*\*Shrink the scope\*\*' "$TAME" \
  && rg -q '\*\*Compute and check variables close to where they are used\.\*\*' "$TAME" \
  && rg -q 'semantic distance' "$TAME"; then
  TAME_SHRINK=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '\*\*Shrink the scope\*\*' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q "Don't introduce variables before" "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'POCPOU \(place-of-check to place-of-use\)' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_CACHE=no
if test -f tools/fixtures/tigerbeetle_cache_inplace_census.sh \
  && test -f tools/gen/season/tigerbeetle_cache_inplace_census_witness.rish; then
  ELDER_CACHE=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_SHRINK=${GUIDE_SHRINK}"
echo "GUIDE_POCPOU=${GUIDE_POCPOU}"
echo "TAME_SHRINK=${TAME_SHRINK}"
echo "STYLE=${STYLE}"
echo "ELDER_CACHE=${ELDER_CACHE}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_SHRINK" = yes \
  && test "$GUIDE_POCPOU" = yes \
  && test "$TAME_SHRINK" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_CACHE" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
