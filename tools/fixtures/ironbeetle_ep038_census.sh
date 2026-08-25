#!/bin/sh
# Census IronBeetle ep038 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP038_NAME=20260712-092212_ironbeetle-ep038-one-number-routes-the-whole-machine.md
EP038="$ROOT/$EP038_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP038"; then
  echo "IRON=present"
  echo "EP038=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP038"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP038"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'One Number Routes the Whole Machine' "$EP038" \
  && rg -q 'The Number Of The Beat' "$EP038" \
  && rg -q 'A Name Corrected in the Open' "$EP038" \
  && rg -q "The Level That Isn't Really a Level" "$EP038" \
  && rg -qi 'compaction' "$EP038" \
  && rg -qi 'modulo' "$EP038"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP038"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP038"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP038=yes"
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
