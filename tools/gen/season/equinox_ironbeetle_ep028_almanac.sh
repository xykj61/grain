#!/bin/sh
# Append Glow almanac seat 84 from IronBeetle ep028 census (e79).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 84\.' "$ALMANAC"; then
  echo "almanac seat 84 already present"
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
if "### 84." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (3 of 16)",
    "## Chapter Six (4 of 16)",
    1,
)
entry = (
    "### 84. IronBeetle ep028 stages a freed block until the next checkpoint; reserve then acquire keeps addresses deterministic.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep028_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep028_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep028_census.sh` · choir `equinox_ironbeetle_ep028_choir_witness.rish`\n"
    "Expected IRON=present · EP028 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 84 appended · chapter six 4/16")
PY
