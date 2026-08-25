#!/bin/sh
# tools/fixtures/shell_comment_ascii_scan.sh -- non-ASCII bytes in authored Rishi and shell COMMENTS.
#
# WHY. `.claude/rules/ascii-first.md` governs every new document, code comment, and commit message,
# and the meter that held it read `*.rye` alone. Two of this tree's own languages stood outside a
# law they are governed by: 2,243 tracked `.rish` sources and 580 `.sh` sources, carrying 10,471
# non-ASCII characters in their comments when this scan was first run (`20260825.084500`). The
# sibling meter for Rye lives at `tools/fixtures/rye_comment_ascii_scan.sh`; one law, two comment
# syntaxes, so two scans that each read plainly rather than one wearing a flag.
#
# WHAT COUNTS. A COMMENT line is one whose first non-blank character is `#`. That covers a header
# block, an indented note beside a bound, and a shebang, and both languages spell it the same way.
#
# WHAT DOES NOT COUNT, and the line is drawn where a sweep would otherwise change behavior:
#   * a HEREDOC body -- `<<WORD`, `<<-WORD`, `<<'WORD'`, `<<"WORD"` through its delimiter line.
#     A heredoc is what a program feeds to another program, so a `#` line inside one is content
#     rather than prose. Measured `20260825.084500`: exactly 3 such characters stand tree-wide, in
#     `tools/fixtures/link_witness_scan.sh` (a Python program) and `tools/w/wov_tb_repl_lab.sh`.
#     The count is small and the guarantee is the point -- the same distinction the Rye meter draws
#     at a `\\` multiline string, for the same reason.
#   * a trailing comment after code on the same line, which needs to know whether the `#` sits
#     inside a string. That is parsing rather than scanning, so **this UNDERCOUNTS on purpose**.
# A heredoc opener is read from non-comment lines only, so a `<<` quoted inside a header block
# cannot swallow the rest of a file. Arithmetic shift (`1 << 3`) and a here-string (`<<<`) both
# fail the opener pattern, which requires an identifier to follow. `<<-WORD` may close on an
# indented delimiter and plain `<<WORD` may not, which is the shell's own rule and is kept because
# closing a heredoc early would read program content as prose.
#
# USAGE
#   sh tools/fixtures/shell_comment_ascii_scan.sh          # count
#   sh tools/fixtures/shell_comment_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap converts comments; never raise it.
# The arc, each figure measured rather than recalled:
#   10468  `20260825.084500`  across 2,166 files, the reading on the lap this meter was seated
#     505  `20260825.084500`  across 153 files, after the named punctuation was converted
# What remains is notation the rule's table does not name -- 169 typographic minus, 73 double
# vertical, 71 section, 37 less-or-greater-or-equal, 26 box drawing, 22 multiplication, 52
# superscripts and subscripts, 15 Greek -- each carrying a meaning a reader should choose the ASCII
# form for, rather than a script guessing it. The six that WERE converted are the six the rule's own
# substitution table names and spells: em dash, en dash, middle dot, two arrows, ellipsis.
#
# THE UNIT IS A CHARACTER, not a byte. This awk reads UTF-8 text, so one em dash counts once rather
# than three times, and the sibling Rye meter reads the same way -- the two numbers are comparable.
CEILING=505

list=$(git ls-files "*.rish" "*.sh" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

total=0
files=0
report=""
for f in $list; do
  n=$(awk '
    {
      if (inhere) {
        # `<<-WORD` strips leading tabs, so its delimiter may be indented; plain `<<WORD` requires
        # column zero. Closing a heredoc early would read program content as prose, so the two
        # forms are told apart rather than both allowed to indent.
        if (dash) { if ($0 ~ ("^[ \t]*" delim "[ \t]*$")) inhere = 0 }
        else      { if ($0 ~ ("^" delim "[ \t]*$"))        inhere = 0 }
        next
      }
      line = $0
      sub(/^[ \t]+/, "", line)
      if (substr(line, 1, 1) == "#") {
        s = $0
        for (i = 1; i <= length(s); i++) if (substr(s, i, 1) ~ /[^\x00-\x7F]/) n++
        next
      }
      # A here-string `<<<"x"` contains `<<"x"` starting one character in, so the opener is
      # rejected when another `<` sits immediately before it. The control plants exactly that.
      if (match($0, /<<-?[ \t]*['"'"'"]?[A-Za-z_][A-Za-z0-9_]*['"'"'"]?/) &&
          (RSTART == 1 || substr($0, RSTART - 1, 1) != "<")) {
        d = substr($0, RSTART, RLENGTH)
        dash = (substr(d, 3, 1) == "-")
        sub(/^<<-?[ \t]*/, "", d)
        gsub(/['"'"'"]/, "", d)
        delim = d
        inhere = 1
      }
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
echo "SHELL_COMMENT_ASCII files=$files chars=$total ceiling=$CEILING under_ceiling=$under"
