#!/bin/sh
# Append Glow almanac seat 123 from e119 close-seat surfaces -- ch8 11/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 123\.' "$ALMANAC"; then
  echo "almanac seat 123 already present"
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
if "### 123." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (10 of 16)",
    "## Chapter Eight (11 of 16)",
    1,
)
entry = (
    "### 123. Equinox e119 close-seat surfaces: close-seat row answered — a surface "
    "witness claims no seat of its own; ch5 and ch6 surfaces land as tools "
    "(equinox_ch5_surface_witness.rish · equinox_ch6_surface_witness.rish) over "
    "already-GREEN limbs with no chapter-close almanac row and no seat displaced; "
    "e92-shaped census finds six (ch2·ch3·ch4·ch5·ch6·ch7); e92 park lifted by "
    "Keaton fuse kg on the measured answer; seat 128 stays reserved.\n"
    "**Ran:** `sh tools/fixtures/equinox_e119_close_seat_surfaces_scan.sh` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e119_close_seat_surfaces_witness.rish` · "
    "counsel `counsel/date/20260731/20260731-214426_e119-close-seat-surfaces.md` · "
    "scan `tools/fixtures/equinox_e119_close_seat_surfaces_scan.sh`\n"
    "Expected control_gate · instruments_tracked · ch5+ch6 surface scans ok · "
    "surface_count=6 · e92_park=lifted · no_almanac_seat honored · prove-red "
    "RED_claimed_four_while_six · seat_128 reserved · fork EXTEND · handback "
    "not_consumed · shelf end ep045 · baton breach 0. A surface witness claims "
    "no seat of its own. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 123 appended · chapter eight 11/16")
PY
