#!/bin/sh
# tools/fixtures/index_row_bound_scan.sh -- an index row points; it does not summarise.
#
# WHY THIS EXISTS. REDS %204: `session-logs/README.md` folded correctly and still stood 5,421 bytes
# above the 24,576 it declares. The fold was not the problem. The rows were: 36 of them averaging
# 783 bytes, the longest 2,223, with the meaning column carrying 655 bytes of the 783. That is the
# session log's own abstract copied into the index -- a second copy of the record, which is exactly
# the single-strandedness this tree keeps: THE LOGS ARE THE RECORD, THE INDEX IS THE WAY IN.
#
# Keaton chose shorter rows on 20260824. This is the number that makes that choice checkable.
#
# THE BOUND, and where it comes from rather than from taste. A row costs about 123 bytes before it
# says anything: 21 for the stamp cell, ~97 for the title-and-filename link, 5 for the pipes. The
# pin's own bound is 24,576 and its prose takes roughly 2,100, leaving about 22,400 for rows. At
#
#     192 bytes -- a power of two, like the 256-file room bound and the 24,576-byte pin bound --
#
# the pin holds about 116 rows and the meaning column gets ~69 characters, which is a clause that
# points rather than a paragraph that restates.
#
# WHAT IS GATED, hard. Every row of every LIVING index pin named below stays at or under 192 bytes.
#
# WHAT PASSES FREE, by named rule. A shelf under `<room>/date/README-index-YYYYMMDD.md` is immutable
# once written and keeps every byte it wrote (accrete-never-break). This gates what is written from
# here forward, in the one file a lap actually appends to.
#
# WHAT THIS DOES NOT FIX, and it is worth reading before trusting the bound. The room bound is 256
# flat files and a meaning-free row still costs ~123 bytes, so 256 rows need ~31,500 -- above the
# pin's 24,576 whatever a row says. The two seated bounds cannot both hold at the room's own
# ceiling (REDS %205). This bound makes the pin fit a MEDIAN day (61 logs measured across 61 days)
# and a heavy one still overflows: 15 of those 61 days ran past 116 logs, the peak at 223.
#
# USAGE
#   sh tools/fixtures/index_row_bound_scan.sh          # census
#   sh tools/fixtures/index_row_bound_scan.sh list     # every row over the bound, longest first
#
# Driven by tools/in/index_row_bound_witness.rish. Run from the repository root.

set -u

verb=${1:-census}
root=${INDEX_ROW_ROOT:-.}
ROW_MAX=${INDEX_ROW_MAX:-192}

# The living pins, named rather than discovered, so a page joins the gated tier by a hand.
PINS="session-logs/README.md"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

: > "$work/over.txt"
total=0
over=0
longest=0
for pin in $PINS; do
  [ -f "$root/$pin" ] || { echo "verdict=pin_missing $pin"; exit 1; }
  # A row is a table line whose first cell opens with a backticked one-clock stamp. A delimiter
  # row, a header row, and a prose line carrying pipes all name no stamp and are read past.
  awk -v pin="$pin" -v max="$ROW_MAX" '
    /^\|[ \t]*`[0-9]{8}\.[0-9]{6}`/ {
      n = length($0) + 1
      total++
      if (n > max) { over++; printf "over\t%d\t%s\t%s\n", n, pin, substr($0, 1, 90) }
      if (n > longest) longest = n
    }
    END { printf "tally\t%d\t%d\t%d\n", total, over, longest }
  ' "$root/$pin" >> "$work/rows.txt"
done

grep '^over' "$work/rows.txt" | sort -t"$(printf '\t')" -k2 -rn > "$work/over.txt" || :
total=$(awk -F'\t' '/^tally/ {s+=$2} END {print s+0}' "$work/rows.txt")
over=$(awk -F'\t' '/^tally/ {s+=$3} END {print s+0}' "$work/rows.txt")
longest=$(awk -F'\t' '/^tally/ {if ($4+0 > m) m = $4+0} END {print m+0}' "$work/rows.txt")

if [ "$verb" = list ]; then
  cat "$work/over.txt"
  exit 0
fi

head -5 "$work/over.txt" | while IFS="$(printf '\t')" read -r _ n p t; do
  printf 'over: %s bytes in %s -- %s\n' "$n" "$p" "$t"
done

echo "pins=$(echo $PINS | wc -w | tr -d ' ')"
echo "rows=$total"
echo "rows_over=$over"
echo "row_max=$ROW_MAX"
echo "longest_row=$longest"

if [ "$over" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=rows_over_bound"
  exit 1
fi
