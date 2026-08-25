#!/bin/sh
# Census Off-By-One law on held TigerStyle / TAME / clone / Grain.
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

GUIDE_OBO=no
if rg -q '### Off-By-One Errors' "$GUIDE"; then
  GUIDE_OBO=yes
fi

GUIDE_TYPES=no
if rg -q '`index`' "$GUIDE" \
  && rg -q '`count`' "$GUIDE" \
  && rg -q '`size`' "$GUIDE" \
  && rg -q '_0-based_' "$GUIDE" \
  && rg -q '_1-based_' "$GUIDE"; then
  GUIDE_TYPES=yes
fi

GUIDE_DIV=no
if rg -q '@divExact\(\)' "$GUIDE" \
  && rg -q '@divFloor\(\)' "$GUIDE" \
  && rg -q 'div_ceil\(\)' "$GUIDE"; then
  GUIDE_DIV=yes
fi

TAME_OBO=no
if rg -q '### Off-By-One Errors' "$TAME" \
  && rg -q 'Treat `index`, `count`, and `size` as distinct types' "$TAME" \
  && rg -q '0-based' "$TAME" \
  && rg -q '1-based' "$TAME" \
  && rg -q '@divExact\(\)' "$TAME" \
  && rg -q '@divFloor\(\)' "$TAME" \
  && rg -q 'div_ceil\(\)' "$TAME"; then
  TAME_OBO=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '### Off-By-One Errors' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '_0-based_' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '_1-based_' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '@divExact\(\)' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'div_ceil\(\)' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_CACHE=no
if test -f tools/gen/season/equinox_tigerbeetle_cache_surface_witness.rish \
  && test -f tools/gen/season/equinox_tigerbeetle_cache_surface_almanac.sh; then
  ELDER_CACHE=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_OBO=${GUIDE_OBO}"
echo "GUIDE_TYPES=${GUIDE_TYPES}"
echo "GUIDE_DIV=${GUIDE_DIV}"
echo "TAME_OBO=${TAME_OBO}"
echo "STYLE=${STYLE}"
echo "ELDER_CACHE=${ELDER_CACHE}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_OBO" = yes \
  && test "$GUIDE_TYPES" = yes \
  && test "$GUIDE_DIV" = yes \
  && test "$TAME_OBO" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_CACHE" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
