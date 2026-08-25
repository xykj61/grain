#!/bin/sh
# Census Buffer-bleeds / alloc-grouping law on held TigerStyle / TAME / clone / Grain.
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

GUIDE_BLEED=no
if rg -q 'buffer bleeds' "$GUIDE" \
  && rg -q 'buffer underflow' "$GUIDE"; then
  GUIDE_BLEED=yes
fi

GUIDE_GROUP=no
if rg -q 'group resource allocation and deallocation' "$GUIDE" \
  && rg -q 'defer' "$GUIDE"; then
  GUIDE_GROUP=yes
fi

TAME_BLEED=no
if rg -q 'Stay alert to buffer bleeds' "$TAME" \
  && rg -q 'buffer underflow' "$TAME" \
  && rg -q 'Group allocation and deallocation with newlines' "$TAME" \
  && rg -q 'defer' "$TAME"; then
  TAME_BLEED=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'buffer bleeds' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'buffer underflow' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'group resource allocation and deallocation' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_SHRINK=no
if test -f tools/fixtures/tigerbeetle_shrink_scope_census.sh \
  && test -f tools/gen/season/tigerbeetle_shrink_scope_census_witness.rish; then
  ELDER_SHRINK=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_BLEED=${GUIDE_BLEED}"
echo "GUIDE_GROUP=${GUIDE_GROUP}"
echo "TAME_BLEED=${TAME_BLEED}"
echo "STYLE=${STYLE}"
echo "ELDER_SHRINK=${ELDER_SHRINK}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_BLEED" = yes \
  && test "$GUIDE_GROUP" = yes \
  && test "$TAME_BLEED" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_SHRINK" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
