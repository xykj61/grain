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
# Where each orphan's bytes live, so the rename reading can open them. Kept beside the path list
# rather than inside it, since the classifier's input shape is proven by its own pen.
orphan_src=""

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

# THE READING BETWEEN THE TWO PROBES (`20260911.230630`). Cited by stamp rather than by a ledger
# number: `reds_pin_capacity` read `pin_deadlocked=1 rows_that_fit=0 pin_foldable_rows=0` on this
# lap, so no row could be booked, and the derived spine's own rule 4 says a lap names its work by
# stamp until the anointed spine binds a number to it. The header above names an exact
# probe that found nothing and an inexact one that ships, and it names the shape falling between
# them in its own prose: *a file landed under a different NAME reads as an orphan*. On this field
# that sentence WAS the whole work drawer. Measured `20260911.230000`: `orphans_work=3`, and all
# three were `tools/fixtures/t/topology_routed_*` -- the draft name of what landed on `20260907` as
# `topology_stretch_*`, two days later. The basename probe cannot see a rename, since the names
# differ by construction; the blob probe cannot either, since a renamed file is edited on the way.
# So the one number this scan calls "the only one worth a lap" read three, and three of three were
# landed work wearing a draft name -- the `%592` shape regrown inside the drawer `%592` left.
#
# WHAT THE MIDDLE READING IS. For an orphan nothing else answers for, ask of each SIBLING in its
# own room: what share of this orphan's own non-blank lines does that file carry? The question is
# ASYMMETRIC on purpose, and the asymmetry is the instrument -- *what does A hold that B does not*
# answers supersession, where any symmetric count (a diff size, a shared subject, a shared elder)
# reads the same from either end and cannot tell a rewrite from a fork. Two careful laps refused
# this same set on symmetric evidence before that was written down, and the sentence is quoted from
# the very paper whose instrument these three orphans are.
#
# AND THE NAME IS MAPPED BEFORE THE READING IS TAKEN, which is the step that makes it answer. A
# guard says its own name in every `say` line and every assert message, so the loudest textual
# difference between a draft and its landing is the name itself. Measured on the three: raw
# containment reads 97, 99 and **42** percent, and every one of the witness's forty-five unheld
# lines differed only in the word `routed` where the landing writes `stretch`. Mapped, all three
# read **100 percent with nothing unheld**. A floor set anywhere above 42 misses the file that most
# needed the answer, so an unmapped reading would have shipped a class that skips its hardest case.
#
# THE CLAIM IS BOUNDED FOUR WAYS, because a triage column that guesses is worse than the count it
# replaced -- the sentence the `moved` class already stands on.
#   - SAME ROOM. Candidates are the tracked files of the orphan's own directory. A rename that also
#     changed rooms is a `moved` question, or nobody's.
#   - SIBLING NAMES. The basenames share a leading or a trailing `_` token, so the mapping is
#     attempted only between names already related.
#   - A FLOOR: the best mapped share reaches `rename_floor` percent.
#   - DOMINANCE: it is also `rename_dominance` times the runner-up. On the three standing here the
#     separation is 100 against 21, 13 and 6, so a close pair is a different situation and falls
#     through rather than being settled by a tiebreak nobody can check.
# A share between `rename_near_floor` and the floor is counted as `orphans_renamed_near` and stays
# in the `work` drawer, since the safe direction for an unproven claim is the drawer a hand already
# reads. The near count prints even at zero: a reach nobody prints is claimed by implication
# (%505).
#
# IT NAMES THE PATH AND THE REMAINDER -- `orphan:renamed:<path>:unheld=N`. The class is not a
# verdict that the bytes are disposable. It says a named living file carries all but N of these
# lines, and a reader checks the claim in one `diff`: `unheld=0` is the strong case, `unheld=12` is
# an invitation to read twelve lines rather than seven hundred.
rename_floor=90
rename_dominance=4
rename_near_floor=50
# Reads, bounded per orphan and per run. The sibling filter runs before any file is opened, so
# these bite only where one room holds many relatives of one name.
max_rename_candidates=64
max_rename_reads=512
rename_reads=0

