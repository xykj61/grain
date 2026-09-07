#!/bin/sh
# tools/fixtures/g/glow_desk_reach_scan.sh -- which Glow desks does the desk witness actually run?
#
# WHY THIS EXISTS. glow/gen/ is the desk ROOM this meter reads, and exactly one
# guard ran desks: tools/g/glow_run_desk_witness.rish, 1,133 lines of hand-written blocks that
# name their desks one at a time. A hand-written enumeration standing in for a population drifts
# the moment the population grows, and nothing in this tree could see the drift. Measured
# 20260907.020441: the witness names 218 desks and glow/gen/ holds 352.
#
# A SECOND INSTRUMENT NOW RUNS DESKS, AND THIS READING WENT ON ASKING ONLY THE FIRST.
# tools/fixtures/g/glow_desk_run_scan.sh, rostered 20260907.110022, derives the bare-runnable set
# from the room on every pass and runs all 301 of it. For one lap after that landed, this scan
# still read `covered` out of the elder witness alone and so reported 83 desks "run by nothing"
# that a rostered guard was running -- two instruments answering differently about one population.
# `covered` is a union from 20260907.122532, and `uncovered_bare` fell from a ratchet of 83 to a
# gate at zero: what it counts now is a desk NOTHING runs, which is a fault rather than a backlog. (This door read 213 and
# 134 for one lap -- the numbers a mis-collated `comm` produced before `LC_ALL=C` was exported
# below, left standing in the prose when the fix landed in the code. A door that recites a
# number its own body disproves is the drift this meter exists to catch, one room in.)
#
# THE ROOM IS NOT THE CORPUS, AND THIS DOOR ONCE SAID IT WAS. The sentence above read "glow/gen/
# holds the generated desk corpus for the language" until 20260907.045422, and it was false when it
# was written: the tree carries 451 tracked *.glow files in eighteen rooms, 99 of them outside
# glow/gen/ -- 49 under src/gate/, 39 under src/shape/, 7 under tools/fixtures/g/, and four
# elsewhere. `uncovered` stays scoped to the room on purpose, since those rooms have their own
# runners (47 of 49 src/gate/ desks and all 39 src/shape/ desks are named by some tool), and
# widening it would fold four questions into one and raise a ceiling that may only fall. What
# changed is that the claim is now `corpus_glow` and `corpus_outside`, printed below, rather than a
# sentence: a hand-named room is an enumeration with one element, and one element is the easiest
# length at which an enumeration passes for a population.
#
# THE BRAID THIS UNTANGLES. A desk's run-contract -- may this file be handed to glow_run? -- was
# declared in three places that no instrument could read together:
#
#   arity        tools/g/glow_run_worker.sh, a hand-written `case` over stem names
#   runnability  a `::` prose comment inside the desk ("Parse-only; do not glow_run")
#   coverage     the 218 hand-written blocks inside glow_run_desk_witness.rish
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
#   desks           every *.glow under glow/gen/, this room's whole population
#   norun_by_name   desks whose stem carries `refuse` -- the contract written in the name
#   norun_by_head   desks whose leading `::` comments declare Refuse or `do not glow_run`
#   norun_disagree  the symmetric difference of those two           -- GATED AT ZERO
#   declared_norun  the agreed set: a desk that says both ways it must not run
#   covered_witness distinct desks the elder hand-written witness names
#   covered_runner  distinct desks the derived runner selects and runs, asked by --list
#   covered         their union -- what anything in this tree runs
#   phantom         covered desks absent from disk                  -- GATED AT ZERO
#   contradicted    declared_norun desks the witness runs anyway    -- GATED AT ZERO
#   runnable        desks - declared_norun
#   uncovered       runnable - covered                              -- derived from its two parts
#   sample_list     stems the worker's `case` permits a sample argument
#   sample_phantom  permitted stems naming no .glow in the tree     -- GATED AT ZERO
#   sample_permitted  desks in this room the worker will take a sample for
#   uncovered_sampled uncovered desks the worker only runs WITH a sample  -- RATCHET
#   uncovered_bare  bare-runnable desks NOTHING runs                 -- GATED AT ZERO
#   corpus_glow     every *.glow in the tree, all rooms
#   corpus_outside  those standing outside this room
#   stem_collision  stems two or more *.glow files share
#
# THE THIRD ENUMERATION, READ AT LAST, AND WHAT IT SPLIT. The braid above named three hand-written
# statements about this corpus and this meter read two of them -- name marker against head marker,
# and coverage against the room. The third, the worker's sample-permission `case`, went unread for
# a lap, and reading it turns one number into two.
#
# The witness runs every desk it names with ZERO arguments: 218 run lines, every one ending
# `.glow"]`, measured 20260907.020441. The worker refuses an argument for any stem absent from its
# `case`, and permits one for 94 stems, of which 46 live in this room. **Every one of those 46 is
# uncovered, and not one is covered.** That is not a coincidence and not an oversight -- it is the
# boundary of the instrument's shape, drawn exactly.
#
# So `uncovered=129` was holding two debts that cost different things. Eighty-three are desks the
# witness could name tomorrow in one three-line block. Forty-six need a sample value somebody must
# choose -- what argument proves this gate? -- and then a fourth hand-written enumeration to hold
# the answers, which is the shape %532 booked in the first place. A single ratchet also hides a
# real fault: cover one bare desk while one sample-taking desk lands, and 129 stands unchanged.
#
# Two ceilings, each falling on its own repair, and the sum derived from them rather than spelled.
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
# WHY uncovered IS A RATCHET RATHER THAN A GATE. It stands at 129 today, in two parts. A ceiling that only falls
# means a desk landing tomorrow must be covered by the witness, declare itself unrunnable in both
# markers, or turn this guard red on the lap it arrives -- which is the whole promise, and it costs
# no repair of the standing 129 to make. Gating at zero would refuse the tree for a backlog nobody
# created today, and a guard that reds on ordinary work is a guard somebody turns off.
#
# A FOURTH KIND, FOUND ON METAL AND LEFT TO ITS OWNER. Running all 129 uncovered desks
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
WORKER=${GLOW_DESK_WORKER:-tools/g/glow_run_worker.sh}
RUNNER=${GLOW_DESK_RUNNER:-tools/fixtures/g/glow_desk_run_scan.sh}

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
if [ ! -f "$WORKER" ]; then
  echo "glow_desk_reach: no run worker at $WORKER" >&2
  exit 2
