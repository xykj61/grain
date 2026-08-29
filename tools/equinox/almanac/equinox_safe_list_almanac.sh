#!/bin/sh
# Append Glow almanac seat 28 from SAFE list census (e22).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 28
print almanac seat 28 appended
census sh tools/fixtures/s/safe_list_census.sh
bump ## Chapter Two (11 of 16)|## Chapter Two (12 of 16)
entry ### 28. The SAFE list opens empty under a sixty-four-row bound; shred stays refused.
entry **Ran:** `rishi/bin/rishi run tools/gen/chapter/safe_list_census_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/safe_list_census_witness.rish` · `tools/fixtures/s/safe_list_census.sh` · `SAFE.md` · `context/specs/oldness-cycle.md`
entry Expected SAFE=present · SPEC=present · SEATED=yes · BOUND_NAMED=yes · EMPTY_OK · SHRED_RED=yes with rows≤64. Metal answered GREEN. Census: {CENSUS}. Rows grow only by Keaton's word.
DATA
