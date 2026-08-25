#!/bin/sh
# tools/fixtures/vols_survey_crosscount.sh -- VOLS survey independent cross-count.
#
#   sh tools/fixtures/vols_survey_crosscount.sh <root>
#
# The "second tool" behind vols_survey_scan.sh's hit count: a grep -r traversal (rather
# than the scan's find-loop) over the same derived living set, counting the identical
# bare "lap <N>" ordinal. Two tools, one answer -- so no site hides between the survey
# and a maintainer's own count. Authored in a file so the refined PCRE lookaround is
# written once, never re-escaped through a witness string.
#
# Excludes the testimony dir (session-logs) exactly as the scan does; the seed/ and
# other prunes are structural in the scan's find and immaterial to a fixture cross-check.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu

if [ "$#" -ne 1 ]; then
  echo "detail: usage — vols_survey_crosscount.sh <root>"
  echo "verdict=noroot"
  exit 2
fi
root=$1
if [ ! -d "$root" ]; then
  echo "detail: absent root ($root)"
  echo "verdict=noroot"
  exit 2
fi

ordinal='(?<![-\w])lap [0-9]+(?![-\w])'
n=$(grep -rPi --include='*.md' --include='*.rye' --include='*.rish' --include='*.glow' \
      --exclude-dir=session-logs --exclude-dir=archive --exclude-dir=seed \
      "$ordinal" "$root" 2>/dev/null | wc -l | tr -d ' ')
echo "crosshits=$n"
echo "verdict=ok"
exit 0
