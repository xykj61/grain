#!/bin/sh
# Append Glow almanac seat 15 from metal when equinox foundations witness is GREEN (e8).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 15\.' "$ALMANAC"; then
  echo "almanac seat 15 already present"
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
if "### 15." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter One — Build Journey greens (14 of 16)",
    "## Chapter One — Build Journey greens (15 of 16)",
    1,
)
t = t.replace("Two seats remain.", "One seat remains.", 1)
entry = (
    "### 15. Twelve foundations distribute three per equinox; the descriptor joins the map flanks.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_foundations_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_foundations_witness.rish` · `context/equinox_foundations.brix`\n"
    "Expected houses 1..12 once · three per equinox · join equinox_map flanks · kendras angular · "
    "wrong-home and missing-house fixtures fail. Metal answered GREEN. The e7 finding became data.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 15 appended")
PY
