#!/bin/sh
# Append Glow almanac seat 123 from e119 close-seat surfaces -- ch8 11/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 123
print almanac seat 123 appended · chapter eight 11/16
bump ## Chapter Eight (10 of 16)|## Chapter Eight (11 of 16)
entry ### 123. Equinox e119 close-seat surfaces: close-seat row answered — a surface witness claims no seat of its own; ch5 and ch6 surfaces land as tools (equinox_ch5_surface_witness.rish · equinox_ch6_surface_witness.rish) over already-GREEN limbs with no chapter-close almanac row and no seat displaced; e92-shaped census finds six (ch2·ch3·ch4·ch5·ch6·ch7); e92 park lifted by Keaton fuse kg on the measured answer; seat 128 stays reserved.
entry **Ran:** `sh tools/fixtures/e/equinox_e119_close_seat_surfaces_scan.sh` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e119_close_seat_surfaces_witness.rish` · counsel `counsel/date/20260731/20260731-214426_e119-close-seat-surfaces.md` · scan `tools/fixtures/e/equinox_e119_close_seat_surfaces_scan.sh`
entry Expected control_gate · instruments_tracked · ch5+ch6 surface scans ok · surface_count=6 · e92_park=lifted · no_almanac_seat honored · prove-red RED_claimed_four_while_six · seat_128 reserved · fork EXTEND · handback not_consumed · shelf end ep045 · baton breach 0. A surface witness claims no seat of its own. Metal answered GREEN. Invent none.
DATA
