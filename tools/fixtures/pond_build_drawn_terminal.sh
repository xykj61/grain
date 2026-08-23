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

# Ask the shared probe whether this machine carries a graphical link seam, rather than assuming.
# WHY (REDS %173): this block used to print "assuming host link seams on metal" and hand a guess to
# a compile that discovered the truth at link time, where an absent GUI library on a headless pier
# reads as a broken tree instead of a machine without a screen. One probe, six callers.
# `set -e` is on, and the probe exits 3 by design, so the call is guarded: an unguarded
# command substitution would end the script at the assignment with no line explaining why.
probe_code=0
probe=$(sh tools/fixtures/display_seam_probe.sh 2>&1) || probe_code=$?
probe=$(printf '%s\n' "$probe" | head -1)
if [ "$probe_code" -eq 3 ]; then
  echo "build: GATED -- ${probe}"
  echo "build: GATED -- drawn-terminal is a Wayland application, so it wants a host with a display"
  echo "build: GATED -- provisioning those libraries is a NixOS rebuild, which is a gate a hand opens"
  echo "verdict=gated_no_display"
  exit 3
fi
echo "build: prepare -- ${probe}"
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
