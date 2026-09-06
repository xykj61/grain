#!/bin/sh
# tools/fixtures/s/standing_equipment_run.sh -- run the rostered guards of a tier, and record when each ran.
#
# WHY. construction/standing-equipment.kyri names what stands. This runs it, and writes one line per
# guard into the run card, so the question "when did this last run?" has an answer on disk
# rather than in a memory of a round. REDS %149 taught the sentence this exists to make
# checkable: a bound is only a bound on the laps someone runs it.
#
# WHY A TIER. Guards cost wildly different amounts of time, and one roster naming all of them made
# one choice for every one. A choir -- a witness that sings a whole family of rungs in one
# invocation -- takes minutes: tools/ca/caravan_suite_witness.rish runs 111 rungs in 8m31s and
# tools/cr/crypto_suite_witness.rish runs 74 in 9m06s, both measured on this pier on 20260825, and
# the whole roster measured 20m20s with one of them seated. A lap reads the roster twice, cold at
# the open and hot after `git add`, so a guard names its own cadence and the runner honors it:
#
#   tier lap       every roster run. What a record naming no tier means, so the roster's existing
#                  rows keep their meaning without being edited.
#   tier cadence   the cadence lap -- the fifth round, where the council rota closes its cycle and
#                  the seed ships -- and any lap where a hand asks for the guard by name.
#
# A tier is a CADENCE rather than an exemption. REDS %219 was a choir standing off the roster
# entirely, which is a refusal nobody receives; a cadence guard is still heard, on a slower clock,
# and construction/standing-equipment-runs.kyri records the clock that heard it. A tier word the
# runner does not know is refused by tools/fixtures/s/standing_equipment_scan.sh rather than run past,
# because a guard on such a tier would run on no lap at all, in silence.
#
# WHAT IT WRITES. construction/standing-equipment-runs.kyri, one
# `ran <name> <stamp> <verdict> <tier> <seconds>`
# line per guard. Lines for guards this pass left alone are KEPT, so a default run preserves the
# cadence tier's own history rather than erasing it. The card is untracked by design -- it measures
# THIS pier's history, and a fresh clone that has run nothing should say so.
#
# WHAT EACH GUARD READS, and why it is not the file above (REDS %483). A guard running mid-pass used
# to read the working-tree card, which this runner writes ONCE, at the close -- so it read the
# PREVIOUS pass's verdict for every peer, including reds the same pass had already repaired. The
# guard that counts recorded reds is itself rostered, so that phantom set `withheld_guard_red`, and
# `--scoped` refuses without a receipt, and the next lap paid a full pass for a fault nobody had.
# Each guard is handed a PEN-LOCAL live view through `STANDING_CARD` instead, rewritten after every
# guard answers, and this runner's own guard is deferred to the end of the todo list so that view is
# complete when it reads. The working-tree card is still written once, at the close, for the reason
# the evidence room is: a file written into the tree DURING the run moves the tree under this
# runner's own `tree_moved` reading.
#
# WHAT IT REFUSES BEFORE IT RUNS. `staged_uncommitted`, the count of paths staged and not yet
# committed, and a full-roster pass that opens on a dirty index REFUSES under
# `run_verdict=lap_unclosed` before a single guard starts. That is the signature of REDS %188: a lap
# that ended at `git add` left this tree's generated pages stale, and the next lap pays the repair.
#
# WHY A REFUSAL RATHER THAN THE READING IT REPLACES. The row fired three times -- 20260824.082144,
# 20260825.092953, and 20260825.132121, the last one leaving `readme_metrics`, `geode_libraries`,
# and `nib_honesty` red on the next cold open. %188 concluded no guard could ENFORCE the close,
# which still holds: such a guard would have to run after a lap ends. %220 answered with a reading
# on line one, and the class fired again eleven hours later, because a reading persuades and a
# refusal decides. The ladder a recurring red climbs is rule, then reading, then refusal, and this
# is the third rung (REDS %223).
#
# THE ONE PLACE THE READING IS UNAMBIGUOUS is exactly here. A full-roster pass is how a lap opens,
# so staged paths at that moment belong to whoever ran last. `--hot` is how a round says the staged
# paths are its own -- the after-`git add` pass REDS %174 asks for. A guard asked for by name is no
# lap open at all and passes free. One flag and one structural distinction, rather than a roster of
# exemptions: a second exemption would be the hiding place this refusal exists to close.
#
# WHAT IT REPORTS WHEN IT FINISHES. `tree_at_open`, `tree_at_close`, and `tree_moved` -- a twelve-
# character digest of the tree's SHAPE and its CONTENT, taken before the first guard and again
# after the last. The shape is `git rev-parse HEAD` plus `git status --porcelain`; the content is
# `git diff HEAD` plus a hash of every untracked file, because a status letter reads the same
# however often a dirty file's bytes change and the elder digest was blind to exactly that
# (REDS %380). The whole reading and its cost sit beside the function itself.
# The roster takes twenty minutes and a lap that begins editing
# while it runs gets verdicts describing neither the tree it started on nor the tree it ended on.
# REDS %221: this round did exactly that, and the round before it had already learned the lesson by
# hand -- it stopped a pass at guard fifty for the same reason and wrote down why. A lantern that
# fires twice becomes a loom, so the runner measures it now instead of a reader remembering to.
# `tree_moved=yes` exits 1 under `run_verdict=tree_moved`, with every guard line still printed
# above it, because a run whose verdicts describe no single tree has not answered what it was
# asked -- and nothing it did learn is thrown away. A pen outside a repository reads `nogit` for
# both, which never moves, so a control can drive this runner without standing inside git.
#
# IT ALSO REFUSES A SECOND PASS IN THE SAME TREE. Before it measures anything, a pass takes a
# directory lock at ZERO wait, and one that finds it held refuses under `run_verdict=run_in_flight`
# naming the pid that holds it. Two cold passes stood in one tree for fifty minutes with nothing in
# either to say so (REDS %359), and the said-why for zero wait rather than a queue sits beside the
# acquisition below. The lock path is relative to the repository root, so the six-body fleet's
# other trees are lawful concurrency and only a second pass in THIS tree refuses.
#
# USAGE
#   sh tools/fixtures/s/standing_equipment_run.sh                 # cold open -- tier lap, dirty index refuses
#   sh tools/fixtures/s/standing_equipment_run.sh --hot           # after `git add` -- the staged paths are mine
#   sh tools/fixtures/s/standing_equipment_run.sh --all           # every tier, choirs included
#   sh tools/fixtures/s/standing_equipment_run.sh --scoped        # only what moved since the full receipt
#   sh tools/fixtures/s/standing_equipment_run.sh --tier cadence  # one tier
#   sh tools/fixtures/s/standing_equipment_run.sh banner_room     # one guard by name, whatever its tier
#
# The flags compose: `--hot --all` is the cadence lap's own after-`git add` pass.
#
# Run from the repository root. Slow by nature -- it runs a roster.

