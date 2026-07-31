#!/bin/sh
# Append Glow almanac seat 87 from IronBeetle ep032 census (e82).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 87\.' "$ALMANAC"; then
  echo "almanac seat 87 already present"
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
if "### 87." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (6 of 16)",
    "## Chapter Six (7 of 16)",
    1,
)
entry = (
    "### 87. IronBeetle ep032 orders engineering values: safety first, then performance, then experience — programming integrated over time.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep032_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep032_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep032_census.sh` · choir `equinox_ironbeetle_ep032_choir_witness.rish`\n"
    "Expected IRON=present · EP032 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 87 appended · chapter six 7/16")
PY
