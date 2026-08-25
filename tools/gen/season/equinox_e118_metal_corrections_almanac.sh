#!/bin/sh
# Append Glow almanac seat 122 from e118 metal corrections -- ch8 10/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 122\.' "$ALMANAC"; then
  echo "almanac seat 122 already present"
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
if "### 122." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (9 of 16)",
    "## Chapter Eight (10 of 16)",
    1,
)
entry = (
    "### 122. Equinox e118 metal corrections: roofs agree CLOSED — dated_testimony "
    "matches on both roofs while fascia_health (live/total) and fascia_health_now "
    "(orphan-share) keep two jobs under lookalike names; stale Cloud-blocked baton "
    "debt retires — each bench re-cuts tool presence (binaries gitignored); seat 128 "
    "stays reserved; surface census four kept; fork EXTEND and breach closed unspent kept.\n"
    "**Ran:** `sh tools/fixtures/equinox_e118_metal_corrections_scan.sh` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e118_metal_corrections_witness.rish` · "
    "counsel `counsel/date/20260731/20260731-172902_e118-metal-corrections.md` · "
    "scan `tools/fixtures/equinox_e118_metal_corrections_scan.sh`\n"
    "Expected control_gate · instruments_tracked · roofs_status=CLOSED · "
    "divergence=absent · dated_testimony agrees · stale_cloud_blocked=retired · "
    "tool_presence=per_bench_recut · prove-red RED_claimed_diverge_while_agree · "
    "seat_128 reserved · surface_count=4 · fork EXTEND · handback not_consumed · "
    "shelf end ep045 · baton breach 0. When two roofs carry one name, either they "
    "agree or the name is doing two jobs. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 122 appended · chapter eight 10/16")
PY
