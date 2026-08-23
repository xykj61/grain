#!/bin/sh
# Append Glow almanac seat 13 from metal when absent (door 15 wire lab).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 13\.' "$ALMANAC"; then
  echo "almanac seat 13 already present"
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
if "### 13." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter One — Build Journey greens (12 of 16)",
    "## Chapter One — Build Journey greens (13 of 16)",
    1,
)
t = t.replace("Four seats remain.", "Three seats remain.", 1)
entry = (
    "### 13. Two discovery lanes converge tables across a spawn/wait-for wire; fold supply matches both sides.\n"
    "**Ran:** `rishi/bin/rishi run tools/d/discovery_round_trip_wire.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/d/discovery_round_trip_wire.rish` · `comlink/discovery/round_trip_wire.rye`\n"
    "Expected peers=2 · both-sides digest equality · stranger + gossip refuse loud · fold supply parity under timeout 64. "
    "Metal answered GREEN — digest lane-a,lane-b · refuse limbs · supply equal. Elder seat 6 wire both-sides lands as door 15.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 13 appended")
PY
