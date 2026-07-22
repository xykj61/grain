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
# A successful GREEN close leaves the emulator running on purpose — a
# caller (tools/hawm1_sala_witness.rish, or an interactive `adb shell`
# session) needs it still attached a moment later. Stop it explicitly with
# tools/hawm0_stop.sh when actually done. Only a failure path tears the
# emulator back down automatically; this is a real fix, corrected
# `20260716.140207` after an earlier version's own exit-trap killed a
# just-proven-GREEN boot before anything downstream could ever attach —
# Keaton hit this exact bug live, two GREEN HAWM0 boots in a row followed
# immediately by HAWM1 reporting no emulator attached, seconds later.
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

# Pin the emulator serial. A GrapheneOS/Pixel phone on the same adb server
# (common on this Framework seat) makes bare `adb wait-for-device` and
# `adb shell` race the physical device — wait returns early, shell may hit
# "more than one device/emulator" under set -e, cleanup kills the just-launched
# AVD, and meta stops mid-wait with no RED timeout line. Live hit
# 20260722.153130 with Pixel 66041JEA306288 attached beside hawm0.
emulator_serial() {
  "$ADB" devices 2>/dev/null | awk '/^emulator-[0-9]+\t/ { print $1; exit }'
}

adb_emu() {
  # SERIAL must already be set by the caller.
  "$ADB" -s "$SERIAL" "$@"
}

report_identity_and_green() {
  progress "reading device identity as final proof of a real, booted userland (serial=$SERIAL)…"
  model="$(adb_emu shell getprop ro.product.model 2>/dev/null | tr -d '\r\n' || true)"
  release="$(adb_emu shell getprop ro.build.version.release 2>/dev/null | tr -d '\r\n' || true)"
  abi="$(adb_emu shell getprop ro.product.cpu.abi 2>/dev/null | tr -d '\r\n' || true)"
  kvm_check="$(adb_emu shell getprop ro.kernel.qemu 2>/dev/null | tr -d '\r\n' || true)"
  echo "device: model=$model android=$release abi=$abi qemu=$kvm_check serial=$SERIAL" | tee -a "$META"
  echo "GREEN: HAWM0 — stock AOSP/Android emulator booted, KVM-accelerated (model=$model android=$release abi=$abi serial=$SERIAL)"
}

# An already-running, already-booted hawm0 is exactly the intended end state
# after the exit-trap fix above (a successful boot deliberately stays up for
# a caller like tools/hawm1_sala_witness.rish) -- treating it as a failure
# here would make a second, ordinary call into this same script red for no
# real reason. Idempotent success: verify the existing *emulator* is genuinely
# booted (not merely a Pixel attached) before declaring GREEN and exiting
# early, never launching a second competing emulator process.
progress "checking for an emulator already running on this AVD…"
SERIAL="$(emulator_serial || true)"
if [ -n "${SERIAL:-}" ]; then
  progress "emulator already attached as $SERIAL — checking whether it is actually booted…"
  existing_boot="$(adb_emu shell getprop sys.boot_completed 2>/dev/null | tr -d '\r\n' || true)"
  if [ "$existing_boot" = "1" ]; then
    progress "already booted — treating as idempotent success, not launching a second emulator"
    report_identity_and_green
    exit 0
  fi
  echo "RED: emulator $SERIAL is attached but not fully booted (sys.boot_completed='$existing_boot') — close it first (tools/hawm0_stop.sh), then retry" | tee -a "$META" >&2
  exit 1
fi

progress "launching hawm0 (-accel kvm, headless, no audio; up to 180s to boot)…"
rm -f "$LOG"
"$EMULATOR" -avd hawm0 -accel on -no-window -no-audio -no-boot-anim \
  >"$LOG" 2>&1 &
EPID=$!
SERIAL=""

cleanup() {
  if kill -0 "$EPID" 2>/dev/null; then
    if [ -n "${SERIAL:-}" ]; then
      "$ADB" -s "$SERIAL" emu kill >/dev/null 2>&1 || kill "$EPID" 2>/dev/null || true
    else
      "$ADB" -s emulator-5554 emu kill >/dev/null 2>&1 || kill "$EPID" 2>/dev/null || true
    fi
    wait "$EPID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# Wait for an emulator-* serial specifically — never bare wait-for-device,
# which returns as soon as a USB phone is already listed.
progress "emulator pid=$EPID — waiting for emulator-* adb serial (up to 60s; Pixel may already be listed)…"
for i in $(seq 1 60); do
  SERIAL="$(emulator_serial || true)"
  if [ -n "${SERIAL:-}" ]; then
    progress "emulator adb serial attached: $SERIAL after ${i}s"
    break
  fi
  if [ $((i % 10)) -eq 0 ]; then
    progress "still waiting for emulator-* serial… ${i}/60s"
  fi
  sleep 1
done
if [ -z "${SERIAL:-}" ]; then
  echo "RED: adb never saw an emulator-* serial — see $LOG (a USB phone alone does not count)" | tee -a "$META" >&2
  exit 1
fi

progress "waiting for sys.boot_completed=1 on $SERIAL (up to 120s)…"
booted=0
for i in $(seq 1 120); do
  # Soften getprop: early shell can fail transiently; never set -e out of the poll.
  prop="$(adb_emu shell getprop sys.boot_completed 2>/dev/null | tr -d '\r\n' || true)"
  if [ "$prop" = "1" ]; then
    progress "boot_completed after ${i}s"
    booted=1
    break
  fi
  if [ $((i % 10)) -eq 0 ]; then
    progress "still booting… ${i}/120s (sys.boot_completed='${prop}')"
  fi
  sleep 1
done
if [ "$booted" -ne 1 ]; then
  echo "RED: sys.boot_completed never reached 1 within 120s on $SERIAL — see $LOG" | tee -a "$META" >&2
  exit 1
fi

# Disarm the cleanup trap before declaring success — a booted emulator this
# script just proved GREEN is exactly what a caller (HAWM1's own adb push,
# or an interactive session) needs to still be running a moment later. The
# trap stays live for every failure path above (a broken boot really should
# tear itself down); only a genuinely successful close leaves hawm0 up.
# Stop it later with: tools/hawm0_stop.sh
trap - EXIT
progress "emulator left running (pid=$EPID serial=$SERIAL) — stop later with tools/hawm0_stop.sh"

report_identity_and_green
