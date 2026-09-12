#!/bin/sh
# tools/fixtures/s/shell_written_ascii_scan.sh -- non-ASCII in text a SHELL script assembles and
# feeds onward, rather than says or comments.
#
# WHY THE SHELL HALF. The ASCII-first law names documents, code comments, what a program says out
# loud, and -- since `20260911.215028` -- what a Rye program ASSEMBLES into a buffer and hands on.
# That fifth meter named this gap in its own header and priced it from the two fixture files it
# happened to know: "the residue is 2 characters in 2 files." Measured here over every tracked
# shell source, the real population is 1,419 characters across 122 files, and 1,417 of them stand
# in `tools/equinox/almanac/` generators whose heredocs append entries to
# `rye-learning-process/GLOW_ALMANAC.md` -- the one page a hand swept from 1,437 to zero on
# `20260910.042550`. A guess taken from the files a meter could already see read seven hundred
# times small.
#
# THREE SIBLINGS ALL NAMED THIS BODY AND ALL STEPPED PAST IT, each giving one reason: converting a
# heredoc "changes what a program prints", so excluding it is what makes a sweep safe. That reason
# is exactly right about a heredoc a PARSER consumes, and it is the Rye written meter's own
# argument one language over that it covers two populations. A heredoc handed to `python3` is a
# program. A heredoc handed to an appender that writes Markdown is PROSE, and prose is what the
# ASCII-first law governs.
#
# WHAT COUNTS -- a HEREDOC BODY: every line between an opener (`<<WORD`, `<<-WORD`, `<<'WORD'`,
# `<<"WORD"`) and its delimiter line. `<<-WORD` may close on an indented delimiter and plain
# `<<WORD` may not, which is the shell's own rule and is kept, because closing a heredoc early
# would read ordinary code as assembled text. An opener is read from non-comment lines only, so a
# `<<` quoted inside a header block cannot swallow a file. Arithmetic shift (`1 << 3`) and a
# here-string (`<<<`) both fail the opener pattern, which requires an identifier to follow.
#
# WHAT DOES NOT COUNT, each line drawn where counting would be wrong rather than merely hard:
#   * a `#` COMMENT outside a heredoc -- `tools/fixtures/s/shell_comment_ascii_scan.sh`'s room.
#     Charging one character to two ceilings makes each reading depend on the other.
#   * a `say` line outside a heredoc -- `tools/fixtures/r/rish_spoken_ascii_scan.sh`'s room.
#   * every literal outside a heredoc. A `printf` argument assembling one line is genuinely this
#     meter's subject and is NOT read, because finding it needs to know whether a quote sits inside
#     another quote, which is parsing rather than scanning. This meter UNDERCOUNTS on purpose, the
#     same way all four siblings do, and says so rather than implying coverage.
#
# THE SECOND READING, and why it REPORTS rather than gates. `program` is the subset of `written`
# whose opener hands the heredoc to an interpreter AS CODE -- `python3 <<PY`, `sh <<EOF`, `awk -f -`
# -- recognised by the command word standing alone or carrying `-c`/`-f -` rather than a script
# path. Converting one of those changes behavior, so it is named and excluded from any sweep rather
# than refused. `sh tools/x/engine.sh <<DATA` is the OTHER shape and stays counted: the command is
# an interpreter and the heredoc is that script's stdin, which is data. That distinction is the
# whole reason this meter can see the almanac population at all.
#
# `sweepable = written - program` is therefore the number a lane acts on, and it is printed so no
# reader has to do the subtraction and get it wrong.
#
# WHAT THE CEILING CANNOT BE TODAY. A wall at zero is impossible: 1,417 living characters stand in
# the equinox almanac stubs, which are DATED generators whose entries already landed, and whose
# engine exits 0 on a seat already present -- so they are inert rather than pending. Whether a
# dated generator is swept, re-poured, or retired governs a family and wants Keaton's word, which
# is the same standfast `construction/ITINERARY.md` already carries for the dated equinox guards.
# So `written` ratchets under a ceiling that only falls.
#
# THE UNIT IS A CHARACTER, counted by its UTF-8 lead byte in the C locale, the byte range spelled
# in OCTAL -- both conventions inherited from the sibling meters, and both bought with a red there.
# `\x00-\x7F` is a GNU awk extension the BWK awk parses as literal characters, and `LC_ALL=C` pins
# awk to bytes so one em dash reads 1 under either.
#
# USAGE
#   sh tools/fixtures/s/shell_written_ascii_scan.sh          # count
#   sh tools/fixtures/s/shell_written_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode=${1:-}

