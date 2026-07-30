#!/bin/sh
# Append Glow almanac seat 57 from TB dependencies census (e52).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 57\.' "$ALMANAC"; then
  echo "almanac seat 57 already present"
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
if "### 57." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (8 of 16)",
    "## Chapter Four (9 of 16)",
    1,
)
entry = (
    "### 57. Dependencies stay at zero beyond Zig; supply-chain risk stays out of the stack.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_dependencies_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_dependencies_census_witness.rish` · scan `tools/fixtures/tigerbeetle_dependencies_census.sh` · choir `equinox_tigerbeetle_dependencies_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_DEPS · GUIDE_ZERO · GUIDE_ZIG · GUIDE_SUPPLY · TAME_DEPS · STYLE · ELDER_STYLE · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 57 appended · chapter four 9/16")
PY
