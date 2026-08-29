#!/bin/sh
# Append Glow almanac seat 97 from IronBeetle ep044 census (e93) -- opens chapter seven.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 97
print almanac seat 97 appended · chapter seven open
bump And may the rest of chapter six wait for metal, not memory.|And may the rest of chapter seven wait for metal, not memory.
entry ## Chapter Seven (1 of 16)
entry.
entry Opened from metal at stamp `{STAMP}`. Themes arrive after findings; this chapter carries none in advance. Ch5 and ch6 surface closes stay parked per e92 ruling D until a close-seat row is seated.
entry.
entry ### 97. IronBeetle ep044 traces everything we know from the first byte: two jobs of consensus, and honesty about unfinished code.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep044_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep044_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep044_census.sh` · choir `equinox_ironbeetle_ep044_choir_witness.rish`
entry Expected IRON=present · EP044 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Chapter seven opens under e76 law; clean-room study only.
DATA
