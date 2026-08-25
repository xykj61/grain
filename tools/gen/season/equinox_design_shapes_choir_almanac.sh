#!/bin/sh
# Append Glow almanac seat 33 from design-shapes choir (e27) -- opens chapter three.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 33\.' "$ALMANAC"; then
  echo "almanac seat 33 already present"
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
if "### 33." in t:
    raise SystemExit(0)
chapter = (
    "## Chapter Three (1 of 16)\n\n"
    "Opened from metal at stamp `"
    + stamp
    + "`. Themes arrive after findings; this chapter carries none in advance.\n\n"
)
entry = (
    "### 33. The design-shapes wing holds four halls; a missing wing path is refused whole.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_design_shapes_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/design_shapes_census_witness.rish` · scan `tools/fixtures/design_shapes_census_scan.sh` · choir `equinox_design_shapes_choir_witness.rish`\n"
    "Expected halls_expected=4 · halls_absent=0 · census_breach_count=0, and verdict=missing_wing on an absent path. "
    "Metal answered GREEN. Chapter three opens; builds inherit, they do not invent.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
# Insert chapter header + seat before the closing blessing.
t = t.replace(marker, chapter + entry + marker, 1)
t = t.replace(
    "And may chapter three wait for metal, not memory.",
    "And may the rest of chapter three wait for metal, not memory.",
    1,
)
p.write_text(t)
print("almanac seat 33 appended · chapter three open")
PY
