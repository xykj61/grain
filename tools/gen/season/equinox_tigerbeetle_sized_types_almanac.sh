#!/bin/sh
# Append Glow almanac seat 43 from TB sized-types census (e37).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 43\.' "$ALMANAC"; then
  echo "almanac seat 43 already present"
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
if "### 43." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (10 of 16)",
    "## Chapter Three (11 of 16)",
    1,
)
entry = (
    "### 43. Types carry exact widths; usize stays at the seam, not in design.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_sized_types_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_sized_types_census_witness.rish` · scan `tools/fixtures/tigerbeetle_sized_types_census.sh` · choir `equinox_tigerbeetle_sized_types_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_SIZED · TAME_SIZED · SUPPLEMENT_SIZED · STYLE · WIDTH_CHECK · USIZE_AUDIT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 43 appended · chapter three 11/16")
PY
