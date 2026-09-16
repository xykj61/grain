#!/bin/sh
# tools/fixtures/s/shell_emit_ascii_scan.sh -- non-ASCII in what a POSIX shell script EMITS
# through `echo` or `printf`, rather than comments, or feeds onward inside a heredoc.
#
# WHY A SIXTH METER. The ASCII-first law is held by five readings, and every one of them is named
# in `.claude/rules/ascii-first.md`: documents, code comments, what a Rishi program SAYS, what a
# Rye program says, and what a Rye or a shell program ASSEMBLES and hands onward. The shell half of
# that last family closed on `20260912.023000` and named its own remainder in its header -- *a
# `printf` argument assembling one line stays unread, because finding it needs to know whether a
# quote sits inside another quote, which is parsing rather than scanning.*
#
# THE FAMILY NAMED `printf` AND THE POPULATION IS `echo`. Measured `20260916.183114` over the same
# 3,682 tracked shell sources: the non-ASCII standing outside heredoc bodies and outside `#`
# comments is 11,030 characters. 10,416 of those sit in `.rish`, where
# `tools/fixtures/r/rish_spoken_ascii_scan.sh` already counts them as speech -- a `say` line and an
# `assert ... else` message. The remaining 614 sit in `.sh`, and NO meter in this tree reads one of
# them: `echo` 360, `printf` 113, the rest in command positions that emit nothing. So the named
# half of the gap was the smaller half by three to one, which is this lane's own lesson from
# `20260915.223327` arriving a second time -- a meter prices a gap from the files it can already
# see.
#
# THE STRUCTURAL REASON, and it is why no sharper reading of the existing meters would have found
# it. A POSIX `.sh` file has no `say` verb; `say` is Rishi's. The spoken meter therefore opens
# `.rish` alone, so the whole `.sh` emit surface stands outside every reading in the family by
# construction rather than by oversight. Every one of the 40 worst files this meter reports is
# `.sh`, and not one `.rish` file appears -- the split is measured here, never assumed.
#
# WHAT COUNTS -- the OPERAND REGION of an `echo` or a `printf`: the text after the command word, up
# to an unquoted redirect or the end of that command. Quote state is walked character by character,
# so a `#` inside a string does not end the line, an escaped `\"` inside a double quote does not
# end the string, and a `>` inside a quoted argument is prose rather than a redirect. A command
# begins after an unquoted `;`, `|`, `&`, `(` or `)`, so an emit after a pipe and an emit inside
# `$( )` are both read. A leading assignment, an `exec`, and the keywords `then`, `else`, `elif`,
# `do`, `time`, `!` and `{` are stepped past, bounded at six steps: `then echo ...` runs echo, and
# leaving that step out loses 21 of the 509 characters below.
#
# THE TWO READINGS, and the line's own redirect decides which. `spoken` is an emit with no
# redirect: it reaches a person on their terminal and in `session-output/`, so converting it
# changes register, which is exactly what the ASCII-first law governs. `written` is an emit
# redirected to a path: it becomes a file somebody or something else reads, so converting it is the
# same act the shell written meter performs one room over, under the same care. Both are counted
# and both ratchet; they are printed apart because the second is the smaller and the more careful.
#
# WHAT DOES NOT COUNT, each boundary drawn where counting would charge one character to two
# ceilings:
#   * a `#` COMMENT -- `tools/fixtures/s/shell_comment_ascii_scan.sh`'s room.
#   * a HEREDOC BODY -- `tools/fixtures/s/shell_written_ascii_scan.sh`'s room, skipped by that
#     meter's own opener rule so the two agree about where a body begins and ends.
#   * a `say` or `assert ... else` line -- `tools/fixtures/r/rish_spoken_ascii_scan.sh`'s room.
#     Neither is an emit verb, so no exclusion is needed and none is written.
#   * a REDIRECT TARGET. A filename carrying a character is a fact about a path rather than prose.
#
# WHY THE TAIL STAYS A READER'S JUDGMENT. `emit_named` counts the eight forms `.claude/rules/
# ascii-first.md` spells outright, where the ASCII answer is the table's and no choosing is left.
# The remainder needs a person, and one population inside it must NOT be swept at all:
# `tools/fixtures/p/prin_matrix.sh` draws a terminal frame out of box-drawing characters, which is
# the rule's own named exception -- non-ASCII where it is the point of the work. A converter that
# read `emit` rather than `emit_named` would take that frame apart.
#
# WHAT IT CANNOT SEE, said plainly rather than implied away. A line continued with a trailing `\`
# is read as two lines, so an operand split across them is counted on the part that carries it and
# its command word is lost on the second. A `$(...)` nested inside a quoted argument reads as
# quoted text. This meter UNDERCOUNTS on purpose, the same way all five siblings do.
#
# THE UNIT IS A CHARACTER, counted by its UTF-8 lead byte in the C locale, the byte range spelled
# in OCTAL -- both conventions inherited from the sibling meters, and both bought with a red there.
#
# USAGE
#   sh tools/fixtures/s/shell_emit_ascii_scan.sh          # count
#   sh tools/fixtures/s/shell_emit_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode=${1:-}

