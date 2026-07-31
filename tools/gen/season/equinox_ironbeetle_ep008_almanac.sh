#!/bin/sh
# Append Glow almanac seat 70 from IronBeetle ep008 census (e65).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 70\.' "$ALMANAC"; then
  echo "almanac seat 70 already present"
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
if "### 70." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (5 of 16)",
    "## Chapter Five (6 of 16)",
    1,
)
entry = (
    "### 70. IronBeetle ep008 runs many ballots so everyone may lead and one truth holds.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep008_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep008_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep008_census.sh` · choir `equinox_ironbeetle_ep008_choir_witness.rish`\n"
    "Expected IRON=present · EP008 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Ep003 and ep007 gaps stay open. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 70 appended · chapter five 6/16")
PY
