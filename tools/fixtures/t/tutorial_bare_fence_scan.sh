#!/bin/sh
# tools/fixtures/t/tutorial_bare_fence_scan.sh -- a command fence that carries no label makes the
# same promise as one that does, and the guard built for that promise cannot see it.
#
# WHY. `tools/fixtures/t/tutorial_output_scan.sh` runs the command above a quoted output block to
# see whether the page still tells the truth, and it opens a pair only on a fence marked ```sh or
# ```bash. A fence with no label sits in the same room, above the same kind of block, promising the
# same thing to the same reader -- and stands in no pair, so it is neither checked nor counted nor
# held. It is invisible, which reads from outside exactly like clean.
#
# The shelf met this on `docs-geode/tutorials/running-the-fleet.md` (20260917.022557). The page
# declares on its own face that every command below was run against this tree, and it carried
# SIXTEEN bare fences and none tagged -- so the guard whose whole job is holding a quoted block
# true read nothing there, while the page carried a `<!-- volatile: -->` comment written for that
# guard and no other reader. One fence was tagged on that lap. The rest, and every page like it,
# are what this counts.
#
# WHAT IT READS, and why the adjacency is reported rather than gated. The first draft of this
# reading paired an untagged fence with the next untagged fence, on the elder scan's own MAX_GAP
# rule, and classified 29 of 29 candidates as `after_prose` -- a reading that puts its whole
# population in one bucket tells nobody anything. `docs-geode/edu/yonder/discovery/round-trip-walk.md`
# says why on its face: a page of all-bare fences writes COMMAND, prose, COMMAND, prose, so half of
# every adjacency was a command block paired with the next command block. Without a label you
# cannot tell a command block from an output block by POSITION; you tell them apart by reading
# them, which is what the roster does.
#
# So the question narrowed to the half that needs no guess: DOES AN UNTAGGED FENCE HOLD COMMANDS
# THIS TREE COULD RUN? That is exact, decided by the roster alone, and it is the whole coverage
# debt -- the elder scan can never reach such a fence whatever stands below it. Whether an output
# block follows decides how much tagging one WINS, so it is counted beside the answer as
# `bare_runnable_with_block` rather than folded into it.
#
# WHAT IT FOUND, measured over the 80-page corpus at seating: 83 untagged fences, SIX of them
# holding commands the run roster accepts. The other 77 refuse, and the refusal words say what:
#
#   off_roster       62   `env RYE_ZIG=... rye/bin/rye run ...`, Rishi's `let`, a config block
#   metacharacter    12   a pipe, a redirect, a shell variable
#   untracked         3   a script the reader is about to write themselves
#
# AND A LABEL IS NOT FREE TO ADD, which is the finding this reading was built to miss. Tagging a
# fence `sh` tells the elder scan to RUN it, so the tag is a promise about the block below rather
# than a tidy-up. Two of the six stood on `docs-geode/tutorials/running-the-fleet.md`, and tagging
# both was wrong in two different ways: at line 30 the block beneath is the NEXT COMMAND BLOCK
# (`cd`, `mkdir`, the loop launch) rather than that command's output, so the pair would be false;
# at line 107 the fence's first line is `sh tools/f/fleet_watch.sh` with no flag, which watches
# until a hand stops it, so a checked pair would hang for the full timeout and then read as drift.
# Both were tagged on this lap and both were reverted, and only the undeclared-prose rule stood
# between the tags and those two outcomes -- luck rather than design.
#
# SO THE POPULATION SPLITS ON WHAT STANDS BENEATH, which this already computes and is exact:
#
#   `bare_runnable_lone`   -- runnable commands, no untagged block within MAX_GAP beneath. Tagging
#                             one creates NO pair, runs nothing, and simply tells the truth about
#                             the block. GATED AT ZERO. Four stood at seating and this lap took all
#                             four; the repair is one word and the wall is what keeps it taken.
#
#   `bare_runnable_paired` -- runnable commands with an untagged block beneath. Tagging one is a
#                             CLAIM that the block is this command's output, and only a reader of
#                             the page can make it. RATCHET at two, falling when a hand reads a page
#                             and either tags the fence or declares the prose between them.
#
# THE CLASSES NAME THE ROSTER'S OWN REFUSAL, never the block's genre. Telling a Rishi listing from
# a shell recipe is a judgment, and this declines to make it: a Rye block refuses as
# `off_roster:const`, which is true and coarse and tells a hand exactly what stands between that
# fence and coverage.
#
# WHAT IS REPORTED, never gated: every untagged fence's refusal word, counted by class and named
# page and line under the `list` verb. A population reported as a bare count is visible the way a
# locked door is visible, which the elder scan learned the hard way.
#
# WHAT THIS DOES NOT REACH. It never runs a command -- the elder scan owns running, and this owns
# counting what that scan cannot see. It reads a fence close as a bare ``` line, the room's
# convention and the elder parser's rule. It cannot tell an output block from the next command
# block, which is precisely why the paired half is a ratchet a reader lowers rather than a wall.
# And it says nothing about whether a fence should carry a `rye`, `rish` or `kyri` tag instead;
# that is a second reading over the same population, named here so the decline is visible.
#
# USAGE
#   sh tools/fixtures/t/tutorial_bare_fence_scan.sh          # report on this tree
#   sh tools/fixtures/t/tutorial_bare_fence_scan.sh list     # every candidate, one per line
#
# Driven by tools/t/tutorial_bare_fence_witness.rish. Pen: tools/fixtures/t/tutorial_bare_fence_control.sh.
# Run from the repository root.

