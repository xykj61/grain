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
#   3. minus every desk whose stem sits in tools/g/glow_run_worker.sh's sample-permission `case`.
#      Those desks refuse to run without an argument the runner would have to choose, and choosing
#      it is a judgment per desk rather than a loop. They are the reach scan's `uncovered_sampled`
#      ratchet and they stay it.
#
# What remains is the BARE-RUNNABLE set: 301 desks measured 20260907, of which the elder witness
# names 218 and nothing named the other 83.
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
comm -23 "$WORK/runnable" "$WORK/sampled" > "$WORK/selected"
selected=$(wc -l < "$WORK/selected" | tr -d ' ')

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
run_desk() {
  _desk=$1
  _stem=${_desk##*/}
  _stem=${_stem%.glow}
  _rye=$(glow/bin/glow_run "$_desk" 2>>"$WORK/fail.log") || return 1
  [ -n "$_rye" ] || return 1
  env RYE_ZIG="$ZIG" rye/bin/rye build "$_rye" -femit-bin="glow/bin/$_stem.batch.$$" >>"$WORK/fail.log" 2>&1 || return 1
  mv -f "glow/bin/$_stem.batch.$$" "glow/bin/$_stem" || return 1
  if [ -f "glow/bin/$_stem.batch.$$.ryekey" ]; then
    mv -f "glow/bin/$_stem.batch.$$.ryekey" "glow/bin/$_stem.ryekey"
  fi
  "glow/bin/$_stem" >>"$WORK/fail.log" 2>&1 || return 1
  return 0
}

ran=0
failed=0
: > "$WORK/failures"
: > "$WORK/fail.log"
while IFS= read -r desk; do
  ran=$((ran + 1))
  if [ -n "$RUN_ONE" ]; then
    if ! $RUN_ONE "$desk" >/dev/null 2>&1; then
      failed=$((failed + 1))
      printf '%s\n' "$desk" >> "$WORK/failures"
    fi
  else
    if ! run_desk "$desk"; then
      failed=$((failed + 1))
      printf '%s\n' "$desk" >> "$WORK/failures"
    fi
  fi
done < "$WORK/selected"

verdict=ok
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
echo "selected=$selected"
echo "ran=$ran"
echo "failed=$failed"
echo "failed_ceiling=$FAILED_CEILING"
echo "verdict=$verdict"

[ "$verdict" = ok ] || exit 1
exit 0
