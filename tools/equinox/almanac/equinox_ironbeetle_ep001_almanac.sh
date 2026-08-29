#!/bin/sh
# Append Glow almanac seat 65 from IronBeetle ep001 census (e60) -- opens chapter five.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 65
print almanac seat 65 appended · chapter five open
bump And may chapter five wait for metal, not memory.|And may the rest of chapter five wait for metal, not memory.
entry ## Chapter Five (1 of 16)
entry.
entry Opened from metal at stamp `{STAMP}`. Themes arrive after findings; this chapter carries none in advance.
entry.
entry ### 65. IronBeetle ep001 teaches the wire that needs no parser; checksum meets cast before trust.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep001_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep001_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep001_census.sh` · choir `equinox_ironbeetle_ep001_choir_witness.rish`
entry Expected IRON=present · EP001 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Chapter five opens; clean-room study only.
DATA
