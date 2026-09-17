#!/bin/sh
# tools/fixtures/c/cpu_unit_scan.sh -- WHICH UNIT can this pier measure a saving in?
#
#   sh tools/fixtures/c/cpu_unit_scan.sh
#
# Every timing claim this fleet ships is stated in WALL milliseconds, read on a pier eight ships
# share. Row 12's erratum on active-designing/20260910-060204_the-bounded-torus-moonshots.md
# measured what that costs: a deterministic workload measuring a change of exactly ZERO read a
# baseline spread of 16.7 to 54.8 percent of its median at load average 8 to 13, so any
# improvement under roughly a fifth is invisible to a single trial here. The remedy named there
# was MORE TRIALS, which is a different method rather than a different unit.
#
# THIS READING TESTS THE OTHER AXIS -- THE UNIT ITSELF. Wall time on a loaded pier is work plus
# waiting for a runqueue seven other ships keep full. CPU time is work alone. So the same
# workload is read BOTH WAYS INSIDE ONE CALL, and the two spreads are compared on identical work
# rather than across two sittings.
#
# THE FALSIFIER IS NAMED BEFORE THE NUMBER. If the CPU spread sits within a factor of two of the
# wall spread at the same load, the unit buys nothing, and the honest finding is that this pier
# cannot measure small effects at all -- a harder sentence, and one that belongs on the card
# either way. The scan prints `narrows=no` and `verdict=unit_buys_nothing` when that fires.
#
# THE TIMED REGION SPAWNS NOTHING BUT THE WORKLOAD, and that is the whole reason both clocks are
# read the way they are. `date +%s%N` is a CHILD PROCESS, so its own CPU lands in the very
# counter being read -- a systematic offset that shrinks relative spread and so biases the
# finding toward the answer this lap wants. Instead wall comes from `read < /proc/uptime`, a
# shell builtin reading a file, and CPU comes from the `times` builtin redirected to a file.
# Neither forks. `$(times)` CANNOT be used: command substitution forks a subshell whose own
# children-times record starts at zero, so it reports 0m0.000s however much work ran -- measured
# on metal 20260917 before this file was written.
#
# RESOLUTION IS MEASURED RATHER THAN ASSUMED. /proc/uptime carries centiseconds on this host and
# `times` prints milliseconds, and another host may print fewer digits. The scan reports the
# smallest NONZERO step it actually observed between adjacent sorted samples in each unit, and
# refuses a workload short enough for quantization to dominate.
#
# WHAT THIS DOES NOT READ. Joules: `tools/fixtures/e/energy_instrument_scan.sh` answers
# `joule_source=none` on this pier, re-read 20260917, so nothing here is an energy. Whether CPU
# time is the RIGHT unit for a claim about a person waiting -- it is not; a reader waits in wall
# seconds, and this reading is about what an ENGINEER can measure a change in. Any workload but
# the fixed spin loop below; a read-heavy or fork-heavy workload has its own answer and wants its
# own run. And the pier's load at any other moment: every figure here is FREE and moves with
# whatever the other seven ships are doing.
#
# USAGE
#   sh tools/fixtures/c/cpu_unit_scan.sh                          # the reading
#   sh tools/fixtures/c/cpu_unit_scan.sh --runs 20 --iters 6000000
#   sh tools/fixtures/c/cpu_unit_scan.sh --samples-wall "900 950 1010" --samples-cpu "540 545 551"
#
# The samples seam takes millisecond lists already measured and runs the arithmetic over them
# alone, which is how the control proves every branch without asking a pen for a busy pier.
#
# Style: Gauge at the Meter setting. Room: checkable -- the arithmetic is gated by
# tools/c/cpu_unit_witness.rish over tools/fixtures/c/cpu_unit_control.sh; the host figures are
# reported and gated by nothing, because a guard that reds on a busy pier is a guard somebody
# turns off.

set -u

