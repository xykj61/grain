#!/bin/sh
# glow_run_worker.sh — lower · build · run one Glow desk (fixture or argv sample).
# Invoked by tools/glow_run.rish.
#
#   tools/glow_run_worker.sh <file.glow>           # fixture path
#   tools/glow_run_worker.sh <file.glow> <sample>  # generator argv path

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"
GLOW=$1
SAMPLE=${2-}

test -n "$GLOW" || {
  echo "usage: glow_run_worker.sh <file.glow> [<sample-u32-decimal>]"
  exit 2
}

STEM=$(basename "$GLOW" .glow)
BIN="glow/bin/$STEM"

case "$STEM" in
sample-u32|gate-sample-u32|gate-double-u32|gate-inc-u32|gate-dec-u32|gate-amount-u32|gate-barket-sample-u32|gate-barket-double-u32|gate-barket-inc-u32|gate-barket-dec-u32|gate-barket-amount-u32)
  test -n "$SAMPLE" || {
    echo "FAIL: ${STEM}.glow needs one @u32 sample decimal"
    exit 2
  }
  ;;
*)
  test -z "$SAMPLE" || {
    echo "FAIL: only sample-u32 / gate-*-u32 bartis/barket generators take a sample decimal"
    exit 2
  }
  ;;
esac

mkdir -p glow/bin glow/.cache
env RYE_ZIG="$ZIG" rye/bin/rye build glow/glow_run.rye -femit-bin=glow/bin/glow_run

if [ -n "$SAMPLE" ]; then
  RYE=$(glow/bin/glow_run --sample-argv "$GLOW")
  test -n "$RYE"
  env RYE_ZIG="$ZIG" rye/bin/rye build "$RYE" -femit-bin="$BIN"
  "$BIN" "$SAMPLE"
  echo "EXIT:$?"
else
  RYE=$(glow/bin/glow_run "$GLOW")
  test -n "$RYE"
  env RYE_ZIG="$ZIG" rye/bin/rye build "$RYE" -femit-bin="$BIN"
  "$BIN"
  echo "EXIT:$?"
fi
