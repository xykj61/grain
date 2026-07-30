#!/bin/sh
# Append Glow almanac seat 47 from TB naming census (e41).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 47\.' "$ALMANAC"; then
  echo "almanac seat 47 already present"
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
if "### 47." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (14 of 16)",
    "## Chapter Three (15 of 16)",
    1,
)
entry = (
    "### 47. Names carry nouns and verbs just right; units trail, abbreviation stays out.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_naming_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_naming_census_witness.rish` · scan `tools/fixtures/tigerbeetle_naming_census.sh` · choir `equinox_tigerbeetle_naming_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_NAMING · GUIDE_UNITS · GUIDE_ABBREV · TAME_NAMING · TAME_UNITS · "
    "SUPPLEMENT_NAMING · STYLE · LEXICON, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 47 appended · chapter three 15/16")
PY
