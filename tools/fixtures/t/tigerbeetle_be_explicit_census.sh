#!/bin/sh
# Census be-explicit / hot-loop law on held TigerStyle / TAME / clone.
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

GUIDE_EXPLICIT=no
if rg -q 'Be explicit. Minimize dependence on the compiler' "$GUIDE"; then
  GUIDE_EXPLICIT=yes
fi

GUIDE_HOTLOOP=no
if rg -q 'extract hot loops into stand-alone functions' "$GUIDE" \
  && rg -q 'primitive arguments without' "$GUIDE"; then
  GUIDE_HOTLOOP=yes
fi

TAME_EXPLICIT=no
if rg -q 'Be explicit, and lean lightly on the compiler' "$TAME" \
  && rg -q 'Extract hot loops into stand-alone functions' "$TAME" \
  && rg -q 'primitive arguments and skip' "$TAME"; then
  TAME_EXPLICIT=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Be explicit. Minimize dependence on the compiler' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'extract hot loops into stand-alone functions' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

COMPACTION=no
if test -f "$ROOT/src/lsm/compaction.zig"; then
  COMPACTION=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_EXPLICIT=${GUIDE_EXPLICIT}"
echo "GUIDE_HOTLOOP=${GUIDE_HOTLOOP}"
echo "TAME_EXPLICIT=${TAME_EXPLICIT}"
echo "STYLE=${STYLE}"
echo "COMPACTION=${COMPACTION}"

if test "$GUIDE_EXPLICIT" = yes \
  && test "$GUIDE_HOTLOOP" = yes \
  && test "$TAME_EXPLICIT" = yes \
  && test "$STYLE" = yes \
  && test "$COMPACTION" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
