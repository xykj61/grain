#!/bin/sh
# tools/fixtures/fact_fold_census.sh -- design-shapes fact_fold - metal + pattern + bounds.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
set -eu
shape="${1:-context/design-shapes/fact_fold.brix}"
[ -f "$shape" ] || { echo "verdict=missing_shape"; exit 2; }

metal=$(awk '$1=="field" && $2=="metal" { print $3; exit }' "$shape")
pattern=$(awk '$1=="field" && $2=="pattern" { print $3; exit }' "$shape")
[ -n "$metal" ] || { echo "verdict=metal_unnamed"; exit 1; }
[ -n "$pattern" ] || { echo "verdict=pattern_unnamed"; exit 1; }
echo "metal_path=$metal"
echo "pattern_path=$pattern"

[ -f "$metal" ] || { echo "verdict=missing_metal"; exit 2; }
[ -f "$pattern" ] || { echo "verdict=missing_pattern"; exit 2; }
echo "METAL_FILE=yes"
echo "PATTERN_FILE=yes"

brix_val() {
  awk -v k="$1" '$1=="field" && $2==k { print $3; exit }' "$shape"
}
rye_val() {
  # pub const <name>: u32 = NNN;
  sed -n "s/^pub const ${1}:.*= *\\([0-9][0-9]*\\);.*/\\1/p" "$metal" | head -1
}

match=0
drift=0
check_pair() {
  field="$1"
  rye_key="$2"
  bv=$(brix_val "$field")
  rv=$(rye_val "$rye_key")
  if [ -z "$bv" ] || [ -z "$rv" ]; then
    echo "detail: absent pair ${field}/${rye_key}"
    drift=$((drift + 1))
    return
  fi
  if [ "$bv" = "$rv" ]; then
    echo "detail: ok pair ${field}=${bv}"
    match=$((match + 1))
  else
    echo "detail: drift pair ${field} brix=${bv} rye=${rv}"
    drift=$((drift + 1))
  fi
}

check_pair fact_max_bytes myc_fact_max_bytes
check_pair star_name_max_bytes star_name_max_bytes
check_pair log_max_facts myc_log_max_facts

# Pattern page cites the metal and the design shape.
pattern_cites=no
if grep -q 'mycelium/fold.rye' "$pattern" && grep -q 'fact_fold.brix' "$pattern"; then
  pattern_cites=yes
fi
echo "PATTERN_CITES=$pattern_cites"
echo "pairs_matched=$match"
echo "pairs_drift=$drift"

if [ "$pattern_cites" = yes ] && [ "$drift" -eq 0 ] && [ "$match" -ge 3 ]; then
  echo "verdict=ok"
  exit 0
fi
if [ "$drift" -gt 0 ]; then
  echo "verdict=bound_drift"
  exit 1
fi
echo "verdict=census_incomplete"
exit 1
