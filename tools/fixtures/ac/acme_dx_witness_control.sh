#!/bin/sh
# tools/fixtures/ac/acme_dx_witness_control.sh -- prove the roster refuses on a planted failing
# first conformance witness.
#
# WHAT THIS DOES. tools/ac/acme_dx_witness.rish is a choir over four conformance witnesses,
# asserting each `.ok` and each `.out contains "GREEN"`. The redleg scan counts it as demonstrating
# no refusal of its own, because each assert inherits a child's own verdict. This control supplies
# the planted case: a failing first witness (`onboarding_path_witness`) must make the roster exit
# non-zero, and every witness passing must make it exit zero -- both directions, one pen.
#
# THE PEN IS ENTERED, never addressed from outside. The roster runs each witness by a repository-
# relative path, so the reading is only true from the pen's own root. The rishi binary is symlinked
# rather than copied.
#
# THE PEN IS PROVEN INNOCENT. A roster patched to always exit zero must pass the failing-witness
# leg, proving the refusal above belongs to the roster's assert rather than to the pen.
#
# USAGE
#   sh tools/fixtures/ac/acme_dx_witness_control.sh
#
# Run from the repository root.
set -eu

ROOT=$(pwd)
SUITE="$ROOT/tools/ac/acme_dx_witness.rish"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/acme_dx_witness_control.XXXXXX") || exit 2
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

mkpen() {
  mkdir -p "$PEN/rishi/bin" "$PEN/tools/ac" "$PEN/tools/o" "$PEN/tools/f" "$PEN/tools/i"
  ln -s "$ROOT/rishi/bin/rishi" "$PEN/rishi/bin/rishi"
  cp "$SUITE" "$PEN/tools/ac/acme_dx_witness.rish"
}

run_suite() { # run_suite <path> ; echoes the exit code
  ( set +e; cd "$PEN" && rishi/bin/rishi run "$1" >/dev/null 2>&1; echo $? )
}

echo "acme_dx_witness_control: planted first witness"

# -- 1. a failing first witness must make the roster refuse -------------------------------------
mkpen
printf '%s\n' 'assert false else "planted: the witness refused"' > "$PEN/tools/o/onboarding_path_witness.rish"
check "failing witness refuses" "1" "$(run_suite tools/ac/acme_dx_witness.rish)"

# -- 2. all four witnesses passing must make the roster welcome ---------------------------------
printf '%s\n' 'say "GREEN"' > "$PEN/tools/o/onboarding_path_witness.rish"
printf '%s\n' 'say "GREEN"' > "$PEN/tools/f/first_hour_witness.rish"
printf '%s\n' 'say "GREEN"' > "$PEN/tools/i/interfaces_conformance_witness.rish"
printf '%s\n' 'say "GREEN"' > "$PEN/tools/o/operations_conformance_witness.rish"
check "all witnesses passing welcomes" "0" "$(run_suite tools/ac/acme_dx_witness.rish)"

# -- 3. the pen is proven innocent ----------------------------------------------------------------
sed 's/^assert onboard.ok else.*/exit 0/' "$PEN/tools/ac/acme_dx_witness.rish" > "$PEN/tools/ac/patched.rish"
if cmp -s "$PEN/tools/ac/acme_dx_witness.rish" "$PEN/tools/ac/patched.rish"; then
  echo "  FAIL innocence patch matched nothing -- the patched roster is byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  printf '%s\n' 'assert false else "planted: the witness refused"' > "$PEN/tools/o/onboarding_path_witness.rish"
  patched_code=$(run_suite tools/ac/patched.rish)
  check "patched roster passes a failing witness" "0" "$patched_code"
fi

echo "behaviors=$behaviors"
[ "$failed" -eq 0 ] || { echo "FAILED: $failed of $behaviors" >&2; exit 1; }
echo "GREEN: acme_dx_witness_control -- $behaviors behaviors, 0 failing"