# Scratch under `.git/`, never in the worktree and never shared between trees. A fixed name in a
# shared `/tmp` is the fault this tree booked twice (%549, %620); `.git` is per-checkout by
# construction and the pid keeps two passes on one tree apart.
rename_pen=".git/stash-record-rename.$$"

# ARE THESE TWO NAMES ONE RENAME APART -- the same `_` token count, differing in exactly one
# position. This is the sibling filter, it runs before one file is opened, and it is taken over the
# whole room in ONE `awk` rather than once per candidate. Both halves of that sentence were paid
# for:
#
#   A LOOSER FILTER WAS TRIED FIRST. Sharing a LEADING or a TRAILING token admits every
#   `*_witness.rish` in `tools/t/`, which is 106 files, so a per-orphan read bound of 64 cut the
#   walk off alphabetically before it reached `topology_stretch_witness` -- and the one orphan
#   whose answer was 100 percent read `work`. A bound that decides an answer by sort order is worse
#   than a narrower question.
#
#   AND A PER-CANDIDATE PROCESS WAS TRIED FIRST. Asking this question in its own `awk` for each of
#   27 candidates held the round open at 4.7s against a 2.3s baseline -- the same objection this
#   scan's own header already sustains against a per-orphan classifier, and 27 small processes beat
#   one larger one only in intuition. That sentence is now proven twice in one file.
#
# It is also exactly the shape the mapping below can carry: one token moved, its neighbours
# standing. A rename that ALSO changed the token count falls through to `work`, the safe direction.
#
# ONE LOOSENESS, NAMED WITH ITS SIZE. A stem carrying no `_` at all -- `fleet-fly-bare` -- is one
# token, so every other one-token stem in its room is "one token apart" and the filter degenerates
# to the room. Measured `20260911.231405` over this tree's tracked files, the largest such rooms
# are `construction/archive` at 462 one-token stems, `glow/gen/g` at 140 and `caravan` at 106. The
# first can never arrive here, since `shelf` is decided before this reading runs and that room is
# what the shelf class names; the rest are held by `max_rename_candidates`, and `rename_reads`
# prints what was actually opened. The floor and the dominance test are what keep a wide candidate
# set from becoming a wide CLAIM -- a room of 64 unrelated siblings answers with a best share in
# the teens, which reaches neither.
rename_siblings() {
  git ls-files "$2" 2>/dev/null | awk -v ostem="$1" -v odir="$2" -v op="$3" -v cap="$4" '
    function stem(b,   d, a, i, out) {
      d = split(b, a, ".")
      if (d <= 1) return b
      out = a[1]; for (i = 2; i < d; i++) out = out "." a[i]
      return out
    }
    $0 == op { next }
    { n = split($0, a, "/"); b = a[n]
      d = $0; sub("/" b "$", "", d); if (n == 1) d = "."
      if (d != odir) next
      cs = stem(b)
      if (cs == ostem) next
      no = split(ostem, x, "_"); nc = split(cs, y, "_")
      if (no != nc) next
      k = 0
      for (i = 1; i <= no; i++) if (x[i] != y[i]) k++
      if (k != 1) next
      if (++seen > cap) exit
      print $0 }'
}

