#!/bin/sh
# Append Glow almanac seat 112 from equinox e108 ch7 close choir — ch7 FULL 16/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 112\.' "$ALMANAC"; then
  echo "almanac seat 112 already present"
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
if "### 112." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (15 of 16)",
    "## Chapter Seven (16 of 16)",
    1,
)
entry = (
    "### 112. Equinox e108 Chapter Seven close choir: check·test·prepare on seat 112; "
    "REDS rows 34–37 cross (find→git ls-files · verify a zero · fence-aware H1 · no backtick); "
    "bundle as crossing mode; shred opens Chapter Eight; ch5+ch6 close-seat row still parked.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e108_ch7_close_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e108_ch7_close_witness.rish` · "
    "scan `tools/fixtures/equinox_e108_ch7_close_scan.sh` · pin `construction/EQUINOX_SEAT_MAP.md`\n"
    "Expected control_gate · seat_map 112 close choir this sitting · shred opens Chapter Eight · "
    "REDS rows=37 · expect_next=38 · M3/M4 kept · zero_view · fascia i9 hold 92 · "
    "fork not_consumed · seats 97–111 → 112 · shelf end ep045 · baton breach 0. "
    "A chapter-close choir is a check. Metal answered GREEN. Chapter seven fills at sixteen. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
t = t.replace(
    "And may the rest of chapter seven wait for metal, not memory.",
    "And may chapter eight wait for metal, not memory — shred only by Keaton's word.",
    1,
)
p.write_text(t)
print("almanac seat 112 appended · chapter seven full")
PY
