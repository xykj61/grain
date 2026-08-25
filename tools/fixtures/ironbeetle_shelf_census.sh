#!/bin/sh
# Census gratitude IronBeetle lesson shelf -- own-voice silos beside tigerbeetle/.
# Presence and density only; never copies captions into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
README=gratitude/README.md
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

COUNT=$(find "$ROOT" -maxdepth 1 -type f -name '20260712-092212_ironbeetle-ep*.md' | wc -l | tr -d ' ')

EP001=no
if test -f "$ROOT"/20260712-092212_ironbeetle-ep001-intro-message-parsing.md; then
  EP001=yes
fi

EP045=no
if test -f "$ROOT"/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md; then
  EP045=yes
fi

README_IRON=no
if test -f "$README" \
  && rg -q 'ironbeetle/' "$README" \
  && rg -q 'thirty-four' "$README" \
  && rg -q 'Open gaps' "$README"; then
  README_IRON=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

GAPS=no
if rg -q '003' "$README" \
  && rg -q '007' "$README" \
  && rg -q '016' "$README"; then
  GAPS=yes
fi

echo "IRON=present"
echo "COUNT=${COUNT}"
echo "EP001=${EP001}"
echo "EP045=${EP045}"
echo "README_IRON=${README_IRON}"
echo "MATKLAD_OK=${MATKLAD_OK}"
echo "GAPS=${GAPS}"

if test "$COUNT" -ge 34 \
  && test "$EP001" = yes \
  && test "$EP045" = yes \
  && test "$README_IRON" = yes \
  && test "$MATKLAD_OK" = yes \
  && test "$GAPS" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
