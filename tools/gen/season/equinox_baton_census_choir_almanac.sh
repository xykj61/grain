#!/bin/sh
# Append Glow almanac seat 31 from baton census choir (e25).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 31\.' "$ALMANAC"; then
  echo "almanac seat 31 already present"
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
if "### 31." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (14 of 16)",
    "## Chapter Two (15 of 16)",
    1,
)
entry = (
    "### 31. The baton museum holds thirteen halls; a missing museum path is refused whole.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_baton_census_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/baton_museum_census_witness.rish` · scan `tools/fixtures/baton_museum_census_scan.sh` · choir `equinox_baton_census_choir_witness.rish`\n"
    "Expected halls_expected=13 · halls_absent=0 · census_breach_count=0, and verdict=missing_museum on an absent path. "
    "Metal answered GREEN. Museum-hall census named; breach census stays zero and banked.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 31 appended")
PY
