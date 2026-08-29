#!/bin/sh
# Append Glow almanac seat 50 from TB say-how census (e44).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 50
print almanac seat 50 appended · chapter four 2/16
bump ## Chapter Four (1 of 16)|## Chapter Four (2 of 16)
entry ### 50. Tests say how; goal and method meet the reader before the dive.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_tigerbeetle_say_how_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/tigerbeetle_say_how_census_witness.rish` · scan `tools/fixtures/t/tigerbeetle_say_how_census.sh` · choir `equinox_tigerbeetle_say_how_choir_witness.rish`
entry Expected CLONE=present · GUIDE_HOW · GUIDE_METHOD · TAME_HOW · STYLE · ELDER_WHY · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.
DATA