set -eu

# The lock this runner takes lives in shell_portable.sh beside the tree's other dialect repairs,
# because `flock(1)` is util-linux and macOS ships none at all (REDS %279). Sourced by the script's
# own directory rather than by a path from the root, so a pen-driven run finds it wherever it stands.
_run_here=$(CDPATH= cd "$(dirname "$0")" && pwd)
. "$_run_here/shell_portable.sh"

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
card="${STANDING_CARD:-construction/standing-equipment-runs.kyri}"
# THIS RUNNER'S OWN GUARD, NAMED HERE because two things below turn on it: it is deferred to the
# end of the todo list, and it is the one guard whose reading of the card is a reading of this
# pass. The scan spells the same name at its own `self_guard`, for the sibling reason (REDS %475).
self_guard=standing_equipment
# The hit-rate meter's two untracked shelves (the fusion build, design 20260825-173153): the
# receipt is the last fully green close's digest, the ledger is every open's match-or-miss row.
# Measurement only -- nothing consults these to skip a guard; that ruling stays Keaton's.
receipt="${STANDING_RECEIPT:-construction/standing-equipment-receipt.kyri}"
hitledger="${STANDING_HITRATE:-construction/standing-equipment-hitrate.kyri}"

want_tier=lap
only=""
hot=no
probe=no
scoped=no

# A loop rather than a single case, so `--hot` composes with `--all` and with `--tier`. A bare word
# is a guard name and selects every tier, which is what asking for one guard has always meant.
while [ $# -gt 0 ]; do
  case "$1" in
    --hot)  hot=yes ;;
    --scoped) scoped=yes ;;
    --receipt-probe) probe=yes ;;
    --all)  want_tier=all ;;
    --tier) shift
            want_tier="${1:-}"
            [ -n "$want_tier" ] || { echo "refused: --tier wants a tier name" >&2; exit 1; } ;;
    --*)    echo "refused: unknown option $1" >&2; exit 1 ;;
    *)      only="$1"; want_tier=all ;;
  esac
  shift
done

[ -f "$roster" ] || { echo "refused: no roster at $roster" >&2; exit 1; }

# THE SCOPED PASS (the fusion build's Move 2+3 synthesis, granted -- the skip word given
# 20260828; design active-designing/20260825-173153_reprove-only-what-moved.md). A scoped run
# proves the DELTA since the last full green receipt: guards whose derived watch-set intersects
# the changed files run, guards the map calls DISCOVERY always run, and everything else is
# skipped BY NAME against a named basis. Three walls hold it honest: it composes with nothing
# that changes what "the roster" means (--all is the cadence's full choir, a bare guard name is
# already a hand's own scope); it refuses outright without a full-run receipt carrying a head to
# diff from; and a scoped close NEVER writes the receipt -- receipts chain only from full greens,
# so a skip can never become the basis of the next skip.
if [ "$scoped" = yes ] && [ -n "$only" ]; then
  echo "refused: --scoped with a guard name -- a by-name run is already a hand's own scope" >&2
  exit 1
fi
if [ "$scoped" = yes ] && [ "$want_tier" != lap ]; then
  echo "refused: --scoped serves the lap tier only; the cadence sings the full choir" >&2
  exit 1
fi

stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)

pen=$(mktemp -d)
receipt_tmp="$pen/receipt.kyri"
trap 'rm -rf "$pen"' EXIT

# The staged reading, before a single guard runs. A pen outside a repository answers 0 rather than
# refusing, so a control can drive this runner without standing inside git.
staged=0
if git rev-parse --git-dir >/dev/null 2>&1; then
  staged=$(git diff --cached --name-only 2>/dev/null | grep -c . || true)
fi
echo "staged_uncommitted=$staged"

# THE DEAD-LETTER BOX, read on the same line-one pass as the index. `tools/f/fleet_round_open.sh`
# runs `git stash push` on a dirty tree at every round-open, and its own header names the doctrine:
# "Stashes are the fleet's dead-letter box; a hand or the lap itself re-derives them." The doctrine
# is sound, so this reading NEVER gates -- a stash is a legitimate parking place, and a guard that
# reds on ordinary work is a guard someone turns off. What it refuses to be is silent.
#
# WHY IT IS HERE RATHER THAN IN A GUARD OF ITS OWN. REDS %321 found a finished lap -- 557 lines of
# Rye, a scan, a witness, two fixtures and its own log -- sitting in the box for fourteen hours
# under a fully green roster, because every meter this tree owns reads the working tree or the
# index and a stash is neither. It closed on a written habit: a lap opens with `git stash list`.
# Three hours later the box held a second finished lap by the same route. A habit is the first rung
# of the ladder this runner's own header names -- rule, then reading, then refusal -- and a reading
# on line one of the pass every lap already opens with is the second, because the lap that needs it
# most is precisely the lap that did not remember to look.
#
# max_stash_entries bounds the enumeration. Two stood on this pier on 20260828; sixteen leaves room
# for a body per seat on the six-body constellation to park twice over, and refuses an unbounded
# walk inside a reading that runs twice a lap. A count past the cap says so on its own line rather
# than being quietly dropped.
max_stash_entries=16
stashed=0
if git rev-parse --git-dir >/dev/null 2>&1; then
  stashed=$(git stash list 2>/dev/null | grep -c . || true)
fi
echo "stashed_entries=$stashed"
i=0
while [ "$i" -lt "$stashed" ] && [ "$i" -lt "$max_stash_entries" ]; do
  # The subject and the file count together, because a number alone is what %321 already had:
  # the reading has to be a line an operator can open, not a figure they can pass over.
  subject=$(git stash list --format='%gs' 2>/dev/null | sed -n "$((i + 1))p")
  # --include-untracked, and the reason is the fault this reading exists for. `git stash show`
  # omits untracked files by default, while `fleet_round_open.sh` stashes with `-u`, so a lap whose
  # leavings are all NEW files -- a fresh scan, a fresh witness, fresh fixtures, which is exactly
  # what REDS %321 lost -- reads as `0 files` and looks like an empty envelope. Proven in a pen on
  # git 2.54.0: two untracked files read 0 without the flag and 2 with it.
  files=$(git stash show --include-untracked --name-only "stash@{$i}" 2>/dev/null | grep -c . || true)
  echo "detail: stash@{$i} $files files -- $subject"
  i=$((i + 1))
