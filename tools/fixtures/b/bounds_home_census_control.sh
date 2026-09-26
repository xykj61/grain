#!/bin/sh
# Plant one numeric drift without changing the living bound table.
set -eu

pen=$(mktemp session-output/bounds-home.XXXXXX)
trap 'rm -f "$pen"' EXIT

# The first field is the bound name; increment only this one value.
awk '$1 == "discovery_max_peers" { $2 += 1 } { print }' \
  tools/gen/chapter/recursion_block.brix > "$pen"

set +e
reading=$(sh tools/fixtures/b/bounds_home_census.sh \
  context/design-shapes/bounds_home.brix "$pen" mycelium/build_bounds.rye 2>&1)
result=$?
set -e
printf '%s\n' "$reading"

[ "$result" -eq 1 ] || { echo 'control_verdict=wrong_status'; exit 1; }
printf '%s\n' "$reading" | grep -qx 'pairs_matched=9' || { echo 'control_verdict=wrong_match_count'; exit 1; }
printf '%s\n' "$reading" | grep -qx 'pairs_drift=1' || { echo 'control_verdict=wrong_drift_count'; exit 1; }
printf '%s\n' "$reading" | grep -qx 'verdict=bound_drift' || { echo 'control_verdict=wrong_verdict'; exit 1; }
echo 'control_verdict=ok'
