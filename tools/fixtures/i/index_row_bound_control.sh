#!/bin/sh
# tools/fixtures/i/index_row_bound_control.sh -- prove the row bound by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and the live pin is green, so its RED
# path cannot be shown there without damaging it. This control plants index pins in a throwaway pen
# and shows every reading from both sides.
#
# USAGE
#   sh tools/fixtures/i/index_row_bound_control.sh
#
# Driven by tools/in/index_row_bound_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/i/index_row_bound_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }
scan_abs=$(CDPATH= cd -- "$(dirname -- "$scan")" && pwd)/$(basename "$scan")

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
# The pen mirrors the folded letter room (letter fold, seated 20260828), matching the path the
# run() below names.
mkdir -p "$pen/tools/fixtures/i" "$pen/session-logs/date"
cp "$scan_abs" "$pen/tools/fixtures/i/"
# The pin's own planted rows carry a link, and from 20260830 a row's link must resolve, so the
# fixture the rows point at exists beside the pin the way a real log exists beside a real row.
: > "$pen/session-logs/f.kyri"

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

run() { ( cd "$pen" && INDEX_ROW_ROOT=. sh tools/fixtures/i/index_row_bound_scan.sh "$@" 2>&1 ); }
val() { echo "$1" | sed -n "s/^$2=\(.*\)/\1/p" | head -1; }

# 1 -- the bound, from both sides, at the exact byte.
pin "$(row 20260824.100000 192)"
o=$(run); [ "$(val "$o" verdict)" = ok ] && echo "at_bound_free=yes" || echo "at_bound_free=no"
[ "$(val "$o" longest_row)" = 192 ] && echo "at_bound_measured=yes" || echo "at_bound_measured=no ($(val "$o" longest_row))"

pin "$(row 20260824.100000 193)"
o=$(run); [ "$(val "$o" verdict)" = rows_over_bound ] && echo "over_bound_bitten=yes" || echo "over_bound_bitten=no"
[ "$(val "$o" rows_over)" = 1 ] && echo "over_bound_counted=yes" || echo "over_bound_counted=no"

# 2 -- a short row passes free, and the count of rows is the count of rows.
# Descending, because a pin reads newest first and from 20260906 the scan gates that (REDS %440).
# These three fixtures were written ascending, which asserted nothing and modelled a page no room
# in this tree carries; flipping them changes no reading they make.
pin "$(row 20260824.100002 120)" "$(row 20260824.100001 130)" "$(row 20260824.100000 140)"
o=$(run)
[ "$(val "$o" rows)" = 3 ] && echo "rows_counted=yes" || echo "rows_counted=no"
[ "$(val "$o" verdict)" = ok ] && echo "short_rows_free=yes" || echo "short_rows_free=no"

# 3 -- one long row among short ones is found, and named.
pin "$(row 20260824.100002 120)" "$(row 20260824.100001 400)" "$(row 20260824.100000 140)"
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


# --- shelf helpers, added 20260830 with the open-shelf reading (REDS %381) --------------
# A shelf is planted by day, so a control can say which one is OPEN (the newest) and which is
# CLOSED (any older one) rather than hoping the scan guesses the same way this tree does.
shelf() {                     # shelf <day> <line>...
  day=$1; shift
  { echo "# shelf"; echo; echo "| Stamp | Log | Meaning |"; echo "|---|---|---|"
    for l in "$@"; do echo "$l"; done; } > "$pen/session-logs/date/README-index-$day.md"
}
noshelf() { rm -f "$pen"/session-logs/date/README-index-*.md; }
# A row whose link resolves, and one whose link does not, so "points" is planted from both sides.
linkrow() { printf '| `%s` | [t](%s) | m |\n' "$1" "$2"; }

mkdir -p "$pen/session-logs/date/20260830"
: > "$pen/session-logs/date/20260830/a.kyri"

# 6a -- a CLOSED shelf keeps every byte it wrote, however long, and points wherever it pointed.
pin "$(row 20260824.100000 120)"
shelf 20260101 "$(row 20260101.010101 900)" "$(row 20260101.010101 120)" "$(linkrow 20260101.010102 nowhere.kyri)"
shelf 20260830 "$(linkrow 20260830.100000 20260830/a.kyri)"
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "closed_shelf_free=yes" || echo "closed_shelf_free=no"
[ "$(val "$o" rows)" = 2 ] && echo "closed_shelf_uncounted=yes" || echo "closed_shelf_uncounted=no ($(val "$o" rows))"
[ "$(val "$o" open_shelf)" = 20260830 ] && echo "open_shelf_named=yes" || echo "open_shelf_named=no"

# 6b -- the OPEN shelf is the file a lap appends to, so the bound reaches it.
shelf 20260830 "$(row 20260830.100000 193)"
o=$(run)
[ "$(val "$o" verdict)" = rows_over_bound ] && echo "open_shelf_bound_bitten=yes" || echo "open_shelf_bound_bitten=no"
[ "$(val "$o" rows_over)" = 1 ] && echo "open_shelf_bound_counted=yes" || echo "open_shelf_bound_counted=no"

# 6c -- a row that points nowhere fails "an index row points", read from the page's own directory.
shelf 20260830 "$(linkrow 20260830.100000 20260830-100000_a.kyri)"
o=$(run)
[ "$(val "$o" verdict)" = rows_unresolved ] && echo "unresolved_bitten=yes" || echo "unresolved_bitten=no"
[ "$(val "$o" rows_unresolved)" = 1 ] && echo "unresolved_counted=yes" || echo "unresolved_counted=no"
echo "$o" | grep -q '^unresolved: .* -> 20260830-100000_a.kyri' && echo "unresolved_named=yes" || echo "unresolved_named=no"
shelf 20260830 "$(linkrow 20260830.100000 20260830/a.kyri)"
o=$(run); [ "$(val "$o" verdict)" = ok ] && echo "resolved_free=yes" || echo "resolved_free=no"