fi
if [ ! -f "$RUNNER" ]; then
  echo "glow_desk_reach: no derived runner at $RUNNER" >&2
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

# WHAT RUNS A DESK, READ FROM BOTH INSTRUMENTS. Two things run desks in this tree now, and until
# 20260907.122532 this reading knew about one of them.
#
#   covered_witness  the desk paths tools/g/glow_run_desk_witness.rish names, one hand-written
#                    block at a time. A desk path in any position counts: the witness runs each
#                    through glow_run and asserts the path back out of the claim line, so naming
#                    it is running it.
#   covered_runner   the selection tools/fixtures/g/glow_desk_run_scan.sh derives from the room
#                    and runs on every pass, asked for by name with --list so nothing is compiled
#                    to answer the question.
#
# `covered` is their UNION, because the reading's own question is *does anything run this desk*.
# Read from the witness alone it answered a narrower question -- does the ELDER witness name it --
# and printed the answer under the wider question's name. That is how this scan came to report 83
# bare-runnable desks "run by nothing" on a lap where a rostered guard ran all 83 of them; two
# instruments answering differently about one population, which is the same braid this meter was
# built to untangle, one turn further out.
grep -oE "$DESK_DIR/[A-Za-z0-9._-]+/[A-Za-z0-9._-]+\.glow" "$WITNESS" | sort -u > "$WORK/covered_witness"
covered_witness=$(wc -l < "$WORK/covered_witness" | tr -d ' ')

