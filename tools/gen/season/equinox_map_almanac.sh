#!/bin/sh
# Append Glow almanac seat 14 from metal when equinox map witness is GREEN (e7).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 14\.' "$ALMANAC"; then
  echo "almanac seat 14 already present"
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
if "### 14." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter One — Build Journey greens (13 of 16)",
    "## Chapter One — Build Journey greens (14 of 16)",
    1,
)
t = t.replace("Three seats remain.", "Two seats remain.", 1)
entry = (
    "### 14. The equinox map sits as Brix data; a witness checks four flanks and the kendras.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_map_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_map_witness.rish` · `context/equinox_map.brix`\n"
    "Expected four blocks · flanks cover 1..12 once · descending wrap · kendras {1,4,7,10} · "
    "H10-north reason seated · negative fixtures fail. Metal answered GREEN. Glow is code; Brix is data.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 14 appended")
PY
