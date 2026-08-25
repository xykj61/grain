#!/bin/sh
# Append Glow almanac seat 97 from IronBeetle ep044 census (e93) -- opens chapter seven.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 97\.' "$ALMANAC"; then
  echo "almanac seat 97 already present"
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
if "### 97." in t:
    raise SystemExit(0)
chapter = (
    "## Chapter Seven (1 of 16)\n\n"
    "Opened from metal at stamp `"
    + stamp
    + "`. Themes arrive after findings; this chapter carries none in advance. "
    "Ch5 and ch6 surface closes stay parked per e92 ruling D until a close-seat row is seated.\n\n"
)
entry = (
    "### 97. IronBeetle ep044 traces everything we know from the first byte: two jobs of consensus, and honesty about unfinished code.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep044_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/ironbeetle_ep044_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep044_census.sh` · choir `equinox_ironbeetle_ep044_choir_witness.rish`\n"
    "Expected IRON=present · EP044 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, "
    "and verdict=absent on a missing iron shelf. Metal answered GREEN. "
    "Chapter seven opens under e76 law; clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, chapter + entry + marker, 1)
t = t.replace(
    "And may the rest of chapter six wait for metal, not memory.",
    "And may the rest of chapter seven wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 97 appended · chapter seven open")
PY
