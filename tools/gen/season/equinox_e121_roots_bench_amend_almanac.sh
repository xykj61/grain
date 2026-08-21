#!/bin/sh
# Append Glow almanac seat 125 from e121 roots bench amend — ch8 13/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 125\.' "$ALMANAC"; then
  echo "almanac seat 125 already present"
  exit 0
fi
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
export STAMP
python3 - <<'PY'
from pathlib import Path
import os
p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
if "### 125." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (12 of 16)",
    "## Chapter Eight (13 of 16)",
    1,
)
entry = (
    "### 125. Equinox e121 roots bench amend: Lexicon **roots** amended — surfaces "
    "through which work reaches the tree; members add Framework and counsel "
    "container beside Claude web · Claude iOS · Cursor AppImage desktop · Cursor iOS; "
    "a root that holds a raise is a **Bench**, and only a bench runs witnesses; "
    "name the root when a measurement is reported; Bench row accretes kinship; "
    "seat 128 stays reserved; surface census six kept.\n"
    "**Ran:** `sh tools/fixtures/equinox_e121_roots_bench_amend_scan.sh` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e121_roots_bench_amend_witness.rish` · "
    "counsel `counsel/date/20260731/20260731-220432_e121-roots-bench-amend.md` · "
    "Lexicon `context/LEXICON.md`\n"
    "Expected control_gate · roots=honored · bench_kinship=honored · six members · "
    "prove-red RED_claimed_bench_not_raised_root · seat_128 reserved · "
    "surface_count=6 · fork EXTEND · handback not_consumed · shelf end ep045 · "
    "baton breach 0. Name the root when a measurement is reported. Metal answered "
    "GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 125 appended · chapter eight 13/16")
PY
