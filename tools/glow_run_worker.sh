#!/bin/sh
# glow_run_worker.sh — lower · build · run one Glow desk (fixture or argv sample).
# Invoked by tools/glow_run.rish.
#
#   tools/glow_run_worker.sh <file.glow>                           # fixture path
#   tools/glow_run_worker.sh <file.glow> <sample>                  # u32 or kind tag
#   tools/glow_run_worker.sh <file.glow> mint <amount-u32>         # xact payload tag
#   tools/glow_run_worker.sh <file.glow> mint <from> <amount>      # xfer payload tag
#   tools/glow_run_worker.sh <file.glow> <from> <amount>           # pair $: fields
#   tools/glow_run_worker.sh <file.glow> <from> <amount> <fee>     # triple $: fields
#   tools/glow_run_worker.sh <file.glow> <from> <amount> <fee> <nonce>  # quad $: fields
#   tools/glow_run_worker.sh <file.glow> <from> <amount> <fee> <nonce> <memo>  # penta
#   tools/glow_run_worker.sh <file.glow> <from> <amount> <fee> <nonce> <memo> <tag>  # hexa
#   tools/glow_run_worker.sh <file.glow> ... <to>  # hepta (7 fields)
#   tools/glow_run_worker.sh <file.glow> ... <via>  # octa (8 fields)

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"
GLOW=$1
SAMPLE=${2-}
SAMPLE2=${3-}
SAMPLE3=${4-}
SAMPLE4=${5-}
SAMPLE5=${6-}
SAMPLE6=${7-}
SAMPLE7=${8-}
SAMPLE8=${9-}

test -n "$GLOW" || {
  echo "usage: glow_run_worker.sh <file.glow> [<sample>] [<u32>]..."
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
    test -z "$SAMPLE3" || {
      echo "FAIL: ${STEM}.glow mint takes one amount only"
      exit 2
    }
  else
    test -z "$SAMPLE2" || {
      echo "FAIL: ${STEM}.glow send takes no amount"
      exit 2
    }
  fi
  ;;
gate-xfer-tag|gate-barket-xfer-tag)
  test -n "$SAMPLE" || {
    echo "FAIL: ${STEM}.glow needs tag mint|send"
    exit 2
  }
  if [ "$SAMPLE" = "mint" ]; then
    test -n "$SAMPLE2" && test -n "$SAMPLE3" || {
      echo "FAIL: ${STEM}.glow mint needs from u32 and amount u32"
      exit 2
    }
    test -z "$SAMPLE4" || {
      echo "FAIL: ${STEM}.glow mint takes two faces only"
      exit 2
    }
  else
    test -z "$SAMPLE2" || {
      echo "FAIL: ${STEM}.glow send takes no faces"
      exit 2
    }
  fi
  ;;
gate-pair-fields|gate-barket-pair-fields)
  test -n "$SAMPLE" && test -n "$SAMPLE2" || {
    echo "FAIL: ${STEM}.glow needs from u32 and amount u32"
    exit 2
  }
  test -z "$SAMPLE3" || {
    echo "FAIL: ${STEM}.glow takes two field decimals only"
    exit 2
  }
  ;;
gate-triple-fields|gate-barket-triple-fields)
  test -n "$SAMPLE" && test -n "$SAMPLE2" && test -n "$SAMPLE3" || {
    echo "FAIL: ${STEM}.glow needs from u32, amount u32, and fee u32"
    exit 2
  }
  test -z "$SAMPLE4" || {
    echo "FAIL: ${STEM}.glow takes three field decimals only"
    exit 2
  }
  ;;
gate-quad-fields|gate-barket-quad-fields)
  test -n "$SAMPLE" && test -n "$SAMPLE2" && test -n "$SAMPLE3" && test -n "$SAMPLE4" || {
    echo "FAIL: ${STEM}.glow needs from u32, amount u32, fee u32, and nonce u32"
    exit 2
  }
  test -z "$SAMPLE5" || {
    echo "FAIL: ${STEM}.glow takes four field decimals only"
    exit 2
  }
  ;;