# The runner is asked rather than re-derived. Deriving its selection a second time here would put
# a fourth hand-written statement of the run-contract in the tree, which is the fault, not the fix.
# --list prints one desk path a line and compiles nothing; a runner that cannot answer refuses the
# whole reading rather than letting an empty answer read as an honest zero.
if ! sh "$RUNNER" --list > "$WORK/runner_raw" 2>"$WORK/runner_err"; then
  echo "glow_desk_reach: the derived runner refused --list (see below)" >&2
  sed 's/^/  /' "$WORK/runner_err" >&2
  exit 2
fi
grep -E "^$DESK_DIR/" "$WORK/runner_raw" | sort -u > "$WORK/covered_runner" || true
covered_runner=$(wc -l < "$WORK/covered_runner" | tr -d ' ')

sort -u "$WORK/covered_witness" "$WORK/covered_runner" > "$WORK/covered"
covered=$(wc -l < "$WORK/covered" | tr -d ' ')

comm -23 "$WORK/covered" "$WORK/desks" > "$WORK/phantom"
phantom=$(wc -l < "$WORK/phantom" | tr -d ' ')

comm -12 "$WORK/declared_norun" "$WORK/covered" > "$WORK/contradicted"
contradicted=$(wc -l < "$WORK/contradicted" | tr -d ' ')

comm -23 "$WORK/desks" "$WORK/declared_norun" > "$WORK/runnable"
runnable=$(wc -l < "$WORK/runnable" | tr -d ' ')

comm -23 "$WORK/runnable" "$WORK/covered" > "$WORK/uncovered"
uncovered=$(wc -l < "$WORK/uncovered" | tr -d ' ')

# THE THIRD ENUMERATION, AND THE SPLIT IT FORCES. tools/g/glow_run_worker.sh holds a `case` over
# stem names deciding which desks may be handed a sample argument at all; a desk absent from it is
# refused by the worker the moment an argument is passed. That list is the third hand-written
# statement about this corpus, and it is the one the coverage reading above cannot see.
#
# Read it from the `case` PATTERN lines rather than by grepping the file for stem-shaped words, so
# a stem named in a comment is never mistaken for a permission. Both readings were taken on
# 20260907 and agreed exactly at 94, which is how the anchor was chosen.
awk '
  /^[[:space:]]*#/ { next }
  /^[[:space:]]*[A-Za-z0-9_*|-]+\)[[:space:]]*$/ ||
  /^[[:space:]]*[A-Za-z0-9_*|-]+\)[[:space:]]+/ {
    line=$0
    sub(/\).*$/, "", line)
    gsub(/^[[:space:]]+/, "", line)
    n=split(line, parts, "|")
    for (i=1; i<=n; i++) if (parts[i] != "*" && parts[i] != "") print parts[i]
  }
' "$WORKER" | sort -u > "$WORK/sample_list"
sample_list=$(wc -l < "$WORK/sample_list" | tr -d ' ')

# A permitted stem naming no Glow file anywhere in the tree is a dead branch in the `case` -- the
# same fault `phantom` reads one enumeration over, and gated for the same reason. Scoped to the
# whole tree rather than to DESK_DIR on purpose: 48 of the 94 name desks under src/gate, src/shape
# and tools/fixtures, and those are somebody else's room rather than a fault of this one.
#
# The tree-wide population is derived ONCE, here, and every reading below shares it. Dot
# directories are machinery -- .git holds objects and glow/.cache holds a lowered REPL line -- and
# vendor/, seed/ and node_modules/ are other people's trees or a projection of this one. Pruning
# those four reads exactly the paths `git ls-files '*.glow'` reads, two methods and one answer,
# while keeping this scan git-free so a pen outside a repository still resolves. The elder spelling
# pruned .git alone and so counted a build-cache artifact as a desk, which is the shape that lets a
# dead permission read as live: a stem whose only file is a leftover under glow/.cache/ would have
# satisfied sample_phantom.
find . -type d \( -name '.?*' -o -name vendor -o -name seed -o -name node_modules \) -prune \
  -o -name '*.glow' -type f -print | sed 's|^\./||' | sort > "$WORK/corpus"
