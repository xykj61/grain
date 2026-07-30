#!/bin/sh
# Open Glow almanac chapter two and append seat 17 from East-pack metal (e11).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 17\.' "$ALMANAC"; then
  echo "almanac seat 17 already present"
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
if "### 17." in t:
    raise SystemExit(0)
entry = (
    "## Chapter Two (1 of 16)\n\n"
    "Opened from metal at stamp `"
    + stamp
    + "`. Themes arrive after findings; this chapter carries none in advance.\n\n"
    "### 17. The East pack still holds as one choir: e1–e6 utilities and harden limbs GREEN together.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_east_almanac_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_east_almanac_witness.rish` · `tools/gen/season/equinox_e1_east_pack_witness.rish`\n"
    "Expected East utilities and harden limbs GREEN in one re-touch. Metal answered GREEN. "
    "Chapter two opens; chapter one stays closed at sixteen.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac chapter two opened · seat 17 appended")
PY
