#!/bin/sh
# Append Glow almanac seat 79 from IronBeetle ep019 census (e74).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 79
print almanac seat 79 appended · chapter five 15/16
bump ## Chapter Five (14 of 16)|## Chapter Five (15 of 16)
entry ### 79. IronBeetle ep019 reduces storage to a sorted array; tables are index plus value blocks.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep019_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep019_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep019_census.sh` · choir `equinox_ironbeetle_ep019_choir_witness.rish`
entry Expected IRON=present · EP019 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
