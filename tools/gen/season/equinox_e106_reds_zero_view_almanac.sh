#!/bin/sh
# Append Glow almanac seat 110 from equinox e106 REDS zero-view -- ch7 14/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 110\.' "$ALMANAC"; then
  echo "almanac seat 110 already present"
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
if "### 110." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (13 of 16)",
    "## Chapter Seven (14 of 16)",
    1,
)
entry = (
    "### 110. Equinox e106 REDS zero-view: ledger row 33 records that a zero names the instrument's view, never the world; planted empty-view + archive-fall control; M3/M4 home land already consumed on e105; fascia i9 hold kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e106_reds_zero_view_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e106_reds_zero_view_witness.rish` · scan `tools/fixtures/equinox_e106_reds_zero_view_scan.sh` · choir `equinox_e106_reds_zero_view_choir_witness.rish`\n"
    "Expected control_gate · REDS rows=33 · monotone expect_next=34 · "
    "zero_view planted · prove-red refuses · m3_m4 e105_consumed · "
    "metric_rev=i9 · hold_not_exclude · fascia=92 · fork not_consumed · "
    "seats 97–109 · shelf end ep045 · baton breach 0. "
    "Look where the thing would be before calling it gone. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 110 appended · chapter seven 14/16")
PY
