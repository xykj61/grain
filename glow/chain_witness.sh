#!/bin/sh
# glow/chain_witness.sh -- prove the Glow chain end to end: lower, refuse a false sum, compile, and run.
#
# Usage: sh glow/chain_witness.sh
# The chain uses the field's Glow runner (glow/bin/glow_run) and its Rye compiler (rye/bin/rye). It writes only to a
# scratch folder, which it removes at the end. A true sum must lower, compile, and exit 0. A planted false sum must be
# refused at lowering with exit 1, and it must never reach the compiler. Any other result reds by name.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
GLOW="$ROOT/glow/bin/glow_run"
RYE="$ROOT/rye/bin/rye"
W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
cd "$W"

# invariant: both tools exist before any generator is written, or the run stops by name.
[ -x "$GLOW" ] || { echo "red: no Glow runner at glow/bin/glow_run" >&2; exit 1; }
[ -x "$RYE" ] || { echo "red: no Rye compiler at rye/bin/rye" >&2; exit 1; }

printf '%s\n' '::  true sum: the threshold 32 holds against the tick (witness).' '?>  (gth tick 32)  1' > orbit-true.glow
printf '%s\n' '::  planted false sum: the threshold 50 must be refused (witness).' '?>  (gth tick 50)  1' > orbit-false.glow

# the true sum lowers
"$GLOW" orbit-true.glow >/dev/null 2>&1 || { echo "red: the true sum did not lower" >&2; exit 1; }
# the false sum is refused at lowering, and nothing is emitted for it
if "$GLOW" orbit-false.glow >/dev/null 2>&1; then
  echo "red: the planted false sum lowered; it must be refused" >&2; exit 1
fi
[ ! -e glow/.cache/orbit-false.rye ] || { echo "red: a refused sum left a file behind" >&2; exit 1; }

# the lowered true sum compiles and runs with exit 0
"$RYE" build glow/.cache/orbit-true.rye -femit-bin=orbit-true >/dev/null 2>&1 || { echo "red: the lowered sum did not compile" >&2; exit 1; }
./orbit-true || { echo "red: the compiled sum did not exit 0" >&2; exit 1; }

echo "green: glow chain holds -- true sum lowers, compiles, and runs; false sum refused at lowering"