corpus_glow=$(wc -l < "$WORK/corpus" | tr -d ' ')

if [ "$corpus_glow" -gt "$MAX_DESKS" ]; then
  echo "glow_desk_reach: $corpus_glow desks tree-wide, past the bound of $MAX_DESKS" >&2
  exit 2
fi

sed -e 's|.*/||' -e 's|\.glow$||' "$WORK/corpus" | sort -u > "$WORK/tree_stems"
comm -23 "$WORK/sample_list" "$WORK/tree_stems" > "$WORK/sample_phantom"
sample_phantom=$(wc -l < "$WORK/sample_phantom" | tr -d ' ')

# What stands outside the room this meter reads. Reported and gated nowhere: a desk landing in
# src/gate/ is ordinary work in another lane, and a guard that reds on ordinary work is a guard
# somebody turns off. Its whole job is to keep the door's claim checkable.
grep -v "^$DESK_DIR/" "$WORK/corpus" > "$WORK/outside"
outside_rc=$?
if [ "$outside_rc" -gt 1 ]; then
  echo "glow_desk_reach: grep failed splitting the corpus by room (exit $outside_rc)" >&2
  exit 2
fi
corpus_outside=$(wc -l < "$WORK/outside" | tr -d ' ')

# Two desks sharing one stem share one built binary, since tools/g/glow_run_worker.sh writes
# glow/bin/<stem>, and one sample permission, since its `case` matches the stem alone. Reported
# rather than gated: both of today's pairs predate the reading, and which file keeps the name is a
# language custody question rather than a repair a lap takes.
sed -e 's|.*/||' -e 's|\.glow$||' "$WORK/corpus" | sort | uniq -d > "$WORK/stem_collision"
stem_collision=$(wc -l < "$WORK/stem_collision" | tr -d ' ')

