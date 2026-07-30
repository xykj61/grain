#!/bin/sh
# Append Glow almanac seat 40 from TB seventy-line census (e34).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 40\.' "$ALMANAC"; then
  echo "almanac seat 40 already present"
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
if "### 40." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (7 of 16)",
    "## Chapter Three (8 of 16)",
    1,
)
entry = (
    "### 40. Functions hold a hard seventy-line bound; tidy ratchets the rule from the clone.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_seventy_line_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_seventy_line_census_witness.rish` · scan `tools/fixtures/tigerbeetle_seventy_line_census.sh` · choir `equinox_tigerbeetle_seventy_line_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_SEVENTY · TAME_SEVENTY · SUPPLEMENT_SEVENTY · STYLE · TIDY · RATCHET, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 40 appended · chapter three 8/16")
PY
