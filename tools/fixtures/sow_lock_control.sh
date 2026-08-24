#!/bin/sh
# tools/fixtures/sow_lock_control.sh -- prove the projection lock from both sides.
#
#   sh tools/fixtures/sow_lock_control.sh        # all six behaviors (~171s)
#   sh tools/fixtures/sow_lock_control.sh fast   # the four refusals only (~1s)
#
# WHY. tools/fixtures/sow_project.sh clears seed/ and rebuilds it, so while it runs the
# directory is a partial tree. On 20260824 a projection run beside the standing roster --
# whose own `sow` guard re-projects -- reported `copied=1644` against the 6,948 the same
# tree gives alone (REDS %193). The reading was the cheap half; the expensive half is that
# sow_leak_scan.sh, sow_witness.rish, and publish-seed.sh all gate on what stands in seed/,
# so a gate reading a tree still being written has examined a set nobody chose.
#
# WHAT IS PROVEN, both directions, on real directories:
#
#   1 bitten  -- a second projection refuses while a live holder has the lock
#   2 bitten  -- the refusal names the holding pid, so a reader knows who to look for
#   3 bitten  -- the refusal exits 3, distinguishable from a projection that merely failed
#   4 bitten  -- the refusal leaves the holder's lock standing rather than stealing it
#   5 free    -- a lock left by a DEAD pid is cleared rather than wedging forever
#   6 free    -- a run with no lock present takes it and releases it on exit
#
# Cases 1-4 exit before any file is copied and take about a second. Cases 5 and 6 need one
# REAL projection, because release-on-exit is only true if the script actually reaches its
# exit, and that costs 171 seconds measured 20260824.
#
# So `fast` exists, and the standing guard uses it. Release-on-exit is still gated on every
# roster run, by a different guard: tools/s/sow_witness.rish runs the projection itself, so
# a lock leaked by a previous run makes that projection refuse with exit 3 and turns `sow`
# red. The expensive half of this control is therefore proof, run on demand and recorded,
# rather than coverage the roster would otherwise lack.
#
# The lock directory is overridable by SEED_LOCK_DIR so this control never touches the
# real one. Run from the repository root.
set -eu

MODE="${1:-full}"

PASS=0
FAIL=0
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

check() {
  # check <label> <expected> <actual>
  if [ "$2" = "$3" ]; then
    PASS=$((PASS + 1)); echo "$1 -- ok"
  else
    FAIL=$((FAIL + 1)); echo "$1 -- FAIL (wanted $2, got $3)"
  fi
}

LOCK="$PEN/lock"

# ---- 1..4: a live holder is refused, named, exits 3, and keeps its lock ----------------
mkdir -p "$LOCK"
# A pid guaranteed alive for the length of this test: this shell.
printf '%s\n' "$$" > "$LOCK/pid"

set +e
out=$(SEED_LOCK_DIR="$LOCK" sh tools/fixtures/sow_project.sh 2>&1)
code=$?
set -e

case "$out" in
  *"a projection is already running"*) got=refused;;
  *) got=allowed;;
esac
check "1 bitten: a second projection refuses while a live holder has the lock" refused "$got"

case "$out" in
  *"pid $$"*) got=named;; *) got=anonymous;;
esac
check "2 bitten: the refusal names the holding pid" named "$got"

check "3 bitten: the refusal exits 3 rather than 0 or 1" 3 "$code"

[ -f "$LOCK/pid" ] && got=standing || got=stolen
check "4 bitten: the refusal leaves the holder's lock standing" standing "$got"

# The seed directory must be untouched by a refused run -- that is the whole point.
rm -rf "$LOCK"

if [ "$MODE" = fast ]; then
  echo "control_cases=$((PASS + FAIL))"
  echo "control_fail=$FAIL"
  echo "control_mode=fast"
  if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=drift"; exit 1; fi
  exit 0
fi

# ---- 5..6: a dead holder is cleared, and a real run releases on exit -------------------
# A pid that is certainly dead: spawn a shell that exits at once, then reuse its number.
sh -c 'exit 0' &
dead=$!
wait "$dead" 2>/dev/null || true
mkdir -p "$LOCK"
printf '%s\n' "$dead" > "$LOCK/pid"

set +e
out=$(SEED_LOCK_DIR="$LOCK" sh tools/fixtures/sow_project.sh 2>&1)
code=$?
set -e

case "$out" in
  *"clearing a lock left by dead pid"*) got=cleared;;
  *) got=wedged;;
esac
check "5 free: a lock left by a dead pid is cleared rather than wedging forever" cleared "$got"

if [ "$code" -eq 0 ] && [ ! -d "$LOCK" ]; then got=released; else got=held; fi
check "6 free: a completed run releases the lock on exit" released "$got"

echo "control_cases=$((PASS + FAIL))"
echo "control_fail=$FAIL"
echo "control_mode=full"
if [ "$FAIL" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=drift"
  exit 1
fi
