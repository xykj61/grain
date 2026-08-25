#!/bin/sh
# Census IronBeetle ep037½ own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP037_NAME=20260712-092212_ironbeetle-ep037-5-garbage-collection-at-allocation.md
EP037="$ROOT/$EP037_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP037"; then
  echo "IRON=present"
  echo "EP037=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP037"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP037"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Garbage Collection at the Moment of Allocation' "$EP037" \
  && rg -q 'Compaction Overview' "$EP037" \
  && rg -q 'Why This Cannot Run in the Background' "$EP037" \
  && rg -q 'Borrowing the Shape of a Simpler Garbage Collector' "$EP037" \
  && rg -qi 'compaction' "$EP037" \
  && rg -qi 'determinism' "$EP037"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP037"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP037"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP037=yes"
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
