#!/bin/sh
# Append Glow almanac seat 80 from IronBeetle ep020 census (e75) -- ch5 FULL.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 80\.' "$ALMANAC"; then
  echo "almanac seat 80 already present"
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
if "### 80." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (15 of 16)",
    "## Chapter Five (16 of 16)",
    1,
)
entry = (
    "### 80. IronBeetle ep020 shadows rather than overwrites; LSM levels and the Manifest keep the stack searchable.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep020_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep020_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep020_census.sh` · choir `equinox_ironbeetle_ep020_choir_witness.rish`\n"
    "Expected IRON=present · EP020 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only. Chapter five fills at sixteen.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 80 appended · chapter five 16/16 FULL")
PY
