#!/bin/sh
# tools/fixtures/l/log_has_a_row_scan.sh -- every log has a way in, wherever the law puts it.
#
# WHY THIS EXISTS. The session-logs law says a log gets a row in the index that promises to hold it,
# so the room and its index describe one set. On 20260824 a row was refused three times for standing
# over the 192-byte row bound, and twice the commit shipped anyway -- the writing step and the commit
# were separate commands, so a refusal in the first did not stop the second. A log with no row is a
# record nobody can find from the front door, and nothing in the tree could see one.
#
# WHY IT READS THE SHELVES, from 20260905. This scan watched `session-logs/*.kyri` -- the FLAT room --
# and its elder control proved a folded log free "because its row is on the day's shelf." That
# exemption was correct and its destination was never checked. Then 20260827.171500 seated
# BORN ON ITS DAY'S SHELF: a log is written straight to `date/YYYYMMDD/` and the flat room is empty
# by design. So the exemption grew to cover every log in the tree, the scan measured `flat_logs=0`,
# and it reported `verdict=ok` for nine days while four logs stood unreachable from any front door.
#
# This is the shape REDS %381 found one room over, in this scan's own sibling: `index_row_bound`
# read the pin alone, measured `rows=0`, and passed for four days while the open shelf carried 87
# rows for 64 logs. Same law moved both files; one guard was repointed and one was not.
#
# AN EMPTY POPULATION IS THE TELL. A gate held at zero cannot tell a clean collection from a dead
# instrument, since both answer zero (REDS %416). So this scan floors its own reach: no shelf read,
# or no log found, refuses rather than reporting a spotless tree.
#
# WHAT IS GATED, hard. Every log under `session-logs/date/YYYYMMDD/` stamped on or after the
# born-on-shelf law (20260827) is named by a link in an index. Held at zero. Every log sitting flat
# in `session-logs/` is named by a link in the pin. Held at zero.
#
# AND THE THIRD PAIR, from the same reading. The room, the shelf, and the pin are meant to describe
# one set, and nothing bound the last pair either. The pin's own sentence is "the newest day's shelf
# is the one to open," and on 20260905 it named 20260904 while seven laps stood on today's shelf --
# a reader following the front door lands on yesterday. Its counts drift the same silent way: they
# are typed once when a day closes and never re-derived, so a closed shelf that later gains a row
# leaves the number behind. Four days had drifted, one of them by six. Both are derivable, so both
# are gated: every day shelf on disk carries a pin row, the newest shelf is the day marked open, and
# a closed day's count equals its shelf's rows. Each is repaired by editing the living pin alone.
#
# WHY NO CLOSED-SHELF EXEMPTION, where the sibling has one. `index_row_bound` passes a closed shelf
# free because its faults -- a row over its bound, a duplicate stamp -- can only be repaired by
# rewriting bytes a closed shelf has promised to keep. A MISSING row is repaired by adding one, and
# accretion is what accrete-never-break asks for rather than what it forbids. So a post-law gap is
# gated on any day, open or closed.
#
# WHAT IS RATCHETED, never gated. Logs on days BEFORE the law, whose shelves were written by bulk
# folds that moved files without carrying every row. 216 stand at seating, the largest block being
# 20260712-20260717 at 211. That block is reached in PART rather than not at all: no DAY-named index
# covers it, and the aggregate shelf README-index-through-20260721.md carries 162 of its 373 logs,
# leaving 211 whose row was never written. A ceiling that only falls; repairing them is its own round
# and its own word.
#
# WHAT IS NOT PROVEN. That a row says anything useful about its log. Presence is the check, and the
# 192-byte row bound is what keeps the presence from becoming a paragraph.
#
# USAGE
#   sh tools/fixtures/l/log_has_a_row_scan.sh
#
# Driven by tools/l/log_has_a_row_witness.rish. Run from the repository root.

set -u

root=${LOG_ROW_ROOT:-.}
pin="$root/session-logs/README.md"
[ -f "$pin" ] || { echo "verdict=pin_missing"; exit 1; }

# The born-on-shelf law: from this day a log is written straight to its shelf, so a gap after it is
# a lap that skipped its row rather than a fold that never carried one.
born_on_shelf_day=${LOG_ROW_LAW_DAY:-20260827}
elder_ceiling=${LOG_ROW_ELDER_CEILING:-216}

