#!/bin/sh
# Append Glow almanac seat 61 from TB DX surface choir (e56).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 61\.' "$ALMANAC"; then
  echo "almanac seat 61 already present"
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
if "### 61." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (12 of 16)",
    "## Chapter Four (13 of 16)",
    1,
)
entry = (
    "### 61. The TigerBeetle DX surface choir holds: say-why and say-how GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_dx_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_tigerbeetle_dx_surface_witness.rish`\n"
    "Expected say-why GREEN · say-how GREEN, "
    "and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Two DX leaves hold as one choir. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 61 appended · chapter four 13/16")
PY
