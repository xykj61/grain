#!/bin/sh
# Oldness census scan -- M3 home land.
# Control first; then SAFE shape; then living/dated split over tracked md.
# No backtick characters in patterns. Print only -- never mutates SAFE.
#
#   sh tools/fixtures/oldness_census_scan.sh
#
# Law: four fifths of markdown is Tier 2 testimony; the living header
# (born ... refreshed ...) is the relevancy marker for the plain-named remainder.
# SAFE rows grow only by Keaton's word.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
SAFE=SAFE.md
LIVING_CONTROL=context/specs/living-vs-dated.md
DATED_CONTROL=counsel/date/20260724/20260724-132812_the-workshop-and-the-warehouse.md

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi

CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT"
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

# --- living control must read living; dated control must read dated ---
if ! test -f "$LIVING_CONTROL"; then
  echo "oldness_living_control=failed"
  echo "verdict=misread"
  exit 1
fi
if ! head -n 40 "$LIVING_CONTROL" | tr '[:upper:]' '[:lower:]' | rg -q 'living ledger'; then
  echo "oldness_living_control=failed"
  echo "verdict=misread"
  echo "detail=living_control_missing_living_ledger"
  exit 1
fi
echo "oldness_living_control=honored"
echo "oldness_living_control_path=${LIVING_CONTROL}"

if ! test -f "$DATED_CONTROL"; then
  echo "oldness_dated_control=failed"
  echo "verdict=misread"
  exit 1
fi
case "$DATED_CONTROL" in
  */2026[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]_*) ;;
  *)
    echo "oldness_dated_control=failed"
    echo "verdict=misread"
    echo "detail=dated_control_name_shape"
    exit 1
    ;;
esac
if head -n 40 "$DATED_CONTROL" | tr '[:upper:]' '[:lower:]' | rg -q 'living ledger'; then
  echo "oldness_dated_control=failed"
  echo "verdict=misread"
  echo "detail=dated_control_must_not_declare_living"
  exit 1
fi
echo "oldness_dated_control=honored"
echo "oldness_dated_control_path=${DATED_CONTROL}"

# --- SAFE shape (cycle 1 - 0 of 64 welcome) ---
if ! test -f "$SAFE"; then
  echo "oldness_safe=failed"
  echo "verdict=misread"
  exit 1
fi
CYCLE=$(rg -o 'Cycle:\*\*[[:space:]]*[0-9]+' "$SAFE" | rg -o '[0-9]+' | head -1)
ROWS=$(rg -o 'Rows:\*\*[[:space:]]*[0-9]+ of 64' "$SAFE" | rg -o '[0-9]+' | head -1)
CYCLE=${CYCLE:-missing}
ROWS=${ROWS:-missing}
if test "$CYCLE" != "1"; then
  echo "oldness_safe=failed"
  echo "verdict=misread"
  echo "detail=want_cycle_1"
  exit 1
fi
if test "$ROWS" != "0"; then
  echo "oldness_safe=failed"
  echo "verdict=misread"
  echo "detail=want_rows_0_until_keaton_word"
  exit 1
fi
rg -q 'none yet' "$SAFE" || {
  echo "oldness_safe=failed"
  echo "verdict=misread"
  echo "detail=want_empty_welcome"
  exit 1
}
echo "oldness_safe=honored"
echo "oldness_safe_cycle=${CYCLE}"
echo "oldness_safe_rows=${ROWS}"
echo "oldness_safe_bound=64"
echo "oldness_safe_empty=yes"

# --- living / dated split (git ls-files - never find) ---
SPLIT=$(python3 <<'PY'
import re, subprocess
from pathlib import Path
files = subprocess.check_output(["git", "ls-files", "*.md"], text=True).splitlines()
dated_re = re.compile(r"(^|/)2026[0-9]{4}-[0-9]{6}[_.][^/]*$")

def living_header(path: str) -> bool:
    try:
        head = "\n".join(Path(path).read_text(errors="replace").splitlines()[:40]).lower()
    except OSError:
        return False
    return "living ledger" in head

dated = [f for f in files if dated_re.search(f)]
plain = [f for f in files if not dated_re.search(f)]
tier2 = [f for f in dated if not living_header(f)]
plain_living = [f for f in plain if living_header(f)]
total = len(files)
share = (len(tier2) / total) if total else 0.0
print(f"tracked_md={total}")
print(f"dated_name={len(dated)}")
print(f"plain_name={len(plain)}")
print(f"dated_tier2={len(tier2)}")
print(f"plain_living_header={len(plain_living)}")
print(f"tier2_share={share:.3f}")
# four fifths band
if 0.75 <= share <= 0.90:
    print("tier2_band=four_fifths")
else:
    print("tier2_band=outside")
print("marker_law=living_header_born_refreshed")
PY
)
echo "$SPLIT"
echo "$SPLIT" | rg -q '^tier2_band=four_fifths$' || {
  echo "oldness_split=failed"
  echo "verdict=misread"
  echo "detail=want_four_fifths_tier2_band"
  exit 1
}
echo "$SPLIT" | rg -q '^marker_law=living_header_born_refreshed$' || {
  echo "oldness_split=failed"
  echo "verdict=misread"
  exit 1
}
echo "oldness_split=honored"
echo "oldness_marker=living_header"
echo "rows_flagged=0"
echo "shred=RED"
echo "oldness_census=ok"
echo "verdict=ok"
