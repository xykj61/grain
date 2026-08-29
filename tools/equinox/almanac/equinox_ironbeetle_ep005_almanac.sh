#!/bin/sh
# Append Glow almanac seat 68 from IronBeetle ep005 census (e63).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 68
print almanac seat 68 appended · chapter five 4/16
bump ## Chapter Five (3 of 16)|## Chapter Five (4 of 16)
entry ### 68. IronBeetle ep005 limits everything; back-pressure arrives as consequence.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep005_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep005_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep005_census.sh` · choir `equinox_ironbeetle_ep005_choir_witness.rish`
entry Expected IRON=present · EP005 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
