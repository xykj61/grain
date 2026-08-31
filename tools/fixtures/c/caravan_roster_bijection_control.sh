#!/bin/sh
# Prove the Caravan witness roster seam in both directions without singing the suite.
set -eu

scan=$(pwd)/tools/fixtures/c/caravan_roster_bijection_scan.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
mkdir -p "$pen/tools/ca"

run_scan() {
  CARAVAN_ROSTER_FILE="$pen/roster.rish" CARAVAN_TOOLS_DIR="$pen/tools" sh "$scan" 2>&1 || true
}

printf '# fixture witness\n' > "$pen/tools/ca/caravan_alpha_witness.rish"
printf '%s\n' 'let witnesses = [ "tools/ca/caravan_alpha_witness.rish" ]' > "$pen/roster.rish"
out=$(run_scan)
case "$out" in *"ROSTER_OK disk=1 registered=1"*) echo "honest_free=yes" ;; *) echo "honest_free=no"; exit 1 ;; esac

printf '# fixture witness\n' > "$pen/tools/ca/caravan_beta_witness.rish"
out=$(run_scan)
case "$out" in *"ROSTER_FAIL reason=unheard names=caravan_beta_witness"*) echo "unheard_bitten=yes" ;; *) echo "unheard_bitten=no"; exit 1 ;; esac

rm "$pen/tools/ca/caravan_beta_witness.rish"
printf '%s\n' 'let witnesses = [ "tools/ca/caravan_alpha_witness.rish" "tools/ca/caravan_ghost_witness.rish" ]' > "$pen/roster.rish"
out=$(run_scan)
case "$out" in *"ROSTER_FAIL reason=phantom names=caravan_ghost_witness"*) echo "phantom_bitten=yes" ;; *) echo "phantom_bitten=no"; exit 1 ;; esac

echo "control_verdict=ok cases=3"
