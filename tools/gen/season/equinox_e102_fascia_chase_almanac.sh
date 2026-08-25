#!/bin/sh
# Append Glow almanac seat 106 from equinox e102 fascia chase -- ch7 10/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 106\.' "$ALMANAC"; then
  echo "almanac seat 106 already present"
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
if "### 106." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (9 of 16)",
    "## Chapter Seven (10 of 16)",
    1,
)
entry = (
    "### 106. Equinox e102 fascia chase: re-cut meters; clear memcpy app and signal-1 prose; hold Class A paper lean at 4; fascia 85→92.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e102_fascia_chase_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e102_fascia_chase_witness.rish` · scan `tools/fixtures/equinox_e102_fascia_chase_scan.sh` · choir `equinox_e102_fascia_chase_choir_witness.rish`\n"
    "Expected control_gate · chase_saga SEATED · chase_memcpy · chase_fascia_grade=92 · "
    "chase_class_a=4 paper lean · chase_fork not_consumed · seats 97–105 · shelf end ep045 · baton breach 0. "
    "Pins reform when a round re-cuts. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 106 appended · chapter seven 10/16")
PY
