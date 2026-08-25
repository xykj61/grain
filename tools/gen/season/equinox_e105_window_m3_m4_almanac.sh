#!/bin/sh
# Append Glow almanac seat 109 from equinox e105 window carry + M3/M4 -- ch7 13/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 109\.' "$ALMANAC"; then
  echo "almanac seat 109 already present"
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
if "### 109." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (12 of 16)",
    "## Chapter Seven (13 of 16)",
    1,
)
entry = (
    "### 109. Equinox e105 window carry + M3/M4 home land: fascia metric i9 carries the window across revisions and restores the arc fall 100/85/92 (−15); M3 oldness census and M4 radiant H1 fence land from named paths; Class A i8 hold kept; fascia 92.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e105_window_m3_m4_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e105_window_m3_m4_witness.rish` · scan `tools/fixtures/equinox_e105_window_m3_m4_scan.sh` · choir `equinox_e105_window_m3_m4_choir_witness.rish`\n"
    "Expected control_gate · metric_rev=i9 · window_carry=honored · window_min=85 · "
    "window_arc_fall=-15 · class_a held 4 · hold_not_exclude · fascia=92 · "
    "M3 four_fifths · SAFE 0/64 · M4 fence-aware · governing template · "
    "fork not_consumed · seats 97–108 · shelf end ep045 · baton breach 0. "
    "A revision carries its window. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 109 appended · chapter seven 13/16")
PY
