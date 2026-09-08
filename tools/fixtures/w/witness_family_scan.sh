#!/bin/sh
# witness_family_scan.sh -- discover one family of witnesses and sing every member.
#
# WHY GENERIC. The first choir this tree wrote was bolted to one font. The second family wanted the
# same thirty lines with one word changed, which is one rule written twice and the drift that
# follows. A family costs a roster row now rather than a file.
#
#   sh tools/fixtures/w/witness_family_scan.sh --dir tools/h --prefix hunk [--max 128]
#
# DISCOVERY, NEVER A LIST. A hand-written list goes stale the first lap somebody adds a member, and
# it goes stale SILENTLY: the new witness never runs and the choir stays green while covering less.
#
# THE GLOB IS `<prefix>*witness.rish`, deliberately WITHOUT a `_` before `witness`. A family's plain
# member -- `font5x7_witness.rish`, carrying no middle segment -- is missed by the tighter pattern,
# and that miss reads exactly like a pass. Learned on the first choir's first run: 44 of 45.
#
# BOUNDED by --max, because an unbounded discovery is an unbounded run.
set -eu

dir=""; prefix=""; max=128; mode=""; runner=${WITNESS_FAMILY_RUNNER:-rishi/bin/rishi}
while [ $# -gt 0 ]; do
  case "$1" in
    --list) mode=list; shift ;;
    --dir) dir=$2; shift 2 ;;
    --prefix) prefix=$2; shift 2 ;;
    --max) max=$2; shift 2 ;;
    *) echo "verdict=unknown_option ($1)"; exit 2 ;;
  esac
done
[ -n "$dir" ]    || { echo "verdict=no_dir"; exit 2; }
[ -n "$prefix" ] || { echo "verdict=no_prefix"; exit 2; }

# --list PRINTS the family and RUNS NOTHING. It exists for `witness_reach_scan.sh`, whose
# `# reach-list:` door is how a DISCOVERING choir tells the meter what it sings. Without it a
# glob-discovered family is invisible: two choirs here ran 131 witnesses the meter still counted
# unreached. The tree refuses to INFER reach from a glob on purpose -- inferring once overstated by
# 111 -- so the choir declares, and the enumerator and the sing read one list, which is what keeps
# the declaration honest when the family changes.
list=$(ls "$dir"/"$prefix"*witness.rish 2>/dev/null | grep -v '_choir' | sort || true)
if [ "$mode" = list ]; then printf '%s\n' "$list" | grep -E '_witness\.rish$' || true; exit 0; fi

echo "dir=$dir"
echo "prefix=$prefix"
echo "max=$max"

n=$(printf '%s\n' "$list" | grep -c . || true)
echo "members=$n"

# A corpus of zero is a red rather than a reading. A choir that discovers nothing and reports
# success is the exact failure this file exists to prevent, so it refuses by name.
if [ "$n" -eq 0 ]; then echo "verdict=empty_corpus"; exit 1; fi
if [ "$n" -gt "$max" ]; then echo "verdict=over_bound"; exit 1; fi

reds=0
for f in $list; do
  if "$runner" run "$f" >/dev/null 2>&1; then :; else echo "red: $f"; reds=$((reds + 1)); fi
done
echo "reds=$reds"
[ "$reds" -eq 0 ] || { echo "verdict=member_red"; exit 1; }
echo "verdict=ok"
