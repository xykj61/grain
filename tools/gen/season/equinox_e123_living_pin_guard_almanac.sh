#!/bin/sh
# Append Glow almanac seat 127 from e123 living-pin guard -- ch8 15/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 127\.' "$ALMANAC"; then
  echo "almanac seat 127 already present"
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
if "### 127." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (14 of 16)",
    "## Chapter Eight (15 of 16)",
    1,
)
entry = (
    "### 127. Equinox e123 living-pin guard: content guard for rostered living pins — "
    "non-empty · header present · tracked via git ls-files · bound enforce or "
    "hold_over disclose; planted emptied fixture must be caught (prove-red "
    "RED_living_pin_emptied_caught); would have named the e121 ITINERARY wipe; "
    "no git-history walk; e122 roots≠Bench kinds kept; seat 128 stays reserved; "
    "surface census six kept. Approve-all seated this lean; shred · SAFE · geode "
    "stay Keaton-gated.\n"
    "**Ran:** `sh tools/fixtures/equinox_e123_living_pin_guard_scan.sh` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e123_living_pin_guard_witness.rish` · "
    "counsel `counsel/date/20260731/20260731-222426_e123-living-pin-guard.md` · "
    "roster `tools/fixtures/living_pin_guard_roster.txt` · "
    "emptied `tools/fixtures/living_pin_emptied_control.md`\n"
    "Expected control_gate · pins=honored · emptied_control=honored · kinds=honored · "
    "history_independence · prove-red RED_living_pin_emptied_caught · "
    "seat_128 reserved · surface_count=6 · fork EXTEND · handback not_consumed · "
    "shelf end ep045 · baton breach 0. A duty with no witness never lands. "
    "Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 127 appended · chapter eight 15/16")
PY
