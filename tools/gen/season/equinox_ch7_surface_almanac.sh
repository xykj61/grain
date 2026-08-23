#!/bin/sh
# Append Glow almanac seat 113 from chapter-seven surface (e109) — opens chapter eight.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 113\.' "$ALMANAC"; then
  echo "almanac seat 113 already present"
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
if "### 113." in t:
    raise SystemExit(0)
chapter = (
    "## Chapter Eight (1 of 16)\n\n"
    "Opened from metal at stamp `"
    + stamp
    + "`. Themes arrive after findings; this chapter carries none in advance. "
    "Bundle and shred stay itinerary modes; Class O paths await Keaton's word.\n\n"
)
entry = (
    "### 113. Equinox e109 chapter-seven surface: fifteen limbs (seats 97–111) GREEN together; "
    "itinerary refined so bundle and shred are modes (not seats); only the close choir was a seat; "
    "ch5+ch6 close-seat row still parked.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch7_surface_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_ch7_surface_witness.rish` · "
    "scan `tools/fixtures/equinox_ch7_surface_scan.sh` · pin `construction/EQUINOX_SEAT_MAP.md`\n"
    "Expected shelf ep044/ep045 · commence control/M5/M6/shed/M8/M9/saga-seat · "
    "meter e102–e105 · zero-view · REDS monotone · itinerary modes · "
    "fork not_consumed · shelf end ep045 · ABSENT refuses · baton breach 0. "
    "A duty is not a seat unless the almanac says so. Metal answered GREEN. "
    "Chapter eight opens; invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, chapter + entry + marker, 1)
t = t.replace(
    "And may chapter eight wait for metal, not memory — shred only by Keaton's word.",
    "And may the rest of chapter eight wait for metal, not memory — shred only by Keaton's word.",
    1,
)
p.write_text(t)
print("almanac seat 113 appended · chapter eight open")
PY