RUNS=12
ITERS=4000000
MAX_RUNS=64
MIN_RUNS=3
MAX_ITERS=100000000
MIN_MEDIAN_MS=200          # below this, quantization rather than the pier is what is being read
NARROW_FACTOR=2            # the falsifier's own factor: cpu_spread * 2 < wall_spread to narrow
INJ_WALL=""
INJ_CPU=""

refuse() {
  echo "verdict=refused"
  echo "reason=$1"
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --runs)          RUNS=${2:-}; shift 2 ;;
    --iters)         ITERS=${2:-}; shift 2 ;;
    --samples-wall)  INJ_WALL=${2:-}; shift 2 ;;
    --samples-cpu)   INJ_CPU=${2:-}; shift 2 ;;
    -h|--help)       sed -n '2,50p' "$0"; exit 0 ;;
    *)               echo "instrument=cpu_unit"; refuse "UNKNOWN_FLAG" ;;
  esac
done

echo "instrument=cpu_unit"

case "$RUNS" in *[!0-9]*|"") refuse "RUNS_NOT_A_NUMBER" ;; esac
case "$ITERS" in *[!0-9]*|"") refuse "ITERS_NOT_A_NUMBER" ;; esac
[ "$RUNS" -ge "$MIN_RUNS" ] || refuse "RUNS_UNDER_MIN"
[ "$RUNS" -le "$MAX_RUNS" ] || refuse "RUNS_OVER_MAX"
[ "$ITERS" -ge 1 ] || refuse "ITERS_UNDER_MIN"
[ "$ITERS" -le "$MAX_ITERS" ] || refuse "ITERS_OVER_MAX"

# -- parsers, each of which forks nothing --------------------------------------------------------

MS=0

