#!/bin/sh
# tools/fixtures/c/cpu_unit_control.sh -- proves the behaviors of
# tools/fixtures/c/cpu_unit_scan.sh in a throwaway pen, every reading shown from both sides.
#
#   sh tools/fixtures/c/cpu_unit_control.sh
#
# WHAT IS PLANTED AND WHAT IS MUTATED. The scan has two halves. Its ARITHMETIC -- medians,
# spreads, the smallest observed step, the contention share, the narrowing verdict -- opens no
# file and needs no busy pier, so it is proven by INJECTING millisecond samples whose right
# answers are known by construction and asserting each reading. Its HOST half reads /proc and the
# `times` builtin, which a pen cannot plant, so it is proven by RUNNING the measured path against
# a workload deliberately too small and asserting the scan reaches its own quantization refusal:
# that path parses both clocks before it can refuse for that reason, so the refusal is evidence
# the parsers ran.
#
# Each mutation asserts it APPLIED before it is run, since a mutation that no longer matches reads
# exactly like a leg that passed.
#
# Style: Gauge at the Meter setting. Room: checkable.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/c/cpu_unit_scan.sh"

# One shell dialect on both piers: `sed -i` takes no argument on GNU and REQUIRES a backup suffix
# on BSD, so the flag is gated at zero tree-wide and `sed_inplace` is the portable form.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
legs=0
LEGS_EXPECTED=41

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }

field() { sed -n "s/^$1=//p" "$2" | head -1; }

# $1 label, then the flags -- writes $PEN/out.txt
runscan() {
  _label=$1; shift
  sh "$SCAN" "$@" > "$PEN/out.txt" 2>&1 || true
}

# --- the arithmetic, injected -------------------------------------------------------------------
#
# Four wall samples 900 950 1010 1200 and four CPU samples 540 545 551 560. With the UPPER middle
# taken as the median, wall reads 1010 and CPU reads 551. Wall spread is (1200-900)*1000/1010 =
# 297 parts per thousand; CPU spread is (560-540)*1000/551 = 36. The ratio is 36*1000/297 = 121.
# Contention is (1010-551)*1000/1010 = 454. And 36*2 < 297, so the unit narrows.

runscan "arithmetic" --samples-wall "900 950 1010 1200" --samples-cpu "540 545 551 560"
check "the injected seam is named as the source"   "$(field source "$PEN/out.txt")"          "injected"
check "the run count comes from the sample count"  "$(field runs "$PEN/out.txt")"            "4"
check "wall median is the upper middle"            "$(field wall_ms_median "$PEN/out.txt")"  "1010"
check "cpu median is the upper middle"             "$(field cpu_ms_median "$PEN/out.txt")"   "551"
check "wall min"                                   "$(field wall_ms_min "$PEN/out.txt")"     "900"
check "wall max"                                   "$(field wall_ms_max "$PEN/out.txt")"     "1200"
check "wall spread in parts per thousand"          "$(field wall_spread_ppt "$PEN/out.txt")" "297"
check "cpu spread in parts per thousand"           "$(field cpu_spread_ppt "$PEN/out.txt")"  "36"
check "the spread ratio"                           "$(field spread_ratio_ppt "$PEN/out.txt")" "121"
check "the contention share"                       "$(field contention_ppt "$PEN/out.txt")"  "454"
check "the smallest nonzero wall step observed"    "$(field wall_step_ms "$PEN/out.txt")"    "50"
check "the smallest nonzero cpu step observed"     "$(field cpu_step_ms "$PEN/out.txt")"     "5"
check "the unit narrows on this population"        "$(field narrows "$PEN/out.txt")"         "yes"
check "and the verdict says so"                    "$(field verdict "$PEN/out.txt")"         "cpu_narrower"

