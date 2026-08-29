#!/bin/sh
# Append Glow almanac seat 66 from IronBeetle ep002 census (e61).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 66
print almanac seat 66 appended · chapter five 2/16
bump ## Chapter Five (1 of 16)|## Chapter Five (2 of 16)
entry ### 66. IronBeetle ep002 keeps two columns; money cannot silently appear.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep002_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep002_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep002_census.sh` · choir `equinox_ironbeetle_ep002_choir_witness.rish`
entry Expected IRON=present · EP002 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
