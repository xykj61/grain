#!/bin/sh
# tools/fixtures/i/index_row_bound_scan.sh -- an index row points; it does not summarise.
#
# WHY THIS EXISTS. REDS %204: `session-logs/README.md` folded correctly and still stood 5,421 bytes
# above the 24,576 it declares. The fold was not the problem. The rows were: 36 of them averaging
# 783 bytes, the longest 2,223, with the meaning column carrying 655 bytes of the 783. That is the
# session log's own abstract copied into the index -- a second copy of the record, which is exactly
# the single-strandedness this tree keeps: THE LOGS ARE THE RECORD, THE INDEX IS THE WAY IN.
#
# Keaton chose shorter rows on 20260824. This is the number that makes that choice checkable.
#
# WHY IT READS THE OPEN SHELF TOO, from 20260830. This scan's own header sentence has always been
# "this gates the one file a lap actually appends to," and on 20260827.171500 the birth-on-shelf law
# moved that file. A log is now written straight to `<room>/date/YYYYMMDD/` and its row prepended to
# `<room>/date/README-index-YYYYMMDD.md`, so the pin holds one row per DAY and the rows a lap writes
# land on the shelf. Pointed at the pin alone the scan read **rows=0** and reported `verdict=ok` for
# four days. Measured on 20260830 with six bodies writing one shelf: 87 rows for 64 logs -- six over
# the bound, eleven links resolving to no file, and 23 duplicate stamps, one of them still crediting
# `%380` for a red its own log books at `%379` (REDS %381).
# A guard measuring an empty set is greener than a guard that is right.
#
# WHICH SHELF IS OPEN, derived rather than clocked. The open shelf is the newest `README-index-<day>`
# in the room, taken by name rather than by reading the wall clock, so a control can plant one in a
# pen and get the same answer this tree gets. `README-index-through-YYYYMMDD.md` is a closed
# gathering rather than a day, so the pattern takes digits only.
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
# WHAT IS GATED, hard, on every page named below -- the living pin and the open shelf.
#   Every row stays at or under 192 bytes.
#   Every row's link resolves to a file the tree carries, read relative to the page's own directory.
#     A row that points nowhere fails "an index row points" more completely than a long row does.
#   No two rows name one log. A duplicate is one log wearing two rows, and a rebase that re-applies
#     an updated row without lifting the stale one leaves both -- which is how two rows came to name
#     REDS %364-368 after the ledger had moved to %365-369. The key is the LOG the row points at,
#     never the stamp: two ships write inside one second roughly every eleven days at this fleet's
#     rate, and those are two records rather than one (REDS %676).
#   The rows descend. A page that promises NEWEST FIRST keeps that promise in its own document
#     order, and a rebase that auto-merges two rows cleanly can still seat the older above the
#     newer (REDS %440, %445's sibling). This is the same rebase, one fault over: the duplicate
#     reading catches two rows where one belongs, and this one catches two rows in the wrong order.
#
# WHAT PASSES FREE, by named rule. A CLOSED shelf -- any `README-index-<day>` that is not the newest
# -- is immutable once its day closes and keeps every byte it wrote (accrete-never-break).
#
# WHAT THIS DOES NOT FIX, and it is worth reading before trusting the bound. The room bound is 256
# flat files and a meaning-free row still costs ~123 bytes, so 256 rows need ~31,500 -- above the
# pin's 24,576 whatever a row says (REDS %205). This bound makes the pin fit a MEDIAN day (61 logs
# measured across 61 days) and a heavy one still overflows: 15 of those 61 days ran past 116 logs,
# the peak at 223.
#
# USAGE
#   sh tools/fixtures/i/index_row_bound_scan.sh          # census
#   sh tools/fixtures/i/index_row_bound_scan.sh list     # every row over the bound, longest first
#
# Driven by tools/in/index_row_bound_witness.rish. Run from the repository root.

set -u

verb=${1:-census}
root=${INDEX_ROW_ROOT:-.}
ROW_MAX=${INDEX_ROW_MAX:-192}

# The living pins, named rather than discovered, so a page joins the gated tier by a hand.
PINS="session-logs/README.md"

# The open shelf, discovered: the newest day index in the same room. A room with no shelf yet
# contributes nothing rather than refusing, so a fresh pen and a fresh clone both read cleanly.
SHELF_ROOM=${INDEX_ROW_SHELF_ROOM:-session-logs/date}
open_shelf=$(ls "$root/$SHELF_ROOM" 2>/dev/null \
  | sed -n 's/^README-index-\([0-9][0-9]*\)\.md$/\1/p' \
  | sort | tail -1)
[ -n "$open_shelf" ] && PINS="$PINS $SHELF_ROOM/README-index-$open_shelf.md"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

