#!/bin/sh
# Append Glow almanac seat 82 from IronBeetle ep022 census (e77).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 82\.' "$ALMANAC"; then
  echo "almanac seat 82 already present"
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
if "### 82." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (1 of 16)",
    "## Chapter Six (2 of 16)",
    1,
)
entry = (
    "### 82. IronBeetle ep022 delivers a proven block; local disk may fail while the read still succeeds.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep022_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep022_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep022_census.sh` · choir `equinox_ironbeetle_ep022_choir_witness.rish`\n"
    "Expected IRON=present · EP022 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 82 appended · chapter six 2/16")
PY
