#!/bin/sh
# tools/fixtures/s/stash_record_scan.sh -- a record parked in the dead-letter box and never read
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
# WHY A RECORD IS NOT THE WORK (REDS %510). The reading above asks whether the lap's REASONING got
# out of the box, and it uses the session log because every lap writes one, which no other file can
# be relied on to be. The proxy breaks in exactly one direction, and it is the expensive one: a lap
# whose log landed while its code did not reads `unlanded=0 verdict=ok` over a box that still holds
# the work.
#
# Measured on this field `20260906.180000`, with the record gate about to close on its last unlanded
# row: FOUR files stood in three round-open stashes that this reading counted at nothing at all --
# 258 lines together, and not one of them raised `records` by one. `stash@{6}` alone held
# `tools/fixtures/a/agent_jail_control.sh` (141 lines) and `tools/fixtures/m/mount_namespace_probe.sh`
# (44) -- the pen and the probe that authorize `%446`'s skip -- while `tools/ag/agent_jail_witness.sh`,
# the guard those two were written for, had already landed without them. That stash's own session log
# read `landed:worktree`, so this scan said nothing about the stash at all.
#
# THE SECOND READING, AND ITS HONEST LIMIT. A path a stash ADDS can be asked the same question the
# record is asked, by the same probe: does the worktree, or a ref a reader reaches, carry it? A path
# nothing carries is an ORPHAN -- bytes standing in the box alone. A path something DOES carry cannot
# be read this way at all, since the stash's change to it is an EDIT and the path exists everywhere
# regardless; those are counted as `unread` and printed rather than left silent, because a reach
# nobody prints is claimed by implication (%505).
#
# THE TWO READINGS ARE DISJOINT ON PURPOSE. A record is never also counted as an orphan, so
# `records` and `paths` partition the box and no file is reported twice under two names. The
# control proves the partition on real numbers rather than trusting the arithmetic here.
#
# ORPHANS REPORT, THEY DO NOT GATE, and there are three reasons rather than one.
#   A count does not travel. `unlanded=0` reads zero on every tree because a record belongs in the
#   channel everywhere, while an orphan COUNT is a per-checkout, per-hour fact -- so a ceiling
#   measured here would red a ship that merely parked more work than this one.
#   An orphan can be honest. A file landed under a different NAME reads as an orphan, and so does an
#   experiment a hand deliberately abandoned. A gate that reds on ordinary work is a gate somebody
#   turns off.
#   And clearing the standing four is a lap rather than a flag flip. Landing a parked pen is work,
#   so a gate seated the day this reading was written would red every open until that lap ran.
# So `unlanded` stays the single gate, unmoved, and `tools/f/fleet_round_open.sh` keeps the meaning
# it greps for. What changes is that the box's other drawer is now NAMED at every open.
#
# NINETEEN ORPHANS ARE THREE KINDS, AND ONLY ONE OF THEM IS A LAP (REDS %592). The count was
# honest and unreadable: measured on this field `20260908.024426`, `orphans=19` stood for a day and
# a half and every ship read past it, because a hand who runs `list` gets nineteen paths wanting
# three different actions with nothing telling them apart. Sorted by hand that morning they were
# ten fold shelves, three copies of this guard's own elder self, and six files of genuinely parked
# work. The six are the lap; the other thirteen are noise competing with it for a reader's
# attention, and thirteen-nineteenths noise is why nobody read any of it.
#
#   `orphan:moved:<path>`  A tracked file elsewhere in the worktree carries the same BASENAME, and
#                          exactly one does. The tools letter-room fold moved this guard's own
#                          three files from `f/` to `s/`, so a stash holding the elder paths is
#                          neither a checkout nor a loss -- it is a diff against the living path.
#                          Exactly one match is required: two make the claim a guess, and a guess
#                          in a triage column is worse than the count it replaced, so an ambiguous
#                          basename falls through and stays whatever it would otherwise be.
#   `orphan:shelf`         A fold shelf under `construction/archive/` -- `REDS-*.md` or
#                          `*_itinerary-landed-accounts.md`, the two families the fold tools write
#                          (442 of that room's 490 files). A shelf is a fold's OUTPUT rather than a
#                          lap's source: its rows come off the living pin, so an unlanded shelf
#                          loses nothing and its recovery is re-running the fold rather than
#                          checking the snapshot out. Checking one out is a ROLLBACK, since seven
#                          peers append to those rooms.
#   `orphan:work`          Everything else -- a guard, a pen, a probe standing on no ref. This is
#                          the number a hand acts on, and it is the only one worth a lap.
#
# THE BLOB PROBE WAS TRIED FIRST AND FOUND NOTHING, which is why the basename is what ships. Asking
# `git rev-parse "$sref:$p"` for each orphan's blob and looking it up in `git ls-files -s` is an
# EXACT answer where the basename is a strong guess -- and on this field it matched zero of the
# nineteen, because a file that moves rooms in this tree is also edited on the way. An exact probe
# that answers never is worth less than an inexact one that answers, so long as the inexact one
# says how it knows. It does: `moved` names the path it matched, so a reader checks the claim in
# one `diff`.
#
# THE CLASSES REPORT, THEY DO NOT GATE, for the same three reasons the orphan count does not, plus
# a fourth of their own: `shelf` is an argument rather than a measurement. It is sound -- a fold
# reads the pin and writes the shelf, so the rows survive an unlanded shelf -- and it would be
# wrong for a lap that landed its pin edit and not its shelf in two separate commits. Nothing turns
# on it, so a reader who distrusts the class reads the path beside it.
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
#   paths=N      distinct NON-record paths across those stashes -- the work beside the reasoning
#   orphans=N    of those, the ones nothing outside the box carries -- reported, never gated
#   orphans_moved=N   of the orphans, the ones a uniquely-named tracked file elsewhere answers for
#   orphans_shelf=N   of the orphans, the fold shelves, whose recovery is a fold re-run
#   orphans_work=N    of the orphans, the remainder -- parked work, and the number worth a lap
#   unread=N     of those, the ones something does carry, so whether the stash's EDIT to them
#                landed cannot be read by a path probe; printed rather than left silent
#   verdict=ok | records_unlanded
#
# `paths` = `orphans` + `unread`, always, since every path is asked exactly one question.
# `orphans` = `orphans_moved` + `orphans_shelf` + `orphans_work`, always, since every orphan is
# given exactly one kind -- asserted below rather than left to the arithmetic here.
#
# USE
#   sh tools/fixtures/s/stash_record_scan.sh          # report on this repository
#   sh tools/fixtures/s/stash_record_scan.sh list     # one unlanded record and one orphan per line
#   sh tools/fixtures/s/stash_record_scan.sh all      # every record and path, with its state
#
# Driven by tools/s/stash_record_witness.rish; proven in a pen by
# tools/fixtures/s/stash_record_control.sh. Called at the open by tools/f/fleet_round_open.sh, which
# must never be able to fail on it. Run from the repository root.
set -u

