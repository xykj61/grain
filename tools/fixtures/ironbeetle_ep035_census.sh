#!/bin/sh
# Census IronBeetle ep035 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP035_NAME=20260712-092212_ironbeetle-ep035-a-column-that-is-also-a-clock.md
EP035="$ROOT/$EP035_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP035"; then
  echo "IRON=present"
  echo "EP035=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP035"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP035"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Column That Is Also a Clock' "$EP035" \
  && rg -q 'Write Path, the Beginning' "$EP035" \
  && rg -q 'Resubmission Is Not an Error' "$EP035" \
  && rg -q 'A Small Number That Does the Work of Two' "$EP035" \
  && rg -qi 'timestamp' "$EP035" \
  && rg -qi 'identifier' "$EP035"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP035"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP035"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP035=yes"
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
