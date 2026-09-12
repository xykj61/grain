#!/bin/sh
# tools/fixtures/l/link_touch_scan.sh -- a round that stages a living page proves that page's links open.
#
# WHAT THIS IS FOR. A living page names a path, and the path is a promise to whoever clicks it.
# `tools/r/readme_reach_witness.rish` already gates that promise at zero across every living file a
# newcomer can walk to from README.md -- inside a cold roster pass that runs for roughly half an
# hour, after the commit is made and, on the fleet's send order, after the push. So a broken link is
# authored, committed, pushed, and read by peers before any instrument speaks (REDS %524). This asks
# the SAME question at the moment the link can still be fixed for free: of the living pages THIS
# COMMIT stages, does every relative link open?
#
# ONE DERIVATION, NOT TWO. This scan does not read links. It runs
# `tools/fixtures/r/readme_reach_scan.sh`, takes that scan's own `living:` findings, and keeps the
# ones whose page this commit stages. So the gated class here is a strict SUBSET of the class the
# roster guard already holds at zero, by construction rather than by care -- this wall can never
# refuse a commit the roster would accept, and the two can never drift apart, because there is only
# one reading. A second link parser was written first and thrown away: it counted 9 findings on one
# commit where the roster reads 0, every one of them a placeholder illustration or a page the front
# door does not reach. Two derivations of one contract disagree; the tree has booked that shape
# often enough to stop writing the second one (REDS %566).
#
# THE CLASS IT CATCHES. A link written at a name that has never existed anywhere -- a shelf spelled
# from the row number a hand remembered rather than read off disk, an archive page named before the
# fold that would have created it. That is a claim about a file, and nothing checked the claim at
# the moment it was made. It is what `20260907.141249` cost: one card link reading `rows-571` where
# the shelf is `rows-570`, discovered by a 1,527-second cold endurance run rather than by a 0.4-second one.
#
# THE CLASS IT DOES NOT CATCH, said plainly, because a wall believed to cover more than it does is
# worse than no wall. A link that was TRUE when written and that a later rebase falsified -- a peer
# folding three rows onto one shelf where this round's page named a shelf of its own. Nothing at
# commit time can see it: the target existed when the commit was made, and `git rebase` does not run
# this hook at all (REDS %339). `readme_reach` at the roster owns that half, and three of REDS
# %524's four firings are exactly it. This closes the fourth.
#
# WHAT IS GATED, hard, at zero: a broken relative link inside a living page this commit stages, as
# READ BY readme_reach. Living, testimony, and the free-passing target forms (http, https, mailto, a
# bare fragment) are all that scan's own rules, so no rule is restated here to drift.
#
# WHAT IS REPORTED AND NEVER GATED: `elsewhere`, the broken living links in pages this commit does
# NOT stage. A commit is answerable for the pages it writes; refusing it for a peer's page would
# make one hand's error every hand's outage, and a wall that reds on ordinary work is a wall
# somebody turns off. The roster guard is what holds that wider line.
#
# WHAT IS NOT PROVEN. That the page on the other side is worth reading, or that the link points at
# what the sentence says it points at. This proves the door opens.
#
#   sh tools/fixtures/l/link_touch_scan.sh              # what this commit ships
#   sh tools/fixtures/l/link_touch_scan.sh worktree     # every living page, off disk
#
# Gated by tools/l/link_touch_witness.rish; proven both ways by
# tools/fixtures/l/link_touch_control.sh on real git repositories in a throwaway pen.
set -u

MODE=${1:-staged}
case "$MODE" in
  staged|worktree) ;;
  *) echo "verdict=unknown_mode"; echo "refused: $MODE is not staged or worktree" >&2; exit 1 ;;
esac

REACH=tools/fixtures/r/readme_reach_scan.sh
if [ ! -r "$REACH" ]; then
  # A reading whose instrument is absent refuses rather than reporting zero. An empty finding set
  # and a broken instrument look identical in the arithmetic and mean opposite things.
  echo "verdict=no_reach_scan"
  echo "refused: $REACH is the one reading this wall takes, and it is absent" >&2
  exit 1
fi

# The reach scan exits 2 when it finds a living break, which is its report rather than its failure.
out=$(sh "$REACH" 2>/dev/null) || true
case "$out" in
  *verdict=ok*|*verdict=living_link_broken*) ;;
  *verdict=no_python*)
    # A CAPABILITY FACT, NEVER A PAGE. This wall rides in a commit hook, so refusing here would
    # refuse EVERY commit on a bench without python3 -- which is the fleet-that-cannot-commit
    # outcome REDS %524 declined this lap for, arriving through a different door. The roster's own
    # readme_reach reds on such a bench and owns it; a wall that cannot take its reading rests and
    # says which capability is missing.
    echo "mode=$MODE"
    echo "verdict=rested_no_python"
    echo "rested: the reach scan wants python3, which this bench does not carry -- readme_reach at the roster owns this reading here" >&2
    exit 0 ;;
  *)
    echo "verdict=reach_refused"
    echo "refused: the reach scan answered no verdict this wall can read" >&2
    exit 1 ;;
esac

findings=$(printf '%s\n' "$out" | grep '^living: ' || true)

if [ "$MODE" = staged ]; then
  staged_set=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
else
  staged_set=""
fi

ours=0
elsewhere=0
report=""

# One finding per line: `living: <page> -> <target>`.
oldifs=$IFS
IFS='
'
for line in $findings; do
  [ -n "$line" ] || continue
  page=${line#living: }
  page=${page%% -> *}
  mine=no
  if [ "$MODE" = worktree ]; then
    mine=yes
  else
    for s in $staged_set; do
      [ "$s" = "$page" ] && { mine=yes; break; }
    done
  fi
  if [ "$mine" = yes ]; then
    ours=$((ours + 1))
    report="$report
ours: ${line#living: }"
  else
    elsewhere=$((elsewhere + 1))
  fi
done
IFS=$oldifs

echo "mode=$MODE"
echo "living_broken_total=$(printf '%s\n' "$findings" | grep -c '^living: ' || true)"
echo "ours=$ours"
echo "elsewhere=$elsewhere"
[ -n "$report" ] && printf '%s\n' "$report" | grep -v '^$'

if [ "$ours" -gt 0 ]; then
  echo "verdict=link_broken"
  exit 2
fi
echo "verdict=ok"
