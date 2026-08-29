#!/bin/sh
# Append Glow almanac seat 76 from IronBeetle ep014 census (e71).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 76
print almanac seat 76 appended · chapter five 12/16
bump ## Chapter Five (11 of 16)|## Chapter Five (12 of 16)
entry ### 76. IronBeetle ep014 trusts the primary's view and verifies every other header claim.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep014_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep014_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep014_census.sh` · choir `equinox_ironbeetle_ep014_choir_witness.rish`
entry Expected IRON=present · EP014 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
