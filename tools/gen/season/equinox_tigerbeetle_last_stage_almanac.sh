#!/bin/sh
# Append Glow almanac seat 59 from TB last-stage census (e54).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 59\.' "$ALMANAC"; then
  echo "almanac seat 59 already present"
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
if "### 59." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (10 of 16)",
    "## Chapter Four (11 of 16)",
    1,
)
entry = (
    "### 59. The last stage keeps trying, stays small, and laughs before the next pass.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_last_stage_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_last_stage_census_witness.rish` · scan `tools/fixtures/tigerbeetle_last_stage_census.sh` · choir `equinox_tigerbeetle_last_stage_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_LAST · GUIDE_FUN · GUIDE_SMALL · GUIDE_BILBO · TAME_LAST · STYLE · ELDER_TOOL · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 59 appended · chapter four 11/16")
PY
