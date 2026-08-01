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
# A straggler is a top-level gen-named file that is NOT a lawful shim (no
# gen/ twin named in its body) and not this meter itself — e205: the first
# reading counted seven shims and the meter's own file as debt; measured
# again, the true straggler count is what prints here.
strag=0
for g in $(git ls-files 'tools/gen_*.rish' 'tools/gen_*.sh' 2>/dev/null); do
  case "$g" in tools/gen_home_census.sh) continue;; esac
  if ! grep -q 'tools/gen/' "$g"; then
    strag=$((strag+1)); echo "straggler $g"
  fi
done
echo "gen_homed_total=$total top_level_true_stragglers=$strag"
echo "alias_witness=tools/gen_alias_sameness_witness.rish"
exit 0
