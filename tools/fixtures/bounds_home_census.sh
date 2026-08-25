#!/bin/sh
# tools/fixtures/bounds_home_census.sh -- design-shapes bounds inherit the living table.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
# Compares seated literals in mycelium/build_bounds.rye to recursion_block.brix.
set -eu
shape="${1:-context/design-shapes/bounds_home.brix}"
table="${2:-tools/gen/season/recursion_block.brix}"
metal="${3:-mycelium/build_bounds.rye}"

[ -f "$shape" ] || { echo "verdict=missing_shape"; exit 2; }
[ -f "$table" ] || { echo "verdict=missing_table"; exit 2; }
[ -f "$metal" ] || { echo "verdict=missing_metal"; exit 2; }

# README names the living table -- wing charter, not invented here.
if grep -q 'recursion_block.brix' context/design-shapes/README.md 2>/dev/null; then
  echo "detail: ok living_table_named"
  named=1
else
  echo "detail: absent living_table_named"
  named=0
fi

brix_val() {
  # First bare key line wins (coords_* variants sit earlier; table keys are bare).
  awk -v k="$1" '$1==k { print $2; exit }' "$table"
}

rye_val() {
  # seated_<name>: uNN = NNN;
  sed -n "s/^const seated_${1}:.*= *\\([0-9][0-9]*\\);.*/\\1/p" "$metal" | head -1
}

match=0
drift=0
check_pair() {
  brix_key="$1"
  rye_key="$2"
  bv=$(brix_val "$brix_key")
  rv=$(rye_val "$rye_key")
  if [ -z "$bv" ] || [ -z "$rv" ]; then
    echo "detail: absent pair ${brix_key}/${rye_key} brix=${bv:-none} rye=${rv:-none}"
    drift=$((drift + 1))
    return
  fi
  if [ "$bv" = "$rv" ]; then
    echo "detail: ok pair ${brix_key}=${bv}"
    match=$((match + 1))
  else
    echo "detail: drift pair ${brix_key} brix=${bv} rye=${rv}"
    drift=$((drift + 1))
  fi
}

check_pair discovery_descriptor_max_bytes descriptor_max
check_pair discovery_max_peers max_peers
check_pair discovery_staleness_max_seconds staleness
check_pair discovery_gossip_fanout fanout
check_pair discovery_introduce_hops_max hops
check_pair myc_fact_max_bytes fact_max
check_pair star_name_max_bytes star_name
check_pair ship_sol_proof_max_bytes ship_sol
check_pair myc_fold_snapshot_max_bytes fold_snapshot
check_pair refusal_storm_min_cases refusal_storm_min

echo "pairs_matched=$match"
echo "pairs_drift=$drift"
echo "living_table_named=$named"

if [ "$named" -eq 1 ] && [ "$drift" -eq 0 ] && [ "$match" -ge 10 ]; then
  echo "verdict=ok"
  exit 0
fi
if [ "$drift" -gt 0 ]; then
  echo "verdict=bound_drift"
  exit 1
fi
echo "verdict=census_incomplete"
exit 1
