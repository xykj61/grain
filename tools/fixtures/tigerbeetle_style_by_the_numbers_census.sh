#!/bin/sh
# Census Style By The Numbers on held TigerStyle / TAME / clone / Grain.
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

GUIDE_STYLE=no
if rg -q '### Style By The Numbers' "$GUIDE"; then
  GUIDE_STYLE=yes
fi

GUIDE_FMT=no
if rg -q 'zig fmt' "$GUIDE"; then
  GUIDE_FMT=yes
fi

GUIDE_INDENT=no
if rg -q '4 spaces of indentation' "$GUIDE"; then
  GUIDE_INDENT=yes
fi

GUIDE_COLS=no
if rg -q '100 columns' "$GUIDE"; then
  GUIDE_COLS=yes
fi

GUIDE_BRACE=no
if rg -q 'Add braces to the `if` statement' "$GUIDE" \
  && rg -q 'goto fail' "$GUIDE"; then
  GUIDE_BRACE=yes
fi

TAME_STYLE=no
if rg -q '### Style By the Numbers' "$TAME" \
  && rg -q 'zig fmt' "$TAME" \
  && rg -q '4 spaces' "$TAME" \
  && rg -q '100 columns' "$TAME" \
  && rg -q 'goto fail' "$TAME"; then
  TAME_STYLE=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '### Style By The Numbers' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'zig fmt' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '100 columns' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'goto fail' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_OBO=no
if test -f tools/gen/season/equinox_tigerbeetle_off_by_one_choir_witness.rish \
  && test -f tools/gen/season/equinox_tigerbeetle_off_by_one_almanac.sh; then
  ELDER_OBO=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_STYLE=${GUIDE_STYLE}"
echo "GUIDE_FMT=${GUIDE_FMT}"
echo "GUIDE_INDENT=${GUIDE_INDENT}"
echo "GUIDE_COLS=${GUIDE_COLS}"
echo "GUIDE_BRACE=${GUIDE_BRACE}"
echo "TAME_STYLE=${TAME_STYLE}"
echo "STYLE=${STYLE}"
echo "ELDER_OBO=${ELDER_OBO}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_STYLE" = yes \
  && test "$GUIDE_FMT" = yes \
  && test "$GUIDE_INDENT" = yes \
  && test "$GUIDE_COLS" = yes \
  && test "$GUIDE_BRACE" = yes \
  && test "$TAME_STYLE" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_OBO" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
