#!/bin/sh
# Append Glow almanac seat 35 from relay-resin choir (e29).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 35\.' "$ALMANAC"; then
  echo "almanac seat 35 already present"
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
if "### 35." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Three (2 of 16)",
    "## Chapter Three (3 of 16)",
    1,
)
entry = (
    "### 35. The resin limb names at most twelve beads; a thirteenth without a manifest refuses whole.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_relay_resin_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/relay_resin_census_witness.rish` · scan `tools/fixtures/relay_resin_census.sh` · choir `equinox_relay_resin_choir_witness.rish`\n"
    "Expected max_limb_beads=12 · limb_beads=12 · LEXICON · MANIFEST_BEAD, and verdict=over_bound on a thirteen-bead fixture without compaction. "
    "Metal answered GREEN. Amphora-shaped bound; the roster becomes a bead past twelve.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 35 appended · chapter three 3/16")
PY
