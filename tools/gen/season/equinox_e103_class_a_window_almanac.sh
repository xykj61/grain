#!/bin/sh
# Append Glow almanac seat 107 from equinox e103 Class A + window -- ch7 11/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 107\.' "$ALMANAC"; then
  echo "almanac seat 107 already present"
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
if "### 107." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (10 of 16)",
    "## Chapter Seven (11 of 16)",
    1,
)
entry = (
    "### 107. Equinox e103 Class A refine + window_min: fascia metric i7 excludes four honest Siya-turn anchors; fall baseline is window_min; fascia 92→100.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e103_class_a_window_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e103_class_a_window_witness.rish` · scan `tools/fixtures/equinox_e103_class_a_window_scan.sh` · choir `equinox_e103_class_a_window_choir_witness.rish`\n"
    "Expected control_gate · refine_memcpy paid · metric_rev=i7 · class_a=0 · "
    "class_a_honest_excluded=4 · baseline_kind=window_min · fascia=100 · fork not_consumed · "
    "seats 97–106 · shelf end ep045 · baton breach 0. "
    "A signal that penalizes an honest record is measuring the wrong thing. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 107 appended · chapter seven 11/16")
PY
