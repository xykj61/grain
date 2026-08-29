#!/bin/sh
# Append Glow almanac seat 117 from e113 fascia-health + REDS 38 -- ch8 5/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 117
print almanac seat 117 appended · chapter eight 5/16
bump ## Chapter Eight (4 of 16)|## Chapter Eight (5 of 16)
entry ### 117. Equinox e113 fascia-health v1: live surface over total tracked surface behind planted live + dated controls; REDS row 38 records that on-disk is not in-the-tree (presence via git ls-files); seat 128 stays reserved; surface census four kept.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e113_fascia_health_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e113_fascia_health_witness.rish` · standing `tools/gen/chapter/fascia_health_witness.rish` · scan `tools/fixtures/f/fascia_health_scan.sh` · equinox scan `tools/fixtures/e/equinox_e113_fascia_health_scan.sh`
entry Expected control_gate · instruments_tracked · controls_honored=2 · fascia_health=41 · prove-red RED_on_disk_is_not_in_the_tree · REDS rows=38 · expect_next=39 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. On-disk is not in-the-tree. Metal answered GREEN. Invent none.
DATA
