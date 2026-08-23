#!/bin/sh
# Append Glow almanac seat 21 from tower frame-bite metal (e15).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 21\.' "$ALMANAC"; then
  echo "almanac seat 21 already present"
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
if "### 21." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (4 of 16)",
    "## Chapter Two (5 of 16)",
    1,
)
entry = (
    "### 21. A capacity-one stack refuses a second push; the tower's frame bound bites from a fixture.\n"
    "**Ran:** `rishi/bin/rishi run tools/e/edu_tower_frame_bite_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/e/edu_tower_frame_bite_witness.rish` · `edu/tower/frame_bound_overpush.rye`\n"
    "Expected overpush EXIT=1 with assertion failure · welcome tower still GREEN. "
    "Metal answered GREEN. Negative space as loud as welcome.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 21 appended")
PY
