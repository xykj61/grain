#!/bin/sh
# Append Glow almanac seat 56 from TB style-by-the-numbers census (e51).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 56\.' "$ALMANAC"; then
  echo "almanac seat 56 already present"
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
if "### 56." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (7 of 16)",
    "## Chapter Four (8 of 16)",
    1,
)
entry = (
    "### 56. Style holds by the numbers: zig fmt, four spaces, one hundred columns, and braced ifs.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_style_by_the_numbers_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_style_by_the_numbers_census_witness.rish` · scan `tools/fixtures/tigerbeetle_style_by_the_numbers_census.sh` · choir `equinox_tigerbeetle_style_by_the_numbers_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_STYLE · GUIDE_FMT · GUIDE_INDENT · GUIDE_COLS · GUIDE_BRACE · TAME_STYLE · STYLE · ELDER_OBO · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 56 appended · chapter four 8/16")
PY
