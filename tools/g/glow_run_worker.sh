#!/bin/sh
# glow_run_worker.sh -- lower - build - run one Glow desk (fixture or argv sample).
# Invoked by tools/g/glow_run.rish.
#
#   tools/g/glow_run_worker.sh <file.glow>                           # fixture path
#   tools/g/glow_run_worker.sh <file.glow> <sample>                  # u32 or kind tag
#   tools/g/glow_run_worker.sh <file.glow> mint <amount-u32>         # xact payload tag
#   tools/g/glow_run_worker.sh <file.glow> mint <from> <amount>      # xfer payload tag
#   tools/g/glow_run_worker.sh <file.glow> <u32>...                  # $: N-field (pair...nona)

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
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
sample-u32|gate-sample-u32|gate-double-u32|gate-pleac-double-u32|gate-surface-double-u32|gate-surface-inc-u32|gate-tally-dec-u32|gate-tally-garden-bound-u32|gate-tally-fold-sumto-u32|gate-tally-fold-prodto-u32|gate-caravan-dependents-bound-u32|gate-aurora-wire-bound-u32|gate-aurora-seed-length-eq-u32|gate-aurora-signature-length-eq-u32|gate-aurora-living-stages-eq-u32|gate-caravan-exit-meanings-eq-u32|gate-mantra-line-fields-eq-u32|gate-mantra-weave-fields-eq-u32|gate-mantra-diff-fields-eq-u32|gate-mantra-store-dirs-eq-u32|gate-mantra-gen-floor-u32|gate-tally-name-len-bound-u32|gate-caravan-caps-bound-u32|gate-comlink-dual-stack-bind-u32|gate-comlink-addr-width-u32|gate-rishi-env-bindings-bound-u32|gate-rishi-history-bound-u32|gate-say-u32|gate-inc-u32|gate-sumto-u32|gate-prodto-u32|gate-sumto-lawful-u32|gate-prodto-lawful-u32|gate-gardens-lawful-u32|gate-caps-lawful-u32|gate-dependents-lawful-u32|gate-caravan-caps-pair-bound-u32|gate-mantra-gen-floor-pair-u32|gate-pair-eq-faces|gate-pair-gth-faces|gate-tally-garden-pair-bound-u32|gate-pair-max|gate-pair-min|gate-compose-sumto-u32|gate-dec-u32|gate-amount-u32|gate-count-u32|gate-barket-sample-u32|gate-barket-double-u32|gate-barket-inc-u32|gate-barket-dec-u32|gate-barket-amount-u32|gate-barket-count-u32|gate-fold-sumto-missing-bound|gate-fold-sum-on-u32|gate-fold-prodto-bound-13|gate-skate-kind-ceiling-u32|gate-skate-kind-floor-u32|gate-skate-ring-admit-u32|gate-surface-lit-area-u32|gate-lantern-face-text-u32|gate-lantern-unknown-law-u32|gate-lantern-feed-unknown-u32|gate-lantern-unknown-law-rune-u32|gate-pond-preset-offset-u32|gate-pond-preset-offset-rune-u32)
  case "$STEM" in
    gate-pair-eq-faces|gate-pair-gth-faces|gate-tally-garden-pair-bound-u32|gate-caravan-caps-pair-bound-u32|gate-mantra-gen-floor-pair-u32|gate-pair-max|gate-pair-min|gate-lantern-unknown-law-u32|gate-lantern-feed-unknown-u32|gate-lantern-unknown-law-rune-u32|gate-pond-preset-offset-u32|gate-pond-preset-offset-rune-u32)
      test "$NARGS" -eq 2 -o "$NARGS" -eq 0 || {
        echo "FAIL: ${STEM}.glow needs exactly two @u32 sample decimals"
        exit 2
      }
      ;;
    gate-surface-lit-area-u32)
      # mul-b: the composed cond's desk takes lit, width, height.
      test "$NARGS" -eq 3 || {
        echo "FAIL: ${STEM}.glow needs exactly three @u32 sample decimals"
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
gate-lantern-face-core)
  # core: argv[1] is the arm ordinal, then that arm's one or two samples.
  test "$NARGS" -eq 2 -o "$NARGS" -eq 3 || {
    echo "FAIL: ${STEM}.glow needs an arm ordinal and its one or two @u32 samples"
    exit 2
  }
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
  # STOA324: closed $: pair...nona fields -- one path (stem -> N -> exact count).
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

