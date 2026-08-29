#!/bin/sh
# Append Glow almanac seat 32 from chapter-two surface choir (e26) -- closes ch2.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 32
print almanac seat 32 appended · chapter two full
bump ## Chapter Two (15 of 16)|## Chapter Two (16 of 16)
bump And may chapter two wait for metal, not memory.|And may chapter three wait for metal, not memory.
entry ### 32. The chapter-two surface choir holds: SAFE, reds, voice, and baton GREEN together.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ch2_surface_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_ch2_surface_witness.rish`
entry Expected SAFE census · reds complete/monotone/refuse · voice sites=6/refuse · baton halls=13/breach=0/absent refuse each GREEN in one choir. Metal answered GREEN. Chapter two closes at sixteen; chapter three waits for metal.
DATA
