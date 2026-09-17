#!/bin/sh
# tools/fixtures/c/control_perturbation_scan.sh -- does a guard's ANSWER move when its own
# control goes away?
#
#   sh tools/fixtures/c/control_perturbation_scan.sh [--candidates] [<scan path> ...]
#
# WHY. Its sibling `control_in_population_scan.sh` reads MEMBERSHIP: it extracts a scan's own
# `git ls-files` invocation, runs it, and asks whether a tracked file of the scan's family stands
# inside the population that comes back. That reading names an upper bound in its own header and
# says why -- a scan may enumerate broadly and filter narrowly, so membership is no proof the scan
# READS the file. The exact question is whether the numbers CHANGE when the control leaves, and
# answering it wants a checkout per candidate. This script is that checkout.
#
# WHAT IT DOES, per candidate scan. It adds a detached git worktree at HEAD in a temporary pen,
# runs the scan there and keeps the output, removes the scan's family INSTRUMENT -- a tracked
# `_control.sh` sharing its stem, or failing that a plant under `context/fixtures/` carrying the
# stem -- from both the pen's index and the pen's working tree, runs the scan again, and compares
# the two outputs.
#
#   unmoved         -- byte-identical output. The control's presence is invisible to the guard.
#   moved           -- some printed reading differs, and every `verdict=` line still agrees.
#   verdict_flipped -- a `verdict=` line differs. The guard's PASS or REFUSE is partly a statement
#                      about its own instrument rather than about the field.
#
# BOTH DIRECTIONS ARE REAL, and only one is the founding shape. INFLATION is a control adding to a
# population a lane reads as its work queue, so a ceiling counts sites no repair can ever reach.
# DEPENDENCE runs the other way: a living file cites the control by path, so removing it REDS a
# link guard that is green today because its own instrument is tracked.
#
# WHY THE FILE LEAVES DISK AND NOT ONLY THE INDEX. A scan enumerating with `git ls-files` reads the
# index; a scan enumerating with `find` reads the filesystem. One perturbation has to answer for
# both populations or the reading is a statement about the enumeration style rather than about the
# guard, so the control is made ABSENT in both senses and the class name says `absent` rather than
# `untracked`.
#
# THE CLASS THIS WAS BUILT FOR. Its sibling reports `no_git_population` -- a scan naming no
# `git ls-files` at all -- as GENUINELY UNMEASURED rather than clear, because a `find` rooted at
# the repository root or under `tools/` can reach a control just as well. Running that class
# statically is out of reach for a reason worth stating: measured `20260916` over the 198 no-git
# scans, every `find` root in the reachable subset is a loop variable or a per-scan directory
# variable -- `$room`, `$DIR`, `$DESK_DIR` -- and not one spells a resolvable literal root beyond
# the handful below. So the sibling's admit rule cannot be widened into this class; only running
# the scan reaches it.
#
# THE READING THIS WIDENING MOVED, `20260916`. Resolving the instrument by role rather than by name
# took the skip class from 3 to 1: `copy_sameness_scan.sh` became a real reading (`unmoved` -- its
# plant stands outside its own `find -name tally_copy.rye` by basename), `tools_py_ban_scan.sh`
# joined the named refusal below since it carries the root-finder, and only
# `living_docs_lint_scan.sh` stayed unmeasurable. Probed rose 4 to 5.
#
# ONE WRITER PER CHECKOUT (REDS %291) IS THE RULE THIS SCRIPT MOST EASILY BREAKS. The pen is a
# second checkout of this repository, so nothing outside this script may stand in it while it
# runs -- the first ad-hoc run of this probe was discarded for exactly that fault, on `20260916`,
# when a hand entered the pen mid-probe. The pen is created under `mktemp -d`, OUTSIDE the tree,
# so a peer's `find .` never walks it, and it is removed on every exit path.
#
# THE REACH THIS PROBE HAS, MEASURED RATHER THAN ASSUMED. A pen is a checkout of TRACKED BYTES,
# and 164 tracked shell scripts in this tree -- 74 of them `*_scan.sh` -- locate the repository root
# by walking up until they find a directory `rishi/bin`. Nothing under `rishi/bin` is tracked: it
# holds the built `rishi` binary, so a pristine checkout has no such directory and every one of
# those 164 refuses with `no tree root within 8 steps` before reading a single file. That is why
# the probe reports `refused_root_finder_needs_built_tree` as its own class rather than a blind
# refusal -- a refusal whose cause is named can be repaired, and a blind one reads as the scan's
# fault. The repair is one directory name: `rishi/src` is tracked, sits in the same relationship to
# the root, and is exactly as discriminating -- measured `20260916`, both `rishi/src/` and
# `tools/fixtures/` occur at the repository root and nowhere below it. The bootstrap is NOT
# circular, checked in a pen the same day: `tools/fixtures/r/rye_build.sh` carries no root-finder,
# so a fresh clone still builds `rishi` and every script then works. The cost is latent rather than
# live, and it falls on anyone reasoning over a checkout nobody has built in.
#
# WHAT IT DOES NOT REACH. Whether a moved reading is a fault. A guard reading its own control may
# be entirely correct to do so, which is why the sibling reports membership rather than gating it,
# and why this one prints a classification rather than a refusal.
set -e

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"

