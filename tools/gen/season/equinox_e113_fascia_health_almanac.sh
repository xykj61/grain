#!/bin/sh
# Append Glow almanac seat 117 from e113 fascia-health + REDS 38 -- ch8 5/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 117\.' "$ALMANAC"; then
  echo "almanac seat 117 already present"
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
if "### 117." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (4 of 16)",
    "## Chapter Eight (5 of 16)",
    1,
)
entry = (
    "### 117. Equinox e113 fascia-health v1: live surface over total tracked surface "
    "behind planted live + dated controls; REDS row 38 records that on-disk is not "
    "in-the-tree (presence via git ls-files); seat 128 stays reserved; surface census four kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e113_fascia_health_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e113_fascia_health_witness.rish` · "
    "standing `tools/gen/season/fascia_health_witness.rish` · "
    "scan `tools/fixtures/fascia_health_scan.sh` · "
    "equinox scan `tools/fixtures/equinox_e113_fascia_health_scan.sh`\n"
    "Expected control_gate · instruments_tracked · controls_honored=2 · "
    "fascia_health=41 · prove-red RED_on_disk_is_not_in_the_tree · "
    "REDS rows=38 · expect_next=39 · seat_128 reserved · surface_count=4 · "
    "fork not_consumed · shelf end ep045 · baton breach 0. "
    "On-disk is not in-the-tree. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 117 appended · chapter eight 5/16")
PY
