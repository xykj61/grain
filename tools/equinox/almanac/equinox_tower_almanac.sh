#!/bin/sh
# Append Glow almanac seat 19 from bounded-tower metal (e13).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 19
print almanac seat 19 appended
bump ## Chapter Two (2 of 16)|## Chapter Two (3 of 16)
entry ### 19. The classic tower solves with an explicit bounded stack; seventeen rings refuse whole.
entry **Ran:** `rishi/bin/rishi run tools/e/edu_tower_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/e/edu_tower_witness.rish` · `docs-geode/edu/yonder/tower/bounded_tower.rye`
entry Expected solve(3)=7 moves · TooManyRings at 17 · tally/stack beneath · tutorial pinned. Metal answered GREEN. Recursion stays out; the depth is named.
DATA
