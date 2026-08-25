#!/bin/sh
# Append Glow almanac seat 81 from IronBeetle ep021 census (e76) -- opens chapter six.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 81\.' "$ALMANAC"; then
  echo "almanac seat 81 already present"
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
if "### 81." in t:
    raise SystemExit(0)
chapter = (
    "## Chapter Six (1 of 16)\n\n"
    "Opened from metal at stamp `"
    + stamp
    + "`. Themes arrive after findings; this chapter carries none in advance.\n\n"
)
entry = (
    "### 81. IronBeetle ep021 writes through one Grid; the queue borrows memory from its callers.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep021_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep021_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep021_census.sh` · choir `equinox_ironbeetle_ep021_choir_witness.rish`\n"
    "Expected IRON=present · EP021 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Chapter six opens; clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, chapter + entry + marker, 1)
t = t.replace(
    "And may the rest of chapter five wait for metal, not memory.",
    "And may the rest of chapter six wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 81 appended · chapter six open")
PY
