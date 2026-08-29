#!/bin/sh
# Append Glow almanac seat 95 from IronBeetle ep042 census (e90).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 95
print almanac seat 95 appended · chapter six 15/16
bump ## Chapter Six (14 of 16)|## Chapter Six (15 of 16)
entry ### 95. IronBeetle ep042 crosses the Alps into the merge loop itself; table_builder writes checksummed blocks from what the loop produces.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep042_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep042_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep042_census.sh` · choir `equinox_ironbeetle_ep042_choir_witness.rish`
entry Expected IRON=present · EP042 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
