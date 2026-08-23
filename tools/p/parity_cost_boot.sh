#!/bin/sh
# Chapter cost-log boot (S0). Avoids inline ${...} in .rish — Rishi interpolates those.
# Usage: sh tools/p/parity_cost_boot.sh <chapter>
# Env: PARITY_COST_RESET (default 1) · PARITY_COST_LOG (default tools/.cache/parity-cost/current.tsv)
set -eu
chapter=${1:?chapter name required}
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
log=${PARITY_COST_LOG:-$root/tools/.cache/parity-cost/current.tsv}
mkdir -p "$(dirname "$log")"
if [ "${PARITY_COST_RESET:-1}" = "1" ]; then
  : >"$log"
fi
printf '%s\n' "$chapter" >"$root/tools/.cache/parity-cost/chapter"
printf 'cost_boot_ok chapter=%s reset=%s log=%s\n' \
  "$chapter" "${PARITY_COST_RESET:-1}" "$log"
