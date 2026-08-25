#!/bin/sh
# Append Glow almanac seat 116 from e112 planted date-dialect witness -- ch8 4/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 116\.' "$ALMANAC"; then
  echo "almanac seat 116 already present"
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
if "### 116." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (3 of 16)",
    "## Chapter Eight (4 of 16)",
    1,
)
entry = (
    "### 116. Equinox e112 planted date-dialect witness: C1 hyphenated control counted; "
    "C2 compact control not counted as hyphen; library 17 of 17 compact (one_dialect); "
    "prove-red refuses; seat 128 stays reserved; surface census four kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e112_date_dialect_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e112_date_dialect_witness.rish` · "
    "standing `tools/gen/season/date_dialect_witness.rish` · "
    "scan `tools/fixtures/date_dialect_scan.sh` · "
    "equinox scan `tools/fixtures/equinox_e112_date_dialect_witness_scan.sh`\n"
    "Expected control_gate · controls_honored=2 · hyphenated=0 · compact=17 · "
    "verdict=one_dialect · prove-red RED_C2-compact · elder e111 · seat_128 reserved · "
    "surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. "
    "A duty with no witness has no seat, and a duty with no seat never lands. "
    "Carry the transformation, never the claim that it was done. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 116 appended · chapter eight 4/16")
PY
