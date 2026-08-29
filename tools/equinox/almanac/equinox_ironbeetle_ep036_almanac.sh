#!/bin/sh
# Append Glow almanac seat 91 from IronBeetle ep036 census (e86).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 91
print almanac seat 91 appended · chapter six 11/16
bump ## Chapter Six (10 of 16)|## Chapter Six (11 of 16)
entry ### 91. IronBeetle ep036 keeps a cache that always hits via stash: a promise with a batch-sized deadline, plus an undo log for linked transfers.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep036_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep036_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep036_census.sh` · choir `equinox_ironbeetle_ep036_choir_witness.rish`
entry Expected IRON=present · EP036 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