# One builder at a time, and no half-written artifact ever left standing.
#
# Every invocation rebuilds glow/bin/glow_run and writes glow/.cache, so two
# witnesses running at once -- a sweep beside a hand-run gate -- interleave on
# the same bytes: one truncates what the other is about to execute, and the
# gate that loses the race reports RED about its own logic while nothing is
# wrong with it. Three false REDs in a single round were bought exactly this
# way, and a killed build left a truncated glow_run that a later, entirely
# clean run then trusted.
#
# Two guards close it, in TAME's own order of safety before speed:
#   1. Builds serialize behind one lock, waited on with a named bound rather
#      than forever, so a deadlock reports itself instead of hanging.
#   2. Every binary is emitted to a private path and moved into place with
#      rename, which is atomic -- so an interrupted build leaves the previous
#      good binary standing rather than a plausible-looking ruin.
#
# The lock is a DIRECTORY rather than `flock` on a descriptor, because `flock(1)` is util-linux and
# macOS ships none -- every witness reaching this worker refused there with `flock: command not
# found` (REDS %279). `lock_acquire` in tools/fixtures/s/shell_portable.sh keeps both properties this
# block was written for: mutual exclusion, since `mkdir` is atomic, and a bounded wait that refuses
# by name rather than hanging.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

# The name carries `.d` because the mechanism is a directory. The elder `flock` spelling left a
# zero-byte FILE at `.build.lock`, and `mkdir` over a plain file fails forever -- so a run on a
# clone that had used the elder worker would wait out its whole bound and refuse. A new
# mechanism under a new name makes that residue simply irrelevant, with no reaping special case.
#
# THE SAME SHAPE CAME BACK INSIDE THE NEW MECHANISM, one layer down (REDS %445). A builder killed
# between `mkdir` and the write of its pid leaves the lock standing with a ZERO-BYTE `pid`, and
# `lock_acquire` read that as a lock caught mid-creation and waited on it rather than reaping it --
# forever, since nobody was ever going to write that pid. Measured here `20260905`: a lock left at
# 17:16 blocked every Glow build for five hours and forty-five minutes, and the cold roster read
# `lantern_face green 1454s` against the 9.5s its own row declares. `lock_acquire` now reaps an
# empty pid past a bounded grace, so this worker's `BUILD_LOCK_WAIT` is again the bound it reads
# like -- the longest a LIVE builder may hold the lock, rather than the price of one dead one.
BUILD_LOCK=glow/.cache/.build.lock.d
BUILD_LOCK_WAIT=${GLOW_BUILD_LOCK_WAIT:-1800}
lock_acquire "$BUILD_LOCK" "$BUILD_LOCK_WAIT" || {
  echo "FAIL: glow build lock not acquired within ${BUILD_LOCK_WAIT}s"
  exit 3
}

# Temporaries carry this run's pid so a concurrent run never adopts them, and
# the trap clears them on every exit path including a kill.
TMP_TAG="building.$$"
# The lock leaves with the temporaries: a directory outlives its owner where a descriptor lock does
# not, so releasing it on every exit path is what keeps the next run from waiting out its bound.
# The .ryekey sidecar rides every emit and must ride the install and the cleanup too --
# 4,666 orphaned building tags, two per successful lane, taught this on 20260830.
cleanup_tmp() { rm -f "glow/bin/glow_run.$TMP_TAG" "glow/bin/glow_run.$TMP_TAG.ryekey" "$BIN.$TMP_TAG" "$BIN.$TMP_TAG.ryekey"; lock_release "$BUILD_LOCK"; }
trap cleanup_tmp EXIT INT TERM

# build_atomic <source.rye> <final-bin> -- emit beside the target, then rename.
build_atomic() {
  _src=$1
  _dst=$2
  env RYE_ZIG="$ZIG" rye/bin/rye build "$_src" -femit-bin="$_dst.$TMP_TAG"
  mv -f "$_dst.$TMP_TAG" "$_dst"
  if test -f "$_dst.$TMP_TAG.ryekey"; then mv -f "$_dst.$TMP_TAG.ryekey" "$_dst.ryekey"; fi
}

# STOA344 - O3: same-dir alias so plants import the vane inside the module path (one source, compiler-followed).
# Both aliases link the module DIRECTORY rather than one file, because a vane's own siblings have to
# resolve too: tally/gardens.rye imports region.rye by bare name, and Zig resolves that beside the
# file it followed the link to. A flat file symlink put gardens.rye in glow/.cache/, where no
# region.rye stands, so every gardens_lawful plant failed to build with FileNotFound. Caravan was
# always linked as a directory and never had the fault (REDS %299).
ln -sfn ../../tally glow/.cache/tally
ln -sfn ../../caravan glow/.cache/caravan
build_atomic glow/glow_run.rye glow/bin/glow_run

if [ "$NARGS" -gt 0 ]; then
  RYE=$(glow/bin/glow_run --sample-argv "$GLOW")
  test -n "$RYE"
  build_atomic "$RYE" "$BIN"
  "$BIN" "$@"
  echo "EXIT:$?"
else
  RYE=$(glow/bin/glow_run "$GLOW")
  test -n "$RYE"
  build_atomic "$RYE" "$BIN"
  "$BIN"
  echo "EXIT:$?"
fi