done
if [ "$stashed" -gt "$max_stash_entries" ]; then
  echo "detail: $((stashed - max_stash_entries)) further entries unenumerated (max_stash_entries=$max_stash_entries)"
fi

# ONE PASS AT A TIME, and it comes before every refusal that asks a hand to change the tree. This
# runner held no lock at all, so a second pass started beside a first and both ran to completion:
# two cold passes stood in ~/grain-hush from 20260830.091545 to 20260830.093000, fifty minutes,
# with nothing in the output of either to say so (REDS %359). The contention is not merely slow.
# tools/ca/caravan_suite_witness.rish clears caravan/bin/ before it sings -- REDS %92's own repair
# for cold-start self-sufficiency -- so one pass deletes the binaries the other pass's rungs are
# partway through using, and both passes append to the one run card, interleaving the record of
# which pass proved what.
#
# ZERO WAIT, AND A NAMED REFUSAL RATHER THAN A QUEUE. A pass that silently waits half an hour is a
# pass whose reading nobody can date: the stamp it writes names the moment it started waiting, and
# the tree it measures is whatever the first pass left. So the second pass refuses under
# `run_verdict=run_in_flight`, naming the pid that holds the lock, and whoever ran it reads the
# first pass's output instead.
#
# WHY HERE, ahead of the unclosed-lap refusal. That refusal tells a hand to commit, and a hand
# committing while another pass measures moves the tree under it -- which is the very reading
# `tree_moved` exists to catch. A pass that cannot run says the runner is busy first.
lock="${STANDING_LOCK:-construction/standing-equipment-run.lock.d}"
if [ -d "$(dirname "$lock")" ]; then
  if lock_acquire "$lock" 0; then
    # The release is armed ONLY on the side that acquired. A refusing pass that released would
    # free the holder's lock and walk a third pass straight in.
    #
    # THE SIGNAL TRAPS ONLY EXIT, and the EXIT trap does the cleanup exactly once, however this
    # pass ends. Written `EXIT INT TERM` on one line, as this tree wrote it 142 other times at `15f99e1fe0`, a
    # handler that cleans up WITHOUT exiting does not stop the script: POSIX runs the handler and
    # RESUMES execution where the signal landed. The pass then carries on against the pen its own
    # handler just removed, and `set -eu` above ends it at the next `>> "$pen/fresh"` -- so a
    # signalled pass prints a list of green guards and NO `run_verdict` line at all, which reads
    # like a short healthy run. Measured 20260906: this pass died that way after 34 guards.
    # REDS %487; proven both directions in tools/fixtures/s/signal_trap_control.sh.
    trap 'rm -rf "$pen"; lock_release "$lock"' EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
    echo "run_lock=held"
  else
    owner=$(cat "$lock/pid" 2>/dev/null || true)
    [ -n "$owner" ] || owner=unknown
    # WHOSE LAP IS THAT PASS STILL RUNNING FOR? The refusal above tells a hand to read the holder's
    # output instead, and that advice quietly assumes somebody is left to read it. Twice in two laps
    # on 20260831 nobody was: a lap died with its pass still running, the pass reparented to init,
    # and the NEXT round's opening stash (%321) moved the tree the orphan had digested at its open,
    # so its verdict was already fixed at `tree_moved` while it went on holding this lock for
    # another forty minutes. Both mechanisms are right alone. Together they lock the new lap out of
    # the instrument its own card tells it to open with, and the refusal's advice points at a reader
    # who has gone.
    #
    # SO THE READING IS TAKEN AND REPORTED, AND NOTHING IS REAPED. `lock_acquire` already reaps an
    # owner that has EXITED; an orphan has not exited, and it is still a live writer appending to
    # the one run card, so killing it from here would be one pass ending another's -- exactly the
    # cross-hand act REDS %291 asks a body never to take. This line names the condition and the
    # repair; a hand acts.
    #
    # `ps -o ppid=` rather than /proc, because macOS ships no /proc and this reading is worth
    # nothing on the one platform it cannot run. WHAT IT MEASURES IS THE PARENT, and the honest
    # sentence is *the process that started it has exited* rather than *it is abandoned*: a pass
    # launched deliberately by init would read the same, and a host running a subreaper reparents
    # an orphan to the reaper rather than to 1, which reads `alive`. The reading therefore
    # UNDER-reports -- it never accuses a live lap of being gone, and that is the direction to be
    # wrong in.
    parent=unknown
    case "$owner" in
      ''|*[!0-9]*) : ;;
      *)
        owner_parent=$(ps -o ppid= -p "$owner" 2>/dev/null | tr -d ' ')
        case "$owner_parent" in
          '') : ;;
          1) parent=gone ;;
          *) parent=alive ;;
        esac
        ;;
    esac
    echo "run_lock=in_flight pid=$owner parent=$parent"
    echo "run_verdict=run_in_flight"
    echo "refused: another roster pass holds $lock (pid $owner) -- read its output rather than opening a second." >&2
    if [ "$parent" = gone ]; then
      echo "detail: that pass's parent has exited, so its output reaches nobody and its lock outlives the lap that took it." >&2
      echo "detail: stop it with \`kill -TERM $owner\`, which runs this runner's own EXIT trap and releases the lock; SIGKILL bypasses the trap and leaves the lock behind for the next pass to reap." >&2
    fi
    exit 1
  fi
else
  # Same room, same reason as the hit ledger and the receipt below: a pen has no construction/ to
  # lock inside. The skip SAYS SO, because a silent one is how this reading would go quietly false
  # on the day that room moved.
  echo "run_lock=skipped_no_room"
fi

# A full-roster pass opening on a dirty index is a lap that ended at `git add` (REDS %188, %220,
# %223). It refuses here, ahead of the tree digest and ahead of the first guard, because nothing
# measured across that tree would answer the question the lap actually has.
if [ "$staged" -gt 0 ] && [ "$hot" = no ] && [ -z "$only" ]; then
  echo "run_verdict=lap_unclosed"
  echo "refused: $staged paths staged and never committed -- a lap ended at 'git add'." >&2
  echo "         commit them, or pass --hot when they are this round's own work." >&2
  exit 1
fi

