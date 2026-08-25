#!/bin/sh
# Census IronBeetle ep045 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP045_NAME=20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
EP045="$ROOT/$EP045_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP045"; then
  echo "IRON=present"
  echo "EP045=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP045"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP045"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'The Whole Machine, in One Breath' "$EP045" \
  && rg -qF 'The Grand Recap, Part II (and III)' "$EP045" \
  && rg -q 'Writing an Await By Hand' "$EP045" \
  && rg -q 'The Whole System, Restated in One Breath' "$EP045" \
  && rg -qi 'prefetch' "$EP045" \
  && rg -qi 'determin' "$EP045"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP045"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP045"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP045=yes"
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
