#!/bin/sh
# Append Glow almanac seat 69 from IronBeetle ep006 census (e64).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 69\.' "$ALMANAC"; then
  echo "almanac seat 69 already present"
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
if "### 69." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Five (4 of 16)",
    "## Chapter Five (5 of 16)",
    1,
)
entry = (
    "### 69. IronBeetle ep006 chooses Zig where never-frees make temporal bugs rare.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep006_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep006_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep006_census.sh` · choir `equinox_ironbeetle_ep006_choir_witness.rish`\n"
    "Expected IRON=present · EP006 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Ep003 and ep007 gaps stay open. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 69 appended · chapter five 5/16")
PY
