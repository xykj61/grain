#!/bin/sh
# Open Glow almanac chapter two and append seat 17 from East-pack metal (e11).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 17
print almanac chapter two opened · seat 17 appended
entry ## Chapter Two (1 of 16)
entry.
entry Opened from metal at stamp `{STAMP}`. Themes arrive after findings; this chapter carries none in advance.
entry.
entry ### 17. The East pack still holds as one choir: e1–e6 utilities and harden limbs GREEN together.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_east_almanac_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_east_almanac_witness.rish` · `tools/equinox/witness/equinox_e1_east_pack_witness.rish`
entry Expected East utilities and harden limbs GREEN in one re-touch. Metal answered GREEN. Chapter two opens; chapter one stays closed at sixteen.
DATA
