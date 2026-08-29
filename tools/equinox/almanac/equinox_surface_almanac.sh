#!/bin/sh
# Append Glow almanac seat 16 from metal when equinox surface choir is GREEN (e10).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 16
print almanac seat 16 appended
bump ## Chapter One — Build Journey greens (15 of 16)|## Chapter One — Build Journey greens (16 of 16)
bump One seat remains.|Chapter one is full.
bump And may the remaining one seat wait for metal, not memory.|And may chapter two wait for metal, not memory.
entry ### 16. The Equinox surface choir holds: e0 bow, map, and foundations GREEN together.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_surface_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_surface_witness.rish`
entry Expected e0 · equinox_map · equinox_foundations each GREEN in one choir. Metal answered GREEN. Chapter one closes at sixteen; prose create-prep did not earn this seat.
DATA