: > "$work/rows.txt"
: > "$work/over.txt"
: > "$work/links.txt"
: > "$work/stamps.txt"
: > "$work/keys.txt"
total=0
over=0
longest=0
for pin in $PINS; do
  [ -f "$root/$pin" ] || { echo "verdict=pin_missing $pin"; exit 1; }
  # A row is a table line whose first cell opens with a backticked one-clock stamp. A delimiter
  # row, a header row, and a prose line carrying pipes all name no stamp and are read past.
  awk -v pin="$pin" -v max="$ROW_MAX" -v stampf="$work/stamps.txt" -v linkf="$work/links.txt" \
      -v keyf="$work/keys.txt" '
    /^\|[ \t]*`[0-9]{8}\.[0-9]{6}`/ {
      n = length($0) + 1
      total++
      if (n > max) { over++; printf "over\t%d\t%s\t%s\n", n, pin, substr($0, 1, 90) }
      if (n > longest) longest = n
      # The stamp orders the row. It does not identify it -- see the duplicate reading below.
      if (match($0, /`[0-9]{8}\.[0-9]{6}`/)) {
        printf "%s\t%s\n", pin, substr($0, RSTART + 1, RLENGTH - 2) >> stampf
      }
      # The row link is what "points" means, so it is read and later resolved on the filesystem.
      first = ""
      line = $0
      while (match(line, /\]\([^)]+\)/)) {
        target = substr(line, RSTART + 2, RLENGTH - 3)
        sub(/#.*$/, "", target)
        if (target != "" && target !~ /^(https?:|mailto:|\/)/) {
          printf "%s\t%s\n", pin, target >> linkf
          if (first == "") first = target
        }
        line = substr(line, RSTART + RLENGTH)
      }
      # THE ROW IDENTITY IS THE LOG IT NAMES. A row carrying no link at all names no log, so it
      # keys on its own bytes -- two such rows are the same row only when they are the same text.
      printf "%s\t%s\n", pin, (first == "" ? "row:" $0 : first) >> keyf
    }
    END { printf "tally\t%d\t%d\t%d\n", total, over, longest }
  ' "$root/$pin" >> "$work/rows.txt"
done

grep '^over' "$work/rows.txt" | sort -t"$(printf '\t')" -k2 -rn > "$work/over.txt" || :
total=$(awk -F'\t' '/^tally/ {s+=$2} END {print s+0}' "$work/rows.txt")
over=$(awk -F'\t' '/^tally/ {s+=$3} END {print s+0}' "$work/rows.txt")
longest=$(awk -F'\t' '/^tally/ {if ($4+0 > m) m = $4+0} END {print m+0}' "$work/rows.txt")

# A link resolves against the directory of the page that carries it, which is the whole of the
# fault this reading was added for: a shelf row written with the pin's relative depth points at
# `<room>/date/<name>` where the log sits at `<room>/date/<day>/<name>`.
: > "$work/unresolved.txt"
while IFS="$(printf '\t')" read -r page target; do
  [ -n "${page:-}" ] || continue
  dir=$(dirname "$root/$page")
  [ -e "$dir/$target" ] || printf '%s\t%s\n' "$page" "$target" >> "$work/unresolved.txt"
done < "$work/links.txt"
unresolved=$(wc -l < "$work/unresolved.txt" | tr -d ' ')

# THE DUPLICATE READING KEYS ON THE LOG A ROW NAMES, never on the second it was written in
# (REDS %676, answered `20260910`). One log wearing two rows is the fault a rebase leaves, and both
# of its rows point at one file. Two logs written inside one second are two records, and the naming
# law already resolves them by sprig -- so refusing them made a lawful day illegal, and the repair
# jammed two logs into one row and lost the one-to-one between a row and the record it points at.
#
# MEASURED BEFORE THE KEY MOVED, over the 73 revisions of `session-logs/date/README-index-20260830.md`
# where this reading last fired hard: 89 duplicate stamps carried ONE link and 64 carried two. Every
# one of the 64 was the SAME log written at two depths -- `20260830/x.kyri` beside a bare `x.kyri` --
# which is the depth fault, and the bare form resolves to nothing, so `rows_unresolved` refuses it
# one branch above this one. So the raw link target is an exact key here rather than an approximate
# one: an unresolved row never reaches this reading.
#
# Across the tree at `20260910.004817`: 78 seconds carry two or more logs, and every day shelf reads
# zero duplicate rows under BOTH keys. The two keys agree on the tree as it stands and part on the
# next collision, which is roughly every eleven days at 130 laps and rises with the square of the
# fleet's daily count.
: > "$work/dupes.txt"
sort "$work/keys.txt" | uniq -d > "$work/dupes.txt" || :
dupes=$(wc -l < "$work/dupes.txt" | tr -d ' ')

