#!/bin/sh
# Census control-plane / data-plane assertion economy on held TigerStyle + clone.
# Clean-room study only -- prints presence and verify-gate counts; never copies into rye/.
set -eu
ROOT=gratitude/tigerbeetle
GUIDE=gratitude/TIGER_STYLE.md
if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 1
fi
REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)
GUIDE_PLANE=no
if rg -q 'control plane' "$GUIDE" && rg -q 'data plane' "$GUIDE" && rg -q 'assertion' "$GUIDE"; then
  GUIDE_PLANE=yes
fi
ARCH_PLANE=no
if test -f "$ROOT/docs/ARCHITECTURE.md" \
  && rg -q 'control plane' "$ROOT/docs/ARCHITECTURE.md" \
  && rg -q 'data plane' "$ROOT/docs/ARCHITECTURE.md" \
  && rg -q 'aggressive assertions|assertion' "$ROOT/docs/ARCHITECTURE.md"; then
  ARCH_PLANE=yes
fi
VERIFY=$(rg -c 'constants\.verify' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
FILES_VERIFY=$(rg -l 'constants\.verify' "$ROOT/src" -g '*.zig' 2>/dev/null | wc -l | tr -d ' ')
STYLE=no
test -f "$ROOT/docs/TIGER_STYLE.md" && STYLE=yes
TAME_BRIDGE=no
if rg -q 'Spend assertions where they are free' external-research/TAME_GUIDANCE.md \
  && rg -q 'control plane' external-research/TAME_GUIDANCE.md \
  && rg -q 'data plane' external-research/TAME_GUIDANCE.md; then
  TAME_BRIDGE=yes
fi
echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_PLANE=${GUIDE_PLANE}"
echo "ARCH_PLANE=${ARCH_PLANE}"
echo "constants_verify=${VERIFY}"
echo "files_verify=${FILES_VERIFY}"
echo "STYLE=${STYLE}"
echo "TAME_BRIDGE=${TAME_BRIDGE}"
if test "$GUIDE_PLANE" = yes \
  && test "$ARCH_PLANE" = yes \
  && test "$VERIFY" -ge 20 \
  && test "$FILES_VERIFY" -ge 10 \
  && test "$STYLE" = yes \
  && test "$TAME_BRIDGE" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
