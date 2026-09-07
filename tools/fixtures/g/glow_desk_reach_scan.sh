#!/bin/sh
# tools/fixtures/g/glow_desk_reach_scan.sh -- which Glow desks does the desk witness actually run?
#
# WHY THIS EXISTS. glow/gen/ holds the generated desk corpus for the language, and exactly one
# guard runs desks: tools/g/glow_run_desk_witness.rish, 1,133 lines of hand-written blocks that
# name their desks one at a time. A hand-written enumeration standing in for a population drifts
# the moment the population grows, and nothing in this tree could see the drift. Measured
# 20260907.004636: the witness named 213 desks and glow/gen/ held 352.
#
# THE BRAID THIS UNTANGLES. A desk's run-contract -- may this file be handed to glow_run? -- was
# declared in three places that no instrument could read together:
#
#   arity        tools/g/glow_run_worker.sh, a hand-written `case` over stem names
#   runnability  a `::` prose comment inside the desk ("Parse-only; do not glow_run")
#   coverage     the 213 hand-written blocks inside glow_run_desk_witness.rish
#
# Three enumerations of one corpus, none derived from any other. The agreement between them was
# real and perfect -- the five desks that declare themselves unrunnable are exactly the five the
# witness declines to name, and running all 139 uncovered desks on metal 20260907 confirmed those
# same five as the only ones that fail. That agreement lived in a person's memory, which is the
# one place a check cannot stand. This meter puts it somewhere a lap can feel it.
#
# WHAT IT READS. Every *.glow under glow/gen/, and the desk paths named by the desk witness.
# Seven readings come out; four are gated at zero and one is the ratchet.
#
#   desks           every *.glow under glow/gen/, the whole corpus
#   norun_by_name   desks whose stem carries `refuse` -- the contract written in the name
#   norun_by_head   desks whose leading `::` comments declare Refuse or `do not glow_run`
#   norun_disagree  the symmetric difference of those two           -- GATED AT ZERO
#   declared_norun  the agreed set: a desk that says both ways it must not run
#   covered         distinct desks the witness names
#   phantom         covered desks absent from disk                  -- GATED AT ZERO
#   contradicted    declared_norun desks the witness runs anyway    -- GATED AT ZERO
#   runnable        desks - declared_norun
#   uncovered       runnable - covered                              -- THE RATCHET
#
# WHY norun_disagree IS GATED AND NOT MERELY REPORTED. The two markers are independent statements
# of one fact, and this tree has watched a single marker drift in silence all week. A desk renamed
# out of `-refuse` while its head still says `do not glow_run` -- or the reverse -- is a contract
# that has come apart, and the failure is invisible from either side alone. Two readings that must
# agree are cheap to hold and loud when they part. Today both name the same five.
#
# WHY phantom AND contradicted ARE SEPARATE GATES. Each answers one question, per the single-
# stranded discipline: phantom asks whether the witness asserts on a file that exists, and
# contradicted asks whether the witness and the desk disagree about whether the desk may run. They
# fire on different faults and a reader repairing one must not have to reason about the other.
#
# WHY uncovered IS A RATCHET RATHER THAN A GATE. It stands at 134 today. A ceiling that only falls
# means a desk landing tomorrow must be covered by the witness, declare itself unrunnable in both
# markers, or turn this guard red on the lap it arrives -- which is the whole promise, and it costs
# no repair of the standing 134 to make. Gating at zero would refuse the tree for a backlog nobody
# created today, and a guard that reds on ordinary work is a guard somebody turns off.
#
# A FOURTH KIND, FOUND ON METAL AND LEFT TO ITS OWNER. Running all 139 uncovered desks
# 20260907 turned up three files under glow/gen/s/ that fail with `unsupported Glow head` --
# sample-demo-fact-line-lits.glow, sample-demo-fixture-lits.glow and sample-digraph-table.glow.
# They are data fixtures rather than desks (sample-digraph-table.glow names its own twin,
# tools/fixtures/g/glow_digraph_table.txt) and they carry no marker in either the name or the
# head, so no instrument can tell them from a desk that ought to run. They stay inside `uncovered`
# and are named here instead: giving them a marker changes what declares a desk's kind, which is a
# language custody ruling rather than a repair a lap takes. The reading is therefore honest about
# what it is -- files under glow/gen/ that no marker excuses and nothing runs -- rather than a
# claim that all 129 are desks awaiting coverage.
#
# WHAT THIS DOES NOT REACH. Whether a covered desk's assertion is a good one, and whether an
# uncovered desk would pass if it were run. Of the 139 measured on metal 20260907, 59 ran GREEN
# bare and 41 refused for want of a sample argument the witness would have to choose. Choosing
# those arguments is a separate lap; this meter only says which desks nothing speaks for.
#
#   sh tools/fixtures/g/glow_desk_reach_scan.sh

set -u

# One collation for the whole script. sort and comm must agree, and they only agree when both
# read the same LC_ALL -- a comm over files sorted under another collation reports differences
# that are not there. This scan read 10 phantom desks that way before the export was added.
LC_ALL=C
export LC_ALL

