#!/bin/sh
# Append Glow almanac seat 114 from e110 — ch8 2/16 · reserve 128 · census finds four.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 114\.' "$ALMANAC"; then
  echo "almanac seat 114 already present"
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
if "### 114." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (1 of 16)",
    "## Chapter Eight (2 of 16)",
    1,
)
entry = (
    "### 114. Equinox e110: e92-shaped surface census finds four (ch2·ch3·ch4·ch7); "
    "ch7 close is findable as equinox_ch7_surface_witness; "
    "Chapter Eight reserves seat 128 for the close choir on day one (content fills 114–127).\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e110_ch8_reserve_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e110_ch8_reserve_witness.rish` · "
    "scan `tools/fixtures/equinox_e110_ch8_reserve_scan.sh` · pin `construction/EQUINOX_SEAT_MAP.md`\n"
    "Expected control_gate · surface_count=4 · chapters 2,3,4,7 · ch5/ch6 absent · "
    "seat_128 reserved_close_choir · ch8 span 113–128 · fork not_consumed · "
    "shelf end ep045 · baton breach 0. "
    "A record that cannot be found by the census that will look for it is not yet a record. "
    "Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 114 appended · chapter eight 2/16")
PY
