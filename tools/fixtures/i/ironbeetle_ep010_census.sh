#!/bin/sh
# Census IronBeetle ep010 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP010_NAME=20260712-092212_ironbeetle-ep010-the-disk-is-allowed-to-lie.md
EP010="$ROOT/$EP010_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP010"; then
  echo "IRON=present"
  echo "EP010=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP010"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP010"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'The Disk Is Allowed to Lie' "$EP010" \
  && rg -q 'Storage Fault Model' "$EP010" \
  && rg -qi 'corrupt' "$EP010" \
  && rg -qi 'checksum' "$EP010" \
  && rg -qi 'repair' "$EP010" \
  && rg -q 'A Request That Verifies Its Own Answer' "$EP010"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP010"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP010"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP010=yes"
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
