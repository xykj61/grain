#!/bin/sh
# tools/fixtures/l/log_has_a_row_control.sh -- prove the row check by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). The real room is green, so its RED path
# is shown on planted rooms in a throwaway pen instead.
#
# USAGE
#   sh tools/fixtures/l/log_has_a_row_control.sh
#
# Driven by tools/l/log_has_a_row_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/l/log_has_a_row_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }
abs=$(CDPATH= cd -- "$(dirname -- "$scan")" && pwd)/$(basename "$scan")

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
# The pen mirrors the folded letter room (letter fold, seated 20260828), matching the path the
# run() below names.
mkdir -p "$pen/tools/fixtures/l"
cp "$abs" "$pen/tools/fixtures/l/"

room() { rm -rf "$pen/session-logs"; mkdir -p "$pen/session-logs/date/20260101"; }
pin()  { { echo "# Session logs"; echo; echo "| Stamp | Log | Meaning |"; echo "|---|---|---|"
           for l in "$@"; do echo "| \`x\` | [t]($l) | m |"; done; } > "$pen/session-logs/README.md"; }
run()  { ( cd "$pen" && LOG_ROW_ROOT=. sh tools/fixtures/l/log_has_a_row_scan.sh 2>&1 ); }
val()  { echo "$1" | sed -n "s/^$2=\(.*\)/\1/p" | head -1; }

# 1 -- a flat log with its row passes free.
room; : > "$pen/session-logs/20260824-100000_one.kyri"; pin 20260824-100000_one.kyri
o=$(run); [ "$(val "$o" verdict)" = ok ] && echo "row_present_free=yes" || echo "row_present_free=no"
[ "$(val "$o" flat_logs)" = 1 ] && echo "log_counted=yes" || echo "log_counted=no"

# 2 -- a flat log with NO row is bitten, and named.
room; : > "$pen/session-logs/20260824-100000_one.kyri"; pin
o=$(run)
[ "$(val "$o" verdict)" = log_without_a_row ] && echo "no_row_bitten=yes" || echo "no_row_bitten=no"
[ "$(val "$o" flat_logs_without_a_row)" = 1 ] && echo "no_row_counted=yes" || echo "no_row_counted=no"
echo "$o" | grep -q 'no_row: 20260824-100000_one.kyri' && echo "no_row_named=yes" || echo "no_row_named=no"

# 3 -- one missing among two present is found, rather than the whole room passing on a majority.
room
: > "$pen/session-logs/20260824-100000_one.kyri"
: > "$pen/session-logs/20260824-100001_two.kyri"
: > "$pen/session-logs/20260824-100002_three.bron"
pin 20260824-100000_one.kyri 20260824-100002_three.bron
o=$(run)
[ "$(val "$o" flat_logs_without_a_row)" = 1 ] && echo "one_of_three_found=yes" || echo "one_of_three_found=no"
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

# 6 -- an entirely empty room REFUSES, where the elder control asserted it passed free. The law
# moved under that assertion: since 20260827.171500 the flat room is empty by design, so "empty is
# honest" is exactly the sentence that let nine days of `flat_logs=0` read green.
room; pin
o=$(run); [ "$(val "$o" verdict)" = no_logs ] && echo "empty_room_refused=yes" || echo "empty_room_refused=no"

# 7 -- an absent pin refuses rather than reading zero logs and calling it clean.
room; : > "$pen/session-logs/20260824-100000_one.kyri"; rm -f "$pen/session-logs/README.md"
o=$(run); echo "$o" | grep -q 'verdict=pin_missing' && echo "absent_pin_refused=yes" || echo "absent_pin_refused=no"


# ---------------------------------------------------------------------------
# The shelf readings, from 20260905. A log is born on its day's shelf, so these are the cases the
# elder control could not reach: it proved a folded log FREE and never asked where its row went.

