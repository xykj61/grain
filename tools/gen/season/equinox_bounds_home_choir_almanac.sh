#!/bin/sh
# Append Glow almanac seat 34 from bounds-home choir (e28) -- ch3 continues.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 34\.' "$ALMANAC"; then
  echo "almanac seat 34 already present"
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
if "### 34." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (1 of 16)",
    "## Chapter Three (2 of 16)",
    1,
)
entry = (
    "### 34. Build ceilings inherit the living bounds table; ten pairs match and metal stays GREEN.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_bounds_home_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/bounds_home_census_witness.rish` · scan `tools/fixtures/bounds_home_census.sh` · metal `mycelium/build_bounds.rye` · choir `equinox_bounds_home_choir_witness.rish`\n"
    "Expected pairs_matched=10 · pairs_drift=0 · living_table_named · build_bounds GREEN, and verdict=missing_shape on an absent path. "
    "Metal answered GREEN. Chapter three continues; builds inherit, they do not invent.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 34 appended · chapter three 2/16")
PY
