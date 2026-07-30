#!/bin/sh
# Append Glow almanac seat 54 from TB cache surface choir (e48).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 54\.' "$ALMANAC"; then
  echo "almanac seat 54 already present"
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
if "### 54." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (5 of 16)",
    "## Chapter Four (6 of 16)",
    1,
)
entry = (
    "### 54. The TigerBeetle cache surface choir holds: inplace, shrink-scope, and buffer-bleeds GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_cache_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_tigerbeetle_cache_surface_witness.rish`\n"
    "Expected inplace GREEN · shrink GREEN · bleeds GREEN, "
    "and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. "
    "Three cache leaves hold as one choir. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 54 appended · chapter four 6/16")
PY
