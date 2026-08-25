#!/bin/sh
# Append Glow almanac seat 48 from chapter-three surface choir (e42) -- closes ch3.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 48\.' "$ALMANAC"; then
  echo "almanac seat 48 already present"
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
if "### 48." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (15 of 16)",
    "## Chapter Three (16 of 16)",
    1,
)
entry = (
    "### 48. The chapter-three surface choir holds: wing, TB safety, TB performance, and naming GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch3_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_ch3_surface_witness.rish`\n"
    "Expected wing halls=4/breach=0 · safety static/seventy/flow · performance sized/batching/explicit · naming, "
    "and verdict=missing_wing on an absent path. Metal answered GREEN. "
    "Chapter three closes at sixteen; chapter four waits for metal.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
t = t.replace(
    "And may the rest of chapter three wait for metal, not memory.",
    "And may chapter four wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 48 appended · chapter three full")
PY
