#!/bin/sh
# Census IronBeetle ep005 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP005_NAME=20260712-092212_ironbeetle-ep005-a-limit-on-everything.md
EP005="$ROOT/$EP005_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP005"; then
  echo "IRON=present"
  echo "EP005=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP005"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP005"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Limit on Everything' "$EP005" \
  && rg -q 'No Dynamic Allocation' "$EP005" \
  && rg -qi 'back-pressure' "$EP005" \
  && rg -qi 'static' "$EP005" \
  && rg -qi 'limit' "$EP005"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP005"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP005"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP005=yes"
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
