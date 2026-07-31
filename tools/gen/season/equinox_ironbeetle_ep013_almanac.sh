#!/bin/sh
# Append Glow almanac seat 75 from IronBeetle ep013 census (e70).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 75\.' "$ALMANAC"; then
  echo "almanac seat 75 already present"
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
if "### 75." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (10 of 16)",
    "## Chapter Five (11 of 16)",
    1,
)
entry = (
    "### 75. IronBeetle ep013 holds Op · commit_min · commit_max apart; repair reads the break in the chain.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep013_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep013_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep013_census.sh` · choir `equinox_ironbeetle_ep013_choir_witness.rish`\n"
    "Expected IRON=present · EP013 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 75 appended · chapter five 11/16")
PY
