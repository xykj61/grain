#!/bin/sh
# Append Glow almanac seat 116 from e112 planted date-dialect witness -- ch8 4/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 116
print almanac seat 116 appended · chapter eight 4/16
bump ## Chapter Eight (3 of 16)|## Chapter Eight (4 of 16)
entry ### 116. Equinox e112 planted date-dialect witness: C1 hyphenated control counted; C2 compact control not counted as hyphen; library 17 of 17 compact (one_dialect); prove-red refuses; seat 128 stays reserved; surface census four kept.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e112_date_dialect_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e112_date_dialect_witness.rish` · standing `tools/gen/chapter/date_dialect_witness.rish` · scan `tools/fixtures/d/date_dialect_scan.sh` · equinox scan `tools/fixtures/e/equinox_e112_date_dialect_witness_scan.sh`
entry Expected control_gate · controls_honored=2 · hyphenated=0 · compact=17 · verdict=one_dialect · prove-red RED_C2-compact · elder e111 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. A duty with no witness has no seat, and a duty with no seat never lands. Carry the transformation, never the claim that it was done. Metal answered GREEN. Invent none.
DATA
