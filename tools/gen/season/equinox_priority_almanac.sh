#!/bin/sh
# Append Glow almanac seat 18 from priority-fold metal (e12).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 18\.' "$ALMANAC"; then
  echo "almanac seat 18 already present"
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
if "### 18." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (1 of 16)",
    "## Chapter Two (2 of 16)",
    1,
)
entry = (
    "### 18. A round names its own priority: sixteen slots, twelve base once, four doubles spaced at least six apart.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_priority_almanac_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_priority_almanac_witness.rish` · `glow/priority_fold_test.rye`\n"
    "Expected 16 slots · 12 base once each · 4 doubles with min gap 6. Metal answered GREEN. "
    "The mod-clock priority fold enters chapter two.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 18 appended")
PY
