#!/bin/sh
# Append Glow almanac seat 32 from chapter-two surface choir (e26) -- closes ch2.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 32\.' "$ALMANAC"; then
  echo "almanac seat 32 already present"
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
if "### 32." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (15 of 16)",
    "## Chapter Two (16 of 16)",
    1,
)
entry = (
    "### 32. The chapter-two surface choir holds: SAFE, reds, voice, and baton GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch2_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_ch2_surface_witness.rish`\n"
    "Expected SAFE census · reds complete/monotone/refuse · voice sites=6/refuse · baton halls=13/breach=0/absent refuse "
    "each GREEN in one choir. Metal answered GREEN. Chapter two closes at sixteen; chapter three waits for metal.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
t = t.replace(
    "And may chapter two wait for metal, not memory.",
    "And may chapter three wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 32 appended · chapter two full")
PY
