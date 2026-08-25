#!/bin/sh
# wasmtime_preflight.sh -- print ABSENT seating when wasmtime is missing.
# Exit 0 always; presence is silent. Used by parity.rish / parity_ch02.rish.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
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
