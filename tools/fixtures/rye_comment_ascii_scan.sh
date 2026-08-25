#!/bin/sh
# tools/fixtures/rye_comment_ascii_scan.sh -- non-ASCII bytes in authored Rye COMMENTS.
#
# WHY. `.claude/rules/ascii-first.md` asks that prose be plain 7-bit ASCII, because a character no
# reader needs is a corruption waiting to compound -- the operator card once triple-encoded itself
# into 2,797 runs of mojibake (REDS %83). The rule governs documents, code comments, and commit
# messages, and it says to migrate on touch. Two files were migrated by hand on `20260825` and both
# times the violation had been written that same day, copied from the surrounding style rather than
# read. A lantern that fires twice becomes a loom, so here is the loom.
#
# WHAT COUNTS, and the line is drawn carefully because getting it wrong changes behavior.
# A COMMENT line is one whose first non-blank characters are `//` -- which covers `//`, `///`, and
# `//!`. Those are prose and the rule reaches them.
#
# WHAT DOES NOT COUNT:
#   * a `\\` line, which is Zig multiline STRING content and is program output, not prose;
#   * a string literal on a code line, for the same reason;
#   * a trailing comment after code on the same line.
# The first two are excluded because converting them would change what a program prints -- measured
# `20260825.011000`: 5,455 non-ASCII characters live in strings across 1,041 authored files, and one
# blanket `sed` over a single module rewrote nine of them, including a header written into a file.
# The third is excluded because finding it needs to know whether a `//` sits inside a string, which
# is parsing rather than scanning. **This therefore UNDERCOUNTS on purpose**: it reads 33,541 total
# non-ASCII in comment context by a parsing measure, and rather less by this one. An honest smaller
# number under a falling ceiling beats a larger one that might be wrong about a string.
#
# USAGE
#   sh tools/fixtures/rye_comment_ascii_scan.sh          # count
#   sh tools/fixtures/rye_comment_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap converts comments; never raise it.
# The arc, each figure measured rather than recalled:
#   32064  `20260825.011000`  across 1,497 files, the reading on the lap this meter was seated
#    4338  `20260825.011500`  after the named punctuation was converted in 1,303 files
# What remains is notation the rule's table does not name -- 1,305 typographic minus, 542 double
# vertical, 350 section, 341 multiplication, 289 less-or-equal, 291 superscripts, 195 Greek -- each
# carrying a meaning a reader should choose the ASCII form for, rather than a script guessing it.
CEILING=4338

list=$(git ls-files "*.rye" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

total=0
files=0
report=""
for f in $list; do
  n=$(awk '
    { line = $0
      sub(/^[ \t]+/, "", line)
      if (substr(line, 1, 2) != "//") next
      s = $0
      for (i = 1; i <= length(s); i++) if (substr(s, i, 1) ~ /[^\x00-\x7F]/) n++
    }
    END { print n + 0 }
  ' "$f" 2>/dev/null)
  [ -z "$n" ] && n=0
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
echo "RYE_COMMENT_ASCII files=$files chars=$total ceiling=$CEILING under_ceiling=$under"
