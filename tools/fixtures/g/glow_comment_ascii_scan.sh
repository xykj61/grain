#!/bin/sh
# tools/fixtures/g/glow_comment_ascii_scan.sh -- non-ASCII characters in authored Glow COMMENTS.
#
# WHY. `.claude/rules/ascii-first.md` governs every new document, code comment, and commit message.
# `tools/as/ascii_comment_witness.rish` held that law for two comment marks: `//` for Rye, and `#`
# for Rishi and shell. Its own head said "ONE LAW, TWO COMMENT SYNTAXES", and this tree authors
# THREE languages. Glow spells a comment `::`, and its 451 tracked sources stood outside a law that
# governs them -- measured `20260907.141019`: 942 non-ASCII characters across 342 files, every one
# inside a `::` comment and not one in program content.
#
# KIN. The siblings are `tools/fixtures/r/rye_comment_ascii_scan.sh` and
# `tools/fixtures/s/shell_comment_ascii_scan.sh`. The pen that proves this one is
# `tools/fixtures/g/glow_comment_ascii_control.sh`.
#
# THE EIGHT FORMS FOUND, and all eight are now converted -- the table stands as the record of what
# the sweep of `20260907.161048` met. Seven were named outright by the rule's own substitution
# table. The eighth was left to a reader's judgment, which is why a script never guessed it, and a
# reader read all 21 of its lines: thirteen say `X-shape (identical to) X-mold`, a sentence with a
# subject, and took the word **is**; eight say `((identical to) @u32 lower)`, a parenthetical with
# none, and took **==**. Both spellings are the rule's own two options, so the register moved and
# not one word of meaning:
#
#   504  middle dot        `-` or `,`   named
#   321  em dash           `--`         named
#    42  ellipsis          `...`        named
#    34  rightwards arrow  `->`         named
#    21  identical to      -- a reader chooses `==` or the word `is`
#    16  left-right arrow  `<->`        named
#     3  en dash           `-`          named
#     1  right quote       `'`          named
#
# WHAT COUNTS. A COMMENT line is one whose first non-blank characters are `::`. That covers a desk's
# header block and an indented note beside a rune. It is also the exact shape the language itself
# uses: `glow/lower_multi.rye:82` and `glow/lower_assert.rye:122` skip a comment this way when they
# collect a desk's real lines, so this meter reads a comment where the language reads one.
#
# WHY THIS METER NEEDS NO ESCAPE HATCH, where both siblings do. Rye must hold back at a `\\`
# multiline string and shell at a heredoc body, because in both languages a literal spans lines and
# a later line of one can open with the comment mark. Glow has no multi-line literal at all:
# `glow/tokens.rye:239` refuses a newline inside a cord literal outright, with
# `if (c == '\n') return error.BadToken;`. So a line opening `::` sits outside every literal, and
# the guarantee is carried by the language rather than by a convention this scan would have to keep
# in step with. The control plants a cord beside a comment and proves the reading anyway, since a
# language rule left unmeasured is a memory.
#
# THE ONE BLIND SPOT, BOUNDED AND PRINTED. A trailing `::` after code on the same line goes unread,
# because telling it from a `::` inside a cord is parsing rather than scanning. So this meter
# UNDERCOUNTS on purpose, and it says by how much: `trailing_unread` counts every line carrying the
# mark away from the start. Measured `20260907.141019` across all 451 tracked sources, that reading
# is **zero**. Both siblings name the same blind spot in prose and neither prints it, so a reader
# there cannot tell an empty blind spot from a large one.
#
# USAGE
#   sh tools/fixtures/g/glow_comment_ascii_scan.sh          # count
#   sh tools/fixtures/g/glow_comment_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap converts comments; never raise it.
#   942  `20260907.141019`  across 342 files, the reading on the lap this meter was seated
#     0  `20260907.161048`  the sweep, 342 files rewritten, every changed line a `::` comment and
#                           no program content touched -- so this meter is a WALL for Glow rather
#                           than a ratchet, and the next non-ASCII character to enter a Glow comment
#                           reds on the lap it arrives. The control was repaired in the same commit:
#                           a pen planting three characters cannot ask a ceiling of zero whether it
#                           is under it, so the ceiling legs now run on a cleared pen.
CEILING=0

