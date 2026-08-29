#!/bin/sh
# Append Glow almanac seat 93 from IronBeetle ep038 census (e88).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 93
print almanac seat 93 appended · chapter six 13/16
bump ## Chapter Six (12 of 16)|## Chapter Six (13 of 16)
entry ### 93. IronBeetle ep038 routes a whole compaction round from one beat number; even levels, then odd, from a single modulo.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep038_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep038_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep038_census.sh` · choir `equinox_ironbeetle_ep038_choir_witness.rish`
entry Expected IRON=present · EP038 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.
DATA
