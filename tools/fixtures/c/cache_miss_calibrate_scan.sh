#!/bin/sh
# tools/fixtures/c/cache_miss_calibrate_scan.sh -- rebuild and run the cache-miss calibration sweep,
# three times, and print each reading beside its band.
#
# WHY THREE RUNS. One reading of a hardware counter is one sample of a noisy machine. The falsifier
# is about the band the readings fall in, so the scan prints every run and a verdict over all of them.
#
# THE FALSIFIER, named before the run. A generic cache-misses reading is usable as a line-fill proxy
# only if a 64 MB sequential sweep (1,048,576 lines) lands between 500 and 2000 permille of that
# expectation: within a factor of two of one million, the band the calibration note set. Below 500
# the generic event is NOT a fill counter on this guest and the stencil falsifier waits on a raw,
# vendor-specific event instead.
#
# THIS SCAN MEASURES. It reports `falsifier=` and never fails a gate: a counter that reads low is the
# finding, and a finding is not a red. A build failure is the only red this scan can name.
#
# Run from anywhere: sh tools/fixtures/c/cache_miss_calibrate_scan.sh

root=$(cd "$(dirname "$0")/../../.." && pwd -P)
out="$root/session-output/cache-miss-calibrate"
bin="$out/cache_miss_calibrate"
runs=3
band_low=500
band_high=2000

mkdir -p "$out" || { echo "verdict=no_output_dir"; exit 1; }

RYE_ZIG="$root/vendor/zig-toolchain/zig" sh "$root/tools/fixtures/r/rye_build.sh" \
    "$root/tools/rye/cache_miss_calibrate.rye" "-femit-bin=$bin" >"$out/build.txt" 2>&1
if [ $? -ne 0 ]; then
    echo "verdict=build_failed see=$out/build.txt"
    exit 1
fi

inside=0
i=0
while [ "$i" -lt "$runs" ]; do
    i=$((i + 1))
    line=$(timeout 120 "$bin" 2>&1)
    echo "$line"
    permille=$(printf '%s\n' "$line" | sed -n 's/.*permille=\([0-9][0-9]*\).*/\1/p')
    if [ -z "$permille" ]; then
        echo "verdict=no_reading run=$i"
        exit 1
    fi
    if [ "$permille" -ge "$band_low" ] && [ "$permille" -le "$band_high" ]; then
        inside=$((inside + 1))
    fi
done

if [ "$inside" -eq "$runs" ]; then
    echo "falsifier=not_fired runs=$runs inside=$inside band=$band_low-$band_high"
else
    echo "falsifier=fired runs=$runs inside=$inside band=$band_low-$band_high"
fi
echo "verdict=measured"
