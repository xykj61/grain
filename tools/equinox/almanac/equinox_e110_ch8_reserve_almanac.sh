#!/bin/sh
# Append Glow almanac seat 114 from e110 -- ch8 2/16 - reserve 128 - census finds four.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 114
print almanac seat 114 appended · chapter eight 2/16
bump ## Chapter Eight (1 of 16)|## Chapter Eight (2 of 16)
entry ### 114. Equinox e110: e92-shaped surface census finds four (ch2·ch3·ch4·ch7); ch7 close is findable as equinox_ch7_surface_witness; Chapter Eight reserves seat 128 for the close choir on day one (content fills 114–127).
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e110_ch8_reserve_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e110_ch8_reserve_witness.rish` · scan `tools/fixtures/e/equinox_e110_ch8_reserve_scan.sh` · pin `construction/EQUINOX_SEAT_MAP.md`
entry Expected control_gate · surface_count=4 · chapters 2,3,4,7 · ch5/ch6 absent · seat_128 reserved_close_choir · ch8 span 113–128 · fork not_consumed · shelf end ep045 · baton breach 0. A record that cannot be found by the census that will look for it is not yet a record. Metal answered GREEN. Invent none.
DATA
