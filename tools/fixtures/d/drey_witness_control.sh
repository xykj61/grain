#!/bin/sh
# tools/fixtures/d/drey_witness_control.sh -- prove the Mikrophone journey roster refuses on a
# planted failing first rung.
#
# WHAT THIS DOES. tools/d/drey_witness.rish is a choir over sixteen firmware-journey rungs,
# asserting each `.ok` and each `.out contains "GREEN ..."` in rung order. The redleg scan counts
# it as demonstrating no refusal of its own, because each assert inherits a rung's own verdict.
# This control supplies the planted case: a failing DREY0 (`drey_session_witness`) must make the
# roster exit non-zero, and DREY0 passing must make it exit zero -- both directions, one pen. Only
# the first-run rung needs to exist in the pen, since the assert chain stops at the first refusal.
#
# THE PEN IS ENTERED, never addressed from outside. The roster runs each rung by a repository-
# relative path, so the reading is only true from the pen's own root. The rishi binary is symlinked
# rather than copied.
#
# THE PEN IS PROVEN INNOCENT. A roster patched to always exit zero must pass the failing-rung leg,
# proving the refusal above belongs to the roster's assert rather than to the pen.
#
# USAGE
#   sh tools/fixtures/d/drey_witness_control.sh
#
# Run from the repository root.
set -eu

ROOT=$(pwd)
SUITE="$ROOT/tools/d/drey_witness.rish"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/drey_witness_control.XXXXXX") || exit 2
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
  mkdir -p "$PEN/rishi/bin" "$PEN/tools/d"
  ln -s "$ROOT/rishi/bin/rishi" "$PEN/rishi/bin/rishi"
  cp "$SUITE" "$PEN/tools/d/drey_witness.rish"
}

run_suite() { # run_suite <path> ; echoes the exit code
  ( set +e; cd "$PEN" && rishi/bin/rishi run "$1" >/dev/null 2>&1; echo $? )
}

echo "drey_witness_control: planted first rung (DREY0)"

# -- 1. a failing DREY0 must make the roster refuse ----------------------------------------------
mkpen
printf '%s\n' 'assert false else "planted: the rung refused"' > "$PEN/tools/d/drey_session_witness.rish"
check "failing DREY0 refuses" "1" "$(run_suite tools/d/drey_witness.rish)"

# -- 2. DREY0 passing, phrased as the roster wants, must make the roster welcome ------------------
printf '%s\n' 'say "GREEN drey-session"' > "$PEN/tools/d/drey_session_witness.rish"
for rung in wire recorder firmware inbox carry archive catalog manifest serve redact sync forget \
            push reconcile verify; do
  case "$rung" in
    wire) tag="wire" ;;
    recorder) tag="recorder" ;;
    firmware) tag="firmware" ;;
    inbox) tag="inbox" ;;
    carry) tag="carry" ;;
    archive) tag="archive" ;;
    catalog) tag="catalog" ;;
    manifest) tag="manifest" ;;
    serve) tag="serve" ;;
    redact) tag="redact" ;;
    sync) tag="sync" ;;
    forget) tag="forget" ;;
    push) tag="push" ;;
    reconcile) tag="reconcile" ;;
    verify) tag="verify" ;;
  esac
  printf 'say "GREEN drey-%s"\n' "$tag" > "$PEN/tools/d/drey_${rung}_witness.rish"
done
check "all sixteen rungs passing welcomes" "0" "$(run_suite tools/d/drey_witness.rish)"

# -- 3. the pen is proven innocent ----------------------------------------------------------------
sed 's/^assert session.ok else.*/exit 0/' "$PEN/tools/d/drey_witness.rish" > "$PEN/tools/d/patched.rish"
if cmp -s "$PEN/tools/d/drey_witness.rish" "$PEN/tools/d/patched.rish"; then
  echo "  FAIL innocence patch matched nothing -- the patched roster is byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  printf '%s\n' 'assert false else "planted: the rung refused"' > "$PEN/tools/d/drey_session_witness.rish"
  patched_code=$(run_suite tools/d/patched.rish)
  check "patched roster passes a failing DREY0" "0" "$patched_code"
fi

echo "behaviors=$behaviors"
[ "$failed" -eq 0 ] || { echo "FAILED: $failed of $behaviors" >&2; exit 1; }
echo "GREEN: drey_witness_control -- $behaviors behaviors, 0 failing"
