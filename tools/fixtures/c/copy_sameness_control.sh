#!/bin/sh
# tools/fixtures/c/copy_sameness_control.sh -- prove the drift refusal fires on a planted
# mismatch, and only on a mismatch.
#
# WHAT THIS DOES. tools/gen/chapter/copy_sameness_witness.rish asserts
# tools/fixtures/c/copy_sameness_scan.sh prints `verdict=ok`, where the scan's own verdict is
# inherited from a tree-wide md5sum walk rather than demonstrated against a planted case. The
# redleg scan (REDS %827) counts it as a guard with no refusal marker of its own. This control
# supplies the case the field withholds: the scan already carries a second positional argument
# naming one extra path to compare against the canon, built for exactly this fixture use (see the
# scan's own header). Three legs, one pen: the ordinary tree-wide walk stays GREEN; an extra path
# byte-identical to the canon stays GREEN too, proving a mismatch alone trips the refusal rather
# than the argument's mere presence; and an extra path that differs refuses.
#
# THE PEN IS ENTERED, never addressed from outside. The scan is run from the repository root so
# its tree-wide walk reads real tracked state; the planted extra paths live under a throwaway
# directory this control owns and cleans up.
#
# USAGE
#   sh tools/fixtures/c/copy_sameness_control.sh
#
# Run from the repository root.
set -eu

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/c/copy_sameness_scan.sh"
CANON="$ROOT/tally/copy.rye"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/copy_sameness_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

behaviors=0
failed=0

check() { # check <name> <expected> <actual>
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok   $1"
  else
    echo "  FAIL $1 -- wanted [$2] got [$3]"
    failed=$((failed + 1))
  fi
}

run_scan() { # run_scan [extra] ; echoes "exit=<code> verdict=<word>"
  code=0
  out=$(cd "$ROOT" && sh "$SCAN" ignored "${1:-}" 2>&1) || code=$?
  v=$(printf '%s\n' "$out" | grep -o 'verdict=[a-z]*' | tail -1)
  echo "exit=$code $v"
}

echo "copy_sameness_control: planted extra-path comparison"

# -- 1. the ordinary tree-wide walk, no extra path -----------------------------------------------
check "ordinary walk welcomes" "exit=0 verdict=ok" "$(run_scan)"

# -- 2. an extra path byte-identical to the canon still welcomes ---------------------------------
same="$PEN/same.rye"
cp "$CANON" "$same"
check "identical extra path welcomes" "exit=0 verdict=ok" "$(run_scan "$same")"

# -- 3. an extra path that differs from the canon refuses ----------------------------------------
drifted="$PEN/drifted.rye"
printf '%s\n' "planted: this byte never matches tally/copy.rye" > "$drifted"
check "drifted extra path refuses" "exit=1 verdict=drift" "$(run_scan "$drifted")"

echo "behaviors=$behaviors"
[ "$failed" -eq 0 ] || { echo "FAILED: $failed of $behaviors" >&2; exit 1; }
echo "GREEN: copy_sameness_control -- $behaviors behaviors, 0 failing"
