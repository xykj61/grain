#!/bin/sh
# tools/fixtures/p/page_residency_sample.sh -- read whether a path STAYS in the page cache.
#
#   sh tools/fixtures/p/page_residency_sample.sh <path> [--samples N] [--interval S]
#
# WHY IT EXISTS. `active-designing/date/20260917/20260917-031330_the-price-of-an-open.md` measured a cold library
# read at 304 us per open and 718 MB/s, found that 87 percent of it is the opens rather than the
# bytes, and recommended packing 527 files into fewer. That advice rests on a premise the page left
# unread: that the fleet walks the cold path more than once. Where the library sits resident
# whenever a build wants it, the 304 us is paid once per boot and the packing project buys back a
# cost already paid. This reads the premise.
#
# WHY IT SAMPLES. `tools/bin/page-evict census` answers residency at the instant it is asked, and a
# page cache under eight ships with no swap is a moving quantity. A single census taken at a quiet
# moment reports the best case and reads as the case. The packing argument turns on the MINIMUM
# across ordinary load -- the worst moment a build could arrive at -- so this reads the same path
# repeatedly and reports the whole distribution.
#
# WHAT IT REPORTS. Per sample: resident pages, total pages, and the percent. At the close: the
# minimum, maximum, and final percent, beside the free and cached kilobytes from `/proc/meminfo` at
# each sample, since residency carries its meaning only together with the pressure that explains it.
#
# WHAT IT REFUSES, each with a named verdict: an absent census binary, a path the census declines,
# a sample count or interval outside its bound, and a census answering zero total pages -- which
# would make every percent a division by zero and read as a healthy 100.
#
# IT READS ONLY. `census` consults residency through `mmap` plus `mincore(2)`, which reads the page
# tables rather than faulting a page in, so a sample leaves the cache exactly as it found it.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"

# Bound on samples in one run. Ninety-six samples at the default fifteen seconds is twenty-four
# minutes, longer than any guard this tree runs, and a bound is what TAME asks of every loop.
MAX_SAMPLES=96
# Bound on one interval, in seconds. Past an hour the run outlives the lap that started it.
MAX_INTERVAL=3600

# The census binary, overridable so a control can prove the no_census refusal without moving the
# real one out from under a peer's lap.
CENSUS=${PAGE_EVICT_BIN:-tools/bin/page-evict}
TARGET=
SAMPLES=8
INTERVAL=15

while [ $# -gt 0 ]; do
  case $1 in
    --samples) SAMPLES=${2:-}; shift 2 ;;
    --interval) INTERVAL=${2:-}; shift 2 ;;
    --*) echo "detail: unknown flag $1"; echo "verdict=bad_flag"; exit 2 ;;
    *) TARGET=$1; shift ;;
  esac
done

[ -n "$TARGET" ] || { echo "detail: name one path to sample"; echo "verdict=no_path"; exit 2; }
[ -e "$TARGET" ] || { echo "detail: $TARGET is not in this tree"; echo "verdict=no_path"; exit 2; }
[ -x "$CENSUS" ] || {
  echo "detail: $CENSUS is absent or unbuilt -- build it with"
  echo "detail:   RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build tools/rye/page_evict.rye -femit-bin=$CENSUS"
  echo "verdict=no_census"
  exit 2
}

case $SAMPLES in ''|*[!0-9]*) echo "detail: --samples wants a whole number"; echo "verdict=bad_bound"; exit 2 ;; esac
case $INTERVAL in ''|*[!0-9]*) echo "detail: --interval wants a whole number of seconds"; echo "verdict=bad_bound"; exit 2 ;; esac
[ "$SAMPLES" -ge 1 ] && [ "$SAMPLES" -le "$MAX_SAMPLES" ] || {
  echo "detail: --samples $SAMPLES is outside 1..$MAX_SAMPLES"; echo "verdict=bad_bound"; exit 2; }
[ "$INTERVAL" -ge 0 ] && [ "$INTERVAL" -le "$MAX_INTERVAL" ] || {
  echo "detail: --interval $INTERVAL is outside 0..$MAX_INTERVAL"; echo "verdict=bad_bound"; exit 2; }

echo "target=$TARGET samples=$SAMPLES interval=$INTERVAL"

min_pct=-1
max_pct=-1
last_pct=-1
taken=0
n=1
while [ "$n" -le "$SAMPLES" ]; do
  # The census reports through Rye's `print`, which is `std.debug.print` and writes to STDERR, so
  # the two streams are merged here. Read with `2>/dev/null` it prints a blank and every parse
  # below fails on an empty field -- the same class the 20260917 mantra lap met one tool over.
  line=$("$CENSUS" census "$TARGET" 2>&1) || {
    echo "detail: census refused $TARGET on sample $n"; echo "verdict=census_refused"; exit 2; }
  pages=$(printf '%s\n' "$line" | tr ' ' '\n' | sed -n 's/^pages=//p')
  res=$(printf '%s\n' "$line" | tr ' ' '\n' | sed -n 's/^resident_pages=//p')
  case ${pages:-} in ''|*[!0-9]*) echo "detail: census named no page total"; echo "verdict=census_shape"; exit 2 ;; esac
  case ${res:-} in ''|*[!0-9]*) echo "detail: census named no resident total"; echo "verdict=census_shape"; exit 2 ;; esac
  # A zero denominator would make every percent a division by zero, and a script printing 100 for
  # an empty path is the one wrong answer this reading must never give.
  [ "$pages" -gt 0 ] || { echo "detail: $TARGET holds zero pages to sample"; echo "verdict=empty_path"; exit 2; }

  pct=$(( res * 100 / pages ))
  free_kb=$(sed -n 's/^MemFree: *\([0-9]*\) kB/\1/p' /proc/meminfo 2>/dev/null || echo 0)
  cached_kb=$(sed -n 's/^Cached: *\([0-9]*\) kB/\1/p' /proc/meminfo 2>/dev/null || echo 0)
  echo "sample n=$n resident_pages=$res pages=$pages pct=$pct free_kb=${free_kb:-0} cached_kb=${cached_kb:-0}"

  [ "$min_pct" -lt 0 ] && min_pct=$pct
  [ "$max_pct" -lt 0 ] && max_pct=$pct
  [ "$pct" -lt "$min_pct" ] && min_pct=$pct
  [ "$pct" -gt "$max_pct" ] && max_pct=$pct
  last_pct=$pct
  taken=$(( taken + 1 ))

  n=$(( n + 1 ))
  [ "$n" -le "$SAMPLES" ] && [ "$INTERVAL" -gt 0 ] && sleep "$INTERVAL"
done

echo "samples_taken=$taken min_pct=$min_pct max_pct=$max_pct last_pct=$last_pct"
# The threshold is the falsifier named in the claim rather than a rule of the kernel's: below it,
# the cold path is one the fleet walks and the packing argument survives.
if [ "$min_pct" -ge 90 ]; then
  echo "verdict=stays_resident"
else
  echo "verdict=falls_cold"
fi
