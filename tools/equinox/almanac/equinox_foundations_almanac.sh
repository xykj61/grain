#!/bin/sh
# Append Glow almanac seat 15 from metal when equinox foundations witness is GREEN (e8).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 15
print almanac seat 15 appended
bump ## Chapter One — Build Journey greens (14 of 16)|## Chapter One — Build Journey greens (15 of 16)
bump Two seats remain.|One seat remains.
entry ### 15. Twelve foundations distribute three per equinox; the descriptor joins the map flanks.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_foundations_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_foundations_witness.rish` · `context/equinox_foundations.brix`
entry Expected houses 1..12 once · three per equinox · join equinox_map flanks · kendras angular · wrong-home and missing-house fixtures fail. Metal answered GREEN. The e7 finding became data.
DATA
