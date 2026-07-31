#!/bin/sh
# Append Glow almanac seat 91 from IronBeetle ep036 census (e86).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 91\.' "$ALMANAC"; then
  echo "almanac seat 91 already present"
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
if "### 91." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (10 of 16)",
    "## Chapter Six (11 of 16)",
    1,
)
entry = (
    "### 91. IronBeetle ep036 keeps a cache that always hits via stash: a promise with a batch-sized deadline, plus an undo log for linked transfers.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep036_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep036_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep036_census.sh` · choir `equinox_ironbeetle_ep036_choir_witness.rish`\n"
    "Expected IRON=present · EP036 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 91 appended · chapter six 11/16")
PY
