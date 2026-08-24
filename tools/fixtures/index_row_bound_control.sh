#!/bin/sh
# tools/fixtures/index_row_bound_control.sh -- prove the row bound by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and the live pin is green, so its RED
# path cannot be shown there without damaging it. This control plants index pins in a throwaway pen
# and shows every reading from both sides.
#
# USAGE
#   sh tools/fixtures/index_row_bound_control.sh
#
# Driven by tools/in/index_row_bound_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/index_row_bound_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }
scan_abs=$(CDPATH= cd -- "$(dirname -- "$scan")" && pwd)/$(basename "$scan")

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures" "$pen/session-logs/date"
cp "$scan_abs" "$pen/tools/fixtures/"

pad() { i=0; s=""; while [ "$i" -lt "$1" ]; do s="${s}x"; i=$((i + 1)); done; printf '%s' "$s"; }

# A row of an exact byte length, so a boundary is planted rather than approximated.
row() {                       # row <stamp> <total-bytes>
  head="| \`$1\` | [t](f.kyri) | "
  tail=" |"
  n=$(( $2 - ${#head} - ${#tail} - 1 ))
  [ "$n" -lt 1 ] && n=1
  printf '%s%s%s\n' "$head" "$(pad $n)" "$tail"
}

pin() {                       # pin <line>...
  { echo "# Session logs"; echo; echo "| Stamp | Log | Meaning |"; echo "|---|---|---|"
    for l in "$@"; do echo "$l"; done; } > "$pen/session-logs/README.md"
}

run() { ( cd "$pen" && INDEX_ROW_ROOT=. sh tools/fixtures/index_row_bound_scan.sh "$@" 2>&1 ); }
val() { echo "$1" | sed -n "s/^$2=\(.*\)/\1/p" | head -1; }

# 1 -- the bound, from both sides, at the exact byte.
pin "$(row 20260824.100000 192)"
o=$(run); [ "$(val "$o" verdict)" = ok ] && echo "at_bound_free=yes" || echo "at_bound_free=no"
[ "$(val "$o" longest_row)" = 192 ] && echo "at_bound_measured=yes" || echo "at_bound_measured=no ($(val "$o" longest_row))"

pin "$(row 20260824.100000 193)"
o=$(run); [ "$(val "$o" verdict)" = rows_over_bound ] && echo "over_bound_bitten=yes" || echo "over_bound_bitten=no"
[ "$(val "$o" rows_over)" = 1 ] && echo "over_bound_counted=yes" || echo "over_bound_counted=no"

# 2 -- a short row passes free, and the count of rows is the count of rows.
pin "$(row 20260824.100000 120)" "$(row 20260824.100001 130)" "$(row 20260824.100002 140)"
o=$(run)
[ "$(val "$o" rows)" = 3 ] && echo "rows_counted=yes" || echo "rows_counted=no"
[ "$(val "$o" verdict)" = ok ] && echo "short_rows_free=yes" || echo "short_rows_free=no"

# 3 -- one long row among short ones is found, and named.
pin "$(row 20260824.100000 120)" "$(row 20260824.100001 400)" "$(row 20260824.100002 140)"
o=$(run)
[ "$(val "$o" rows_over)" = 1 ] && echo "one_of_three_found=yes" || echo "one_of_three_found=no"
echo "$o" | grep -q '^over: 400 bytes' && echo "over_row_named=yes" || echo "over_row_named=no"
[ "$(val "$o" longest_row)" = 400 ] && echo "longest_reported=yes" || echo "longest_reported=no"

# 4 -- a header row, a delimiter row, and prose carrying pipes are not rows.
pin "| not a stamp | x | y |" "|---|---|---|" "| \`nonsense\` | x | y |"
o=$(run)
[ "$(val "$o" rows)" = 0 ] && echo "non_rows_read_past=yes" || echo "non_rows_read_past=no ($(val "$o" rows))"
[ "$(val "$o" verdict)" = ok ] && echo "non_rows_free=yes" || echo "non_rows_free=no"

# 5 -- a hyphen-form stamp is a FILENAME, never a row's first cell, and must not be counted.
pin "| \`20260824-100000\` | x | $(pad 400) |"
o=$(run); [ "$(val "$o" rows)" = 0 ] && echo "hyphen_stamp_read_past=yes" || echo "hyphen_stamp_read_past=no"

# 6 -- an immutable shelf keeps every byte it wrote, however long.
pin "$(row 20260824.100000 120)"
{ echo "# shelf"; row 20260101.010101 900; } > "$pen/session-logs/date/README-index-20260101.md"
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "shelf_free=yes" || echo "shelf_free=no"
[ "$(val "$o" rows)" = 1 ] && echo "shelf_uncounted=yes" || echo "shelf_uncounted=no"

# 7 -- an absent pin refuses rather than reading zero rows and calling it clean.
rm -f "$pen/session-logs/README.md"
o=$(run); echo "$o" | grep -q 'verdict=pin_missing' && echo "absent_pin_refused=yes" || echo "absent_pin_refused=no"

# 8 -- the bound is one number, taken from the environment only so a control can plant against it.
pin "$(row 20260824.100000 250)"
o=$( ( cd "$pen" && INDEX_ROW_ROOT=. INDEX_ROW_MAX=300 sh tools/fixtures/index_row_bound_scan.sh 2>&1 ) )
[ "$(val "$o" row_max)" = 300 ] && echo "bound_readable=yes" || echo "bound_readable=no"
[ "$(val "$o" verdict)" = ok ] && echo "bound_applies=yes" || echo "bound_applies=no"

echo "control_verdict=ok"
