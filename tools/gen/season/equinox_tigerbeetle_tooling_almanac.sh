#!/bin/sh
# Append Glow almanac seat 58 from TB tooling census (e53).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 58\.' "$ALMANAC"; then
  echo "almanac seat 58 already present"
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
if "### 58." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (9 of 16)",
    "## Chapter Four (10 of 16)",
    1,
)
entry = (
    "### 58. Tooling stays small: Zig first, and scripts prefer Zig when the team grows.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_tooling_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_tooling_census_witness.rish` · scan `tools/fixtures/tigerbeetle_tooling_census.sh` · choir `equinox_tigerbeetle_tooling_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_TOOL · GUIDE_ZIG · GUIDE_SCRIPTS · GUIDE_RIGHT · TAME_TOOL · STYLE · ELDER_DEPS · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 58 appended · chapter four 10/16")
PY
