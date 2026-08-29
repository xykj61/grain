#!/bin/sh
# Append Glow almanac seat 80 from IronBeetle ep020 census (e75) -- ch5 FULL.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 80
print almanac seat 80 appended · chapter five 16/16 FULL
bump ## Chapter Five (15 of 16)|## Chapter Five (16 of 16)
entry ### 80. IronBeetle ep020 shadows rather than overwrites; LSM levels and the Manifest keep the stack searchable.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep020_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep020_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep020_census.sh` · choir `equinox_ironbeetle_ep020_choir_witness.rish`
entry Expected IRON=present · EP020 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only. Chapter five fills at sixteen.
DATA
