#!/bin/sh
# tools/fixtures/i/index_shelf_repair.sh -- put a day shelf's rows back into the order it promises.
#
# WHY THIS EXISTS. REDS %440 has fired twelve times across five laps and every firing was repaired
# the same way: a hand read `rows_misordered=1`, found the two rows, and swapped them. The fault is
# not a hand's carelessness -- it is what a shared prepend does under a rebase. Eight ships each
# write a row at line 14 of one file, git merges two of them cleanly because they touch different
# lines after the merge, and the page that promises NEWEST FIRST comes out with the older row on
# top. Nobody wrote a wrong row; the order is an emergent property of the merge.
#
# `tools/fixtures/i/index_row_bound_scan.sh` already SEES this and names it exactly. What it gave a
# reader was a number and no way to act (the `%528` lesson, one room over). This is the way to act.
#
# WHAT IT DOES, and nothing else. It sorts the contiguous run of table rows below the shelf's
# delimiter into descending stamp order, and lifts the extra copies of any row that stands twice
# byte for byte. With nothing to lift that is a PERMUTATION -- the same lines, the same bytes, a
# different order. With copies lifted it is a permutation of the deduplicated set. Either way the
# tool proves the property about its own output before it writes, through one gate that keys both
# sides the same way. A repair that could add, drop, or alter a line would be a repair nobody
# should run unattended on testimony.
#
# WHAT IT REFUSES, each because the safe answer is a hand rather than a guess.
#   DIVERGENT duplicate stamps -- two DIFFERENT rows wearing one stamp. Choosing which text is
#     true is a judgment about the record, so it refuses, names each such stamp, and prints both
#     rows for the hand. Identical duplicates are a different case and are lifted; the reasoning,
#     and the measurement that separates the two, stands beside the classification below.
#   A row in the block that does not open with a stamp cell. The sort is lexical on the whole line
#     and that is exact only while the stamp is fixed-width and first; a row shaped otherwise would
#     sort by its title. Refused rather than sorted wrong.
#   A page with no delimiter row. Nothing below it is a table, so there is no block to sort.
#   A shelf the guard is not reading. The open shelf is taken from the scan's own `open_shelf=`
#     line rather than derived a second time here, so this tool can never repair a page the guard
#     is not measuring. A CLOSED shelf is immutable once its day closes and is never a target.
#
# WHY IT WRITES THROUGH THE ORIGINAL INODE. `cat "$tmp" > "$f"` keeps the mode the repository
# tracks, where `mv` would carry the temporary's (.claude/rules/exec-bit.md, where a rewrite pass
# dropped 100755 on thirty-nine files in one commit).
#
# WHY `sort -r` AND NOT A STAMP PARSER. A row opens `| \`YYYYMMDD.HHMMSS\` |`, fixed width, first
# cell. Byte-descending order on the whole line IS chronological-descending order for rows of that
# shape, so the tool needs no second reading of what a stamp is -- and the shape check above is
# what keeps that true. `LC_ALL=C` because a locale's collation is not byte order, which this tree
# has already paid for once in a `sort`/`comm` pair that reported ten phantoms.
#
# USAGE
#   sh tools/fixtures/i/index_shelf_repair.sh --check   # say what is wrong, change nothing
#   sh tools/fixtures/i/index_shelf_repair.sh           # sort the open shelf, in place
#
# Run from anywhere -- the root is found by upward walk.

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

check_only=no
while [ $# -gt 0 ]; do
  case "$1" in
    --check) check_only=yes; shift ;;
    *) echo "refused: unknown argument '$1' -- takes --check" >&2; exit 2 ;;
  esac
done

root=${INDEX_ROW_ROOT:-$_fd_root}
SHELF_ROOM=${INDEX_ROW_SHELF_ROOM:-session-logs/date}
cd "$root"

# THE SCAN IS THE AUTHORITY on which shelf is open and on what is wrong with it. Asking it rather
# than deriving the answer again is what keeps the repair aimed at the page the guard reads.
scan_out=$(INDEX_ROW_ROOT=. INDEX_ROW_SHELF_ROOM="$SHELF_ROOM" \
  sh "$_fd_root/tools/fixtures/i/index_row_bound_scan.sh" 2>&1 || true)
