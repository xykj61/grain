#!/bin/sh
# one_clock_mono_scan.sh -- false-future gate (monotonic true head).
#
# true_head = max(living stamps not listed in the drift erratum).
# Any living stamp greater than true_head must be on the erratum list
# (the four UTC-window files). Unlisted false-futures -> MONO_BAD.
#
# TRUE_HEAD is what duty 5 consumes (tools/fixtures/o/one_clock_head_scan.sh),
# and duty 5 is the leg with teeth: it alone weighs the head against the LIVE
# clock. This scan's own monotonicity leg is self-satisfying by construction --
# true_head is the maximum OF the population, so no population stamp can exceed
# it, and a year-2099 stamp simply becomes the head. So the population this
# scan reads is the population duty 5 can refuse a fabricated stamp in, and
# nothing wider.
#
# That population is every dated basename in the five rooms, FLAT OR FOLDED,
# and the fold half is why this reads with find rather than a flat glob. A
# session log is BORN on its day shelf from 20260827.171500, so `session-logs/*`
# holds none at all: measured 20260911.020039, the flat glob read 247 of 7,344
# dated artifacts, 3.4%, and the newest living stamp in the tree stood six hours
# past the head this scan named. A log stamped four hours ahead of the clock, on
# the shelf the law requires, was invisible to both duties; moved flat, the same
# file reds duty 5 at once. The erratum-integrity half below already searched
# session-logs/date, so one file held two answers to where logs live.
#
# The stamp spelling is [_.] rather than _, because the sprig is OPTIONAL: 237
# dated files carry a stamp and no sprig, and a pattern requiring one reads
# every last of them as absent (the REDS %175 shape; tools/fixtures/d/
# dated_spelling_scan.sh gates 19 sites for it and never named this one).
#
# Whole-list reads rather than per-stamp greps: the erratum exclusion and the
# above-head reading are each one pass over the list, because a `grep -qx` per
# stamp cost 5.5s at 247 stamps and would spawn 7,344 subprocesses at the real
# population.
set -eu
erratum=tools/fixtures/o/one_clock_drift_erratum.txt
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

for d in session-logs waymarks counsel foundations counsel/replies; do
  test -d "$d" || continue
  find "$d" -type f -name '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]*' 2>/dev/null
done | sed 's#.*/##' \
     | sed -n 's/^\([0-9]\{8\}\)-\([0-9]\{6\}\)[_.].*$/\1.\2/p' \
     | sort -u >"$tmp"

# One pass: drop the erratum stamps, take the last of a sorted list.
true_head=$(grep -vxF -f "$erratum" "$tmp" 2>/dev/null | tail -1 || true)

if test -z "$true_head"; then
  echo "MONO_BAD no non-erratum living stamp"
  exit 0
fi

echo "TRUE_HEAD $true_head"
bad=0
# One pass for the stamps above the head. Every one must be on the erratum --
# and by the construction named at the top, every one always is.
above=$(awk -v h="$true_head" '$0 > h' "$tmp")
if test -n "$above"; then
  for stamp in $above; do
    if grep -qx "$stamp" "$erratum" 2>/dev/null; then
      echo "ERRATUM_OK $stamp"
    else
      echo "MONO_BAD $stamp > true_head $true_head (unlisted false-future)"
      bad=1
    fi
  done
fi

# Erratum integrity: each listed stamp must still exist in the tree -- as a living
# file, or (accrete-never-break) as a folded log under session-logs/date/, since a
# day's logs fold there by stamp and leave the top-level living glob unchanged in name.
# The fold destination molted archive/ -> date/ on 20260821.161758 with the mark law; the
# elder name is still searched so this guard reads a tree folded either way rather than
# going quietly weaker on a clone that has not moved yet.
while IFS= read -r line; do
  case "$line" in
    ''|\#*) continue ;;
  esac
  if grep -qx "$line" "$tmp"; then
    continue
  fi
  d="${line%.*}"
  t="${line#*.}"
  if find session-logs/date session-logs/archive -name "${d}-${t}_*" 2>/dev/null | grep -q .; then
    echo "ERRATUM_ARCHIVED $line"
    continue
  fi
  echo "MONO_BAD erratum stamp missing from the tree (living or archived): $line"
  bad=1
done <"$erratum"

if test "$bad" = "0"; then
  echo MONO_OK
fi
exit 0
