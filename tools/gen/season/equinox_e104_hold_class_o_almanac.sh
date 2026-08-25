#!/bin/sh
# Append Glow almanac seat 108 from equinox e104 hold + Class O -- ch7 12/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 108\.' "$ALMANAC"; then
  echo "almanac seat 108 already present"
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
if "### 108." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (11 of 16)",
    "## Chapter Seven (12 of 16)",
    1,
)
entry = (
    "### 108. Equinox e104 hold Class A disclosed + Class O rooms: fascia metric i8 holds four honest anchors with reason named (not excluded); Class O room home in SHRED_PREP; fascia 100→92; window_min kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e104_hold_class_o_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e104_hold_class_o_witness.rish` · scan `tools/fixtures/equinox_e104_hold_class_o_scan.sh` · choir `equinox_e104_hold_class_o_choir_witness.rish`\n"
    "Expected control_gate · metric_rev=i8 · class_a=4 · class_a_held_disclosed=4 · "
    "law=hold_not_exclude · baseline_kind=window_min · fascia=92 · Class O rooms · "
    "no paths seated · fork not_consumed · seats 97–107 · shelf end ep045 · baton breach 0. "
    "Exclusion hides; holding discloses. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 108 appended · chapter seven 12/16")
PY