mode=${1:-report}

# Bounds, named at the edge. A dead-letter box past these is itself the finding, and a walk that
# reads the whole of an unbounded box at every round open is a cost every ship pays every lap.
max_stashes=64
max_records=512
# A stash holds far more paths than records -- the field's largest carries fourteen files against
# one log -- so the path walk gets its own, wider bound rather than borrowing the record one.
max_paths=2048

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

# THE CLASSIFIER IS DEFERRED TO ONE PASS, and the cost is why. Asked per orphan -- one `awk` over
# a 14,000-path index for each of nineteen -- the open went from 1.4s to 3.0s, a doubling every
# ship pays every lap for a diagnosis. Rewriting the probe as a fixed-string `grep` made it WORSE
# at 4.4s, because three small processes per orphan beat one larger one only in intuition. So the
# walk defers: it records each orphan and labels its line `orphan:PENDING`, and ONE `awk` at the
# end reads the tracked index and every orphan together. The process count stops depending on how
# full the box is.
orphan_paths=""

# WHICH KIND, decided for every orphan at once. Three, and they want three different hands -- see
# the header. The two streams are tagged `T` (tracked) and `O` (orphan) and read in one pass, since
# POSIX shell has neither an associative array nor process substitution to carry a map between two.
classify_orphans() {
  # The tag is prepended by `awk` rather than by `sed 's/^/T\t/'`, which is the portability trap
  # this tree booked one lane over the same day: a `\t` in a sed REPLACEMENT is a GNU extension and
  # inserts a literal `t` on the Mac door, where every field would then be one field and the
  # classifier would answer `work` for everything -- a failure a partition check cannot see, since
  # the wrong answers still sum. In `awk` the escape is the language's own and portable.
  { git ls-files 2>/dev/null | awk '{ print "T\t" $0 }'
    printf '%s' "$1"        | awk 'NF { print "O\t" $0 }'
  } | awk -F'\t' -v OFS='\t' '
    # The basename is taken by splitting on "/" rather than matched as a pattern: every path here
    # ends in `.sh`, `.rish`, or `.md`, and a regex `.` matches any character, so a pattern probe
    # would claim matches it never earned. Two answers are remembered because one of them may be
    # the orphan itself, and an orphan is never its own evidence.
    $1 == "T" { n = split($2, a, "/"); b = a[n]
                c[b]++
                if (c[b] == 1)      first[b] = $2
                else if (c[b] == 2) second[b] = $2
                next }
    $1 == "O" { n = split($2, a, "/"); b = a[n]
                k = c[b]; m = first[b]
                if (m == $2) { k--; m = second[b] }
                # MOVED, and only when exactly one tracked file answers. Two make the claim a
                # guess, and a guess in a triage column is worse than the count it replaced, so an
                # ambiguous basename falls through to whatever it would otherwise be.
                if (k == 1 && m != "") { print $2, "moved:" m; next }
                # SHELF is bound by its ROOM as well as its name: the two families the fold tools
                # write, and only where the fold writes them.
                if ($2 ~ /^construction\/archive\/REDS-.*\.md$/ ||
                    $2 ~ /^construction\/archive\/.*_itinerary-landed-accounts\.md$/) {
                  print $2, "shelf"; next }
                print $2, "work" }
  '
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
paths=0
orphans=0
orphans_moved=0
orphans_shelf=0
orphans_work=0
unread=0
seen=""
seen_path=""
lines=""

for sref in $(git stash list --format='%gd' 2>/dev/null); do
  subj=$(git stash list --format='%gd%x09%gs' 2>/dev/null | grep "^$sref	" | cut -f2-)
  case "$subj" in *fleet-round-open*) : ;; *) continue ;; esac
  stashes=$((stashes + 1))
  [ "$stashes" -gt "$max_stashes" ] && break
  held=$(stash_paths "$sref")

  # THE WORK, beside the reasoning. Every path the stash holds that is NOT a record, asked the same
  # question a record is asked. A path nothing outside the box carries is an orphan; a path
  # something does carry holds an EDIT no path probe can judge, so it is counted as unread rather
  # than quietly called safe. The two sets are disjoint, so nothing is reported twice.
  for p in $(printf '%s\n' "$held" | grep -v -E '^session-logs/.*[0-9]{8}-[0-9]{6}[_.]'); do
    case " $seen_path " in *" $p "*) continue ;; esac
    seen_path="$seen_path $p"
    paths=$((paths + 1))
    [ "$paths" -gt "$max_paths" ] && break
    holder=$(carried_by "$p") || true
    if [ -n "$holder" ]; then
      unread=$((unread + 1))
      # An unread path gets a line too, so `all` shows every path the box holds rather than only
      # the ones this probe can judge. A file the scan looked at and could not answer for is a
      # different thing from a file it never saw, and a reader deserves to tell them apart.
      lines="$lines$sref	$p	unread:$holder
