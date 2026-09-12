#!/bin/sh
# tools/fixtures/g/glow_desk_run_scan.sh -- run every bare-runnable Glow desk, derived from the room.
#
# WHAT THIS READS AND WHY IT IS DERIVED. glow/gen/ holds the generated desk corpus for the Glow
# language, and until now exactly one guard ran any of it: tools/g/glow_run_desk_witness.rish,
# 1,133 lines naming 218 desks one block at a time. REDS %532 booked that shape -- a hand-written
# enumeration standing in for a population reads as coverage from every side, and it drifts the
# moment the population grows. This scan takes the other road: it derives its own population from
# the room on every run, so a desk landing tomorrow is run tomorrow.
#
# THE SELECTION, in three steps, each the same reading tools/fixtures/g/glow_desk_reach_scan.sh
# already takes, so the two meters cannot come to disagree about what a desk is:
#
#   1. every *.glow under glow/gen/
#   2. minus every desk declaring it must not run, by EITHER marker -- `refuse` in the stem, or
#      `Refuse` / `do not glow_run` in the first six `::` lines of its head. The reach scan gates
#      the two markers' DISAGREEMENT at zero and excludes by their intersection; this scan excludes
#      by their UNION, which is the safe direction for a runner: a desk half-declared is a desk we
#      decline to hand to the compiler, rather than one we hand over on a technicality.
#   3. minus every desk whose stem sits in tools/g/glow_run_worker.sh's sample-permission `case`
#      AND whose head declares no sample. A sampled desk refuses to run without an argument, and
#      the elder reading stopped there: choosing that argument was called a judgment per desk
#      rather than a loop, so 46 desks stood run by nothing. Holding the answers in a table here
#      would be a FOURTH hand-written enumeration of one corpus -- the shape REDS %532 booked in
#      the first place. So the desk carries its own, in the same head band its run-contract already
#      uses:
#
#          ::  Sample: 3 5
#
#      One line, in the file the sample proves, read on every pass. A sampled desk landing tomorrow
#      declares what proves it or stays out of the selection and is counted by name.
#
# What remains is the SELECTION: 347 desks measured 20260908 -- the whole runnable room, 301 bare
# and 46 declaring their own sample -- where the elder witness names 218 and nothing named the
# other 129.
#
# THE COMPILER IS BUILT ONCE, AND THAT IS MOST OF THE COST. tools/g/glow_run_worker.sh rebuilds
# glow/bin/glow_run from glow/glow_run.rye on EVERY invocation, because one desk run is one hand's
# gesture and the hand may have edited the compiler. Measured on this pier 20260907: a desk through
# the worker costs 3.80s, of which 2.42s is that rebuild and 1.38s is the desk's own lower, build
# and run. Over the elder witness's 218 blocks that is roughly 527s spent re-linking one unchanged
# binary. A batch builds it once, so 301 desks cost about 420s rather than 1,144s.
#
# The desk lower-build-run below is the worker's own sequence, held here rather than shelled out to
# it, for exactly one reason: the worker's whole job is to serve a hand running one desk, and its
# compiler rebuild is correct for that caller. Rewriting the worker to please a batch would trade a
# guarantee six ships rely on for a saving only this scan wants.
#
#   sh tools/fixtures/g/glow_desk_run_scan.sh          # run them
#   sh tools/fixtures/g/glow_desk_run_scan.sh --list   # print the selection, run nothing

set -u

# One collation for the whole script. sort and comm agree only when both read the same LC_ALL; the
# reach scan read 10 phantom desks before it learned this.
LC_ALL=C
export LC_ALL