# 6d -- two rows carrying one stamp are one log wearing two rows, which is how a rebase left a
# stale row naming REDS numbers the ledger had moved past.
shelf 20260830 "$(linkrow 20260830.100000 20260830/a.kyri)" "$(linkrow 20260830.100000 20260830/a.kyri)"
o=$(run)
[ "$(val "$o" verdict)" = rows_duplicate ] && echo "duplicate_bitten=yes" || echo "duplicate_bitten=no"
[ "$(val "$o" rows_duplicate)" = 1 ] && echo "duplicate_counted=yes" || echo "duplicate_counted=no"
shelf 20260830 "$(linkrow 20260830.100001 20260830/a.kyri)" "$(linkrow 20260830.100000 20260830/a.kyri)"
o=$(run); [ "$(val "$o" verdict)" = ok ] && echo "distinct_stamps_free=yes" || echo "distinct_stamps_free=no"

# 6g -- the rows descend, which is the promise the page makes in its own title. A rebase that
# auto-merges two rows CLEANLY -- no marker, nothing to resolve -- can still seat the older above
# the newer, and every other reading here stays green while it does (REDS %440).
shelf 20260830 "$(linkrow 20260830.100002 20260830/a.kyri)" "$(linkrow 20260830.100001 20260830/a.kyri)" "$(linkrow 20260830.100000 20260830/a.kyri)"
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "descending_free=yes" || echo "descending_free=no"
[ "$(val "$o" rows_misordered)" = 0 ] && echo "descending_counted_zero=yes" || echo "descending_counted_zero=no"
shelf 20260830 "$(linkrow 20260830.100002 20260830/a.kyri)" "$(linkrow 20260830.100000 20260830/a.kyri)" "$(linkrow 20260830.100001 20260830/a.kyri)"
o=$(run)
[ "$(val "$o" verdict)" = rows_misordered ] && echo "misordered_bitten=yes" || echo "misordered_bitten=no"
[ "$(val "$o" rows_misordered)" = 1 ] && echo "misordered_counted=yes" || echo "misordered_counted=no"
# The seam is named from both sides, so a hand knows which pair to swap rather than which page to
# re-read -- the reading that made the elder rebase repair take an eye rather than a command.
echo "$o" | grep -q '^misordered: .* -- 20260830.100000 stands above 20260830.100001' \
  && echo "misordered_named=yes" || echo "misordered_named=no"
# A tie belongs to the DUPLICATE reading, never this one, so one fault is never counted twice.
shelf 20260830 "$(linkrow 20260830.100000 20260830/a.kyri)" "$(linkrow 20260830.100000 20260830/a.kyri)"
o=$(run)
[ "$(val "$o" rows_misordered)" = 0 ] && echo "tie_is_not_misorder=yes" || echo "tie_is_not_misorder=no"
[ "$(val "$o" verdict)" = rows_duplicate ] && echo "tie_stays_duplicate=yes" || echo "tie_stays_duplicate=no"
# A CLOSED shelf out of order keeps every byte it wrote, and needed no exemption of its own: it
# never enters the read set, so the order gate inherits accrete-never-break from where it stands.
shelf 20260101 "$(row 20260101.010100 120)" "$(row 20260101.010102 120)" "$(row 20260101.010101 120)"
shelf 20260830 "$(linkrow 20260830.100001 20260830/a.kyri)" "$(linkrow 20260830.100000 20260830/a.kyri)"
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "closed_shelf_order_free=yes" || echo "closed_shelf_order_free=no"
[ "$(val "$o" rows_misordered)" = 0 ] && echo "closed_shelf_order_uncounted=yes" || echo "closed_shelf_order_uncounted=no"
rm -f "$pen"/session-logs/date/README-index-20260101.md

# 6e -- a `through-` gathering names no day, so it is never mistaken for the open shelf.
shelf through-20260721 "$(row 20260721.010101 900)"
o=$(run)
[ "$(val "$o" open_shelf)" = 20260830 ] && echo "through_not_open=yes" || echo "through_not_open=no ($(val "$o" open_shelf))"
[ "$(val "$o" verdict)" = ok ] && echo "through_free=yes" || echo "through_free=no"

# 6f -- a room with no shelf yet contributes nothing rather than refusing, so a fresh clone reads.
noshelf
o=$(run)
[ "$(val "$o" open_shelf)" = none ] && echo "no_shelf_none=yes" || echo "no_shelf_none=no"
[ "$(val "$o" verdict)" = ok ] && echo "no_shelf_free=yes" || echo "no_shelf_free=no"

# 7 -- an absent pin refuses rather than reading zero rows and calling it clean.
rm -f "$pen/session-logs/README.md"
o=$(run); echo "$o" | grep -q 'verdict=pin_missing' && echo "absent_pin_refused=yes" || echo "absent_pin_refused=no"

# 8 -- the bound is one number, taken from the environment only so a control can plant against it.
pin "$(row 20260824.100000 250)"
o=$( ( cd "$pen" && INDEX_ROW_ROOT=. INDEX_ROW_MAX=300 sh tools/fixtures/i/index_row_bound_scan.sh 2>&1 ) )
[ "$(val "$o" row_max)" = 300 ] && echo "bound_readable=yes" || echo "bound_readable=no"
[ "$(val "$o" verdict)" = ok ] && echo "bound_applies=yes" || echo "bound_applies=no"

echo "control_verdict=ok"
