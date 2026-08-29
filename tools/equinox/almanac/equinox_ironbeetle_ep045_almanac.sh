#!/bin/sh
# Append Glow almanac seat 98 from IronBeetle ep045 census (e94) -- ch7 2/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 98
print almanac seat 98 appended · chapter seven 2/16
bump ## Chapter Seven (1 of 16)|## Chapter Seven (2 of 16)
entry ### 98. IronBeetle ep045 restates the whole machine in one breath: await by hand, one sequential core, prefetch before decide, DST as the quiet reason.
entry **Ran:** `rishi/bin/rishi run tools/equinox/witness/equinox_ironbeetle_ep045_choir_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/ironbeetle_ep045_census_witness.rish` · scan `tools/fixtures/i/ironbeetle_ep045_census.sh` · choir `equinox_ironbeetle_ep045_choir_witness.rish`
entry Expected IRON=present · EP045 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only. Chapter seven advances to two of sixteen.
DATA
