#!/bin/sh
# Census IronBeetle ep011 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP011_NAME=20260712-092212_ironbeetle-ep011-five-layers-down-to-the-kernel.md
EP011="$ROOT/$EP011_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP011"; then
  echo "IRON=present"
  echo "EP011=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP011"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP011"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Five Layers Down to the Kernel' "$EP011" \
  && rg -q "Let's Go to the Disk" "$EP011" \
  && rg -qi 'journal' "$EP011" \
  && rg -qi 'storage' "$EP011" \
  && rg -q 'io_uring' "$EP011" \
  && rg -q 'Why the Checksum Never Trusts the Read' "$EP011"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP011"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP011"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP011=yes"
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
