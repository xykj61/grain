#!/bin/sh
# Append Glow almanac seat 19 from bounded-tower metal (e13).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 19\.' "$ALMANAC"; then
  echo "almanac seat 19 already present"
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
if "### 19." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (2 of 16)",
    "## Chapter Two (3 of 16)",
    1,
)
entry = (
    "### 19. The classic tower solves with an explicit bounded stack; seventeen rings refuse whole.\n"
    "**Ran:** `rishi/bin/rishi run tools/e/edu_tower_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/e/edu_tower_witness.rish` · `edu/tower/bounded_tower.rye`\n"
    "Expected solve(3)=7 moves · TooManyRings at 17 · tally/stack beneath · tutorial pinned. "
    "Metal answered GREEN. Recursion stays out; the depth is named.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 19 appended")
PY
