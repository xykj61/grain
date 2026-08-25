#!/bin/sh
# Census The Last Stage on held TigerStyle / TAME / clone / Grain.
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

GUIDE_LAST=no
if rg -q '## The Last Stage' "$GUIDE"; then
  GUIDE_LAST=yes
fi

GUIDE_FUN=no
if rg -q 'keep trying things out' "$GUIDE" \
  && rg -q 'have fun' "$GUIDE"; then
  GUIDE_FUN=yes
fi

GUIDE_SMALL=no
if rg -q "because it's small" "$GUIDE"; then
  GUIDE_SMALL=yes
fi

GUIDE_BILBO=no
if rg -q 'Bilbo' "$GUIDE" \
  && rg -q 'Thank goodness' "$GUIDE"; then
  GUIDE_BILBO=yes
fi

TAME_LAST=no
if rg -q '## The Last Stage' "$TAME" \
  && rg -q 'keep trying things' "$TAME" \
  && rg -q 'TAME Guidance' "$TAME" \
  && rg -q 'thankful' "$TAME"; then
  TAME_LAST=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '## The Last Stage' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q "because it's small" "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Bilbo' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_TOOL=no
if test -f tools/gen/season/equinox_tigerbeetle_tooling_choir_witness.rish \
  && test -f tools/gen/season/equinox_tigerbeetle_tooling_almanac.sh; then
  ELDER_TOOL=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_LAST=${GUIDE_LAST}"
echo "GUIDE_FUN=${GUIDE_FUN}"
echo "GUIDE_SMALL=${GUIDE_SMALL}"
echo "GUIDE_BILBO=${GUIDE_BILBO}"
echo "TAME_LAST=${TAME_LAST}"
echo "STYLE=${STYLE}"
echo "ELDER_TOOL=${ELDER_TOOL}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_LAST" = yes \
  && test "$GUIDE_FUN" = yes \
  && test "$GUIDE_SMALL" = yes \
  && test "$GUIDE_BILBO" = yes \
  && test "$TAME_LAST" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_TOOL" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
