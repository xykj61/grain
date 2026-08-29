#!/bin/sh
# Append Glow almanac seat 67 from IronBeetle ep004 census (e62).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 67
print almanac seat 67 appended · chapter five 3/16
bump ## Chapter Five (2 of 16)|## Chapter Five (3 of 16)
entry ### 67. IronBeetle ep004 refuses to shard the ledger; one serial core, pipelined rest.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep004_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep004_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep004_census.sh` · choir `equinox_ironbeetle_ep004_choir_witness.rish`
entry Expected IRON=present · EP004 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Ep003 gap stays open. Clean-room study only.
DATA
