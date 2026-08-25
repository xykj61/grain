#!/bin/sh
# Append Glow almanac seat 96 from IronBeetle ep043 census (e91) -- ch6 FULL.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 96\.' "$ALMANAC"; then
  echo "almanac seat 96 already present"
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
if "### 96." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (15 of 16)",
    "## Chapter Six (16 of 16)",
    1,
)
entry = (
    "### 96. IronBeetle ep043 makes the Manifest the moment of truth: written tables stay unacknowledged until apply; snapshots defer erasure.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep043_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep043_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep043_census.sh` · choir `equinox_ironbeetle_ep043_choir_witness.rish`\n"
    "Expected IRON=present · EP043 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only. Chapter six fills at sixteen.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 96 appended · chapter six 16/16 FULL")
PY
