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
# WHY A `pier/` BRANCH IS NOT A LANDING (REDS %507). The round open fills TWO drawers, and until
# this reading was widened one of them certified the other empty. Step 4 of
# `tools/f/fleet_round_open.sh` parks a diverged local line on `refs/heads/pier/diverged-<stamp>`,
# and `%499` measured where those go: 11 park branches on `xy`, 33 distinct subjects since
# `20260828`, and **ten of them still stand there today**. So a record carried only by a `pier/`
# ref sits in the second drawer of the same box, which is the exact state this guard exists to
# find.
#
# Measured on this field `20260906.153148`, before the widening: three stashes, `unlanded=0`,
# `verdict=ok` -- while `stash@{0}` held a complete unlanded feature (a module operation, its Rye
# witness, a scan, a control, a roster line) whose session log stood on
# `refs/heads/pier/diverged-20260906-131810` **and nowhere a reader reaches** -- `main` and
# `xy/main` alike went past it. The guard called the box clean because a park is a ref and
# `refs/heads` was read whole.
#
# The whole `pier/` namespace is excluded rather than the `diverged-` prefix alone: the round
# open's own header calls `refs/heads/pier/` "the rota's own deferral shelf", and it writes
# `pier/rebase-<stamp>` there too. Excluding by the namespace follows the namespace's declared
# meaning; one prefix would hold only until a park is named something else. Remote park refs go
# the same way -- `refs/remotes/*/pier/*` -- since a park pushed to the anointed remote leaves the
# record exactly where it already was. A remote `main` still counts, which is legs 20-21.
#
# ONE GATE, AND A DIAGNOSIS BESIDE IT. `unlanded` stays the single gate and keeps its meaning:
# a record carried by no ref a reader will reach. `parked` is the SUBSET of those a `pier/` ref
# does carry, and it is reported beside the gate rather than gated, because two readings that
# always fire together are one reading wearing two names (`.claude/rules/derived-spine.md`). That
# also leaves `tools/f/fleet_round_open.sh` untouched -- it greps `^unlanded=` and starts printing
# correctly on its own, so the change stays inside one seat (%291).
#
# READINGS
#   stashes=N    round-open stashes standing in this repository
#   records=N    distinct session-log records across them
#   landed=N     of those, the ones the worktree or a ref A READER REACHES carries
#   unlanded=N   of those, the ones no such ref carries -- THE GATE, held at zero
#   parked=N     of the unlanded, the ones a `pier/` park ref carries -- the diagnosis
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
# branch, by name. NEVER `--all`, which reaches refs/stash -- see the header. And never the
# `pier/` namespace, local or remote: that is the round open's own deferral shelf, where a park
# keeps every byte and still costs the tree the lap (REDS %499, %507).
all_refs=$(git for-each-ref --format='%(refname)' refs/heads refs/remotes 2>/dev/null)
reader_refs=$(printf '%s\n' "$all_refs" | grep -v -E '^refs/heads/pier/|^refs/remotes/[^/]+/pier/')
park_refs=$(printf '%s\n' "$all_refs" | grep    -E '^refs/heads/pier/|^refs/remotes/[^/]+/pier/')

# Does the worktree, or a ref a reader will actually reach, carry this path?
carried_by() {
  p=$1
  [ -f "$p" ] && { echo "worktree"; return 0; }
  for r in $reader_refs; do
    if git cat-file -e "$r:$p" 2>/dev/null; then echo "$r"; return 0; fi
  done
  echo ""
  return 1
}

# Does a park ref carry it? Asked only of records `carried_by` has already placed outside the
# channel, so this names WHY a record is unlanded rather than deciding whether it is.
parked_on() {
  p=$1
  for r in $park_refs; do
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
parked=0
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
      park=$(parked_on "$p") || true
      if [ -n "$park" ]; then
        parked=$((parked + 1))
        lines="$lines$sref	$p	unlanded:parked:$park
"
      else
        lines="$lines$sref	$p	unlanded
"
      fi
    fi
  done
done

case "$mode" in
  list)
    # Both gate states, since a parked record is unlanded with a reason attached rather than a
    # third kind of safe. Anchored on the tab, so the match reads the state column alone.
    printf '%s' "$lines" | grep '	unlanded' || true
    ;;
  all)
    printf '%s' "$lines"
    ;;
esac

echo "stashes=$stashes"
echo "records=$records"
echo "landed=$landed"
echo "unlanded=$unlanded"
echo "parked=$parked"
if [ "$unlanded" -gt 0 ]; then
  echo "verdict=records_unlanded"
else
  echo "verdict=ok"
fi
