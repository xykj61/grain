#!/bin/sh
# Append Glow almanac seat 67 from IronBeetle ep004 census (e62).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 67\.' "$ALMANAC"; then
  echo "almanac seat 67 already present"
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
if "### 67." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (2 of 16)",
    "## Chapter Five (3 of 16)",
    1,
)
entry = (
    "### 67. IronBeetle ep004 refuses to shard the ledger; one serial core, pipelined rest.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep004_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep004_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep004_census.sh` · choir `equinox_ironbeetle_ep004_choir_witness.rish`\n"
    "Expected IRON=present · EP004 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Ep003 gap stays open. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 67 appended · chapter five 3/16")
PY
