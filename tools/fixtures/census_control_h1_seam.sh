#!/bin/sh
# Census control -- H1 fence-count seam (POSIX). Counts only; orchestration validates.
# No backtick characters in patterns.
#
#   sh tools/fixtures/census_control_h1_seam.sh
set -eu

H1_FIXTURE=tools/fixtures/census_control_h1_fenced.md

if ! test -f "$H1_FIXTURE"; then
  echo "CONTROL=ABSENT"
  echo "duty=h1_fixture"
  echo "verdict=absent"
  exit 1
fi

# Count H1 headings (^#\s) two ways: naive over every line, true only outside fenced
# code blocks. Fence state toggles on a ``` delimiter line, which is itself skipped.
# awk, not python -- this pier has no python3 on PATH (Python -> Rishi molt 20260809).
COUNTS=$(awk '
  {
    is_fence = ($0 ~ /^[[:space:]]*```/)
    if (is_fence) { infence = !infence }
    is_h1 = ($0 ~ /^#[[:space:]]/)
    if (is_h1) n++
    if (is_h1 && !infence && !is_fence) t++
  }
  END { print "true=" t+0; print "naive=" n+0 }
' "$H1_FIXTURE")
TRUE=$(printf '%s\n' "$COUNTS" | sed -n 's/^true=//p' | head -1)
NAIVE=$(printf '%s\n' "$COUNTS" | sed -n 's/^naive=//p' | head -1)

echo "duty1_h1_true=${TRUE}"
echo "duty1_h1_naive=${NAIVE}"
exit 0
