#!/bin/sh
# Append Glow almanac seat 46 from TB performance surface choir (e40).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 46\.' "$ALMANAC"; then
  echo "almanac seat 46 already present"
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
if "### 46." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (13 of 16)",
    "## Chapter Three (14 of 16)",
    1,
)
entry = (
    "### 46. The TigerBeetle performance surface choir holds: sized-types, batching, and be-explicit GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_perf_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_tigerbeetle_perf_surface_witness.rish`\n"
    "Expected sized GREEN · batching GREEN · be-explicit GREEN, "
    "and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. "
    "Three performance leaves hold as one choir. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 46 appended · chapter three 14/16")
PY
