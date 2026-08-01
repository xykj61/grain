#!/bin/sh
# gen_home_census — print-only meter for the generators migration (beta leg 2).
# Counts what lives in each gen/ home and names any generator-shaped file
# still standing at tools/ top level. Advisory law: prints, never fails.
cd "$(git rev-parse --show-toplevel)"
total=0
for home in tools/gen/*/; do
  n=$(git ls-files "$home" | wc -l | tr -d ' ')
  echo "home $home files=$n"
  total=$((total+n))
done
strag=$(git ls-files 'tools/gen_*.rish' 'tools/gen_*.sh' 2>/dev/null | wc -l | tr -d ' ')
echo "gen_homed_total=$total top_level_gen_named_stragglers=$strag"
echo "open_leg=alias_sameness_witness_not_yet_standing"
exit 0
