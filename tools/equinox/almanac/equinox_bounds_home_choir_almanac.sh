#!/bin/sh
# Append Glow almanac seat 34 from bounds-home choir (e28) -- ch3 continues.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 34
print almanac seat 34 appended · chapter three 2/16
bump ## Chapter Three (1 of 16)|## Chapter Three (2 of 16)
entry ### 34. Build ceilings inherit the living bounds table; ten pairs match and metal stays GREEN.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_bounds_home_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/bounds_home_census_witness.rish` · scan `tools/fixtures/b/bounds_home_census.sh` · metal `mycelium/build_bounds.rye` · choir `equinox_bounds_home_choir_witness.rish`
entry Expected pairs_matched=10 · pairs_drift=0 · living_table_named · build_bounds GREEN, and verdict=missing_shape on an absent path. Metal answered GREEN. Chapter three continues; builds inherit, they do not invent.
DATA
