#!/bin/sh
# Census Naming Things law on held TigerStyle / TAME / supplement / clone / Lexicon.
# Clean-room study only -- prints presence; never copies into rye/.
set -eu
ROOT="${1:-gratitude/tigerbeetle}"
GUIDE=gratitude/TIGER_STYLE.md
TAME=external-research/TAME_GUIDANCE.md
SUPP=context/TAME_GUIDANCE.md

if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 2
fi

REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)

GUIDE_NAMING=no
if rg -q '### Naming Things' "$GUIDE" \
  && rg -q 'Get the nouns and verbs just right' "$GUIDE"; then
  GUIDE_NAMING=yes
fi

GUIDE_UNITS=no
if rg -q 'Add units or qualifiers to variable names' "$GUIDE" \
  && rg -q 'latency_ms_max' "$GUIDE"; then
  GUIDE_UNITS=yes
fi

GUIDE_ABBREV=no
if rg -q 'Do not abbreviate variable names' "$GUIDE"; then
  GUIDE_ABBREV=yes
fi

TAME_NAMING=no
if rg -q '### Naming Things' "$TAME" \
  && rg -q 'Write names in full' "$TAME"; then
  TAME_NAMING=yes
fi

TAME_UNITS=no
if rg -q 'Put units and qualifiers last' "$TAME" \
  && rg -q 'latency_ms_max' "$TAME"; then
  TAME_UNITS=yes
fi

SUPPLEMENT_NAMING=no
if rg -q '### Naming \(Tiger Style\)' "$SUPP" \
  && rg -q 'snake_case' "$SUPP"; then
  SUPPLEMENT_NAMING=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q '### Naming Things' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Do not abbreviate variable names' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'latency_ms_max' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

LEXICON=no
if test -f context/LEXICON.md; then
  LEXICON=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_NAMING=${GUIDE_NAMING}"
echo "GUIDE_UNITS=${GUIDE_UNITS}"
echo "GUIDE_ABBREV=${GUIDE_ABBREV}"
echo "TAME_NAMING=${TAME_NAMING}"
echo "TAME_UNITS=${TAME_UNITS}"
echo "SUPPLEMENT_NAMING=${SUPPLEMENT_NAMING}"
echo "STYLE=${STYLE}"
echo "LEXICON=${LEXICON}"

if test "$GUIDE_NAMING" = yes \
  && test "$GUIDE_UNITS" = yes \
  && test "$GUIDE_ABBREV" = yes \
  && test "$TAME_NAMING" = yes \
  && test "$TAME_UNITS" = yes \
  && test "$SUPPLEMENT_NAMING" = yes \
  && test "$STYLE" = yes \
  && test "$LEXICON" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
