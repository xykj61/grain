#!/bin/sh
# Census IronBeetle ep042 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP042_NAME=20260712-092212_ironbeetle-ep042-over-the-alps.md
EP042="$ROOT/$EP042_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP042"; then
  echo "IRON=present"
  echo "EP042=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP042"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP042"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Over the Alps' "$EP042" \
  && rg -q 'Compaction MERGE!' "$EP042" \
  && rg -q 'Crossing the Alps' "$EP042" \
  && rg -q 'Writing What the Loop Produces' "$EP042" \
  && rg -qi 'merge' "$EP042" \
  && rg -q 'table_builder' "$EP042"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP042"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP042"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP042=yes"
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
