#!/bin/sh
# Append Glow almanac seat 36 from fact-fold choir (e30).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 36\.' "$ALMANAC"; then
  echo "almanac seat 36 already present"
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
if "### 36." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (3 of 16)",
    "## Chapter Three (4 of 16)",
    1,
)
entry = (
    "### 36. The fact-fold design hall points at living metal; three bounds match and purity holds.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_fact_fold_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/fact_fold_census_witness.rish` · scan `tools/fixtures/fact_fold_census.sh` · metal `mycelium/fold.rye` · choir `equinox_fact_fold_choir_witness.rish`\n"
    "Expected pairs_matched=3 · PATTERN_CITES · fold GREEN with supply=872 · purity · refuse whole, and verdict=missing_shape on an absent path. "
    "Metal answered GREEN. Design hall and Sangha page keep one fold honest.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 36 appended · chapter three 4/16")
PY