MAX_SCANS=2048          # bound: far above the 375 tracked scans read 20260916
MAX_CANDIDATES=64       # bound: the reachable class read 9 on 20260916, the whole census 37
RUN_TIMEOUT=300         # bound, seconds: the slowest candidate measured runs well under this

MODE=run
case "$1" in
  --candidates) MODE=candidates; shift ;;
esac

# candidates: tracked `*_scan.sh` files that name no `git ls-files`, and whose own `find` is rooted
# at the repository root or under `tools/` -- the subset the membership census reads as unmeasured.
candidates() {
  git ls-files | grep -E '_scan\.sh$' | head -n "$MAX_SCANS" | while IFS= read -r s; do
    [ -f "$s" ] || continue
    src=$(sed 's/#.*$//' "$s")
    if printf '%s\n' "$src" | grep -qE 'git ls-files'; then continue; fi
    printf '%s\n' "$src" | grep -oE 'find +[^ ]+' | sed 's/find *//' | sort -u \
      | while IFS= read -r r; do
          case "$r" in .|./|tools|tools/*) echo "$s"; break ;; esac
        done
  done | sort -u | head -n "$MAX_CANDIDATES"
}

if [ "$MODE" = candidates ]; then
  candidates
  exit 0
fi

if [ $# -gt 0 ]; then
  TARGETS=$*
else
  TARGETS=$(candidates)
fi

# family_instrument: what this family plants for its OWN proof, resolved by ROLE rather than by
# NAME, printed as `<kind> <path>`. Empty when neither kind stands, which is a SKIP rather than a
# reading -- there is nothing to take away.
#
#   control -- a tracked `_control.sh` sharing the scan's basename stem.
#   plant   -- a tracked file under `context/fixtures/` whose path carries the stem.
#
# WHY THE SECOND KIND EXISTS. The first reading of this probe skipped three of its nine candidates
# for holding no tracked `_control.sh`, and that one word covered three different states. Measured
# `20260916`: `tools/fixtures/t/tools_py_ban_scan.sh` plants
# `context/fixtures/tools_py_ban_tree/tools/planted.py` and hands its selftest a
# `TOOLS_PY_SCAN_ROOT` override, so the plant stands in a root the living `find tools` never walks.
# `tools/fixtures/c/copy_sameness_scan.sh` plants `context/fixtures/copy_sameness_drift/
# tally_copy_drifted.rye` under a basename its own `find . -name tally_copy.rye` excludes. Both are
# controls by role, under another name and in another room, and both are perturbable. Only
# `tools/fixtures/l/living_docs_lint_scan.sh` is genuinely unmeasurable, and for a reason worth
# telling apart: its family files are a roster and a keeps allowlist, which the scan READS as
# input rather than planting to be found.
#
# WHY THE ROOM DECIDES, rather than a spelling test. The obvious role test asks whether the scan's
# own source names the path -- an input is spelled, a plant is not. It reads wrong on real data:
# `tools/fixtures/l/living_docs_lint_keeps.txt` is spelled by a SIBLING scan
# (`tools/fixtures/r/retired_word_scan.sh`) and never by its own, so the spelling test would call
# an allowlist a plant. The room answers cleanly instead. `context/fixtures/` held 12 tracked files
# on `20260916` and every one is a planted fixture -- a broken-and-valid pair, an unlawful
# descriptor, a drifted copy, a planted `.py` -- while `tools/fixtures/` holds the instruments that
# read them. That is the tree's own filing, so the probe reads it rather than inventing a second.
family_instrument() {
  b=${1##*/}; stem=${b%_scan.sh}
  c=$(git ls-files | awk -v s="$stem" '
    { n = $0; sub(/^.*\//, "", n)
      if (index(n, s) == 1 && n ~ /_control\.sh$/) print $0 }' | head -n 1)
  if [ -n "$c" ]; then echo "control $c"; return 0; fi
  p=$(git ls-files -- 'context/fixtures' | grep -F "$stem" | head -n 1)
  if [ -n "$p" ]; then echo "plant $p"; return 0; fi
  return 0
}

PEN=$(mktemp -d)
BEFORE=$(mktemp); AFTER=$(mktemp); ERR=$(mktemp)
cleanup() {
  cd "$ROOT" 2>/dev/null || true
  [ -n "$PEN" ] && git worktree remove --force "$PEN/tree" >/dev/null 2>&1 || true
  rm -rf "$PEN" "$BEFORE" "$AFTER" "$ERR"
  git worktree prune >/dev/null 2>&1 || true
}
trap cleanup EXIT INT HUP TERM

git worktree add --detach "$PEN/tree" HEAD >/dev/null 2>&1
TREE="$PEN/tree"

probed=0; unmoved=0; moved=0; flipped=0; skipped_no_instrument=0; refused=0; needs_built=0
plants_probed=0

for scan in $TARGETS; do
  inst=$(family_instrument "$scan")
  if [ -z "$inst" ]; then
    skipped_no_instrument=$((skipped_no_instrument + 1))
    echo "skip $scan reason=no_family_instrument"
    continue
  fi
  kind=${inst%% *}
  ctl=${inst#* }

  # Restore the pen to HEAD before each candidate, so every one is measured against the same
  # tree. The ORDER is load-bearing and was wrong in the first draft: `git checkout -- .` restores
  # the working tree FROM THE INDEX, so running it while the index still lacks the previous
  # candidate's control brings nothing back. Reset the index from HEAD first, then check out.
  ( cd "$TREE" && git reset -q && git checkout -q -- . ) >/dev/null 2>&1 || true

  if ! ( cd "$TREE" && timeout "$RUN_TIMEOUT" sh "$scan" ) > "$BEFORE" 2> "$ERR"; then
    : # a non-zero exit is an ANSWER for a scan that gates; the output still compares
  fi
  if [ ! -s "$BEFORE" ]; then
    refused=$((refused + 1))
    if grep -qF 'needs rishi/bin and tools/fixtures' "$ERR"; then
      needs_built=$((needs_built + 1))
      echo "refuse $scan reason=root_finder_needs_built_tree"
    else
      echo "refuse $scan reason=no_output_with_control_present"
    fi
    continue
  fi

  ( cd "$TREE" && git rm -q -f --cached "$ctl" >/dev/null 2>&1; rm -f "$ctl" ) || true

  if ! ( cd "$TREE" && timeout "$RUN_TIMEOUT" sh "$scan" ) > "$AFTER" 2>/dev/null; then
    :
  fi
  if [ ! -s "$AFTER" ]; then
    refused=$((refused + 1))
    echo "refuse $scan reason=no_output_with_control_absent"
    continue
  fi

  probed=$((probed + 1))
  if [ "$kind" = plant ]; then plants_probed=$((plants_probed + 1)); fi
  if cmp -s "$BEFORE" "$AFTER"; then
    unmoved=$((unmoved + 1))
    echo "unmoved $scan instrument=$ctl kind=$kind"
  else
    vb=$(grep -E '^verdict=' "$BEFORE" | sort || true)
    va=$(grep -E '^verdict=' "$AFTER" | sort || true)
    if [ "$vb" = "$va" ]; then
      moved=$((moved + 1))
      echo "moved $scan instrument=$ctl kind=$kind detail=$(diff "$BEFORE" "$AFTER" | grep -E '^[<>]' | tr '\n' ' ' | cut -c1-160)"
    else
      flipped=$((flipped + 1))
      echo "verdict_flipped $scan instrument=$ctl kind=$kind before=$(echo $vb) after=$(echo $va)"
    fi
  fi
done

echo "probed=$probed"
echo "unmoved=$unmoved"
echo "moved=$moved"
echo "verdict_flipped=$flipped"
echo "skipped_no_instrument=$skipped_no_instrument"
echo "plants_probed=$plants_probed"
echo "refused=$refused"
echo "refused_root_finder_needs_built_tree=$needs_built"
echo "perturbation=family_instrument_absent_from_index_and_worktree"
echo "verdict=reported"
