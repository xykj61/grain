#!/bin/sh
# Append Glow almanac seat 23 from TigerStyle void-return finding (e17).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 23
print almanac seat 23 appended
bump ## Chapter Two (6 of 16)|## Chapter Two (7 of 16)
entry ### 23. TigerStyle ranks void above bool as a return type; its held examples return !void.
entry **Ran:** `rishi/bin/rishi run tools/gen/chapter/tigerstyle_void_return_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/tigerstyle_void_return_witness.rish` · `gratitude/TIGER_STYLE.md`
entry Expected the dimensionality ladder and !void init/main examples on the held style guide. Metal answered GREEN. Full tigerbeetle src clone may be ABSENT; this seat measures the guide we hold.
DATA
