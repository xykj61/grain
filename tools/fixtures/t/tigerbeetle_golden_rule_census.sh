#!/bin/sh
# Census golden-rule positive/negative space + maybe triad on held TigerStyle / clone.
# Clean-room study only -- prints presence and counts; never copies into rye/.
set -eu
ROOT=gratitude/tigerbeetle
GUIDE=gratitude/TIGER_STYLE.md
TAME=external-research/TAME_GUIDANCE.md
if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 1
fi
REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)
GUIDE_GOLDEN=no
if rg -q 'positive space' "$GUIDE" && rg -q 'negative space' "$GUIDE" \
  && rg -q 'golden rule of assertions' "$GUIDE"; then
  GUIDE_GOLDEN=yes
fi
TAME_GOLDEN=no
if rg -q 'positive space' "$TAME" && rg -q 'negative space' "$TAME" \
  && rg -q 'golden rule' "$TAME"; then
  TAME_GOLDEN=yes
fi
MAYBE_COMPLETES=no
if rg -q 'completes the golden rule' "$TAME" && rg -q 'maybe' "$TAME"; then
  MAYBE_COMPLETES=yes
fi
ASSERT=$(rg -c '\bassert\s*\(' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
MAYBE=$(rg -c '\bmaybe\s*\(' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
IMPL=$(rg -c 'if\s*\([^)]+\)\s*assert\s*\(' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
STYLE=no
test -f "$ROOT/docs/TIGER_STYLE.md" && STYLE=yes
echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_GOLDEN=${GUIDE_GOLDEN}"
echo "TAME_GOLDEN=${TAME_GOLDEN}"
echo "MAYBE_COMPLETES=${MAYBE_COMPLETES}"
echo "assert_calls=${ASSERT}"
echo "maybe_calls=${MAYBE}"
echo "implication_assert=${IMPL}"
echo "STYLE=${STYLE}"
if test "$GUIDE_GOLDEN" = yes \
  && test "$TAME_GOLDEN" = yes \
  && test "$MAYBE_COMPLETES" = yes \
  && test "$ASSERT" -ge 2000 \
  && test "$MAYBE" -ge 100 \
  && test "$IMPL" -ge 20 \
  && test "$STYLE" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
