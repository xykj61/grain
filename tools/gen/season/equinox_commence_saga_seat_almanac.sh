#!/bin/sh
# Append Glow almanac seat 105 from commence saga seat + fork (e101) -- ch7 9/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 105\.' "$ALMANAC"; then
  echo "almanac seat 105 already present"
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
if "### 105." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (8 of 16)",
    "## Chapter Seven (9 of 16)",
    1,
)
entry = (
    "### 105. Commence-arc saga Seated + fork named: Keaton approve seats the narrative; nested return_surface_p59 stays unconsumed (RETURN or EXTEND +128).\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_saga_seat_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/commence_saga_seat_fork_witness.rish` · scan `tools/fixtures/commence_saga_seat_fork_scan.sh` · choir `equinox_commence_saga_seat_choir_witness.rish`\n"
    "Expected control_gate · seat_saga SEATED 20260731.131240 · seat_m9 complement · "
    "seat_fork not_consumed · seat_almanac seats 97–104 · seat_shelf_end=ep045 · baton breach 0. "
    "Seating != consuming the fork. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 105 appended · chapter seven 9/16")
PY
