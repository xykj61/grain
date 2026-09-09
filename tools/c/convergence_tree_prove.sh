#!/bin/sh
# convergence_tree_prove.sh -- run a whole-tree operator twice on a throwaway checkout and see
# whether the second run changes anything.
#
# WHY A SECOND PROVER. `tools/c/convergence_prove.sh` settles the question by RUNNING, and it
# invokes a tool as `sh <tool> <one-path>`. Measured `20260908.190452`, nine of the ten tools
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
# read `inert` while writing `construction/archive/20260909-999999_itinerary-landed-accounts.md`
# into the working tree of the ship that ran it. The tool is copied into the pen and run there now,
# so `$0` resolves inside the pen and the claim above is one the code keeps.
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
# SIX VERDICTS:
#   converges         -- the second run left the tree byte-identical to what the first run left.
#   diverges          -- the second run changed the tree again. A red, and the paths are printed.
#   inert             -- the first run changed nothing, so nothing was exercised and the reading
#                        proves nothing. Reported, never counted as a pass.
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
cleanup() { git -C "$ROOT" worktree remove --force "$pen" >/dev/null 2>&1 || rm -rf "$pen"; }
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

state() { git -C "$pen" add -A >/dev/null 2>&1; git -C "$pen" write-tree; }

baseline=$(state)

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
    echo "verdict=perturb_inert"
    echo "detail: the perturbation exited zero and changed nothing -- the sample never landed, so the tool was never asked"
    exit 1
  fi
fi
before=$(state)

if ! ( cd "$pen" && sh "$RUN_TOOL" "$@" ) >"$pen/.run1.out" 2>&1; then
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
  echo "verdict=inert"
  echo "detail: the first run changed nothing, so this tree exercises no path -- the reading proves nothing"
  exit 0
fi

if ! ( cd "$pen" && sh "$RUN_TOOL" "$@" ) >"$pen/.run2.out" 2>&1; then
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
