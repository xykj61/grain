#!/bin/sh
# Append Glow almanac seat 39 from TB static-alloc census (e33).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 39\.' "$ALMANAC"; then
  echo "almanac seat 39 already present"
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
if "### 39." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (6 of 16)",
    "## Chapter Three (7 of 16)",
    1,
)
entry = (
    "### 39. Memory is allocated at startup; the held guide, TAME, and clone teach the static law.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_static_alloc_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_static_alloc_census_witness.rish` · scan `tools/fixtures/tigerbeetle_static_alloc_census.sh` · choir `equinox_tigerbeetle_static_alloc_choir_witness.rish`\n"
    "Expected CLONE=present · GUIDE_STATIC · GUIDE_LIMIT · TAME_STATIC · STYLE · static_mentions≥10 · allocator_word≥500 · "
    "init_allocator_files≥20, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 39 appended · chapter three 7/16")
PY
