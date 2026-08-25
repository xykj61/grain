#!/bin/sh
# tools/m/myc_perf_pin.sh -- S0 wall-time baselines for myc GREEN mains (door 11).
# Measure only - no tuning - no budget red on elapsed_ms.
#
# Invoked by tools/m/myc_perf_pin.rish.
# Writes work-in-progress/myc-s0-baselines.tsv (rewrite whole table each run).
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$root"

export RYE_ZIG="${RYE_ZIG:-$root/vendor/zig-toolchain/zig}"
export ZIG_LOCAL_CACHE_DIR="${ZIG_LOCAL_CACHE_DIR:-$root/tools/.cache/zig/local}"
export ZIG_GLOBAL_CACHE_DIR="${ZIG_GLOBAL_CACHE_DIR:-$root/tools/.cache/zig/global}"
mkdir -p "$ZIG_LOCAL_CACHE_DIR" "$ZIG_GLOBAL_CACHE_DIR"

report=$root/work-in-progress/myc-s0-baselines.tsv
min_rows=${MYC_PERF_BASELINE_MIN_ROWS:-5}

# Roster -- Build myc surface after door 10 (charter 20260730.101101).
set -- \
  fold:mycelium/fold.rye \
  fold_persist:mycelium/fold_persist.rye \
  ship_sol:mycelium/ship_sol.rye \
  build_bounds:mycelium/build_bounds.rye \
  refusal_storm:mycelium/refusal_storm.rye

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
printf 'name\tstart_stamp\tend_stamp\telapsed_ms\texit\n' >"$tmp"

rows=0
fails=0
for entry in "$@"; do
  name=${entry%%:*}
  path=${entry#*:}
  start_ns=$(date +%s%N)
  start_stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)
  set +e
  env RYE_ZIG="$RYE_ZIG" "$root/rye/bin/rye" run "$path" >/tmp/myc_perf_pin_out.$$ 2>&1
  code=$?
  set -e
  end_ns=$(date +%s%N)
  end_stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)
  elapsed_ms=$(( (end_ns - start_ns) / 1000000 ))
  printf '%s\t%s\t%s\t%s\t%s\n' \
    "$name" "$start_stamp" "$end_stamp" "$elapsed_ms" "$code" >>"$tmp"
  rows=$((rows + 1))
  if [ "$code" -ne 0 ]; then
    fails=$((fails + 1))
    echo "myc_perf_pin: RED $name exit=$code elapsed_ms=$elapsed_ms" >&2
    sed -n '1,40p' /tmp/myc_perf_pin_out.$$ >&2 || true
  else
    echo "myc_perf_pin: timed $name elapsed_ms=$elapsed_ms exit=0"
  fi
  rm -f /tmp/myc_perf_pin_out.$$
done

cp "$tmp" "$report"

if [ "$fails" -ne 0 ]; then
  echo "myc_perf_pin: correctness failed · fails=$fails · report=$report" >&2
  exit 1
fi
if [ "$rows" -lt "$min_rows" ]; then
  echo "myc_perf_pin: thin · rows=$rows · bound=$min_rows" >&2
  exit 1
fi

echo "GREEN: myc_perf_pin — S0 baselines · rows=$rows · bound=$min_rows · report=$report · no tuning"