# ONE `awk` PER ORPHAN, reading its whole room at once, and the process count is why. A first
# working draft spent three processes per candidate -- one to emit the substitutions, one `sed` to
# apply them, one to take the reading -- and the round open went 2.3s to 4.0s. That is the same
# objection this scan's own header already sustains against a per-orphan classifier, so it holds
# against a per-candidate one with more force. Mapping and reading inside one pass leaves one
# process per orphan.
#
# THE MAPPING, per candidate, derived from the two names: the full stem in both separator
# spellings, plus the single differing token carried by its own left neighbour. The neighbour is
# what keeps it narrow -- mapping a bare differing token would rewrite `routed_mean` into
# `stretch_mean` and LOWER the share, since the landed file keeps the reading's own name.
#
# THE READING IS THE ORPHAN'S OWN LINES, asked of the candidate, and never the other way. Blank
# lines are dropped from both sides; they would flatter every pair equally.
rename_prog='
function stem(path,   n, a, b, d, i) {
  n = split(path, a, "/"); b = a[n]
  d = split(b, a, ".")
  if (d > 1) { b = a[1]; for (i = 2; i < d; i++) b = b "." a[i] }
  return b
}
function build_subs(os, cs,   no, nc, a, b, i, d, at, go, gc) {
  ns = 0
  from[++ns] = os; to[ns] = cs
  go = os; gsub(/_/, "-", go); gc = cs; gsub(/_/, "-", gc)
  from[++ns] = go; to[ns] = gc
  no = split(os, a, "_"); nc = split(cs, b, "_")
  if (no != nc) return
  d = 0; at = 0
  for (i = 1; i <= no; i++) if (a[i] != b[i]) { d++; at = i }
  if (d != 1 || at < 2) return
  from[++ns] = a[at-1] "_" a[at]; to[ns] = b[at-1] "_" b[at]
  from[++ns] = a[at-1] "-" a[at]; to[ns] = b[at-1] "-" b[at]
}
function map_line(l,   i, out) {
  out = l
  for (i = 1; i <= ns; i++) gsub(from[i], to[i], out)
  return out
}
function finish(   l, t, h, share) {
  if (cur == "") return
  t = 0; h = 0
  for (l in orph) { t++; if (map_line(l) in cand) h++ }
  if (t == 0) return
  share = int(h * 100 / t)
  if (share > best)        { second = best; best = share; best_unheld = t - h; best_path = cur }
  else if (share > second) { second = share }
}
NR == FNR { if ($0 ~ /[^ \t]/) orph[$0] = 1; next }
FNR == 1 { finish(); cur = FILENAME; delete cand; build_subs(ostem, stem(FILENAME)) }
{ if ($0 ~ /[^ \t]/) cand[$0] = 1 }
END { finish(); printf "%d %d %d %s\n", best + 0, second + 0, best_unheld + 0, best_path }'

# The orphan's own bytes, wherever the stash keeps them: a tracked change rides in the stash commit
# itself, an untracked addition in its third parent.
rename_blob() {
  git show "$2:$1" 2>/dev/null || git show "$2^3:$1" 2>/dev/null
}

