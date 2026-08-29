#!/bin/sh
# Append Glow almanac seat 71 from IronBeetle ep009 census (e66).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 71
print almanac seat 71 appended · chapter five 7/16
bump ## Chapter Five (6 of 16)|## Chapter Five (7 of 16)
entry ### 71. IronBeetle ep009 hash-chains prepares so the ledger remembers its parent.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep009_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep009_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep009_census.sh` · choir `equinox_ironbeetle_ep009_choir_witness.rish`
entry Expected IRON=present · EP009 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