# A symlink is skipped for the sibling's reason: `git ls-files` lists a link AND its target as two
# paths, and following both counts one set of bytes twice (REDS %340).
list=${SHELL_EMIT_ASCII_LIST:-$(git ls-files "*.sh" "*.rish" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")}

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513, learned by every sibling. The awk
# lives in a function so its exit status can be read: an empty answer from a refused read is
# byte-identical to an empty answer from a clean file, and the second is the one everyone hopes for.
count_file() {
  LC_ALL=C awk '
    BEGIN { inhere = 0; delim = ""; dash = 0 }

    # One character, counted once, classified by the whole UTF-8 sequence, and billed to the
    # reading its command line chose.
    function tally(str, kind,   stop, at, seq, k, ch) {
      stop = length(str)
      at = 1
      while (at <= stop) {
        ch = substr(str, at, 1)
        if (ch !~ /[\300-\377]/) { at++; continue }
        if (kind == "w") w++; else sp++
        seq = ch
        k = at + 1
        while (k <= stop && substr(str, k, 1) ~ /[\200-\277]/) { seq = seq substr(str, k, 1); k++ }
        # The eight forms the rule names and spells are reported apart from the notation tail: one
        # number is a mechanical sweep, the other is a reader choosing a word -- or declining to.
        if (seq == "\342\200\224" || seq == "\342\200\223" || seq == "\302\267" ||
            seq == "\342\200\246" || seq == "\342\206\222" || seq == "\342\206\220" ||
            seq == "\342\206\224" || seq == "\342\210\222") t++
        at = k
      }
    }

    # Walk one line once, tracking quote state, and hand each command segment to emit().
    function walk(s,   at, stop, q, ch, seg) {
      stop = length(s)
      at = 1
      q = ""
      seg = ""
      while (at <= stop) {
        ch = substr(s, at, 1)
        if (q == "") {
          if (ch == "\\") { seg = seg ch substr(s, at + 1, 1); at += 2; continue }
          if (ch == "\047") { q = "\047"; seg = seg ch; at++; continue }
          if (ch == "\"")   { q = "\"";   seg = seg ch; at++; continue }
          # A `#` begins a comment only at the start of a word, and only unquoted.
          if (ch == "#" && (seg == "" || substr(s, at - 1, 1) ~ /[ \t]/)) break
          if (ch == ";" || ch == "|" || ch == "&" || ch == "(" || ch == ")") {
            emit(seg); seg = ""; at++; continue
          }
          seg = seg ch; at++; continue
        }
        # Inside a double quote a backslash escapes; inside a single quote it does not.
        if (q == "\"" && ch == "\\") { seg = seg ch substr(s, at + 1, 1); at += 2; continue }
        if (ch == q) { q = ""; seg = seg ch; at++; continue }
        seg = seg ch; at++
      }
      emit(seg)
    }

    # One command segment. If its command word is an emit verb, tally its operand region, billed
    # spoken or written by whether the segment redirects.
    function emit(seg,   c, i, cmd, rest, region, kind, at, stop, ch, q, redirected) {
      c = seg
      sub(/^[ \t]+/, "", c)
      sub(/[ \t]+$/, "", c)
      if (c == "") return
      # A keyword and an assignment are not the command: `then echo ...` runs echo. Bounded at six
      # steps, so no line can loop here however it is written.
      for (i = 0; i < 6; i++) {
        if (c ~ /^(then|else|elif|do|time|!|\{)[ \t]+/) { sub(/^[^ \t]+[ \t]+/, "", c); continue }
        if (c ~ /^exec[ \t]+/) { sub(/^exec[ \t]+/, "", c); continue }
        if (c ~ /^[A-Za-z_][A-Za-z0-9_]*=/) { sub(/^[^ \t]+[ \t]*/, "", c); continue }
        break
      }
      cmd = c
      sub(/[ \t].*$/, "", cmd)
      sub(/^.*\//, "", cmd)
      if (cmd != "echo" && cmd != "printf") return
      rest = c
      sub(/^[^ \t]+[ \t]*/, "", rest)
      if (rest == "") return
      # The operand region ends at the first UNQUOTED redirect; what follows is a path.
      stop = length(rest)
      at = 1
      q = ""
      region = ""
      redirected = 0
      while (at <= stop) {
        ch = substr(rest, at, 1)
        if (q == "") {
          if (ch == "\\") { region = region ch substr(rest, at + 1, 1); at += 2; continue }
          if (ch == "\047") { q = "\047"; at++; continue }
          if (ch == "\"")   { q = "\"";   at++; continue }
          if (ch == ">" || ch == "<") { redirected = 1; break }
          region = region ch; at++; continue
        }
        if (q == "\"" && ch == "\\") { region = region ch substr(rest, at + 1, 1); at += 2; continue }
        if (ch == q) { q = ""; at++; continue }
        region = region ch; at++
      }
      kind = redirected ? "w" : "s"
      tally(region, kind)
    }

    {
      s = $0
      if (inhere) {
        trimmed = s
        sub(/^[ \t]+/, "", trimmed)
        if (s == delim || (dash && trimmed == delim)) { inhere = 0 }
        next
      }
      c = s
      sub(/^[ \t]+/, "", c)
      if (substr(c, 1, 1) == "#") next
      # The sibling meter opener rule, kept character for character so the two agree about where a
      # heredoc body begins and ends. A here-string `<<<"x"` is rejected by the preceding `<`.
      if (match(s, /<<-?[ \t]*("[A-Za-z_][A-Za-z0-9_]*"|\047[A-Za-z_][A-Za-z0-9_]*\047|\\?[A-Za-z_][A-Za-z0-9_]*)/) &&
          (RSTART == 1 || substr(s, RSTART - 1, 1) != "<")) {
        op = substr(s, RSTART, RLENGTH)
        dash = (substr(op, 3, 1) == "-") ? 1 : 0
        d = op
        sub(/^<<-?[ \t]*/, "", d)
        gsub(/["\047\\]/, "", d)
        delim = d
        inhere = 1
        next
      }
      walk(s)
    }
    END { print (sp + 0) " " (w + 0) " " (t + 0) }
  ' "$1"
}

spoken=0
written=0
named=0
files=0
dirty=0
absent=0
report=""

for f in $list; do
  [ -f "$f" ] || continue
  [ -L "$f" ] && continue
  files=$((files + 1))
  if ! triple=$(count_file "$f" 2>/dev/null); then
    absent=$((absent + 1))
    continue
  fi
  sp=${triple%% *}
  rest=${triple#* }
  wr=${rest%% *}
  tn=${rest#* }
  spoken=$((spoken + sp))
  written=$((written + wr))
  named=$((named + tn))
  tot=$((sp + wr))
  [ "$tot" -gt 0 ] || continue
  dirty=$((dirty + 1))
  report="$report$tot $f
"
done

if [ "$mode" = "--list" ]; then
  printf '%s' "$report" | sort -rn | head -40
fi

# THE CEILING only falls. Lower it whenever a lap converts an emitted character; never raise it.
#   509  `20260916.183114`  across 77 files, the reading on the lap this meter was seated
ceiling=${SHELL_EMIT_ASCII_CEILING:-509}

emit=$((spoken + written))

echo "files_read=$files"
echo "files_unreadable=$absent"
if [ "$absent" -gt 0 ]; then
  echo "instrument=failed"
else
  echo "instrument=ok"
fi
echo "files_with_emit=$dirty"
echo "spoken=$spoken"
echo "written=$written"
echo "emit=$emit"
echo "emit_named=$named"
echo "ceiling=$ceiling"
if [ "$absent" -gt 0 ]; then
  # A METER THAT READ NOTHING PRINTS A CLEAN CEILING TOO (REDS %513). A refused read answers no.
  echo "under_ceiling=no"
else
  if [ "$emit" -le "$ceiling" ]; then echo "under_ceiling=yes"; else echo "under_ceiling=no"; fi
fi
if [ "$absent" -gt 0 ]; then
  echo "verdict=refused"
else
  echo "verdict=ok"
fi
