#!/bin/sh
# Census IronBeetle ep043 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP043_NAME=20260712-092212_ironbeetle-ep043-nothing-is-real-until-the-manifest-says-so.md
EP043="$ROOT/$EP043_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP043"; then
  echo "IRON=present"
  echo "EP043=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP043"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP043"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Nothing Is Real Until the Manifest Says So' "$EP043" \
  && rg -qF 'The End of the Compaction (Finally!)' "$EP043" \
  && rg -q 'Written, Yet Not Yet True' "$EP043" \
  && rg -q 'A Table That Outlives Its Own Compaction' "$EP043" \
  && rg -qi 'manifest' "$EP043" \
  && rg -qi 'snapshot' "$EP043"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP043"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP043"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP043=yes"
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
