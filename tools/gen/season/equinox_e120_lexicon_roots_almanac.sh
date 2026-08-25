#!/bin/sh
# Append Glow almanac seat 124 from e120 Lexicon roots -- ch8 12/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 124\.' "$ALMANAC"; then
  echo "almanac seat 124 already present"
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
if "### 124." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (11 of 16)",
    "## Chapter Eight (12 of 16)",
    1,
)
entry = (
    "### 124. Equinox e120 Lexicon roots: seats **roots** as the general category of "
    "client surfaces — Claude web · Claude iOS · Cursor AppImage desktop · Cursor iOS; "
    "distinct from Bench · pier · Pond · digest/Tilak roots; seat 128 stays reserved; "
    "surface census six kept; close-seat answered kept.\n"
    "**Ran:** `sh tools/fixtures/equinox_e120_lexicon_roots_scan.sh` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e120_lexicon_roots_witness.rish` · "
    "counsel `counsel/date/20260731/20260731-215300_e120-lexicon-roots.md` · "
    "Lexicon `context/LEXICON.md`\n"
    "Expected control_gate · instruments_tracked · roots=honored · four members · "
    "Bench/pier/Pond distinctions · prove-red RED_claimed_roots_absent_while_seated · "
    "seat_128 reserved · surface_count=6 · fork EXTEND · handback not_consumed · "
    "shelf end ep045 · baton breach 0. Look for the thing, not for the name of the "
    "thing. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 124 appended · chapter eight 12/16")
PY
