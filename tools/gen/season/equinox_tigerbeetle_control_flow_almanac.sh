#!/bin/sh
# Append Glow almanac seat 41 from TB control-flow census (e35).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 41\.' "$ALMANAC"; then
  echo "almanac seat 41 already present"
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
if "### 41." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (8 of 16)",
    "## Chapter Three (9 of 16)",
    1,
)
entry = (
    "### 41. Control flow stays simple and explicit; recursion stays out so bounds hold.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_control_flow_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_control_flow_census_witness.rish` · scan `tools/fixtures/tigerbeetle_control_flow_census.sh` · choir `equinox_tigerbeetle_control_flow_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_FLOW · GUIDE_NASA · GUIDE_LIMIT · TAME_FLOW · SUPPLEMENT_FLOW · STYLE, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 41 appended · chapter three 9/16")
PY
