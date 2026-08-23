#!/bin/sh
# Append Glow almanac seat 111 from equinox e107 seat map — ch7 15/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 111\.' "$ALMANAC"; then
  echo "almanac seat 111 already present"
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
if "### 111." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (14 of 16)",
    "## Chapter Seven (15 of 16)",
    1,
)
entry = (
    "### 111. Equinox e107 seat map: corrected close path after seat 110 spent on e106; proposes seat 112 CLOSE CHOIR as check·test·prepare; bundle as crossing mode; shred Keaton-gated; ch5+ch6 close-seat row still parked.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e107_seat_map_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e107_seat_map_witness.rish` · scan `tools/fixtures/equinox_seat_map_scan.sh` · pin `construction/EQUINOX_SEAT_MAP.md`\n"
    "Expected control_gate · seat_map 110 spent · 112 close choir proposed · "
    "bundle crossing mode · shred Keaton-gated · fork not_consumed · "
    "seats 97–110 · shelf end ep045 · baton breach 0. "
    "Look at spent seats before naming the remaining map. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 111 appended · chapter seven 15/16")
PY