# The flat room -- still the law for a log written flat by hand, and still gated at zero.
flat=0
flat_missing=0
for f in "$root"/session-logs/*.kyri "$root"/session-logs/*.bron; do
  [ -f "$f" ] || continue
  b=$(basename "$f")
  flat=$((flat + 1))
  grep -qF -- "($b)" "$pin" || { flat_missing=$((flat_missing + 1)); echo "no_row: $b"; }
done

# The shelves -- one find and one awk, rather than a grep per log across four thousand of them.
# awk reads every index file first and collects its links, then reads the log list from stdin.
#
# The index files are collected into the argument list rather than passed as a glob: an unexpanded
# glob is a filename awk cannot open, and awk dies on it having printed no END block at all. That
# turns every reading below into the empty string, which the shell then reads as zero -- the exact
# shape this rung exists to refuse, arriving through its own instrument.
set --
for f in "$root"/session-logs/date/README-index-*.md; do
  [ -f "$f" ] && set -- "$@" "$f"
done
reading=$(find "$root/session-logs/date" -type f \( -name '*.kyri' -o -name '*.bron' \) -print 2>/dev/null | awk \
  -v law="$born_on_shelf_day" -v pin="$pin" '
  # The living pin: one row per day, naming a count and the shelf that holds it.
  FILENAME == pin {
    if (match($0, /^\| `20[0-9][0-9][01][0-9][0-3][0-9]` *(\*\*open\*\*)? *\|/)) {
      match($0, /20[0-9][0-9][01][0-9][0-3][0-9]/); d = substr($0, RSTART, RLENGTH)
      split($0, c, "|"); n = c[3]; gsub(/[ *]/, "", n)
      pin_count[d] = n; pin_rows++
      if (n == "open") pin_open = d
    }
    next
  }
  # Every index file: collect the links it makes, and count the rows it carries.
  FILENAME != "-" {
    s = $0
    while (match(s, /\]\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\/[^)]+\)/)) {
      seen[substr(s, RSTART + 2, RLENGTH - 3)] = 1
      s = substr(s, RSTART + RLENGTH)
    }
    if (!(FILENAME in shelf)) {
      shelf[FILENAME] = 1; shelves++
      sd = FILENAME; sub(/.*README-index-/, "", sd); sub(/\.md$/, "", sd)
      shelf_day[FILENAME] = sd
      if (sd ~ /^[0-9]{8}$/) { day_shelf[sd] = 1; if (sd > newest) newest = sd }
    }
    if ($0 ~ /^[|-] `20[0-9][0-9][01][0-9][0-3][0-9]\.[0-9]{6}`/) rows[shelf_day[FILENAME]]++
    next
  }
  # The log list, arriving on stdin after every index file has been read.
  {
    n = split($0, p, "/")
    if (n < 2) next
    day = p[n-1]; key = day "/" p[n]
    logs++
    if (key in seen) next
    if (day >= law) { post++; print "no_row: " key } else { elder++ }
  }
  END {
    for (d in day_shelf) {
      if (!(d in pin_count)) { pin_missing++; print "no_pin_row: " d; continue }
      if (d == newest) continue
      if (pin_count[d] == "open") continue
      # An empty shelf carries zero rows rather than no reading; unset would compare unequal to "0"
      # and report a drift that is not there.
      rd = (d in rows) ? rows[d] : 0
      if (pin_count[d] != rd) {
        drift++; print "pin_drift: " d " pin=" pin_count[d] " shelf=" rd
      }
    }
    printf "shelves_read=%d\nshelved_logs=%d\npost_law_logs_without_a_row=%d\nelder_logs_without_a_row=%d\n",
      shelves, logs, post, elder
    printf "pin_rows=%d\npin_shelves_missing=%d\npin_count_drift=%d\npin_open_day=%s\nnewest_shelf=%s\n",
      pin_rows, pin_missing, drift, (pin_open == "" ? "none" : pin_open), (newest == "" ? "none" : newest)
  }
' "$pin" "$@" -)

echo "$reading"
echo "flat_logs=$flat"
echo "flat_logs_without_a_row=$flat_missing"
echo "elder_ceiling=$elder_ceiling"

val() { echo "$reading" | sed -n "s/^$1=\(.*\)/\1/p" | head -1; }

# The instrument must have SPOKEN. An awk that died prints no END block, so every reading below
# would be the empty string and every gate held at zero would pass.
case "$reading" in
  *shelved_logs=*) : ;;
  *) echo "verdict=reading_absent"; exit 1 ;;
esac
shelves=$(val shelves_read)
shelved=$(val shelved_logs)
post=$(val post_law_logs_without_a_row)
elder=$(val elder_logs_without_a_row)

# The flat gate first -- it discloses its own population, and a flat log missing its row is a fault
# whatever the shelves hold.
if [ "$flat_missing" -ne 0 ]; then
  echo "verdict=log_without_a_row"; exit 1
fi

# The instrument floor, before the shelf verdicts. A dead find or a missing room answers zero on
# every reading a gate holds at zero, which is byte-identical to a tree where every log has its row.
# The floor reads the whole population, flat and shelved together: what it refuses is a scan that
# found NO logs anywhere, since nine days of `flat_logs=0` reading green is what this rung is for.
if [ $((flat + shelved)) -eq 0 ]; then
  echo "verdict=no_logs"; exit 1
fi
if [ "$post" -ne 0 ]; then
  echo "verdict=shelf_row_missing"; exit 1
fi
if [ "$elder" -gt "$elder_ceiling" ]; then
  echo "verdict=elder_over_ceiling"; exit 1
fi
if [ "$(val pin_shelves_missing)" -ne 0 ]; then
  echo "verdict=pin_shelf_missing"; exit 1
fi
if [ "$(val pin_count_drift)" -ne 0 ]; then
  echo "verdict=pin_count_drift"; exit 1
fi
if [ "$(val pin_open_day)" != "$(val newest_shelf)" ]; then
  echo "verdict=pin_open_stale"; exit 1
fi

echo "verdict=ok"
