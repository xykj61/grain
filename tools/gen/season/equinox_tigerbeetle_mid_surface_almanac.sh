#!/bin/sh
# Append Glow almanac seat 62 from TB mid surface choir (e57).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 62\.' "$ALMANAC"; then
  echo "almanac seat 62 already present"
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
if "### 62." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (13 of 16)",
    "## Chapter Four (14 of 16)",
    1,
)
entry = (
    "### 62. The TigerBeetle mid surface choir holds: cache leaves and off-by-one GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_mid_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_tigerbeetle_mid_surface_witness.rish`\n"
    "Expected inplace GREEN · shrink GREEN · bleeds GREEN · off-by-one GREEN, "
    "and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Off-by-one joins the cache three. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 62 appended · chapter four 14/16")
PY
