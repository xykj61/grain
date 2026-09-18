#!/bin/sh
# process_fanout_scan.sh -- how many programs a rostered guard starts, and what that costs it.
#
#   sh tools/fixtures/p/process_fanout_scan.sh [--sample N] [--guard NAME] [--calibrate-only]
#
# WHY THIS METER EXISTS. The cold endurance run is this fleet's most expensive reading and its most
# repeated: `tools/f/fleet_baton.txt` asks every lap for one, twice, and eight ships sail. Read from
# `construction/standing-equipment-runs.kyri` at `20260917.163151`, it stood at **4,303 wall seconds
# over 355 lap-tier guards with 4,197 seconds of CPU** -- a ratio of **0.975**, so the run computes
# for essentially every second it lasts and waits on nothing at all.
#
# That ratio says the cost is arithmetic rather than waiting, and stops there. It cannot say WHAT is
# computed, and nothing else in this tree could either. The ASCII of a document is metered, the
# register of prose is metered, a commit body's mechanism words are metered, a file's exec bit is
# metered -- and the harness that runs all of those held no reading of itself.
#
# WHAT A HAND MEASURED BEFORE BUILDING THIS, and why it is not enough. One `qa_report_card.sh`
# invocation starts **43 processes in 615ms**, seventeen of them `awk`. Three mid-weight lap-tier
# scans start **5,837, 2,728 and 7,020** processes against 61, 63 and 75 wall seconds -- seventy-eight
# new programs a second. At this host's startup costs that is roughly **35 percent** of those three
# spent on programs loading themselves. Three guards is a sample chosen for being easy to reach, and
# one of the three read 19 percent beside two neighbours above 40 -- a threefold spread that makes
# any extrapolation from three files untrustworthy. A meter prices a gap from the files it can
# already see, which is this fleet's own lesson from `20260915.223327`; so this reads a population.
#
# WHY IT CALIBRATES RATHER THAN CARRYING A CONSTANT. Startup cost is a property of the machine --
# its loader, its libraries, its locale, its disk. A number measured on one pier and baked into a
# scan is a number that silently describes the wrong host the first time a ship sails elsewhere. So
# every run times the tools a scan actually reaches, on the host it is running on, and derives the
# blend from what it measured. The calibration prints beside the reading, so a reader can always see
# which machine's arithmetic produced the share.
#
# WHAT IT COUNTS. `execve` calls under `strace -f`, which is every program actually started,
# children included. It traces the SCAN rather than the witness, because the scan is where the shell
# work lives and a witness may rebuild a Rye module whose compile time is a different subject with a
# different cure (the fusion build's Move 1, design `20260825-173153`).
#
# WHAT IT REPORTS AND NEVER GATES. Every reading here is a first census. A ceiling over a population
# nobody has measured is a number invented rather than read, and this tree has already written down
# what such a gate becomes: one somebody turns off. When the population is known, a ceiling is a
# separate lap and a separate word.
#
# WHAT IT CANNOT SEE, named rather than left for a reader to discover:
#
#   * A guard whose cost is COMPILATION rather than spawning. 142 of 2,054 witnesses invoke a Rye
#     build; tracing the scan steps past that entirely, and it is the other half of the run's hour.
#   * The wall seconds are read from the run card, which remembers each guard's LAST run rather than
#     one pass. A row stamped days ago is reported with its stamp so a reader can tell.
#   * `strace` slows a traced program considerably, so the execve COUNT is honest and the traced
#     wall time is not. The share below divides a traced count by an UNTRACED wall, which is the
#     only pairing that means anything.
#   * Contention. This pier runs eight ships on eight cores, so a guard's wall seconds already carry
#     whatever its peers were doing. That inflates the denominator and UNDERSTATES the share.
#
# BOUNDS. Sample size, calibration runs, and per-trace seconds each name a maximum below. A guard
# that outruns its trace budget is reported as `timeout` and counted apart rather than dropped.
#
# Read by tools/p/process_fanout_witness.rish and its control.

set -u

SAMPLE_MAX=40          # a bounded census; the whole roster under strace runs into hours
SAMPLE_DEFAULT=6
CALIB_RUNS=20          # enough to average out scheduler noise, cheap enough to run every pass
TRACE_SECONDS=120      # a guard past this is reported by name rather than waited on

root=${PROCESS_FANOUT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
roster="$root/construction/standing-equipment.kyri"
card="$root/construction/standing-equipment-runs.kyri"

sample=$SAMPLE_DEFAULT
only=""
calibrate_only=no

while [ $# -gt 0 ]; do
  case "$1" in
    --sample) sample=${2:-$SAMPLE_DEFAULT}; shift 2 ;;
    --guard)  only=${2:-}; shift 2 ;;
    --calibrate-only) calibrate_only=yes; shift ;;
    *) echo "detail: unknown argument $1" >&2; echo "verdict=bad_argument"; exit 1 ;;
  esac
done

case "$sample" in ''|*[!0-9]*) echo "verdict=bad_sample"; exit 1 ;; esac
[ "$sample" -le "$SAMPLE_MAX" ] || sample=$SAMPLE_MAX
[ "$sample" -ge 1 ] || sample=1

command -v strace >/dev/null 2>&1 || { echo "detail: strace is absent -- this meter counts execve and cannot default to a guess"; echo "verdict=no_tracer"; exit 1; }