# The tree this run is about to measure, in twelve characters. `git status --porcelain` covers
# staged, unstaged, and untracked alike, so an untracked file written mid-run moves the digest --
# which is the case that actually happened (REDS %221). What porcelain prints is a status letter
# and a path and nothing else, which is the case that happened next: a file already carrying `M`
# reads `M path` however often its bytes change, and so do `??`, `MM`, and a staged `M ` re-staged.
# A forty-minute pass could therefore close `tree_moved=no` over a tree it had rewritten entirely,
# and `--hot` -- the pass that runs over a round's own staged paths -- reads worst of all, since
# re-staging an edit is the ordinary motion of a round (REDS %380).
#
# So the CONTENT rides beside the shape, in two readings. `git diff HEAD --binary` carries every
# tracked difference from HEAD, staged and unstaged in one reading, with a binary edit emitted as a
# patch rather than as the one-line summary a plain diff gives; before a first commit there is no
# HEAD to diff from, so the index's own blob hashes stand in, which is content under another name.
# Untracked files go through `git hash-object --stdin-paths`, since git holds no content for a path
# it has never been told about. ONE process for the whole list rather than one per file, and the
# difference is not a nicety: measured in a pen at 2,003 untracked files, git's own hasher took
# 45ms where a `sha256sum` per file took 10,393ms -- 231 times the cost, growing with a count this
# runner does not control. Ignored paths stay outside both readings, which is what keeps this
# runner's own card, receipt, hit ledger, and evidence room from moving the digest they sit beside.
#
# Porcelain stays, so the reading is a refinement rather than a replacement: it still names a
# deletion and a rename compactly. Measured on this tree `20260830` at 15,165 tracked files and a
# clean working directory, the whole function costs 261ms per call against the elder reading's 148ms
# -- 113ms more, twice, across a pass that runs for forty minutes. One consequence is named rather
# than left to be discovered: a receipt written by the elder digest cannot match this one, so the
# first pass after this change reads `roster_receipt=miss` once and re-chains at its next full
# green close. A miss runs every guard, which is the safe direction for a reading to fail in.
tree_digest() {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    {
      git rev-parse HEAD 2>/dev/null || echo no_head
      git status --porcelain 2>/dev/null
      if git rev-parse --verify --quiet HEAD >/dev/null 2>&1; then
        git diff HEAD --binary 2>/dev/null
      else
        git ls-files -s 2>/dev/null
      fi
      git ls-files --others --exclude-standard 2>/dev/null \
        | git hash-object --stdin-paths 2>/dev/null
    } | sha256sum | cut -c1-12
  else
    echo nogit
  fi
}
tree_open=$(tree_digest)
echo "tree_at_open=$tree_open"

# THE HIT-RATE METER (the fusion build's Move 2 gate, measurement only -- design
# active-designing/20260825-173153_reprove-only-what-moved.md; the FAST/COLD ruling stays
# Keaton's). At a fully green close the runner records the digest it proved; this compare says
# whether that record would have answered the present open -- and every guard still runs,
# because a skip that consults a cache is a ruling this tree has not made. The rolling ledger
# is where the week's hit rate is read from, one row per open. `--receipt-probe` stops here,
# runs zero guards, and says so in its own verdict -- a probe never wears the roster's green.
receipt_state=none
receipt_head=""
receipt_scope=""
if [ -f "$receipt" ]; then
  rec=$(sed -n 's/^digest //p' "$receipt" | head -1)
  receipt_head=$(sed -n 's/^head //p' "$receipt" | head -1)
  receipt_scope=$(sed -n 's/^scope //p' "$receipt" | head -1)
  if [ "$rec" = "$tree_open" ]; then receipt_state=match; else receipt_state=miss; fi
fi
echo "roster_receipt=$receipt_state"
# The ledger and the receipt both live under `construction/`, which every clone of this tree owns
# and no throwaway pen does. A bare `>>` cannot create a parent directory, so the append DIED here
# in a pen -- taking the runner with it before a single guard ran, and taking with it every one of
# the control's runner-driven cases. Creating the directory instead would be worse: an untracked
# `construction/` written into a pen moves the very tree digest three of those cases exist to read.
# So the write is skipped where its room is absent, and the skip SAYS SO, because a silent skip is
# how this reading would go quietly false on the day `construction/` moved.
#
# AND THE ROW IS WRITTEN AT THE CLOSE, never here. This append used to run between the two digests,
# which made the runner one of the things its own `tree_moved` reading measures: the row grows the
# ledger by one line while the guards run, and a digest that reads CONTENT sees that growth. In
# this repository the shelf is gitignored and so invisible either way; in the control's own pen it
# is not, and the moment the digest learned to read bytes the pen answered `tree_moved=yes` on
# every pass whose earlier case had created `construction/`. The run card and the evidence room
# already keep this discipline and say why beside themselves -- the digest describes the tree the
# GUARDS saw, rather than the tree plus this runner's bookkeeping. The ledger simply predated it
# (REDS %380). The row still records the OPEN's own reading, since that is what it is computed
# from; only the writing waits.
hitledger_write() {
  if [ -d "$(dirname "$hitledger")" ]; then
    printf 'open %s digest %s receipt %s\n' "$stamp" "$tree_open" "$receipt_state" >> "$hitledger"
  else
    echo "hitrate_ledger=skipped_no_room"
  fi
}
if [ "$probe" = yes ]; then
  # A probe runs no guard and takes no close digest, so nothing can move between its open reading
  # and this line -- it writes its own row here and leaves.
  hitledger_write
  echo "run_verdict=receipt_probe"
  exit 0
fi

# Pass one: which guards does this pass run, and what tier does each carry. A guard record is open
# from its `guard` line until the next one, so the tier is read wherever it sits inside the record.
#
# A row may also carry `host macos` or `host linux` (REDS %295, seated on Keaton's word 20260828):
# a three-star constellation writes into one tree from three hosts, and a witness whose last leg
# is `xcrun swift test` is a promise only the Mac benches can keep. A host row is a TIER FOR
# PLACE the way tier is a tier for time -- never an exemption: the row stays on the one roster,
# every host SEES it, and a pass on the wrong host reports it skipped by name rather than
# silently thin. An explicit by-name run (`only`) still runs it wherever the hand asks, so the
# refusal that follows names the real absence instead of this filter. The host word itself is
# validated by standing_equipment_scan.sh; here an unmatched word simply does not match.
case "$(uname -s)" in
  Darwin) this_host=macos ;;
  Linux)  this_host=linux ;;
  *)      this_host=other ;;
esac

