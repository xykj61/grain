#!/bin/sh
# tools/fixtures/f/stash_record_scan.sh -- a record parked in the dead-letter box and never read
# back out.
#
# WHY THIS EXISTS. REDS %464. `tools/f/fleet_round_open.sh` stashes an unsent working tree at the
# round open -- correct, and the only reason a dead lap's bytes survive at all (%321). What was
# missing is any step that reads them back. So the bytes live and the record does not: measured
# `20260906.043823`, three stashes held 32 files and 455 insertions, and each held a complete
# session log no branch carried. A lap whose CODE had landed left its reasoning in the box, which
# costs the next lap a rediscovery of work already done -- paid three times in one morning, where
# two hands wrote the same repair and two of the three were discarded.
#
# The row named the instrument it wanted, and this is it: at the open, report any stash holding a
# session-log record that stands in no branch.
#
# WHY `git log --all` IS THE WRONG PROBE, and it is wrong in BOTH directions.
# `--all` includes `refs/stash`, so the obvious question -- is this record in history? -- is asked
# of a set that contains the dead-letter box itself.
#
#   A record STAGED when the lap died rides in the stash's index commit, `stash@{N}^2`, and
#   `git log --all` reports it as history. FALSE SAFE. Measured on this field while the scan was
#   written: `git log --all --oneline -- '*20260906-055857*'` returned one commit, `98b56e594`,
#   and `git rev-parse 'stash@{0}^2'` returns that same hash.
#
#   A record merely UNTRACKED rides in the third parent, `stash@{N}^3`, which the default history
#   walk prunes, so `git log --all` reports nothing. Right answer, wrong reason -- it would report
#   nothing for a landed record parked the same way.
#
# Same probe, same question, opposite answers, and neither answer is about whether the record
# landed. Both readings are reproduced in a pen by the control, legs 6-8. This scan asks
# `refs/heads` and `refs/remotes` by name instead, plus the worktree, and never `--all`.
#
# WHY THE READING IS ABOUT THE RECORD RATHER THAN THE BOX. A stash reads clean here once its
# record has LANDED, whether or not the stash still stands. That property is deliberate: it means
# the only way to turn this guard green is to put the record back in the channel, and never to drop
# the stash. A meter that could be satisfied by deleting evidence is a meter that teaches deletion.
#
# WHAT A RECORD IS. A session log: a path under `session-logs/` whose basename carries the one-clock
# stamp `YYYYMMDD-HHMMSS` followed by a sprig or straight by the extension. The sprig is OPTIONAL
# (REDS %175: 237 logs carry a stamp and no sprig, and a pattern requiring one reads every last of
# them as living), so the shape is `[0-9]{8}-[0-9]{6}[_.]` -- one of the three spellings
# `tools/fixtures/d/dated_spelling_scan.sh` accepts. A shelf index is NOT a record: it is a living
# page every ship appends to, so it is present by construction and would only dilute the count.
#
# READINGS
#   stashes=N    round-open stashes standing in this repository
#   records=N    distinct session-log records across them
#   landed=N     of those, the ones a ref or the worktree carries
#   unlanded=N   of those, the ones nothing carries -- THE GATE, held at zero
#   verdict=ok | records_unlanded
#
# USE
#   sh tools/fixtures/f/stash_record_scan.sh          # report on this repository
#   sh tools/fixtures/f/stash_record_scan.sh list     # one unlanded record per line: stash, path
#   sh tools/fixtures/f/stash_record_scan.sh all      # every record, landed or not, with its state
#
# Driven by tools/f/stash_record_witness.rish; proven in a pen by
# tools/fixtures/f/stash_record_control.sh. Called at the open by tools/f/fleet_round_open.sh, which
# must never be able to fail on it. Run from the repository root.
set -u

mode=${1:-report}

# Bounds, named at the edge. A dead-letter box past these is itself the finding, and a walk that
# reads the whole of an unbounded box at every round open is a cost every ship pays every lap.
max_stashes=64
max_records=512

test -d .git || { echo "verdict=not_a_repository"; exit 0; }

# The refs a record may honestly have landed on: every local branch and every remote-tracking
# branch, by name. NEVER `--all`, which reaches refs/stash -- see the header.
refs=$(git for-each-ref --format='%(refname)' refs/heads refs/remotes 2>/dev/null)

# Does any ref, or the worktree, carry this path?
carried_by() {
  p=$1
  [ -f "$p" ] && { echo "worktree"; return 0; }
  for r in $refs; do
    if git cat-file -e "$r:$p" 2>/dev/null; then echo "$r"; return 0; fi
  done
  echo ""
  return 1
}

# Every path a stash holds, tracked changes and untracked additions alike.
stash_paths() {
  git stash show --include-untracked --name-only "$1" 2>/dev/null
}

stashes=0
records=0
landed=0
unlanded=0
seen=""
lines=""

for sref in $(git stash list --format='%gd' 2>/dev/null); do
  subj=$(git stash list --format='%gd%x09%gs' 2>/dev/null | grep "^$sref	" | cut -f2-)
  case "$subj" in *fleet-round-open*) : ;; *) continue ;; esac
  stashes=$((stashes + 1))
  [ "$stashes" -gt "$max_stashes" ] && break
  for p in $(stash_paths "$sref" | grep -E '^session-logs/.*[0-9]{8}-[0-9]{6}[_.]'); do
    case " $seen " in *" $p "*) continue ;; esac
    seen="$seen $p"
    records=$((records + 1))
    [ "$records" -gt "$max_records" ] && break
    where=$(carried_by "$p") || true
    if [ -n "$where" ]; then
      landed=$((landed + 1))
      lines="$lines$sref	$p	landed:$where
"
    else
      unlanded=$((unlanded + 1))
      lines="$lines$sref	$p	unlanded
"
    fi
  done
done

case "$mode" in
  list)
    printf '%s' "$lines" | grep '	unlanded$' || true
    ;;
  all)
    printf '%s' "$lines"
    ;;
esac

echo "stashes=$stashes"
echo "records=$records"
echo "landed=$landed"
echo "unlanded=$unlanded"
if [ "$unlanded" -gt 0 ]; then
  echo "verdict=records_unlanded"
else
  echo "verdict=ok"
fi
