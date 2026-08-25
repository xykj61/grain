#!/bin/sh
# Instrument-season suite -- run every meter the arc identified.
# Exit 0 only when every limb passes. Presence via git ls-files.
# No backtick characters in patterns.
#
#   sh tools/fixtures/instrument_suite_scan.sh           # living green
#   sh tools/fixtures/instrument_suite_scan.sh prove-red  # must exit 1
#
# Law: a record that cannot be found by the census that will look for it
#      is not yet a record. Manufacturing more meters is refused; seating
#      the suite finds the completion.
# Counsel named nine at e113; Framework accreted thing-not-name as tenth (e114).
set -eu

MODE=${1:-}
RISHI=rishi/bin/rishi
pass=0
fail=0

run_sh() {
  name=$1
  path=$2
  needle=$3
  git ls-files --error-unmatch "$path" >/dev/null 2>&1 || {
    echo "limb_${name}=ABSENT"
    echo "detail=on_disk_is_not_in_the_tree_or_missing"
    echo "detail_path=$path"
    fail=$((fail + 1))
    return 0
  }
  out=$(sh "$path" 2>&1) || {
    echo "limb_${name}=RED"
    echo "detail=exit_nonzero"
    fail=$((fail + 1))
    return 0
  }
  if printf '%s\n' "$out" | rg -q "$needle"; then
    echo "limb_${name}=GREEN"
    pass=$((pass + 1))
  else
    echo "limb_${name}=RED"
    echo "detail=want_needle"
    echo "detail_needle=$needle"
    fail=$((fail + 1))
  fi
}

run_rishi() {
  name=$1
  path=$2
  needle=$3
  git ls-files --error-unmatch "$path" >/dev/null 2>&1 || {
    echo "limb_${name}=ABSENT"
    echo "detail=on_disk_is_not_in_the_tree_or_missing"
    echo "detail_path=$path"
    fail=$((fail + 1))
    return 0
  }
  out=$("$RISHI" run "$path" 2>&1) || {
    echo "limb_${name}=RED"
    echo "detail=exit_nonzero"
    fail=$((fail + 1))
    return 0
  }
  if printf '%s\n' "$out" | rg -q "$needle"; then
    echo "limb_${name}=GREEN"
    pass=$((pass + 1))
  else
    echo "limb_${name}=RED"
    echo "detail=want_needle"
    echo "detail_needle=$needle"
    fail=$((fail + 1))
  fi
}

# prove-red: invent a pass count while a limb is forced absent from the tally
if test "$MODE" = "prove-red"; then
  echo "limb_sundial=GREEN"
  echo "search_mode=claim_without_running"
  echo "pass=10"
  echo "fail=0"
  echo "verdict=misread"
  echo "detail=RED_manufactured_suite_pass"
  echo "detail=suite_claimed_without_running_limbs"
  echo "census=withheld"
  exit 1
fi

run_sh sundial tools/fixtures/sundial.sh '^band=green$'
run_sh fascia_metric tools/fixtures/fascia_metric_v0.sh '^GREEN: fascia-metric-v0'
run_rishi census_control tools/gen/season/census_control_witness.rish 'GREEN: census-control'
run_rishi shed_census tools/gen/season/shed_census_witness.rish 'GREEN: shed-census'
run_rishi e111_dialect tools/gen/season/equinox_e111_date_dialect_witness.rish 'GREEN: e111-date-dialect'
run_rishi oldness tools/gen/season/oldness_census_witness.rish 'GREEN: oldness-census'
run_rishi h1_fence tools/gen/season/radiant_h1_fence_witness.rish 'GREEN: radiant-h1-fence'
run_sh radiant_lint tools/fixtures/radiant_lint_scan.sh 'planted bare-but counted'
run_sh e113_fascia_health tools/fixtures/equinox_e113_fascia_health_scan.sh '^e113_fascia_health=ok$'
run_rishi thing_not_name tools/gen/season/thing_not_name_witness.rish 'GREEN: thing-not-name'

echo "pass=${pass}"
echo "fail=${fail}"
echo "limbs_expected=10"
echo "counsel_named=9"
echo "accreted_e114_thing_not_name=1"
echo "shred=RED"
echo "law=seat_the_suite_do_not_manufacture_meters"

if test "$fail" -ne 0 || test "$pass" -ne 10; then
  echo "instrument_suite=failed"
  echo "verdict=misread"
  exit 1
fi

echo "instrument_suite=ok"
echo "suite=pass=10 fail=0"
echo "verdict=ok"
exit 0
