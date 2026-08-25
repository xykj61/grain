#!/bin/sh
# Append Glow almanac seat 121 from e117 fork EXTEND + breach let-close -- ch8 9/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 121\.' "$ALMANAC"; then
  echo "almanac seat 121 already present"
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
if "### 121." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (8 of 16)",
    "## Chapter Eight (9 of 16)",
    1,
)
entry = (
    "### 121. Equinox e117 fork EXTEND + breach let-close: Keaton's word "
    "(fuse kg approving all breaches forks recommendations) seats THE FORK as "
    "EXTEND +128 with nested return_surface_p59 held not consumed; seats THE "
    "BREACH as let close — census_breach_count=0 banked approval closed unspent; "
    "roof reconciliation already e116; geode stays APPROVED GATED; shred RED; "
    "seat 128 stays reserved; surface census four kept.\n"
    "**Ran:** `sh tools/fixtures/equinox_e117_fork_extend_breach_close_scan.sh` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e117_fork_extend_breach_close_witness.rish` · "
    "counsel `counsel/date/20260731/20260731-170354_e117-fork-extend-breach-let-close.md` · "
    "scan `tools/fixtures/equinox_e117_fork_extend_breach_close_scan.sh`\n"
    "Expected control_gate · instruments_tracked · fork_word=EXTEND · "
    "handback_status=not_consumed · breach_status=closed_unspent · "
    "geode APPROVED_GATED · seat_128 reserved · surface_count=4 · "
    "prove-red RED_approve_all_consumed_handback · roof e116 kept · "
    "shelf end ep045 · baton breach 0. Approve-all seats recommended yes/no "
    "leans; hard lines still refuse shred. Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 121 appended · chapter eight 9/16")
PY