# A symlink is skipped for the sibling's reason: `git ls-files` lists a link AND its target as two
# paths, and following both counts one set of bytes twice (REDS %340).
list=$(git ls-files "*.sh" "*.rish" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513, learned by every sibling. The awk
# lives in a function so its exit status can be read: an empty answer from a refused read is
# byte-identical to an empty answer from a clean file, and the second is the one everyone hopes for.
count_file() {
  LC_ALL=C awk '
    BEGIN { inhere = 0; delim = ""; dash = 0; prog = 0 }
    {
      s = $0
      if (inhere) {
        trimmed = s
        sub(/^[ \t]+/, "", trimmed)
        if (s == delim || (dash && trimmed == delim)) { inhere = 0; next }
        tally(s, prog)
        next
      }
      # An opener is read from a non-comment line only.
      c = s
      sub(/^[ \t]+/, "", c)
      if (substr(c, 1, 1) == "#") next
      # A here-string `<<<"x"` contains `<<"x"` starting one character in, so the opener is
      # rejected when another `<` sits immediately before it. The control plants exactly that.
      if (match(s, /<<-?[ \t]*("[A-Za-z_][A-Za-z0-9_]*"|'"'"'[A-Za-z_][A-Za-z0-9_]*'"'"'|\\?[A-Za-z_][A-Za-z0-9_]*)/) &&
          (RSTART == 1 || substr(s, RSTART - 1, 1) != "<")) {
        op = substr(s, RSTART, RLENGTH)
        dash = (substr(op, 3, 1) == "-") ? 1 : 0
        d = op
        sub(/^<<-?[ \t]*/, "", d)
        gsub(/["'"'"'\\]/, "", d)
        delim = d
        inhere = 1
        prog = interpreter(substr(s, 1, RSTART - 1))
      }
    }
    END { print (n + 0) " " (p + 0) " " (t + 0) }

    # THE ONE CLASSIFICATION. The text before the opener is the command. A bare interpreter word,
    # or one carrying `-c` or `-f -`, consumes the heredoc AS CODE; the same word followed by a
    # script path hands it that script as stdin, which is data. Returns 1 for code.
    function interpreter(pre,   w, i, k, words, seen, cmd) {
      # The command begins after the last shell separator, so a pipeline or an `exec` prefix reads
      # as the command it actually runs.
      sub(/^.*[;&|][ \t]*/, "", pre)
      sub(/^[ \t]*exec[ \t]+/, "", pre)
      k = split(pre, words, /[ \t]+/)
      cmd = ""
      for (i = 1; i <= k; i++) {
        w = words[i]
        if (w == "") continue
        sub(/^.*\//, "", w)
        if (cmd == "") { cmd = w; continue }
        if (w ~ /^-/) {
          if (w == "-c") return 1
          if (w == "-f") return 1
          continue
        }
        # A non-flag operand after the command is a script path or a subcommand: the heredoc is
        # that program stdin rather than its source.
        return 0
      }
      if (cmd ~ /^(sh|bash|dash|ksh|zsh|python|python2|python3|perl|ruby|node|awk|gawk|mawk|sed|bc|dc|ed|lua|tclsh|Rscript)$/) return 1
      return 0
    }

    # One character, counted once, and classified by the whole UTF-8 sequence.
    function tally(str, isprog,   stop, at, seq, k, ch) {
      stop = length(str)
      at = 1
      while (at <= stop) {
        ch = substr(str, at, 1)
        if (ch !~ /[\300-\377]/) { at++; continue }
        n++
        if (isprog) p++
        seq = ch
        k = at + 1
        while (k <= stop && substr(str, k, 1) ~ /[\200-\277]/) { seq = seq substr(str, k, 1); k++ }
        # The seven forms the rule names and spells are reported apart from the notation tail: one
        # number is a mechanical sweep, the other is a reader choosing a word.
        if (seq == "\342\200\224" || seq == "\342\200\223" || seq == "\302\267" ||
            seq == "\342\200\246" || seq == "\342\206\222" || seq == "\342\206\220" ||
            seq == "\342\206\224" || seq == "\342\210\222") t++
        at = k
      }
    }
  ' "$1"
}

written=0
program=0
named=0
files=0
dirty=0
program_files=0
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
  n=${triple%% *}
  rest=${triple#* }
  pr=${rest%% *}
  tn=${rest#* }
  written=$((written + n))
  program=$((program + pr))
  named=$((named + tn))
  [ "$n" -gt 0 ] || continue
  dirty=$((dirty + 1))
  [ "$pr" -gt 0 ] && program_files=$((program_files + 1))
  report="$report$n $f
"
done

if [ "$mode" = "--list" ]; then
  printf '%s' "$report" | sort -rn | head -40
fi

# THE CEILING only falls. Lower it whenever a lap converts an assembled heredoc; never raise it.
#   1419  `20260912.023000`  across 122 files, the reading on the lap this meter was seated
ceiling=1419

sweepable=$((written - program))

echo "files_read=$files"
echo "files_unreadable=$absent"
if [ "$absent" -gt 0 ]; then
  echo "instrument=failed"
else
  echo "instrument=ok"
fi
echo "files_with_written=$dirty"
echo "files_with_program=$program_files"
echo "written=$written"
echo "written_named=$named"
echo "program=$program"
echo "sweepable=$sweepable"
echo "ceiling=$ceiling"
if [ "$absent" -gt 0 ]; then
  # A METER THAT READ NOTHING PRINTS A CLEAN CEILING TOO (REDS %513). A refused read answers no.
  echo "under_ceiling=no"
else
  if [ "$written" -le "$ceiling" ]; then echo "under_ceiling=yes"; else echo "under_ceiling=no"; fi
fi
if [ "$absent" -gt 0 ]; then
  echo "verdict=refused"
else
  echo "verdict=ok"
fi
