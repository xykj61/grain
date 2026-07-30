#!/bin/sh
# Append Glow almanac seat 16 from metal when equinox surface choir is GREEN (e10).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 16\.' "$ALMANAC"; then
  echo "almanac seat 16 already present"
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
if "### 16." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter One — Build Journey greens (15 of 16)",
    "## Chapter One — Build Journey greens (16 of 16)",
    1,
)
t = t.replace("One seat remains.", "Chapter one is full.", 1)
entry = (
    "### 16. The Equinox surface choir holds: e0 bow, map, and foundations GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_surface_witness.rish`\n"
    "Expected e0 · equinox_map · equinox_foundations each GREEN in one choir. Metal answered GREEN. "
    "Chapter one closes at sixteen; prose create-prep did not earn this seat.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
# close the one-seat footer if still present
t = t.replace(
    "And may the remaining one seat wait for metal, not memory.",
    "And may chapter two wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 16 appended")
PY