# The pen's shelf world: a day room, its shelf, and a pin whose table names each day and its count.
shelfroom() { rm -rf "$pen/session-logs"; mkdir -p "$pen/session-logs/date"; }
day() {  # day() DAY -- make the day room and an empty shelf
  mkdir -p "$pen/session-logs/date/$1"
  { echo "# shelf $1"; echo; echo "| Stamp | Log | What it recorded |"; echo "|---|---|---|"
  } > "$pen/session-logs/date/README-index-$1.md"
}
log() {  # log() DAY STAMP -- a log file in the day room
  : > "$pen/session-logs/date/$1/$1-$2_x.kyri"
}
shelfrow() {  # shelfrow() DAY STAMP -- the row that reaches it
  echo "| \`$1.$2\` | [t]($1/$1-$2_x.kyri) | m |" >> "$pen/session-logs/date/README-index-$1.md"
}
pintable() {  # pintable() DAY:COUNT ... -- the living pin's shelves table
  { echo "# Session logs"; echo; echo "| Day | Rows | Shelf |"; echo "|---|---|---|"
    for e in "$@"; do
      d=${e%%:*}; c=${e##*:}
      if [ "$c" = open ]; then
        echo "| \`$d\` **open** | **open** | [\`date/README-index-$d.md\`](date/README-index-$d.md) |"
      else
        echo "| \`$d\` | $c | [\`date/README-index-$d.md\`](date/README-index-$d.md) |"
      fi
    done
  } > "$pen/session-logs/README.md"
}

# 8 -- a shelved log WITH its row passes free, and is counted.
shelfroom; day 20260901; log 20260901 100000; shelfrow 20260901 100000; pintable 20260901:open
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "shelved_row_free=yes" || echo "shelved_row_free=no"
[ "$(val "$o" shelved_logs)" = 1 ] && echo "shelved_counted=yes" || echo "shelved_counted=no"

# 9 -- a shelved log with NO row, after the born-on-shelf law, is bitten and named.
shelfroom; day 20260901; log 20260901 100000; pintable 20260901:open
o=$(run)
[ "$(val "$o" verdict)" = shelf_row_missing ] && echo "shelf_gap_bitten=yes" || echo "shelf_gap_bitten=no"
[ "$(val "$o" post_law_logs_without_a_row)" = 1 ] && echo "shelf_gap_counted=yes" || echo "shelf_gap_counted=no"
echo "$o" | grep -q 'no_row: 20260901/20260901-100000_x.kyri' && echo "shelf_gap_named=yes" || echo "shelf_gap_named=no"

# 10 -- one missing among three on a shelf is found, rather than the majority carrying the day.
shelfroom; day 20260901
log 20260901 100000; log 20260901 100001; log 20260901 100002
shelfrow 20260901 100000; shelfrow 20260901 100002
pintable 20260901:open
o=$(run)
[ "$(val "$o" post_law_logs_without_a_row)" = 1 ] && echo "shelf_one_of_three=yes" || echo "shelf_one_of_three=no"

# 11 -- a gap BEFORE the law is elder: counted, reported, never gated.
shelfroom; day 20260801; log 20260801 100000; day 20260901; log 20260901 100000
shelfrow 20260901 100000; pintable 20260901:open 20260801:0
o=$(run)
[ "$(val "$o" elder_logs_without_a_row)" = 1 ] && echo "elder_counted=yes" || echo "elder_counted=no"
[ "$(val "$o" post_law_logs_without_a_row)" = 0 ] && echo "elder_not_post=yes" || echo "elder_not_post=no"
[ "$(val "$o" verdict)" = ok ] && echo "elder_free_under_ceiling=yes" || echo "elder_free_under_ceiling=no"

# 12 -- the elder ceiling, proven from both sides: free at the ceiling, bitten one past it.
o=$( ( cd "$pen" && LOG_ROW_ROOT=. LOG_ROW_ELDER_CEILING=1 sh tools/fixtures/l/log_has_a_row_scan.sh 2>&1 ) )
[ "$(val "$o" verdict)" = ok ] && echo "elder_ceiling_free=yes" || echo "elder_ceiling_free=no"
o=$( ( cd "$pen" && LOG_ROW_ROOT=. LOG_ROW_ELDER_CEILING=0 sh tools/fixtures/l/log_has_a_row_scan.sh 2>&1 ) )
[ "$(val "$o" verdict)" = elder_over_ceiling ] && echo "elder_ceiling_bitten=yes" || echo "elder_ceiling_bitten=no"

# 13 -- a tree with no logs anywhere refuses, rather than reporting a spotless tree. This is the
# shape that stood for nine days: an emptied population answers zero on every reading a gate holds
# at zero, and zero is the answer everyone wants to hear.
shelfroom; pintable 20260901:open
o=$(run)
[ "$(val "$o" verdict)" = no_logs ] && echo "empty_tree_refused=yes" || echo "empty_tree_refused=no"

# 13b -- a tree whose logs are all FLAT, with no shelf yet, passes free. There is one floor rather
# than two: a shelf room holding index files for no logs is reported loudly by the count above.
shelfroom; : > "$pen/session-logs/20260901-100000_flat.kyri"
{ echo "# Session logs"; echo; echo "| \`x\` | [t](20260901-100000_flat.kyri) | m |"; } > "$pen/session-logs/README.md"
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "flat_only_tree_free=yes" || echo "flat_only_tree_free=no"

# 14 -- a shelf with no log refuses too, for the same reason.
shelfroom; day 20260901; pintable 20260901:open
o=$(run)
[ "$(val "$o" verdict)" = no_logs ] && echo "no_logs_refused=yes" || echo "no_logs_refused=no"

# 15 -- a day shelf the pin never names is bitten and named: the front door missing a room.
shelfroom; day 20260901; log 20260901 100000; shelfrow 20260901 100000
day 20260902; log 20260902 100000; shelfrow 20260902 100000
pintable 20260902:open
o=$(run)
[ "$(val "$o" verdict)" = pin_shelf_missing ] && echo "pin_gap_bitten=yes" || echo "pin_gap_bitten=no"
echo "$o" | grep -q 'no_pin_row: 20260901' && echo "pin_gap_named=yes" || echo "pin_gap_named=no"

# 16 -- a closed day whose pin count disagrees with its shelf is bitten, and freed by the repair.
shelfroom; day 20260901; log 20260901 100000; shelfrow 20260901 100000
day 20260902; log 20260902 100000; shelfrow 20260902 100000
pintable 20260902:open 20260901:9
o=$(run)
[ "$(val "$o" verdict)" = pin_count_drift ] && echo "pin_drift_bitten=yes" || echo "pin_drift_bitten=no"
echo "$o" | grep -q 'pin_drift: 20260901 pin=9 shelf=1' && echo "pin_drift_named=yes" || echo "pin_drift_named=no"
pintable 20260902:open 20260901:1
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "pin_drift_repaired=yes" || echo "pin_drift_repaired=no"

# 17 -- the OPEN day is exempt from the count, because its shelf gains a row every lap.
shelfroom; day 20260902; log 20260902 100000; shelfrow 20260902 100000; pintable 20260902:open
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "open_day_count_exempt=yes" || echo "open_day_count_exempt=no"

# 18 -- the pin marking yesterday open while today's shelf stands is bitten. This is the fault a
# reader actually hits: the front door says "open the newest shelf" and names the wrong one.
shelfroom; day 20260901; log 20260901 100000; shelfrow 20260901 100000
day 20260902; log 20260902 100000; shelfrow 20260902 100000
pintable 20260901:open 20260902:1
o=$(run)
[ "$(val "$o" verdict)" = pin_open_stale ] && echo "pin_open_stale_bitten=yes" || echo "pin_open_stale_bitten=no"
pintable 20260902:open 20260901:1
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "pin_open_repaired=yes" || echo "pin_open_repaired=no"

# 19 -- a non-day shelf gathering (`README-index-through-YYYYMMDD.md`) is read for its links and
# never mistaken for a day the pin must count.
shelfroom; day 20260902; log 20260902 100000
mkdir -p "$pen/session-logs/date/20260801"
: > "$pen/session-logs/date/20260801/20260801-100000_x.kyri"
{ echo "# gathering"; echo "- \`20260801.100000\` - [t](20260801/20260801-100000_x.kyri) - m"
} > "$pen/session-logs/date/README-index-through-20260801.md"
shelfrow 20260902 100000; pintable 20260902:open
o=$(run)
[ "$(val "$o" verdict)" = ok ] && echo "gathering_read_free=yes" || echo "gathering_read_free=no"
[ "$(val "$o" elder_logs_without_a_row)" = 0 ] && echo "gathering_links_counted=yes" || echo "gathering_links_counted=no"

echo "control_verdict=ok"
