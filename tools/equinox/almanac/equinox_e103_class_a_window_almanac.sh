#!/bin/sh
# Append Glow almanac seat 107 from equinox e103 Class A + window -- ch7 11/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 107
print almanac seat 107 appended · chapter seven 11/16
bump ## Chapter Seven (10 of 16)|## Chapter Seven (11 of 16)
entry ### 107. Equinox e103 Class A refine + window_min: fascia metric i7 excludes four honest Siya-turn anchors; fall baseline is window_min; fascia 92→100.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e103_class_a_window_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e103_class_a_window_witness.rish` · scan `tools/fixtures/e/equinox_e103_class_a_window_scan.sh` · choir `equinox_e103_class_a_window_choir_witness.rish`
entry Expected control_gate · refine_memcpy paid · metric_rev=i7 · class_a=0 · class_a_honest_excluded=4 · baseline_kind=window_min · fascia=100 · fork not_consumed · seats 97–106 · shelf end ep045 · baton breach 0. A signal that penalizes an honest record is measuring the wrong thing. Metal answered GREEN. Invent none.
DATA
