#!/bin/sh
# Append Glow almanac seat 50 from TB say-how census (e44).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 50\.' "$ALMANAC"; then
  echo "almanac seat 50 already present"
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
if "### 50." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (1 of 16)",
    "## Chapter Four (2 of 16)",
    1,
)
entry = (
    "### 50. Tests say how; goal and method meet the reader before the dive.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_say_how_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_say_how_census_witness.rish` · scan `tools/fixtures/tigerbeetle_say_how_census.sh` · choir `equinox_tigerbeetle_say_how_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_HOW · GUIDE_METHOD · TAME_HOW · STYLE · ELDER_WHY · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 50 appended · chapter four 2/16")
PY
