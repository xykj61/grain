#!/bin/sh
# Append Glow almanac seat 81 from IronBeetle ep021 census (e76) -- opens chapter six.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 81
print almanac seat 81 appended · chapter six open
bump And may the rest of chapter five wait for metal, not memory.|And may the rest of chapter six wait for metal, not memory.
entry ## Chapter Six (1 of 16)
entry.
entry Opened from metal at stamp `{STAMP}`. Themes arrive after findings; this chapter carries none in advance.
entry.
entry ### 81. IronBeetle ep021 writes through one Grid; the queue borrows memory from its callers.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep021_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep021_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep021_census.sh` · choir `equinox_ironbeetle_ep021_choir_witness.rish`
entry Expected IRON=present · EP021 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Chapter six opens; clean-room study only.
DATA
