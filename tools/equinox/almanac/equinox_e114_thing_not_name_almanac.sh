#!/bin/sh
# Append Glow almanac seat 118 from e114 thing-not-name + REDS 39 -- ch8 6/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 118
print almanac seat 118 appended · chapter eight 6/16
bump ## Chapter Eight (5 of 16)|## Chapter Eight (6 of 16)
entry ### 118. Equinox e114 thing-not-name: planted emitter proves a value can live without its key in the filename; shed emits fascia_health_now and standalone emits fascia_health (two roofs); REDS row 39 records look for the thing, not for the name of the thing; seat 128 stays reserved; surface census four kept.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e114_thing_not_name_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e114_thing_not_name_witness.rish` · standing `tools/gen/chapter/thing_not_name_witness.rish` · scan `tools/fixtures/t/thing_not_name_scan.sh` · equinox scan `tools/fixtures/e/equinox_e114_thing_not_name_scan.sh`
entry Expected control_gate · instruments_tracked · demo_meter=7 · name_hits_demo_meter=0 · roofs=2 · prove-red RED_looked_for_name_not_thing · REDS rows=39 · expect_next=40 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. Look for the thing, not for the name of the thing. Metal answered GREEN. Invent none.
DATA
