#!/bin/sh
# Append Glow almanac seat 83 from IronBeetle ep025 census (e78).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 83
print almanac seat 83 appended · chapter six 3/16
bump ## Chapter Six (2 of 16)|## Chapter Six (3 of 16)
entry ### 83. IronBeetle ep025 stores the tree's map as a list of changes; persistence means add, never erase.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep025_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep025_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep025_census.sh` · choir `equinox_ironbeetle_ep025_choir_witness.rish`
entry Expected IRON=present · EP025 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
