#!/bin/sh
# one_clock_mode_gate.sh — advisory always ok; blocking requires CEILING_CLEAN
set -eu
mode=$(grep -E '^(advisory|blocking)$' tools/fixtures/one_clock_mode.txt | head -1)
scan=$(sh tools/fixtures/one_clock_ceiling_scan.sh)
printf '%s\n' "$scan"
if test "$mode" = "advisory"; then
  echo GATE_ADVISORY
  exit 0
fi
if printf '%s\n' "$scan" | grep -q CEILING_CLEAN && ! printf '%s\n' "$scan" | grep -q CEILING_WARN; then
  echo GATE_BLOCK_OK
  exit 0
fi
echo GATE_BLOCK_FAIL
exit 1
