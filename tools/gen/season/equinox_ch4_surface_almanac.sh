#!/bin/sh
# Append Glow almanac seat 64 from chapter-four surface choir (e59) -- closes ch4.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 64\.' "$ALMANAC"; then
  echo "almanac seat 64 already present"
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
if "### 64." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (15 of 16)",
    "## Chapter Four (16 of 16)",
    1,
)
entry = (
    "### 64. The chapter-four surface choir holds: DX, mid, style, and IronBeetle GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch4_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_ch4_surface_witness.rish`\n"
    "Expected dx why/how · mid inplace/shrink/bleeds/obo · style numbers/deps/tooling/last · iron COUNT≥34, "
    "and ABSENT refuses on a missing clone or iron shelf. Metal answered GREEN. "
    "Chapter four closes at sixteen; chapter five waits for metal.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
t = t.replace(
    "And may the rest of chapter four wait for metal, not memory.",
    "And may chapter five wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 64 appended · chapter four full")
PY
