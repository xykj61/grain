#!/bin/sh
# Append Glow almanac seat 49 from TB say-why census (e43) -- opens chapter four.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 49\.' "$ALMANAC"; then
  echo "almanac seat 49 already present"
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
if "### 49." in t:
    raise SystemExit(0)
chapter = (
    "## Chapter Four (1 of 16)\n\n"
    "Opened from metal at stamp `"
    + stamp
    + "`. Themes arrive after findings; this chapter carries none in advance.\n\n"
)
entry = (
    "### 49. Comments say why; they are sentences, and Radiant voice keeps them honest.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_say_why_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_say_why_census_witness.rish` · scan `tools/fixtures/tigerbeetle_say_why_census.sh` · choir `equinox_tigerbeetle_say_why_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_WHY · GUIDE_HOW · GUIDE_SENTENCE · TAME_WHY · TAME_SENTENCE · "
    "TAME_RADIANT · SUPPLEMENT_WHY · STYLE · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. "
    "Chapter four opens; clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, chapter + entry + marker, 1)
t = t.replace(
    "And may chapter four wait for metal, not memory.",
    "And may the rest of chapter four wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 49 appended · chapter four open")
PY