"
    else
      orphans=$((orphans + 1))
      orphan_paths="$orphan_paths$p
"
      lines="$lines$sref	$p	orphan:PENDING
"
    fi
  done

  for p in $(printf '%s\n' "$held" | grep -E '^session-logs/.*[0-9]{8}-[0-9]{6}[_.]'); do
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

# The one pass, and the labels it fills in. Skipped entirely on an empty box, since a classifier
# run over nothing still forks `git ls-files` at every open on every ship.
if [ -n "$orphan_paths" ]; then
  kinds=$(classify_orphans "$orphan_paths")
  orphans_moved=$(printf '%s\n' "$kinds" | grep -c '	moved:')
  orphans_shelf=$(printf '%s\n' "$kinds" | grep -c '	shelf$')
  orphans_work=$(printf '%s\n'  "$kinds" | grep -c '	work$')
  # `printf '%s'` on the kinds, whose last line carries no newline of its own, glues the first
  # `lines` row onto it -- which cost one label a stray `L` and swallowed a whole `unread` row,
  # caught by the pen the same lap. The newline is the fix and the reason it is spelled out here.
  lines=$( { printf '%s\n' "$kinds" | awk 'NF { print "K\t" $0 }'
             printf '%s'   "$lines" | awk 'NF { print "L\t" $0 }'
           } | awk -F'\t' -v OFS='\t' '
             $1 == "K" { k[$2] = $3; next }
             $1 == "L" { if ($4 == "orphan:PENDING") $4 = "orphan:" k[$3]
                         print $2, $3, $4 }' )
  lines="$lines
"
fi

case "$mode" in
  list)
    # Both gate states, since a parked record is unlanded with a reason attached rather than a
    # third kind of safe -- and every orphan beside them, since a hand reading this list wants
    # what is IN the box rather than which drawer it is in. Anchored on the tab, so the match
    # reads the state column alone.
    printf '%s' "$lines" | grep -E '	unlanded|	orphan' || true
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
echo "paths=$paths"
echo "orphans=$orphans"
echo "orphans_moved=$orphans_moved"
echo "orphans_shelf=$orphans_shelf"
echo "orphans_work=$orphans_work"
echo "unread=$unread"
# invariant: every orphan is given exactly one kind, so the three sum to the count they partition.
# A partition stated in a header and never checked is a partition that drifts on the lap somebody
# adds a fourth kind.
kind_sum=$((orphans_moved + orphans_shelf + orphans_work))
if [ "$kind_sum" -ne "$orphans" ]; then
  echo "orphan_kinds=disagree:$kind_sum"
else
  echo "orphan_kinds=partition"
fi
if [ "$unlanded" -gt 0 ]; then
  echo "verdict=records_unlanded"
else
  echo "verdict=ok"
fi