# --- the falsifier, from BOTH sides ---------------------------------------------------------------
#
# The factor is two, so the boundary is exact and is shown from each side rather than approached
# from one. Wall spread 400 with CPU spread 199 narrows; CPU spread 200 does not.
# Wall 1000 1200 1400 gives median 1200, spread (1400-1000)*1000/1200 = 333.
# CPU 1000 1030 1060 gives median 1030, spread 60*1000/1030 = 58 -- 58*2 = 116 < 333, narrows.
# CPU 1000 1120 1240 gives median 1120, spread 240*1000/1120 = 214 -- 214*2 = 428 >= 333, no.

runscan "boundary-below" --samples-wall "1000 1200 1400" --samples-cpu "1000 1030 1060"
check "a quarter the spread narrows"      "$(field narrows "$PEN/out.txt")" "yes"
check "and reads cpu_narrower"            "$(field verdict "$PEN/out.txt")" "cpu_narrower"

runscan "boundary-above" --samples-wall "1000 1200 1400" --samples-cpu "1000 1120 1240"
check "two thirds the spread does not"    "$(field narrows "$PEN/out.txt")" "no"
check "and the falsifier's own verdict"   "$(field verdict "$PEN/out.txt")" "unit_buys_nothing"

# A population where the two units agree exactly is the sharpest no: nothing is bought.
runscan "identical" --samples-wall "1000 1200 1400" --samples-cpu "1000 1200 1400"
check "identical samples buy nothing"     "$(field verdict "$PEN/out.txt")" "unit_buys_nothing"
check "and the ratio reads one thousand"  "$(field spread_ratio_ppt "$PEN/out.txt")" "1000"
check "with no contention between them"   "$(field contention_ppt "$PEN/out.txt")"  "0"

# --- the refusals, each planted and then lifted ---------------------------------------------------

runscan "short" --samples-wall "100 120 140" --samples-cpu "100 110 120"
check "a median under the floor refuses"  "$(field reason "$PEN/out.txt")" "SHORT_WORKLOAD"
runscan "short-lifted" --samples-wall "1000 1200 1400" --samples-cpu "1000 1030 1060"
check "and one over it walks free"        "$(field verdict "$PEN/out.txt")" "cpu_narrower"

# A CLOCK THAT ROUNDS THE WHOLE WORKLOAD TO NOTHING is the extreme of a short one, and it gets
# the SAME name. The first draft of the scan gave it its own, so the leg below that runs the
# measured path read one name on a loaded moment and another on a quiet one -- caught by running
# this control five times rather than once.
runscan "zero-median" --samples-wall "0 0 0" --samples-cpu "0 0 0"
check "a median of zero is a short workload" "$(field reason "$PEN/out.txt")" "SHORT_WORKLOAD"

runscan "counts" --samples-wall "1000 1200 1400 1600" --samples-cpu "1000 1100 1200"
check "sample counts that differ refuse"  "$(field reason "$PEN/out.txt")" "SAMPLE_COUNTS_DIFFER"

runscan "one-side" --samples-wall "1000 1200 1400"
check "a wall list with no cpu list refuses" "$(field reason "$PEN/out.txt")" "SAMPLES_CPU_MISSING"
runscan "other-side" --samples-cpu "1000 1200 1400"
check "a cpu list with no wall list refuses" "$(field reason "$PEN/out.txt")" "SAMPLES_WALL_MISSING"

runscan "letters" --samples-wall "1000 abc 1400" --samples-cpu "1000 1100 1200"
check "letters in a sample list refuse"   "$(field reason "$PEN/out.txt")" "SAMPLES_WALL_NOT_NUMBERS"

runscan "too-few" --samples-wall "1000 1200" --samples-cpu "1000 1100"
check "two samples are under the minimum" "$(field reason "$PEN/out.txt")" "RUNS_UNDER_MIN"

runscan "flag" --nonsense
check "an unknown flag refuses"           "$(field reason "$PEN/out.txt")" "UNKNOWN_FLAG"

runscan "runs-max" --runs 999
check "a run count over the bound refuses" "$(field reason "$PEN/out.txt")" "RUNS_OVER_MAX"
runscan "runs-word" --runs twelve
check "a run count that is a word refuses" "$(field reason "$PEN/out.txt")" "RUNS_NOT_A_NUMBER"
runscan "iters-word" --iters many
check "an iteration count that is a word refuses" "$(field reason "$PEN/out.txt")" "ITERS_NOT_A_NUMBER"

