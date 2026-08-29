#!/bin/sh
# Append Glow almanac seat 52 from TB shrink-scope census (e46).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 52
print almanac seat 52 appended · chapter four 4/16
bump ## Chapter Four (3 of 16)|## Chapter Four (4 of 16)
entry ### 52. Scope stays small; check meets use before the gap opens.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_tigerbeetle_shrink_scope_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/tigerbeetle_shrink_scope_census_witness.rish` · scan `tools/fixtures/t/tigerbeetle_shrink_scope_census.sh` · choir `equinox_tigerbeetle_shrink_scope_choir_witness.rish`
entry Expected CLONE=present · GUIDE_SHRINK · GUIDE_POCPOU · TAME_SHRINK · STYLE · ELDER_CACHE · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.
DATA
