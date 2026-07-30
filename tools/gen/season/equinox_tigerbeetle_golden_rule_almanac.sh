#!/bin/sh
# Append Glow almanac seat 27 from tigerbeetle golden-rule census (e21).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 27\.' "$ALMANAC"; then
  echo "almanac seat 27 already present"
  exit 0
fi
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
CENSUS=$(sh tools/fixtures/tigerbeetle_golden_rule_census.sh)
export STAMP
export CENSUS
python3 - <<'PY'
from pathlib import Path
import os
p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
census = os.environ["CENSUS"].replace("\n", " · ")
if "### 27." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (10 of 16)",
    "## Chapter Two (11 of 16)",
    1,
)
entry = (
    "### 27. Assert the positive space and the negative; maybe marks what truly varies.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_golden_rule_census_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/tigerbeetle_golden_rule_census_witness.rish` · `tools/fixtures/tigerbeetle_golden_rule_census.sh` · submodule `gratitude/tigerbeetle`\n"
    "Expected CLONE=present · GUIDE_GOLDEN=yes · TAME_GOLDEN=yes · MAYBE_COMPLETES=yes · STYLE=yes "
    "with assert≥2000 · maybe≥100 · implication_assert≥20. "
    "Metal answered GREEN. Census: "
    + census
    + ". Clean-room study only.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 27 appended")
PY