set -u

# The run roster -- one rule, two readers.
# A SIBLING rather than a root-relative path: a mutant copy of this scan is written into a pen and
# run from another tree, so the rule has to travel with the file rather than with the cwd.
ROSTER="$(dirname "$0")/tutorial_run_roster.sh"
if [ ! -f "$ROSTER" ]; then
  echo "verdict=no_run_roster"
  echo "refused: the run roster is the rule this reading applies and it is not beside this script" >&2
  exit 1
fi
# shellcheck disable=SC1090
. "$ROSTER"

verb=${1:-report}

# A LONE runnable untagged fence is walled at zero: tagging it creates no pair, runs nothing, and
# the repair is one word. Four stood at seating 20260917 and all four were taken in the commit that
# seated this, so the wall refuses the next one on the lap it lands.
LONE_CEILING=${TUTORIAL_BARE_LONE_CEILING:-0}

# A PAIRED one is a ratchet, because tagging it claims the block beneath is that command's output
# and only a reader of the page knows. Two at seating, both on running-the-fleet. The ceiling falls
# when a hand reads one and either tags the fence or declares what the prose between them does; it
# rises only when the CORPUS widens, the one honest reason a ratchet ceiling may move up.
PAIRED_CEILING=${TUTORIAL_BARE_PAIRED_CEILING:-2}

# The same screen of prose the elder scan allows between a command and the block answering it.
MAX_GAP_LINES=${TUTORIAL_BARE_MAX_GAP_LINES:-12}

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "verdict=not_a_git_tree"
  echo "refused: this scan reads the tracked corpus and there is no git tree here" >&2
  exit 1
fi

