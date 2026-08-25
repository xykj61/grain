#!/bin/sh
# Append Glow almanac seat 115 from e111 date dialect -- ch8 3/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 115\.' "$ALMANAC"; then
  echo "almanac seat 115 already present"
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
if "### 115." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (2 of 16)",
    "## Chapter Eight (3 of 16)",
    1,
)
entry = (
    "### 115. Equinox e111 date dialect: eleven context Last updated values compact "
    "(hyphenated day -> YYYYMMDD in backticks); 17 of 17 compact; zero hyphenated; "
    "seat 128 stays reserved; surface census four kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e111_date_dialect_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e111_date_dialect_witness.rish` · "
    "scan `tools/fixtures/equinox_e111_date_dialect_scan.sh`\n"
    "Expected control_gate · dialect_transformed=11 · hyphenated_last_updated=0 · "
    "17_of_17_compact · lint label-only dep · seat_128 reserved · surface_count=4 · "
    "fork not_consumed · shelf end ep045 · baton breach 0. "
    "Carry the transformation, never the claim that it was done. "
    "A format change claims no review. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 115 appended · chapter eight 3/16")
PY
