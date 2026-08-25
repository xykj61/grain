#!/bin/sh
# Census Tooling law on held TigerStyle / TAME / clone / Grain.
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

GUIDE_TOOL=no
if rg -q '### Tooling' "$GUIDE"; then
  GUIDE_TOOL=yes
fi

GUIDE_ZIG=no
if rg -q 'primary tool is Zig' "$GUIDE"; then
  GUIDE_ZIG=yes
fi

GUIDE_SCRIPTS=no
if rg -q 'scripts/\*\.zig' "$GUIDE" \
  && rg -q 'scripts/\*\.sh' "$GUIDE"; then
  GUIDE_SCRIPTS=yes
fi

GUIDE_RIGHT=no
if rg -q 'right tool for the job' "$GUIDE" \
  && rg -q 'John Carmack' "$GUIDE"; then
  GUIDE_RIGHT=yes
fi

TAME_TOOL=no
if rg -q '### Tooling' "$TAME" \
  && rg -q 'primary tool is Zig' "$TAME" \
  && rg -q 'scripts/\*\.zig' "$TAME" \
  && rg -q 'scripts/\*\.sh' "$TAME" \
  && rg -q 'right tool' "$TAME"; then
  TAME_TOOL=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '### Tooling' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'primary tool is Zig' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'scripts/\*\.zig' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'John Carmack' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_DEPS=no
if test -f tools/gen/season/equinox_tigerbeetle_dependencies_choir_witness.rish \
  && test -f tools/gen/season/equinox_tigerbeetle_dependencies_almanac.sh; then
  ELDER_DEPS=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_TOOL=${GUIDE_TOOL}"
echo "GUIDE_ZIG=${GUIDE_ZIG}"
echo "GUIDE_SCRIPTS=${GUIDE_SCRIPTS}"
echo "GUIDE_RIGHT=${GUIDE_RIGHT}"
echo "TAME_TOOL=${TAME_TOOL}"
echo "STYLE=${STYLE}"
echo "ELDER_DEPS=${ELDER_DEPS}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_TOOL" = yes \
  && test "$GUIDE_ZIG" = yes \
  && test "$GUIDE_SCRIPTS" = yes \
  && test "$GUIDE_RIGHT" = yes \
  && test "$TAME_TOOL" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_DEPS" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
