#!/bin/sh
# Plant one absent hall in a bounded copy of the museum.
set -eu

pen=$(mktemp -d session-output/baton-museum.XXXXXX)
trap 'rm -rf "$pen"' EXIT

cp -R context/baton-museum/. "$pen/"
rm "$pen/cell.brix"

set +e
reading=$(sh tools/fixtures/b/baton_museum_census_scan.sh "$pen" 2>&1)
result=$?
set -e
printf '%s\n' "$reading"

[ "$result" -eq 1 ] || { echo 'control_verdict=wrong_status'; exit 1; }
printf '%s\n' "$reading" | grep -qx 'halls_absent=1' || { echo 'control_verdict=wrong_hall_count'; exit 1; }
printf '%s\n' "$reading" | grep -qx 'elder_miss=0' || { echo 'control_verdict=wrong_elder_count'; exit 1; }
printf '%s\n' "$reading" | grep -qx 'census_breach_count=1' || { echo 'control_verdict=wrong_breach_count'; exit 1; }
printf '%s\n' "$reading" | grep -qx 'verdict=census_incomplete' || { echo 'control_verdict=wrong_verdict'; exit 1; }
echo 'control_verdict=ok'
