#!/bin/sh
# tools/fixtures/r/reds_fold.sh -- move closed REDS rows onto a shelf, links re-anchored.
#
# WHAT THIS IS FOR. `construction/REDS.md` folds when it nears the byte bound its own header
# declares: the elder rows move onto a shelf under `construction/archive/` and the pin keeps what is
# still open. Doing that by hand is four steps, and the fourth -- re-anchoring each moved row's
# relative links one directory deeper -- is the one a hand forgets. It was forgotten twice, at REDS
# %247 and again at REDS %270, and the second row said the quiet part: a fix that ends in "someone
# remembers" has forecast its own next firing. A lantern that fires twice becomes a loom. This is
# the loom.
#
#   sh tools/fixtures/r/reds_fold.sh construction/archive/REDS-<sprig>-rows-<a>-<b>.md 266 267 268
#
# WHAT IT DOES, in order: reads the named rows out of the pin, runs each through
# `reds_fold_reanchor.sh`, appends them to the shelf in ascending order, and removes them from the
# pin. The pin and the shelf are rewritten through their original inodes (`cat tmp > file`), so the
# mode the repository tracks survives -- the exec-bit law, `.claude/rules/exec-bit.md`.
#
# WHAT IT REFUSES, each by name and each because a fold that does this is wrong rather than merely
# untidy:
#
#   not_at_root      -- `construction/REDS.md` is missing, so this is not the tree's root.
#   shelf_unnamed    -- the shelf basename carries no `rows-`. The recital's own contract: the
#                       monotone scan discovers shelves by the glob `REDS-*rows-*.md`, so a shelf
#                       named `...row-249.md` is never read and the spine reports a gap where the
#                       row actually stands. Measured `20260826.070513`, when exactly that happened.
#   shelf_absent     -- the shelf file does not exist. A shelf's header is prose a person writes --
#                       which rows, on what stamp, and what they taught together -- and inventing it
#                       here would be this tool guessing at meaning. Write the head, then fold.
#   row_absent       -- a named row is not in the pin. Either it is already folded or the number is
#                       a typo, and both want a human's eye rather than a silent skip.
#   row_open         -- a named row still reads OPEN. The pin keeps what is open; folding one would
#                       hide live work on a shelf nobody reads for live work. Since door B
#                       (20260829, Keaton's word; active-designing/20260829-031804): the row's
#                       LAST bold status marker decides -- **BOOKED** and **CLOSED** fold, **OPEN**
#                       refuses, and a markerless row keeps the elder whole-word test. The one OPEN
#                       flag had carried two meanings, live defect and booked remainder, and the
#                       pin deadlocked on the second (%338).
#   too_many_rows    -- more than the bound below. Every collection names a maximum (TAME).
#
# WHAT IT LEAVES TO A HAND, on purpose: the shelf's header prose and the row in
# `construction/archive/REDS-fold-recital.md` that records which rows moved, on what stamp, onto
# which shelf. Both are authorial. This tool moves bytes and fixes links; it does not write meaning.
#
# Proven by tools/fixtures/r/reds_fold_control.sh over real files in a throwaway pen, refusals and
# welcomes both, and gated by tools/r/reds_fold_witness.rish.
set -eu

# A fold moves a handful of rows, not a ledger. Twelve is above every fold this tree has taken --
# the largest was seven (%242, %245-%248, %251, %254 on `20260826.044827`) -- and far below a
# number that would mean somebody meant to move the whole page.
MAX_ROWS=12

PIN=construction/REDS.md
REANCHOR=tools/fixtures/r/reds_fold_reanchor.sh

fail() { echo "reds-fold: refused -- $1" >&2; echo "verdict=$2" >&2; exit 2; }

[ -f "$PIN" ] || fail "run from the repository root; $PIN is not here" not_at_root
[ -f "$REANCHOR" ] || fail "the re-anchor filter $REANCHOR is missing" not_at_root
[ "$#" -ge 2 ] || fail "usage: sh $0 <shelf-path> <row-number> [<row-number>...]" not_at_root

shelf=$1
shift

case "$(basename "$shelf")" in
  *rows-*) ;;
  *) fail "the shelf basename must carry 'rows-': $shelf" shelf_unnamed ;;
esac

[ -f "$shelf" ] || fail "the shelf does not exist, and its header is a person's to write: $shelf" shelf_absent

[ "$#" -le "$MAX_ROWS" ] || fail "$# rows named, against a bound of $MAX_ROWS" too_many_rows

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# Ascending, deduplicated, so a shelf reads in spine order however the arguments arrived.
for n in "$@"; do
  case "$n" in
    ''|*[!0-9]*) fail "row numbers are digits: '$n'" row_absent ;;
  esac
  echo "$n"
done | sort -n -u > "$work/rows.txt"

: > "$work/moved.txt"
while IFS= read -r n; do
  row=$(awk -v n="$n" 'index($0,"**REDS %"n" ")==1{print; found=1; exit} END{exit !found}' "$PIN") \
    || fail "row %$n is not in $PIN" row_absent
  # Door B: the row's LAST bold status marker decides, read the way
  # reds_status_consistency_scan.sh reads it, so status has one definition everywhere. BOOKED
  # (defect repaired, remainder booked as a ratchet, a seat, or a lap) and CLOSED fold; OPEN
  # refuses; a markerless row keeps the elder whole-word test -- prose that merely says "opened"
  # is left alone, and awk's ERE is used rather than grep -E because the grep on this bench
  # mishandles an anchored alternation (the same dialect care as REDS %234).
  marker=$(printf '%s\n' "$row" | awk '{
    found = ""
    s = $0
    while (match(s, /\*\*(OPEN|CLOSED|BOOKED)[^*]*\*\*/)) {
      found = substr(s, RSTART + 2, 4)
      s = substr(s, RSTART + RLENGTH)
    }
    print found
  }')
  case "$marker" in
    BOOK|CLOS) ;;
    OPEN)
      fail "row %$n reads OPEN at its last marker; the pin keeps what is open" row_open
      ;;
    *)
      printf '%s\n' "$row" | awk '{ if ($0 ~ /(^|[^A-Za-z])OPEN([^A-Za-z]|$)/) exit 1 }' \
        || fail "row %$n still reads OPEN; the pin keeps what is open" row_open
      ;;
  esac
  printf '%s\n' "$row" >> "$work/moved.txt"
done < "$work/rows.txt"

# Re-anchor every moved row at once, then append each with the blank line the shelf's shape wants.
sh "$REANCHOR" < "$work/moved.txt" > "$work/anchored.txt"

cp "$shelf" "$work/shelf.new"
while IFS= read -r row; do
  printf '\n%s\n' "$row" >> "$work/shelf.new"
done < "$work/anchored.txt"

# Drop the moved rows and the blank line that follows each, so the pin keeps its shape.
awk -v rowfile="$work/rows.txt" '
  BEGIN { while ((getline r < rowfile) > 0) drop["**REDS %" r " "] = 1 }
  {
    for (k in drop) { if (index($0, k) == 1) { skipping = 1; next } }
    if (skipping && $0 == "") { skipping = 0; next }
    skipping = 0
    print
  }
' "$PIN" > "$work/pin.new"

# Through the original inode, so the tracked mode survives (exec-bit law).
cat "$work/shelf.new" > "$shelf"
cat "$work/pin.new" > "$PIN"

moved=$(grep -c '' "$work/rows.txt")
anchored=$(grep -c "](\.\./\.\./" "$work/anchored.txt" 2>/dev/null || true)
echo "shelf=$shelf"
echo "rows_moved=$moved"
echo "links_reanchored=$anchored"
echo "verdict=ok"
