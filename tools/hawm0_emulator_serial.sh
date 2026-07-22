#!/usr/bin/env bash
# hawm0_emulator_serial.sh — print the first emulator-* adb serial (no newline).
# Used by hawm1_sala_witness so Rish string escaping never mangles the extract.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ADB="${REPO_ROOT}/tools/.cache/hawm0/android-sdk/platform-tools/adb"
serial="$("$ADB" devices | awk '/^emulator-/ { print $1; exit }')"
if [ -z "$serial" ]; then
  exit 1
fi
printf '%s' "$serial"
