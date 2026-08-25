#!/bin/sh
# tools/fixtures/vols_survey_scan.sh -- CION VOLS Journey 13, the derived survey census.
#
#   sh tools/fixtures/vols_survey_scan.sh <root>
#
# Where the module labeling guard (tools/fixtures/labeling_module_scan.sh) scans a
# HAND-LISTED set of already-swept files and FAILS on drift, this scan DERIVES its
# input set from the tree under <root> and REPORTS a census -- every living surface
# that names a capability by a bare "lap <N>" ordinal, the identity the chronological-
# semantic labeling law retired (context/specs/20260810-222755_..., addendum
# 20260811.130827). Completeness is the point: a capability born tomorrow appears in
# the census the day it lands, with no one editing this scan.
#
# A survey reports, it does not gate. verdict=ok means the census RAN COMPLETELY over
# a derived set -- however many sites it found. The GRAD seal, not VOLS, fails on drift.
#
# Derived set: authored living prose surfaces under <root> --
#   */README.md, *.rye, *.rish, *.glow
# Excluded structurally (dated testimony keeps the ordinals it recorded; the law
# governs living surfaces only) and the seed/ projection (a derived copy of source,
# named at its source, never double-counted):
#   session-logs/  */archive/  counsel/  vendor/  gratitude/  old/  .git/
#   */fixtures/     seed/       external-research/
#
# Bare-ordinal pattern: the refined PCRE the law already uses (labeling_module_scan.sh)
#   (?<![-\w])lap [0-9]+(?![-\w])
# -- a structured code ("lap 4b", "OA-L3"), a "sub-lap N" compound, and a stable witness-
# handle filename ("granary_lap1.rish", matched only inside file CONTENT, never by name)
# are deliberately NOT the bare identity; the negative lookaround skips them.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu

if [ "$#" -ne 1 ]; then
  echo "detail: usage — vols_survey_scan.sh <root>"
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

# Derive the living-surface set. find prunes the excluded directories, then prints the
# authored prose surfaces. Deterministic order (sort) so the census reads the same twice.
surfaces=0
sites=0
hits=0
files=$(find "$root" \
    \( -path '*/session-logs' -o -path '*/archive' -o -path '*/counsel' \
       -o -path '*/vendor' -o -path '*/gratitude' -o -path '*/old' \
       -o -path '*/.git' -o -path '*/fixtures' -o -path '*/seed' \
       -o -path '*/external-research' \) -prune -o \
    -type f \( -name '*.rye' -o -name '*.rish' -o -name '*.glow' -o -name 'README.md' \) \
    -print 2>/dev/null | sort)

for f in $files; do
  surfaces=$((surfaces + 1))
  h=$(grep -cPi "$ordinal" "$f" 2>/dev/null || true)
  if [ "$h" -gt 0 ]; then
    echo "site=$f lap_ordinal=$h"
    sites=$((sites + 1))
    hits=$((hits + h))
  fi
done

echo "surfaces=$surfaces"
echo "sites=$sites"
echo "hits=$hits"
echo "verdict=ok"
exit 0
