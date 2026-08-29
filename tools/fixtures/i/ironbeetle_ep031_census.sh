#!/bin/sh
# Census IronBeetle ep031½ own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP031_NAME=20260712-092212_ironbeetle-ep031-5-a-fact-kept-in-two-shapes.md
EP031="$ROOT/$EP031_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP031"; then
  echo "IRON=present"
  echo "EP031=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP031"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP031"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Fact Kept in Two Different Shapes' "$EP031" \
  && rg -q 'Journal vs. Checkpoint' "$EP031" \
  && rg -q 'Three Numbers, and a Pipeline That Outran Them' "$EP031" \
  && rg -q 'The Comment That Used to Be True' "$EP031" \
  && rg -qi 'quorum' "$EP031" \
  && rg -qi 'checkpoint' "$EP031"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP031"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP031"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP031=yes"
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