# A row may also carry `capability ipv6` (seated 20260829): where `host` is a tier for PLACE and
# `tier` is a tier for TIME, this is a tier for what a host CAN DO. The two are different questions
# and the roster's own note under `comlink_r1_dual_stack` says why: a Linux bench routing IPv6 keeps
# a promise a Linux bench without it breaks, so `host linux` would encode something untrue. That
# note asked for this word and declined to guess at it; this is the guess made and proven.
#
# THREE ANSWERS, NOT TWO, and the third is the whole safety of the field. A probe returns `present`,
# `absent`, or `unknown` -- and an UNKNOWN RUNS THE GUARD. Skipping on an unknown is exactly how a
# capability tier stops being a cadence and becomes an exemption: the probe's own tools go missing
# on some future bench, every capability reads unknown, and a roster quietly thins to nothing while
# every meter stays green. TAME settles the direction -- a guard that runs and reds honestly costs
# one lap, and a guard silently skipped costs the promise. So absence is the only answer that skips,
# and it must be positively read.
#
# ONLY WHAT THE ROSTER ASKS FOR IS PROBED, rather than a list kept here beside the scan's own. Two
# copies of one list is the drift this tree keeps paying for, so the runner reads the words off the
# roster and the scan alone refuses one no runner knows. A word this function does not know reads
# `unknown` and therefore RUNS -- the scan refuses that roster, and if a hand runs it anyway the
# guard still runs rather than vanishing.
capability_state() {
  case "$1" in
    ipv6)
      # The same interface table the elder probe reads, and named as such rather than dressed up:
      # Linux spells the loopback `lo` under iproute2, Darwin spells it `lo0` and ships no `ip`.
      # This asks the host a host question. It does NOT prove the tree can bind a socket, and no
      # capability probe should be read as proving anything the guard it gates exists to prove.
      _lo=$( { ip -o addr show lo 2>/dev/null || ifconfig lo0 2>/dev/null; } || true )
      [ -n "$_lo" ] || { echo unknown; return 0; }
      case "$_lo" in
        *"::1"*) echo present ;;
        *)       echo absent ;;
      esac
      ;;
    jail_nesting)
      # Can a jail be launched from where this pass is standing? `bwrap` refuses to nest, so a ship
      # that is itself jailed cannot run the enclosure legs of `agent_jail` -- not because the
      # launcher is broken but because the kernel says no to the second wrapper. ATTEMPTED rather
      # than inferred: no flag, no /proc reading, no "am I in a container" heuristic, just the
      # cheapest real bwrap this tree can spell, whose failure is the same failure the guard's own
      # legs would hit. A probe that performs the act cannot be wrong about the bench it stands on,
      # which is the difference between this and the `host` field REDS %422 declined.
      command -v bwrap >/dev/null 2>&1 || { echo unknown; return 0; }
      if bwrap --ro-bind / / --dev /dev /bin/true >/dev/null 2>&1; then echo present; else echo absent; fi
      ;;
    seed_projection)
      # Does a seed projection stand in this checkout? `seed/` is gitignored and built by
      # `tools/s/sow.rish`, so a fresh clone has none -- and `sow_allow_reach`, which reads the
      # shipped side, cannot run without one. Its scan refuses rather than reporting clean, which is
      # correct (REDS %170) and made the guard red on every tree in the fleet that had not projected
      # (REDS %492). This is the same reading the operator card already gives an empty `vendor/`: an
      # ENVIRONMENT fact rather than a tree red.
      #
      # THE PROBE ASKS THE GUARD'S OWN QUESTION, reading `SOW_SEED` exactly as the scan does, so the
      # two can never disagree about where the projection is. Answering a different question than
      # the guard would is how a capability becomes an exemption.
      #
      # THERE IS NO UNKNOWN HERE, and that is honest rather than a gap: `test -d` has no tool to go
      # missing, so the question is always answerable. The one thing absence could hide is a
      # projection deleted where it should stand -- and `sow.rish` rebuilds it from the field every
      # publish, so a missing `seed/` names no fault. The skip is announced by name on every pass
      # (`skipped_capability sow_allow_reach wants=seed_projection here=absent`), which is what keeps
      # it a cadence rather than a quiet hole.
      if [ -d "${SOW_SEED:-seed}" ]; then echo present; else echo absent; fi
      ;;
    *) echo unknown ;;
  esac
}

caps_absent=" "
for _cap in $(awk '$1 == "capability" { print $2 }' "$roster" 2>/dev/null | sort -u); do
  if [ "$(capability_state "$_cap")" = absent ]; then
    caps_absent="$caps_absent$_cap "
  fi
done
awk -v want="$want_tier" -v only="$only" -v here="$this_host" -v capsabsent="$caps_absent" '
  function reset() { name = ""; path = ""; tier = ""; host = ""; cap = ""; gate = "" }
  function flush(   t) {
    if (name == "") return
    t = (tier == "" ? "lap" : tier)
    if (only != "" && name != only)                { reset(); return }
    if (only == "" && want != "all" && t != want)  { reset(); return }
    if (only == "" && host != "" && host != here)  { print "SKIPHOST", name, host; reset(); return }
    if (only == "" && cap != "" && index(capsabsent, " " cap " ") > 0) { print "SKIPCAP", name, cap; reset(); return }
    print name, (path == "" ? "-" : path), t, (gate == "" ? "-" : gate)
    reset()
  }
  $1 == "guard"      { flush(); name = $2; next }
  $1 == "path"       { if (name != "") path = $2; next }
  $1 == "tier"       { if (name != "") tier = $2; next }
  $1 == "host"       { if (name != "") host = $2; next }
  $1 == "capability" { if (name != "") cap = $2; next }
  $1 == "gate"       { if (name != "") gate = $2; next }
  END { flush() }
' "$roster" > "$pen/selected"
grep '^SKIPHOST ' "$pen/selected" > "$pen/skiphost" || true
grep '^SKIPCAP ' "$pen/selected" > "$pen/skipcap" || true
grep -vE '^(SKIPHOST|SKIPCAP) ' "$pen/selected" > "$pen/todo" || true
skipped_host=$(grep -c '' "$pen/skiphost" || true)
skipped_capability=$(grep -c '' "$pen/skipcap" || true)
while read -r _ skipname skiphost; do
  [ -n "$skipname" ] || continue
  echo "skipped_host $skipname wants=$skiphost here=$this_host"
done < "$pen/skiphost"
# Named, never merely counted. A guard skipped for a capability this host lacks is still ON the one
# roster and still SEEN by every pass; what changes is that this pass says out loud which promise it
# could not ask for and why, so a thinning roster reads as a thinning roster rather than as a green.
while read -r _ skipname skipcap; do
  [ -n "$skipname" ] || continue
  echo "skipped_capability $skipname wants=$skipcap here=absent"
done < "$pen/skipcap"

