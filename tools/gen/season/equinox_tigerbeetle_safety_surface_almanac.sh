#!/bin/sh
# Append Glow almanac seat 42 from TB safety surface choir (e36).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 42\.' "$ALMANAC"; then
  echo "almanac seat 42 already present"
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
if "### 42." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (9 of 16)",
    "## Chapter Three (10 of 16)",
    1,
)
entry = (
    "### 42. The TigerBeetle safety surface choir holds: static, seventy-line, and control-flow GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_safety_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_tigerbeetle_safety_surface_witness.rish`\n"
    "Expected static GREEN · seventy GREEN · control-flow GREEN, "
    "and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. "
    "Three safety leaves hold as one choir. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 42 appended · chapter three 10/16")
PY
