#!/bin/sh
# tools/fixtures/log_has_a_row_scan.sh -- every flat log has a way in.
#
# WHY THIS EXISTS. The session-logs law says a log gets a row in `session-logs/README.md`, and the
# room and its index describe one set. On 20260824 a row was refused three times for standing over
# the 192-byte row bound, and twice the commit shipped anyway -- the writing step and the commit
# were separate commands, so a refusal in the first did not stop the second. A log with no row is a
# record nobody can find from the front door, and nothing in the tree could see one.
#
# The bound is doing its job in each of those cases. This is the other half: a refusal has to STOP
# the lap rather than merely decline to write.
#
# WHAT IS GATED, hard. Every `.kyri` and `.bron` log sitting flat in `session-logs/` is named by a
# link in `session-logs/README.md`. Held at zero missing.
#
# WHAT PASSES FREE, by named rule. A log that has FOLDED into `session-logs/date/YYYYMMDD/` has its
# row on that day's shelf, and the shelf is immutable. The index-fold guard already holds those two
# together; this one watches the flat room only.
#
# WHAT IS NOT PROVEN. That the row says anything useful about its log. Presence is the check.
#
# USAGE
#   sh tools/fixtures/log_has_a_row_scan.sh
#
# Driven by tools/l/log_has_a_row_witness.rish. Run from the repository root.

set -u

root=${LOG_ROW_ROOT:-.}
pin="$root/session-logs/README.md"
[ -f "$pin" ] || { echo "verdict=pin_missing"; exit 1; }

logs=0
missing=0
for f in "$root"/session-logs/*.kyri "$root"/session-logs/*.bron; do
  [ -f "$f" ] || continue
  b=$(basename "$f")
  logs=$((logs + 1))
  grep -qF -- "($b)" "$pin" || { missing=$((missing + 1)); echo "no_row: $b"; }
done

echo "flat_logs=$logs"
echo "logs_without_a_row=$missing"

if [ "$missing" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=log_without_a_row"
  exit 1
fi
