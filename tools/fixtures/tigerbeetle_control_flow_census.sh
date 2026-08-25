#!/bin/sh
# Census explicit control-flow / no-recursion law on held TigerStyle / TAME / clone.
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

GUIDE_FLOW=no
if rg -q 'very simple, explicit control flow' "$GUIDE" \
  && rg -q 'Do not use recursion' "$GUIDE"; then
  GUIDE_FLOW=yes
fi

GUIDE_NASA=no
if rg -q "NASA's Power of Ten" "$GUIDE" \
  && rg -q 'Safety Critical' "$GUIDE"; then
  GUIDE_NASA=yes
fi

TAME_FLOW=no
if rg -q 'Keep control flow simple and explicit' "$TAME" \
  && rg -q 'We avoid recursion' "$TAME"; then
  TAME_FLOW=yes
fi

SUPPLEMENT_FLOW=no
if rg -q 'Control flow stays simple and explicit' "$SUPP" \
  && rg -q 'recursion stays out' "$SUPP"; then
  SUPPLEMENT_FLOW=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Do not use recursion' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'explicit control flow' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

# Companion bound law -- loops and queues carry fixed upper bounds (same Power-of-Ten family).
GUIDE_LIMIT=no
if rg -q 'Put a limit on everything' "$GUIDE" \
  && rg -q 'fixed upper bound' "$GUIDE"; then
  GUIDE_LIMIT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_FLOW=${GUIDE_FLOW}"
echo "GUIDE_NASA=${GUIDE_NASA}"
echo "GUIDE_LIMIT=${GUIDE_LIMIT}"
echo "TAME_FLOW=${TAME_FLOW}"
echo "SUPPLEMENT_FLOW=${SUPPLEMENT_FLOW}"
echo "STYLE=${STYLE}"

if test "$GUIDE_FLOW" = yes \
  && test "$GUIDE_NASA" = yes \
  && test "$GUIDE_LIMIT" = yes \
  && test "$TAME_FLOW" = yes \
  && test "$SUPPLEMENT_FLOW" = yes \
  && test "$STYLE" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
