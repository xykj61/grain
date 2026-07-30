#!/bin/sh
# Append Glow almanac seat 66 from IronBeetle ep002 census (e61).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 66\.' "$ALMANAC"; then
  echo "almanac seat 66 already present"
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
if "### 66." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (1 of 16)",
    "## Chapter Five (2 of 16)",
    1,
)
entry = (
    "### 66. IronBeetle ep002 keeps two columns; money cannot silently appear.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep002_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep002_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep002_census.sh` · choir `equinox_ironbeetle_ep002_choir_witness.rish`\n"
    "Expected IRON=present · EP002 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 66 appended · chapter five 2/16")
PY
