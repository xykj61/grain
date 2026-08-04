#!/bin/sh
# glow_run_worker.sh — lower · build · run one Glow desk (fixture or argv sample).
# Invoked by tools/glow_run.rish.
#
#   tools/glow_run_worker.sh <file.glow>                           # fixture path
#   tools/glow_run_worker.sh <file.glow> <sample>                  # u32 or kind tag
#   tools/glow_run_worker.sh <file.glow> mint <amount-u32>         # xact payload tag
#   tools/glow_run_worker.sh <file.glow> mint <from> <amount>      # xfer payload tag
#   tools/glow_run_worker.sh <file.glow> <u32>...                  # $: N-field (pair…nona)

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"
GLOW=$1
shift || true

test -n "$GLOW" || {
  echo "usage: glow_run_worker.sh <file.glow> [<sample>] [<u32>]..."
  exit 2
}

STEM=$(basename "$GLOW" .glow)
BIN="glow/bin/$STEM"
# Remaining positional args are samples (after shift).
NARGS=$#

fields_need() {
  case "$1" in
  gate-pair-fields|gate-barket-pair-fields|gate-tally-fold-pair-sum) echo 2 ;;
  gate-triple-fields|gate-barket-triple-fields|gate-tally-fold-triple-sum|gate-tally-fold-triple-prod|gate-mantra-fold-triple-fields) echo 3 ;;
  gate-quad-fields|gate-barket-quad-fields|gate-tally-fold-quad-sum) echo 4 ;;
  gate-penta-fields|gate-barket-penta-fields) echo 5 ;;
  gate-hexa-fields|gate-barket-hexa-fields) echo 6 ;;
  gate-hepta-fields|gate-barket-hepta-fields) echo 7 ;;
  gate-octa-fields|gate-barket-octa-fields) echo 8 ;;
  gate-nona-fields|gate-barket-nona-fields) echo 9 ;;
  *) echo 0 ;;
  esac
}

NEED_FIELDS=$(fields_need "$STEM")

case "$STEM" in
sample-u32|gate-sample-u32|gate-double-u32|gate-pleac-double-u32|gate-surface-double-u32|gate-surface-inc-u32|gate-tally-dec-u32|gate-tally-garden-bound-u32|gate-tally-fold-sumto-u32|gate-tally-fold-prodto-u32|gate-caravan-dependents-bound-u32|gate-aurora-wire-bound-u32|gate-aurora-seed-length-eq-u32|gate-aurora-signature-length-eq-u32|gate-aurora-living-stages-eq-u32|gate-caravan-exit-meanings-eq-u32|gate-mantra-line-fields-eq-u32|gate-mantra-weave-fields-eq-u32|gate-mantra-diff-fields-eq-u32|gate-mantra-store-dirs-eq-u32|gate-mantra-gen-floor-u32|gate-tally-name-len-bound-u32|gate-caravan-caps-bound-u32|gate-comlink-dual-stack-bind-u32|gate-comlink-addr-width-u32|gate-rishi-env-bindings-bound-u32|gate-rishi-history-bound-u32|gate-say-u32|gate-inc-u32|gate-sumto-u32|gate-prodto-u32|gate-sumto-lawful-u32|gate-prodto-lawful-u32|gate-gardens-lawful-u32|gate-pair-eq-faces|gate-pair-gth-faces|gate-tally-garden-pair-bound-u32|gate-pair-max|gate-pair-min|gate-compose-sumto-u32|gate-dec-u32|gate-amount-u32|gate-count-u32|gate-barket-sample-u32|gate-barket-double-u32|gate-barket-inc-u32|gate-barket-dec-u32|gate-barket-amount-u32|gate-barket-count-u32|gate-fold-sumto-missing-bound|gate-fold-sum-on-u32|gate-fold-prodto-bound-13)
  case "$STEM" in
    gate-pair-eq-faces|gate-pair-gth-faces|gate-tally-garden-pair-bound-u32|gate-pair-max|gate-pair-min)
      test "$NARGS" -eq 2 -o "$NARGS" -eq 0 || {
        echo "FAIL: ${STEM}.glow needs exactly two @u32 sample decimals"
        exit 2
      }
      ;;
    *)
  test "$NARGS" -eq 1 || {
    echo "FAIL: ${STEM}.glow needs exactly one @u32 sample decimal"
    exit 2
  }
      ;;
  esac
  ;;
gate-kind-tag|gate-barket-kind-tag)
  test "$NARGS" -eq 1 || {
    echo "FAIL: ${STEM}.glow needs exactly one kind unit tag (mint|send)"
    exit 2
  }
  ;;
gate-xact-tag|gate-barket-xact-tag)
  test -n "${1-}" || {
    echo "FAIL: ${STEM}.glow needs tag mint|send"
    exit 2
  }
  if [ "$1" = "mint" ]; then
    test "$NARGS" -eq 2 || {
      echo "FAIL: ${STEM}.glow mint needs exactly one amount u32"
      exit 2
    }
  else
    test "$NARGS" -eq 1 || {
      echo "FAIL: ${STEM}.glow send takes no amount"
      exit 2
    }
  fi
  ;;
gate-xfer-tag|gate-barket-xfer-tag)
  test -n "${1-}" || {
    echo "FAIL: ${STEM}.glow needs tag mint|send"
    exit 2
  }
  if [ "$1" = "mint" ]; then
    test "$NARGS" -eq 3 || {
      echo "FAIL: ${STEM}.glow mint needs from u32 and amount u32"
      exit 2
    }
  else
    test "$NARGS" -eq 1 || {
      echo "FAIL: ${STEM}.glow send takes no faces"
      exit 2
    }
  fi
  ;;
*)
  # STOA324: closed $: pair…nona fields — one path (stem → N → exact count).
  if [ "$NEED_FIELDS" -ge 2 ]; then
    test "$NARGS" -eq "$NEED_FIELDS" || {
      echo "FAIL: ${STEM}.glow needs exactly ${NEED_FIELDS} field decimals"
      exit 2
    }
  else
    test "$NARGS" -eq 0 || {
      echo "FAIL: only sample-u32 / gate-*-u32 / gate-*-kind-tag / gate-*-xact-tag / gate-*-xfer-tag / gate-*-fields take a sample"
      exit 2
    }
  fi
  ;;
esac

mkdir -p glow/bin glow/.cache
# STOA344 · O3: same-dir alias so plants import the vane inside the module path (one source, compiler-followed).
ln -sf ../../tally/gardens.rye glow/.cache/tally_gardens.rye
env RYE_ZIG="$ZIG" rye/bin/rye build glow/glow_run.rye -femit-bin=glow/bin/glow_run

if [ "$NARGS" -gt 0 ]; then
  RYE=$(glow/bin/glow_run --sample-argv "$GLOW")
  test -n "$RYE"
  env RYE_ZIG="$ZIG" rye/bin/rye build "$RYE" -femit-bin="$BIN"
  "$BIN" "$@"
  echo "EXIT:$?"
else
  RYE=$(glow/bin/glow_run "$GLOW")
  test -n "$RYE"
  env RYE_ZIG="$ZIG" rye/bin/rye build "$RYE" -femit-bin="$BIN"
  "$BIN"
  echo "EXIT:$?"
fi