# THE STAMP COLLISION STAYS VISIBLE, and stays ungated. Two logs in one second is lawful and worth
# seeing, since it is the shape a growing fleet meets more often every ship it adds.
shared=$(sort "$work/stamps.txt" | uniq -d | wc -l | tr -d ' ')

# A shelf reads NEWEST FIRST, and a merge that reports no conflict has still made a decision. Two
# rows landing minutes apart auto-merge cleanly -- no marker, nothing to resolve -- and seat the
# older above the newer, so the page descends everywhere except across the seam the merge just
# made (REDS %440). Measured on the 20260905 shelf: 53 rows, two rises, three firings in one
# evening on one file, and every existing reading here green through all three.
#
# DOCUMENT ORDER IS THE READING, so the stamps are compared in the order the page carries them
# rather than sorted first. A stamp is one integer once its dot is removed -- `20260905.231916`
# reads 20260905231916 -- and fourteen digits sit far inside a double's exact range, so the
# comparison is the one-clock order itself rather than a string sort whose answer would depend on
# whether awk decided the field looked numeric.
#
# NO NEW EXEMPTION WAS NEEDED for a closed shelf. A closed shelf never enters $PINS, so it already
# stands outside every reading on this page, and the order gate inherits that by standing where its
# three siblings stand. That is what a part standing free buys: the law was already expressed in
# WHICH pages are read, so the new reading needed no copy of it.
: > "$work/misordered.txt"
awk -F'\t' '
  $1 != page { page = $1; prev = 0 }
  {
    n = $2; gsub(/\./, "", n); n = n + 0
    # An equal pair is the DUPLICATE reading above, never this one, so a tie is read past here and
    # counted once rather than reported twice by two readings for one fault.
    if (prev != 0 && n > prev) { printf "%s\t%s\t%s\n", $1, prevs, $2 }
    prev = n; prevs = $2
  }
' "$work/stamps.txt" > "$work/misordered.txt"
misordered=$(wc -l < "$work/misordered.txt" | tr -d ' ')

if [ "$verb" = list ]; then
  cat "$work/over.txt"
  exit 0
fi

head -5 "$work/over.txt" | while IFS="$(printf '\t')" read -r _ n p t; do
  printf 'over: %s bytes in %s -- %s\n' "$n" "$p" "$t"
done
head -5 "$work/unresolved.txt" | while IFS="$(printf '\t')" read -r p t; do
  printf 'unresolved: %s -> %s\n' "$p" "$t"
done
head -5 "$work/dupes.txt" | while IFS="$(printf '\t')" read -r p s; do
  printf 'duplicate: %s names %s twice\n' "$p" "$s"
done
# The seam is named from both sides, so a hand knows which pair to swap rather than which page to
# re-read.
head -5 "$work/misordered.txt" | while IFS="$(printf '\t')" read -r p a b; do
  printf 'misordered: %s -- %s stands above %s\n' "$p" "$a" "$b"
done

echo "pins=$(echo $PINS | wc -w | tr -d ' ')"
echo "open_shelf=${open_shelf:-none}"
echo "rows=$total"
echo "rows_over=$over"
echo "rows_unresolved=$unresolved"
echo "rows_duplicate=$dupes"
echo "rows_stamp_shared=$shared"
echo "rows_misordered=$misordered"
echo "row_max=$ROW_MAX"
echo "longest_row=$longest"

# One verdict per pass, so a caller reads a single answer. The counts above stay whole, so a
# reader still sees every reading rather than only the one that fired first.
if [ "$over" -ne 0 ]; then
  echo "verdict=rows_over_bound"; exit 1
elif [ "$unresolved" -ne 0 ]; then
  echo "verdict=rows_unresolved"; exit 1
elif [ "$dupes" -ne 0 ]; then
  # THE SAME NUMBER-AND-A-WAY-TO-ACT, owed here too. This branch fires BEFORE the misordered one
  # below, so a shelf carrying both faults -- which is what 20260907's firing was -- printed this
  # verdict and no advice at all, while the remedy sat one branch down. The repair tool sorts a
  # duplicate stamp into its two classes: byte-identical rows it lifts, since either copy leaves
  # the same page, and divergent rows it refuses while printing both, since which text is true is
  # a judgment about the record. Either way it tells a reader which of the two they have.
  echo "advice=sh tools/fixtures/i/index_shelf_repair.sh"
  echo "verdict=rows_duplicate"; exit 1
elif [ "$misordered" -ne 0 ]; then
  # A NUMBER AND A WAY TO ACT. This reading has fired twelve times across five laps and every
  # firing was repaired by the same hand-swap, because the refusal named the fault and no remedy
  # (the `%528` lesson, one room over). The repair is a permutation of the rows and proves that
  # about its own output before it writes, so it is safe to name here.
  echo "advice=sh tools/fixtures/i/index_shelf_repair.sh"
  echo "verdict=rows_misordered"; exit 1
fi
echo "verdict=ok"
