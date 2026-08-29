#!/bin/sh
# Append Glow almanac seat 61 from TB DX surface choir (e56).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 61
print almanac seat 61 appended · chapter four 13/16
bump ## Chapter Four (12 of 16)|## Chapter Four (13 of 16)
entry ### 61. The TigerBeetle DX surface choir holds: say-why and say-how GREEN together.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_tigerbeetle_dx_surface_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_tigerbeetle_dx_surface_witness.rish`
entry Expected say-why GREEN · say-how GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Two DX leaves hold as one choir. Clean-room study only.
DATA
