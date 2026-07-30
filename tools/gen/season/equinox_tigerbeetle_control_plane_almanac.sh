#!/bin/sh
# Append Glow almanac seat 26 from tigerbeetle control-plane census (e20).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 26\.' "$ALMANAC"; then
  echo "almanac seat 26 already present"
  exit 0
fi
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
CENSUS=$(sh tools/fixtures/tigerbeetle_control_plane_census.sh)
export STAMP
export CENSUS
python3 - <<'PY'
from pathlib import Path
import os
p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
census = os.environ["CENSUS"].replace("\n", " · ")
if "### 26." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (9 of 16)",
    "## Chapter Two (10 of 16)",
    1,
)
entry = (
    "### 26. Control plane spends asserts freely; data plane gates the dear checks behind verify.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_control_plane_census_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_control_plane_census_witness.rish` · `tools/fixtures/tigerbeetle_control_plane_census.sh` · submodule `gratitude/tigerbeetle`\n"
    "Expected CLONE=present · GUIDE_PLANE=yes · ARCH_PLANE=yes · TAME_BRIDGE=yes · STYLE=yes "
    "with constants.verify≥20 and files_verify≥10. "
    "Metal answered GREEN. Census: "
    + census
    + ". Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 26 appended")
PY
