#!/bin/sh
# Append Glow almanac seat 88 from IronBeetle ep033 census (e83).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 88\.' "$ALMANAC"; then
  echo "almanac seat 88 already present"
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
if "### 88." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (7 of 16)",
    "## Chapter Six (8 of 16)",
    1,
)
entry = (
    "### 88. IronBeetle ep033 prefetches a whole batch of accounts before executing any transfer; load before decide.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep033_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep033_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep033_census.sh` · choir `equinox_ironbeetle_ep033_choir_witness.rish`\n"
    "Expected IRON=present · EP033 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 88 appended · chapter six 8/16")
PY
