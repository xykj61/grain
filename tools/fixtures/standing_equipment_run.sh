#!/bin/sh
# tools/fixtures/standing_equipment_run.sh -- run the rostered guards of a tier, and record when each ran.
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
# runner does not know is refused by tools/fixtures/standing_equipment_scan.sh rather than run past,
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
#   sh tools/fixtures/standing_equipment_run.sh                 # cold open -- tier lap, dirty index refuses
#   sh tools/fixtures/standing_equipment_run.sh --hot           # after `git add` -- the staged paths are mine
#   sh tools/fixtures/standing_equipment_run.sh --all           # every tier, choirs included
#   sh tools/fixtures/standing_equipment_run.sh --tier cadence  # one tier
#   sh tools/fixtures/standing_equipment_run.sh banner_room     # one guard by name, whatever its tier
#
# The flags compose: `--hot --all` is the cadence lap's own after-`git add` pass.
#
# Run from the repository root. Slow by nature -- it runs a roster.

set -eu

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
card="${STANDING_CARD:-construction/standing-equipment-runs.kyri}"

want_tier=lap
only=""
hot=no

# A loop rather than a single case, so `--hot` composes with `--all` and with `--tier`. A bare word
# is a guard name and selects every tier, which is what asking for one guard has always meant.
while [ $# -gt 0 ]; do
  case "$1" in
    --hot)  hot=yes ;;
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
trap 'rm -rf "$pen"' EXIT

# The staged reading, before a single guard runs. A pen outside a repository answers 0 rather than
# refusing, so a control can drive this runner without standing inside git.
staged=0
if git rev-parse --git-dir >/dev/null 2>&1; then
  staged=$(git diff --cached --name-only 2>/dev/null | grep -c . || true)
fi
echo "staged_uncommitted=$staged"

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

# Pass one: which guards does this pass run, and what tier does each carry. A guard record is open
# from its `guard` line until the next one, so the tier is read wherever it sits inside the record.
awk -v want="$want_tier" -v only="$only" '
  function flush(   t) {
    if (name == "") return
    t = (tier == "" ? "lap" : tier)
    if (only != "" && name != only)                { name = ""; path = ""; tier = ""; return }
    if (only == "" && want != "all" && t != want)  { name = ""; path = ""; tier = ""; return }
    print name, (path == "" ? "-" : path), t
    name = ""; path = ""; tier = ""
  }
  $1 == "guard" { flush(); name = $2; next }
  $1 == "path"  { if (name != "") path = $2; next }
  $1 == "tier"  { if (name != "") tier = $2; next }
  END { flush() }
' "$roster" > "$pen/todo"

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

while read -r name path tier; do
  [ -n "$name" ] || continue
  if [ "$path" != "-" ] && [ -f "$path" ]; then
    if rishi/bin/rishi run "$path" >/dev/null 2>&1; then
      verdict=green
      green=$((green + 1))
    else
      verdict=red
      red=$((red + 1))
    fi
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

{
  echo "# construction/standing-equipment-runs.kyri -- when each standing guard last ran on THIS pier."
  echo "# Written by tools/fixtures/standing_equipment_run.sh; untracked on purpose, so a fresh"
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

echo "run_verdict=ok"
exit 0
