#!/bin/sh
# Append Glow almanac seat 24 from tigerbeetle void census (e18).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 24\.' "$ALMANAC"; then
  echo "almanac seat 24 already present"
  exit 0
fi
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
CENSUS=$(sh tools/fixtures/tigerbeetle_void_census.sh)
export STAMP
export CENSUS
python3 - <<'PY'
from pathlib import Path
import os
p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
census = os.environ["CENSUS"].replace("\n", " · ")
if "### 24." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (7 of 16)",
    "## Chapter Two (8 of 16)",
    1,
)
entry = (
    "### 24. The held TigerBeetle clone's src returns void often; density is measured, not assumed.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_void_census_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_void_census_witness.rish` · `tools/fixtures/tigerbeetle_void_census.sh` · submodule `gratitude/tigerbeetle`\n"
    "Expected CLONE=present · verdict=ok · STYLE=yes with files≥100 and total_voidish≥1000. "
    "Metal answered GREEN. Census: "
    + census
    + ". Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 24 appended")
PY
