#!/bin/sh
# Append Glow almanac seat 84 from IronBeetle ep028 census (e79).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 84
print almanac seat 84 appended · chapter six 4/16
bump ## Chapter Six (3 of 16)|## Chapter Six (4 of 16)
entry ### 84. IronBeetle ep028 stages a freed block until the next checkpoint; reserve then acquire keeps addresses deterministic.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep028_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep028_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep028_census.sh` · choir `equinox_ironbeetle_ep028_choir_witness.rish`
entry Expected IRON=present · EP028 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
