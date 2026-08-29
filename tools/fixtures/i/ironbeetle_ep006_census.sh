#!/bin/sh
# Census IronBeetle ep006 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP006_NAME=20260712-092212_ironbeetle-ep006-safety-for-code-that-never-frees.md
EP006="$ROOT/$EP006_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP006"; then
  echo "IRON=present"
  echo "EP006=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP006"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP006"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Memory Safety for Code That Never Frees' "$EP006" \
  && rg -q 'A Question of Fit, Never of Rank' "$EP006" \
  && rg -q 'Zig' "$EP006" \
  && rg -q 'Rust' "$EP006" \
  && rg -qi 'never freed' "$EP006" \
  && rg -q 'comptime' "$EP006"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP006"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP006"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP006=yes"
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