# Root by upward walk, git-free, so a pen copy outside a repository still resolves.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_gr_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/glow" ]; do
  _gr_steps=$((_gr_steps + 1))
  if [ "$_gr_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs tools/fixtures and glow)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

DESK_DIR=${GLOW_DESK_DIR:-glow/gen}
WORKER=${GLOW_DESK_WORKER:-tools/g/glow_run_worker.sh}
ZIG=${RYE_ZIG:-vendor/zig-toolchain/zig}

# Bound: the corpus stood at 352 on 20260907 and grows by hand, a few desks a round. 4096 is a
# power of two an order of magnitude above that -- high enough never to refuse honest growth, low
# enough that a runaway generator writing desks in a loop is named rather than run forever.
MAX_DESKS=4096

# The ceiling only falls. It stands at 3 rather than 0 because three files under glow/gen/ are data
# fixtures rather than desks and carry no marker in either name or head -- sample-demo-fact-line-lits,
# sample-demo-fixture-lits and sample-digraph-table. Giving them a marker changes what declares a
# desk's kind, which is a language custody ruling rather than a repair a lap takes (REDS %532).
FAILED_CEILING=${GLOW_DESK_RUN_FAILED_CEILING:-3}

# A RUNNABLE SAMPLED DESK THAT DECLARES NO SAMPLE, held at zero. The ceiling is zero rather than a
# ratchet counting down because all 46 were given their line in one lap, measured on metal before
# it was written -- each desk run with its own declared values through tools/g/glow_run.rish, 46 of
# 46 GREEN. A backlog earns a ratchet; an empty set earns a wall, and the wall is what makes the
# next sampled desk arrive covered. The cure is one line in the desk's own head, and the refusal
# below names it.
SAMPLE_UNDECLARED_CEILING=${GLOW_DESK_SAMPLE_UNDECLARED_CEILING:-0}

# A per-desk runner the control can replace. Left empty, the scan runs the real lower-build-run
# below; a pen sets it to a stub so the reading -- selection, counting, ceiling, refusal -- is
# proven without a Zig toolchain on the bench. The stub receives one desk path and exits 0 or not.
RUN_ONE=${GLOW_DESK_RUN_ONE:-}

list_only=no
for arg in "$@"; do
  case "$arg" in
    --list) list_only=yes ;;
    *) echo "$0: unknown argument $arg" >&2; exit 2 ;;
  esac
done

if [ ! -d "$DESK_DIR" ]; then
  echo "glow_desk_run: no desk room at $DESK_DIR" >&2
  exit 2
fi
if [ ! -f "$WORKER" ]; then
  echo "glow_desk_run: no run worker at $WORKER" >&2
  exit 2
fi

WORK=$(mktemp -d 2>/dev/null) || { echo "glow_desk_run: no temporary directory" >&2; exit 2; }
# THE SIGNAL TRAPS ONLY EXIT, and the EXIT trap does the cleanup exactly once, however this pass
# ends. A handler that cleans up WITHOUT exiting does not stop the script: POSIX runs it and RESUMES
# where the signal landed, so the pass carries on against the pen its own handler just removed
# (REDS %487, and this scan's own first version reddened `signal_trap` for exactly that spelling).
trap 'rm -rf "$WORK"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

find "$DESK_DIR" -name '*.glow' -type f | sort > "$WORK/desks"
desks=$(wc -l < "$WORK/desks" | tr -d ' ')

if [ "$desks" -gt "$MAX_DESKS" ]; then
  echo "glow_desk_run: $desks desks past the bound of $MAX_DESKS" >&2
  exit 2
fi

# The contract written in the name.
grep -E '/[^/]*refuse[^/]*\.glow$' "$WORK/desks" | sort > "$WORK/norun_name" || true

# The contract written in the head -- the leading comment band only, so a desk mentioning refusal
# deep in its body is never mistaken for one declaring its own contract.
: > "$WORK/norun_head"
while IFS= read -r desk; do
  if head -6 "$desk" | grep -qiE '^::[[:space:]]*refuse|do not glow_run' 2>/dev/null; then
    printf '%s\n' "$desk" >> "$WORK/norun_head"
  fi
