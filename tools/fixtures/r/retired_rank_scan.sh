#!/bin/sh
# tools/fixtures/r/retired_rank_scan.sh -- DO INSTRUCTIONS RETIRED AND WALL TIME RANK TWO
# IMPLEMENTATIONS THE SAME WAY? This is the reading row 3 of
# active-designing/date/20260917/20260917-105154_the-refusal-that-can-fire.md names as its own falsifier.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# THE QUESTION, BOUNDED BEFORE THE NUMBER. Energy-saving work wants a unit. This pier exposes no
# joule -- tools/fixtures/e/energy_instrument_scan.sh reads joule_source=none, powercap_domains=0,
# msr_device=no -- and it does expose hardware counters, hw_instructions=yes at
# perf_event_paranoid=2. So the row proposes RETIRED INSTRUCTIONS as the unit a lane can carry
# here, and its falsifier is a disagreement: if the counter ranks two implementations of one
# workload in the opposite order from the clock, the counter is measuring a different quantity from
# the one a lane cares about.
#
# WHAT IT RUNS. Two labeled commands, R repetitions each, interleaved A B A B rather than run in
# blocks, so a load that arrives partway through the trial reaches both arms rather than one. Each
# repetition is measured by tools/bin/retired-exec, which arms a counter on a forked dependent with
# enable_on_exec and inherit, so the number covers the command and everything it starts.
#
# WHAT IT REPORTS. The MEDIAN of each arm on each reading, the spread as a parts-per-million
# relative range, and one word: agree=yes when the two readings put the same arm first, agree=no
# when they disagree. A disagreement is the falsifier firing and the verdict says so by name.
#
# WHY MEDIAN RATHER THAN MEAN. A pier shared by eight ships delivers occasional enormous wall
# outliers -- a neighbour's compile landing inside one repetition. A mean carries that neighbour
# into the verdict; a median holds unless the neighbour is present for half the run.
#
# WHAT IT DECLINES TO RANK, which is the honest half. Two arms whose medians differ by less than
# MIN_SEPARATION_PPM on a reading are not ranked by that reading at all, and the scan reports
# verdict=too_close rather than manufacturing an order out of noise. An arm that exits non-zero is
# a broken trial rather than a fast one, and the scan refuses it by name.
#
# WHAT THE NUMBER IS NOT. User-space retired instructions, kernel and hypervisor excluded. A pair
# whose difference is all I/O wait reports a small instruction difference beside a large wall
# difference, which is a real property of the proxy rather than a fault in it. Both numbers are
# printed so a reader sees that case rather than being handed a verdict about it.
#
# A HOST IS NOT A FAULT (REDS %646). Where the counter is unreadable, the scan reports
# tier=cpu_seconds, verdict=counter_unavailable, and exits 1 without pretending to a ranking.
#
#   sh tools/fixtures/r/retired_rank_scan.sh --a "<label>:<command>" --b "<label>:<command>" [--reps N]
#
set -u

MAX_REPS=64                    # repetitions per arm; a trial past this is a benchmark, not a reading
MIN_REPS=3                     # a median wants an odd handful; two runs have no middle
MIN_SEPARATION_PPM=20000       # 2 percent: under this the two arms are one arm on that reading
MAX_COMMAND_BYTES=4096         # the binary's own bound, restated at the seam that feeds it

REPS=7
A_SPEC=""
B_SPEC=""

while [ $# -gt 0 ]; do
  case $1 in
    --a) shift; A_SPEC=${1:-} ;;
    --b) shift; B_SPEC=${1:-} ;;
    --reps) shift; REPS=${1:-$REPS} ;;
    *) ;;
  esac
  shift
done

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
cd "$ROOT" 2>/dev/null || :

echo "scan=retired_rank"
echo "max_reps=$MAX_REPS"
echo "min_reps=$MIN_REPS"
echo "min_separation_ppm=$MIN_SEPARATION_PPM"

BIN=tools/bin/retired-exec

if [ -z "$A_SPEC" ] || [ -z "$B_SPEC" ]; then
  echo "detail: both arms are required -- --a <label>:<command> --b <label>:<command>"
  echo "verdict=arms_missing"
  exit 1
fi

case $REPS in
  ''|*[!0-9]*) echo "detail: reps must be a count"; echo "verdict=reps_unreadable"; exit 1 ;;
esac
if [ "$REPS" -lt "$MIN_REPS" ] || [ "$REPS" -gt "$MAX_REPS" ]; then
  echo "detail: reps $REPS outside [$MIN_REPS, $MAX_REPS]"
  echo "verdict=reps_out_of_bounds"
  exit 1
fi

