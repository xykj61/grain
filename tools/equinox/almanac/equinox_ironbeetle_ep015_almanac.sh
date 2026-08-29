#!/bin/sh
# Append Glow almanac seat 77 from IronBeetle ep015 census (e72).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 77
print almanac seat 77 appended · chapter five 13/16
bump ## Chapter Five (12 of 16)|## Chapter Five (13 of 16)
entry ### 77. IronBeetle ep015 proves a negative with nacks; a stuck view change stays honestly stuck.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep015_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep015_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep015_census.sh` · choir `equinox_ironbeetle_ep015_choir_witness.rish`
entry Expected IRON=present · EP015 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
