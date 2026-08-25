#!/bin/sh
# tools/fixtures/almanac_breach_scan.sh -- the almanac breach, both sides.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Voice v11 - breach approved by Keaton 20260729.225900; designed at v7.
# Promise 4 of six: witnessed both sides -- this instrument exists before the
# first file moves, is red before, and green after.
#
# What it asserts:
#   the elder rests at its archive address with its 310 lines intact
#   the living path no longer holds the elder
#   all six LIVING references resolve to the new address
#   the 43 dated-testimony references are UNTOUCHED -- Tier 2 keeps its words at
#   any address, and re-pointing a June session log would falsify what it wrote
set -eu
elder="rye-learning-process/archive/ALMANAC.md"
old="rye-learning-process/ALMANAC.md"
faults=0

if [ -f "$elder" ]; then
  lines=$(wc -l < "$elder" | tr -d ' ')
  echo "elder_lines=$lines"
  [ "$lines" -eq 310 ] || { echo "detail: elder line count changed — a breach preserves every byte"; faults=$((faults+1)); }
else
  echo "detail: elder absent from its archive address -> $elder"
  faults=$((faults+1))
  echo "elder_lines=0"
fi

[ -f "$old" ] && { echo "detail: elder still at the living address -> $old"; faults=$((faults+1)); }

# Living references must point at the archive address.
living="rye-learning-process/README.md
rishi/README.md
rye/README.md
ORGANIZING.md
expanding-prompts/README.md"
turned=0
for f in $living; do
  [ -f "$f" ] || continue
  if grep -q "ALMANAC" "$f"; then
    if grep -q "archive/ALMANAC.md" "$f"; then
      turned=$((turned + 1))
    else
      echo "detail: living reference not turned -> $f"
      faults=$((faults + 1))
    fi
  else
    turned=$((turned + 1))
  fi
done
echo "living_refs_turned=$turned"

# Dated testimony must be untouched: still pointing at the elder address.
# session-logs/date is where a folded log lives since 20260821.161758 (the mark law);
# the elder archive/ stays in the list so this reads a tree folded either way.
dated=$(grep -rl "ALMANAC\|almanac" --include=*.md session-logs/date session-logs/archive expanding-prompts/yonder waymarks 2>/dev/null | wc -l | tr -d ' ')
echo "dated_testimony_untouched=$dated"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=breach_incomplete"
exit 1
