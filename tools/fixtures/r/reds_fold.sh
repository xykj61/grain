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
#   sh tools/fixtures/r/reds_fold.sh construction/archive/REDS-<sprig>-rows-<a>-<b>.md 266 267 268 \
#       --why "what the three rows taught together"
#
# WHAT IT DOES, in order: reads the clause and the stamp BEFORE a byte moves, reads the named rows
# out of the pin, runs each through `reds_fold_reanchor.sh`, appends them to the shelf in ascending
# order, removes them from the pin, and appends this fold's row to the recital. The pin and the
# shelf are rewritten through their original inodes (`cat tmp > file`) and the recital is appended
# to, so the mode the repository tracks survives all three -- the exec-bit law,
# `.claude/rules/exec-bit.md`. A refusal therefore leaves pin, shelf and recital exactly as they
# stood, which is what makes a refused fold safe to retype.
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
#   why_absent       -- no `--why` clause, or an empty one. The trail's meaning is a person's.
#   why_too_long     -- a clause past MAX_WHY bytes. Every collection names a maximum.
#   why_non_ascii    -- a byte outside printable ASCII, which also catches a newline: the recital
#                       row is ONE line, read whole by a person and by the capacity scan's grep,
#                       and ascii-first governs what this tree writes (`.claude/rules/ascii-first.md`).
#   stamp_shape      -- `--stamp` given something that is not `YYYYMMDD.HHMMSS`.
#   recital_absent   -- the recital file is missing, so the fold's trail has nowhere to land.
#   unknown_option   -- an option this tool does not know, refused rather than read as a row.
#
# WHAT IT WRITES BESIDE THE MOVE, from `20260830`: the recital row in
# `construction/archive/REDS-fold-recital.md` naming which rows moved, on what stamp, onto which
# shelf. Those three facts are the tool's own -- it sorted the rows, it read each row's status
# marker, and it was handed the shelf -- so a hand writing them out was copying what the tool
# already held. Twice on `20260830` a fold shipped without its line and
# `tools/fixtures/r/reds_pin_capacity_scan.sh` read `unrecorded_shelves` one over its ceiling, and
# a fix that ends in "someone remembers" has forecast its own next firing.
#
# WHAT IT STILL LEAVES TO A HAND, on purpose: the shelf's header prose, and the clause saying what
# the moved rows taught together. That clause arrives through `--why` and is required, for the same
# reason `shelf_absent` refuses -- meaning is a person's to write, and a tool that invents it writes
# a trail nobody can trust. Write the head and the clause, then fold.
#
# Proven by tools/fixtures/r/reds_fold_control.sh over real files in a throwaway pen, refusals and
# welcomes both, and gated by tools/r/reds_fold_witness.rish.
set -eu

# A fold moves a handful of rows, not a ledger. Twelve is above every fold this tree has taken --
# the largest was seven (%242, %245-%248, %251, %254 on `20260826.044827`) -- and far below a
# number that would mean somebody meant to move the whole page.
MAX_ROWS=12

# The clause a hand writes about what the moved rows taught. The longest clause standing on the
# recital measured 925 bytes on `20260830`, so 1,024 is the next power of two above every real case
# and refuses nothing anyone means to write.
MAX_WHY=1024

PIN=construction/REDS.md
RECITAL=construction/archive/REDS-fold-recital.md
REANCHOR=tools/fixtures/r/reds_fold_reanchor.sh

# One clock, cited rather than spelled -- the canonical zone of the naming law, overridable exactly
# the way tools/fixtures/o/one_clock_head_scan.sh overrides it. A pen pins the stamp with --stamp
# instead, so no control depends on the wall clock.
ZONE=${ONE_CLOCK_CANONICAL_ZONE:-America/New_York}

fail() { echo "reds-fold: refused -- $1" >&2; echo "verdict=$2" >&2; exit 2; }

[ -f "$PIN" ] || fail "run from the repository root; $PIN is not here" not_at_root
[ -f "$REANCHOR" ] || fail "the re-anchor filter $REANCHOR is missing" not_at_root
# The shelf and the rows arrive as words; the clause and the stamp arrive as named options, so a
# call site reads as what it means and the order of the two halves never matters.
shelf=
why=
stamp=
rows=
while [ "$#" -gt 0 ]; do
  case $1 in
    --why)
      [ "$#" -ge 2 ] || fail "--why takes the clause saying what the rows taught" why_absent
      why=$2
      shift 2
      ;;
    --stamp)
      [ "$#" -ge 2 ] || fail "--stamp takes a one-clock stamp, YYYYMMDD.HHMMSS" stamp_shape
      stamp=$2
      shift 2
      ;;
    --*)
      fail "unknown option: $1" unknown_option
      ;;
    *)
      if [ -z "$shelf" ]; then shelf=$1; else rows="$rows $1"; fi
      shift
      ;;
  esac
