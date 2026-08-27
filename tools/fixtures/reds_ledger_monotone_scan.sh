#!/bin/sh
# tools/fixtures/reds_ledger_monotone_scan.sh -- REDS row numbers accrete, never rewrite.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Companion to reds_ledger_scan.sh (three fields - living-pin bound).
# This seam proves row indices are 1..N with no gaps and no duplicates --
# the mechanical half of "rows are never edited or removed."
#
# Fold-aware (20260811.143500): a closed-range fold moves a contiguous PREFIX of
# rows into an archive file to keep the living pin under bound, so the living
# ledger holds only a suffix. The 1..N spine therefore spans the living pin AND its
# fold archives together. Pass every file that holds rows (the archives then the
# living pin); this scan unions their row indices and proves the UNION is 1..N with
# no gaps or dupes -- so a fold never breaks the spine and a bundle still cannot
# silently rewrite a landed row number. Before this, the scan read one file and
# expected it to start at 1, so it went red the moment the first fold landed.
#
# TWO ROW SHAPES (20260820.232126, REDS %102). The ledger grew a second shape and
# this scan was never taught it. Elder rows are table lines opening on a digit cell;
# every row from %81 forward is prose -- a bold `**REDS %N ...**` opening followed by
# the three fields in italics. Reading only the table shape, this scan could see 73
# of the 101 rows that exist, and it answered `verdict=ok` over that partial spine
# because the witness above it happened to pass only the three archives whose rows
# were all table-shaped. A count that cannot see what it measures is a guess wearing
# a measurement's clothes -- REDS %97's own lesson, which repaired the sibling scan
# beside this one and left this one exactly as it was. Both shapes are unioned now,
# so the spine is proven over every row the ledger actually holds.

set -eu
# THE DEFAULT SPANS THE SHELVES (REDS %237). Called with no arguments this once read
# construction/REDS.md alone, which since the first fold holds a SUFFIX of the spine -- three
# rows on 20260825 against 232 -- so every bare caller got `verdict=not_monotone` from a ledger
# that was perfectly whole. Fourteen scans in tools/fixtures/ call it bare, and the comment
# above them has said `pass every file that holds rows` the whole time. A default that
# contradicts its own documentation is a trap rather than a convenience, so the default now
# does what the witness beside it does. A caller naming its own files still overrides, which is
# what the planted single-file pens in the witness rely on.
if [ "$#" -eq 0 ]; then
  set -- construction/REDS.md
  for shelf in construction/archive/REDS-*rows-*.md; do
    # An unmatched glob stays literal in POSIX sh, so a tree that has never folded is read
    # exactly as it was before -- the living pin alone, and honestly.
    [ -f "$shelf" ] && set -- "$shelf" "$@"
  done
fi
for f in "$@"; do
  [ -f "$f" ] || { echo "detail: absent ($f)"; echo "verdict=missing_ledger"; exit 2; }
done

# Union every "| N |" row index across all given files, sorted numerically.
# Both shapes: the elder table line opening on a digit cell, and the prose row opening
# on a bold `**REDS %N` or `**REDS #N` -- the living ledger writes the latter and wrote
# the former, so the spine spans both.
mentions=$(for f in "$@"; do
  sed -n 's/^| *\([0-9][0-9]*\) *|.*/\1/p' "$f"
  sed -n 's/^\*\*REDS [%#]\([0-9][0-9]*\).*/\1/p' "$f"
done | sort -n)

# The spine is the DISTINCT set of row numbers, because the ledger honestly names one
# row more than once: a full row is written when the red is found, and a closure note
# written later speaks ABOUT that row rather than opening a new one, keeping its number
# (REDS %97 drew exactly this distinction in the sibling scan). Counting mentions would
# read every closure note as a duplicate and refuse a ledger that is perfectly whole --
# a gate that reds on valid input, which REDS %100 named as its own kind of fault. Both
# counts are printed, so the gap between them stays visible rather than folded away.
n_mentions=$(printf '%s\n' "$mentions" | grep -c '[0-9]' || true)
sorted=$(printf '%s\n' "$mentions" | sort -n -u)

