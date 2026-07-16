#!/usr/bin/env bash
# hawm0_stop.sh — stop a running hawm0 emulator cleanly.
#
# A successful tools/hawm0_boot_worker.sh run (via tools/hawm0_boot_onpath_host.rish)
# leaves the emulator running on purpose, since a caller like
# tools/hawm1_sala_witness.rish needs it attached a moment later. This is the
# explicit teardown for when you are actually done with it — run from the
# same plain host terminal, outside any jail.
#
#   ./tools/hawm0_stop.sh
#
# adb emu kill is the clean shutdown path (graceful VM poweroff signal); a
# bare `kill` on the process is the fallback only if adb itself can't reach it.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

ADB="$REPO_ROOT/tools/.cache/hawm0/android-sdk/platform-tools/adb"

if [ ! -x "$ADB" ]; then
  echo "RED: adb not found at $ADB — setup did not complete" >&2
  exit 1
fi

if ! "$ADB" devices | grep -q "emulator-"; then
  echo "OK: no emulator currently attached — nothing to stop"
  exit 0
fi

echo "stopping hawm0…"
if "$ADB" -s emulator-5554 emu kill 2>&1; then
  echo "GREEN: hawm0 stopped cleanly"
else
  echo "adb emu kill failed — falling back to a direct process kill" >&2
  pkill -f "avd hawm0" 2>/dev/null || true
  echo "GREEN: hawm0 stopped (fallback path)"
fi
