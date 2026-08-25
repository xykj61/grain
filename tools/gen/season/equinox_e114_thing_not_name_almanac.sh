#!/bin/sh
# Append Glow almanac seat 118 from e114 thing-not-name + REDS 39 -- ch8 6/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 118\.' "$ALMANAC"; then
  echo "almanac seat 118 already present"
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
if "### 118." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (5 of 16)",
    "## Chapter Eight (6 of 16)",
    1,
)
entry = (
    "### 118. Equinox e114 thing-not-name: planted emitter proves a value can live "
    "without its key in the filename; shed emits fascia_health_now and standalone "
    "emits fascia_health (two roofs); REDS row 39 records look for the thing, not "
    "for the name of the thing; seat 128 stays reserved; surface census four kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e114_thing_not_name_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e114_thing_not_name_witness.rish` · "
    "standing `tools/gen/season/thing_not_name_witness.rish` · "
    "scan `tools/fixtures/thing_not_name_scan.sh` · "
    "equinox scan `tools/fixtures/equinox_e114_thing_not_name_scan.sh`\n"
    "Expected control_gate · instruments_tracked · demo_meter=7 · "
    "name_hits_demo_meter=0 · roofs=2 · prove-red RED_looked_for_name_not_thing · "
    "REDS rows=39 · expect_next=40 · seat_128 reserved · surface_count=4 · "
    "fork not_consumed · shelf end ep045 · baton breach 0. "
    "Look for the thing, not for the name of the thing. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 118 appended · chapter eight 6/16")
PY
