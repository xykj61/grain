#!/bin/sh
# Append Glow almanac seat 29 from reds choir (e23).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 29\.' "$ALMANAC"; then
  echo "almanac seat 29 already present"
  exit 0
fi
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
export STAMP
# Capture living ledger row count for the entry line
ROWS=$(sh tools/fixtures/reds_ledger_monotone_scan.sh | rg -o 'rows=[0-9]+' | head -1 | cut -d= -f2)
ROWS=${ROWS:-unknown}
export ROWS
python3 - <<'PY'
from pathlib import Path
import os
p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
rows = os.environ["ROWS"]
if "### 29." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (12 of 16)",
    "## Chapter Two (13 of 16)",
    1,
)
entry = (
    "### 29. The reds ledger accretes complete rows; a thin fixture is refused whole.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_reds_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/reds_ledger_witness.rish` · `tools/gen/season/reds_ledger_monotone_witness.rish` · `tools/gen/season/reds_ledger_negative_witness.rish` · choir `equinox_reds_choir_witness.rish`\n"
    "Expected living ledger completeness and 1..N monotone indices, plus fixture refuse "
    "(incomplete_rows) while the live pin stays clean. "
    "Metal answered GREEN. Living rows="
    + rows
    + ". Negative space as loud as welcome.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 29 appended")
PY
