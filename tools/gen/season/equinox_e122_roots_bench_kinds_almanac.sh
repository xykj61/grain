#!/bin/sh
# Append Glow almanac seat 126 from e122 roots bench kinds — ch8 14/16.
set -eu
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
if grep -q '^### 126\.' "$ALMANAC"; then
  echo "almanac seat 126 already present"
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
if "### 126." in t:
    raise SystemExit(0)
t = t.replace(
    "## Chapter Eight (13 of 16)",
    "## Chapter Eight (14 of 16)",
    1,
)
entry = (
    "### 126. Equinox e122 roots bench kinds: Lexicon **roots** restored to four "
    "client surfaces (Claude web · Claude iOS · Cursor AppImage desktop · Cursor iOS) "
    "— where the hand sits to send words; **Bench** kept a different kind — where "
    "claims become evidence; e121 blur that made Bench a raised root is refused; "
    "hard line corrected to name the **Bench** when a measurement is reported; "
    "seat 128 stays reserved; surface census six kept.\n"
    "**Ran:** `sh tools/fixtures/equinox_e122_roots_bench_kinds_scan.sh` · **Stamp:** `"
    + stamp
    + "` · **Witness:** `tools/gen/season/equinox_e122_roots_bench_kinds_witness.rish` · "
    "counsel `counsel/20260731-221131_e122-roots-bench-kinds.md` · "
    "Lexicon `context/LEXICON.md`\n"
    "Expected control_gate · roots=honored · kinds=honored · four members · "
    "prove-red RED_claimed_bench_is_raised_root · name_the_bench law · "
    "seat_128 reserved · surface_count=6 · remember non-empty · fork EXTEND · "
    "handback not_consumed · shelf end ep045 · baton breach 0. When two roofs "
    "carry one name, either they agree or the name is doing two jobs. Metal "
    "answered GREEN. Invent none.\n\n"
)
marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, entry + marker, 1)
p.write_text(t)
print("almanac seat 126 appended · chapter eight 14/16")
PY
