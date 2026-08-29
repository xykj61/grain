#!/bin/sh
# Append Glow almanac seat 14 from metal when equinox map witness is GREEN (e7).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 14
print almanac seat 14 appended
bump ## Chapter One — Build Journey greens (13 of 16)|## Chapter One — Build Journey greens (14 of 16)
bump Three seats remain.|Two seats remain.
entry ### 14. The equinox map sits as Brix data; a witness checks four flanks and the kendras.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_map_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_map_witness.rish` · `context/equinox_map.brix`
entry Expected four blocks · flanks cover 1..12 once · descending wrap · kendras {1,4,7,10} · H10-north reason seated · negative fixtures fail. Metal answered GREEN. Glow is code; Brix is data.
DATA
