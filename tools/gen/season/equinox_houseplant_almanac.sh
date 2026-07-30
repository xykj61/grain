#!/bin/sh
# Append Glow almanac seat 20 from houseplant glossary metal (e14).
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 20\.' "$ALMANAC"; then
  echo "almanac seat 20 already present"
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
if "### 20." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Two (3 of 16)",
    "## Chapter Two (4 of 16)",
    1,
)
entry = (
    "### 20. Houseplant names a Kumara ship owner's whole grain repository project tree.\n"
    "**Ran:** `rishi/bin/rishi run tools/gen/season/houseplant_glossary_witness.rish` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/houseplant_glossary_witness.rish` · `context/LEXICON.md`\n"
    "Expected Lexicon row with ship · repository · project tree · pier/verse distinct · ladder accretion. "
    "Metal answered GREEN. The plant is the tree, not the keypair.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 20 appended")
PY
