#!/bin/sh
# tools/fixtures/r/rule_twin_scan.sh -- a rule and its editor twin say the same thing.
#
# WHY. This tree writes each standing rule twice: `.claude/rules/<name>.md` for Zed and Claude
# Code, `.cursor/rules/<name>.mdc` for Cursor. Both are read as law by whichever editor is
# driving, so a pair that disagrees means the tree holds two different laws under one name and
# which one governs depends on who opened the session.
#
# `context/document-mirrors.brix` exists for exactly this problem and cannot hold these pairs:
# it proves homes BYTE-IDENTICAL, and a `.mdc` twin is a TRANSFORM rather than a copy -- Cursor
# frontmatter on top, local links rewritten `.md` -> `.mdc`, and a closing cross-pointer that
# each file aims at the other on purpose. At the first measurement 40 pairs stood, and ONE was
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
# TWO READINGS, BECAUSE ONE NUMBER WAS ANSWERING TWO QUESTIONS. The elder gate was the single
# figure 36, read at `20260824.112806` over 40 pairs. By `20260908` the tree held 51 pairs and 38
# drifted, so the meter refused -- while drift among those same 40 had FALLEN 36 -> 35. The count
# was carrying both *did a standing pair drift further* and *how many pairs are there*, and the
# second moved every time a hand wrote a new rule. So they are counted apart:
#
#   cohort_drifted   -- drift among the pairs named in tools/fixtures/r/rule_twin_cohort.txt, a
#                       census of a closed day that can never grow. GATED, under a ceiling that
#                       only ever falls: each pair reconciled lowers it by one.
#   arrival_drifted  -- drift among pairs born since. REPORTED with names, never gated, because
#                       reconciling a pair means reading both sides and deciding which sentence is
#                       the law, and that is Keaton's word (below). A gate here would refuse the
#                       ordinary act of writing a new rule -- a gate on new writing in a ratchet's
#                       clothes.
#
# The split is also the honest reading of how the tree is doing: 8 of the 11 pairs born since the
# seating arrived AGREEING, against 5 of 40 among the elders. The habit changed, and one absolute
# could not see it.
#
# WHY RECONCILIATION IS NOT ATTEMPTED HERE. The drift runs in BOTH directions.
# `.cursor/rules/reds-first.mdc` names `work-in-progress/REDS.md`, a path that has since moved to
# `construction/`, so the twin is behind. `.cursor/rules/send-word.mdc` carries an `ls-remote`
# pre-push guard and a two-remote push discipline that `.claude/rules/send-word.md` has never
# held, so the twin is AHEAD. A bulk merge in either direction would silently delete a live
# safety rule. That decision is Keaton's word; this meter's job is to keep the count honest until
# it is made.
#
# USAGE
#   sh tools/fixtures/r/rule_twin_scan.sh          # census -- key=value lines
#   sh tools/fixtures/r/rule_twin_scan.sh list     # every drifted pair, one per line
#   sh tools/fixtures/r/rule_twin_scan.sh diff <name>   # what one pair disagrees about
#
# Driven by tools/r/rule_twin_witness.rish. Run from the repository root.
set -eu

MODE="${1:-census}"
WANT="${2:-}"
CLAUDE_DIR="${RULE_TWIN_CLAUDE_DIR:-.claude/rules}"
CURSOR_DIR="${RULE_TWIN_CURSOR_DIR:-.cursor/rules}"
COHORT_FILE="${RULE_TWIN_COHORT:-tools/fixtures/r/rule_twin_cohort.txt}"

# The cohort ceiling only ever falls. Measured 20260908.034712: 40 cohort pairs, 5 agreeing,
# 35 drifted -- one below the 36 the elder absolute recorded on 20260824.112806.
ceiling="${RULE_TWIN_COHORT_CEILING:-35}"

norm() {
  # $1 path. Applies the four declared transform steps, in order.
  awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$1" \
    | sed 's/\.mdc)/.md)/g; s/\.mdc`/.md`/g' \
    | grep -vE '^Canonical (Claude|Cursor) twin' \
    | sed '/^[[:space:]]*$/d'
}

# A meter that cannot name its cohort would read every pair as an arrival and gate on nothing,
# which is the shape of a guard reporting clean while measuring less than it claims.
if [ ! -f "$COHORT_FILE" ]; then
  echo "detail: the cohort roster $COHORT_FILE is absent, so no pair can be told from an arrival"
  echo "verdict=cohort_absent"
  exit 1
fi
COHORT=" $(grep -vE '^[[:space:]]*(#|$)' "$COHORT_FILE" | tr '\n' ' ')"

in_cohort() { case "$COHORT" in *" $1 "*) return 0;; *) return 1;; esac; }

pairs=0
agree=0
drift=0
claude_only=0
cursor_only=0
cohort_pairs=0
cohort_drift=0
arrival_pairs=0
arrival_drift=0
DRIFTED=""
ARRIVED=""

for f in "$CLAUDE_DIR"/*.md; do
  [ -f "$f" ] || continue
  b=$(basename "$f" .md)
  m="$CURSOR_DIR/$b.mdc"
  if [ ! -f "$m" ]; then
    claude_only=$((claude_only + 1))
    continue
  fi
  pairs=$((pairs + 1))
  if in_cohort "$b"; then cohort_pairs=$((cohort_pairs + 1)); else arrival_pairs=$((arrival_pairs + 1)); fi
  if [ "$(norm "$f")" = "$(norm "$m")" ]; then
    agree=$((agree + 1))
  else
    drift=$((drift + 1))
    DRIFTED="$DRIFTED $b"
    if in_cohort "$b"; then
      cohort_drift=$((cohort_drift + 1))
    else
      arrival_drift=$((arrival_drift + 1))
      ARRIVED="$ARRIVED $b"
    fi
  fi
done

# A cohort name that is no longer a pair is reported rather than quietly shrinking the reading,
# since a rule retired and a pair reconciled are two different facts wearing one appearance.
cohort_missing=0
MISSING=""
for c in $COHORT; do
  if [ ! -f "$CLAUDE_DIR/$c.md" ] || [ ! -f "$CURSOR_DIR/$c.mdc" ]; then
    cohort_missing=$((cohort_missing + 1))
    MISSING="$MISSING $c"
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
echo "cohort_pairs=$cohort_pairs"
echo "cohort_drifted=$cohort_drift"
echo "cohort_ceiling=$ceiling"
echo "cohort_missing=$cohort_missing"
echo "arrival_pairs=$arrival_pairs"
echo "arrival_drifted=$arrival_drift"
echo "claude_only=$claude_only"
echo "cursor_only=$cursor_only"
for a in $ARRIVED; do echo "arrival: $a -- born since the cohort and already drifted; reported, never gated"; done
for x in $MISSING; do echo "absent: $x -- named in the cohort roster and no longer a pair"; done

# A reading over no pairs finds no drift and would report clean while measuring nothing.
if [ "$pairs" -eq 0 ]; then
  echo "verdict=empty_corpus"
  exit 1
fi

if [ "$cohort_drift" -le "$ceiling" ]; then
  echo "verdict=ok"
else
  echo "detail: cohort drift $cohort_drift stands above a ceiling of $ceiling, which only ever falls"
  echo "verdict=cohort_over_ceiling"
  exit 1
fi
