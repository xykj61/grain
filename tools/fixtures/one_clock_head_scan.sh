#!/bin/sh
# one_clock_head_scan.sh -- duty 5: the living head never stands ahead of the clock.
#
# Duty 4 weighs dated artifacts that are new against a base, and its base is
# `origin/main`. A lap that lands and merges puts its artifacts on main, where
# the diff never names them again -- so a stamp written ahead of the clock is
# weighed for exactly as long as it stays unmerged, and never afterward. The one
# number the whole law rests on, the living head, was the number nobody checked.
#
# This duty asks the single question that closes it: at the moment the witness
# runs, is the newest living stamp at or behind the live clock? A head ahead of
# now is a stamp somebody wrote rather than read, and no amount of monotonicity
# can see it -- every false future is monotonic with itself.
#
# ONE_CLOCK_HEAD_TOLERANCE_SECONDS (default 120): a lap stamps, works, and runs
# the witness, so by the time this check runs an honest head is already minutes
# in the past. Two minutes of grace covers clock skew and a same-minute stamp
# without admitting an invented one.
#
# ONE_CLOCK_HEAD_STAMPS: an explicit newline-separated list, for the PASS and
# FAIL fixtures, so both paths are provable without touching the tree.
#
# tools/fixtures/one_clock_head_erratum.txt pins the stamps already written
# ahead of the clock before this duty stood. Accrete-never-break: dated logs
# keep their names, the erratum records the fault, and the guard catches the next.
set -eu

. "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"

TOLERANCE=${ONE_CLOCK_HEAD_TOLERANCE_SECONDS:-120}
ZONE=${ONE_CLOCK_CANONICAL_ZONE:-America/New_York}
erratum=tools/fixtures/one_clock_head_erratum.txt

host_dot=$(TZ="$ZONE" date +%Y%m%d.%H%M%S)
host_epoch=$(TZ="$ZONE" date +%s)

# The parse itself lives in tools/fixtures/shell_portable.sh, because this body stood byte for byte
# in two scans and `date -d` is a GNU extension BSD spells `-j -f` -- one rule two files could come
# to disagree about, in the one place where disagreeing means calling every stamp unparsable.
stamp_to_epoch() {
  TZ="$ZONE" stamp_epoch "$1"
}

bad=0

check_head() {
  stamp=$1
  st_epoch=$(stamp_to_epoch "$stamp") || {
    echo "HEAD_BAD unparsable head stamp ${stamp}"
    bad=$((bad + 1))
    return 0
  }
  delta=$((st_epoch - host_epoch))
  if [ "$delta" -le "$TOLERANCE" ]; then
    echo "HEAD_OK ${stamp} stands ${delta}s from host ${host_dot} (tolerance ${TOLERANCE}s)"
    return 0
  fi
  if grep -qx "$stamp" "$erratum" 2>/dev/null; then
    echo "HEAD_ERRATUM ${stamp} is ${delta}s ahead of host ${host_dot} -- recorded, not rewritten"
    return 0
  fi
  echo "HEAD_BAD ${stamp} is ${delta}s ahead of host ${host_dot} (tolerance ${TOLERANCE}s)"
  bad=$((bad + 1))
}

if [ -n "${ONE_CLOCK_HEAD_STAMPS:-}" ]; then
  while IFS= read -r s; do
    test -n "$s" || continue
    check_head "$s"
  done <<EOF
$(printf '%s\n' "$ONE_CLOCK_HEAD_STAMPS")
EOF
else
  # One definition of "head": the monotonicity scan already names it, so this
  # duty reads that answer rather than growing a second walk that could drift.
  head_line=$(sh tools/fixtures/one_clock_mono_scan.sh | sed -n 's/^TRUE_HEAD \(.*\)$/\1/p' | head -1)
  if [ -z "$head_line" ]; then
    echo "HEAD_BAD the monotonicity scan named no head at all"
    bad=$((bad + 1))
  else
    check_head "$head_line"
  fi
fi

if [ "$bad" -ne 0 ]; then
  echo "HEAD_FAIL count=$bad host=${host_dot} tolerance=${TOLERANCE}s"
  exit 1
fi

echo "HEAD_OK host=${host_dot} tolerance=${TOLERANCE}s zone=${ZONE}"
