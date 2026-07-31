#!/bin/sh
# Append Glow almanac seat 74 from IronBeetle ep012 census (e69).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 74\.' "$ALMANAC"; then
  echo "almanac seat 74 already present"
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
if "### 74." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (9 of 16)",
    "## Chapter Five (10 of 16)",
    1,
)
entry = (
    "### 74. IronBeetle ep012 runs one ring for asking and one for answering; deadlines refuse to wait twice.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep012_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep012_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep012_census.sh` · choir `equinox_ironbeetle_ep012_choir_witness.rish`\n"
    "Expected IRON=present · EP012 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 74 appended · chapter five 10/16")
PY
