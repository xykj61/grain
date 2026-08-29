#!/bin/sh
# Append Glow almanac seat 35 from relay-resin choir (e29).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 35
print almanac seat 35 appended · chapter three 3/16
bump ## Chapter Three (2 of 16)|## Chapter Three (3 of 16)
entry ### 35. The resin limb names at most twelve beads; a thirteenth without a manifest refuses whole.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_relay_resin_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/relay_resin_census_witness.rish` · scan `tools/fixtures/r/relay_resin_census.sh` · choir `equinox_relay_resin_choir_witness.rish`
entry Expected max_limb_beads=12 · limb_beads=12 · LEXICON · MANIFEST_BEAD, and verdict=over_bound on a thirteen-bead fixture without compaction. Metal answered GREEN. Amphora-shaped bound; the roster becomes a bead past twelve.
DATA
