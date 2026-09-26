#!/bin/sh
# tools/fixtures/cr/crypto_vendored_parity_suite_control.sh -- prove the roster refuses on a
# planted failing rung.
#
# WHAT THIS DOES. tools/cr/crypto_vendored_parity_suite.rish is a choir: it runs each vendored-
# parity rung in turn and asserts each exits clean. The redleg scan counts it as demonstrating no
# refusal of its own, because the assert inherits each rung's own verdict rather than planting one.
# This control supplies the case the field withholds: a planted failing FIRST rung must make the
# suite exit non-zero, and a planted passing first rung must make it exit zero -- both directions,
# one pen, so the refusal belongs to the plant rather than to the pen. The `for-each` loop's own
# assert stops at the first failure, so only the first-listed rung
# (`tools/cr/crypto_monocypher_parity_witness.rish`) needs to exist in the pen.
#
# THE PEN IS ENTERED, never addressed from outside. The suite runs each rung by a repository-
# relative path, so the reading is only true from the pen's own root. The rishi binary is symlinked
# rather than copied, so the suite under test is the tracked bytes and the runner is the built one.
#
# THE PEN IS PROVEN INNOCENT. A suite patched to always exit zero must pass the failing-rung leg,
# proving the refusal above belongs to the suite's assert rather than to the pen.
#
# USAGE
#   sh tools/fixtures/cr/crypto_vendored_parity_suite_control.sh
#
# Run from the repository root.
set -eu

ROOT=$(pwd)
SUITE="$ROOT/tools/cr/crypto_vendored_parity_suite.rish"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/crypto_vendored_parity_suite_control.XXXXXX") || exit 2
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
  mkdir -p "$PEN/rishi/bin" "$PEN/tools/cr"
  ln -s "$ROOT/rishi/bin/rishi" "$PEN/rishi/bin/rishi"
  cp "$SUITE" "$PEN/tools/cr/crypto_vendored_parity_suite.rish"
}

run_suite() { # run_suite <path> ; echoes the exit code
  ( set +e; cd "$PEN" && rishi/bin/rishi run "$1" >/dev/null 2>&1; echo $? )
}

echo "crypto_vendored_parity_suite_control: planted first rung"

# -- 1. a failing first rung must make the suite refuse -----------------------------------------
mkpen
printf '%s\n' 'assert false else "planted: the rung refused"' > "$PEN/tools/cr/crypto_monocypher_parity_witness.rish"
check "failing rung refuses" "1" "$(run_suite tools/cr/crypto_vendored_parity_suite.rish)"

# -- 2. a passing first rung must make the suite exit non-zero on the SECOND, absent rung --------
# The first rung passing alone is not enough proof of welcome, since the suite has five more rungs
# to run and none of the rest exist in this pen -- so a passing suite is proven by supplying every
# rung with a trivial passing script.
for rung in crypto_monocypher_parity_witness crypto_monocypher_blake2b_var_parity_witness \
            crypto_monocypher_x25519_parity_witness crypto_monocypher_ed25519_parity_witness \
            crypto_slhdsa_oracle_witness crypto_slhdsa_thash_parity_witness; do
  printf '%s\n' 'say "GREEN: planted pass"' > "$PEN/tools/cr/${rung}.rish"
done
check "all rungs passing welcomes" "0" "$(run_suite tools/cr/crypto_vendored_parity_suite.rish)"

# -- 3. the pen is proven innocent ----------------------------------------------------------------
# A suite patched to always exit zero must pass the failing-rung leg, proving the refusal above
# belongs to the suite's assert rather than to the pen.
sed 's/^for-each rungs as rung do assert.*/exit 0/' "$PEN/tools/cr/crypto_vendored_parity_suite.rish" \
  > "$PEN/tools/cr/patched.rish"
if cmp -s "$PEN/tools/cr/crypto_vendored_parity_suite.rish" "$PEN/tools/cr/patched.rish"; then
  echo "  FAIL innocence patch matched nothing -- the patched suite is byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  printf '%s\n' 'assert false else "planted: the rung refused"' > "$PEN/tools/cr/crypto_monocypher_parity_witness.rish"
  patched_code=$(run_suite tools/cr/patched.rish)
  check "patched suite passes a failing rung" "0" "$patched_code"
fi

echo "behaviors=$behaviors"
[ "$failed" -eq 0 ] || { echo "FAILED: $failed of $behaviors" >&2; exit 1; }
echo "GREEN: crypto_vendored_parity_suite_control -- $behaviors behaviors, 0 failing"
