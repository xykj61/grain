#!/bin/sh
# witness_probe_scan.sh -- run one witness under a bound and report WHICH of three things happened.
#
# WHY A THIRD ANSWER. Green and red are not the only outcomes. On `20260908` two `glow_*desk*`
# witnesses neither passed nor failed: they ran past 250 seconds and were killed, and the loop that
# classified them wrote "red" for something that had returned no answer at all. A red is a claim
# about the code; a timeout is a claim about the run, and a roster row for a hanging witness hangs
# the FLEET, which is worse than the silence it would end. So the two are told apart here.
#
#   sh tools/fixtures/w/witness_probe_scan.sh <witness-path> [--bound 120]
#
# verdict=green    the witness ran and passed
# verdict=red      the witness ran and refused -- a claim about the tree, worth reading
# verdict=hung     the witness did not answer inside the bound -- a claim about the run
# verdict=absent   there is no such file
#
# THE BOUND IS NAMED, never inherited. A probe with no bound is the hang it exists to detect.
set -eu

path=""; bound=120
while [ $# -gt 0 ]; do
  case "$1" in
    --bound) bound=$2; shift 2 ;;
    -*) echo "verdict=unknown_option ($1)"; exit 2 ;;
    *) path=$1; shift ;;
  esac
done
[ -n "$path" ] || { echo "verdict=no_path"; exit 2; }
echo "path=$path"
echo "bound=$bound"
[ -f "$path" ] || { echo "verdict=absent"; exit 1; }

runner=${WITNESS_PROBE_RUNNER:-rishi/bin/rishi}
start=$(date +%s)
timeout "$bound" "$runner" run "$path" >/dev/null 2>&1 && code=0 || code=$?
end=$(date +%s)
echo "seconds=$((end - start))"
echo "code=$code"

# 124 is what `timeout` returns when it kills the child, and that is the whole distinction: the
# witness never answered, so nothing it might have said is known either way.
if [ "$code" -eq 124 ]; then echo "verdict=hung"; exit 1; fi
if [ "$code" -eq 0 ];   then echo "verdict=green"; exit 0; fi
echo "verdict=red"
exit 1
