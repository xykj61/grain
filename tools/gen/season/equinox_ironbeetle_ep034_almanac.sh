#!/bin/sh
# Append Glow almanac seat 89 from IronBeetle ep034 census (e84).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 89\.' "$ALMANAC"; then
  echo "almanac seat 89 already present"
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
if "### 89." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (8 of 16)",
    "## Chapter Six (9 of 16)",
    1,
)
entry = (
    "### 89. IronBeetle ep034 forbids half-sync callbacks; asynchronous always means the next tick, and prefetch stays parallel while commit stays sequential.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep034_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep034_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep034_census.sh` · choir `equinox_ironbeetle_ep034_choir_witness.rish`\n"
    "Expected IRON=present · EP034 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 89 appended · chapter six 9/16")
PY
