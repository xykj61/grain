#!/bin/sh
# Append Glow almanac seat 86 from IronBeetle ep031½ census (e81).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 86\.' "$ALMANAC"; then
  echo "almanac seat 86 already present"
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
if "### 86." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (5 of 16)",
    "## Chapter Six (6 of 16)",
    1,
)
entry = (
    "### 86. IronBeetle ep031½ keeps a durable fact in one coherent form; journal and checkpoint must truly copy the same thing.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep031_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep031_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep031_census.sh` · choir `equinox_ironbeetle_ep031_choir_witness.rish`\n"
    "Expected IRON=present · EP031 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 86 appended · chapter six 6/16")
PY
