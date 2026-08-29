#!/bin/sh
# Census IronBeetle ep028 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP028_NAME=20260712-092212_ironbeetle-ep028-freed-yet-not-freed-quite-yet.md
EP028="$ROOT/$EP028_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP028"; then
  echo "IRON=present"
  echo "EP028=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP028"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP028"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Freed, Yet Not Freed Quite Yet' "$EP028" \
  && rg -q 'The FreeSet, Part I' "$EP028" \
  && rg -q 'Why a Freed Block Waits Its Turn' "$EP028" \
  && rg -q 'Two Phases So Concurrency Never Costs Determinism' "$EP028" \
  && rg -q 'FreeSet' "$EP028" \
  && rg -qi 'reservation' "$EP028"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP028"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP028"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP028=yes"
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
