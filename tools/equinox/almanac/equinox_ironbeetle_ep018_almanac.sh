#!/bin/sh
# Append Glow almanac seat 78 from IronBeetle ep018 census (e73).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 78
print almanac seat 78 appended · chapter five 14/16
bump ## Chapter Five (13 of 16)|## Chapter Five (14 of 16)
entry ### 78. IronBeetle ep018 replays the same bug byte for byte; two correct rules can still stall liveness.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep018_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep018_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep018_census.sh` · choir `equinox_ironbeetle_ep018_choir_witness.rish`
entry Expected IRON=present · EP018 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
