#!/bin/sh
# Append Glow almanac seat 101 from commence M6 see (e97) -- ch7 5/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 101\.' "$ALMANAC"; then
  echo "almanac seat 101 already present"
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
if "### 101." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (4 of 16)",
    "## Chapter Seven (5 of 16)",
    1,
)
entry = (
    "### 101. Commence M6 see: eyes census behind the proven census control — almanac seats, waymarks, IronBeetle shelf end, museum, inventory.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m6_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/commence_m6_see_witness.rish` · scan `tools/fixtures/commence_m6_see_scan.sh` · choir `equinox_commence_m6_choir_witness.rish`\n"
    "Expected control_gate=honored · see_almanac seats 97–100 · see_waymarks e93–e96 · "
    "see_shelf_end=ep045 · see_ep046=absent · baton breach 0 · inventory behind control. "
    "See != run. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 101 appended · chapter seven 5/16")
PY
