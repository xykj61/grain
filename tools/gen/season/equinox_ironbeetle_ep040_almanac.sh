#!/bin/sh
# Append Glow almanac seat 94 from IronBeetle ep040 census (e89).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 94\.' "$ALMANAC"; then
  echo "almanac seat 94 already present"
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
if "### 94." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (13 of 16)",
    "## Chapter Six (14 of 16)",
    1,
)
entry = (
    "### 94. IronBeetle ep040 overlaps read, merge, and write in three pipeline slots; bar and beat clocks pace one compaction round.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep040_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep040_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep040_census.sh` · choir `equinox_ironbeetle_ep040_choir_witness.rish`\n"
    "Expected IRON=present · EP040 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 94 appended · chapter six 14/16")
PY