# "0m0.416s" -> milliseconds. A host printing two decimals is padded rather than mistrusted.
clock_ms() {
  _v=$1
  case "$_v" in *m*s) ;; *) MS=-1; return 0 ;; esac
  _m=${_v%%m*}
  _r=${_v#*m}; _r=${_r%s}
  case "$_r" in *.*) _sec=${_r%%.*}; _fr=${_r#*.} ;; *) _sec=$_r; _fr=0 ;; esac
  case "$_m$_sec$_fr" in *[!0-9]*) MS=-1; return 0 ;; esac
  while [ ${#_fr} -lt 3 ]; do _fr="${_fr}0"; done
  _fr=${_fr%"${_fr#???}"}
  MS=$(( (_m * 60 + _sec) * 1000 + 10#$_fr ))
}

# "994729.98" -> milliseconds since boot.
uptime_ms() {
  _v=$1
  case "$_v" in *.*) _s=${_v%%.*}; _f=${_v#*.} ;; *) _s=$_v; _f=0 ;; esac
  case "$_s$_f" in *[!0-9]*|"") MS=-1; return 0 ;; esac
  while [ ${#_f} -lt 3 ]; do _f="${_f}0"; done
  _f=${_f%"${_f#???}"}
  MS=$(( _s * 1000 + 10#$_f ))
}

# -- the workload ---------------------------------------------------------------------------------
#
# MINSTD, whose largest intermediate is 48271 * 2147483646 -- about 1.04e14, well inside the
# 9007199254740992 a double holds exactly, so tools/a/awk_lcg_exact_witness.rish reads one rule
# with no exemption beside it. The value is discarded; the loop exists to cost work.

work() {
  awk -v n="$ITERS" 'BEGIN{x=1;for(i=0;i<n;i++)x=(x*48271+12345)%2147483647;exit(x==0)}' \
    >/dev/null 2>&1 || true
}

# -- statistics, over a space separated list of integers -------------------------------------------
#
# The median of an even sample is taken as the UPPER of the two middles, stated here rather than
# left to a reader to infer from the arithmetic.

SMIN=0; SMED=0; SMAX=0; SSPREAD=0; SSTEP=0; SN=0

stats() {
  _sorted=$(printf '%s\n' $1 | sort -n)
  SN=$(printf '%s\n' "$_sorted" | grep -c .)
  [ "$SN" -ge 1 ] || return 1
  SMIN=$(printf '%s\n' "$_sorted" | head -1)
  SMAX=$(printf '%s\n' "$_sorted" | tail -1)
  _mid=$(( SN / 2 + 1 ))
  SMED=$(printf '%s\n' "$_sorted" | sed -n "${_mid}p")
  # A ZERO MEDIAN IS THE EXTREME OF A SHORT WORKLOAD RATHER THAN A SECOND FAULT, and saying so
  # here is what makes the refusal deterministic. The first draft returned a failure for it, so
  # a workload the clock rounds to nothing refused as ZERO_MEDIAN on a loaded moment and as
  # SHORT_WORKLOAD on a quiet one -- one condition wearing two names, which the control caught by
  # being run five times rather than once. The spread of a zero median is zero, and the floor
  # below refuses it by the one name it deserves.
  if [ "$SMED" -le 0 ]; then SSPREAD=0; else SSPREAD=$(( (SMAX - SMIN) * 1000 / SMED )); fi
  # the smallest nonzero step actually observed -- the resolution this run really had
  SSTEP=0
  _prev=""
  for _v in $_sorted; do
    if [ -n "$_prev" ]; then
      _d=$(( _v - _prev ))
      if [ "$_d" -gt 0 ]; then
        if [ "$SSTEP" -eq 0 ] || [ "$_d" -lt "$SSTEP" ]; then SSTEP=$_d; fi
      fi
    fi
    _prev=$_v
  done
  return 0
}

# -- the samples ----------------------------------------------------------------------------------

WALL_MS=""
CPU_MS=""
LOAD0="injected"
LOAD1="injected"
CORES="injected"

if [ -n "$INJ_WALL" ] || [ -n "$INJ_CPU" ]; then
  [ -n "$INJ_WALL" ] || refuse "SAMPLES_WALL_MISSING"
  [ -n "$INJ_CPU" ]  || refuse "SAMPLES_CPU_MISSING"
  case "$INJ_WALL" in *[!0-9\ ]*) refuse "SAMPLES_WALL_NOT_NUMBERS" ;; esac
  case "$INJ_CPU"  in *[!0-9\ ]*) refuse "SAMPLES_CPU_NOT_NUMBERS" ;; esac
  WALL_MS=$INJ_WALL
  CPU_MS=$INJ_CPU
  _nw=$(printf '%s\n' $WALL_MS | grep -c .)
  _nc=$(printf '%s\n' $CPU_MS  | grep -c .)
  [ "$_nw" -eq "$_nc" ] || refuse "SAMPLE_COUNTS_DIFFER"
  [ "$_nw" -ge "$MIN_RUNS" ] || refuse "RUNS_UNDER_MIN"
  [ "$_nw" -le "$MAX_RUNS" ] || refuse "RUNS_OVER_MAX"
  RUNS=$_nw
  ITERS=0
  SOURCE=injected
else
  [ -r /proc/uptime ] || refuse "NO_PROC_UPTIME"
  SOURCE=measured
  PEN=$(mktemp -d) || refuse "NO_PEN"
  trap 'rm -rf "$PEN"' EXIT
  read -r LOAD0 _rest < /proc/loadavg 2>/dev/null || LOAD0=unread
  CORES=$(nproc 2>/dev/null || echo unread)

  _i=0
  while [ "$_i" -lt "$RUNS" ]; do
    # ---- timed region: one child, the workload, and nothing else -----------------------------
    times > "$PEN/t0"
    read -r _u0 _r0 < /proc/uptime
    work
    read -r _u1 _r1 < /proc/uptime
    times > "$PEN/t1"
    # ---- end timed region --------------------------------------------------------------------
    { read -r _su0 _ss0; read -r _cu0 _cs0; } < "$PEN/t0"
    { read -r _su1 _ss1; read -r _cu1 _cs1; } < "$PEN/t1"

    uptime_ms "$_u0"; _w0=$MS
    uptime_ms "$_u1"; _w1=$MS
    [ "$_w0" -ge 0 ] && [ "$_w1" -ge 0 ] || refuse "UPTIME_UNPARSED"

    _cpu=0
    for _pair in "$_cu1" "$_cs1"; do clock_ms "$_pair"; [ "$MS" -ge 0 ] || refuse "TIMES_UNPARSED"; _cpu=$(( _cpu + MS )); done
    for _pair in "$_cu0" "$_cs0"; do clock_ms "$_pair"; [ "$MS" -ge 0 ] || refuse "TIMES_UNPARSED"; _cpu=$(( _cpu - MS )); done

    _wall=$(( _w1 - _w0 ))
    [ "$_wall" -ge 0 ] || refuse "WALL_WENT_BACKWARD"
    [ "$_cpu" -ge 0 ] || refuse "CPU_WENT_BACKWARD"

    WALL_MS="$WALL_MS $_wall"
    CPU_MS="$CPU_MS $_cpu"
    _i=$(( _i + 1 ))
  done
  read -r LOAD1 _rest < /proc/loadavg 2>/dev/null || LOAD1=unread
fi

echo "source=$SOURCE"
echo "runs=$RUNS"
echo "iters=$ITERS"
echo "cores=$CORES"
echo "loadavg_start=$LOAD0"
echo "loadavg_end=$LOAD1"

# -- the two readings ------------------------------------------------------------------------------

stats "$WALL_MS" || refuse "NO_WALL_SAMPLES"
W_MIN=$SMIN; W_MED=$SMED; W_MAX=$SMAX; W_SPREAD=$SSPREAD; W_STEP=$SSTEP
echo "wall_ms_min=$W_MIN"
echo "wall_ms_median=$W_MED"
echo "wall_ms_max=$W_MAX"
echo "wall_spread_ppt=$W_SPREAD"
echo "wall_step_ms=$W_STEP"

stats "$CPU_MS" || refuse "NO_CPU_SAMPLES"
C_MIN=$SMIN; C_MED=$SMED; C_MAX=$SMAX; C_SPREAD=$SSPREAD; C_STEP=$SSTEP
echo "cpu_ms_min=$C_MIN"
echo "cpu_ms_median=$C_MED"
echo "cpu_ms_max=$C_MAX"
echo "cpu_spread_ppt=$C_SPREAD"
echo "cpu_step_ms=$C_STEP"

# A WORKLOAD SHORT ENOUGH FOR THE CLOCK TO QUANTIZE IS A READING ABOUT THE CLOCK. Refused rather
# than reported, because the two spreads would then be comparing rounding against rounding.
if [ "$W_MED" -lt "$MIN_MEDIAN_MS" ] || [ "$C_MED" -lt "$MIN_MEDIAN_MS" ]; then
  echo "min_median_ms=$MIN_MEDIAN_MS"
  refuse "SHORT_WORKLOAD"
fi

# The share of wall that is NOT this program's own work. On an idle host it is near zero; it is
# the quantity the whole reading is about.
CONTENTION=$(( (W_MED - C_MED) * 1000 / W_MED ))
echo "contention_ppt=$CONTENTION"

echo "narrow_factor=$NARROW_FACTOR"
if [ "$W_SPREAD" -eq 0 ]; then
  RATIO=0
else
  RATIO=$(( C_SPREAD * 1000 / W_SPREAD ))
fi
echo "spread_ratio_ppt=$RATIO"

if [ $(( C_SPREAD * NARROW_FACTOR )) -lt "$W_SPREAD" ]; then
  echo "narrows=yes"
  echo "verdict=cpu_narrower"
else
  echo "narrows=no"
  echo "verdict=unit_buys_nothing"
fi
