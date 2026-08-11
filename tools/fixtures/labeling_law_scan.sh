#!/bin/sh
# tools/fixtures/labeling_law_scan.sh — the GRAD seal's guard for the chronological-
# semantic labeling law (context/specs/20260810-222755_...). Scans the given files
# for a **bare count-up-from-0 identity** in a living now-line — the thing the law
# forbids — and reports a verdict.
#
# Forbidden as IDENTITY (matched):
#   * a season ordinal used as a name — "s<N> ·"  (e.g. the retired "s1 · ...")
#   * a waymark followed by a redundant equinox number — "SOON e1", "JARL e2", ...
# Allowed and NOT matched (on purpose):
#   * nesting bounds — "Quest 4 · Journey 16 · Equinox 64 · Season 256"
#   * computed coordinates — "j1 · q1 · r1", "SOON q1" (quest/round coords)
#   * one-clock stamps, waymarks standing alone, prose numbers
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu
season='\bs[0-9]+ ·'
redundant='(SOON|JARL|BUHR|TACT|GISM|AYRE|DAHL|KOFF|VOLS|LOWE|OFFY|GRAD) e[0-9]'
fail=0
for f in "$@"; do
  if [ ! -f "$f" ]; then echo "detail: absent ($f)"; fail=$((fail + 1)); continue; fi
  h1=$(grep -cE "$season" "$f" 2>/dev/null || true)
  h2=$(grep -cE "$redundant" "$f" 2>/dev/null || true)
  echo "file=$f season_ordinal=$h1 waymark_redundant=$h2"
  if [ "$h1" -gt 0 ] || [ "$h2" -gt 0 ]; then
    echo "detail: drifted ($f) carries a bare count-up-from-0 identity"
    fail=$((fail + 1))
  fi
done
echo "drift=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=drift"; exit 1