# The scoped filter, after every other selection has spoken. The basis must be a FULL green
# receipt carrying a head this repository holds; the changed set is that head to HEAD plus every
# porcelain path (staged, unstaged, untracked alike -- the same breadth the tree digest reads);
# the map comes from its own fixture, one line per guard, DISCOVERY or a watch-set. A guard whose
# map row is missing runs -- absence is the answer that runs, exactly as the capability tier holds.
skipped_scope=0
if [ "$scoped" = yes ]; then
  scope_map="${STANDING_SCOPE_MAP:-tools/fixtures/s/standing_equipment_scope_map.sh}"
  if [ "$receipt_scope" != full ] || [ -z "$receipt_head" ] \
    || ! git rev-parse --verify --quiet "$receipt_head^{commit}" >/dev/null 2>&1; then
    # WHICH OF THE TWO REMEDIES IS THEIRS. A missing receipt has two causes that want opposite
    # answers, and the elder sentence gave one answer to both. Either no full pass has closed here
    # yet, and running the roster earns the basis; or every full pass here closes red, a receipt is
    # written only from a fully green close, and running it again changes nothing at all. On a tree
    # whose reds sit at a custody gate the living card names, the second is permanent (REDS %374).
    # The run card is the only evidence standing at this point, since this refusal comes before a
    # guard runs, and it holds the last verdict of each guard ON THIS PIER. Eight names are printed
    # and the rest counted, because a refusal that prints a roster is a refusal nobody reads.
    blocked=$(awk '$1 == "ran" && $4 == "red" {
        n++
        if (n <= 8) { printf "%s%s", sep, $2; sep = "," }
      } END { if (n > 8) printf ",+%d more", n - 8 }' "$card" 2>/dev/null || true)
    [ -n "$blocked" ] || blocked=none
    echo "scoped_basis_blocked=$blocked"
    echo "run_verdict=scoped_no_basis"
    if [ "$blocked" = none ]; then
      echo "refused: --scoped wants a FULL green receipt with a head to diff from -- run the full roster once" >&2
    else
      echo "refused: --scoped wants a FULL GREEN receipt; the last full pass here closed red at $blocked, and a receipt is written only from a fully green close" >&2
    fi
    exit 1
  fi
  [ -f "$scope_map" ] || { echo "refused: no scope map at $scope_map" >&2; exit 1; }
  { git diff --name-only "$receipt_head" HEAD 2>/dev/null
    git status --porcelain 2>/dev/null | awk '{ $1=""; sub(/^ /,""); print }' \
      | sed 's/^"\(.*\)"$/\1/' | awk -F' -> ' '{ print $NF }'
  } | sort -u > "$pen/changed"
  changed_n=$(grep -c . "$pen/changed" || true)
  echo "scoped_basis=$receipt_head"
  echo "scoped_changed=$changed_n"
  sh "$scope_map" > "$pen/scopemap" || { echo "refused: the scope map fixture failed" >&2; exit 1; }
  : > "$pen/todo.scoped"
  while read -r name path tier_word gate_word; do
    [ -n "$name" ] || continue
    maprow=$(awk -v g="$name" '$1 == g { $1=""; sub(/^ /,""); print; exit }' "$pen/scopemap")
    keep=no
    if [ -z "$maprow" ] || [ "$maprow" = DISCOVERY ]; then
      # Absence runs, exactly as the capability tier holds: a guard the map does not know is
      # never skipped, so a newborn guard is safe before anyone maps it.
      keep=yes
    else
      # Watch words are shell patterns; a word ending in / watches its whole room. The case
      # matcher gives glob semantics natively, and changed sets are small on the passes this
      # mode exists for.
      while IFS= read -r cf; do
        [ -n "$cf" ] || continue
        for w in $maprow; do
          case "$w" in */) w="$w*" ;; esac
          # shellcheck disable=SC2254
          case "$cf" in $w) keep=yes; break ;; esac
        done
        [ "$keep" = yes ] && break
      done < "$pen/changed"
    fi
    if [ "$keep" = yes ]; then
      printf '%s %s %s %s\n' "$name" "$path" "$tier_word" "$gate_word" >> "$pen/todo.scoped"
    else
      skipped_scope=$((skipped_scope + 1))
      echo "skipped_scope $name basis=$receipt_head"
    fi
  done < "$pen/todo"
  cat "$pen/todo.scoped" > "$pen/todo"
fi
echo "skipped_scope=$skipped_scope"

# THE GUARD THAT READS THE CARD RUNS WHEN THE CARD IS COMPLETE (REDS %483, second half). This
# runner's own guard, `standing_equipment`, stands at roster position 188 of 196 -- so eight guards
# stood after it, and their rows in the live view below could only be last pass's. Deferring it to
# the end of the todo list by NAME rather than by roster position closes that residue and keeps it
# closed: a hand adding a guard alphabetically after it cannot silently reopen the gap. It changes
# no verdict, since guards are independent of one another and nothing in this pass reads another
# guard's result.
if grep -q "^$self_guard " "$pen/todo"; then
  awk -v n="$self_guard" '$1 != n' "$pen/todo" > "$pen/todo.deferred"
  awk -v n="$self_guard" '$1 == n' "$pen/todo" >> "$pen/todo.deferred"
  cat "$pen/todo.deferred" > "$pen/todo"
fi

awk '{print $1}' "$pen/todo" | sort -u > "$pen/running"

# A GUARD THIS HOST CANNOT RUN LOSES ITS ELDER CARD ROW (REDS %493, second half). The carry-forward
# below exists so a `tier cadence` guard keeps its own history between its runs, and that is right.
# It is NOT right for a guard skipped by `host` or `capability`: that guard is not merely waiting its
# turn, it cannot run here at all, so its last verdict was recorded in a different world and nothing
# will ever overwrite it. `sow_allow_reach` is the case that taught it -- red on the cold pass for a
# missing `seed/`, given `capability seed_projection` in the same lap, and its red then stood on the
# card permanently while `standing_equipment` counted it every pass. The skip is announced by name on
# every pass (`skipped_capability <name> wants=<cap> here=absent`), so dropping the row loses no
# reading; keeping it would be inheriting a verdict from a machine this one is not.
#
# `skipped_scope` is deliberately NOT here: a `--scoped` pass skips a guard that DOES apply to this
# host and whose receipt is the whole point of the mechanism.
cat "$pen/skiphost" "$pen/skipcap" 2>/dev/null | awk '{print $2}' | sort -u > "$pen/unrunnable"

