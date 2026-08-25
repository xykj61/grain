#!/bin/sh
# Census IronBeetle ep034 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP034_NAME=20260712-092212_ironbeetle-ep034-a-callback-that-must-never-choose.md
EP034="$ROOT/$EP034_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP034"; then
  echo "IRON=present"
  echo "EP034=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP034"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP034"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Callback That Must Never Choose' "$EP034" \
  && rg -q 'Prefetching From Disk' "$EP034" \
  && rg -q 'Many Lookups, One Bounded Pool' "$EP034" \
  && rg -q 'The Rule Behind the Rule' "$EP034" \
  && rg -qi 'callback' "$EP034" \
  && rg -qi 'asynchronous' "$EP034"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP034"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP034"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP034=yes"
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
