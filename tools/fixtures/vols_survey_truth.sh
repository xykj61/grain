#!/bin/sh
# tools/fixtures/vols_survey_truth.sh -- VOLS survey, the independent measure (r4's second tool).
#
#   sh tools/fixtures/vols_survey_truth.sh <root> <guardlist>
#
# Computes the survey totals a SECOND way, so the seated ledger can be cross-checked
# against a genuinely different traversal -- two tools, one answer, the read-true crux of
# Journey 13's closing round. Where vols_classify_scan.sh walks with a find-loop over the
# census, this lists the bare-ordinal files with grep -rl (a different traversal) and
# classifies each by basename, computing prose_gaps as sites minus handles minus guarded.
#
# The excluded dirs mirror the census exactly (dated testimony + the seed/ projection), so
# the two tools scan the same living set. Output convention:
# context/specs/20260729-215600_scan-seam-convention.md.
set -eu

if [ "$#" -ne 2 ]; then
  echo "detail: usage — vols_survey_truth.sh <root> <guardlist>"
  echo "verdict=noroot"
  exit 2
fi
root=$1
guardlist=$2
if [ ! -d "$root" ]; then echo "detail: absent root ($root)"; echo "verdict=noroot"; exit 2; fi
if [ ! -f "$guardlist" ]; then echo "detail: absent guardlist ($guardlist)"; echo "verdict=noroot"; exit 2; fi

ordinal='(?<![-\w])lap [0-9]+(?![-\w])'

# grep -rl: list the files carrying a bare ordinal -- a different traversal from the census.
site_files=$(grep -rlPi \
    --include='*.rye' --include='*.rish' --include='*.glow' --include='README.md' \
    --exclude-dir=session-logs --exclude-dir=archive --exclude-dir=counsel \
    --exclude-dir=vendor --exclude-dir=gratitude --exclude-dir=old \
    --exclude-dir=external-research --exclude-dir=fixtures --exclude-dir=seed \
    "$ordinal" "$root" 2>/dev/null | sort -u || true)

sites=0
handles=0
guarded=0
OLD_IFS=$IFS
IFS='
'
for f in $site_files; do
  [ -n "$f" ] || continue
  sites=$((sites + 1))
  base=$(basename "$f")
  case "$base" in
    *_lap[0-9]*) handles=$((handles + 1)) ;;
  esac
  IFS=$OLD_IFS
  for g in $(cat "$guardlist"); do
    if [ "$f" = "$root/$g" ] || [ "$f" = "$g" ] || [ "$f" = "./$g" ]; then guarded=$((guarded + 1)); break; fi
  done
  IFS='
'
done
IFS=$OLD_IFS

prose_gaps=$((sites - handles - guarded))
echo "truth_sites=$sites"
echo "truth_handles=$handles"
echo "truth_guarded=$guarded"
echo "truth_prose_gaps=$prose_gaps"
echo "verdict=ok"
exit 0
