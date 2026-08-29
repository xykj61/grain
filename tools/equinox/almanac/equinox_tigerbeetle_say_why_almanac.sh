#!/bin/sh
# Append Glow almanac seat 49 from TB say-why census (e43) -- opens chapter four.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 49
print almanac seat 49 appended · chapter four open
bump And may chapter four wait for metal, not memory.|And may the rest of chapter four wait for metal, not memory.
entry ## Chapter Four (1 of 16)
entry.
entry Opened from metal at stamp `{STAMP}`. Themes arrive after findings; this chapter carries none in advance.
entry.
entry ### 49. Comments say why; they are sentences, and Radiant voice keeps them honest.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_tigerbeetle_say_why_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/tigerbeetle_say_why_census_witness.rish` · scan `tools/fixtures/t/tigerbeetle_say_why_census.sh` · choir `equinox_tigerbeetle_say_why_choir_witness.rish`
entry Expected CLONE=present · GUIDE_WHY · GUIDE_HOW · GUIDE_SENTENCE · TAME_WHY · TAME_SENTENCE · TAME_RADIANT · SUPPLEMENT_WHY · STYLE · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Chapter four opens; clean-room study only.
DATA
