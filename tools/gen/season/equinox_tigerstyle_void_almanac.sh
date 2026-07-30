#!/bin/sh
# Append Glow almanac seat 23 from TigerStyle void-return finding (e17).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 23\.' "$ALMANAC"; then
  echo "almanac seat 23 already present"
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
if "### 23." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (6 of 16)",
    "## Chapter Two (7 of 16)",
    1,
)
entry = (
    "### 23. TigerStyle ranks void above bool as a return type; its held examples return !void.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/tigerstyle_void_return_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerstyle_void_return_witness.rish` · `gratitude/TIGER_STYLE.md`\n"
    "Expected the dimensionality ladder and !void init/main examples on the held style guide. "
    "Metal answered GREEN. Full tigerbeetle src clone may be ABSENT; this seat measures the guide we hold.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 23 appended")
PY