# The split, taken over PATHS rather than stems, so nothing here assumes a stem names one file.
# A desk is `sampled` when the worker's list carries its stem: the witness runs every desk it names
# with zero arguments (218 run lines, every one ending `.glow"]`, measured 20260907), so a desk the
# worker will only accept WITH an argument cannot be covered by the witness in its present shape.
: > "$WORK/sample_permitted"
while IFS= read -r desk; do
  stem=${desk##*/}
  stem=${stem%.glow}
  if grep -qxF "$stem" "$WORK/sample_list"; then
    printf '%s\n' "$desk" >> "$WORK/sample_permitted"
  fi
done < "$WORK/desks"
sort -o "$WORK/sample_permitted" "$WORK/sample_permitted"
sample_permitted=$(wc -l < "$WORK/sample_permitted" | tr -d ' ')

comm -12 "$WORK/uncovered" "$WORK/sample_permitted" > "$WORK/uncovered_sampled"
uncovered_sampled=$(wc -l < "$WORK/uncovered_sampled" | tr -d ' ')
comm -23 "$WORK/uncovered" "$WORK/sample_permitted" > "$WORK/uncovered_bare"
uncovered_bare=$(wc -l < "$WORK/uncovered_bare" | tr -d ' ')

# TWO CEILINGS, BECAUSE ONE NUMBER WAS HOLDING TWO COSTS. The ceilings live here rather than in
# the witness, so a control can move them by name and prove the refusal from both sides, and a
# ceiling only falls. What changed on 20260907.020441 is that there are two of them:
#
#   uncovered_bare      0 -- a bare-runnable desk nothing runs. The derived runner closed this
#                            debt on 20260907 by running the whole bare-runnable set, so the
#                            ceiling is zero and the reading has changed character: it is no
#                            longer a backlog counting down, it is a GATE on the two derivations
#                            agreeing. This scan computes `runnable` by excluding the marker
#                            INTERSECTION; the runner excludes by their UNION. Those agree only
#                            while `norun_disagree` is zero, and the day a desk is half-declared
#                            both readings fire together, which is the truth said twice rather
#                            than once. A desk landing in a room the runner's selection misses
#                            for any other reason reds here on the lap it arrives.
#   uncovered_sampled  46 -- a desk the worker will only run WITH a sample somebody must choose
#
# The elder single ceiling of 129 could not tell those apart, and they were not the same debt. A
# bare desk cost a line. A sampled desk costs a judgment -- what value proves this gate? -- and
# then a fourth hand-written enumeration to hold the answer, which is the very shape %532 booked.
# Worse, the sum hides a real fault: a sampled desk landing while a bare one is covered leaves 129
# standing, and the elder gate reads that as no change.
#
# The sum is printed and DERIVED from the two rather than spelled, so it can never disagree with
# its parts; the gates are on the parts.
UNCOVERED_BARE_CEILING=${GLOW_DESK_UNCOVERED_BARE_CEILING:-0}
UNCOVERED_SAMPLED_CEILING=${GLOW_DESK_UNCOVERED_SAMPLED_CEILING:-46}
UNCOVERED_CEILING=$((UNCOVERED_BARE_CEILING + UNCOVERED_SAMPLED_CEILING))

verdict=ok
if [ "$norun_disagree" -ne 0 ]; then
  verdict=marker_disagree
  echo "detail: the two run-contract markers name different desks --"
  sed 's/^/  /' "$WORK/disagree"
fi
if [ "$phantom" -ne 0 ]; then
  verdict=phantom
  echo "detail: a desk named as covered is not on disk --"
  sed 's/^/  /' "$WORK/phantom"
fi
if [ "$contradicted" -ne 0 ]; then
  verdict=contradicted
  echo "detail: a covered desk declares it must not run --"
  sed 's/^/  /' "$WORK/contradicted"
fi
if [ "$sample_phantom" -ne 0 ]; then
  verdict=sample_phantom
  echo "detail: the worker permits a sample for stems that name no Glow file in the tree --"
  sed 's/^/  /' "$WORK/sample_phantom"
fi
if [ "$uncovered_bare" -gt "$UNCOVERED_BARE_CEILING" ]; then
  verdict=over_bare_ceiling
  echo "detail: $uncovered_bare bare-runnable desks are run by nothing, past the ceiling of $UNCOVERED_BARE_CEILING --"
  head -20 "$WORK/uncovered_bare" | sed 's/^/  /'
fi
if [ "$uncovered_sampled" -gt "$UNCOVERED_SAMPLED_CEILING" ]; then
  verdict=over_sampled_ceiling
  echo "detail: $uncovered_sampled sample-taking desks are run by nothing, past the ceiling of $UNCOVERED_SAMPLED_CEILING --"
  head -20 "$WORK/uncovered_sampled" | sed 's/^/  /'
fi

echo "desks=$desks"
echo "norun_by_name=$norun_by_name"
echo "norun_by_head=$norun_by_head"
echo "norun_disagree=$norun_disagree"
echo "declared_norun=$declared_norun"
echo "covered_witness=$covered_witness"
echo "covered_runner=$covered_runner"
echo "covered=$covered"
echo "phantom=$phantom"
echo "contradicted=$contradicted"
echo "runnable=$runnable"
echo "uncovered=$uncovered"
echo "uncovered_ceiling=$UNCOVERED_CEILING"
echo "sample_list=$sample_list"
echo "sample_phantom=$sample_phantom"
echo "sample_permitted=$sample_permitted"
echo "uncovered_sampled=$uncovered_sampled"
echo "uncovered_sampled_ceiling=$UNCOVERED_SAMPLED_CEILING"
echo "uncovered_bare=$uncovered_bare"
echo "uncovered_bare_ceiling=$UNCOVERED_BARE_CEILING"
echo "corpus_glow=$corpus_glow"
echo "corpus_outside=$corpus_outside"
echo "stem_collision=$stem_collision"
echo "verdict=$verdict"

[ "$verdict" = ok ] || exit 1
exit 0
