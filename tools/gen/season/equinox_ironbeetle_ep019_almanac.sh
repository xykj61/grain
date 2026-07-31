#!/bin/sh
# Append Glow almanac seat 79 from IronBeetle ep019 census (e74).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 79\.' "$ALMANAC"; then
  echo "almanac seat 79 already present"
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
if "### 79." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (14 of 16)",
    "## Chapter Five (15 of 16)",
    1,
)
entry = (
    "### 79. IronBeetle ep019 reduces storage to a sorted array; tables are index plus value blocks.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep019_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep019_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep019_census.sh` · choir `equinox_ironbeetle_ep019_choir_witness.rish`\n"
    "Expected IRON=present · EP019 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 79 appended · chapter five 15/16")
PY
