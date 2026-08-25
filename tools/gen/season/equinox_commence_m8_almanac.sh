#!/bin/sh
# Append Glow almanac seat 103 from commence M8 saga (e99) -- ch7 7/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 103\.' "$ALMANAC"; then
  echo "almanac seat 103 already present"
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
if "### 103." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (6 of 16)",
    "## Chapter Seven (7 of 16)",
    1,
)
entry = (
    "### 103. Commence M8 saga: the ordered commence-arc story behind the proven control — eight waymark beats, seats 97–102, shelf end ep045.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m8_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/commence_m8_saga_witness.rish` · scan `tools/fixtures/commence_m8_saga_scan.sh` · choir `equinox_commence_m8_choir_witness.rish`\n"
    "Expected control_gate · saga_home · saga_beats=8 · saga_almanac seats 97–102 · "
    "saga_shelf_end=ep045 · saga_ep046=absent · baton breach 0. "
    "Saga != see != weave. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 103 appended · chapter seven 7/16")
PY
