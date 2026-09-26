#!/bin/sh
# tools/fixtures/gen/fund/gen_linn_fund_prep_control.sh -- prove the retired-name shim refuses on
# a planted failing forward.
#
# WHAT THIS DOES. tools/gen/fund/gen_linn_fund_prep.rish affirms the retired-name Lexicon rows and
# then forwards wholesale to tools/gen/fund/gen_bozo_fund_prep.rish, asserting its `.ok`. The
# redleg scan counts it as demonstrating no refusal of its own, because that assert inherits the
# forward target's own verdict. This control supplies the planted case: a failing gen-bozo target
# must make the shim exit non-zero, and a passing one must make it exit zero -- both directions,
# one pen.
#
# THE PEN IS ENTERED, never addressed from outside. The shim reads context/LEXICON.md and forwards
# to gen_bozo_fund_prep.rish by a repository-relative path, so both must be present in the pen; the
# Lexicon rows are carried verbatim from the living tree so the assert on them holds. The rishi
# binary is symlinked rather than copied.
#
# THE PEN IS PROVEN INNOCENT. A shim patched to always exit zero must pass the failing-target leg,
# proving the refusal above belongs to the shim's assert rather than to the pen.
#
# USAGE
#   sh tools/fixtures/gen/fund/gen_linn_fund_prep_control.sh
#
# Run from the repository root.
set -eu

ROOT=$(pwd)
SHIM="$ROOT/tools/gen/fund/gen_linn_fund_prep.rish"
LEXICON="$ROOT/context/LEXICON.md"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/gen_linn_fund_prep_control.XXXXXX") || exit 2
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
  mkdir -p "$PEN/rishi/bin" "$PEN/tools/gen/fund" "$PEN/context"
  ln -s "$ROOT/rishi/bin/rishi" "$PEN/rishi/bin/rishi"
  cp "$SHIM" "$PEN/tools/gen/fund/gen_linn_fund_prep.rish"
  cp "$LEXICON" "$PEN/context/LEXICON.md"
}

run_shim() { # run_shim <path> ; echoes the exit code
  ( set +e; cd "$PEN" && rishi/bin/rishi run "$1" >/dev/null 2>&1; echo $? )
}

echo "gen_linn_fund_prep_control: planted forward target"

# -- 1. a failing forward target must make the shim refuse --------------------------------------
mkpen
printf '%s\n' 'assert false else "planted: the forward refused"' \
  > "$PEN/tools/gen/fund/gen_bozo_fund_prep.rish"
check "failing forward refuses" "1" "$(run_shim tools/gen/fund/gen_linn_fund_prep.rish)"

# -- 2. a passing forward target must make the shim welcome -------------------------------------
printf '%s\n' 'say "GREEN: gen-bozo -- planted pass"' > "$PEN/tools/gen/fund/gen_bozo_fund_prep.rish"
check "passing forward welcomes" "0" "$(run_shim tools/gen/fund/gen_linn_fund_prep.rish)"

# -- 3. the pen is proven innocent ----------------------------------------------------------------
sed 's/^assert prep.ok else.*/exit 0/' "$PEN/tools/gen/fund/gen_linn_fund_prep.rish" \
  > "$PEN/tools/gen/fund/patched.rish"
if cmp -s "$PEN/tools/gen/fund/gen_linn_fund_prep.rish" "$PEN/tools/gen/fund/patched.rish"; then
  echo "  FAIL innocence patch matched nothing -- the patched shim is byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  printf '%s\n' 'assert false else "planted: the forward refused"' \
    > "$PEN/tools/gen/fund/gen_bozo_fund_prep.rish"
  patched_code=$(run_shim tools/gen/fund/patched.rish)
  check "patched shim passes a failing forward" "0" "$patched_code"
fi

echo "behaviors=$behaviors"
[ "$failed" -eq 0 ] || { echo "FAILED: $failed of $behaviors" >&2; exit 1; }
echo "GREEN: gen_linn_fund_prep_control -- $behaviors behaviors, 0 failing"
