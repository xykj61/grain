#!/bin/sh
# Append Glow almanac seat 95 from IronBeetle ep042 census (e90).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 95\.' "$ALMANAC"; then
  echo "almanac seat 95 already present"
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
if "### 95." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (14 of 16)",
    "## Chapter Six (15 of 16)",
    1,
)
entry = (
    "### 95. IronBeetle ep042 crosses the Alps into the merge loop itself; table_builder writes checksummed blocks from what the loop produces.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep042_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep042_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep042_census.sh` · choir `equinox_ironbeetle_ep042_choir_witness.rish`\n"
    "Expected IRON=present · EP042 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 95 appended · chapter six 15/16")
PY
