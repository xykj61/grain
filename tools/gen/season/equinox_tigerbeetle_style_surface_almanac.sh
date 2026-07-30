#!/bin/sh
# Append Glow almanac seat 60 from TB style surface choir (e55).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 60\.' "$ALMANAC"; then
  echo "almanac seat 60 already present"
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
if "### 60." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (11 of 16)",
    "## Chapter Four (12 of 16)",
    1,
)
entry = (
    "### 60. The TigerBeetle style surface choir holds: numbers, dependencies, tooling, and last-stage GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_style_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_tigerbeetle_style_surface_witness.rish`\n"
    "Expected style GREEN · deps GREEN · tooling GREEN · last-stage GREEN, "
    "and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Four style leaves hold as one choir. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 60 appended · chapter four 12/16")
PY
