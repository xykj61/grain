#!/usr/bin/env bash
# tools/active_designing_cycle_pick.sh — select-only picker for active-designing.
# Args: optional u64/decimal seed or hex tip digits.
# Never shreds.
set -euo pipefail
N=$(find active-designing -type f ! -path '*/quin-workshop/*' ! -path '*/.git/*' 2>/dev/null | wc -l | tr -d ' ')
test "$N" -gt 0
S="${1-}"
if [ -z "$S" ]; then
  S=$(git rev-parse --short=10 HEAD | tr -cd '0-9a-fA-F')
fi
if [[ "$S" =~ ^[0-9]+$ ]]; then
  SEED_NUM=$S
else
  SEED_NUM=$((16#$S))
fi
IDX=$((SEED_NUM % N))
PATH_P=$(find active-designing -type f ! -path '*/quin-workshop/*' ! -path '*/.git/*' 2>/dev/null | sort | sed -n "$((IDX + 1))p")
test -n "$PATH_P"
printf 'ad-cycle: count %s\n' "$N"
printf 'ad-cycle: seed %s\n' "$S"
printf 'ad-cycle: index %s\n' "$IDX"
printf 'ad-cycle: path %s\n' "$PATH_P"
