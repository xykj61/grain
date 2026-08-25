#!/bin/sh
# Census explicitly-sized-types law on held TigerStyle / TAME / clone / Grain tools.
# Clean-room study only -- prints presence; never copies into rye/.
set -eu
ROOT="${1:-gratitude/tigerbeetle}"
GUIDE=gratitude/TIGER_STYLE.md
TAME=external-research/TAME_GUIDANCE.md
SUPP=context/TAME_GUIDANCE.md

if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 2
fi

REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)

GUIDE_SIZED=no
if rg -q 'explicitly-sized types like `u32`' "$GUIDE" \
  && rg -q 'architecture-specific `usize`' "$GUIDE"; then
  GUIDE_SIZED=yes
fi

TAME_SIZED=no
if rg -q 'Use explicitly sized types' "$TAME" \
  && rg -q 'architecture-specific `usize`' "$TAME"; then
  TAME_SIZED=yes
fi

SUPPLEMENT_SIZED=no
if rg -q 'Prefer fixed widths; avoid `usize`' "$SUPP" \
  && rg -q 'explicitly-sized types like `u32`' "$SUPP"; then
  SUPPLEMENT_SIZED=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'explicitly-sized types like `u32`' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'architecture-specific `usize`' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

WIDTH_CHECK=no
if test -f tools/w/width-check.rish; then
  WIDTH_CHECK=yes
fi

USIZE_AUDIT=no
if test -f tools/rye/tame_usize_audit.rye; then
  USIZE_AUDIT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_SIZED=${GUIDE_SIZED}"
echo "TAME_SIZED=${TAME_SIZED}"
echo "SUPPLEMENT_SIZED=${SUPPLEMENT_SIZED}"
echo "STYLE=${STYLE}"
echo "WIDTH_CHECK=${WIDTH_CHECK}"
echo "USIZE_AUDIT=${USIZE_AUDIT}"

if test "$GUIDE_SIZED" = yes \
  && test "$TAME_SIZED" = yes \
  && test "$SUPPLEMENT_SIZED" = yes \
  && test "$STYLE" = yes \
  && test "$WIDTH_CHECK" = yes \
  && test "$USIZE_AUDIT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
