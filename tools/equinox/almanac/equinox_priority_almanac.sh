#!/bin/sh
# Append Glow almanac seat 18 from priority-fold metal (e12).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 18
print almanac seat 18 appended
bump ## Chapter Two (1 of 16)|## Chapter Two (2 of 16)
entry ### 18. A round names its own priority: sixteen slots, twelve base once, four doubles spaced at least six apart.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_priority_almanac_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_priority_almanac_witness.rish` · `glow/priority_fold_test.rye`
entry Expected 16 slots · 12 base once each · 4 doubles with min gap 6. Metal answered GREEN. The mod-clock priority fold enters chapter two.
DATA