# The second stage over the classifier's output, reading stdin and writing the same two columns.
# Only a `work` row is asked, so the three proven classes are untouched and the cost is paid for
# the one drawer a hand acts on.
rename_reading() {
  work_src=$1
  mkdir -p "$rename_pen" 2>/dev/null || true
  while IFS='	' read -r rp rk; do
    [ -n "$rp" ] || continue
    if [ "$rk" != "work" ]; then printf '%s\t%s\n' "$rp" "$rk"; continue; fi
    rsref=$(printf '%s\n' "$work_src" | awk -F'\t' -v p="$rp" '$1 == p { print $2; exit }')
    rdir=${rp%/*}; [ "$rdir" = "$rp" ] && rdir="."
    rbase=${rp##*/}; rstem=${rbase%.*}
    best=0; best_unheld=0; best_path=""; second=0; looked=0; cands=""
    if [ -n "$rsref" ] && rename_blob "$rp" "$rsref" > "$rename_pen/orphan" 2>/dev/null; then
      # The room's siblings, chosen by name before one file is opened.
      left=$((max_rename_reads - rename_reads))
      [ "$left" -gt "$max_rename_candidates" ] && left=$max_rename_candidates
      if [ "$left" -gt 0 ]; then
        cands=$(rename_siblings "$rstem" "$rdir" "$rp" "$left")
        looked=$(printf '%s' "$cands" | awk 'NF' | wc -l | tr -d ' ')
        rename_reads=$((rename_reads + looked))
      fi
      if [ -n "$cands" ]; then
        reading=$(awk -v ostem="$rstem" "$rename_prog" "$rename_pen/orphan" $cands 2>/dev/null)
        best=$(printf '%s' "$reading" | cut -d' ' -f1)
        second=$(printf '%s' "$reading" | cut -d' ' -f2)
        best_unheld=$(printf '%s' "$reading" | cut -d' ' -f3)
        best_path=$(printf '%s' "$reading" | cut -d' ' -f4)
        best=${best:-0}; second=${second:-0}; best_unheld=${best_unheld:-0}
      fi
    fi
    if [ -n "$best_path" ] && [ "$best" -ge "$rename_floor" ] &&
       [ "$best" -ge $((second * rename_dominance)) ]; then
      printf '%s\trenamed:%s:unheld=%s\n' "$rp" "$best_path" "$best_unheld"
    elif [ -n "$best_path" ] && [ "$best" -ge "$rename_near_floor" ]; then
      printf '%s\twork:near:%s:%s\n' "$rp" "$best_path" "$best"
    else
      printf '%s\twork\n' "$rp"
    fi
  done
  # The read count rides OUT on a sentinel line rather than in a variable. This stage runs inside a
  # command substitution, so a counter incremented here never reaches the caller -- a shell fault
  # that would have printed `rename_reads=0` beside however many files it opened, which is exactly
  # the shape of an unprinted reach (%505) with the print present and lying.
  printf 'RENAME_READS\t%s\n' "$rename_reads"
  rm -rf "$rename_pen" 2>/dev/null || true
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
orphans_renamed=0
orphans_renamed_near=0
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
      orphan_src="$orphan_src$p	$sref
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
  kinds_raw=$(classify_orphans "$orphan_paths" | rename_reading "$orphan_src")
  rename_reads=$(printf '%s\n' "$kinds_raw" | awk -F'\t' '$1 == "RENAME_READS" { print $2; exit }')
  rename_reads=${rename_reads:-0}
  kinds=$(printf '%s\n' "$kinds_raw" | grep -v '^RENAME_READS	')
  # THE KINDS ARE COUNTED IN ONE `awk` ON THE SECOND FIELD, never by a `grep` pattern spelling a
  # tab. `grep -E '\twork'` reads that escape as a literal `t` on this bench -- POSIX ERE has no
  # `\t` -- so the first draft of this block counted zero work rows while one stood in its own
  # output, and the partition check below is what caught it. A field read as a field cannot make
  # that mistake.
  kind_counts=$(printf '%s\n' "$kinds" | awk -F'\t' '
    NF >= 2 { k = $2
              if (k ~ /^moved:/)     m++
              else if (k ~ /^renamed:/) r++
              else if (k == "shelf") s++
              else { w++; if (k ~ /^work:near:/) n++ } }
    END { printf "%d %d %d %d %d\n", m+0, r+0, s+0, w+0, n+0 }')
  orphans_moved=$(printf '%s' "$kind_counts" | cut -d' ' -f1)
  orphans_renamed=$(printf '%s' "$kind_counts" | cut -d' ' -f2)
  orphans_shelf=$(printf '%s' "$kind_counts" | cut -d' ' -f3)
  orphans_work=$(printf '%s' "$kind_counts" | cut -d' ' -f4)
  orphans_renamed_near=$(printf '%s' "$kind_counts" | cut -d' ' -f5)
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
echo "orphans_renamed=$orphans_renamed"
echo "orphans_renamed_near=$orphans_renamed_near"
echo "orphans_shelf=$orphans_shelf"
echo "orphans_work=$orphans_work"
echo "rename_reads=$rename_reads"
echo "unread=$unread"
# invariant: every orphan is given exactly one kind, so the four sum to the count they partition.
# A partition stated in a header and never checked is a partition that drifts on the lap somebody
# adds a fifth kind -- which is exactly how the fourth arrived, and the check is what caught the
# first draft counting a `near` row twice.
kind_sum=$((orphans_moved + orphans_renamed + orphans_shelf + orphans_work))
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
