#!/bin/sh
# Append Glow almanac seat 53 from TB buffer-bleeds census (e47).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 53\.' "$ALMANAC"; then
  echo "almanac seat 53 already present"
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
if "### 53." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (4 of 16)",
    "## Chapter Four (5 of 16)",
    1,
)
entry = (
    "### 53. Buffer bleeds stay guarded; alloc meets defer in one glance.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_buffer_bleeds_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_buffer_bleeds_census_witness.rish` · scan `tools/fixtures/tigerbeetle_buffer_bleeds_census.sh` · choir `equinox_tigerbeetle_buffer_bleeds_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_BLEED · GUIDE_GROUP · TAME_BLEED · STYLE · ELDER_SHRINK · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 53 appended · chapter four 5/16")
PY
