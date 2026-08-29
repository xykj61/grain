#!/bin/sh
# Append Glow almanac seat 86 from IronBeetle ep031½ census (e81).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 86
print almanac seat 86 appended · chapter six 6/16
bump ## Chapter Six (5 of 16)|## Chapter Six (6 of 16)
entry ### 86. IronBeetle ep031½ keeps a durable fact in one coherent form; journal and checkpoint must truly copy the same thing.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep031_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep031_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep031_census.sh` · choir `equinox_ironbeetle_ep031_choir_witness.rish`
entry Expected IRON=present · EP031 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
