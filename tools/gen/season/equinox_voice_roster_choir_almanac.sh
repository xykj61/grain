#!/bin/sh
# Append Glow almanac seat 30 from voice-roster choir (e24).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 30\.' "$ALMANAC"; then
  echo "almanac seat 30 already present"
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
if "### 30." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (13 of 16)",
    "## Chapter Two (14 of 16)",
    1,
)
entry = (
    "### 30. The standing voice is declared at six sites; an undeclared name is refused.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_voice_roster_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/voice_roster_witness.rish` · `tools/gen/season/voice_roster_negative_witness.rish` · choir `equinox_voice_roster_choir_witness.rish`\n"
    "Expected sites=6 · drift=0 for Riyo, and verdict=drift for an undeclared voice while the standing call stays clean. "
    "Metal answered GREEN. Negative space as loud as welcome.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 30 appended")
PY