done < "$WORK/desks"
sort -o "$WORK/norun_head" "$WORK/norun_head"

sort -u "$WORK/norun_name" "$WORK/norun_head" > "$WORK/norun"
declined=$(wc -l < "$WORK/norun" | tr -d ' ')

# The sample-permission `case`, read from its PATTERN lines rather than by grepping the file for
# stem-shaped words, so a stem named in a comment is never mistaken for a permission.
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

: > "$WORK/sampled"
while IFS= read -r desk; do
  stem=${desk##*/}
  stem=${stem%.glow}
  if grep -qxF "$stem" "$WORK/sample_list"; then
    printf '%s\n' "$desk" >> "$WORK/sampled"
  fi
done < "$WORK/desks"
sort -o "$WORK/sampled" "$WORK/sampled"
sampled=$(wc -l < "$WORK/sampled" | tr -d ' ')

comm -23 "$WORK/desks" "$WORK/norun" > "$WORK/runnable"
comm -23 "$WORK/runnable" "$WORK/sampled" > "$WORK/bare"
bare=$(wc -l < "$WORK/bare" | tr -d ' ')

# THE SAMPLE A DESK DECLARES FOR ITSELF, read from the same six-line head band the run-contract
# above is read from, so one band answers every question this scan asks of a desk. The first
# `Sample:` line wins: a desk saying it twice has said one thing twice, and taking the first is the
# reading a human eye takes.
#
# Only a RUNNABLE sampled desk is asked. A desk that has declared it must not run has already
# answered, and counting it undeclared would ask a file to fill in a form it declined to enter.
comm -12 "$WORK/runnable" "$WORK/sampled" > "$WORK/sampled_runnable"
: > "$WORK/sample_declared"
: > "$WORK/sample_undeclared"
while IFS= read -r desk; do
  args=$(head -6 "$desk" | sed -n 's/^::[[:space:]]*Sample:[[:space:]]*//p' | head -1)
  if [ -n "$args" ]; then
    printf '%s\t%s\n' "$desk" "$args" >> "$WORK/sample_declared"
  else
    printf '%s\n' "$desk" >> "$WORK/sample_undeclared"
  fi
done < "$WORK/sampled_runnable"
sort -o "$WORK/sample_declared" "$WORK/sample_declared"
sort -o "$WORK/sample_undeclared" "$WORK/sample_undeclared"
sample_declared=$(wc -l < "$WORK/sample_declared" | tr -d ' ')
sample_undeclared=$(wc -l < "$WORK/sample_undeclared" | tr -d ' ')

cut -f1 "$WORK/sample_declared" | sort > "$WORK/declared_paths"
sort -u "$WORK/bare" "$WORK/declared_paths" > "$WORK/selected"
selected=$(wc -l < "$WORK/selected" | tr -d ' ')

# The selection with each desk's own arguments beside it, so the run loop reads one file rather
# than looking a second one up per desk. A bare desk carries an empty field, which is what makes
# the loop below single -- one path through the corpus, not one for each kind of desk.
# The map is read in BEGIN rather than by the usual NR==FNR two-file idiom, and the control is why:
# NR==FNR asks "am I still in the first file?" by arithmetic, and when the first file is EMPTY that
# arithmetic answers yes for every record of the second -- so a room where no desk declares a sample
# consumed its whole selection as map entries and ran nothing, while every count above still read
# right. A clean room is the commonest room there is.
awk -F'\t' -v decl="$WORK/sample_declared" '
  BEGIN { while ((getline line < decl) > 0) { split(line, f, "\t"); a[f[1]] = f[2] } }
  { print $1 "\t" (($1 in a) ? a[$1] : "") }
' "$WORK/selected" > "$WORK/selected_args"

# --list is the coverage answer other meters ask for, and it runs nothing. Keeping the selection
# and the running in one file is what stops a second enumeration from being born beside this one:
# tools/fixtures/g/glow_desk_reach_scan.sh reads its covered set from here rather than restating
# the rule, so the two can never come to disagree about which desks are spoken for.
if [ "$list_only" = yes ]; then
  cat "$WORK/selected"
  exit 0
fi

if [ -z "$RUN_ONE" ]; then
  # The real path wants the toolchain and the two module links the worker makes. A vane's siblings
  # resolve beside the file the compiler followed, so both links point at the DIRECTORY (REDS %299).
  [ -x "$ZIG" ] || { echo "glow_desk_run: no Zig toolchain at $ZIG" >&2; exit 2; }
  [ -f glow/glow_run.rye ] || { echo "glow_desk_run: no compiler source at glow/glow_run.rye" >&2; exit 2; }
  [ -f tools/fixtures/s/shell_portable.sh ] || { echo "glow_desk_run: no portable shell helpers" >&2; exit 2; }
  . tools/fixtures/s/shell_portable.sh
  mkdir -p glow/bin glow/.cache || exit 2
  ln -sfn ../../tally glow/.cache/tally
  ln -sfn ../../caravan glow/.cache/caravan

  # ONE BUILDER AT A TIME, the same directory lock tools/g/glow_run_worker.sh takes and for the
  # same reason: glow/bin/glow_run and glow/.cache are shared bytes, and two builders interleaving
  # on them buy a red about nothing -- three of those in one round is what put the lock there. The
  # batch holds it once rather than 301 times, which is stronger than the worker's per-run hold and
  # costs a competing hand a wait bounded by GLOW_BUILD_LOCK_WAIT rather than forever.
  BUILD_LOCK=glow/.cache/.build.lock.d
  lock_acquire "$BUILD_LOCK" "${GLOW_BUILD_LOCK_WAIT:-1800}" || {
    echo "glow_desk_run: glow build lock not acquired" >&2
    exit 2
  }
  trap 'lock_release "$BUILD_LOCK"; rm -rf "$WORK"' EXIT

  # Built once, and named as the whole point of the batch. Emitted beside the target and renamed,
  # which is atomic, so an interrupted build leaves the previous good binary standing.
  if ! env RYE_ZIG="$ZIG" rye/bin/rye build glow/glow_run.rye -femit-bin=glow/bin/glow_run.batch.$$ > "$WORK/compiler.log" 2>&1; then
    echo "glow_desk_run: the Glow compiler did not build --" >&2
    tail -20 "$WORK/compiler.log" >&2
    exit 2
  fi
  mv -f glow/bin/glow_run.batch.$$ glow/bin/glow_run
  if [ -f "glow/bin/glow_run.batch.$$.ryekey" ]; then
    mv -f "glow/bin/glow_run.batch.$$.ryekey" glow/bin/glow_run.ryekey
  fi
fi

# One desk: lower, build, run, and report by exit status alone. Nothing here reads prose out of the
# compiler, because a refusal's wording is the compiler's to change and a runner that matched on it
# would red on a reworded message with nothing wrong.
#
# THE STAGE IS PART OF THAT EXIT STATUS, AND THIS FUNCTION SPENT IT. Every one of four stages
# collapsed into a single `return 1`, so `failed` counted a file glow_run DECLINED, a lowering that
# ran and broke, a build that broke, and a binary that exited nonzero as one thing. Those are four
# different faults wanting four different repairs, and one number cannot ask which.
#
# glow_run draws the line itself, in its own contract rather than in its prose (glow/glow_run.rye):
# exit 2 means it DECLINES the file -- no head it knows, more lines than max_lines admits -- and
# exit 1 means a lowering was attempted and failed inside. Reading that code matches no wording, so
# the door's rule above holds exactly as written; what changes is that the status is kept.
#
# WHY THE DISTINCTION IS LOAD-BEARING HERE, measured 20260908.234354. The three unmarked data
# fixtures this scan carries at its ceiling were recorded as refusing "in two distinct ways, two at
# TooManyLines and one at unsupported Glow head." On metal they refuse in THREE, across BOTH exit
# codes -- and the grouping crosses the contract line rather than following it:
#
#   sample-digraph-table.glow        exit 2  unsupported Glow head       glow_run declines
#   sample-demo-fixture-lits.glow    exit 2  too many Glow lines         glow_run declines
#   sample-demo-fact-line-lits.glow  exit 1  multi lower failed          taken as a desk, then broke
#
# The two called one refusal sit on opposite sides of *declined* versus *lowering failed*, and the
# one set apart shares a side with one of them. That correction was written by matching the word
# TooManyLines, which is the one reading this door already says not to make.
#
# AND GLOW_RUN NOW STATES ITS OWN CONTRACT, seated 20260911.230925. The sentence above -- "glow_run
# draws the line itself, in its own contract rather than in its prose" -- was true, and the prose it
# pointed at lived in THIS door rather than in the module returning the number, which is why the
# reading was rewritten twice from metal. glow/glow_run.rye carries the table in its own `//!` head
# now, and tools/g/glow_run_contract_witness.rish holds the table, main's return sites, and the
# built binary's answers to one another.
#
# Two of glow_run's codes each carried two meanings when that table was written, and one of them
# reached this scan. `readFileAlloc` was called with `try`, so FileNotFound, IsDir and
# StreamTooLong each returned through Zig's `!u8` main -- exit 1 -- and the row below named that
# *lowering failed*: a claim about a desk's CONTENT for a file whose bytes were never read. glow_run
# answers `3 unreadable` for all three now, and this scan gives it a stage of its own rather than
# letting it fall to `unclassified`, since a desk that vanished under a running pass and a desk that
# broke in the lowerer want two different repairs.
#
# The stage codes, returned here and expected of a GLOW_DESK_RUN_ONE stub:
#
#   0  ran
#   2  glow_run declined the file          (glow_run exit 2)
#   3  glow_run's lowering failed          (glow_run exit 1)
#   4  the build failed
#   5  the built binary exited nonzero
#   6  glow_run never read the file        (glow_run exit 3 -- absent, a directory, past 64 KiB)
#   1  anything else -- counted, and named unclassified rather than guessed at
#
# glow_run's `4 usage` stays in `unclassified` on purpose: this scan always hands over a path, so a
# usage answer would mean the scan itself is broken, and inventing a stage for it would give that
# fault a name that reads like a fact about a desk.
run_desk() {
  _desk=$1
  shift
  _stem=${_desk##*/}
  _stem=${_stem%.glow}
  # TWO LOWERINGS, and the worker chose between them the same way. A desk handed a sample is
  # lowered with --sample-argv, which emits a program reading its values from argv; a bare desk is
  # lowered with its baked sample. Handing a sampled desk the bare lowering builds a program that
  # ignores the values, which would run, exit 0, and prove nothing.
  _gs=0
  if [ "$#" -gt 0 ]; then
    _rye=$(glow/bin/glow_run --sample-argv "$_desk" 2>>"$WORK/fail.log") || _gs=$?
  else
    _rye=$(glow/bin/glow_run "$_desk" 2>>"$WORK/fail.log") || _gs=$?
  fi
  if [ "$_gs" -ne 0 ]; then
    case "$_gs" in
      2) return 2 ;;
      1) return 3 ;;
      3) return 6 ;;
      *) return 1 ;;
    esac
  fi
  # An empty lowering at exit 0 is neither of glow_run's two refusals, so it stays unclassified
  # rather than borrowing a name that would misreport it.
  [ -n "$_rye" ] || return 1
  env RYE_ZIG="$ZIG" rye/bin/rye build "$_rye" -femit-bin="glow/bin/$_stem.batch.$$" >>"$WORK/fail.log" 2>&1 || return 4
  mv -f "glow/bin/$_stem.batch.$$" "glow/bin/$_stem" || return 4
  if [ -f "glow/bin/$_stem.batch.$$.ryekey" ]; then
    mv -f "glow/bin/$_stem.batch.$$.ryekey" "glow/bin/$_stem.ryekey"
  fi
  "glow/bin/$_stem" "$@" >>"$WORK/fail.log" 2>&1 || return 5
  return 0
}

