#!/bin/sh
# Append Glow almanac seat 38 from design-shapes surface choir (e32).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 38\.' "$ALMANAC"; then
  echo "almanac seat 38 already present"
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
if "### 38." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (5 of 16)",
    "## Chapter Three (6 of 16)",
    1,
)
entry = (
    "### 38. The design-shapes surface choir holds: wing, bounds, resin, fact-fold, and tend GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_design_shapes_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_design_shapes_surface_witness.rish`\n"
    "Expected wing halls=4/breach=0 · bounds pairs=10 · resin bound 12 · fact-fold supply=872/purity · tend waymarks=3, "
    "and verdict=missing_wing on an absent path. Metal answered GREEN. Four halls and the wing hold as one choir.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 38 appended · chapter three 6/16")
PY