gate-penta-fields|gate-barket-penta-fields)
  test -n "$SAMPLE" && test -n "$SAMPLE2" && test -n "$SAMPLE3" && test -n "$SAMPLE4" && test -n "$SAMPLE5" || {
    echo "FAIL: ${STEM}.glow needs from, amount, fee, nonce, and memo u32"
    exit 2
  }
  test -z "$SAMPLE6" || {
    echo "FAIL: ${STEM}.glow takes five field decimals only"
    exit 2
  }
  ;;
gate-hexa-fields|gate-barket-hexa-fields)
  test -n "$SAMPLE" && test -n "$SAMPLE2" && test -n "$SAMPLE3" && test -n "$SAMPLE4" && test -n "$SAMPLE5" && test -n "$SAMPLE6" || {
    echo "FAIL: ${STEM}.glow needs from, amount, fee, nonce, memo, and tag u32"
    exit 2
  }
  test -z "$SAMPLE7" || {
    echo "FAIL: ${STEM}.glow takes six field decimals only"
    exit 2
  }
  ;;
gate-hepta-fields|gate-barket-hepta-fields)
  test -n "$SAMPLE" && test -n "$SAMPLE2" && test -n "$SAMPLE3" && test -n "$SAMPLE4" && test -n "$SAMPLE5" && test -n "$SAMPLE6" && test -n "$SAMPLE7" || {
    echo "FAIL: ${STEM}.glow needs from, amount, fee, nonce, memo, tag, and to u32"
    exit 2
  }
  test -z "$SAMPLE8" || {
    echo "FAIL: ${STEM}.glow takes seven field decimals only"
    exit 2
  }
  ;;
gate-octa-fields|gate-barket-octa-fields)
  test -n "$SAMPLE" && test -n "$SAMPLE2" && test -n "$SAMPLE3" && test -n "$SAMPLE4" && test -n "$SAMPLE5" && test -n "$SAMPLE6" && test -n "$SAMPLE7" && test -n "$SAMPLE8" || {
    echo "FAIL: ${STEM}.glow needs from, amount, fee, nonce, memo, tag, to, and via u32"
    exit 2
  }
  ;;
*)
  test -z "$SAMPLE" || {
    echo "FAIL: only sample-u32 / gate-*-u32 / gate-*-kind-tag / gate-*-xact-tag / gate-*-xfer-tag / gate-*-pair-fields / gate-*-triple-fields / gate-*-quad-fields / gate-*-penta-fields / gate-*-hexa-fields / gate-*-hepta-fields / gate-*-octa-fields take a sample"
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
  if [ -n "$SAMPLE8" ]; then
    "$BIN" "$SAMPLE" "$SAMPLE2" "$SAMPLE3" "$SAMPLE4" "$SAMPLE5" "$SAMPLE6" "$SAMPLE7" "$SAMPLE8"
  elif [ -n "$SAMPLE7" ]; then
    "$BIN" "$SAMPLE" "$SAMPLE2" "$SAMPLE3" "$SAMPLE4" "$SAMPLE5" "$SAMPLE6" "$SAMPLE7"
  elif [ -n "$SAMPLE6" ]; then
    "$BIN" "$SAMPLE" "$SAMPLE2" "$SAMPLE3" "$SAMPLE4" "$SAMPLE5" "$SAMPLE6"
  elif [ -n "$SAMPLE5" ]; then
    "$BIN" "$SAMPLE" "$SAMPLE2" "$SAMPLE3" "$SAMPLE4" "$SAMPLE5"
  elif [ -n "$SAMPLE4" ]; then
    "$BIN" "$SAMPLE" "$SAMPLE2" "$SAMPLE3" "$SAMPLE4"
  elif [ -n "$SAMPLE3" ]; then
    "$BIN" "$SAMPLE" "$SAMPLE2" "$SAMPLE3"
  elif [ -n "$SAMPLE2" ]; then
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
