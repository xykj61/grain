#!/bin/sh
# tools/fixtures/design_shapes_census_scan.sh -- four design halls present; elders named.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
set -eu
root="${1:-context/design-shapes}"
[ -d "$root" ] || { echo "verdict=missing_wing"; exit 2; }
[ -f "$root/README.md" ] || { echo "verdict=missing_charter"; exit 2; }

need="bounds_home.brix tend_hygiene.brix relay_resin.brix fact_fold.brix"
absent=0
for f in $need; do
  if [ -f "$root/$f" ]; then
    echo "detail: ok hall $f"
  else
    echo "detail: absent hall $f"
    absent=$((absent + 1))
  fi
done

# Elders the wing names -- first and second outside consumers.
elder_miss=0
if [ -f tools/gen/season/recursion_block.brix ]; then
  echo "detail: ok elder bounds_home_consumer"
else
  echo "detail: absent elder bounds_home_consumer"
  elder_miss=$((elder_miss + 1))
fi
if [ -f context/baton-museum/tend_round.brix ]; then
  echo "detail: ok elder tend_round_consumer"
else
  echo "detail: absent elder tend_round_consumer"
  elder_miss=$((elder_miss + 1))
fi

halls=4
echo "halls_expected=$halls"
echo "halls_absent=$absent"
echo "elder_miss=$elder_miss"
breach_count=$((absent + elder_miss))
echo "census_breach_count=$breach_count"

if [ "$absent" -eq 0 ] && [ "$elder_miss" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=census_incomplete"
exit 1
