#!/bin/sh
# Append Glow almanac seat 102 from commence M7 shed census weave (e98) -- ch7 6/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 102\.' "$ALMANAC"; then
  echo "almanac seat 102 already present"
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
if "### 102." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (5 of 16)",
    "## Chapter Seven (6 of 16)",
    1,
)
entry = (
    "### 102. Commence M7 weave: shed census behind proven control — C1 keeps reachable, C2 exposes unreachable; orphan floor informs Class O propose.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_shed_census_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/shed_census_witness.rish` · scan `tools/fixtures/shed_census_scan.sh` · choir `equinox_shed_census_choir_witness.rish`\n"
    "Expected control_gate · tracked planted controls · C1=REFERENCED · C2=ORPHAN · "
    "controls 2 of 2 · orphan floor · fascia_health_now/if_shed · shred=RED · prove-red refuses. "
    "Class O propose-never-seat. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 102 appended · chapter seven 6/16")
PY
