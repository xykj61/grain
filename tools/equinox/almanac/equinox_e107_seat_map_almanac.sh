#!/bin/sh
# Append Glow almanac seat 111 from equinox e107 seat map -- ch7 15/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 111
print almanac seat 111 appended · chapter seven 15/16
bump ## Chapter Seven (14 of 16)|## Chapter Seven (15 of 16)
entry ### 111. Equinox e107 seat map: corrected close path after seat 110 spent on e106; proposes seat 112 CLOSE CHOIR as check·test·prepare; bundle as crossing mode; shred Keaton-gated; ch5+ch6 close-seat row still parked.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e107_seat_map_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e107_seat_map_witness.rish` · scan `tools/fixtures/e/equinox_seat_map_scan.sh` · pin `construction/EQUINOX_SEAT_MAP.md`
entry Expected control_gate · seat_map 110 spent · 112 close choir proposed · bundle crossing mode · shred Keaton-gated · fork not_consumed · seats 97–110 · shelf end ep045 · baton breach 0. Look at spent seats before naming the remaining map. Metal answered GREEN. Invent none.
DATA