open_shelf=$(printf '%s\n' "$scan_out" | sed -n 's/^open_shelf=//p' | tail -1)
misordered=$(printf '%s\n' "$scan_out" | sed -n 's/^rows_misordered=//p' | tail -1)
duplicate=$(printf '%s\n' "$scan_out" | sed -n 's/^rows_duplicate=//p' | tail -1)
: "${misordered:=0}" "${duplicate:=0}"

if [ -z "$open_shelf" ]; then
  echo "shelf=none"
  echo "repair=none"
  echo "verdict=no_open_shelf"
  exit 0
fi
shelf="$SHELF_ROOM/README-index-$open_shelf.md"
echo "shelf=$shelf"
[ -f "$shelf" ] || { echo "verdict=shelf_missing" >&2; exit 1; }


# The delimiter row is where the table starts, and the block is the contiguous run of `|` lines
# after it. Everything above stays exactly where it stands; anything below the run stays too.
delim=$(awk '/^\|[- |:]*\|[ \t]*$/ { print NR; exit }' "$shelf")
if [ -z "$delim" ]; then
  echo "repair=none"
  echo "refused: no delimiter row -- nothing below it is a table" >&2
  echo "verdict=no_delimiter"
  exit 1
fi
last=$(awk -v d="$delim" 'NR > d { if (substr($0,1,1) == "|") last = NR; else exit } END { print last + 0 }' "$shelf")
if [ "$last" -le "$delim" ]; then
  echo "rows=0"
  echo "repair=none"
  echo "verdict=ok"
  exit 0
fi
rows=$((last - delim))
echo "rows=$rows"

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM
sed -n "$((delim + 1)),${last}p" "$shelf" > "$pen/block"

# EVERY ROW IN THE BLOCK OPENS WITH A STAMP CELL, or the lexical sort is sorting titles.
badshape=$(grep -cv '^| `[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\.[0-9][0-9][0-9][0-9][0-9][0-9]` |' "$pen/block" || true)
if [ "$badshape" -gt 0 ]; then
  echo "rows_unstamped=$badshape"
  echo "repair=none"
  echo "refused: $badshape row(s) do not open with a stamp cell -- a lexical sort would order them by title" >&2
  echo "verdict=unstamped_row"
  exit 1
fi

# DUPLICATES SPLIT INTO TWO CLASSES, and only one of them is a hand's judgment.
#
# This tool was built on 20260907 to end REDS %440's twelve hand repairs, and it refused the very
# next firing -- because it refused every duplicate on sight, before looking at one. Measured over
# the git history of this room's three most recent shelves: 20 revisions carried duplicate stamps,
# and of those stamps 38 were BYTE-IDENTICAL rows against 4 that were not.
#
# An IDENTICAL duplicate is one log's row standing twice, character for character -- what a rebase
# leaves when it re-applies a row already applied. Lifting either copy leaves the same page, so
# there is nothing to choose and the repair is provable rather than trusted. That is 90 pct of them.
#
# A DIVERGENT duplicate is two different rows wearing one stamp, and all four measured were one
# shape: a REDS number the derived spine renumbered under the row (`%505` against `%507` for a
# single log). Which text is true is a judgment about the ledger, so this still refuses -- and it
# now PRINTS both rows, because a hand asked to choose has to see what it is choosing between.
#
# THE KEY IS THE LOG A ROW NAMES, never the second it was written in (REDS %676, answered
# `20260910`). Two ships write inside one second roughly every eleven days at this fleet's rate,
# and the naming law resolves that with distinct sprigs -- so two such rows are two records, and
# keying on the stamp made a lawful day refuse here while the scan one file over refused it too.
# A row's first link is that key; a row carrying none names no log and keys on its own bytes.
# The reading the scan makes and the reading this tool makes must be one reading, or a hand is sent
# to a repair that disagrees with the guard that summoned it.
key_of() {                    # key_of <row>
  _k=$(printf '%s\n' "$1" | sed -n 's/.*](\([^)#]*\)[)#].*/\1/p' | head -1)
  [ -n "$_k" ] && printf '%s' "$_k" || printf 'row:%s' "$1"
}
dup_identical=0
dup_divergent=0
: > "$pen/keys"
while IFS= read -r _row; do printf '%s\n' "$(key_of "$_row")"; done < "$pen/block" > "$pen/keys"
for _k in $(LC_ALL=C sort "$pen/keys" | uniq -d); do
  _rows=$(paste -d'\t' "$pen/keys" "$pen/block" | awk -F'\t' -v k="$_k" '$1 == k { print $2 }')
  _n=$(printf '%s\n' "$_rows" | LC_ALL=C sort -u | wc -l | tr -d ' ')
  if [ "$_n" -gt 1 ]; then
    dup_divergent=$((dup_divergent + 1))
    echo "divergent: $_k carries $_n different rows"
    printf '%s\n' "$_rows" | LC_ALL=C sort -u | sed 's/^/  /'
  else
    dup_identical=$((dup_identical + 1))
  fi
