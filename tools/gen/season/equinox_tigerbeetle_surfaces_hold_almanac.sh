#!/bin/sh
# Append Glow almanac seat 63 from TB surfaces-hold choir (e58).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 63\.' "$ALMANAC"; then
  echo "almanac seat 63 already present"
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
if "### 63." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (14 of 16)",
    "## Chapter Four (15 of 16)",
    1,
)
entry = (
    "### 63. The TigerBeetle surfaces hold with IronBeetle beside them: DX, mid, style, and the lesson shelf GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_surfaces_hold_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_tigerbeetle_surfaces_hold_witness.rish` · iron `tools/fixtures/ironbeetle_shelf_census.sh`\n"
    "Expected say-why GREEN · off-by-one GREEN · style-numbers GREEN · IRON present · COUNT≥34 · ep001 · ep045, "
    "and ABSENT refuses on a missing iron shelf or clone. Metal answered GREEN. Surfaces hold toward chapter-four close. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 63 appended · chapter four 15/16")
PY
