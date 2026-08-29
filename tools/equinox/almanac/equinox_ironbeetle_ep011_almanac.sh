#!/bin/sh
# Append Glow almanac seat 73 from IronBeetle ep011 census (e68).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 73
print almanac seat 73 appended · chapter five 9/16
bump ## Chapter Five (8 of 16)|## Chapter Five (9 of 16)
entry ### 73. IronBeetle ep011 walks five layers to the kernel; checksum never trusts the read alone.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep011_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep011_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep011_census.sh` · choir `equinox_ironbeetle_ep011_choir_witness.rish`
entry Expected IRON=present · EP011 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
