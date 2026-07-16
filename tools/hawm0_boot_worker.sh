#!/usr/bin/env bash
# hawm0_boot_worker.sh — HAWM0's actual boot worker: backgrounds the emulator,
# polls adb + sys.boot_completed, reads back device identity. Bash, not Rish,
# on purpose: Rish's own `run` is blocking-only (manual/reference/rishi-language.md
# §4) — no `&`, no `trap`, no `wait`, no sleep-and-poll loop. This mirrors
# tools/proven_seat_g0c_lane_kvm.sh's own relationship to
# tools/lane_kvm_onpath_host.rish exactly: the .rish file is the host-facing
# entrypoint and precondition-checker; this .sh file is the one seam that
# actually manages a long-lived background process.
#
# Not run directly — call tools/hawm0_boot_onpath_host.rish instead:
#   rishi/bin/rishi run tools/hawm0_boot_onpath_host.rish
#
# (context/specs/two-dev-environments-and-mobile-emulation.md · waymark fix
# context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md)
#
# Run OUTSIDE ai-jail, from a plain host terminal that already has /dev/kvm.
# HAWM0 never touches the ai-jail wall or tools/lane_kvm.sh at all: this
# emulator never runs inside the jail in the first place (no /dev/kvm, no
# sdkmanager/emulator binaries reachable there), so there is nothing to widen
# and nothing to gate — it is simply a host action, same as any other program
# you run on this machine outside Cursor's jailed session.
#
# Setup already done, from inside the jail (network-only work, no /dev/kvm
# needed): a portable Temurin 21 JDK and the Android command-line tools were
# fetched and sha-verified into tools/.cache/hawm0/ (gitignored), licenses
# accepted, platform-tools + emulator + a stock Android 16 (API 36) Google
# APIs x86_64 system image installed, and one AVD named "hawm0" created with
# a Pixel-10-Pro-XL-shaped hardware profile (1344x2992 @560dpi, 4G RAM) — the
# flagship device this fork's own go-to-market brief names first
# (active-designing/20260715-194500_the-slc-product-glow-on-capable-hardware.md).
# tools/.cache/hawm0/ lives on this host's real, persistent ~/urbit partition
# (not the jail's tmpfs $HOME), so every file already staged there is reachable
# unchanged from this plain terminal too.
#
# This is the honest register named in the living spec: HAWM0 boots real
# stock AOSP/Android with KVM acceleration, the same userland surface
# GrapheneOS presents to an app. It never claims to be GrapheneOS itself —
# HAWM2 (a real GrapheneOS build) is the only rung that actually exercises
# GrapheneOS's own hardening, and needs the full GrapheneOS/AOSP source tree,
# not this stock SDK image.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

CACHE="$REPO_ROOT/tools/.cache/hawm0"
export JAVA_HOME="$CACHE/jdk"
export ANDROID_SDK_ROOT="$CACHE/android-sdk"
export ANDROID_AVD_HOME="$CACHE/avd-home"
export PATH="$JAVA_HOME/bin:$PATH"

META="$CACHE/hawm0-boot-meta.txt"
LOG="$CACHE/hawm0-emulator.log"
mkdir -p "$CACHE"
: >"$META"
date -Is | tee -a "$META"

progress() {
  echo "progress: $*" | tee -a "$META"
}

if [ ! -e /dev/kvm ]; then
  echo "REFUSE: /dev/kvm absent — this script is host-only; run from a plain terminal outside any jail." | tee -a "$META" >&2
  exit 1
fi
progress "/dev/kvm present"

EMULATOR="$ANDROID_SDK_ROOT/emulator/emulator"
if [ ! -x "$EMULATOR" ]; then
  echo "RED: emulator binary missing at $EMULATOR — setup did not complete (see tools/.cache/hawm0/)" | tee -a "$META" >&2
  exit 1
fi
if [ ! -f "$ANDROID_AVD_HOME/hawm0.ini" ]; then
  echo "RED: AVD 'hawm0' not found under $ANDROID_AVD_HOME — setup did not complete" | tee -a "$META" >&2
  exit 1
fi
progress "emulator + AVD present"

ADB="$ANDROID_SDK_ROOT/platform-tools/adb"

progress "checking for a stray emulator already running on this AVD…"
"$ADB" devices | grep -q "emulator-" && {
  echo "RED: an emulator is already attached — close it first (adb devices to see which)" | tee -a "$META" >&2
  exit 1
} || true

progress "launching hawm0 (-accel kvm, headless, no audio; up to 180s to boot)…"
rm -f "$LOG"
"$EMULATOR" -avd hawm0 -accel on -no-window -no-audio -no-boot-anim \
  >"$LOG" 2>&1 &
EPID=$!

cleanup() {
  if kill -0 "$EPID" 2>/dev/null; then
    "$ADB" -s emulator-5554 emu kill >/dev/null 2>&1 || kill "$EPID" 2>/dev/null || true
    wait "$EPID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

progress "emulator pid=$EPID — waiting for adb device (up to 60s)…"
"$ADB" wait-for-device &
WAITPID=$!
for i in $(seq 1 60); do
  if ! kill -0 "$WAITPID" 2>/dev/null; then
    break
  fi
  if [ $((i % 10)) -eq 0 ]; then
    progress "still waiting for adb device… ${i}/60s"
  fi
  sleep 1
done
wait "$WAITPID" 2>/dev/null || {
  echo "RED: adb never saw the device — see $LOG" | tee -a "$META" >&2
  exit 1
}
progress "adb device attached"

progress "waiting for sys.boot_completed=1 (up to 120s)…"
booted=0
for i in $(seq 1 120); do
  prop="$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r\n')"
  if [ "$prop" = "1" ]; then
    progress "boot_completed after ${i}s"
    booted=1
    break
  fi
  if [ $((i % 10)) -eq 0 ]; then
    progress "still booting… ${i}/120s"
  fi
  sleep 1
done
if [ "$booted" -ne 1 ]; then
  echo "RED: sys.boot_completed never reached 1 within 120s — see $LOG" | tee -a "$META" >&2
  exit 1
fi

progress "reading device identity as final proof of a real, booted userland…"
model="$("$ADB" shell getprop ro.product.model 2>/dev/null | tr -d '\r\n')"
release="$("$ADB" shell getprop ro.build.version.release 2>/dev/null | tr -d '\r\n')"
abi="$("$ADB" shell getprop ro.product.cpu.abi 2>/dev/null | tr -d '\r\n')"
kvm_check="$("$ADB" shell getprop ro.kernel.qemu 2>/dev/null | tr -d '\r\n')"
echo "device: model=$model android=$release abi=$abi qemu=$kvm_check" | tee -a "$META"

echo "GREEN: HAWM0 — stock AOSP/Android emulator booted, KVM-accelerated (model=$model android=$release abi=$abi)"
