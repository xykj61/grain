#!/bin/sh
# Append Glow almanac seat 43 from TB sized-types census (e37).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 43
print almanac seat 43 appended · chapter three 11/16
bump ## Chapter Three (10 of 16)|## Chapter Three (11 of 16)
entry ### 43. Types carry exact widths; usize stays at the seam, not in design.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_tigerbeetle_sized_types_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/tigerbeetle_sized_types_census_witness.rish` · scan `tools/fixtures/t/tigerbeetle_sized_types_census.sh` · choir `equinox_tigerbeetle_sized_types_choir_witness.rish`
entry Expected CLONE=present · GUIDE_SIZED · TAME_SIZED · SUPPLEMENT_SIZED · STYLE · WIDTH_CHECK · USIZE_AUDIT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.
DATA
