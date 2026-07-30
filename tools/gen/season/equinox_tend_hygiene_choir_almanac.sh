#!/bin/sh
# Append Glow almanac seat 37 from tend-hygiene choir (e31).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 37\.' "$ALMANAC"; then
  echo "almanac seat 37 already present"
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
if "### 37." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (4 of 16)",
    "## Chapter Three (5 of 16)",
    1,
)
entry = (
    "### 37. Tend hygiene forbids new code files; three tend waymarks hold fascia delta zero.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tend_hygiene_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tend_hygiene_census_witness.rish` · scan `tools/fixtures/tend_hygiene_census.sh` · choir `equinox_tend_hygiene_choir_witness.rish`\n"
    "Expected SHAPE_ZERO_CODE · HALL_ZERO_CODE · tend_waymarks=3 · delta_two=0 · delta_three=0, and verdict=missing_shape on an absent path. "
    "Metal answered GREEN. The fourth design hall closes the wing's measured set.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 37 appended · chapter three 5/16")
PY
