#!/bin/sh
# Census IronBeetle ep019 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP019_NAME=20260712-092212_ironbeetle-ep019-everything-is-a-sorted-array.md
EP019="$ROOT/$EP019_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP019"; then
  echo "IRON=present"
  echo "EP019=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP019"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP019"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Everything Is a Sorted Array' "$EP019" \
  && rg -q 'A Sorted Array on Disk' "$EP019" \
  && rg -q 'The Deflating, Freeing Realization' "$EP019" \
  && rg -q 'A Table, and the Key That Was Never Separate' "$EP019" \
  && rg -qi 'index block' "$EP019" \
  && rg -qi 'value block' "$EP019"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP019"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP019"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP019=yes"
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