a_label=${A_SPEC%%:*}; a_cmd=${A_SPEC#*:}
b_label=${B_SPEC%%:*}; b_cmd=${B_SPEC#*:}

if [ -z "$a_cmd" ] || [ -z "$b_cmd" ] || [ "$a_cmd" = "$A_SPEC" ] || [ "$b_cmd" = "$B_SPEC" ]; then
  echo "detail: an arm reads <label>:<command> and one of them carried no colon"
  echo "verdict=arm_unreadable"
  exit 1
fi

if [ ${#a_cmd} -ge $MAX_COMMAND_BYTES ] || [ ${#b_cmd} -ge $MAX_COMMAND_BYTES ]; then
  echo "detail: a command exceeds the binary's own $MAX_COMMAND_BYTES byte bound"
  echo "verdict=command_too_long"
  exit 1
fi

echo "a_label=$a_label"
echo "b_label=$b_label"
echo "reps=$REPS"

if [ ! -x "$BIN" ]; then
  echo "detail: $BIN is absent -- rye build tools/rye/retired_exec.rye -femit-bin=$BIN"
  echo "verdict=binary_absent"
  exit 1
fi

pen=$(mktemp -d) || { echo "verdict=pen_refused"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

# One repetition of one arm, appending "instructions wall_ns" to that arm's file. Output of the
# workload itself is discarded: this reads the counter, never the command's own words.
run_once() {
  _arm=$1; _cmd=$2
  _line=$("$BIN" "$_cmd" 2>&1 >/dev/null | grep '^retired_exec ')
  _ins=$(echo "$_line" | sed -n 's/.*instructions=\([0-9a-z_]*\).*/\1/p')
  _wall=$(echo "$_line" | sed -n 's/.*wall_ns=\([0-9]*\).*/\1/p')
  _exit=$(echo "$_line" | sed -n 's/.*exit=\([0-9]*\).*/\1/p')
  echo "$_ins $_wall $_exit" >> "$pen/$_arm"
}

# Interleaved rather than blocked: a load arriving partway through reaches both arms.
i=0
while [ "$i" -lt "$REPS" ]; do
  run_once a "$a_cmd"
  run_once b "$b_cmd"
  i=$((i + 1))
done

nonzero=$(cat "$pen/a" "$pen/b" 2>/dev/null | awk '$3 != 0' | wc -l | tr -d ' ')
echo "nonzero_exits=$nonzero"
if [ "$nonzero" -gt 0 ]; then
  echo "detail: an arm exited non-zero -- a broken command is not a fast one"
  echo "verdict=arm_failed"
  exit 1
fi

unavailable=$(cat "$pen/a" "$pen/b" 2>/dev/null | awk '$1 == "unavailable"' | wc -l | tr -d ' ')
if [ "$unavailable" -gt 0 ]; then
  echo "tier=cpu_seconds"
  echo "detail: the kernel refused a hardware counter on this host"
  echo "verdict=counter_unavailable"
  exit 1
fi
echo "tier=counters"

# median and relative range, in parts per million of the median, over one column of one arm.
stat_of() {
  awk -v col="$2" '
    { v[NR] = $col + 0 }
    END {
      n = NR
      if (n == 0) { print "0 0"; exit }
      for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) if (v[j] < v[i]) { t = v[i]; v[i] = v[j]; v[j] = t }
      mid = (n % 2 == 1) ? v[(n + 1) / 2] : int((v[n / 2] + v[n / 2 + 1]) / 2)
      spread = (mid > 0) ? int((v[n] - v[1]) * 1000000 / mid) : 0
      print mid " " spread
    }' "$1"
}

set -- $(stat_of "$pen/a" 1); a_ins=$1; a_ins_ppm=$2
set -- $(stat_of "$pen/b" 1); b_ins=$1; b_ins_ppm=$2
set -- $(stat_of "$pen/a" 2); a_wall=$1; a_wall_ppm=$2
set -- $(stat_of "$pen/b" 2); b_wall=$1; b_wall_ppm=$2

echo "a_instructions_median=$a_ins"
echo "b_instructions_median=$b_ins"
echo "a_wall_ns_median=$a_wall"
echo "b_wall_ns_median=$b_wall"
echo "a_instructions_spread_ppm=$a_ins_ppm"
echo "b_instructions_spread_ppm=$b_ins_ppm"
echo "a_wall_spread_ppm=$a_wall_ppm"
echo "b_wall_spread_ppm=$b_wall_ppm"

# separation of the two arms on one reading, in ppm of the smaller median: how far apart they are
# relative to where they sit.
separation() {
  awk -v x="$1" -v y="$2" 'BEGIN {
    lo = (x < y) ? x : y
    if (lo <= 0) { print 0; exit }
    d = (x > y) ? x - y : y - x
    printf "%d\n", d * 1000000 / lo
  }'
}

ins_sep=$(separation "$a_ins" "$b_ins")
wall_sep=$(separation "$a_wall" "$b_wall")
echo "instructions_separation_ppm=$ins_sep"
echo "wall_separation_ppm=$wall_sep"

order_of() {
  awk -v x="$1" -v y="$2" -v la="$3" -v lb="$4" 'BEGIN { print (x < y) ? la : lb }'
}

ins_first=$(order_of "$a_ins" "$b_ins" "$a_label" "$b_label")
wall_first=$(order_of "$a_wall" "$b_wall" "$a_label" "$b_label")
echo "instructions_cheaper=$ins_first"
echo "wall_cheaper=$wall_first"

if [ "$ins_sep" -lt "$MIN_SEPARATION_PPM" ] || [ "$wall_sep" -lt "$MIN_SEPARATION_PPM" ]; then
  echo "agree=undecided"
  echo "detail: the arms sit closer than $MIN_SEPARATION_PPM ppm on a reading -- no order is claimed"
  echo "verdict=too_close"
  exit 1
fi

if [ "$ins_first" = "$wall_first" ]; then
  echo "agree=yes"
  echo "verdict=ok"
  exit 0
fi

echo "agree=no"
echo "detail: the counter ranks $ins_first cheaper and the clock ranks $wall_first cheaper"
echo "verdict=rank_disagreement"
exit 1