rows=0
expect=1
fail=0
for n in $sorted; do
  rows=$((rows + 1))
  if [ "$n" -ne "$expect" ]; then
    echo "detail: expected row $expect, found $n"
    fail=$((fail + 1))
  fi
  expect=$((n + 1))
done

# THE SPINE PROVES WHOLE, NOT DISTINCT (REDS %287). Everything above proves the row numbers
# run 1..N with no gaps or duplicate NUMBERS, which is what "rows are never edited or removed"
# needs -- and a spine can be perfectly whole while holding one incident twice under two
# numbers. That is what two piers allocating from their own trees produce: a red booked on one
# bench, shifted onto the other by a merge repair, then re-seated a second time when it arrived
# again from upstream. Measured 20260826: %249/%271, %250/%272 and %251/%273 are three
# incidents standing twice, so a spine reading 285 holds 282 distinct reds. REDS %230 named the
# blindness one layer back -- a guard cannot see a collision it has no second tree to compare
# against -- and after a merge there is no second tree, so the collision is inside this one
# wearing two names.
#
# THE READING. A headline is the row's own one-sentence identity, so one headline published
# under two DIFFERENT row numbers is the signal. Pairs are deduped by (number, headline) first,
# so a row and its own closure note stay one row -- the same welcome the mentions/rows split
# above already makes, because a gate that reds on valid input teaches the bench to route
# around it (REDS %100).
#
# A CEILING THAT ONLY FALLS, rather than a gate at zero. The three pairs standing today are on
# dated shelves and in the living pin, and resolving them edits testimony, which is Keaton's
# word under `debride`. So this holds the line where it stands and refuses the fourth.
duplicate_headlines_ceiling=3

pairs=$(for f in "$@"; do
  awk '
    /^\*\*REDS [%#][0-9]+/ {
      line = $0
      match(line, /^\*\*REDS [%#][0-9]+/)
      num = substr(line, RSTART, RLENGTH)
      sub(/^\*\*REDS [%#]/, "", num)
      rest = substr(line, RSTART + RLENGTH)
      p = index(rest, " -- ")
      if (p == 0) next
      head = substr(rest, p + 4)
      q = index(head, "**")
      if (q > 0) head = substr(head, 1, q - 1)
      printf "%s\t%s\n", num, head
    }
  ' "$f"
done | sort -u)

dup_file=$(mktemp)
printf '%s\n' "$pairs" | cut -f2- | sort | uniq -d > "$dup_file"
duplicate_headlines=$(wc -l < "$dup_file" | tr -d ' ')

echo "mentions=$n_mentions"
echo "rows=$rows"
echo "expect_next=$expect"
echo "gaps_or_dupes=$fail"
echo "duplicate_headlines=$duplicate_headlines"
echo "duplicate_headlines_ceiling=$duplicate_headlines_ceiling"
while IFS= read -r h; do
  [ -n "$h" ] || continue
  ns=$(printf '%s\n' "$pairs" | awk -F'\t' -v h="$h" '$2==h { printf "%%%s ", $1 }')
  echo "detail: one headline under ${ns}-- $(printf '%s' "$h" | cut -c1-72)"
done < "$dup_file"
rm -f "$dup_file"
if [ "$rows" -eq 0 ]; then echo "verdict=no_rows"; exit 1; fi
if [ "$fail" -eq 0 ] && [ "$duplicate_headlines" -le "$duplicate_headlines_ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
if [ "$fail" -ne 0 ]; then echo "verdict=not_monotone"; exit 1; fi
echo "verdict=duplicate_rows"
echo "refused: one headline stands under two row numbers past the ceiling -- read the lines above" >&2
exit 1
