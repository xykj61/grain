#!/bin/sh
# stranger_lap_worker.sh — body of the stranger's lap (OPEN_QUESTIONS #4).
#
# Clone the pier fresh from origin into a temp dir, raise the toolchain per
# manual/guides/cloud-agent-toolchain-setup.md, run ONE named witness, print
# elapsed seconds. Invoked by tools/stranger_lap_witness.rish.
#
# Avoids Rish dollar-interpolation: all shell vars live here.
set -eu

# Named bound (seconds).
# Reason: the open question claimed "under thirty minutes" (1800s). First GREEN
# seat on this cloud host (ziglang already present via pip) reported
# STRANGER_ELAPSED_SECONDS=3. Bound pins above that report with room for a cold
# pip install and ordinary host variance, while staying well under the original
# thirty-minute claim ceiling.
STRANGER_LAP_WALL_SECONDS=120

# ONE named witness — the documented cloud-guide family (small, self-contained).
STRANGER_NAMED_WITNESS="tools/crockford_stamp_witness.rish"

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
ORIGIN=$(git -C "$ROOT" remote get-url origin)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/stranger-lap.XXXXXX")
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "stranger-lap: temp=${TMP}"
echo "stranger-lap: witness=${STRANGER_NAMED_WITNESS}"
echo "stranger-lap: bound_seconds=${STRANGER_LAP_WALL_SECONDS}"

START=$(date +%s)

git clone --depth 1 "$ORIGIN" "$TMP/pier"
cd "$TMP/pier"

# Raise zig — same recipe as manual/guides/cloud-agent-toolchain-setup.md.
# Prefer an already-present ziglang package; install only when missing.
if ! python3 -c 'import ziglang' >/dev/null 2>&1; then
  pip3 install 'ziglang==0.16.0' --break-system-packages
fi
mkdir -p vendor
ln -sfn "$(python3 -c 'import ziglang,os;print(os.path.dirname(ziglang.__file__))')" vendor/zig-toolchain
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"

sh rye/bootstrap.sh
mkdir -p rishi/bin
rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi

rishi/bin/rishi run "$STRANGER_NAMED_WITNESS"
WITNESS_RC=$?

END=$(date +%s)
ELAPSED=$((END - START))
echo "STRANGER_ELAPSED_SECONDS=${ELAPSED}"
echo "STRANGER_BOUND_SECONDS=${STRANGER_LAP_WALL_SECONDS}"

if [ "$WITNESS_RC" -ne 0 ]; then
  echo "ADVISORY: stranger lap named witness exited non-zero"
  exit 1
fi
if [ "$ELAPSED" -gt "$STRANGER_LAP_WALL_SECONDS" ]; then
  echo "ADVISORY: stranger lap exceeded wall-clock bound (${ELAPSED} > ${STRANGER_LAP_WALL_SECONDS})"
  exit 1
fi

echo "GREEN: stranger lap — clone · bootstrap · ${STRANGER_NAMED_WITNESS} · ${ELAPSED}s < ${STRANGER_LAP_WALL_SECONDS}s"
exit 0
