#!/usr/bin/env sh
# pond_build_drawn_terminal.sh — TAME-guided build (hosted by pond_build_drawn_terminal.rish).
#
# Canonical entry: rishi/bin/rishi run tools/fixtures/pond_build_drawn_terminal.rish
# Direct .sh only when you need lines to stream during a long compile.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "${ROOT}"

ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"
RYE="rye/bin/rye"
BIN="pond/bin/drawn-terminal"
SRC="pond/apps/drawn_terminal.rye"
PROTO="brushstroke/xdg-shell-protocol.c"
LINK_SEAMS="wayland-client xkbcommon rt"
HEARTBEAT_SECS=15

echo "build: Language EN — drawn-terminal compile witness."
echo "build: Style Radiant — staged lines carry progress; GREEN only after proof."
echo "build: Lens TAME — prepare, compile, prove; Zig may run silent until link."

echo "build: prepare — repository root ${ROOT}"
echo "build: prepare — source ${SRC}"
echo "build: prepare — output ${BIN}"
echo "build: prepare — RYE_ZIG=${ZIG}"

if ! test -x "${RYE}"; then
  echo "build: RED — ${RYE} missing or not executable"
  exit 1
fi
echo "build: prepare — rye driver present"

if ! test -x "${ZIG}"; then
  if ! test -f "${ZIG}"; then
    echo "build: RED — Zig toolchain missing at ${ZIG}"
    exit 1
  fi
fi
echo "build: prepare — Zig toolchain present"

if ! test -f "${SRC}"; then
  echo "build: RED — source missing: ${SRC}"
  exit 1
fi
if ! test -f "${PROTO}"; then
  echo "build: RED — protocol stub missing: ${PROTO}"
  exit 1
fi
echo "build: prepare — source and xdg-shell protocol present"

if command -v pkg-config >/dev/null 2>&1; then
  if pkg-config --exists xkbcommon 2>/dev/null; then
    echo "build: prepare — host link seam xkbcommon (pkg-config)"
  else
    echo "build: prepare — xkbcommon not found via pkg-config; link may still succeed on metal"
  fi
else
  echo "build: prepare — pkg-config absent; assuming host link seams on metal"
fi
echo "build: prepare — link seams: ${LINK_SEAMS}"

echo "build: prepare — ensuring pond/bin/"
mkdir -p pond/bin

echo "build: compile — ${SRC} → ${BIN}"
echo "build: compile — flags: -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt"
echo "build: compile — heartbeat every ${HEARTBEAT_SECS}s (silent compile is normal)"

(
  env RYE_ZIG="${ZIG}" "${RYE}" build "${SRC}" "${PROTO}" \
    -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt -femit-bin="${BIN}"
) &
BPID=$!
SECS=0
while kill -0 "${BPID}" 2>/dev/null; do
  sleep "${HEARTBEAT_SECS}"
  SECS=$((SECS + HEARTBEAT_SECS))
  echo "build: compile — still linking… ${SECS}s elapsed"
done
wait "${BPID}"
RC=$?

if [ "${RC}" -ne 0 ]; then
  echo "build: RED — rye compile failed (exit ${RC})"
  exit "${RC}"
fi
echo "build: prove — rye exit code 0"

if ! test -x "${BIN}"; then
  echo "build: RED — ${BIN} missing or not executable after compile"
  exit 1
fi

BYTES=$(wc -c < "${BIN}" | tr -d ' ')
echo "build: prove — ${BIN} executable (${BYTES} bytes)"

echo "GREEN: ${BIN} built."
