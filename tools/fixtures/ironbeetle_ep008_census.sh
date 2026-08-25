#!/bin/sh
# Census IronBeetle ep008 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP008_NAME=20260712-092212_ironbeetle-ep008-everyone-gets-to-be-a-dictator.md
EP008="$ROOT/$EP008_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP008"; then
  echo "IRON=present"
  echo "EP008=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP008"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP008"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Everyone Gets to Be a Dictator' "$EP008" \
  && rg -q 'Mathematics of Consensus' "$EP008" \
  && rg -q 'FLP' "$EP008" \
  && rg -qi 'ballot' "$EP008" \
  && rg -qi 'quorum' "$EP008" \
  && rg -q 'What Impossibility Actually Says' "$EP008"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP008"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP008"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP008=yes"
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
