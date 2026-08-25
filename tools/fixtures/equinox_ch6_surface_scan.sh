#!/bin/sh
# Equinox ch6 surface scan -- e119 - sixteen limbs - tool - no almanac seat.
# Exit 0 only when limbs are tracked and the surface claims no chapter-close seat.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_ch6_surface_scan.sh
#
# Law: a surface witness claims no seat of its own.
set -eu

SURFACE=tools/gen/season/equinox_ch6_surface_witness.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

git ls-files --error-unmatch "$SURFACE" >/dev/null 2>&1 || {
  if test -f "$SURFACE"; then
    echo "ch6_surface=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    exit 1
  fi
  echo "ch6_surface=ABSENT"
  echo "verdict=absent"
  exit 1
}

LIMBS="
tools/gen/season/ironbeetle_ep021_census_witness.rish
tools/gen/season/ironbeetle_ep022_census_witness.rish
tools/gen/season/ironbeetle_ep025_census_witness.rish
tools/gen/season/ironbeetle_ep028_census_witness.rish
tools/gen/season/ironbeetle_ep030_census_witness.rish
tools/gen/season/ironbeetle_ep031_census_witness.rish
tools/gen/season/ironbeetle_ep032_census_witness.rish
tools/gen/season/ironbeetle_ep033_census_witness.rish
tools/gen/season/ironbeetle_ep034_census_witness.rish
tools/gen/season/ironbeetle_ep035_census_witness.rish
tools/gen/season/ironbeetle_ep036_census_witness.rish
tools/gen/season/ironbeetle_ep037_census_witness.rish
tools/gen/season/ironbeetle_ep038_census_witness.rish
tools/gen/season/ironbeetle_ep040_census_witness.rish
tools/gen/season/ironbeetle_ep042_census_witness.rish
tools/gen/season/ironbeetle_ep043_census_witness.rish
"

N=0
for p in $LIMBS; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "limb=failed"
    echo "verdict=misread"
    echo "detail_path=$p"
    exit 1
  }
  N=$((N + 1))
done

if test "$N" -ne 16; then
  echo "limbs=$N"
  echo "verdict=misread"
  echo "detail=want_limbs_16"
  exit 1
fi
echo "limbs=16"
echo "limbs_tracked=honored"

rg -q 'no almanac seat|claims no seat|no seat of its own' "$SURFACE" || {
  echo "no_almanac_seat=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'almanac seat 96|almanac seat 80 · ch6|### 96\..*ch6 surface close' "$SURFACE"; then
  echo "no_almanac_seat=failed"
  echo "verdict=misread"
  echo "detail=surface_must_not_claim_chapter_close_seat"
  exit 1
fi
echo "no_almanac_seat=honored"

git ls-files --error-unmatch tools/fixtures/ironbeetle_ep043_census.sh >/dev/null 2>&1 || {
  echo "refuse=failed"
  echo "verdict=misread"
  exit 1
}
echo "refuse_path=honored"
echo "ch6_surface=ok"
echo "verdict=ok"
