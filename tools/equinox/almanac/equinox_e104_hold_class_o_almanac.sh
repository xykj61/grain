#!/bin/sh
# Append Glow almanac seat 108 from equinox e104 hold + Class O -- ch7 12/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 108
print almanac seat 108 appended · chapter seven 12/16
bump ## Chapter Seven (11 of 16)|## Chapter Seven (12 of 16)
entry ### 108. Equinox e104 hold Class A disclosed + Class O rooms: fascia metric i8 holds four honest anchors with reason named (not excluded); Class O room home in SHRED_PREP; fascia 100→92; window_min kept.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e104_hold_class_o_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e104_hold_class_o_witness.rish` · scan `tools/fixtures/e/equinox_e104_hold_class_o_scan.sh` · choir `equinox_e104_hold_class_o_choir_witness.rish`
entry Expected control_gate · metric_rev=i8 · class_a=4 · class_a_held_disclosed=4 · law=hold_not_exclude · baseline_kind=window_min · fascia=92 · Class O rooms · no paths seated · fork not_consumed · seats 97–107 · shelf end ep045 · baton breach 0. Exclusion hides; holding discloses. Metal answered GREEN. Invent none.
DATA
