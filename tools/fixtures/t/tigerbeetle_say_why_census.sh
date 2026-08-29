#!/bin/sh
# Census Say-why / comments-as-prose law on held TigerStyle / TAME / supplement / clone.
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

GUIDE_WHY=no
if rg -q "Don't forget to say why" "$GUIDE" \
  && rg -q 'Show your workings' "$GUIDE"; then
  GUIDE_WHY=yes
fi

GUIDE_HOW=no
if rg -q "Don't forget to say how" "$GUIDE"; then
  GUIDE_HOW=yes
fi

GUIDE_SENTENCE=no
if rg -q 'Comments are sentences, with a space after the slash' "$GUIDE"; then
  GUIDE_SENTENCE=yes
fi

TAME_WHY=no
if rg -q '\*\*Say why\.\*\*' "$TAME" \
  && rg -q 'Show your workings' "$TAME"; then
  TAME_WHY=yes
fi

TAME_SENTENCE=no
if rg -q 'Write comments as sentences' "$TAME"; then
  TAME_SENTENCE=yes
fi

TAME_RADIANT=no
if rg -q '### Comments in the Radiant Voice' "$TAME" \
  && rg -q 'Lead with what is' "$TAME"; then
  TAME_RADIANT=yes
fi

SUPPLEMENT_WHY=no
if rg -q '### 3\. Say why' "$SUPP"; then
  SUPPLEMENT_WHY=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q "Don't forget to say why" "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Comments are sentences, with a space after the slash' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

RADIANT=no
if test -f context/RADIANT_STYLE.md; then
  RADIANT=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_WHY=${GUIDE_WHY}"
echo "GUIDE_HOW=${GUIDE_HOW}"
echo "GUIDE_SENTENCE=${GUIDE_SENTENCE}"
echo "TAME_WHY=${TAME_WHY}"
echo "TAME_SENTENCE=${TAME_SENTENCE}"
echo "TAME_RADIANT=${TAME_RADIANT}"
echo "SUPPLEMENT_WHY=${SUPPLEMENT_WHY}"
echo "STYLE=${STYLE}"
echo "RADIANT=${RADIANT}"

if test "$GUIDE_WHY" = yes \
  && test "$GUIDE_HOW" = yes \
  && test "$GUIDE_SENTENCE" = yes \
  && test "$TAME_WHY" = yes \
  && test "$TAME_SENTENCE" = yes \
  && test "$TAME_RADIANT" = yes \
  && test "$SUPPLEMENT_WHY" = yes \
  && test "$STYLE" = yes \
  && test "$RADIANT" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
