#!/bin/sh
# Append Glow almanac seat 72 from IronBeetle ep010 census (e67).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 72
print almanac seat 72 appended · chapter five 8/16
bump ## Chapter Five (7 of 16)|## Chapter Five (8 of 16)
entry ### 72. IronBeetle ep010 lets the disk lie; repair asks by checksum and verifies the answer.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep010_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep010_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep010_census.sh` · choir `equinox_ironbeetle_ep010_choir_witness.rish`
entry Expected IRON=present · EP010 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
