#!/bin/sh
# Census Say-how / test-methodology law on held TigerStyle / TAME / clone / Grain.
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

GUIDE_HOW=no
if rg -q "Don't forget to say how" "$GUIDE"; then
  GUIDE_HOW=yes
fi

GUIDE_METHOD=no
if rg -q 'goal and methodology of the test' "$GUIDE" \
  && rg -q 'get up to speed' "$GUIDE"; then
  GUIDE_METHOD=yes
fi

TAME_HOW=no
if rg -q '\*\*Say how\.\*\*' "$TAME" \
  && rg -q 'goal and the method' "$TAME" \
  && rg -q 'get up to speed' "$TAME"; then
  TAME_HOW=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q "Don't forget to say how" "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'goal and methodology of the test' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

ELDER_WHY=no
if test -f tools/fixtures/tigerbeetle_say_why_census.sh \
  && test -f tools/gen/season/tigerbeetle_say_why_census_witness.rish; then
  ELDER_WHY=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_HOW=${GUIDE_HOW}"
echo "GUIDE_METHOD=${GUIDE_METHOD}"
echo "TAME_HOW=${TAME_HOW}"
echo "STYLE=${STYLE}"
echo "ELDER_WHY=${ELDER_WHY}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_HOW" = yes \
  && test "$GUIDE_METHOD" = yes \
  && test "$TAME_HOW" = yes \
  && test "$STYLE" = yes \
  && test "$ELDER_WHY" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
