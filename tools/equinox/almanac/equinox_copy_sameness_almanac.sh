#!/bin/sh
# Append Glow almanac seat 22 from copy-sameness choir (e16).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 22
print almanac seat 22 appended
bump ## Chapter Two (5 of 16)|## Chapter Two (6 of 16)
entry ### 22. Fourteen symlinks and one real file keep tally/copy.rye sameness; a drifted fixture is refused.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_copy_sameness_almanac_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/copy_sameness_witness.rish` · `tools/gen/chapter/copy_sameness_negative_witness.rish` · choir `equinox_copy_sameness_almanac_witness.rish`
entry Expected welcome verdict=ok and refuse verdict=drift on the fixture while the live tree stays clean. Metal answered GREEN. Negative space as loud as welcome.
DATA
