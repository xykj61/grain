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
# WHAT IT WRITES. construction/standing-equipment-runs.kyri, one `ran <name> <stamp> <verdict> <tier>`
# line per guard. Lines for guards this pass left alone are KEPT, so a default run preserves the
# cadence tier's own history rather than erasing it. The card is untracked by design -- it measures
# THIS pier's history, and a fresh clone that has run nothing should say so.
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
# character digest of `git rev-parse HEAD` plus `git status --porcelain`, taken before the first
# guard and again after the last. The roster takes twenty minutes and a lap that begins editing
# while it runs gets verdicts describing neither the tree it started on nor the tree it ended on.
# REDS %221: this round did exactly that, and the round before it had already learned the lesson by
# hand -- it stopped a pass at guard fifty for the same reason and wrote down why. A lantern that
# fires twice becomes a loom, so the runner measures it now instead of a reader remembering to.
# `tree_moved=yes` exits 1 under `run_verdict=tree_moved`, with every guard line still printed
# above it, because a run whose verdicts describe no single tree has not answered what it was
# asked -- and nothing it did learn is thrown away. A pen outside a repository reads `nogit` for
# both, which never moves, so a control can drive this runner without standing inside git.
#
# USAGE
#   sh tools/fixtures/s/standing_equipment_run.sh                 # cold open -- tier lap, dirty index refuses
#   sh tools/fixtures/s/standing_equipment_run.sh --hot           # after `git add` -- the staged paths are mine
#   sh tools/fixtures/s/standing_equipment_run.sh --all           # every tier, choirs included
#   sh tools/fixtures/s/standing_equipment_run.sh --tier cadence  # one tier
#   sh tools/fixtures/s/standing_equipment_run.sh banner_room     # one guard by name, whatever its tier
#
# The flags compose: `--hot --all` is the cadence lap's own after-`git add` pass.
#
# Run from the repository root. Slow by nature -- it runs a roster.

set -eu

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
card="${STANDING_CARD:-construction/standing-equipment-runs.kyri}"
# The hit-rate meter's two untracked shelves (the fusion build, design 20260825-173153): the
# receipt is the last fully green close's digest, the ledger is every open's match-or-miss row.
# Measurement only -- nothing consults these to skip a guard; that ruling stays Keaton's.
receipt="${STANDING_RECEIPT:-construction/standing-equipment-receipt.kyri}"
hitledger="${STANDING_HITRATE:-construction/standing-equipment-hitrate.kyri}"

want_tier=lap
only=""
hot=no
probe=no

# A loop rather than a single case, so `--hot` composes with `--all` and with `--tier`. A bare word
# is a guard name and selects every tier, which is what asking for one guard has always meant.
while [ $# -gt 0 ]; do
  case "$1" in
    --hot)  hot=yes ;;
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
# which is the case that actually happened (REDS %221).
tree_digest() {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    { git rev-parse HEAD 2>/dev/null || echo no_head; git status --porcelain 2>/dev/null; } \
      | sha256sum | cut -c1-12
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
if [ -f "$receipt" ]; then
  rec=$(sed -n 's/^digest //p' "$receipt" | head -1)
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
if [ -d "$(dirname "$hitledger")" ]; then
  printf 'open %s digest %s receipt %s\n' "$stamp" "$tree_open" "$receipt_state" >> "$hitledger"
else
  echo "hitrate_ledger=skipped_no_room"
fi
if [ "$probe" = yes ]; then
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
awk -v want="$want_tier" -v only="$only" -v here="$this_host" '
  function flush(   t) {
    if (name == "") return
    t = (tier == "" ? "lap" : tier)
    if (only != "" && name != only)                { name = ""; path = ""; tier = ""; host = ""; return }
    if (only == "" && want != "all" && t != want)  { name = ""; path = ""; tier = ""; host = ""; return }
    if (only == "" && host != "" && host != here)  { print "SKIPHOST", name, host; name = ""; path = ""; tier = ""; host = ""; return }
    print name, (path == "" ? "-" : path), t
    name = ""; path = ""; tier = ""; host = ""
  }
  $1 == "guard" { flush(); name = $2; next }
  $1 == "path"  { if (name != "") path = $2; next }
  $1 == "tier"  { if (name != "") tier = $2; next }
  $1 == "host"  { if (name != "") host = $2; next }
  END { flush() }
' "$roster" > "$pen/selected"
grep '^SKIPHOST ' "$pen/selected" > "$pen/skiphost" || true
grep -v '^SKIPHOST ' "$pen/selected" > "$pen/todo" || true
skipped_host=$(grep -c '' "$pen/skiphost" || true)
while read -r _ skipname skiphost; do
  [ -n "$skipname" ] || continue
  echo "skipped_host $skipname wants=$skiphost here=$this_host"
done < "$pen/skiphost"

awk '{print $1}' "$pen/todo" | sort -u > "$pen/running"

# Keep every card line whose guard this pass leaves alone, so a slower tier keeps its own history.
: > "$pen/fresh"
if [ -f "$card" ]; then
  while IFS= read -r line; do
    case "$line" in
      ran\ *)
        name=$(printf '%s' "$line" | awk '{print $2}')
        grep -qx "$name" "$pen/running" || printf '%s\n' "$line" >> "$pen/fresh"
        ;;
      *) ;;
    esac
  done < "$card"
fi

ran=0
green=0
red=0

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

while read -r name path tier; do
  [ -n "$name" ] || continue
  if [ "$path" != "-" ] && [ -f "$path" ]; then
    if rishi/bin/rishi run "$path" > "$pen/out.$$" 2>&1; then
      verdict=green
      green=$((green + 1))
    else
      verdict=red
      red=$((red + 1))
      tail -n 200 "$pen/out.$$" > "$pen/evidence.$name.txt"
      echo "  evidence $red_room/$name.txt"
    fi
    rm -f "$pen/out.$$"
  else
    verdict=absent
    red=$((red + 1))
  fi
  echo "ran $name $stamp $verdict $tier" >> "$pen/fresh"
  echo "$name $verdict"
  ran=$((ran + 1))
done < "$pen/todo"

# Taken before the runner writes its own card, so the digest describes the tree the GUARDS saw
# rather than the tree plus this runner's bookkeeping. The card is gitignored here and so invisible
# to `git status --porcelain` either way; ordering it this way means a clone where it is not yet
# ignored still reads honestly.
tree_close=$(tree_digest)

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
echo "guards_green=$green"
echo "guards_red=$red"
echo "host=$this_host"
echo "skipped_host=$skipped_host"
echo "tree_at_close=$tree_close"
echo "tree_moved=$moved"

if [ "$red" -ne 0 ]; then
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

# The record a future open compares against, written only at a fully green, unmoved close --
# so the receipt can never speak a green the roster did not prove on this exact tree.
{
  echo "# construction/standing-equipment-receipt.kyri -- the last fully green close on THIS pier."
  echo "# The hit-rate meter's record (fusion build, measurement only); skipped by nothing."
  echo "format standing-equipment-receipt-v1"
  echo "digest $tree_close"
  echo "guards $ran"
  echo "stamp $stamp"
} > "$receipt_tmp"
# Same room, same reason as the hit ledger above: a pen has no `construction/` to write into.
if [ -d "$(dirname "$receipt")" ]; then
  cat "$receipt_tmp" > "$receipt"
else
  echo "roster_receipt_write=skipped_no_room"
fi
rm -f "$receipt_tmp"

echo "run_verdict=ok"
exit 0
