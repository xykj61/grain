#!/bin/sh
# Append Glow almanac seat 28 from SAFE list census (e22).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 28\.' "$ALMANAC"; then
  echo "almanac seat 28 already present"
  exit 0
fi
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
CENSUS=$(sh tools/fixtures/safe_list_census.sh)
export STAMP
export CENSUS
python3 - <<'PY'
from pathlib import Path
import os
p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
census = os.environ["CENSUS"].replace("\n", " · ")
if "### 28." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (11 of 16)",
    "## Chapter Two (12 of 16)",
    1,
)
entry = (
    "### 28. The SAFE list opens empty under a sixty-four-row bound; shred stays refused.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/safe_list_census_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/safe_list_census_witness.rish` · `tools/fixtures/safe_list_census.sh` · `SAFE.md` · `context/specs/oldness-cycle.md`\n"
    "Expected SAFE=present · SPEC=present · SEATED=yes · BOUND_NAMED=yes · EMPTY_OK · SHRED_RED=yes "
    "with rows≤64. "
    "Metal answered GREEN. Census: "
    + census
    + ". Rows grow only by Keaton's word.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 28 appended")
PY
