#!/bin/sh
# Append Glow almanac seat 119 from e115 instrument suite -- ch8 7/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 119\.' "$ALMANAC"; then
  echo "almanac seat 119 already present"
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
if "### 119." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (6 of 16)",
    "## Chapter Eight (7 of 16)",
    1,
)
entry = (
    "### 119. Equinox e115 instrument-season suite: counsel's nine meters plus "
    "thing-not-name as tenth run together (pass=10 fail=0); prove-red refuses a "
    "manufactured suite pass; remaining work is Keaton-gated (fork · breach · "
    "shred · names); seat 128 stays reserved; surface census four kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e115_instrument_suite_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e115_instrument_suite_witness.rish` · "
    "standing `tools/gen/season/instrument_suite_witness.rish` · "
    "scan `tools/fixtures/instrument_suite_scan.sh` · "
    "equinox scan `tools/fixtures/equinox_e115_instrument_suite_scan.sh`\n"
    "Expected control_gate · instruments_tracked · pass=10 · fail=0 · "
    "prove-red RED_manufactured_suite_pass · remaining=keaton_gated · "
    "seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · "
    "baton breach 0. Seat the suite; do not manufacture meters. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 119 appended · chapter eight 7/16")
PY
