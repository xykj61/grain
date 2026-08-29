#!/bin/sh
# Append Glow almanac seat 85 from IronBeetle ep030 census (e80).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 85
print almanac seat 85 appended · chapter six 5/16
bump ## Chapter Six (4 of 16)|## Chapter Six (5 of 16)
entry ### 85. IronBeetle ep030 asks which manifest-log entry owns a reused address; table_extent answers what an address alone cannot.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep030_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep030_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep030_census.sh` · choir `equinox_ironbeetle_ep030_choir_witness.rish`
entry Expected IRON=present · EP030 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
