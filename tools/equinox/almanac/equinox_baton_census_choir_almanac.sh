#!/bin/sh
# Append Glow almanac seat 31 from baton census choir (e25).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 31
print almanac seat 31 appended
bump ## Chapter Two (14 of 16)|## Chapter Two (15 of 16)
entry ### 31. The baton museum holds thirteen halls; a missing museum path is refused whole.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_baton_census_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/baton_museum_census_witness.rish` · scan `tools/fixtures/b/baton_museum_census_scan.sh` · choir `equinox_baton_census_choir_witness.rish`
entry Expected halls_expected=13 · halls_absent=0 · census_breach_count=0, and verdict=missing_museum on an absent path. Metal answered GREEN. Museum-hall census named; breach census stays zero and banked.
DATA
