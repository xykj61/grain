#!/bin/sh
# tools/fixtures/relay_resin_census.sh -- twelve-bead limb bound - design-shapes.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
# Args: [limb_fixture] -- counts named bead lines; over bound without manifest refuses.
set -eu
shape="${1:-context/design-shapes/relay_resin.brix}"
limb="${2:-tools/fixtures/relay_resin_limb_ok.txt}"

[ -f "$shape" ] || { echo "verdict=missing_shape"; exit 2; }

bound=$(awk '$1=="const" && $2=="max_limb_beads" { print $3; exit }' "$shape")
[ -n "$bound" ] || { echo "verdict=bound_unnamed"; exit 1; }
echo "max_limb_beads=$bound"

essay=no
[ -f context/design-shapes/relay_resin.md ] && essay=yes
echo "ESSAY=$essay"

lex=no
if grep -q '| \*\*resin\*\* ' context/LEXICON.md && grep -q '| \*\*bead\*\* ' context/LEXICON.md; then
  lex=yes
fi
echo "LEXICON=$lex"

manifest=no
[ -f counsel/replies/20260730-072710_seatings-and-resin-manifest.md ] && manifest=yes
echo "MANIFEST_BEAD=$manifest"

[ -f "$limb" ] || { echo "verdict=missing_limb"; exit 2; }
beads=$(grep -c '^bead ' "$limb" || true)
has_manifest_mark=no
grep -q '^manifest ' "$limb" && has_manifest_mark=yes
echo "limb_beads=$beads"
echo "limb_manifest_mark=$has_manifest_mark"

if [ "$essay" != yes ] || [ "$lex" != yes ] || [ "$manifest" != yes ]; then
  echo "verdict=census_incomplete"
  exit 1
fi
if [ "$bound" != 12 ]; then
  echo "verdict=bound_wrong"
  exit 1
fi

# Welcome: at or under the bound.
if [ "$beads" -le "$bound" ]; then
  echo "verdict=ok"
  exit 0
fi

# Past the bound: only legal when the limb carries a manifest mark (compaction).
if [ "$has_manifest_mark" = yes ]; then
  echo "verdict=ok_compacted"
  exit 0
fi
echo "verdict=over_bound"
exit 1
