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
# THE RED CEILING FELL 30 -> 10 on `20260908.234500`, on the lap after it was first counted.
# Seventeen of the thirty were one absent submodule: 21 census witnesses each carried the SAME hard
# assert on `gratitude/tigerbeetle/src`, and 17 choirs asserted their content. Teaching both to SKIP
# turned 17 reds into honest skips without changing what any of them checks on a host that HAS the
# clone. Green rose 50 -> 70. The class is booked at `20260908.202239`.
# THE TEN THAT REMAIN, asked one at a time on `20260908.235139` -- and FIVE share one cause, which
# is the same class already met at `e49` against `e125`: **a guard pinned to a count of a growing
# surface reds on every ordinary advance.** `e106` wants the REDS ledger to hold 33 rows and `e108`
# wants 37, where the spine now reads past 645; `e102` and `e105` want a metric revision that has
# moved; `e110` wants four chapter surfaces. Three more -- `e111`, `e113`, `e114` -- have scans that
# read `verdict=ok` while their witnesses still refuse, so their cause is elsewhere and unread.
#
# NO REPAIR IS TAKEN HERE, on purpose. These are DATED equinox guards: each records what was true at
# its own equinox, so whether it should read an archived state, read the living value, or retire as
# satisfied-and-past is a decision about testimony rather than a mechanical fix, and it governs a
# whole family. It wants Keaton's word.
#
# The ledger row this finding deserves is not written: `construction/REDS.md` stands at 173 bytes of
# headroom with all seven of its rows OPEN, so no fold is lawful and a row cannot land. That pin
# bound is itself awaiting his word, recorded on the card.
red_ceiling=${EQUINOX_CHOIR_RED_CEILING:-10}
over_bound_ceiling=${EQUINOX_CHOIR_HUNG_CEILING:-2}
bound=${EQUINOX_CHOIR_BOUND:-90}
dir=${EQUINOX_CHOIR_DIR:-tools/equinox/witness}

list=$(ls "$dir"/*_choir_witness.rish 2>/dev/null | sort || true)
n=$(printf '%s\n' "$list" | grep -c . || true)
echo "members=$n"
echo "bound=$bound"
if [ "$n" -eq 0 ]; then echo "verdict=empty_corpus"; exit 1; fi

green=0; red=0; over_bound=0
for f in $list; do
  v=$(sh tools/fixtures/w/witness_probe_scan.sh "$f" --bound "$bound" 2>/dev/null | grep '^verdict=' | cut -d= -f2)
  case "$v" in
    green) green=$((green+1)) ;;
    hung)  over_bound=$((hung+1)); echo "hung: $f" ;;
    *)     red=$((red+1)); echo "red: $f" ;;
  esac
done
echo "green=$green"
echo "red=$red"
echo "red_ceiling=$red_ceiling"
echo "over_bound=$hung"
echo "over_bound_ceiling=$over_bound_ceiling"

# A corpus that answers nothing green is a broken probe rather than a broken room.
if [ "$green" -eq 0 ]; then echo "verdict=no_green"; exit 1; fi
if [ "$red" -gt "$red_ceiling" ]; then echo "verdict=red_over_ceiling"; exit 1; fi
if [ "$hung" -gt "$over_bound_ceiling" ]; then echo "verdict=over_bound_over_ceiling"; exit 1; fi
echo "verdict=ok"
