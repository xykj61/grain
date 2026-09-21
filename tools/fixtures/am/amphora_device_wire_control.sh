#!/bin/sh
# tools/fixtures/am/amphora_device_wire_control.sh -- prove the shim refuses on a planted failing target.
#
# WHAT THIS DOES. tools/am/amphora_device_wire.rish is an accrete shim over
# tools/gen/amphora/amphora_device_wire.rish: it runs the target, forwards its stdout and stderr,
# and asserts the target's own `ok`. The redleg scan counts it as demonstrating no refusal of its
# own, because the assert inherits the target's verdict rather than planting one. This control
# supplies the case the field withholds: a planted failing target must make the shim exit non-zero,
# and a planted passing target must make it exit zero -- both directions, one pen, so the refusal
# belongs to the plant rather than to the pen.
#
# THE PEN IS ENTERED, never addressed from outside. The shim runs its target by a repository-relative
# path, so the reading is only true from the pen's own root. The rishi binary is symlinked rather
# than copied, so the shim under test is the tracked bytes and the runner is the built one.
#
# THE PEN IS PROVEN INNOCENT. A shim patched to always exit zero must pass the failing-target leg,
# proving the refusal above belongs to the shim's assert rather than to the pen. The patch's landing
# is proven by cmp rather than assumed from a sed exit code (REDS %519).
#
# USAGE
#   sh tools/fixtures/am/amphora_device_wire_control.sh
#
# Run from the repository root.
set -eu

ROOT=$(pwd)
SHIM="$ROOT/tools/am/amphora_device_wire.rish"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/amphora_device_wire_control.XXXXXX") || exit 2
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

# Build the pen: the rishi binary symlinked, the tracked shim copied, and a target planted.
mkpen() {
  mkdir -p "$PEN/rishi/bin" "$PEN/tools/am" "$PEN/tools/gen/amphora"
  ln -s "$ROOT/rishi/bin/rishi" "$PEN/rishi/bin/rishi"
  cp "$SHIM" "$PEN/tools/am/amphora_device_wire.rish"
}

run_shim() { # run_shim ; echoes the shim's exit code
  ( set +e; cd "$PEN" && rishi/bin/rishi run tools/am/amphora_device_wire.rish >/dev/null 2>&1; echo $? )
}

echo "amphora_device_wire_control: planted target"

# -- 1. a failing target must make the shim refuse ---------------------------------------------
mkpen
printf '%s\n' 'assert false else "planted: the target refused"' > "$PEN/tools/gen/amphora/amphora_device_wire.rish"
check "failing target refuses" "1" "$(run_shim)"

# -- 2. a passing target must make the shim welcome --------------------------------------------
printf '%s\n' 'say "GREEN: planted pass"' > "$PEN/tools/gen/amphora/amphora_device_wire.rish"
check "passing target welcomes" "0" "$(run_shim)"

# -- 3. the pen is proven innocent -------------------------------------------------------------
# A shim patched to always exit zero must pass the failing-target leg, proving the refusal above
# belongs to the shim's assert rather than to the pen.
sed 's/^assert r.ok else.*/exit 0/' "$PEN/tools/am/amphora_device_wire.rish" > "$PEN/tools/am/patched.rish"
if cmp -s "$PEN/tools/am/amphora_device_wire.rish" "$PEN/tools/am/patched.rish"; then
  echo "  FAIL innocence patch matched nothing -- the patched shim is byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  printf '%s\n' 'assert false else "planted: the target refused"' > "$PEN/tools/gen/amphora/amphora_device_wire.rish"
  patched_code=$( ( set +e; cd "$PEN" && rishi/bin/rishi run tools/am/patched.rish >/dev/null 2>&1; echo $? ) )
  check "patched shim passes a failing target" "0" "$patched_code"
fi

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