done

[ -n "$shelf" ] && [ -n "$rows" ] \
  || fail "usage: sh $0 <shelf-path> <row-number> [...] --why \"<clause>\" [--stamp YYYYMMDD.HHMMSS]" not_at_root

case "$(basename "$shelf")" in
  *rows-*) ;;
  *) fail "the shelf basename must carry 'rows-': $shelf" shelf_unnamed ;;
esac

[ -f "$shelf" ] || fail "the shelf does not exist, and its header is a person's to write: $shelf" shelf_absent

row_count=$(printf '%s\n' $rows | grep -c .)
[ "$row_count" -le "$MAX_ROWS" ] || fail "$row_count rows named, against a bound of $MAX_ROWS" too_many_rows

# The clause and the stamp are read BEFORE a byte moves, so a refusal here leaves the pin, the
# shelf and the recital exactly as they stood.
[ -n "$why" ] || fail "no --why clause; the recital row's meaning is a person's to write -- retype with --why \"what these rows taught together\"" why_absent

why_bytes=$(printf '%s' "$why" | wc -c | tr -d ' ')
[ "$why_bytes" -le "$MAX_WHY" ] || fail "the --why clause is $why_bytes bytes, against a bound of $MAX_WHY" why_too_long

if printf '%s' "$why" | LC_ALL=C grep -q '[^ -~]'; then
  fail "the --why clause carries a byte outside printable ASCII" why_non_ascii
fi

[ -f "$RECITAL" ] || fail "the recital $RECITAL is missing; the fold's trail has nowhere to land" recital_absent

if [ -n "$stamp" ]; then
  case $stamp in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]) ;;
    *) fail "--stamp reads '$stamp'; the one-clock shape is YYYYMMDD.HHMMSS" stamp_shape ;;
  esac
else
  stamp=$(TZ="$ZONE" date '+%Y%m%d.%H%M%S')
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# Ascending, deduplicated, so a shelf reads in spine order however the arguments arrived.
for n in $rows; do
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
  # The status word the trail line will carry, read rather than assumed. A row that passed the
  # elder whole-word test without a bold marker is recorded UNMARKED, and an unmarked row in the
  # set drops the status clause from the line entirely -- the tool says what it read and no more.
  case "$marker" in
    BOOK) echo BOOKED >> "$work/markers.txt" ;;
    CLOS) echo CLOSED >> "$work/markers.txt" ;;
    *)    echo UNMARKED >> "$work/markers.txt" ;;
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

# THE TRAIL LINE. Runs of three or more consecutive rows compress to a range, the way every row
# already standing on the recital reads (%347-%349); a run of two stays two items (%364 and %371).
phrase=$(awk '
  { n[NR] = $1 }
  END {
    c = 0; i = 1
    while (i <= NR) {
      j = i
      while (j < NR && n[j+1] == n[j] + 1) j++
      if (j - i >= 2) { c++; item[c] = "%" n[i] "-%" n[j] }
      else { for (k = i; k <= j; k++) { c++; item[c] = "%" n[k] } }
      i = j + 1
    }
    s = ""
    for (t = 1; t <= c; t++) {
      if (t == 1) s = item[t]
      else if (t == c) s = s " and " item[t]
      else s = s ", " item[t]
    }
    print s
  }
' "$work/rows.txt")

distinct=$(sort -u "$work/markers.txt" | tr '\n' ' ' | sed 's/ *$//')
case "$distinct" in
  CLOSED|BOOKED)
    case "$moved" in
      1) status=", **$distinct**" ;;
      2) status=", both **$distinct**" ;;
      *) status=", each **$distinct**" ;;
    esac
    ;;
  "BOOKED CLOSED") status=", **BOOKED** and **CLOSED**" ;;
  *) status="" ;;
esac

rowword=Rows
[ "$moved" -eq 1 ] && rowword=Row
# The clause closes the sentence, so the period is added unless the hand already wrote one.
case "$why" in
  *.|*!|*\?) stop="" ;;
  *) stop="." ;;
esac
base=$(basename "$shelf")
line="*$rowword $phrase folded to [\`$base\`]($base) on \`$stamp\`$status -- $why$stop*"

# Appended rather than rewritten, so the recital keeps its inode and the mode the repository
# tracks (the exec-bit law, `.claude/rules/exec-bit.md`).
printf '\n%s\n' "$line" >> "$RECITAL"

echo "shelf=$shelf"
echo "rows_moved=$moved"
echo "links_reanchored=$anchored"
echo "recital=$RECITAL"
echo "recital_line=written"
echo "stamp=$stamp"
echo "trail: $line"
echo "verdict=ok"