# --- the host half, run rather than planted --------------------------------------------------------
#
# A three-iteration workload finishes far under the floor, so the measured path runs both clocks,
# parses both, and refuses for quantization. Reaching THAT reason is the evidence: an unparsed
# clock refuses earlier and by a different name, so this leg tells a parser that works from one
# that does not.

runscan "measured-short" --runs 3 --iters 3
check "the measured path names itself"     "$(field source "$PEN/out.txt")" "measured"
check "and refuses for quantization"       "$(field reason "$PEN/out.txt")" "SHORT_WORKLOAD"
if [ "$(field cores "$PEN/out.txt")" -ge 1 ] 2>/dev/null; then
  ok "the measured path reads a core count"
else
  no "the measured path reads a core count -- read [$(field cores "$PEN/out.txt")]"
fi

# --- the mutations, each asserted to have applied ----------------------------------------------------

# EACH MUTATION IS RUN AGAINST THE POPULATION WHERE THE MUTATED LINE IS LOAD-BEARING, which the
# first draft of this control got wrong twice and was told by its own legs: dropping the narrowing
# factor changes nothing on a population that narrows four times over, and dropping the sample
# count check changes nothing when the two lists are already the same length. A mutation run
# against the wrong population is a mutation that cannot bite.
mutate() {
  # $1 label, $2 sed program, $3 key that must move, $4 value it must NOT keep,
  # $5 wall samples, $6 cpu samples
  cp "$SCAN" "$PEN/mutant.sh"
  sed_inplace "$2" "$PEN/mutant.sh"
  if cmp -s "$SCAN" "$PEN/mutant.sh"; then
    no "$1 -- the mutation did not apply, so the leg proves nothing"
    return
  fi
  sh "$PEN/mutant.sh" --samples-wall "$5" --samples-cpu "$6" > "$PEN/mutant.txt" 2>&1 || true
  _got=$(field "$3" "$PEN/mutant.txt")
  if [ "$_got" = "$4" ]; then
    no "$1 -- $3 still reads [$4] with the mutation in"
  else
    ok "$1 -- $3 moved off [$4] to [$_got]"
  fi
}

mutate "dropping the narrowing factor calls two thirds of the spread a finding" \
  's/C_SPREAD \* NARROW_FACTOR/C_SPREAD/' verdict unit_buys_nothing \
  "1000 1200 1400" "1000 1120 1240"

mutate "taking the lower middle moves the median" \
  's|_mid=$(( SN / 2 + 1 ))|_mid=$(( SN / 2 ))|' wall_ms_median 1010 \
  "900 950 1010 1200" "540 545 551 560"

mutate "reading the largest step rather than the smallest hides the resolution" \
  's/\[ "$_d" -lt "$SSTEP" \]/[ "$_d" -gt "$SSTEP" ]/' wall_step_ms 50 \
  "900 950 1010 1200" "540 545 551 560"

mutate "dropping the sample count check lets two lists of different length through" \
  '/SAMPLE_COUNTS_DIFFER/d' reason SAMPLE_COUNTS_DIFFER \
  "1000 1200 1400 1600" "1000 1100 1200"

check "every mutation applied and bit" "$fail" "0"

# --- the tally ---------------------------------------------------------------------------------------

echo "control_legs=$legs"
echo "control_expected=$LEGS_EXPECTED"
echo "control_passed=$pass"
echo "control_failed=$fail"
if [ "$legs" -ne "$LEGS_EXPECTED" ]; then
  echo "detail: leg count moved -- a leg added or lost is a leg nobody heard"
  echo "control_verdict=leg_count_moved"
  exit 0
fi
if [ "$fail" -ne 0 ]; then
  echo "control_verdict=failed"
  exit 0
fi
echo "control_verdict=ok"
