#!/bin/sh
# tools/fixtures/log_has_a_row_control.sh -- prove the row check by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). The real room is green, so its RED path
# is shown on planted rooms in a throwaway pen instead.
#
# USAGE
#   sh tools/fixtures/log_has_a_row_control.sh
#
# Driven by tools/l/log_has_a_row_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/log_has_a_row_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }
abs=$(CDPATH= cd -- "$(dirname -- "$scan")" && pwd)/$(basename "$scan")

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures"
cp "$abs" "$pen/tools/fixtures/"

room() { rm -rf "$pen/session-logs"; mkdir -p "$pen/session-logs/date/20260101"; }
pin()  { { echo "# Session logs"; echo; echo "| Stamp | Log | Meaning |"; echo "|---|---|---|"
           for l in "$@"; do echo "| \`x\` | [t]($l) | m |"; done; } > "$pen/session-logs/README.md"; }
run()  { ( cd "$pen" && LOG_ROW_ROOT=. sh tools/fixtures/log_has_a_row_scan.sh 2>&1 ); }
val()  { echo "$1" | sed -n "s/^$2=\(.*\)/\1/p" | head -1; }

# 1 -- a flat log with its row passes free.
room; : > "$pen/session-logs/20260824-100000_one.kyri"; pin 20260824-100000_one.kyri
o=$(run); [ "$(val "$o" verdict)" = ok ] && echo "row_present_free=yes" || echo "row_present_free=no"
[ "$(val "$o" flat_logs)" = 1 ] && echo "log_counted=yes" || echo "log_counted=no"

# 2 -- a flat log with NO row is bitten, and named.
room; : > "$pen/session-logs/20260824-100000_one.kyri"; pin
o=$(run)
[ "$(val "$o" verdict)" = log_without_a_row ] && echo "no_row_bitten=yes" || echo "no_row_bitten=no"
[ "$(val "$o" logs_without_a_row)" = 1 ] && echo "no_row_counted=yes" || echo "no_row_counted=no"
echo "$o" | grep -q 'no_row: 20260824-100000_one.kyri' && echo "no_row_named=yes" || echo "no_row_named=no"

# 3 -- one missing among two present is found, rather than the whole room passing on a majority.
room
: > "$pen/session-logs/20260824-100000_one.kyri"
: > "$pen/session-logs/20260824-100001_two.kyri"
: > "$pen/session-logs/20260824-100002_three.bron"
pin 20260824-100000_one.kyri 20260824-100002_three.bron
o=$(run)
[ "$(val "$o" logs_without_a_row)" = 1 ] && echo "one_of_three_found=yes" || echo "one_of_three_found=no"
[ "$(val "$o" flat_logs)" = 3 ] && echo "bron_counted=yes" || echo "bron_counted=no"

# 4 -- a FOLDED log needs no row in the living pin; its row is on the day's shelf.
room; : > "$pen/session-logs/date/20260101/20260101-100000_folded.kyri"; pin
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "folded_free=yes" || echo "folded_free=no"
[ "$(val "$o" flat_logs)" = 0 ] && echo "folded_uncounted=yes" || echo "folded_uncounted=no"

# 5 -- a substring must not answer for a filename: `_one.kyri` is not `_one-more.kyri`.
room; : > "$pen/session-logs/20260824-100000_one-more.kyri"; pin 20260824-100000_one.kyri
o=$(run)
[ "$(val "$o" verdict)" = log_without_a_row ] && echo "substring_refused=yes" || echo "substring_refused=no"

# 6 -- an empty room is honest rather than an error.
room; pin
o=$(run); [ "$(val "$o" verdict)" = ok ] && echo "empty_room_free=yes" || echo "empty_room_free=no"

# 7 -- an absent pin refuses rather than reading zero logs and calling it clean.
room; : > "$pen/session-logs/20260824-100000_one.kyri"; rm -f "$pen/session-logs/README.md"
o=$(run); echo "$o" | grep -q 'verdict=pin_missing' && echo "absent_pin_refused=yes" || echo "absent_pin_refused=no"

echo "control_verdict=ok"
