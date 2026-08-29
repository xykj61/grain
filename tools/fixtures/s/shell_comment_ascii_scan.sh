#!/bin/sh
# tools/fixtures/s/shell_comment_ascii_scan.sh -- non-ASCII bytes in authored Rishi and shell COMMENTS.
#
# WHY. `.claude/rules/ascii-first.md` governs every new document, code comment, and commit message,
# and the meter that held it read `*.rye` alone. Two of this tree's own languages stood outside a
# law they are governed by: 2,243 tracked `.rish` sources and 580 `.sh` sources, carrying 10,471
# non-ASCII characters in their comments when this scan was first run (`20260825.084500`). The
# sibling meter for Rye lives at `tools/fixtures/r/rye_comment_ascii_scan.sh`; one law, two comment
# syntaxes, so two scans that each read plainly rather than one wearing a flag.
#
# WHAT COUNTS. A COMMENT line is one whose first non-blank character is `#`. That covers a header
# block, an indented note beside a bound, and a shebang, and both languages spell it the same way.
#
# WHAT DOES NOT COUNT, and the line is drawn where a sweep would otherwise change behavior:
#   * a HEREDOC body -- `<<WORD`, `<<-WORD`, `<<'WORD'`, `<<"WORD"` through its delimiter line.
#     A heredoc is what a program feeds to another program, so a `#` line inside one is content
#     rather than prose. Measured `20260825.084500`: exactly 3 such characters stand tree-wide, in
#     `tools/fixtures/l/link_witness_scan.sh` (a Python program) and `tools/w/wov_tb_repl_lab.sh`.
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
#   sh tools/fixtures/s/shell_comment_ascii_scan.sh          # count
#   sh tools/fixtures/s/shell_comment_ascii_scan.sh --list   # name each file and its count, worst first
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
# THE UNIT IS A CHARACTER, COUNTED BY ITS UTF-8 LEAD BYTE IN THE C LOCALE. "This awk reads UTF-8
# text" was true only of GNU awk -- the BWK awk this bench ships iterates bytes, so one em dash
# read 3 here and 1 on the Linux benches, and one tree carried two readings (`20260828.160500`).
# Every non-ASCII character carries exactly one lead byte in `\300-\377`, so `LC_ALL=C` pins both
# awks to bytes and the lead-byte class turns bytes back into characters -- one em dash is one,
# under every awk, and the sibling Rye meter reads the same way.
#
# THE BYTE RANGE IS SPELLED IN OCTAL, not in hex. `\x00-\x7F` is a GNU awk extension; the BWK awk
# macOS ships parses it as literal characters, so the negated class matches EVERY character and the
# meter counts a whole comment line as non-ASCII. Measured on this bench `20260826.211500`: the
# sibling Rye meter read 16,131,707 against a ceiling of 4,338 by this fault, and this
# meter read the same way while its control stayed green, since a control that asks only whether a
# line was counted cannot see a meter that counts too much. `\001-\177` is the POSIX spelling of the same range and
# reads identically in both dialects -- the same move `tools/fixtures/l/living_card_ascii_scan.sh`
# already made when it dropped `grep -P` for a C-locale byte range (REDS %278).
CEILING=505

# A SYMLINK IS SKIPPED, and this is a census rather than a roster, so the reading is unambiguous:
# `git ls-files` lists a link AND its target as two paths, and following both counts the same bytes
# twice. On 20260829 two symlinks landed under `tools/rye/` pointing at `crypto/sha3.rye` and
# `crypto/keccak256.rye`, which have carried their 32 non-ASCII characters since 20260826 -- so this
# meter read 4,342 against a 4,333 ceiling and reported a rise that never happened. 4,342 minus the
# doubled 32 is 4,310, twenty-three UNDER. The idiom and its reason are the tree's own, from
# `tools/fixtures/c/caravan_wrap_class_scan.sh`: a symlink's laws belong to the room its target
# lives in. `tools/fixtures/c/caravan_ladder_roster_scan.sh` deliberately reads the other way, and
# both are right -- that meter asks which modules a room HAS, where a shared body reached by symlink
# is genuinely one of them; this one asks how many characters EXIST, and a byte counted twice is a
# byte miscounted. Booked at REDS %340.
list=$(git ls-files "*.rish" "*.sh" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

total=0
files=0
report=""
for f in $list; do
  # A link and its target are two paths and one set of bytes; the target is read on its own row.
  [ -L "$f" ] && continue
  n=$(LC_ALL=C awk '
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
        for (i = 1; i <= length(s); i++) if (substr(s, i, 1) ~ /[\300-\377]/) n++
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
