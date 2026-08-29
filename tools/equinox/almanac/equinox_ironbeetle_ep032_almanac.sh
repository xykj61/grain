#!/bin/sh
# Append Glow almanac seat 87 from IronBeetle ep032 census (e82).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 87
print almanac seat 87 appended · chapter six 7/16
bump ## Chapter Six (6 of 16)|## Chapter Six (7 of 16)
entry ### 87. IronBeetle ep032 orders engineering values: safety first, then performance, then experience — programming integrated over time.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep032_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep032_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep032_census.sh` · choir `equinox_ironbeetle_ep032_choir_witness.rish`
entry Expected IRON=present · EP032 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
