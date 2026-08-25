#!/bin/sh
# Append Glow almanac seat 120 from e116 one dated definition + REDS 40 -- ch8 8/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 120\.' "$ALMANAC"; then
  echo "almanac seat 120 already present"
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
if "### 120." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (7 of 16)",
    "## Chapter Eight (8 of 16)",
    1,
)
entry = (
    "### 120. Equinox e116 one dated definition: shared dated_classify seats living-vs-dated "
    "once in code; shed and fascia-health both source it; divergence witness goes RED while "
    "dated_testimony differs; REDS row 40 records when two roofs carry one name, either they "
    "agree or the name is doing two jobs; seat 128 stays reserved; surface census four kept.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e116_dated_one_definition_choir_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e116_dated_one_definition_witness.rish` · "
    "standing `tools/gen/season/dated_pattern_witness.rish` · "
    "`tools/gen/season/dated_roof_divergence_witness.rish` · "
    "scan `tools/fixtures/dated_pattern_scan.sh` · "
    "`tools/fixtures/dated_roof_divergence_scan.sh` · "
    "equinox scan `tools/fixtures/equinox_e116_dated_one_definition_scan.sh`\n"
    "Expected control_gate · instruments_tracked · definition=one · divergence=absent · "
    "roofs_agree · prove-red RED_dated_definition_blind · RED_roofs_diverge · "
    "REDS rows=40 · expect_next=41 · seat_128 reserved · surface_count=4 · "
    "fork not_consumed · shelf end ep045 · baton breach 0. "
    "When two roofs carry one name, either they agree or the name is doing two jobs. "
    "Metal answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 120 appended · chapter eight 8/16")
PY
