#!/bin/sh
# Census IronBeetle ep044 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP044_NAME=20260712-092212_ironbeetle-ep044-everything-we-know-from-the-first-byte.md
EP044="$ROOT/$EP044_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP044"; then
  echo "IRON=present"
  echo "EP044=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP044"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP044"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Everything We Know, From the First Byte' "$EP044" \
  && rg -qF 'The Grand Recap, Part I' "$EP044" \
  && rg -q 'Two Jobs Consensus Was Always Doing' "$EP044" \
  && rg -q 'An Honesty Worth Naming' "$EP044" \
  && rg -qi 'consensus' "$EP044" \
  && rg -qi 'quorum' "$EP044"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP044"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP044"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP044=yes"
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
