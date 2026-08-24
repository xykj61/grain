#!/bin/sh
# tools/fixtures/rule_twin_scan.sh -- a rule and its editor twin say the same thing.
#
# WHY. This tree writes each standing rule twice: `.claude/rules/<name>.md` for Zed and Claude
# Code, `.cursor/rules/<name>.mdc` for Cursor. Both are read as law by whichever editor is
# driving, so a pair that disagrees means the tree holds two different laws under one name and
# which one governs depends on who opened the session.
#
# `context/document-mirrors.brix` exists for exactly this problem and cannot hold these pairs:
# it proves homes BYTE-IDENTICAL, and a `.mdc` twin is a TRANSFORM rather than a copy -- Cursor
# frontmatter on top, local links rewritten `.md` -> `.mdc`, and a closing cross-pointer that
# each file aims at the other on purpose. Measured 20260824.112806: 40 pairs stand, ONE was
# named in that descriptor, and registering the rest would red every pair forever (REDS %194).
#
# THE TRANSFORM, declared here so it is checkable rather than assumed:
#
#   1. a leading `---` frontmatter block in the twin is dropped
#   2. `.mdc)` and `.mdc`` in link targets read as `.md`
#   3. a line beginning `Canonical Claude twin` or `Canonical Cursor twin` is dropped from both,
#      since each file names the other there and agreeing would make them wrong
#   4. blank lines are dropped, so a reflow is not read as a disagreement
#
# Anything still differing after that is two editors being told two different things.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. This does NOT gate, and
# the reason is worth saying: the drift runs in BOTH directions. `.cursor/rules/reds-first.mdc`
# names `work-in-progress/REDS.md`, a path that has since moved to `construction/`, so the twin
# is behind. `.cursor/rules/send-word.mdc` carries an `ls-remote` pre-push guard and a
# two-remote push discipline that `.claude/rules/send-word.md` has never held, so the twin is
# AHEAD. Reconciling a pair therefore means reading both and deciding, and a bulk merge in
# either direction would silently delete a live safety rule. That decision is Keaton's word;
# this meter's job is to keep the count honest until it is made.
#
# USAGE
#   sh tools/fixtures/rule_twin_scan.sh          # census -- key=value lines
#   sh tools/fixtures/rule_twin_scan.sh list     # every drifted pair, one per line
#   sh tools/fixtures/rule_twin_scan.sh diff <name>   # what one pair disagrees about
#
# Driven by tools/r/rule_twin_witness.rish. Run from the repository root.
set -eu

MODE="${1:-census}"
WANT="${2:-}"
CLAUDE_DIR="${RULE_TWIN_CLAUDE_DIR:-.claude/rules}"
CURSOR_DIR="${RULE_TWIN_CURSOR_DIR:-.cursor/rules}"

# The ceiling only ever falls. Measured 20260824.112806: 40 pairs, 4 agreeing, 36 drifted.
ceiling="${RULE_TWIN_CEILING:-36}"

norm() {
  # $1 path. Applies the four declared transform steps, in order.
  awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$1" \
    | sed 's/\.mdc)/.md)/g; s/\.mdc`/.md`/g' \
    | grep -vE '^Canonical (Claude|Cursor) twin' \
    | sed '/^[[:space:]]*$/d'
}

pairs=0
agree=0
drift=0
claude_only=0
cursor_only=0
DRIFTED=""

for f in "$CLAUDE_DIR"/*.md; do
  [ -f "$f" ] || continue
  b=$(basename "$f" .md)
  m="$CURSOR_DIR/$b.mdc"
  if [ ! -f "$m" ]; then
    claude_only=$((claude_only + 1))
    continue
  fi
  pairs=$((pairs + 1))
  if [ "$(norm "$f")" = "$(norm "$m")" ]; then
    agree=$((agree + 1))
  else
    drift=$((drift + 1))
    DRIFTED="$DRIFTED $b"
  fi
done

for m in "$CURSOR_DIR"/*.mdc; do
  [ -f "$m" ] || continue
  b=$(basename "$m" .mdc)
  [ -f "$CLAUDE_DIR/$b.md" ] || cursor_only=$((cursor_only + 1))
done

if [ "$MODE" = diff ]; then
  [ -n "$WANT" ] || { echo "rule-twin: diff wants a rule name" >&2; exit 2; }
  f="$CLAUDE_DIR/$WANT.md"; m="$CURSOR_DIR/$WANT.mdc"
  [ -f "$f" ] && [ -f "$m" ] || { echo "rule-twin: $WANT is not a pair" >&2; exit 2; }
  diff "$(norm "$f" > /tmp/rt_c.$$; echo /tmp/rt_c.$$)" "$(norm "$m" > /tmp/rt_u.$$; echo /tmp/rt_u.$$)" || true
  rm -f /tmp/rt_c.$$ /tmp/rt_u.$$
  exit 0
fi

if [ "$MODE" = list ]; then
  for d in $DRIFTED; do echo "drift: $d -- $CLAUDE_DIR/$d.md and $CURSOR_DIR/$d.mdc say different things"; done
  [ "$claude_only" -gt 0 ] && echo "note: $claude_only rules have no Cursor twin" || true
  [ "$cursor_only" -gt 0 ] && echo "note: $cursor_only Cursor rules have no Claude canonical" || true
fi

echo "rule_pairs=$pairs"
echo "pairs_agree=$agree"
echo "pairs_drifted=$drift"
echo "drift_ceiling=$ceiling"
echo "claude_only=$claude_only"
echo "cursor_only=$cursor_only"

# A reading over no pairs finds no drift and would report clean while measuring nothing.
if [ "$pairs" -eq 0 ]; then
  echo "verdict=empty_corpus"
  exit 1
fi

if [ "$drift" -le "$ceiling" ]; then
  echo "verdict=ok"
else
  echo "detail: drift $drift stands above a ceiling of $ceiling, which only ever falls"
  echo "verdict=drift_over_ceiling"
  exit 1
fi
