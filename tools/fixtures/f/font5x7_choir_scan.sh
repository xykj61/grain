#!/bin/sh
# font5x7_choir_scan.sh -- discover the 5x7 font's witnesses and sing every one.
#
# DISCOVERY, NEVER A LIST. A hand-written list goes stale the first lap somebody adds a glyph table,
# and it goes stale SILENTLY: the new witness never runs and the choir stays green while covering
# less. The glob deliberately reads `font5x7_*witness.rish` rather than `font5x7_*_witness.rish`,
# because `font5x7_witness.rish` carries no middle segment -- a pattern that assumes a shape misses
# the member without it, and that miss reads exactly like a pass.
#
# BOUNDED at 128 members, because an unbounded discovery is an unbounded run.
set -eu
max=${FONT5X7_MAX:-128}
list=$(ls tools/f/font5x7_*witness.rish 2>/dev/null | grep -v 'font5x7_choir' | sort || true)
n=$(printf '%s\n' "$list" | grep -c . || true)

echo "members=$n"
echo "max=$max"

# A corpus of zero is a red rather than a reading: a choir that discovers nothing and reports
# success is the exact failure this file exists to prevent.
if [ "$n" -eq 0 ]; then echo "verdict=empty_corpus"; exit 1; fi
if [ "$n" -gt "$max" ]; then echo "verdict=over_bound"; exit 1; fi

reds=0
for f in $list; do
  if rishi/bin/rishi run "$f" >/dev/null 2>&1; then :; else echo "red: $f"; reds=$((reds + 1)); fi
done
echo "reds=$reds"
[ "$reds" -eq 0 ] || { echo "verdict=member_red"; exit 1; }
echo "verdict=ok"
