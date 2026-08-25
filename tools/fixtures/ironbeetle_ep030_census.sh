#!/bin/sh
# Census IronBeetle ep030 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP030_NAME=20260712-092212_ironbeetle-ep030-which-entry-owns-this-address.md
EP030="$ROOT/$EP030_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP030"; then
  echo "IRON=present"
  echo "EP030=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP030"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP030"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Which Entry Owns This Address' "$EP030" \
  && rg -q 'ManifestLog Compaction' "$EP030" \
  && rg -q 'Reading the Tail, Writing the Head' "$EP030" \
  && rg -q 'The Question an Address Alone Cannot Answer' "$EP030" \
  && rg -q 'table_extent' "$EP030" \
  && rg -qi 'insertion' "$EP030"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP030"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP030"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP030=yes"
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
