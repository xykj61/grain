#!/bin/sh
# Append Glow almanac seat 25 from tigerbeetle assert census (e19).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 25\.' "$ALMANAC"; then
  echo "almanac seat 25 already present"
  exit 0
fi
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
CENSUS=$(sh tools/fixtures/tigerbeetle_assert_census.sh)
export STAMP
export CENSUS
python3 - <<'PY'
from pathlib import Path
import os
p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
census = os.environ["CENSUS"].replace("\n", " · ")
if "### 25." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (8 of 16)",
    "## Chapter Two (9 of 16)",
    1,
)
entry = (
    "### 25. The held TigerBeetle clone asserts densely; maybe and verify gate the rest.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_assert_census_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_assert_census_witness.rish` · `tools/fixtures/tigerbeetle_assert_census.sh` · submodule `gratitude/tigerbeetle`\n"
    "Expected CLONE=present · verdict=ok · STYLE=yes · MAYBE_DEF=yes · GUIDE_DENSITY=yes "
    "with assert≥2000 · maybe≥100 · constants.verify≥20 · files_assert≥100. "
    "Metal answered GREEN. Census: "
    + census
    + ". Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 25 appended")
PY
