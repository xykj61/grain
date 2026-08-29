#!/bin/sh
# Append Glow almanac seat 30 from voice-roster choir (e24).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 30
print almanac seat 30 appended
bump ## Chapter Two (13 of 16)|## Chapter Two (14 of 16)
entry ### 30. The standing voice is declared at six sites; an undeclared name is refused.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_voice_roster_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/voice_roster_witness.rish` · `tools/gen/chapter/voice_roster_negative_witness.rish` · choir `equinox_voice_roster_choir_witness.rish`
entry Expected sites=6 · drift=0 for Riyo, and verdict=drift for an undeclared voice while the standing call stays clean. Metal answered GREEN. Negative space as loud as welcome.
DATA
