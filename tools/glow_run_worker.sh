#!/bin/sh
# glow_run_worker.sh — lower · build · run one Glow desk (fixture or argv sample).
# Invoked by tools/glow_run.rish.
#
#   tools/glow_run_worker.sh <file.glow>                      # fixture path
#   tools/glow_run_worker.sh <file.glow> <sample>             # u32 or kind tag
#   tools/glow_run_worker.sh <file.glow> mint <amount-u32>    # xact payload tag

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"
GLOW=$1
SAMPLE=${2-}
SAMPLE2=${3-}

test -n "$GLOW" || {
  echo "usage: glow_run_worker.sh <file.glow> [<sample>] [<amount-u32>]"
  exit 2
}

STEM=$(basename "$GLOW" .glow)
BIN="glow/bin/$STEM"

case "$STEM" in
sample-u32|gate-sample-u32|gate-double-u32|gate-inc-u32|gate-dec-u32|gate-amount-u32|gate-count-u32|gate-barket-sample-u32|gate-barket-double-u32|gate-barket-inc-u32|gate-barket-dec-u32|gate-barket-amount-u32|gate-barket-count-u32)
  test -n "$SAMPLE" || {
    echo "FAIL: ${STEM}.glow needs one @u32 sample decimal"
    exit 2
  }
  test -z "$SAMPLE2" || {
    echo "FAIL: ${STEM}.glow takes one sample only"
    exit 2
  }
  ;;
gate-kind-tag|gate-barket-kind-tag)
  test -n "$SAMPLE" || {
    echo "FAIL: ${STEM}.glow needs one kind unit tag (mint|send)"
    exit 2
  }
  test -z "$SAMPLE2" || {
    echo "FAIL: ${STEM}.glow takes one tag only"
    exit 2
  }
  ;;
gate-xact-tag|gate-barket-xact-tag)
  test -n "$SAMPLE" || {
    echo "FAIL: ${STEM}.glow needs tag mint|send"
    exit 2
  }
  if [ "$SAMPLE" = "mint" ]; then
    test -n "$SAMPLE2" || {
      echo "FAIL: ${STEM}.glow mint needs amount u32"
      exit 2
    }
  else
    test -z "$SAMPLE2" || {
      echo "FAIL: ${STEM}.glow send takes no amount"
      exit 2
    }
  fi
  ;;
*)
  test -z "$SAMPLE" || {
    echo "FAIL: only sample-u32 / gate-*-u32 / gate-*-kind-tag / gate-*-xact-tag take a sample"
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
  if [ -n "$SAMPLE2" ]; then
    "$BIN" "$SAMPLE" "$SAMPLE2"
  else
    "$BIN" "$SAMPLE"
  fi
  echo "EXIT:$?"
else
  RYE=$(glow/bin/glow_run "$GLOW")
  test -n "$RYE"
  env RYE_ZIG="$ZIG" rye/bin/rye build "$RYE" -femit-bin="$BIN"
  "$BIN"
  echo "EXIT:$?"
fi
