#!/bin/sh
# Append Glow almanac seat 99 from census control (e95) -- ch7 3/16 - commence arc.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 99\.' "$ALMANAC"; then
  echo "almanac seat 99 already present"
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
if "### 99." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (2 of 16)",
    "## Chapter Seven (3 of 16)",
    1,
)
entry = (
    "### 99. Census control seats planted positives and a planted negative: no total until the control reads; naive H1 refuses.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_census_control_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/census_control_witness.rish` · scan `tools/fixtures/census_control_scan.sh` · choir `equinox_census_control_choir_witness.rish`\n"
    "Expected duties_honored=3 · true=1 · naive=4 · marker stamp in shape · glow cache untracked, "
    "and prove-red (naive-as-total) exits non-zero. Metal answered GREEN. "
    "Commence arc fills chapter seven after the IronBeetle written shelf ended; invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 99 appended · chapter seven 3/16")
PY
