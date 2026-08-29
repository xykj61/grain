#!/bin/sh
# Append Glow almanac seat 75 from IronBeetle ep013 census (e70).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 75
print almanac seat 75 appended · chapter five 11/16
bump ## Chapter Five (10 of 16)|## Chapter Five (11 of 16)
entry ### 75. IronBeetle ep013 holds Op · commit_min · commit_max apart; repair reads the break in the chain.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep013_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep013_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep013_census.sh` · choir `equinox_ironbeetle_ep013_choir_witness.rish`
entry Expected IRON=present · EP013 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
