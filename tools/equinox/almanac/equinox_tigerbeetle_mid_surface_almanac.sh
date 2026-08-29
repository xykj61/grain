#!/bin/sh
# Append Glow almanac seat 62 from TB mid surface choir (e57).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 62
print almanac seat 62 appended · chapter four 14/16
bump ## Chapter Four (13 of 16)|## Chapter Four (14 of 16)
entry ### 62. The TigerBeetle mid surface choir holds: cache leaves and off-by-one GREEN together.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_tigerbeetle_mid_surface_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_tigerbeetle_mid_surface_witness.rish`
entry Expected inplace GREEN · shrink GREEN · bleeds GREEN · off-by-one GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Off-by-one joins the cache three. Clean-room study only.
DATA
