#!/bin/sh
# tools/fixtures/l/line_length_census_scan.sh -- how many lines of the TAME family run past a
# hundred columns, and what kind of line each one is.
#
#   sh tools/fixtures/l/line_length_census_scan.sh [--list] [--max N]
#
# WHAT THIS READS, AND WHY IT EXISTS. `context/TAME_GUIDANCE.md`'s lint table stood under the
# heading **Enforced now** until `20260912` and carries the row *Line length <= 100 columns*. REDS %714 read that
# table one row at a time and found this row held by nothing at all: no tracked tool compares a
# line length against a hundred outside a study of upstream code. The remainder it booked was a
# measurement and a decision -- does the row earn a guard, or a retirement? This is the
# measurement, and it is kept as an instrument rather than a number in a page, because the
# population grows with every lap and a figure typed into prose is stale by the next one.
#
# WHAT IT COUNTS. Tracked sources of the six extensions TAME governs -- `.rye`, `.rish`, `.brix`,
# `.bron`, `.glow`, `.kyri` -- minus four rooms, each left out for its own reason:
#
#   vendor/ gratitude/   third-party text, held unmodified; their line lengths are their authors'.
#   seed/                the public projection, whose bytes are a copy of what is measured here.
#   session-logs/        testimony. A dated log keeps every byte it wrote, so counting its lines
#                        would put a number no lap may lower inside a reading meant to move.
#   */fixtures/*         a plant, read byte for byte by the guard it feeds. A fixture may carry a
#                        long line ON PURPOSE, and this scan's own control plants exactly that.
#
# THE THIRD CLASS, AND IT IS WHERE THE ARGUMENT LANDS. A Rishi line opening `say ` or `assert `
# carries a SENTENCE -- the claim a witness prints, or the refusal it names -- so its width is
# prose wearing code's syntax. Counted apart as `over_claim`. Measured `20260911`: 18,402 of the
# 23,151 long non-comment Rishi lines are one of those two forms, which together with the own-line
# comments puts 72 percent of this whole population outside what a column rule was written for.
#
# THE SPLIT, AND WHY IT IS THE WHOLE FINDING. A long line is counted as a **comment** when its
# first non-blank characters open one in that language -- `//` in Rye, `#` in Rishi, Bron and
# Kyri, `::` in Glow -- and as **code** otherwise. Measured `20260911`: of 101,957 lines past a
# hundred columns, **54,917 are own-line comments**. The rule was written for code a reader has to
# follow across a terminal; more than half of what it catches here is prose, governed already by
# the register laws and by nothing about columns.
#
# WHY NO CEILING HOLDS THE TOTAL. A ratchet over this population would red on ordinary work, which
# is the one thing this tree has repeatedly said a guard must never do. Three reasons, each
# measured rather than argued: `caravan/` alone carries 4,864 long lines, 956 of them a chained
# `.inner` field access whose length is the ladder's nesting rather than a writer's choice;
# `tools/` carries 37,163, most of them a `run [...]` invocation array that no wrapping shortens;
# and `crypto/` carries 7,329, largely published test vectors that must stand exactly as their
# source publishes them. A number that rises whenever a rung is added is a number a gate cannot
# hold, so this scan REPORTS its census and gates one thing only -- its own reach.
#
# THE ONE GATE: REACH. A walk that quietly stops early reports a smaller population and reads as a
# cleaner tree, and this tree has booked that exact fault three times -- a shell glob that stopped
# at `/` after a room folded (the doorway roster), `index_row_bound` reading the pin alone over 87
# unheld rows (%381), and `log_has_a_row` answering `flat_logs=0` for nine days. So `files_read`
# is compared against a floor, and a census that lost its corpus refuses rather than celebrating.
#
# Purely local -- no key, no network, no funds, no device. It reads tracked sources, or a pen.
set -eu
LC_ALL=C
export LC_ALL

MAXCOL=${LINE_LENGTH_MAX:-100}
# EVERY COLLECTION NAMES A MAXIMUM (TAME). The reader hands its whole file list to one `awk`, so
# the list is bounded rather than trusted to fit an argument vector. 20,000 is four times the
# 4,914 standing on `20260911`, and a corpus past it refuses by name instead of being truncated by
# the kernel.
MAX_FILES=${LINE_LENGTH_MAX_FILES:-20000}
FLOOR=${LINE_LENGTH_REACH_FLOOR:-3500}
CORPUS=${LINE_LENGTH_CORPUS:-}
list=no

while [ $# -gt 0 ]; do
  case "$1" in
    --list) list=yes ;;
    --max) shift; MAXCOL=$1 ;;
    *) echo "$0: unknown argument $1" >&2; exit 2 ;;
  esac
  shift
done

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

# THE CORPUS. A pen is walked with `find` so the control needs no git repository; the tree is read
# with `git ls-files`, whose pathspec `*` crosses `/` where a shell glob stops at it.
if [ -n "$CORPUS" ]; then
  ( cd "$CORPUS" && find . -type f \
      \( -name '*.rye' -o -name '*.rish' -o -name '*.brix' \
         -o -name '*.bron' -o -name '*.glow' -o -name '*.kyri' \) \
      | sed 's|^\./||' ) > "$pen/all.txt"
  base=$CORPUS