# THE RECORD A GUARD READS MUST DESCRIBE THIS PASS, NOT THE LAST ONE (REDS %483). The card in the
# working tree is written once, at the close far below, so every guard reading it mid-pass read the
# PREVIOUS pass's verdict for every peer -- including reds this same pass had already repaired.
# Measured `20260906.113000`: a cold pass read `index_row_bound red`, the shelf was repaired, and
# the hot pass read `index_row_bound green` at line 60 and `standing_equipment red` at line 151 --
# the same scan run by hand two minutes later read `runs_red=0 verdict=ok`. That phantom red is
# counted, so it costs the receipt at `withheld_guard_red` below, `--scoped` refuses without one,
# and the NEXT lap pays a full cold pass. On this pier that is 798 seconds of guard time alone, and
# six ships share eight cores, so the bill is a full pass under whatever contention the pier carries.
#
# THE REPAIR KEEPS THE CARD OUT OF THE WORKING TREE. Writing the tree's card incrementally would
# move the tree under this runner's own `tree_moved` reading in any clone where the card is not yet
# gitignored, and in every control pen -- the same reason the evidence room lands after the close
# digest. So the live view is written inside the PEN and handed to each guard through
# `STANDING_CARD`, which `rishi run` passes on to the scan (proven on metal `20260906`). Nothing
# enters the working tree before the close, and a guard reads the truest record available: this
# pass's verdict for every peer that has already answered, and the last recorded one for every peer
# that has not -- which is exactly what a peer that has not re-run honestly has.
: > "$pen/live.rows"
if [ -f "$card" ]; then
  # The live view drops an unrunnable guard's elder row for the same reason the close does
  # (REDS %493, second half): a guard skipped by `host` or `capability` cannot run here, so its last
  # recorded verdict came from a different machine and no pass will ever replace it. Filtering only
  # at the close would leave every guard reading this view mid-pass the very phantom red the two
  # repairs exist to end.
  grep '^ran ' "$card" \
    | while IFS= read -r _row; do
        _rname=$(printf '%s' "$_row" | awk '{print $2}')
        grep -qx "$_rname" "$pen/unrunnable" || printf '%s\n' "$_row"
      done > "$pen/live.rows" || :
fi
live_card="$pen/card.live"
live_write() {
  {
    echo "# Pen-local live view of the run card, handed to each guard through STANDING_CARD."
    echo "# Written by tools/fixtures/s/standing_equipment_run.sh; it never enters the working tree."
    echo "format standing-equipment-runs-v1"
    sort "$pen/live.rows"
  } > "$live_card"
}
live_write
export STANDING_CARD="$live_card"

# Keep every card line whose guard this pass leaves alone, so a slower tier keeps its own history.
: > "$pen/fresh"
if [ -f "$card" ]; then
  while IFS= read -r line; do
    case "$line" in
      ran\ *)
        name=$(printf '%s' "$line" | awk '{print $2}')
        if ! grep -qx "$name" "$pen/running" && ! grep -qx "$name" "$pen/unrunnable"; then
          printf '%s\n' "$line" >> "$pen/fresh"
        fi
        ;;
      *) ;;
    esac
  done < "$card"
fi

ran=0
green=0
red=0
gated=0
gate_names=""
seconds=0

# A RED THAT KEEPS NO WORDS CANNOT BE ROOTED. This loop discarded every guard's output, so a red
# printed one word -- the guard's name -- and whoever read it later had to reproduce the failure to
# learn anything. On `20260826.114500` `caravan_suite` read red here and GREEN when run alone
# minutes afterward, on a tree that had not moved, and the run's own record held nothing to tell
# those two cases apart (REDS %266). So a red keeps its guard's stdout and stderr beside the run
# card, in a room this file's sibling gitignores, and the printed line names the file.
#
# BOUNDED, because an unbounded log is the next thing to fill a tmpfs: the last 200 lines of each
# red, which is the tail a witness fails in, and only reds are kept -- a green that wrote a
# thousand lines is a green nobody needs to read.
# EVIDENCE IS GATHERED IN THE PEN AND LANDS AFTER THE CLOSE DIGEST, for the same reason the run
# card does: a file written into the working tree DURING the run moves the tree under the runner's
# own `tree_moved` reading. In this repository the room is gitignored and so invisible to
# `git status --porcelain` either way; in a clone where it is not yet ignored -- or a pen a control
# drives -- writing it mid-run would turn every red into a `tree_moved` refusal as well.
red_room="construction/standing-equipment-reds"

# WHAT A GUARD COST, recorded beside what it answered (REDS %388). This loop wrote a verdict and
# no elapsed time, so the run card held a hundred verdicts and not one cost -- and a lap deciding
# whether a pass fits its own clock had nothing to read but a window it had watched. On
# `20260831.023122` a lap watched 15 guards for 30 minutes, took 2 min/guard as a rate, projected a
# 106-guard close at three and a half hours, and shipped without a full roster. Measured here the
# next hour over 28 guards: a **median of 2.5 seconds against a mean of 31**, `sow` at 280 and
# `living_card_ascii` at 189, three guards holding 65% of 865 seconds. A mean fifteen times its own
# median is not a rate, and no window of a distribution that skewed predicts the rest of it.
#
# TWO `date` FORKS PER GUARD, against guards measured in seconds -- a cost worth paying to stop
# guessing. Seconds rather than anything finer, because this reading exists to size a PASS: a guard
# that finishes inside a second is one no lap ever needs to think about, and it reads 0 honestly.
while read -r name path tier gate; do
  [ -n "$name" ] || continue
  guard_open=$(date +%s)
  if [ "$path" != "-" ] && [ -f "$path" ]; then
    if rishi/bin/rishi run "$path" > "$pen/out.$$" 2>&1; then
      verdict=green
      green=$((green + 1))
    else
      # A RED AT A CUSTODY GATE IS A PARKED READING, NOT A BROKEN ONE (REDS %374, Keaton's word
      # `20260904`). The counter below used to book both under one name, and this pier's gates are
      # permanent by design -- pond at %5, the drifted rule pairs at %7, the untracked publisher at
      # %1 -- so no pass here could ever close fully green and the fusion build's cheaper pass was
      # unreachable BY CONSTRUCTION rather than by delay. Splitting the counter is the whole repair:
      # `red` keeps its meaning of *this guard broke*, `gated` says *this guard is parked at a gate
      # the card names*, and only the first refuses. The evidence is kept either way, because a
      # parked reading a hand cannot read is a parked reading nobody can retire.
      tail -n 200 "$pen/out.$$" > "$pen/evidence.$name.txt"
      echo "  evidence $red_room/$name.txt"
      if [ "$gate" != "-" ]; then
        verdict=gated
        gated=$((gated + 1))
        gate_names="$gate_names$name($gate) "
      else
        verdict=red
        red=$((red + 1))
      fi
    fi
    rm -f "$pen/out.$$"
  else
    # An absent path is never gated: a guard whose file is gone proves nothing, whatever a
    # roster row claims about it, and letting a gate excuse absence would turn the field into
    # the exemption the tier vocabulary refuses to be.
    verdict=absent
    red=$((red + 1))
  fi
  guard_seconds=$(( $(date +%s) - guard_open ))
  seconds=$((seconds + guard_seconds))
  echo "ran $name $stamp $verdict $tier $guard_seconds" >> "$pen/fresh"
  # The live view moves with the pass: this guard's elder row leaves and the one it just earned
  # lands, so every guard after it reads what actually happened rather than what happened last time.
  awk -v n="$name" '!($1 == "ran" && $2 == n)' "$pen/live.rows" > "$pen/live.next"
  echo "ran $name $stamp $verdict $tier $guard_seconds" >> "$pen/live.next"
  cat "$pen/live.next" > "$pen/live.rows"
  live_write
  echo "$name $verdict ${guard_seconds}s"
  ran=$((ran + 1))
