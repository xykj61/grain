#!/bin/sh
# convergence_tree_prove.sh -- run a whole-tree operator twice on a throwaway checkout and see
# whether the second run changes anything.
#
# WHY A SECOND PROVER. `tools/c/convergence_prove.sh` settles the question by RUNNING, and it
# invokes a tool with ONE path. Measured `20260908.190452`, nine of the ten tools
# `tools/c/convergence_census.sh` finds answer to a FLAG rather than a path -- `apply`, `write`,
# `--check`, a `dry|apply` mode -- because they are whole-tree operators that find their own work.
# So the census column reads whether somebody WROTE an idempotence check, and for nine of ten
# nobody could have run one. This is the instrument that can.
#
# The subject is a repository rather than a file, so the pen is a repository:
# `git worktree add --detach` gives a real checkout of HEAD with a working `git ls-files`, costs
# under two seconds, and is removed whole at the end. The tree under test is never touched -- and
# that sentence stood here for a day while the opposite was true (`20260909.170804`). The prover
# `cd`-ed into the pen and then invoked the tool by its path in the REAL tree; a tool resolving its
# own root from `$0`, which 100 tracked tools here do, walked back out and edited the live tree. It
# read `inert` while writing a landed-accounts shelf, under a fabricated `999999` stamp, into
# `construction/archive/` in the working tree of the ship that ran it. That file is named here
# without its path on purpose: it was removed the same hour, so a full basename would read as a
# citation and resolve nowhere -- the shape `.claude/rules/stamp-and-name.md` refuses under
# *illustrate with placeholders, cite only what exists*, and `dated_path`'s lost census counted it.
# The tool is copied into the pen and run there now, so `$0` resolves inside the pen and the claim
# above is one the code keeps.
#
#   sh tools/c/convergence_tree_prove.sh [--perturb <command>] <tool> [<arg>...]
#
# WHAT A SAMPLE IS HERE, and it is the hazard the sibling prover already paid for. That prover
# learned that a sample which triggers no path proves nothing, and named the reading `inert`. For a
# whole-tree operator the sample is the TREE, and a committed tree is usually already in the state
# the operator produces -- `reds_ledger_headline_write.sh write` runs in `tools/hooks/pre-commit`
# on every commit, so at HEAD it has nothing left to do. Reading `inert` there is honest and it
# proves nothing about convergence. `--perturb` is how a caller hands over a tree that HAS work
# waiting: one shell command, run once inside the pen before the first run, exactly as the sibling
# takes one sample file.
#
# NINE VERDICTS (this line read SIX over a list of seven until `20260909.201720`, when the two
# below joined it):
#   converges         -- the second run left the tree byte-identical to what the first run left.
#   diverges          -- the second run changed the tree again. A red, and the paths are printed.
#   inert             -- the first run changed nothing, so nothing was exercised and the reading
#                        proves nothing. Reported, never counted as a pass.
#   unseen            -- the first run wrote ONLY paths `.gitignore` denies, so `git write-tree` is
#                        blind to its whole output. A refusal rather than a report: `inert` is a
#                        claim about the subject, and this instrument never looked where it wrote.
#   perturb_unseen    -- the PERTURBATION wrote only ignored paths. It landed on disk; the tree hash
#                        cannot see it, so the subject was never asked. Told apart from
#                        `perturb_inert` for the same reason that one was told apart from `inert`.
#   perturb_inert     -- the PERTURBATION changed nothing, so the sample never landed. Told apart
#                        from `inert` because they are two different facts and only one of them is
#                        about the tool. This verdict was earned rather than designed: the first
#                        witness written over this prover passed a `sed` expression through Rishi,
#                        the escaping doubled its backslashes, the expression matched nothing, and
#                        it exited zero. Nothing was wrong with the tool and the reading said
#                        `inert` -- a broken sample wearing a true verdict's clothes.
#   refused           -- the first run exited non-zero. A tool that refused has not converged; it
#                        has not run, and calling that a pass is what `instrument_refusal` gates.
#   write_once        -- it ran once, then refused its own output and changed NOTHING. Accrete-
#                        never-break asks exactly this of a shelf writer, so the refusal IS the
#                        convergence. Counted as a pass.
#   refused_on_second -- it ran once, then changed the tree again AND refused. The sharpest
#                        divergence. Told apart from `write_once` by asking the tree rather than
#                        by reading the exit code, because those are two facts wearing one
#                        appearance -- and the first real tool this prover ever reached, the
#                        account-shelf writer, wears the harmless one.
#
# HOW THE TREE IS COMPARED. `git add -A` then `git write-tree` in the pen yields one hash over every
# path, its bytes, and its mode -- so a mode-only change is caught, which `.claude/rules/exec-bit.md`
# exists because a diff of lines cannot see. The pen's index is its own; the tree under test has no
# part in it.
#
# BOUNDS: one tool, one perturbation, at most two runs, one pen, at most 12 paths printed on a
# divergence. The pen is removed on every exit path including an interrupt.
set -eu

