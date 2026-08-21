#!/bin/sh
# tools/fixtures/tend_hygiene_census.sh — design-shapes tend_hygiene · baton hall 12.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
set -eu
shape="${1:-context/design-shapes/tend_hygiene.brix}"
hall="${2:-context/baton-museum/tend_round.brix}"
table="${3:-tools/gen/season/recursion_block.brix}"

[ -f "$shape" ] || { echo "verdict=missing_shape"; exit 2; }
[ -f "$hall" ] || { echo "verdict=missing_hall"; exit 2; }
[ -f "$table" ] || { echo "verdict=missing_table"; exit 2; }

# Design hall names the duty; baton hall mints the instance.
echo "SHAPE=yes"
echo "HALL=yes"

# Invariant text present on both carriers.
shape_inv=no
grep -q 'zero new code' "$shape" && shape_inv=yes
hall_inv=no
grep -q 'zero new code' "$hall" && hall_inv=yes
echo "SHAPE_ZERO_CODE=$shape_inv"
echo "HALL_ZERO_CODE=$hall_inv"

# Fascia fields on the baton instance.
fascia_fields=0
grep -q 'field fascia_entry' "$hall" && fascia_fields=$((fascia_fields + 1))
grep -q 'field fascia_exit' "$hall" && fascia_fields=$((fascia_fields + 1))
echo "fascia_fields=$fascia_fields"

# Three completed tend waymarks (docs-and-measurement only).
marks=0
for f in \
  waymarks/date/20260730/20260730-041039_tend-one-fascia-delta.md \
  waymarks/date/20260730/20260730-085559_tend-two-fascia-delta.md \
  waymarks/date/20260730/20260730-102430_tend-three-fascia-delta.md
do
  if [ -f "$f" ]; then
    marks=$((marks + 1))
    echo "detail: ok waymark $(basename "$f")"
  else
    echo "detail: absent waymark $(basename "$f")"
  fi
done
echo "tend_waymarks=$marks"

# Living coords: tend two and three DONE with delta 0 (no invent).
tend2=no
tend3=no
grep -q 'coords_tend_two DONE' "$table" && tend2=yes
grep -q 'coords_tend_three DONE' "$table" && tend3=yes
delta2=$(awk '/coords_tend_two DONE/ { for (i=1;i<=NF;i++) if ($i=="delta") { print $(i+1); exit } }' "$table")
delta3=$(awk '/coords_tend_three DONE/ { for (i=1;i<=NF;i++) if ($i=="delta") { print $(i+1); exit } }' "$table")
echo "TEND_TWO=$tend2"
echo "TEND_THREE=$tend3"
echo "delta_two=${delta2:-none}"
echo "delta_three=${delta3:-none}"

# Wing README names this hall.
readme=no
grep -q 'tend_hygiene' context/design-shapes/README.md && readme=yes
echo "README=$readme"

if [ "$shape_inv" = yes ] && [ "$hall_inv" = yes ] \
  && [ "$fascia_fields" -eq 2 ] && [ "$marks" -eq 3 ] \
  && [ "$tend2" = yes ] && [ "$tend3" = yes ] \
  && [ "$delta2" = 0 ] && [ "$delta3" = 0 ] \
  && [ "$readme" = yes ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=census_incomplete"
exit 1
