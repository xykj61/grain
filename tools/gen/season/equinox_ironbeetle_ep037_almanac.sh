#!/bin/sh
# Append Glow almanac seat 92 from IronBeetle ep037½ census (e87).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 92\.' "$ALMANAC"; then
  echo "almanac seat 92 already present"
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
if "### 92." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Six (11 of 16)",
    "## Chapter Six (12 of 16)",
    1,
)
entry = (
    "### 92. IronBeetle ep037½ folds compaction into each commit: garbage collection at allocation so replicas stay byte-identical.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep037_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep037_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep037_census.sh` · choir `equinox_ironbeetle_ep037_choir_witness.rish`\n"
    "Expected IRON=present · EP037 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 92 appended · chapter six 12/16")
PY
