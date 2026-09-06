#!/bin/sh
# Append Glow almanac seat 21 from tower frame-bite metal (e15).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 21
print almanac seat 21 appended
bump ## Chapter Two (4 of 16)|## Chapter Two (5 of 16)
entry ### 21. A capacity-one stack refuses a second push; the tower's frame bound bites from a fixture.
entry **Ran:** `rishi/bin/rishi run tools/e/edu_tower_frame_bite_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/e/edu_tower_frame_bite_witness.rish` · `docs-geode/edu/yonder/tower/frame_bound_overpush.rye`
entry Expected overpush EXIT=1 with assertion failure · welcome tower still GREEN. Metal answered GREEN. Negative space as loud as welcome.
DATA
