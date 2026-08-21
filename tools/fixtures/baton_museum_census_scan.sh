#!/bin/sh
# tools/fixtures/baton_museum_census_scan.sh — thirteen halls present; elders named.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
set -eu
root="${1:-context/baton-museum}"
[ -d "$root" ] || { echo "verdict=missing_museum"; exit 2; }
[ -f "$root/README.md" ] || { echo "verdict=missing_charter"; exit 2; }

need="counsel_close.brix agent_cover.brix recursion_prompt.brix tiered_handoff.brix cursor_relay.brix infusion_prompt.brix bench_apply_report.brix waymark.brix handback.brix season_summary.brix queue_packet.brix tend_round.brix cell.brix"
absent=0
for f in $need; do
  if [ -f "$root/$f" ]; then
    echo "detail: ok hall $f"
  else
    echo "detail: absent hall $f"
    absent=$((absent + 1))
  fi
done

# Exact elders the museum itself names — confirm present before claiming the seat.
elder_miss=0
if [ -f expanding-prompts/date/20260730/20260730-021541_build-journey-agent-cover.md ]; then
  echo "detail: ok elder agent_cover"
else
  echo "detail: absent elder agent_cover"
  elder_miss=$((elder_miss + 1))
fi
if [ -f external-research/20260703-013412_writing-recursion-prompts.md ]; then
  echo "detail: ok elder recursion_craft"
else
  echo "detail: absent elder recursion_craft"
  elder_miss=$((elder_miss + 1))
fi

halls=13
echo "halls_expected=$halls"
echo "halls_absent=$absent"
echo "elder_miss=$elder_miss"
# Census breach count: missing halls or named elders. Zero means breach stays banked.
breach_count=$((absent + elder_miss))
echo "census_breach_count=$breach_count"

if [ "$absent" -eq 0 ] && [ "$elder_miss" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=census_incomplete"
exit 1