# Root by upward walk (seated 20260828): the letter fold moves this script's depth, so fixed
# ../.. arithmetic breaks. Git-free, so a pen copy outside a repository still resolves.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_gd_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/glow" ]; do
  _gd_steps=$((_gd_steps + 1))
  if [ "$_gd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs tools/fixtures and glow)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

DESK_DIR=${GLOW_DESK_DIR:-glow/gen}
WITNESS=${GLOW_DESK_WITNESS:-tools/g/glow_run_desk_witness.rish}

# Bound: the corpus stood at 352 on 20260907 and grows by hand, a few desks a round. 4096 is a
# power of two an order of magnitude above that -- high enough never to refuse honest growth, low
# enough that a runaway generator writing desks in a loop is named rather than scanned forever.
MAX_DESKS=4096

if [ ! -d "$DESK_DIR" ]; then
  echo "glow_desk_reach: no desk room at $DESK_DIR" >&2
  exit 2
fi
if [ ! -f "$WITNESS" ]; then
  echo "glow_desk_reach: no desk witness at $WITNESS" >&2
  exit 2
fi

WORK=$(mktemp -d 2>/dev/null || echo "/tmp/glow_desk_reach.$$")
mkdir -p "$WORK" || exit 2
trap 'rm -rf "$WORK"' EXIT INT TERM

find "$DESK_DIR" -name '*.glow' -type f | sort > "$WORK/desks"
desks=$(wc -l < "$WORK/desks" | tr -d ' ')

if [ "$desks" -gt "$MAX_DESKS" ]; then
  echo "glow_desk_reach: $desks desks past the bound of $MAX_DESKS" >&2
  exit 2
fi

# The contract written in the name. A stem carrying `refuse` says so in every listing and diff.
grep -E '/[^/]*refuse[^/]*\.glow$' "$WORK/desks" | sort > "$WORK/norun_name" || true
norun_by_name=$(wc -l < "$WORK/norun_name" | tr -d ' ')

# The contract written in the head. Read only the leading comment band -- the first 6 `::` lines --
# so a desk mentioning refusal deep in its body is not mistaken for one declaring its own contract.
: > "$WORK/norun_head"
while IFS= read -r desk; do
  if head -6 "$desk" | grep -qiE '^::[[:space:]]*refuse|do not glow_run' 2>/dev/null; then
    printf '%s\n' "$desk" >> "$WORK/norun_head"
  fi
done < "$WORK/desks"
sort -o "$WORK/norun_head" "$WORK/norun_head"
norun_by_head=$(wc -l < "$WORK/norun_head" | tr -d ' ')

# Two independent statements of one fact. Their disagreement is the gated reading.
comm -3 "$WORK/norun_name" "$WORK/norun_head" | sed 's/^[[:space:]]*//' | grep -v '^$' > "$WORK/disagree" || true
norun_disagree=$(wc -l < "$WORK/disagree" | tr -d ' ')

comm -12 "$WORK/norun_name" "$WORK/norun_head" > "$WORK/declared_norun"
declared_norun=$(wc -l < "$WORK/declared_norun" | tr -d ' ')

# What the witness names. A desk path in any position counts as covered -- the witness runs each
# through glow_run and asserts the path back out of the claim line, so naming it is running it.
grep -oE "$DESK_DIR/[A-Za-z0-9._-]+/[A-Za-z0-9._-]+\.glow" "$WITNESS" | sort -u > "$WORK/covered"
covered=$(wc -l < "$WORK/covered" | tr -d ' ')

comm -23 "$WORK/covered" "$WORK/desks" > "$WORK/phantom"
phantom=$(wc -l < "$WORK/phantom" | tr -d ' ')

comm -12 "$WORK/declared_norun" "$WORK/covered" > "$WORK/contradicted"
contradicted=$(wc -l < "$WORK/contradicted" | tr -d ' ')

comm -23 "$WORK/desks" "$WORK/declared_norun" > "$WORK/runnable"
runnable=$(wc -l < "$WORK/runnable" | tr -d ' ')

comm -23 "$WORK/runnable" "$WORK/covered" > "$WORK/uncovered"
uncovered=$(wc -l < "$WORK/uncovered" | tr -d ' ')

# The ceiling lives here rather than in the witness, so a control can move it by name and prove
# the refusal from both sides. A ceiling only falls: lower it when a repair lands.
UNCOVERED_CEILING=${GLOW_DESK_UNCOVERED_CEILING:-129}

verdict=ok
if [ "$norun_disagree" -ne 0 ]; then
  verdict=marker_disagree
  echo "detail: the two run-contract markers name different desks --"
  sed 's/^/  /' "$WORK/disagree"
fi
if [ "$phantom" -ne 0 ]; then
  verdict=phantom
  echo "detail: the witness names desks that are not on disk --"
  sed 's/^/  /' "$WORK/phantom"
fi
if [ "$contradicted" -ne 0 ]; then
  verdict=contradicted
  echo "detail: the witness runs desks that declare they must not run --"
  sed 's/^/  /' "$WORK/contradicted"
fi
if [ "$uncovered" -gt "$UNCOVERED_CEILING" ]; then
  verdict=over_ceiling
  echo "detail: $uncovered runnable desks are run by nothing, past the ceiling of $UNCOVERED_CEILING --"
  comm -23 "$WORK/uncovered" "$WORK/covered" | head -20 | sed 's/^/  /'
fi

echo "desks=$desks"
echo "norun_by_name=$norun_by_name"
echo "norun_by_head=$norun_by_head"
echo "norun_disagree=$norun_disagree"
echo "declared_norun=$declared_norun"
echo "covered=$covered"
echo "phantom=$phantom"
echo "contradicted=$contradicted"
echo "runnable=$runnable"
echo "uncovered=$uncovered"
echo "uncovered_ceiling=$UNCOVERED_CEILING"
echo "verdict=$verdict"

[ "$verdict" = ok ] || exit 1
exit 0