done < "$pen/todo"

# Taken before the runner writes its own card, so the digest describes the tree the GUARDS saw
# rather than the tree plus this runner's bookkeeping. The card is gitignored here and so invisible
# to `git status --porcelain` either way; ordering it this way means a clone where it is not yet
# ignored still reads honestly.
tree_close=$(tree_digest)

# The open's hit-ledger row lands here, beside the card and the evidence and for the same
# reason: nothing this runner writes belongs between its own two digests.
hitledger_write

# The evidence lands now, after the digest and beside the card, for the reason written above the
# room's name. The old room is cleared first so a stale file can never be read as this run's
# verdict, and a run with no reds leaves no room at all.
rm -rf "$red_room"
for _ev in "$pen"/evidence.*.txt; do
  [ -f "$_ev" ] || continue
  mkdir -p "$red_room"
  _nm=${_ev##*/evidence.}
  cat "$_ev" > "$red_room/$_nm"
done

{
  echo "# construction/standing-equipment-runs.kyri -- when each standing guard last ran on THIS pier."
  echo "# Written by tools/fixtures/s/standing_equipment_run.sh; untracked on purpose, so a fresh"
  echo "# clone reads 'never run here' rather than inheriting another machine's memory."
  echo "format standing-equipment-runs-v1"
  sort "$pen/fresh"
} > "$card"

moved=no
[ "$tree_open" = "$tree_close" ] || moved=yes

echo "tier_run=$want_tier"
echo "guards_run=$ran"
# The pass's own cost, so a hand reads what it just spent without opening the card (REDS %388).
echo "guards_seconds=$seconds"
echo "guards_green=$green"
echo "guards_red=$red"
# Disclosed on every pass, empty or full, for the reason the enforced rooms are reported at every
# count: a gate that vanishes from a meter is a gate nobody witnessed being retired.
echo "guards_gated=$gated"
[ -n "$gate_names" ] && echo "gated_at=${gate_names% }"
echo "host=$this_host"
echo "skipped_host=$skipped_host"
echo "skipped_capability=$skipped_capability"
echo "tree_at_close=$tree_close"
echo "tree_moved=$moved"

# The scope word, computed here rather than beside the receipt below, because a pass that refuses
# has to name what the refusal COST as well as what it found.
run_scope=full
[ "$scoped" = yes ] && run_scope=scoped
[ -n "$only" ] && run_scope=named

if [ "$red" -ne 0 ]; then
  # A RED COSTS THE RECEIPT, AND THAT IS SAID HERE RATHER THAN LEFT TO BE INFERRED. The receipt is
  # written below, past this exit, so a full pass carrying any red writes none -- and `--scoped`
  # reads that receipt for its basis. Where a tree's reds sit at a custody gate the living card
  # names, that is a permanent state rather than a delay: this pier carries two, pond_enclosure_door
  # at gate %5 and rule_twin at gate %7, so no pass here can ever close fully green and the fusion
  # build's cheaper pass can never be earned (REDS %374).
  [ "$run_scope" = full ] && echo "roster_receipt_write=withheld_guard_red"
  echo "run_verdict=guard_red"
  echo "refused: a rostered guard answered red -- read its own line" >&2
  exit 1
fi

# A guard red is the louder finding, so it keeps the verdict when both are true. A moved tree comes
# second and still refuses, since verdicts spread across two trees answer no question about either.
if [ "$moved" = yes ]; then
  echo "run_verdict=tree_moved"
  echo "refused: the tree changed while this ran -- these verdicts describe neither one" >&2
  exit 1
fi

# The record a future open compares against, written at an unmoved close of a FULL pass carrying
# no BROKEN guard -- so the receipt can never speak a green the roster did not prove on this exact
# tree, and never one a scoped or by-name pass merely inherited. A guard parked at a custody gate
# the card names no longer costs the receipt (REDS %374, Keaton's word `20260904`); it is disclosed
# inside it instead, since the honest reading is *nothing here broke* rather than *nothing here is
# parked*, and this pier's gates are permanent by design. A scoped close writing the
# receipt would let a skip become the basis of the next skip, which is the one road from
# evidence to rumor this whole design exists to close; a single-guard green overwriting the
# full roster's record was the same road at a walk (found on the fusion lap, 20260829). The
# head rides beside the digest because a digest cannot be diffed from and a commit can.
if [ "$run_scope" = full ]; then
  {
    echo "# construction/standing-equipment-receipt.kyri -- the last fully green FULL close on THIS pier."
    echo "# The fusion build's basis record; written by full passes alone, consulted by --scoped."
    echo "format standing-equipment-receipt-v2"
    echo "digest $tree_close"
    echo "head $(git rev-parse HEAD 2>/dev/null || echo no_head)"
    echo "scope full"
    echo "tier $want_tier"
    echo "guards $ran"
    # THE RECEIPT DISCLOSES WHAT IT CHAINED PAST (REDS %374, granted `20260904`). A receipt that
    # simply said `green` after a gated-only close would promise more than the pass proved, and
    # `--scoped` reads this file for its basis -- so the gates ride in the record itself, and a
    # reader of the receipt learns what was parked without rerunning anything. Zero gates writes
    # the line anyway, at zero, so an absent line is a receipt from before this format rather
    # than a pass that quietly had none.
    echo "gated $gated"
    [ -n "$gate_names" ] && echo "gated_at ${gate_names% }"
    echo "stamp $stamp"
  } > "$receipt_tmp"
  # Same room, same reason as the hit ledger above: a pen has no `construction/` to write into.
  if [ -d "$(dirname "$receipt")" ]; then
    cat "$receipt_tmp" > "$receipt"
  else
    echo "roster_receipt_write=skipped_no_room"
  fi
  rm -f "$receipt_tmp"
else
  echo "roster_receipt_write=withheld_scope_$run_scope"
fi

echo "run_verdict=ok"
exit 0
