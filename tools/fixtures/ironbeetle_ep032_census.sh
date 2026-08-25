#!/bin/sh
# Census IronBeetle ep032 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP032_NAME=20260712-092212_ironbeetle-ep032-programming-integrated-over-time.md
EP032="$ROOT/$EP032_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP032"; then
  echo "IRON=present"
  echo "EP032=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP032"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP032"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Programming Integrated Over Time' "$EP032" \
  && rg -q 'Safety, Performance, Experience' "$EP032" \
  && rg -q 'Why Values, Rather Than Just Good Taste' "$EP032" \
  && rg -q 'Safety First, Then Speed, Then Delight' "$EP032" \
  && rg -qi 'safety' "$EP032" \
  && rg -qi 'performance' "$EP032"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP032"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP032"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP032=yes"
echo "HONORS=${HONORS}"
echo "SOURCE=${SOURCE}"
echo "TEACH=${TEACH}"
echo "RHYME=${RHYME}"
echo "CLEAN=${CLEAN}"
echo "MATKLAD_OK=${MATKLAD_OK}"

if test "$HONORS" = yes \
  && test "$SOURCE" = yes \
  && test "$TEACH" = yes \
  && test "$RHYME" = yes \
  && test "$CLEAN" = yes \
  && test "$MATKLAD_OK" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
