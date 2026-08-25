#!/bin/sh
# Census Cache Invalidation / in-place law on held TigerStyle / TAME / clone / Grain.
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

GUIDE_CACHE=no
if rg -q '### Cache Invalidation' "$GUIDE"; then
  GUIDE_CACHE=yes
fi

GUIDE_NODUP=no
if rg -q "Don't duplicate variables or take aliases to them" "$GUIDE"; then
  GUIDE_NODUP=yes
fi

GUIDE_INPLACE=no
if rg -q 'Construct larger structs _in-place_ by passing an _out pointer_' "$GUIDE" \
  && rg -q 'pointer stability' "$GUIDE"; then
  GUIDE_INPLACE=yes
fi

TAME_CACHE=no
if rg -q '### Cache Invalidation' "$TAME" \
  && rg -q 'Avoid duplicating variables or aliasing them' "$TAME" \
  && rg -q 'Build larger structs in place' "$TAME" \
  && rg -q 'out-pointer' "$TAME" \
  && rg -q 'pointer stability' "$TAME"; then
  TAME_CACHE=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '### Cache Invalidation' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q "Don't duplicate variables or take aliases to them" "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Construct larger structs _in-place_ by passing an _out pointer_' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'pointer stability' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_HOW=no
if test -f tools/fixtures/tigerbeetle_say_how_census.sh \
  && test -f tools/gen/season/tigerbeetle_say_how_census_witness.rish; then
  ELDER_HOW=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_CACHE=${GUIDE_CACHE}"
echo "GUIDE_NODUP=${GUIDE_NODUP}"
echo "GUIDE_INPLACE=${GUIDE_INPLACE}"
echo "TAME_CACHE=${TAME_CACHE}"
echo "STYLE=${STYLE}"
echo "ELDER_HOW=${ELDER_HOW}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_CACHE" = yes \
  && test "$GUIDE_NODUP" = yes \
  && test "$GUIDE_INPLACE" = yes \
  && test "$TAME_CACHE" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_HOW" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
