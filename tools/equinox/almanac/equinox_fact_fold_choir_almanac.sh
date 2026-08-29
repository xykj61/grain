#!/bin/sh
# Append Glow almanac seat 36 from fact-fold choir (e30).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 36
print almanac seat 36 appended · chapter three 4/16
bump ## Chapter Three (3 of 16)|## Chapter Three (4 of 16)
entry ### 36. The fact-fold design hall points at living metal; three bounds match and purity holds.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_fact_fold_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/fact_fold_census_witness.rish` · scan `tools/fixtures/f/fact_fold_census.sh` · metal `mycelium/fold.rye` · choir `equinox_fact_fold_choir_witness.rish`
entry Expected pairs_matched=3 · PATTERN_CITES · fold GREEN with supply=872 · purity · refuse whole, and verdict=missing_shape on an absent path. Metal answered GREEN. Design hall and Sangha page keep one fold honest.
DATA