done
echo "rows_duplicate_identical=$dup_identical"
echo "rows_duplicate_divergent=$dup_divergent"
if [ "$dup_divergent" -gt 0 ]; then
  echo "rows_duplicate=$((dup_identical + dup_divergent))"
  echo "repair=none"
  echo "refused: $dup_divergent log(s) carry different rows -- which text is true is a hand's" >&2
  echo "verdict=duplicate_stamps"
  exit 1
fi

echo "rows_misordered=$misordered"
if [ "$misordered" -eq 0 ] && [ "$dup_identical" -eq 0 ]; then
  echo "repair=none"
  echo "verdict=ok"
  exit 0
fi

if [ "$dup_identical" -gt 0 ] && [ "$misordered" -gt 0 ]; then act=dedupe_and_sort; did=deduped_and_sorted
elif [ "$dup_identical" -gt 0 ]; then act=dedupe; did=deduped
else act=sort; did=sorted
fi

if [ "$check_only" = yes ]; then
  echo "repair=would_$act"
  if [ "$dup_identical" -gt 0 ]; then echo "verdict=duplicate_identical"; else echo "verdict=misordered"; fi
  exit 1
fi

# The original block is kept for the postcondition, so the proof spans the dedupe as well as the
# sort rather than only the half that comes after it.
cp "$pen/block" "$pen/block.orig"
if [ "$dup_identical" -gt 0 ]; then
  LC_ALL=C sort -u "$pen/block.orig" > "$pen/block"
fi

LC_ALL=C sort -r "$pen/block" > "$pen/block.sorted"

# THE POSTCONDITION, checked before anything is written. With no duplicates to lift the repair is a
# permutation -- same lines, same count, different order -- and that is what is proven. When
# identical rows ARE lifted the repair is no longer a permutation, so the same one gate keys both
# sides by SET instead: nothing new may appear and nothing may be lost, and `sort -r` on an
# already-unique block cannot reintroduce a copy. One gate either way, because a second gate
# beside it could not be shown to be the thing doing the stopping.
if [ "$dup_identical" -gt 0 ]; then _keyer="sort -u"; else _keyer="sort"; fi
LC_ALL=C $_keyer "$pen/block.orig" > "$pen/before.keyed"
LC_ALL=C $_keyer "$pen/block.sorted" > "$pen/after.keyed"
if ! cmp -s "$pen/before.keyed" "$pen/after.keyed"; then
  echo "repair=none"
  echo "refused: the repair changed the line set -- writing nothing" >&2
  echo "verdict=not_a_permutation"
  exit 1
fi

{
  sed -n "1,${delim}p" "$shelf"
  cat "$pen/block.sorted"
  awk -v n="$last" 'NR > n' "$shelf"
} > "$pen/shelf.new"
cat "$pen/shelf.new" > "$shelf"

echo "repair=$did"
echo "verdict=repaired"
exit 0
