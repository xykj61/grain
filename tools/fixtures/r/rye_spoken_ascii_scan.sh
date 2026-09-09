#!/bin/sh
# tools/fixtures/r/rye_spoken_ascii_scan.sh -- non-ASCII in what a Rye program PRINTS to a person.
#
# WHY. `.claude/rules/ascii-first.md` governs prose in four subjects, and three of them already
# carry a meter: the living card, the documents, and the comments. The fourth was seated
# `20260907.075500` as `tools/fixtures/r/rish_spoken_ascii_scan.sh`, which reads what a RISHI guard
# says out loud, and its argument is written there in full: a heredoc body is what a program feeds
# ONWARD, so converting it changes behavior; a `say` line is what a program says TO A PERSON, so
# converting it changes register, and register is what the rule governs.
#
# THAT ARGUMENT IS ABOUT SPEECH, NOT ABOUT RISHI. Rye speaks the same way, through `print`, and the
# comment meter beside it -- `tools/fixtures/r/rye_comment_ascii_scan.sh` -- declines program
# content for the same one reason its Rishi sibling does. So the tree holds a guard over what a
# Rishi program says and none over what a Rye program says, in the language it writes most of its
# own modules in.
#
# THE SIZE OF THE GAP, measured `20260908.214712` over the same tracked `.rye` sources the comment
# meter opens, under the same law, on the same run:
#      3794  characters the Rye comment meter counts and holds (its ceiling)
#      3996  characters this meter counted before this lap swept its own lane, in 809 files
# Of those, all but a few dozen are the SIX forms the rule's own substitution table names and
# spells -- em dash, middle dot, right arrow, ellipsis, en dash, left-right arrow. The remainder is
# notation a reader chooses the ASCII word for rather than a script guessing it: a `\302\247`
# section sign citing a spec clause, a `\342\210\245` in a concatenation formula, a minus sign in a
# field name. The two are printed apart for exactly that reason -- one number is a sweep, the other
# is a judgment.
#
# WHAT COUNTS. A SPOKEN region is everything between a `print(` call's opening parenthesis and its
# matching close, at any depth, across as many lines as the call spans. Rye's `print` is the
# opening triad's own binding (`const print = std.debug.print;`), and the qualified
# `std.debug.print(` counts too, since a reader meets the same sentence either way.
#
# A LINE-ORIENTED READING WOULD MISS HALF OF IT, and that is measured rather than feared. This tree
# writes a claim line as a chain of string literals joined by `++` across four or five lines, so a
# scan matching `print(` alone reads the first line and walks past the rest: 2,480 characters stand
# on lines holding the call, and 2,235 more on its continuation lines. So this meter tracks
# parenthesis depth outside string literals rather than matching a line at a time.
#
# THE PRECEDING-CHARACTER TRAP, met on the lap this meter was written. `print` must be read as a
# whole identifier: `crypto/bip32.rye` documents a `parent_fingerprint(4)` field, and a pattern
# matching `print\(` anywhere finds `fingerprint(` inside it. Three such lines stand in the tree
# today. The scan reads the whole identifier back from the parenthesis and compares it to `print`,
# so a longer name ending in those letters can never certify itself.
#
# WHAT DOES NOT COUNT, each line drawn where counting would be wrong rather than merely hard:
#   * a `//` COMMENT, including one trailing a spoken line -- the sibling meter's room. Charging one
#     character to two ceilings makes each reading depend on the other. That residue was named here
#     rather than quietly swept into this numerator, and the sibling CLOSED it on `20260908.232949`:
#     `tools/fixtures/r/rye_comment_ascii_scan.sh` prints a second reading, with its own ceiling,
#     over exactly the trailing comments this meter steps past -- 1,311 characters in 366 files, and
#     an escape hatch rather than a blind spot, since moving an own-line comment onto a code line
#     dropped its characters out of every numerator and read as a sweep.
#   * every line outside a print call -- a `const` binding, a struct field, a `std.mem.eql`
#     comparison. A test asserting that a decoder handles an em dash must CONTAIN one, so counting
#     those would ask the tree's own modules to stop being able to test what they decode.
#   * a sentence assembled through a variable (`print("{s}", .{msg})` counts the literal text; the
#     value of `msg` is followed by nobody). Following a value is parsing rather than scanning, so
#     this meter UNDERCOUNTS on purpose, the same way both siblings do.
#
# THE UNIT IS A CHARACTER, counted by its UTF-8 lead byte in the C locale, and the byte range is
# spelled in OCTAL -- both conventions inherited from the sibling meters, and both bought with a red
# there. `\x00-\x7F` is a GNU awk extension the BWK awk parses as literal characters, and `LC_ALL=C`
# pins both awks to bytes so one em dash reads 1 under either.
#
# USAGE
#   sh tools/fixtures/r/rye_spoken_ascii_scan.sh          # count
#   sh tools/fixtures/r/rye_spoken_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap converts spoken lines; never raise it.
# The arc, each figure measured rather than recalled:
#   3895  `20260908.214712`  the reading on the lap this meter was seated, mantra and tally swept to zero
CEILING=3895