else
  git ls-files '*.rye' '*.rish' '*.brix' '*.bron' '*.glow' '*.kyri' > "$pen/all.txt"
  base=.
fi

: > "$pen/files.txt"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    vendor/*|gratitude/*|seed/*|session-logs/*) continue ;;
    */fixtures/*|fixtures/*) continue ;;
  esac
  [ -f "$base/$f" ] || continue
  # A PATH CARRYING WHITESPACE REFUSES OUT LOUD. The list is expanded unquoted into one `awk`, and
  # a space would split one path into two unreadable ones -- the same fault the ASCII-first
  # widening found in a `for f in docs/*.md` loop, where a spaced page fell out of a wall in
  # silence. This tree writes no such name today; a refusal is what keeps that true.
  case "$f" in
    *[!-a-zA-Z0-9_./]*) echo "path_space=$f" >&2; echo "verdict=path_unsafe"; exit 1 ;;
  esac
  printf '%s\n' "$base/$f" >> "$pen/files.txt"
done < "$pen/all.txt"

files_listed=$(wc -l < "$pen/files.txt" | tr -d ' ')

if [ "$files_listed" -gt "$MAX_FILES" ]; then
  echo "files_listed=$files_listed"
  echo "max_files=$MAX_FILES"
  echo "verdict=corpus_over_bound"
  exit 1
fi

if [ "$files_listed" -eq 0 ]; then
  echo "files_listed=0"
  echo "files_read=0"
  echo "verdict=reach_empty"
  exit 1
fi

awk -v maxcol="$MAXCOL" '
  FNR == 1 { files_read++; ext = FILENAME; sub(/.*\./, "", ext) }
  {
    lines++
    if (length($0) > maxcol) {
      s = $0; sub(/^[ \t]+/, "", s)
      comment = 0
      if (ext == "rye"  && s ~ /^\/\//) comment = 1
      if (ext == "glow" && s ~ /^::/)   comment = 1
      if ((ext == "rish" || ext == "bron" || ext == "kyri") && s ~ /^#/) comment = 1
      claim = 0
      if (ext == "rish" && comment == 0 && (s ~ /^say / || s ~ /^assert /)) claim = 1
      over++
      if (comment) over_comment++
      else if (claim) over_claim++
      else over_code++
      per[FILENAME]++
    }
  }
  END {
    printf "files_read=%d\n", files_read + 0
    printf "lines=%d\n",      lines + 0
    printf "over=%d\n",       over + 0
    printf "over_comment=%d\n", over_comment + 0
    printf "over_claim=%d\n",   over_claim + 0
    printf "over_code=%d\n",    over_code + 0
    n = 0
    for (f in per) n++
    printf "files_over=%d\n", n
    for (f in per) printf "PERFILE\t%d\t%s\n", per[f], f
  }
' $(cat "$pen/files.txt") > "$pen/out.txt"

# A SECOND READING IN THE HOST'S OWN LOCALE. Everything above runs under `LC_ALL=C`, where awk's
# `length()` counts BYTES, so a line is measured the same way on every host -- which is what a
# meter wants. A column, though, is a display cell, and a multi-byte character fills one. The two
# readings differ by exactly the non-ASCII residue the ASCII-first law already meters: 181 lines of
# 102,138 on `20260911`. Both are printed, so neither reading has to stand in for the other.
display_locale=${LINE_LENGTH_DISPLAY_LOCALE:-en_US.UTF-8}
over_display=$(LC_ALL=$display_locale \
  awk -v maxcol="$MAXCOL" 'length($0) > maxcol { n++ } END { print n + 0 }' \
  $(cat "$pen/files.txt"))

# BOTH GREPS CARRY `|| true`. Under `set -eu` a grep that matches nothing ends the walk, and a
# corpus with no long line at all is exactly the tree this rule hopes for -- so the happy case is
# the one an unguarded grep would kill.
grep -v '^PERFILE' "$pen/out.txt" > "$pen/head.txt" || true
grep '^PERFILE' "$pen/out.txt" | cut -f2,3 | sort -rn > "$pen/perfile.txt" || true

files_read=$(sed -n 's/^files_read=//p' "$pen/head.txt")

verdict=ok
if [ "$files_read" -ne "$files_listed" ]; then
  verdict=walk_short
elif [ -z "$CORPUS" ] && [ "$files_read" -lt "$FLOOR" ]; then
  verdict=reach_short
fi

echo "files_listed=$files_listed"
cat "$pen/head.txt"
echo "over_display=$over_display"
echo "max_files=$MAX_FILES"
echo "reach_floor=$FLOOR"
echo "maxcol=$MAXCOL"
echo "verdict=$verdict"

if [ "$list" = yes ]; then
  echo "top_files:"
  head -20 "$pen/perfile.txt" | while IFS="$(printf '\t')" read -r n f; do
    [ -n "$f" ] && echo "  over=$n $f"
  done
fi

[ "$verdict" = ok ] || exit 1
exit 0
