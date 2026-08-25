#!/bin/sh
# Census Dependencies law on held TigerStyle / TAME / clone / Grain.
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

GUIDE_DEPS=no
if rg -q '### Dependencies' "$GUIDE"; then
  GUIDE_DEPS=yes
fi

GUIDE_ZERO=no
if rg -q 'zero dependencies' "$GUIDE"; then
  GUIDE_ZERO=yes
fi

GUIDE_ZIG=no
if rg -q 'Zig toolchain' "$GUIDE"; then
  GUIDE_ZIG=yes
fi

GUIDE_SUPPLY=no
if rg -q 'supply chain' "$GUIDE"; then
  GUIDE_SUPPLY=yes
fi

TAME_DEPS=no
if rg -q '### Dependencies' "$TAME" \
  && rg -q 'zero dependencies' "$TAME" \
  && rg -q 'Zig toolchain' "$TAME" \
  && rg -q 'supply-chain' "$TAME"; then
  TAME_DEPS=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '### Dependencies' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'zero dependencies' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Zig toolchain' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'supply chain' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_STYLE=no
if test -f tools/gen/season/equinox_tigerbeetle_style_by_the_numbers_choir_witness.rish \
  && test -f tools/gen/season/equinox_tigerbeetle_style_by_the_numbers_almanac.sh; then
  ELDER_STYLE=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_DEPS=${GUIDE_DEPS}"
echo "GUIDE_ZERO=${GUIDE_ZERO}"
echo "GUIDE_ZIG=${GUIDE_ZIG}"
echo "GUIDE_SUPPLY=${GUIDE_SUPPLY}"
echo "TAME_DEPS=${TAME_DEPS}"
echo "STYLE=${STYLE}"
echo "ELDER_STYLE=${ELDER_STYLE}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_DEPS" = yes \
  && test "$GUIDE_ZERO" = yes \
  && test "$GUIDE_ZIG" = yes \
  && test "$GUIDE_SUPPLY" = yes \
  && test "$TAME_DEPS" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_STYLE" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
