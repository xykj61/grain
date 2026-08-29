#!/bin/sh
# Append Glow almanac seat 120 from e116 one dated definition + REDS 40 -- ch8 8/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 120
print almanac seat 120 appended · chapter eight 8/16
bump ## Chapter Eight (7 of 16)|## Chapter Eight (8 of 16)
entry ### 120. Equinox e116 one dated definition: shared dated_classify seats living-vs-dated once in code; shed and fascia-health both source it; divergence witness goes RED while dated_testimony differs; REDS row 40 records when two roofs carry one name, either they agree or the name is doing two jobs; seat 128 stays reserved; surface census four kept.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_e116_dated_one_definition_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e116_dated_one_definition_witness.rish` · standing `tools/gen/chapter/dated_pattern_witness.rish` · `tools/gen/chapter/dated_roof_divergence_witness.rish` · scan `tools/fixtures/d/dated_pattern_scan.sh` · `tools/fixtures/d/dated_roof_divergence_scan.sh` · equinox scan `tools/fixtures/e/equinox_e116_dated_one_definition_scan.sh`
entry Expected control_gate · instruments_tracked · definition=one · divergence=absent · roofs_agree · prove-red RED_dated_definition_blind · RED_roofs_diverge · REDS rows=40 · expect_next=41 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. When two roofs carry one name, either they agree or the name is doing two jobs. Metal answered GREEN. Invent none.
DATA
