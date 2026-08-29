#!/bin/sh
# wasmtime_preflight.sh -- print ABSENT seating when wasmtime is missing.
# Exit 0 always; presence is silent. Used by parity.rish / parity_ch02.rish.
set -eu
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"
if command -v wasmtime >/dev/null 2>&1; then
  exit 0
fi
if [ -x tools/.cache/wasmtime/wasmtime ]; then
  exit 0
fi
cat <<'EOF'
preflight ABSENT: wasmtime
  seat 1: wasmtime-cli on PATH
  seat 2: tools/.cache/wasmtime/wasmtime  (pin 31.0.0)
  restore: sh tools/b/bootstrap_wasmtime.sh
  effect:  receipt_verify_wasm reports ABSENT; suite is PARTIAL, never GREEN
EOF
exit 0
