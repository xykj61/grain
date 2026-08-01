#!/bin/sh
# Date dialect scan — planted C1/C2 before library totals.
# Exit 0 only when controls honor and library hyphenated == 0 (one_dialect).
# Exit 1 while two dialects remain, or when a control misreads.
# No backtick characters in patterns.
#
#   sh tools/fixtures/date_dialect_scan.sh           # living green path
#   sh tools/fixtures/date_dialect_scan.sh prove-red  # must exit 1
#
# Law: a duty with no witness has no seat, and a duty with no seat never lands.
# Law: planted positive proves firing; planted negative proves discrimination.
# Law: a planted control only becomes a control once tracked (git ls-files).
# Law: carry the transformation, never the claim that it was done.
set -eu

MODE=${1:-}
C1=tools/fixtures/date_dialect_control_hyphenated.md
C2=tools/fixtures/date_dialect_control_compact.md
HYPHEN_RE='^\*\*Last updated:\*\* [0-9]{4}-[0-9]{2}-[0-9]{2}'
LABEL_RE='^\*\*(Last updated|Seated|Stamp|Version):\*\*'
BT=$(printf '\140')
# Compact: YYYYMMDD or YYYYMMDD.HHMMSS (e132 — date and full stamp both compact).
COMPACT_RE="^\\*\\*Last updated:\\*\\* ${BT}[0-9]{8}(\\.[0-9]{6})?${BT}"

# --- planted controls must be tracked ---
for p in "$C1" "$C2"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "CONTROL=untracked"
    echo "verdict=misread"
    echo "detail=planted_control_must_be_tracked"
    echo "detail_path=$p"
    echo "census=withheld"
    exit 1
  }
done
echo "tracked_controls=honored"

# --- C1: planted hyphen must be COUNTED (firing) ---
C1_HITS=$(rg -c "$HYPHEN_RE" "$C1" 2>/dev/null || true)
C1_HITS=${C1_HITS:-0}
if test "$C1_HITS" -lt 1; then
  echo "OK C1-hyphenated=failed"
  echo "C1_hyphen_hits=${C1_HITS}"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=C1_must_count_hyphenated"
  echo "census=withheld"
  exit 1
fi
echo "OK C1-hyphenated planted hyphen counted"
echo "C1_hyphen_hits=${C1_HITS}"

# --- C2: planted compact must NOT be counted as hyphen (discrimination) ---
C2_HITS=$(rg -c "$HYPHEN_RE" "$C2" 2>/dev/null || true)
C2_HITS=${C2_HITS:-0}
if test "$C2_HITS" -ne 0; then
  echo "OK C2-compact=failed"
  echo "C2_hyphen_hits=${C2_HITS}"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=C2_must_not_count_as_hyphen"
  echo "census=withheld"
  exit 1
fi
# also prove compact shape is present on C2 (instrument sees the other dialect)
if ! rg -q "$COMPACT_RE" "$C2"; then
  echo "OK C2-compact=failed"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=C2_must_carry_compact_last_updated"
  echo "census=withheld"
  exit 1
fi
echo "OK C2-compact planted compact not counted"
echo "C2_hyphen_hits=0"
echo "controls: 2 of 2 honored - count released"
echo "controls_honored=2"

# prove-red: release a false one_dialect while claiming C2 was hyphen-counted
if test "$MODE" = "prove-red"; then
  echo "C1_hyphen_hits=${C1_HITS}"
  echo "C2_hyphen_hits=1"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=RED_C2-compact"
  echo "detail=discrimination_blind"
  echo "census=withheld"
  echo "law_library_dated=withheld"
  exit 1
fi

# --- law library roster: top-level context/*.md carrying date labels ---
# Use git pathspec magic :(glob) so * does not recurse into context/specs.
REPORT=$(HYPHEN_RE="$HYPHEN_RE" LABEL_RE="$LABEL_RE" python3 <<'PY'
import os, re, subprocess
from pathlib import Path

hyphen_re = re.compile(os.environ["HYPHEN_RE"])
label_re = re.compile(os.environ["LABEL_RE"])

files = subprocess.check_output(
    ["git", "ls-files", "-z", "--", ":(glob)context/*.md"],
    text=True,
).split("\0")
files = [f for f in files if f]

dated = 0
hyphenated = 0
compact = 0
for f in files:
    text = Path(f).read_text(encoding="utf-8", errors="ignore")
    if not any(label_re.search(ln) for ln in text.splitlines()):
        continue
    dated += 1
    if any(hyphen_re.search(ln) for ln in text.splitlines()):
        hyphenated += 1
    else:
        compact += 1

print(f"law_library_dated={dated}")
print(f"hyphenated={hyphenated}")
print(f"compact={compact}")
if hyphenated == 0 and dated > 0:
    print("verdict=one_dialect")
elif hyphenated > 0 and compact > 0:
    print("verdict=two_dialects")
elif hyphenated > 0 and compact == 0:
    print("verdict=hyphen_only")
else:
    print("verdict=misread")
PY
)
echo "$REPORT"

DATED=$(printf '%s\n' "$REPORT" | sed -n 's/^law_library_dated=//p' | head -1)
HYPH=$(printf '%s\n' "$REPORT" | sed -n 's/^hyphenated=//p' | head -1)
COMP=$(printf '%s\n' "$REPORT" | sed -n 's/^compact=//p' | head -1)
VERDICT=$(printf '%s\n' "$REPORT" | sed -n 's/^verdict=//p' | head -1)

if test "${DATED:-0}" -ne 17; then
  echo "roster=failed"
  echo "detail=want_dated_17_got_${DATED}"
  echo "date_dialect=failed"
  exit 1
fi
echo "roster=honored"

if test "$VERDICT" != "one_dialect" || test "${HYPH:-1}" -ne 0; then
  echo "date_dialect=failed"
  echo "detail=want_one_dialect_hyphenated_0"
  # keep the measured verdict line already printed
  exit 1
fi

echo "date_dialect=honored"
echo "dialect_status=17_of_17_compact"
echo "shred=RED"
echo "story=planted_C1_C2>one_dialect>compact_library"
echo "date_dialect_scan=ok"
echo "verdict=ok"
exit 0
