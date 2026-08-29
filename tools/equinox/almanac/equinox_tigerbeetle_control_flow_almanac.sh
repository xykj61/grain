#!/bin/sh
# Append Glow almanac seat 41 from TB control-flow census (e35).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 41
print almanac seat 41 appended · chapter three 9/16
bump ## Chapter Three (8 of 16)|## Chapter Three (9 of 16)
entry ### 41. Control flow stays simple and explicit; recursion stays out so bounds hold.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_tigerbeetle_control_flow_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/tigerbeetle_control_flow_census_witness.rish` · scan `tools/fixtures/t/tigerbeetle_control_flow_census.sh` · choir `equinox_tigerbeetle_control_flow_choir_witness.rish`
entry Expected CLONE=present · GUIDE_FLOW · GUIDE_NASA · GUIDE_LIMIT · TAME_FLOW · SUPPLEMENT_FLOW · STYLE, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.
DATA
