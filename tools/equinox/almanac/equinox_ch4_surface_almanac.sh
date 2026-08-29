#!/bin/sh
# Append Glow almanac seat 64 from chapter-four surface choir (e59) -- closes ch4.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 64
print almanac seat 64 appended · chapter four full
bump ## Chapter Four (15 of 16)|## Chapter Four (16 of 16)
bump And may the rest of chapter four wait for metal, not memory.|And may chapter five wait for metal, not memory.
entry ### 64. The chapter-four surface choir holds: DX, mid, style, and IronBeetle GREEN together.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ch4_surface_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_ch4_surface_witness.rish`
entry Expected dx why/how · mid inplace/shrink/bleeds/obo · style numbers/deps/tooling/last · iron COUNT≥34, and ABSENT refuses on a missing clone or iron shelf. Metal answered GREEN. Chapter four closes at sixteen; chapter five waits for metal.
DATA
