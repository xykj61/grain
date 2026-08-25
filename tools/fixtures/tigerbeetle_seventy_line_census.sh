#!/bin/sh
# Census 70-line function bound on held TigerStyle / TAME / TigerBeetle tidy.
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

GUIDE_SEVENTY=no
if rg -q 'hard limit of 70 lines per function' "$GUIDE" \
  && rg -q 'chunks of 70 lines' "$GUIDE"; then
  GUIDE_SEVENTY=yes
fi

TAME_SEVENTY=no
if rg -q 'Hold functions to 70 lines' "$TAME" \
  && rg -q '70-line pieces' "$TAME"; then
  TAME_SEVENTY=yes
fi

SUPPLEMENT_SEVENTY=no
if rg -q 'hard limit of 70 lines per function' "$SUPP"; then
  SUPPLEMENT_SEVENTY=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'hard limit of 70 lines per function' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

TIDY=no
TIDY_PATH="$ROOT/src/tidy.zig"
if test -f "$TIDY_PATH" \
  && rg -q 'functions exceeds 70 lines' "$TIDY_PATH" \
  && rg -q '70-lines-per-function' "$TIDY_PATH"; then
  TIDY=yes
fi

# Ratchet floor named in tidy -- exclusive red zone starts empty at 70.
RATCHET=no
if test -f "$TIDY_PATH" && rg -q '\.min = 70' "$TIDY_PATH"; then
  RATCHET=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_SEVENTY=${GUIDE_SEVENTY}"
echo "TAME_SEVENTY=${TAME_SEVENTY}"
echo "SUPPLEMENT_SEVENTY=${SUPPLEMENT_SEVENTY}"
echo "STYLE=${STYLE}"
echo "TIDY=${TIDY}"
echo "RATCHET=${RATCHET}"

if test "$GUIDE_SEVENTY" = yes \
  && test "$TAME_SEVENTY" = yes \
  && test "$SUPPLEMENT_SEVENTY" = yes \
  && test "$STYLE" = yes \
  && test "$TIDY" = yes \
  && test "$RATCHET" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
