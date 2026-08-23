#!/bin/sh
# glow_build_concurrency_scan.sh -- two witnesses may build at once, and neither ruins the other.
#
# The hazard this measures is not hypothetical. Every glow_run_worker.sh invocation rebuilds
# glow/bin/glow_run and writes glow/.cache, so a sweep running beside a hand-run gate wrote the
# same bytes from two processes at once. The loser executed a half-written binary and reported
# RED about its own logic while nothing was wrong with it -- three false REDs in one round --
# and a build killed midway left a truncated glow_run standing for the next, entirely clean run
# to trust.
#
# The scan proves the guard rather than describing it, in three parts:
#   1. PRESENT  -- the worker still carries both guards, by marker, so this can never pass by
#      measuring a worker that quietly lost them.
#   2. UNGUARDED -- a twin generated from the real worker with exactly those two guards stripped
#      is run in parallel lanes and must fail. Generated rather than kept, so the control can
#      never drift away from the worker it is a control for.
#   3. GUARDED  -- the real worker is run in the same lanes and must not fail at all, must answer
#      on every lane, and must leave no temporary behind.
#
# Purely local: no key, no signature, no network, no funds, no real device.
#
#   sh tools/fixtures/glow_build_concurrency_scan.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

WORKER=tools/g/glow_run_worker.sh
# Bounded on purpose: six lanes reproduced the race every time it was measured, and the scan
# should cost one build's wall time rather than a sweep's.
LANES=6
DESK=src/lib/gate-caravan-dependents-bound-u32.glow
SAMPLE=2
TWIN=tools/.glow_build_concurrency_control.sh
WORKDIR=$(mktemp -d)

cleanup() { rm -f "$TWIN"; rm -rf "$WORKDIR"; }
trap cleanup EXIT INT TERM

echo "CONC_LANES $LANES"

# --- 1. the guards are still there -------------------------------------------------
guards=0
grep -q '^flock -w "\$BUILD_LOCK_WAIT" 9' "$WORKER" && guards=$((guards + 1))
grep -q '^  mv -f "\$_dst\.\$TMP_TAG" "\$_dst"' "$WORKER" && guards=$((guards + 1))
echo "CONC_GUARDS_PRESENT $guards"
if test "$guards" -ne 2; then
  echo "CONC_BAD the worker no longer carries both guards -- lock and atomic install"
  exit 0
fi

# --- 2. the twin without them, generated from the worker itself ---------------------
awk '
  /^exec 9>"\$BUILD_LOCK"$/      { skip = 5 }
  skip > 0                        { skip = skip - 1; next }
  /^  mv -f "\$_dst\.\$TMP_TAG" "\$_dst"$/ { next }
  { gsub(/-femit-bin="\$_dst\.\$TMP_TAG"/, "-femit-bin=\"$_dst\""); print }
' "$WORKER" > "$TWIN"

if grep -q 'flock' "$TWIN"; then
  echo "CONC_BAD the control twin still holds a lock -- the strip did not apply"
  exit 0
fi
sh -n "$TWIN" || { echo "CONC_BAD the control twin is not valid shell"; exit 0; }

unguarded_fails=0
i=1
while test "$i" -le "$LANES"; do
  ( sh "$TWIN" "$DESK" "$SAMPLE" >"$WORKDIR/u$i.log" 2>&1 || echo x >>"$WORKDIR/ufail" ) &
  i=$((i + 1))
done
wait
test -f "$WORKDIR/ufail" && unguarded_fails=$(wc -l < "$WORKDIR/ufail" | tr -d ' ')
echo "CONC_UNGUARDED_FAILS $unguarded_fails"

# --- 3. the real worker, same lanes -------------------------------------------------
guarded_fails=0
i=1
while test "$i" -le "$LANES"; do
  ( sh "$WORKER" "$DESK" "$SAMPLE" >"$WORKDIR/g$i.log" 2>&1 || echo x >>"$WORKDIR/gfail" ) &
  i=$((i + 1))
done
wait
test -f "$WORKDIR/gfail" && guarded_fails=$(wc -l < "$WORKDIR/gfail" | tr -d ' ')
answered=$(cat "$WORKDIR"/g*.log 2>/dev/null | grep -c '^EXIT:0$' || true)
leftovers=$(ls glow/bin/*.building.* 2>/dev/null | wc -l | tr -d ' ')
echo "CONC_GUARDED_FAILS $guarded_fails"
echo "CONC_GUARDED_ANSWERED $answered"
echo "CONC_LEFTOVER_TEMPS $leftovers"

# --- the verdict --------------------------------------------------------------------
if test "$unguarded_fails" -eq 0; then
  echo "CONC_BAD the unguarded twin survived $LANES lanes -- the control proves nothing"
elif test "$guarded_fails" -ne 0; then
  echo "CONC_BAD the guarded worker failed $guarded_fails of $LANES lanes"
elif test "$answered" -ne "$LANES"; then
  echo "CONC_BAD only $answered of $LANES guarded lanes answered EXIT:0"
elif test "$leftovers" -ne 0; then
  echo "CONC_BAD $leftovers half-built temporaries left behind"
else
  echo "CONC_OK"
fi
exit 0