CORPUS=${TUTORIAL_BARE_CORPUS:-docs-geode/*.md manual/*.md SOURCE.md}
# The corpus is a list of GIT PATHSPECS: the shell's own globbing is switched off so `*` reaches
# across a slash the way git's does. Left on, `docs-geode/*.md` becomes one top-level page.
set -f
# shellcheck disable=SC2086
set -- $CORPUS
set +f
# `sort -u` because `git ls-files` prints one line per INDEX STAGE, so a page standing
# unresolved mid-rebase arrives three times and every fence on it is counted three times. Met on
# metal `20260917`: `running-the-fleet.md` read 6 paired fences against its 2 while its conflict
# was unstaged, which is a reading about the index wearing the clothes of a reading about the page.
git ls-files -- "$@" 2>/dev/null | sort -u > "$work/pages.txt" || : > "$work/pages.txt"
pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
echo "pages_considered=$pages"

# ---- parse: every untagged fence, and whether a block stands under it --------------------------
# invariant: a fence's label is read from its OPENER, so a close is never mistaken for an opener.
: > "$work/index.txt"
n=0
while IFS= read -r page; do
  [ -f "$page" ] || continue
  n=$(awk -v pen="$work" -v page="$page" -v start="$n" -v maxgap="$MAX_GAP_LINES" '
    BEGIN { n = start; inside = 0; pending = 0; gap = 0 }
    /^```/ {
      if (inside == 0) {
        # An opener. A bare block waiting below is answered by an untagged fence and ended by a
        # tagged one -- the WITH_BLOCK reading, reported rather than gated.
        if (pending > 0) { withblock[pending] = ($0 == "```") ? 1 : 0; pending = 0 }
        inside = 1; tag = substr($0, 4); opener = NR; buf = ""
        next
      }
      inside = 0
      if (tag == "") {
        n++
        printf "%s", buf > (pen "/u." n ".cmd")
        lineof[n] = opener; pageof[n] = page
        pending = n; gap = 0
      }
      next
    }
    inside == 1 { buf = buf $0 "\n"; next }
    pending > 0 { gap++; if (gap > maxgap) pending = 0; next }
    END {
      for (k = start + 1; k <= n; k++)
        printf "%s\t%d\t%d\n", pageof[k], lineof[k], (k in withblock ? withblock[k] : 0) >> (pen "/index.txt")
      print n
    }
  ' "$page")
done < "$work/pages.txt"

fences=$n
echo "untagged_fences=$fences"

# ---- classify -----------------------------------------------------------------------------------
lone=0; paired=0
: > "$work/lines.txt"

i=0
while [ "$i" -lt "$fences" ]; do
  i=$((i + 1))
  meta=$(sed -n "${i}p" "$work/index.txt")
  page=$(printf '%s' "$meta" | cut -f1)
  line=$(printf '%s' "$meta" | cut -f2)
  hasblock=$(printf '%s' "$meta" | cut -f3)
  why=$(run_roster_why "$work/u.$i.cmd")

  if [ "$why" != passes ]; then
    printf '%s:%s\tbare_off_roster\t%s\n' "$page" "$line" "$why" >> "$work/lines.txt"
  elif [ "${hasblock:-0}" -eq 1 ]; then
    paired=$((paired + 1))
    printf '%s:%s\tbare_runnable_paired\t%s\n' "$page" "$line" \
      "an untagged block stands beneath -- read the page before tagging, since the block may be the next command rather than this one's output" \
      >> "$work/lines.txt"
  else
    lone=$((lone + 1))
    printf '%s:%s\tbare_runnable_lone\t%s\n' "$page" "$line" \
      "tag this fence sh -- no block stands beneath, so the tag creates no pair and runs nothing" \
      >> "$work/lines.txt"
  fi
done

if [ "$verb" = list ]; then
  sort "$work/lines.txt"
  exit 0
fi

echo "bare_runnable_lone=$lone"
echo "lone_ceiling=$LONE_CEILING"
echo "bare_runnable_paired=$paired"
echo "paired_ceiling=$PAIRED_CEILING"

# The refusal words, counted by class. A population reported as a bare count is visible the way a
# locked door is visible -- `list` names every fence, page and line.
awk -F'\t' '$2 == "bare_off_roster" { w = $3; sub(/:.*/, "", w); c[w]++ }
     END { for (k in c) printf "off_roster_class: %s=%d\n", k, c[k] }' "$work/lines.txt" | sort

awk -F'\t' '$2 == "bare_runnable_lone"   { printf "lone: %s -- %s\n", $1, $3 }' "$work/lines.txt" | sort
awk -F'\t' '$2 == "bare_runnable_paired" { printf "paired: %s -- %s\n", $1, $3 }' "$work/lines.txt" | sort

if [ "$lone" -gt "$LONE_CEILING" ]; then
  echo "verdict=lone_untagged_fence_holds_runnable_commands"
  exit 1
fi
if [ "$paired" -gt "$PAIRED_CEILING" ]; then
  echo "verdict=paired_untagged_fence_over_ceiling"
  exit 1
fi
echo "verdict=every_runnable_untagged_fence_named"
