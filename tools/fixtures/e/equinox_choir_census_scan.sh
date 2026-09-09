#!/bin/sh
# equinox_choir_census_scan.sh -- probe every equinox choir and hold its reds under a ceiling.
#
# WHY A RATCHET RATHER THAN A WALL. Measured `20260908.223011`: of the 80 unreached choirs in this
# tree, 48 are green, 30 are red and 2 hang -- and all 48 green ones live in this one room. A wall
# would refuse the whole roster on the 30 that were already red before anyone looked, so nobody
# would keep it. A ceiling that only falls lets the 48 begin to RUN, which is the point: a green
# choir nothing runs cannot report the day it stops being green.
#
# WHY THE CHOIRS RATHER THAN THE PREFIX. `witness_reach_scan.sh` records that inferring reach from
# the equinox glob overstated by 111, since the pattern selects 144 witnesses while the season choir
# sings the 33 that chain nobody. A choir already knows its own members, so probing the choirs asks
# each family its own question instead of guessing at one.
#
# EACH IS PROBED, never merely run, so a HANG is told from a RED: one is a claim about the run and
# the other about the tree, and a roster row for a hanging witness hangs the fleet.
set -eu
red_ceiling=${EQUINOX_CHOIR_RED_CEILING:-30}
hung_ceiling=${EQUINOX_CHOIR_HUNG_CEILING:-2}
bound=${EQUINOX_CHOIR_BOUND:-90}
dir=${EQUINOX_CHOIR_DIR:-tools/equinox/witness}

list=$(ls "$dir"/*_choir_witness.rish 2>/dev/null | sort || true)
n=$(printf '%s\n' "$list" | grep -c . || true)
echo "members=$n"
echo "bound=$bound"
if [ "$n" -eq 0 ]; then echo "verdict=empty_corpus"; exit 1; fi

green=0; red=0; hung=0
for f in $list; do
  v=$(sh tools/fixtures/w/witness_probe_scan.sh "$f" --bound "$bound" 2>/dev/null | grep '^verdict=' | cut -d= -f2)
  case "$v" in
    green) green=$((green+1)) ;;
    hung)  hung=$((hung+1)); echo "hung: $f" ;;
    *)     red=$((red+1)); echo "red: $f" ;;
  esac
done
echo "green=$green"
echo "red=$red"
echo "red_ceiling=$red_ceiling"
echo "hung=$hung"
echo "hung_ceiling=$hung_ceiling"

# A corpus that answers nothing green is a broken probe rather than a broken room.
if [ "$green" -eq 0 ]; then echo "verdict=no_green"; exit 1; fi
if [ "$red" -gt "$red_ceiling" ]; then echo "verdict=red_over_ceiling"; exit 1; fi
if [ "$hung" -gt "$hung_ceiling" ]; then echo "verdict=hung_over_ceiling"; exit 1; fi
echo "verdict=ok"
