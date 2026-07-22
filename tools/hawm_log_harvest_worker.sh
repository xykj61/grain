#!/usr/bin/env bash
# hawm_log_harvest_worker.sh — STOA275: fold HAWM0 boot meta into a Bron harvest.
#
# Reads tools/.cache/hawm0/hawm0-boot-meta.txt (or --fixture) and writes
# tools/.cache/hawm0/hawm-harvest.bron with the hawm-harvest-v1 shape.
# Device-free when meta already exists; does not boot the emulator.
#
#   ./tools/hawm_log_harvest_worker.sh
#   ./tools/hawm_log_harvest_worker.sh --fixture

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

CACHE="$REPO_ROOT/tools/.cache/hawm0"
META="$CACHE/hawm0-boot-meta.txt"
OUT="$CACHE/hawm-harvest.bron"
FIXTURE="$REPO_ROOT/tools/fixtures/hawm_harvest_v1.bron"
STAMP="$(date '+%Y%m%d.%H%M%S')"

use_fixture=0
if [ "${1:-}" = "--fixture" ]; then
  use_fixture=1
fi

mkdir -p "$CACHE"

if [ "$use_fixture" -eq 1 ]; then
  cp "$FIXTURE" "$OUT"
  # Refresh stamp on the copy so the harvest names this run.
  tmp="$(mktemp)"
  awk -v s="$STAMP" '
    BEGIN { done=0 }
    /^stamp / && !done { print "stamp " s; done=1; next }
    { print }
  ' "$OUT" >"$tmp"
  mv "$tmp" "$OUT"
  echo "harvest: wrote fixture-shaped $OUT"
  exit 0
fi

if [ ! -f "$META" ]; then
  echo "RED: missing $META — boot hawm0 first or pass --fixture" >&2
  exit 1
fi

if ! grep -q '^device: ' "$META"; then
  echo "RED: $META has no device: line — boot incomplete" >&2
  exit 1
fi

device_line="$(grep '^device: ' "$META" | tail -n1)"
# device: model=… android=… abi=… qemu=… [serial=…]
model="$(printf '%s' "$device_line" | sed -n 's/.*model=\([^ ]*\).*/\1/p')"
android="$(printf '%s' "$device_line" | sed -n 's/.*android=\([^ ]*\).*/\1/p')"
abi="$(printf '%s' "$device_line" | sed -n 's/.*abi=\([^ ]*\).*/\1/p')"
qemu="$(printf '%s' "$device_line" | sed -n 's/.*qemu=\([^ ]*\).*/\1/p')"
serial="$(printf '%s' "$device_line" | sed -n 's/.*serial=\([^ ]*\).*/\1/p')"
if [ -z "$serial" ]; then
  serial=unknown
fi

boot_completed=0
if grep -q 'boot_completed' "$META" || grep -q 'already booted' "$META"; then
  boot_completed=1
fi

kvm=absent
if grep -q '/dev/kvm present' "$META"; then
  kvm=present
fi

# Optional HAWM1 fold — present after hawm1_sala_witness captures the root.
SESSION_ROOT_FILE="$CACHE/hawm1-session-root.txt"
session_root=pending
if [ -f "$SESSION_ROOT_FILE" ]; then
  session_root="$(cat "$SESSION_ROOT_FILE")"
  if [[ ! "$session_root" =~ ^[0-9a-f]{64}$ ]]; then
    echo "RED: $SESSION_ROOT_FILE is not 64 lowercase hex" >&2
    exit 1
  fi
fi

cat >"$OUT" <<EOF
format hawm-harvest-v1
stamp ${STAMP}
waymark HAWM
rung HAWM0
source meta
kvm ${kvm}
boot_completed ${boot_completed}
model ${model}
android ${android}
abi ${abi}
qemu ${qemu}
serial ${serial}
session_root ${session_root}
meta_path tools/.cache/hawm0/hawm0-boot-meta.txt
emulator_log_path tools/.cache/hawm0/hawm0-emulator.log
status GREEN
EOF

echo "harvest: wrote $OUT"
echo "harvest: model=${model} android=${android} abi=${abi} serial=${serial} session_root=${session_root}"
