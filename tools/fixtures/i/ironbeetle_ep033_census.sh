#!/bin/sh
# Census IronBeetle ep033 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP033_NAME=20260712-092212_ironbeetle-ep033-sixteen-thousand-accounts-at-once.md
EP033="$ROOT/$EP033_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP033"; then
  echo "IRON=present"
  echo "EP033=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP033"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP033"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Sixteen Thousand Accounts at Once' "$EP033" \
  && rg -q 'Prefetching From Memory' "$EP033" \
  && rg -q 'One Object, Several Trees, Two Different Caches' "$EP033" \
  && rg -q 'Loading Before Deciding, Rather Than Deciding As You Go' "$EP033" \
  && rg -qi 'prefetch' "$EP033" \
  && rg -qi 'batch' "$EP033"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP033"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP033"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP033=yes"
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
