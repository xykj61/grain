#!/bin/sh
# one_clock_ceiling_scan.sh — stamps above ceiling (minus erratum) → CEILING_WARN
set -eu
ceiling=$(grep -E '^[0-9]{8}\.[0-9]{6}$' tools/fixtures/one_clock_ceiling.txt | head -1)
erratum=tools/fixtures/one_clock_drift_erratum.txt
test -n "$ceiling"
warn=0
for d in session-logs waymarks counsel foundations counsel/replies; do
  test -d "$d" || continue
  for f in "$d"/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-*; do
    test -e "$f" || continue
    base=$(basename "$f")
    stamp=$(printf '%s' "$base" | sed -n 's/^\([0-9]\{8\}\)-\([0-9]\{6\}\)_.*$/\1.\2/p')
    test -n "$stamp" || continue
    if [ "$stamp" \> "$ceiling" ]; then
      if grep -qx "$stamp" "$erratum" 2>/dev/null; then
        echo "ERRATUM_OK $stamp"
      else
        echo "CEILING_WARN $stamp > $ceiling ($base)"
        warn=1
      fi
    fi
  done
done
if test "$warn" = "0"; then
  echo CEILING_CLEAN
else
  echo CEILING_DIRTY
fi
exit 0
