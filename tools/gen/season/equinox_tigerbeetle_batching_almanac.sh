#!/bin/sh
# Append Glow almanac seat 44 from TB batching census (e38).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 44\.' "$ALMANAC"; then
  echo "almanac seat 44 already present"
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
if "### 44." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (11 of 16)",
    "## Chapter Three (12 of 16)",
    1,
)
entry = (
    "### 44. Costs amortize by batching; the CPU sprints on large enough chunks.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_batching_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_batching_census_witness.rish` · scan `tools/fixtures/tigerbeetle_batching_census.sh` · choir `equinox_tigerbeetle_batching_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_BATCH · GUIDE_SPRINTER · TAME_BATCH · TAME_SPRINTER · STYLE · GRAIN_BATCH, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 44 appended · chapter three 12/16")
PY