# THE UNIT IS A CHARACTER, COUNTED BY ITS UTF-8 LEAD BYTE IN THE C LOCALE -- the same reading both
# siblings take, and for the reason they learned the expensive way: "this awk reads UTF-8 text" was
# true only of GNU awk, and the BWK awk a Mac ships iterates bytes, so one em dash read 3 on one
# bench and 1 on another and one tree carried two readings (`20260828.160500`). Every non-ASCII
# character carries exactly one lead byte in `\300-\377`, so `LC_ALL=C` pins both awks to bytes and
# the lead-byte class turns bytes back into characters.
#
# THE BYTE RANGE IS SPELLED IN OCTAL. `\x00-\x7F` is a GNU awk extension that the BWK awk parses as
# literal characters, which makes a negated class match everything and reads a whole comment line as
# non-ASCII (REDS %278, and the sibling meters carry the scar).
#
# A SYMLINK IS SKIPPED. `git ls-files` lists a link AND its target as two paths, and following both
# counts one set of bytes twice -- the reading that made the Rye meter report a rise nobody had
# written (REDS %340). This tree tracks no symlinked `.glow` today, which is why the control plants
# one rather than waiting for it.
list=$(git ls-files "*.glow" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513. An empty answer from a refused
# read is byte-identical to an empty answer from a clean file, and the second is the one everyone
# hopes for. The awk sits in a function so its exit status can be read, and three answers are told
# apart: ABSENT is skipped and COUNTED, never fatal, because `git ls-files` reads the INDEX and a
# rename staged mid-lap lists a path the working tree no longer holds; REFUSED is fatal and NAMED;
# and a non-numeric answer is refused too, since `END { print n + 0 }` prints a number whenever the
# program runs at all.
count_file() {
  LC_ALL=C awk '
    {
      line = $0
      sub(/^[ \t]+/, "", line)
      if (substr(line, 1, 2) == "::") {
        s = $0
        for (i = 1; i <= length(s); i++) if (substr(s, i, 1) ~ /[\300-\377]/) n++
      }
    }
    END { print n + 0 }
  ' "$1"
}

# The deliberate undercount, measured rather than assumed: lines carrying `::` anywhere but at the
# start. Reported beside the count so a reader knows how much this meter cannot see.
trailing_file() {
  LC_ALL=C awk '
    /::/ { line = $0; sub(/^[ \t]+/, "", line); if (substr(line, 1, 2) != "::") n++ }
    END { print n + 0 }
  ' "$1"
}

total=0
files=0
absent=0
opened=0
trailing=0
report=""
for f in $list; do
  # A link and its target are two paths and one set of bytes; the target is read on its own row.
  [ -L "$f" ] && continue
  if [ ! -f "$f" ]; then
    absent=$((absent + 1))
    continue
  fi
  opened=$((opened + 1))
  n=$(count_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  case "$n" in
    '' | *[!0-9]*)
      echo "instrument=failed"
      echo "detail=awk_answered_no_number"
      echo "detail_path=$f"
      echo "verdict=misread"
      exit 1
      ;;
  esac
  t=$(trailing_file "$f") || t=0
  case "$t" in '' | *[!0-9]*) t=0 ;; esac
  trailing=$((trailing + t))
  if [ "$n" -gt 0 ]; then
    files=$((files + 1))
    total=$((total + n))
    report="$report$n $f
"
  fi
done

if [ "$mode" = "--list" ]; then
  printf '%s' "$report" | sort -rn | head -40
fi

if [ "$total" -le "$CEILING" ]; then under=yes; else under=no; fi
echo "instrument=ok"
echo "GLOW_COMMENT_ASCII files=$files chars=$total opened=$opened absent=$absent trailing_unread=$trailing ceiling=$CEILING under_ceiling=$under"
