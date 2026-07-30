#!/bin/sh
# Append Glow almanac seat 55 from TB off-by-one census (e49).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 55\.' "$ALMANAC"; then
  echo "almanac seat 55 already present"
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
if "### 55." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (6 of 16)",
    "## Chapter Four (7 of 16)",
    1,
)
entry = (
    "### 55. Index, count, and size stay distinct; division shows its intent.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_off_by_one_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_off_by_one_census_witness.rish` · scan `tools/fixtures/tigerbeetle_off_by_one_census.sh` · choir `equinox_tigerbeetle_off_by_one_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_OBO · GUIDE_TYPES · GUIDE_DIV · TAME_OBO · STYLE · ELDER_CACHE · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 55 appended · chapter four 7/16")
PY
