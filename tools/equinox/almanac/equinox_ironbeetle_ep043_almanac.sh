#!/bin/sh
# Append Glow almanac seat 96 from IronBeetle ep043 census (e91) -- ch6 FULL.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 96
print almanac seat 96 appended · chapter six 16/16 FULL
bump ## Chapter Six (15 of 16)|## Chapter Six (16 of 16)
entry ### 96. IronBeetle ep043 makes the Manifest the moment of truth: written tables stay unacknowledged until apply; snapshots defer erasure.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep043_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep043_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep043_census.sh` · choir `equinox_ironbeetle_ep043_choir_witness.rish`
entry Expected IRON=present · EP043 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only. Chapter six fills at sixteen.
DATA
