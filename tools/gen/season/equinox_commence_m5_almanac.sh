#!/bin/sh
# Append Glow almanac seat 100 from commence M5 (e96) -- ch7 4/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 100\.' "$ALMANAC"; then
  echo "almanac seat 100 already present"
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
if "### 100." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Seven (3 of 16)",
    "## Chapter Seven (4 of 16)",
    1,
)
entry = (
    "### 100. Commence M5 re-cuts every green behind the proven census control: glow desk, baton museum, rune alphabet, hygiene, prin-scope, advisory-11, and tracked inventory.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m5_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/commence_m5_recut_witness.rish` · scan `tools/fixtures/commence_m5_recut_scan.sh` · choir `equinox_commence_m5_choir_witness.rish`\n"
    "Expected control_gate=honored · advisory 11/11 · inventory behind control · baton breach 0 · "
    "glow · alphabet · hygiene · prin-scope GREEN. Pinned meters (sundial · fascia · shred) stay pinned. "
    "Metal answered GREEN. Commence arc fills chapter seven; invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 100 appended · chapter seven 4/16")
PY
