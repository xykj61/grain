#!/bin/sh
# Append Glow almanac seat 52 from TB shrink-scope census (e46).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 52\.' "$ALMANAC"; then
  echo "almanac seat 52 already present"
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
if "### 52." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (3 of 16)",
    "## Chapter Four (4 of 16)",
    1,
)
entry = (
    "### 52. Scope stays small; check meets use before the gap opens.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_shrink_scope_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_shrink_scope_census_witness.rish` · scan `tools/fixtures/tigerbeetle_shrink_scope_census.sh` · choir `equinox_tigerbeetle_shrink_scope_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_SHRINK · GUIDE_POCPOU · TAME_SHRINK · STYLE · ELDER_CACHE · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 52 appended · chapter four 4/16")
PY
