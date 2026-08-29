#!/bin/sh
# Append Glow almanac seat 20 from houseplant glossary metal (e14).
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 20
print almanac seat 20 appended
bump ## Chapter Two (3 of 16)|## Chapter Two (4 of 16)
entry ### 20. Houseplant names a Kumara ship owner's whole grain repository project tree.
entry **Ran:** `rishi/bin/rishi run tools/gen/chapter/houseplant_glossary_witness.rish` · **Stamp:** `{STAMP}` · **Witness:** `tools/gen/chapter/houseplant_glossary_witness.rish` · `context/LEXICON.md`
entry Expected Lexicon row with ship · repository · project tree · pier/verse distinct · ladder accretion. Metal answered GREEN. The plant is the tree, not the keypair.
DATA
