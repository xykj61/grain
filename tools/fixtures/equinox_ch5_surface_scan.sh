#!/bin/sh
# Equinox ch5 surface scan -- e119 - sixteen limbs - tool - no almanac seat.
# Exit 0 only when limbs are tracked and the surface claims no chapter-close seat.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_ch5_surface_scan.sh
#
# Law: a surface witness claims no seat of its own.
set -eu

SURFACE=tools/gen/season/equinox_ch5_surface_witness.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

git ls-files --error-unmatch "$SURFACE" >/dev/null 2>&1 || {
  if test -f "$SURFACE"; then
    echo "ch5_surface=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    exit 1
  fi
  echo "ch5_surface=ABSENT"
  echo "verdict=absent"
  exit 1
}

LIMBS="
tools/gen/season/ironbeetle_ep001_census_witness.rish
tools/gen/season/ironbeetle_ep002_census_witness.rish
tools/gen/season/ironbeetle_ep004_census_witness.rish
tools/gen/season/ironbeetle_ep005_census_witness.rish
tools/gen/season/ironbeetle_ep006_census_witness.rish
tools/gen/season/ironbeetle_ep008_census_witness.rish
tools/gen/season/ironbeetle_ep009_census_witness.rish
tools/gen/season/ironbeetle_ep010_census_witness.rish
tools/gen/season/ironbeetle_ep011_census_witness.rish
tools/gen/season/ironbeetle_ep012_census_witness.rish
tools/gen/season/ironbeetle_ep013_census_witness.rish
tools/gen/season/ironbeetle_ep014_census_witness.rish
tools/gen/season/ironbeetle_ep015_census_witness.rish
tools/gen/season/ironbeetle_ep018_census_witness.rish
tools/gen/season/ironbeetle_ep019_census_witness.rish
tools/gen/season/ironbeetle_ep020_census_witness.rish
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
# Must not append a ch5 close almanac seat under elder close numbers
if rg -q 'almanac seat 80|almanac seat 64 · ch5|### 80\..*ch5 surface close' "$SURFACE"; then
  echo "no_almanac_seat=failed"
  echo "verdict=misread"
  echo "detail=surface_must_not_claim_chapter_close_seat"
  exit 1
fi
echo "no_almanac_seat=honored"

# Refuse fixture present
git ls-files --error-unmatch tools/fixtures/ironbeetle_ep020_census.sh >/dev/null 2>&1 || {
  echo "refuse=failed"
  echo "verdict=misread"
  exit 1
}
echo "refuse_path=honored"
echo "ch5_surface=ok"
echo "verdict=ok"
