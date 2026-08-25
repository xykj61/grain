#!/bin/sh
# stranger_lap_worker.sh -- body of the stranger's lap (OPEN_QUESTIONS #4).
#
# Invoked by tools/s/stranger_lap_witness.rish (and the bound-negative fixture).
# Avoids Rish dollar-interpolation: all shell vars live here.
#
# ---------------------------------------------------------------------------
# SCOPE (read this before trusting a GREEN line)
# ---------------------------------------------------------------------------
# Today's seated path is mode=warm. That configuration is the FASTEST that can
# exist for this witness:
#   - clone source = LOCAL pier path (file:// / path clone), not a network fetch
#   - git clone --depth 1 (shallow tip only)
#   - pre-warmed toolchain (ziglang already on the host; linked, not freshly
#     installed)
#
# Therefore a warm GREEN does NOT yet prove:
#   - a network clone from a remote URL
#   - a full-history clone (no --depth)
#   - a cold toolchain install (pip/fetch when nothing is cached)
#
# Mode=cold asks for those three. Framework cold REPORT 20260725.174428 printed
# elapsed=29s under the 1800s claim ceiling (remote origin - full history -
# force-reinstall ziglang). Seat stays REPORT; tighten the bound only when the
# range of real reports across hosts justifies it. Cold SSH clones need the
# origin host key already trusted (BatchMode; no ssh-askpass in jail).
# ---------------------------------------------------------------------------
set -eu

# Mode switch -- warm (today's seat) - cold (network - full history - forced install).
# Override: STRANGER_LAP_MODE=cold
MODE=${STRANGER_LAP_MODE:-warm}

# Bound (seconds). Default is the OPEN_QUESTIONS #4 claim ceiling: thirty minutes.
# Reason: until cold - networked - full-clone reports exist, do not tighten from
# the warm-path best case. Override only for fixtures (e.g. bound-negative).
STRANGER_LAP_WALL_SECONDS=${STRANGER_LAP_WALL_SECONDS:-1800}

# Posture: report (default seat) -- comparison still runs and can FAIL; the
# seated bound stays at the claim ceiling so warm does not pretend to gate cold.
# Override STRANGER_LAP_POSTURE only in fixtures that exercise the comparator.
POSTURE=${STRANGER_LAP_POSTURE:-report}

# ONE named witness -- small, self-contained, already on the pier.
STRANGER_NAMED_WITNESS="tools/cr/crockford_stamp_witness.rish"

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
ORIGIN=$(git -C "$ROOT" remote get-url origin)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/stranger-lap.XXXXXX")
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

case "$MODE" in
  warm|cold) ;;
  *)
    echo "FAIL: stranger lap unknown mode=${MODE} (want warm|cold)"
    exit 2
    ;;
esac

echo "STRANGER_MODE=${MODE}"
echo "STRANGER_POSTURE=${POSTURE}"
echo "stranger-lap: temp=${TMP}"
echo "stranger-lap: witness=${STRANGER_NAMED_WITNESS}"
echo "stranger-lap: bound_seconds=${STRANGER_LAP_WALL_SECONDS}"

START=$(date +%s)

if [ "$MODE" = "warm" ]; then
  # Fastest credible seat: local file:// clone - shallow - reuse prewarmed zig.
  # file:// is required for --depth on a local pier (path clones ignore --depth
  # and can hardlink-fail against a dirty worktree).
  echo "STRANGER_CONFIG=local-path depth=1 toolchain=prewarmed"
  git clone --depth 1 "file://${ROOT}" "$TMP/pier"
  cd "$TMP/pier"
  mkdir -p vendor
  # Prefer the source pier's pinned toolchain (Framework / ai-jail usual), then
  # the ziglang Python package, then a one-shot pip install. pip is often
  # absent on locked-down hosts; the pier vendor path is the real prewarm.
  if [ -x "${ROOT}/vendor/zig-toolchain/zig" ]; then
    ln -sfn "${ROOT}/vendor/zig-toolchain" vendor/zig-toolchain
  elif python3 -c 'import ziglang' >/dev/null 2>&1; then
    ln -sfn "$(python3 -c 'import ziglang,os;print(os.path.dirname(ziglang.__file__))')" vendor/zig-toolchain
  else
    echo "ADVISORY: warm mode expected pre-warmed zig; installing ziglang once"
    python3 -m pip install 'ziglang==0.16.0' --break-system-packages
    ln -sfn "$(python3 -c 'import ziglang,os;print(os.path.dirname(ziglang.__file__))')" vendor/zig-toolchain
  fi
else
  # Cold path: remote URL - full history - forced toolchain reinstall.
  echo "STRANGER_CONFIG=remote-url depth=full toolchain=cold-install"
  git clone "$ORIGIN" "$TMP/pier"
  cd "$TMP/pier"
  python3 -m pip install --force-reinstall 'ziglang==0.16.0' --break-system-packages
  mkdir -p vendor
  ln -sfn "$(python3 -c 'import ziglang,os;print(os.path.dirname(ziglang.__file__))')" vendor/zig-toolchain
fi

export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
test -x "$RYE_ZIG" || {
  echo "FAIL: stranger lap zig missing at ${RYE_ZIG}"
  exit 1
}

sh rye/bootstrap.sh
mkdir -p rishi/bin
rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi

set +e
rishi/bin/rishi run "$STRANGER_NAMED_WITNESS"
WITNESS_RC=$?
set -e

END=$(date +%s)
ELAPSED=$((END - START))
echo "STRANGER_ELAPSED_SECONDS=${ELAPSED}"
echo "STRANGER_BOUND_SECONDS=${STRANGER_LAP_WALL_SECONDS}"

if [ "$WITNESS_RC" -ne 0 ]; then
  echo "FAIL: stranger lap named witness exited non-zero"
  exit 1
fi

# Live comparator -- elapsed must be strictly under the named bound.
if [ "$ELAPSED" -lt "$STRANGER_LAP_WALL_SECONDS" ]; then
  echo "STRANGER_BOUND_OK=1"
  echo "REPORT: stranger lap mode=${MODE} posture=${POSTURE} elapsed=${ELAPSED}s bound=${STRANGER_LAP_WALL_SECONDS}s — under bound"
  echo "GREEN: stranger lap — ${MODE} · ${STRANGER_NAMED_WITNESS} · ${ELAPSED}s < ${STRANGER_LAP_WALL_SECONDS}s"
  exit 0
fi

echo "STRANGER_BOUND_OK=0"
echo "FAIL: stranger lap exceeded wall-clock bound (${ELAPSED} >= ${STRANGER_LAP_WALL_SECONDS})"
exit 1
