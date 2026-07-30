#!/bin/sh
# Append Glow almanac seat 45 from TB be-explicit census (e39).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 45\.' "$ALMANAC"; then
  echo "almanac seat 45 already present"
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
if "### 45." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (12 of 16)",
    "## Chapter Three (13 of 16)",
    1,
)
entry = (
    "### 45. Hot loops stand alone; the compiler proves less, the reader sees more.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_be_explicit_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_be_explicit_census_witness.rish` · scan `tools/fixtures/tigerbeetle_be_explicit_census.sh` · choir `equinox_tigerbeetle_be_explicit_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_EXPLICIT · GUIDE_HOTLOOP · TAME_EXPLICIT · STYLE · COMPACTION, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 45 appended · chapter three 13/16")
PY
