#!/usr/bin/env bash
# proven_seat_g0c_lane_kvm.sh — in-lane G0-complete (counsel 20260712.090512).
#
# Requires lane_kvm on + /dev/kvm. Two phases (same sitting):
#   A) Serial floor — -nographic; poll until GRUB loading (grep -aF — portable;
#      Rishi's PATH often lacks rg).
#   B) Glass — -display none (VGA kept) + QMP screendump PNG.
# Both keep -nic none until a worded networking need.
#
#   ./tools/run_with_lane_kvm.sh -- ./tools/proven_seat_g0c_lane_kvm.sh
#   rishi/bin/rishi run tools/lane_kvm_onpath_host.rish

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

"$REPO_ROOT/tools/lane_kvm.sh" assert-on

CACHE="$REPO_ROOT/tools/.cache/proven-seat"
IMG="$CACHE/sculpt-26-04.img"
WORK="$CACHE/sculpt-g0c-lane-work.img"
LOG="$CACHE/g0c-lane-serial.log"
PNG="$CACHE/g0c-lane-screendump.png"
QMP="$CACHE/g0c-lane-qmp.sock"
META="$CACHE/g0c-lane-meta.txt"
EXPECTED="241b916ab9e3ed25a089c27119aac98f80fe4d3e67101936b4e69d7f1c708f14"

mkdir -p "$CACHE"
: >"$META"
date -Is | tee -a "$META"

progress() {
  echo "progress: $*" | tee -a "$META"
  echo "progress: $*" > /dev/tty 2>/dev/null || true
}

# Portable: Rishi often runs with PATH=/usr/bin:/bin (no cargo rg).
serial_has_grub() {
  grep -aFq 'GRUB loading' "$LOG" 2>/dev/null
}

if [ ! -f "$IMG" ]; then
  echo "RED: missing $IMG" | tee -a "$META" >&2
  exit 1
fi
hash="$(sha256sum "$IMG" | cut -d' ' -f1)"
if [ "$hash" != "$EXPECTED" ]; then
  echo "RED: sha256 mismatch want $EXPECTED got $hash" | tee -a "$META" >&2
  exit 1
fi

# ── Phase A: serial floor (nographic; -nic none; early kill on GRUB) ────────
progress "phase A: serial floor — nographic, nic none (poll up to 90s)…"
cp -f "$IMG" "$WORK"
rm -f "$LOG"
: >"$LOG"

qemu-system-x86_64 \
  -accel kvm -cpu host -machine q35 -m 4G \
  -drive "format=raw,file=${WORK}" \
  -nic none \
  -boot order=c \
  -nographic \
  >"$LOG" 2>&1 &
QPID=$!

cleanup_a() {
  if kill -0 "$QPID" 2>/dev/null; then
    kill "$QPID" 2>/dev/null || true
    wait "$QPID" 2>/dev/null || true
  fi
}
trap cleanup_a EXIT

grub=0
for i in $(seq 1 90); do
  if serial_has_grub; then
    progress "phase A: GRUB loading seen after ${i}s"
    grub=1
    break
  fi
  if [ $((i % 5)) -eq 0 ]; then
    bytes="$(wc -c <"$LOG" | tr -d ' \n')"
    progress "phase A: waiting… ${i}/90s serial_bytes=${bytes}"
  fi
  sleep 1
done

cleanup_a
trap - EXIT

serial_bytes="$(wc -c <"$LOG" | tr -d ' \n')"
progress "phase A: serial bytes=${serial_bytes}"
if [ "$grub" -ne 1 ] || ! serial_has_grub; then
  echo "RED: serial missing GRUB loading — see $LOG" | tee -a "$META" >&2
  progress "phase A: serial head:"
  head -20 "$LOG" | tee -a "$META" > /dev/tty 2>/dev/null || head -20 "$LOG" | tee -a "$META"
  exit 1
fi
echo "serial_floor=GRUB" | tee -a "$META"
progress "phase A: GRUB loading GREEN"

# ── Phase B: glass (display none + QMP screendump; -nic none) ──────────────
progress "phase B: glass — display none + QMP screendump…"
cp -f "$IMG" "$WORK"
rm -f "$PNG" "$QMP"

qemu-system-x86_64 \
  -accel kvm -cpu host -machine q35 -m 4G \
  -drive "format=raw,file=${WORK}" \
  -nic none \
  -boot order=c \
  -display none \
  -qmp "unix:${QMP},server,nowait" \
  >>"$META" 2>&1 &
QPID=$!

cleanup_b() {
  if kill -0 "$QPID" 2>/dev/null; then
    kill "$QPID" 2>/dev/null || true
    wait "$QPID" 2>/dev/null || true
  fi
}
trap cleanup_b EXIT

progress "phase B: qemu_pid=$QPID — waiting for QMP (up to 60s)…"
ready=0
for i in $(seq 1 60); do
  if [ -S "$QMP" ]; then
    progress "phase B: QMP ready after ${i}s"
    ready=1
    break
  fi
  if [ $((i % 5)) -eq 0 ]; then
    progress "phase B: still waiting for QMP… ${i}/60s"
  fi
  sleep 1
done
if [ "$ready" -ne 1 ]; then
  echo "RED: QMP socket never appeared" | tee -a "$META" >&2
  exit 1
fi

progress "phase B: brief settle before screendump (8s)…"
sleep 8
progress "phase B: taking QMP screendump…"
python3 - "$QMP" "$PNG" <<'PY'
import json, socket, sys, time

qmp_path, png_path = sys.argv[1], sys.argv[2]
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.settimeout(30)
sock.connect(qmp_path)

def recv_obj():
    buf = b""
    while True:
        chunk = sock.recv(4096)
        if not chunk:
            raise RuntimeError("QMP closed")
        buf += chunk
        if b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            return json.loads(line.decode())

def send(obj):
    sock.sendall((json.dumps(obj) + "\n").encode())

recv_obj()
send({"execute": "qmp_capabilities"})
recv_obj()
send({"execute": "screendump", "arguments": {"filename": png_path}})
deadline = time.time() + 20
got = False
while time.time() < deadline:
    msg = recv_obj()
    if msg.get("return") is not None or "error" in msg:
        if "error" in msg:
            raise RuntimeError(msg["error"])
        got = True
        break
if not got:
    raise RuntimeError("screendump timed out")
sock.close()
print("screendump_ok", png_path)
PY

if [ ! -s "$PNG" ]; then
  echo "RED: empty or missing screendump $PNG" | tee -a "$META" >&2
  exit 1
fi
bytes="$(wc -c <"$PNG" | tr -d ' \n')"
echo "glass_bytes=$bytes" | tee -a "$META"
progress "phase B: glass ${bytes} bytes"
echo "GREEN: proven-seat G0-complete (lane_kvm) — GRUB serial (nographic) + QMP PNG ($bytes bytes); -nic none; display-none glass"