# A symlink is skipped for the sibling's reason: `git ls-files` lists a link AND its target as two
# paths, and following both counts one set of bytes twice (REDS %340). The Rye comment meter paid
# 548 characters of phantom headroom to learn this.
list=$(git ls-files "*.rye" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513, learned by every sibling. The awk
# lives in a function so its exit status can be read: an empty answer from a refused read is
# byte-identical to an empty answer from a clean file, and the second is the one everyone hopes for.
count_file() {
  LC_ALL=C awk '
    BEGIN { depth = 0; in_str = 0; in_raw = 0 }
    {
      s = $0
      len = length(s)
      i = 1
      in_raw = 0
      while (i <= len) {
        c = substr(s, i, 1)
        if (in_str) {
          if (c == "\\") { i += 2; continue }
          if (c == "\"") { in_str = 0; i++; continue }
          if (depth > 0 && c ~ /[\300-\377]/) { i = tally(s, i, len); continue }
          i++
          continue
        }
        if (in_raw) {
          if (depth > 0 && c ~ /[\300-\377]/) { i = tally(s, i, len); continue }
          i++
          continue
        }
        # A raw multiline string runs to the end of the line and holds no closing quote.
        if (c == "\\" && substr(s, i + 1, 1) == "\\") { in_raw = 1; i += 2; continue }
        # A comment runs to the end of the line and belongs to the sibling meter.
        if (c == "/" && substr(s, i + 1, 1) == "/") break
        if (c == "\"") { in_str = 1; i++; continue }
        # A character literal may hold a parenthesis, so it is stepped over whole.
        if (c == "'"'"'") {
          i++
          while (i <= len) {
            ch = substr(s, i, 1)
            if (ch == "\\") { i += 2; continue }
            if (ch == "'"'"'") { i++; break }
            i++
          }
          continue
        }
        if (c == "(") {
          if (depth > 0) depth++
          else {
            # Read the identifier back from the parenthesis, whole. A longer name ending in these
            # letters -- `fingerprint(` -- must never certify itself as a spoken call.
            j = i - 1
            while (j >= 1 && substr(s, j, 1) ~ /[A-Za-z0-9_]/) j--
            if (substr(s, j + 1, i - j - 1) == "print") depth = 1
          }
          i++
          continue
        }
        if (c == ")") { if (depth > 0) depth--; i++; continue }
        i++
      }
    }
    END { print (n + 0) " " (t + 0) }

    # One character, counted once, and classified by the whole UTF-8 sequence. Returns the index
    # just past it, so the continuation bytes are never counted a second time.
    function tally(str, at, stop,   seq, k) {
      n++
      seq = substr(str, at, 1)
      k = at + 1
      while (k <= stop && substr(str, k, 1) ~ /[\200-\277]/) { seq = seq substr(str, k, 1); k++ }
      # The six forms the rule names and spells are reported apart from the notation tail:
      # one number is a mechanical sweep, the other is a reader choosing a word.
      if (seq == "\342\200\224" || seq == "\342\200\223" || seq == "\302\267" ||
          seq == "\342\200\246" || seq == "\342\206\222" || seq == "\342\206\220" ||
          seq == "\342\206\224") t++
      return k
    }
  ' "$1"
}

total=0
table=0
files=0
absent=0
opened=0
report=""
for f in $list; do
  [ -L "$f" ] && continue
  if [ ! -f "$f" ]; then
    absent=$((absent + 1))
    continue
  fi
  opened=$((opened + 1))
  pair=$(count_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  n=${pair% *}
  t=${pair#* }
  case "$n$t" in
    '' | *[!0-9]*)
      echo "instrument=failed"
      echo "detail=awk_answered_no_number"
      echo "detail_path=$f"
      echo "verdict=misread"
      exit 1
      ;;
  esac
  if [ "$n" -gt 0 ]; then
    files=$((files + 1))
    total=$((total + n))
    table=$((table + t))
    report="$report$n $f
"
  fi
done

if [ "$mode" = "--list" ]; then
  printf '%s' "$report" | sort -rn | head -40
fi

if [ "$total" -le "$CEILING" ]; then under=yes; else under=no; fi
echo "instrument=ok"
echo "RYE_SPOKEN_ASCII files=$files chars=$total table_forms=$table notation=$((total - table)) opened=$opened absent=$absent ceiling=$CEILING under_ceiling=$under"
