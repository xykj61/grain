#!/bin/sh
# Append Glow almanac seat 51 from TB cache-inplace census (e45).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 51\.' "$ALMANAC"; then
  echo "almanac seat 51 already present"
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
if "### 51." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Four (2 of 16)",
    "## Chapter Four (3 of 16)",
    1,
)
entry = (
    "### 51. Cache stays singular; larger structs initialize in place.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_cache_inplace_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_cache_inplace_census_witness.rish` · scan `tools/fixtures/tigerbeetle_cache_inplace_census.sh` · choir `equinox_tigerbeetle_cache_inplace_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_CACHE · GUIDE_NODUP · GUIDE_INPLACE · TAME_CACHE · STYLE · ELDER_HOW · RADIANT, "
    "and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 51 appended · chapter four 3/16")
PY