ran=0
failed=0
failed_declined=0
failed_lower=0
failed_build=0
failed_run=0
failed_unreadable=0
failed_unclassified=0
: > "$WORK/failures"
: > "$WORK/fail.log"
TAB=$(printf '\t')
while IFS="$TAB" read -r desk args; do
  ran=$((ran + 1))
  # $args is deliberately unquoted here and nowhere else: a declared sample is a WORD LIST -- nine
  # decimals for a nona desk -- and the split is the whole point of the field. A bare desk's field
  # is empty, which splits to no words at all, so both kinds walk one loop.
  _st=0
  if [ -n "$RUN_ONE" ]; then
    $RUN_ONE "$desk" $args >/dev/null 2>&1 || _st=$?
  else
    run_desk "$desk" $args || _st=$?
  fi
  if [ "$_st" -ne 0 ]; then
    failed=$((failed + 1))
    case "$_st" in
      2) failed_declined=$((failed_declined + 1)); _stage=declined ;;
      3) failed_lower=$((failed_lower + 1)); _stage=lower ;;
      4) failed_build=$((failed_build + 1)); _stage=build ;;
      5) failed_run=$((failed_run + 1)); _stage=run ;;
      6) failed_unreadable=$((failed_unreadable + 1)); _stage=unreadable ;;
      *) failed_unclassified=$((failed_unclassified + 1)); _stage=unclassified ;;
    esac
    printf '%s %s\n' "$_stage" "$desk" >> "$WORK/failures"
  fi
