#!/bin/sh
# Append Glow almanac seat 22 from copy-sameness choir (e16).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 22\.' "$ALMANAC"; then
  echo "almanac seat 22 already present"
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
if "### 22." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (5 of 16)",
    "## Chapter Two (6 of 16)",
    1,
)
entry = (
    "### 22. Fourteen symlinks and one real file keep tally/copy.rye sameness; a drifted fixture is refused.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_copy_sameness_almanac_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/copy_sameness_witness.rish` · `tools/gen/season/copy_sameness_negative_witness.rish` · choir `equinox_copy_sameness_almanac_witness.rish`\n"
    "Expected welcome verdict=ok and refuse verdict=drift on the fixture while the live tree stays clean. "
    "Metal answered GREEN. Negative space as loud as welcome.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 22 appended")
PY