PERTURB=
if [ "${1:-}" = "--perturb" ]; then
  PERTURB=${2:-}
  [ -n "$PERTURB" ] || { echo "refused: --perturb wants a command" >&2; exit 2; }
  shift 2
fi

TOOL=${1:-}
[ -n "$TOOL" ] || { echo "usage: convergence_tree_prove.sh [--perturb <command>] <tool> [<arg>...]" >&2; exit 2; }
shift
[ -f "$TOOL" ] || { echo "refused: no tool at $TOOL" >&2; exit 2; }

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "refused: not a git repository" >&2; exit 2; }
TOOL_ABS=$(cd "$(dirname "$TOOL")" && pwd)/$(basename "$TOOL")

# WHERE THE TOOL IS RUN FROM DECIDES WHICH TREE IT EDITS. This tree's tools resolve their own root
# from `$0` -- `root=$(cd "$(dirname "$0")/../.." && pwd)` -- and then `cd` to it, so a tool invoked
# by its path in the REAL tree walks straight back out of the pen and works on the tree under test.
# Measured `20260909.170804`: 100 tracked tools in `tools/` carry that idiom. The pen is a full
# checkout, so the tool has a path INSIDE it; running that copy is what makes `$0` resolve to the pen.
# A tool from outside the repository has no in-pen path and keeps its own, which is honest, since it
# has no root of this tree's to resolve.
ROOT_REAL=$(CDPATH= cd -- "$ROOT" && pwd -P)
TOOL_REAL=$(CDPATH= cd -- "$(dirname "$TOOL")" && pwd -P)/$(basename "$TOOL")
TOOL_REL=
case "$TOOL_REAL" in
  "$ROOT_REAL"/*) TOOL_REL=${TOOL_REAL#"$ROOT_REAL"/} ;;
esac

# THE PEN LIVES OUTSIDE THE TREE ON PURPOSE. A whole-tree operator finds its own work by walking the
# repository, so a pen nested inside it would be part of its own subject.
pen=$(mktemp -d "${TMPDIR:-/tmp}/conv-tree.XXXXXX")
rmdir "$pen"
cleanup() { git -C "$ROOT" worktree remove --force "$pen" >/dev/null 2>&1 || rm -rf "$pen"; rm -rf "${scratch:-}"; }
trap cleanup EXIT INT TERM

git -C "$ROOT" worktree add --detach "$pen" HEAD >/dev/null 2>&1 \
  || { echo "refused: could not make a pen checkout" >&2; exit 2; }

# THE VERSION UNDER TEST IS THE ONE ON DISK, never the one HEAD remembers. The pen is a checkout of
# HEAD, so a tool edited and not yet committed -- which is every tool a lap is repairing -- would be
# proven in its elder form. The copy lands BEFORE the baseline is taken, so it is invisible to every
# comparison below. `cat >` writes through the checkout's own inode, keeping the mode git tracks
# (`.claude/rules/exec-bit.md`).
RUN_TOOL=$TOOL_ABS
if [ -n "$TOOL_REL" ]; then
  mkdir -p "$pen/$(dirname "$TOOL_REL")"
  if [ -e "$pen/$TOOL_REL" ]; then cat "$TOOL_REAL" > "$pen/$TOOL_REL"; else cp "$TOOL_REAL" "$pen/$TOOL_REL"; fi
  RUN_TOOL="$pen/$TOOL_REL"
fi

# THE INTERPRETER FOLLOWS THE SUBJECT'S LANGUAGE, and until `20260909` it did not. Both runs below
# read `sh "$RUN_TOOL"`, so a Rishi operator was parsed as shell: handed
# `tools/r/readme_metrics.rish write`, the prover answered `verdict=refused -- the first run exited
# non-zero` over a shell syntax error, which reads as the TOOL refusing when what happened is the
# prover not speaking its language. The reach this costs grows rather than shrinks: this tree holds
# 2,407 tracked `.rish` sources against 913 `.sh`, and `construction/ITINERARY.md` seats
# *an operational shell script molts to Rishi on substantial touch*, so every time that law is
# followed a subject leaves this prover's reach. Two of the three pages `tools/hooks/pre-commit`
# regenerates on EVERY commit -- `tools/r/readme_metrics.rish` and `tools/g/geode_libraries.rish` --
# are Rishi, and neither had ever been asked whether it converges.
#
# THE INTERPRETER IS RESOLVED FROM THE PROVER'S OWN PATH, never from the pen or the subject
# repository, because `rishi/bin/rishi` is a built binary this tree does not track: a `git worktree`
# pen holds no copy of it, and a pen repository a control builds has no Rishi anywhere. The subject
# is the pen's, so `$0` resolves inside the pen; the interpreter is the machine's.
RISHI_BIN=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)/rishi/bin/rishi
case "$TOOL" in
  *.rish)
    # invariant: a Rishi subject is refused by name rather than fed to a shell that cannot read it.
    [ -x "$RISHI_BIN" ] || { echo "refused: no rishi interpreter at $RISHI_BIN -- a Rishi subject needs one" >&2; exit 2; }
    ;;
esac

# invariant: one dispatch, written once, so the two runs below can never disagree about how the
# subject is invoked -- a prover whose runs differ proves nothing about the tool.
run_subject() {
  case "$TOOL" in
    *.rish) ( cd "$pen" && "$RISHI_BIN" run "$RUN_TOOL" "$@" ) ;;
    *) ( cd "$pen" && sh "$RUN_TOOL" "$@" ) ;;
  esac
}

state() { git -C "$pen" add -A >/dev/null 2>&1; git -C "$pen" write-tree; }

# A TREE HASH CANNOT SEE A PATH GIT IGNORES, AND THE TWO INERT VERDICTS ARE WHERE THAT COSTS
# (`20260909.201720`). `git add -A` stages what is not ignored, so `write-tree` is blind to every
# ignored path -- and this tree's own `.gitignore` denies the whole repository root (`/*`, then
# allow-backs, because the repository sits inside a sandboxed home), so a file written at the root
# moves the disk and moves no hash. Proven in a pen before the repair, both halves: an operator
# rewriting an ignored `notes.txt` with a fresh timestamp on EVERY run -- a tool that diverges every
# time it is called -- read `inert`, and a perturbation writing an ignored root file read
# `perturb_inert`, whose own words are "the sample never landed". Both sentences were false, and
# the second was met by a hand: proving the front door's metrics splice took two tries, the first
# writing its block file to the pen root.
#
# The listing is asked only where the hash has just said nothing moved, so the ordinary path pays
# for none of it; measured 0.15s over this tree's 16,000 tracked files. The prover's own `.run*.out`
# and `.perturb.out` are dropped by name, since they are this instrument's scratch rather than the
# subject's writes -- each is removed before its reading, and a guard that depends on that ordering
# is a guard one edit away from lying.
ignored_state() {
  git -C "$pen" status --porcelain --ignored=matching 2>/dev/null \
    | sed -n 's/^!! //p' | grep -vE '^\.(run1|run2|perturb)\.out$' | sort
}

scratch=$(mktemp -d "${TMPDIR:-/tmp}/conv-tree-ig.XXXXXX")

baseline=$(state)
ignored_state > "$scratch/ig_baseline"

if [ -n "$PERTURB" ]; then
  ( cd "$pen" && sh -c "$PERTURB" ) >"$pen/.perturb.out" 2>&1 \
    || { echo "tool=$TOOL"; echo "verdict=refused"; echo "detail: the perturbation itself failed -- no tree was prepared"; sed 's/^/  /' "$pen/.perturb.out" | head -5; exit 1; }
  rm -f "$pen/.perturb.out"
  # A PERTURBATION THAT LEFT NO MARK NEVER HAPPENED. Reading that as `inert` would blame the tool
  # for a sample that never landed -- one appearance over two facts, which is the braid this tree
  # keeps finding. A command may exit zero and match nothing, so the tree is what gets asked.
  if [ "$(state)" = "$baseline" ]; then
    echo "tool=$TOOL"
    echo "perturb=$PERTURB"
    ignored_state > "$scratch/ig_now"
    if cmp -s "$scratch/ig_baseline" "$scratch/ig_now"; then
      echo "verdict=perturb_inert"
      echo "detail: the perturbation exited zero and changed nothing -- the sample never landed, so the tool was never asked"
    else
      echo "verdict=perturb_unseen"
      echo "detail: the perturbation wrote only paths git ignores, so the tree hash cannot see it -- the sample landed on disk and never reached the subject"
      comm -13 "$scratch/ig_baseline" "$scratch/ig_now" | head -12 | sed 's/^/  /'
    fi
    exit 1
  fi
fi
before=$(state)
ignored_state > "$scratch/ig_before"

if ! run_subject "$@" >"$pen/.run1.out" 2>&1; then
  echo "tool=$TOOL"
  echo "verdict=refused"
  echo "detail: the first run exited non-zero -- no convergence claim can be made"
  sed 's/^/  /' "$pen/.run1.out" | head -5
  exit 1
fi
rm -f "$pen/.run1.out"
after_one=$(state)

echo "tool=$TOOL"
echo "args=$*"
[ -n "$PERTURB" ] && echo "perturb=$PERTURB"

if [ "$before" = "$after_one" ]; then
  ignored_state > "$scratch/ig_after_one"
  # THE TOOL'S HALF OF THE SAME BLINDNESS, and it is the sharper one. A perturbation nobody sees is
  # a sample that never landed; a WRITE nobody sees is a tool whose whole output is invisible to the
  # comparison that judges it. `unseen` refuses rather than reporting, because `inert` says the tree
  # exercised no path and that would be a claim about the subject made by an instrument that never
  # looked at where the subject wrote.
  if ! cmp -s "$scratch/ig_before" "$scratch/ig_after_one"; then
    echo "verdict=unseen"
    echo "detail: the first run wrote only paths git ignores, so the comparison is blind to its whole output -- no convergence claim can be made"
    comm -13 "$scratch/ig_before" "$scratch/ig_after_one" | head -12 | sed 's/^/  /'
    exit 1
  fi
  echo "verdict=inert"
  echo "detail: the first run changed nothing, so this tree exercises no path -- the reading proves nothing"
  exit 0
fi

if ! run_subject "$@" >"$pen/.run2.out" 2>&1; then
  second_said=$(sed 's/^/  /' "$pen/.run2.out" | head -5)
  rm -f "$pen/.run2.out"
  # A REFUSAL IS NOT YET A VERDICT -- ASK THE TREE. A tool that refuses its own output and leaves the
  # tree exactly as its first run left it has converged, by refusing rather than by rewriting, and
  # that is the shape accrete-never-break asks of every write-once writer this tree owns: a shelf is
  # immutable once written, so the second run's `shelf_exists` IS the promise being kept. Calling
  # that the sharpest divergence would red the whole family, and a verdict nobody believes is a
  # verdict nobody reads. What separates the two is one question -- did the tree move?
  if [ "$after_one" = "$(state)" ]; then
    echo "verdict=write_once"
    echo "detail: the second run refused and changed nothing -- the tool converges by declining its own output"
    printf '%s\n' "$second_said"
    exit 0
  fi
  echo "verdict=refused_on_second"
  echo "detail: the tool ran once, then changed the tree again AND refused -- the sharpest kind of divergence"
  printf '%s\n' "$second_said"
  exit 1
fi
rm -f "$pen/.run2.out"
after_two=$(state)

if [ "$after_one" = "$after_two" ]; then
  echo "verdict=converges"
  exit 0
fi

echo "verdict=diverges"
echo "detail: the second run changed the tree again -- running it twice does not do what running it once did"
git -C "$pen" diff --name-status "$after_one" "$after_two" | head -12 | sed 's/^/  /'
exit 1