done < "$WORK/selected_args"

verdict=ok
if [ "$sample_undeclared" -gt "$SAMPLE_UNDECLARED_CEILING" ]; then
  verdict=sample_undeclared
  echo "detail: $sample_undeclared runnable desks take a sample and declare none, past the ceiling of $SAMPLE_UNDECLARED_CEILING --"
  head -20 "$WORK/sample_undeclared" | sed 's/^/  /'
  echo "detail: the cure is one line in the desk's own head band -- ::  Sample: <the values that prove it>"
fi
if [ "$failed" -gt "$FAILED_CEILING" ]; then
  verdict=over_failed_ceiling
  echo "detail: $failed selected desks did not run, past the ceiling of $FAILED_CEILING --"
  head -20 "$WORK/failures" | sed 's/^/  /'
elif [ "$failed" -gt 0 ]; then
  echo "detail: $failed selected desks did not run, at or under the ceiling of $FAILED_CEILING --"
  head -20 "$WORK/failures" | sed 's/^/  /'
fi

echo "desks=$desks"
echo "declined=$declined"
echo "sampled=$sampled"
echo "sample_declared=$sample_declared"
echo "sample_undeclared=$sample_undeclared"
echo "sample_undeclared_ceiling=$SAMPLE_UNDECLARED_CEILING"
echo "bare=$bare"
echo "selected=$selected"
echo "ran=$ran"
echo "failed=$failed"
# The six parts of that one number. `failed` stays the gated total, so this scan refuses exactly
# what it refused before; what the parts buy is that a fourth fixture landing tomorrow raises the
# reading that names its own fault rather than joining a bucket of three.
echo "failed_declined=$failed_declined"
echo "failed_lower=$failed_lower"
echo "failed_build=$failed_build"
echo "failed_run=$failed_run"
echo "failed_unreadable=$failed_unreadable"
echo "failed_unclassified=$failed_unclassified"
echo "failed_ceiling=$FAILED_CEILING"
echo "verdict=$verdict"

[ "$verdict" = ok ] || exit 1
exit 0
