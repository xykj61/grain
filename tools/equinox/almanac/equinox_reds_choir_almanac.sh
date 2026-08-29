#!/bin/sh
# Append Glow almanac seat 29 from reds choir (e23).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 29
print almanac seat 29 appended
rows sh tools/fixtures/r/reds_ledger_monotone_scan.sh | rg -o 'rows=[0-9]+' | head -1 | cut -d= -f2
bump ## Chapter Two (12 of 16)|## Chapter Two (13 of 16)
entry ### 29. The reds ledger accretes complete rows; a thin fixture is refused whole.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_reds_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/reds_ledger_witness.rish` · `tools/gen/chapter/reds_ledger_monotone_witness.rish` · `tools/gen/chapter/reds_ledger_negative_witness.rish` · choir `equinox_reds_choir_witness.rish`
entry Expected living ledger completeness and 1..N monotone indices, plus fixture refuse (incomplete_rows) while the live pin stays clean. Metal answered GREEN. Living rows={ROWS}. Negative space as loud as welcome.
DATA