# CALIBRATION. Time each tool doing the least it can do, so what is measured is arrival rather than
# work. `true` is the floor: fork, exec, exit, nothing else. Every figure is microseconds per call.
calib() {
  _c_s=$(date +%s%N)
  _c_i=0
  while [ "$_c_i" -lt "$CALIB_RUNS" ]; do
    "$@" >/dev/null 2>&1
    _c_i=$((_c_i + 1))
  done
  _c_e=$(date +%s%N)
  echo $(( (_c_e - _c_s) / 1000 / CALIB_RUNS ))
}

us_fork=$(calib /bin/true)
us_awk=$(calib awk 'BEGIN{}')
us_grep=$(calib grep -q x /dev/null)
us_sed=$(calib sed -n '1p' /dev/null)

# THE BLEND is the mean of the three text tools and the floor, weighted as the one measured card
# breakdown ran: 17 awk, 6 sed, 5 grep, 12 others at roughly the floor. Spelled as integers so no
# shell needs floating point, and stated here so a reader can redo it by hand.
us_blend=$(( (17 * us_awk + 6 * us_sed + 5 * us_grep + 12 * us_fork) / 40 ))

echo "calib_runs=$CALIB_RUNS"
echo "calib_fork_us=$us_fork"
echo "calib_awk_us=$us_awk"
echo "calib_grep_us=$us_grep"
echo "calib_sed_us=$us_sed"
echo "calib_blend_us=$us_blend"

if [ "$calibrate_only" = yes ]; then
  echo "verdict=calibrated"
  exit 0
fi

[ -f "$roster" ] || { echo "detail: no roster at $roster"; echo "verdict=roster_missing"; exit 1; }
[ -f "$card" ]   || { echo "detail: no run card at $card -- wall seconds have no source"; echo "verdict=card_missing"; exit 1; }

# The population: rostered guards at tier lap whose scan file this tree actually holds. A guard
# with no scan is a witness doing its own work, which this meter says nothing about.
names=$(awk '/^guard /{n=$2} /^tier /{t=$2; if (n != "" && t == "lap") print n; n=""} ' "$roster" | sort -u)
[ -n "$only" ] && names=$only

candidates=""
total_pop=0
for n in $names; do
  s=$(ls "$root"/tools/fixtures/*/"${n}_scan.sh" 2>/dev/null | head -1)
  [ -n "$s" ] || continue
  grep -q "^ran $n " "$card" 2>/dev/null || continue
  total_pop=$((total_pop + 1))
  candidates="$candidates $n"
done

echo "population_with_scan_and_card=$total_pop"

# Sample evenly across the sorted population rather than taking the head, so the reading is not a
# reading of the letter `a`.
picked=""
if [ -n "$only" ]; then
  picked=$candidates
else
  step=$(( total_pop / sample ))
  [ "$step" -ge 1 ] || step=1
  i=0
  for n in $candidates; do
    if [ $((i % step)) -eq 0 ]; then
      picked="$picked $n"
    fi
    i=$((i + 1))
  done
fi

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

sampled=0
exec_total=0
wall_total=0
timeouts=0

for n in $picked; do
  [ "$sampled" -lt "$sample" ] || break
  s=$(ls "$root"/tools/fixtures/*/"${n}_scan.sh" 2>/dev/null | head -1)
  [ -n "$s" ] || continue
  wall=$(awk -v g="$n" '$1=="ran" && $2==g {print $6; exit}' "$card")
  stamp=$(awk -v g="$n" '$1=="ran" && $2==g {print $3; exit}' "$card")
  case "$wall" in ''|*[!0-9]*) continue ;; esac
  [ "$wall" -ge 1 ] || continue

  if command -v timeout >/dev/null 2>&1; then
    timeout "$TRACE_SECONDS" strace -f -c -e trace=execve -o "$pen/t" sh "$s" >/dev/null 2>&1
    rc=$?
  else
    strace -f -c -e trace=execve -o "$pen/t" sh "$s" >/dev/null 2>&1
    rc=$?
  fi
  if [ "$rc" = 124 ]; then
    echo "fanout $n verdict=timeout trace_seconds=$TRACE_SECONDS"
    timeouts=$((timeouts + 1))
    continue
  fi

  ex=$(awk '/execve/{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+$/ && i>=4) {print $i; exit}}' "$pen/t" 2>/dev/null)
  case "$ex" in ''|*[!0-9]*) ex=0 ;; esac

  # startup microseconds against wall microseconds, in per mille, integer throughout.
  start_us=$(( ex * us_blend ))
  wall_us=$(( wall * 1000000 ))
  share=0
  [ "$wall_us" -gt 0 ] && share=$(( start_us * 1000 / wall_us ))

  echo "fanout $n execve=$ex wall_s=$wall card_stamp=$stamp exec_per_s=$(( ex / wall )) startup_per_mille=$share"
  sampled=$((sampled + 1))
  exec_total=$((exec_total + ex))
  wall_total=$((wall_total + wall))
done

echo "guards_sampled=$sampled"
echo "trace_timeouts=$timeouts"
echo "execve_total=$exec_total"
echo "wall_s_total=$wall_total"

if [ "$sampled" -ge 1 ] && [ "$wall_total" -ge 1 ]; then
  echo "exec_per_s_mean=$(( exec_total / wall_total ))"
  echo "startup_per_mille_mean=$(( exec_total * us_blend * 1000 / (wall_total * 1000000) ))"
  echo "verdict=read"
else
  echo "detail: no guard in the sample carried both a scan and a card row with wall seconds"
  echo "verdict=nothing_sampled"
fi
