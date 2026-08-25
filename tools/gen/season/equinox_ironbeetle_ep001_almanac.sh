#!/bin/sh
# Append Glow almanac seat 65 from IronBeetle ep001 census (e60) -- opens chapter five.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 65\.' "$ALMANAC"; then
  echo "almanac seat 65 already present"
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
if "### 65." in t:
    raise SystemExit(0)
chapter = (
    "## Chapter Five (1 of 16)\n\n"
    "Opened from metal at stamp `"
    + stamp
    + "`. Themes arrive after findings; this chapter carries none in advance.\n\n"
)
entry = (
    "### 65. IronBeetle ep001 teaches the wire that needs no parser; checksum meets cast before trust.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep001_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep001_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep001_census.sh` · choir `equinox_ironbeetle_ep001_choir_witness.rish`\n"
    "Expected IRON=present · EP001 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Chapter five opens; clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, chapter + entry + marker, 1)
t = t.replace(
    "And may chapter five wait for metal, not memory.",
    "And may the rest of chapter five wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 65 appended · chapter five open")
PY
