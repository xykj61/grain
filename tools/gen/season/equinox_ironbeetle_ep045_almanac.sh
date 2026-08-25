#!/bin/sh
# Append Glow almanac seat 98 from IronBeetle ep045 census (e94) -- ch7 2/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 98\.' "$ALMANAC"; then
  echo "almanac seat 98 already present"
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
if "### 98." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (1 of 16)",
    "## Chapter Seven (2 of 16)",
    1,
)
entry = (
    "### 98. IronBeetle ep045 restates the whole machine in one breath: await by hand, one sequential core, prefetch before decide, DST as the quiet reason.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep045_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep045_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep045_census.sh` · choir `equinox_ironbeetle_ep045_choir_witness.rish`\n"
    "Expected IRON=present · EP045 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only. Chapter seven advances to two of sixteen.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 98 appended · chapter seven 2/16")
PY
