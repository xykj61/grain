#!/bin/sh
# Append Glow almanac seat 104 from commence M9 ascent (e100) -- ch7 8/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 104\.' "$ALMANAC"; then
  echo "almanac seat 104 already present"
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
if "### 104." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (7 of 16)",
    "## Chapter Seven (8 of 16)",
    1,
)
entry = (
    "### 104. Commence M9 ascent: handbacks consumed outward, nested return_surface_p59 waiting, commence-arc prose saga PROPOSED — nine waymark beats, seats 97–103, shelf end ep045.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m9_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/commence_m9_ascent_witness.rish` · scan `tools/fixtures/commence_m9_ascent_scan.sh` · choir `equinox_commence_m9_choir_witness.rish`\n"
    "Expected control_gate · ascent_saga PROPOSED · ascent_beats=9 · ascent_handbacks · "
    "ascent_nested=return_surface_p59 not_consumed · ascent_almanac seats 97–103 · "
    "ascent_shelf_end=ep045 · ascent_ep046=absent · baton breach 0. "
    "Ascent != saga != weave. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 104 appended · chapter seven 8/16")
PY
