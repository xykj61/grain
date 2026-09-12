#!/bin/sh
# rye_written_ascii_scan.sh -- non-ASCII in text a Rye program ASSEMBLES, rather than says.
#
# WHY A FOURTH SURFACE. The ASCII-first law names documents, code comments, and what a guard says
# out loud, and each has a meter. All three read what a source COMMENTS or what a program PRINTS.
# None reads what a program BUILDS INTO A BUFFER and then hands onward -- to a file, a wire frame,
# or a generated page. That is where the law was born: REDS %83 was a persisted document rewritten
# into mojibake by a tool that read it in the wrong encoding.
#
# THE EXCLUSION THAT COVERED TWO POPULATIONS. `tools/fixtures/r/rye_spoken_ascii_scan.sh` steps past
# "every line outside a print call -- a `const` binding, a struct field, a `std.mem.eql` comparison.
# A test asserting that a decoder handles an em dash must CONTAIN one." That reason is exactly right
# about a decoder's own fixture, and it is wrong about a header a program writes into every artifact
# it pours. One line was drawn across two populations, and this meter reads the half the reason does
# not cover.
#
# WHAT COUNTS -- a WRITTEN region: everything between an assembling call's opening parenthesis and
# its matching close, at any depth, across as many lines as the call spans. The four calls are
# `bufPrint`, `bufPrintZ`, `allocPrint`, and `writeFile`; each is read as a WHOLE identifier, so
# `bufPrint(` is never mistaken for `print(` and `fingerprint(` is never mistaken for either.
#
# WHAT DOES NOT COUNT, each line drawn where counting would be wrong rather than merely hard:
#   * a `//` COMMENT -- the comment meter's room. Charging one character to two ceilings makes each
#     reading depend on the other.
#   * a written region nested INSIDE a `print(` call -- the spoken meter already counts that
#     character, and a character charged twice makes neither ceiling readable.
#   * every literal outside an assembling call -- a `const` binding, a struct field, a comparison.
#     The spoken meter's own reason holds here whole: a decoder's test must contain what it decodes.
#   * text assembled through a variable. Following a value is parsing rather than scanning, so this
#     meter UNDERCOUNTS on purpose, the same way all three siblings do.
#
# THE TWO READINGS, and why the second is a PROXY named as one. `written` counts every assembled
# character; where that buffer lands -- a file, a terminal line, a wire frame -- is dataflow this
# scan does not follow. `persisted` counts the subset standing in a file that ALSO calls
# `writeFile`, which is the closest a scanner gets to "these bytes reach a disk". It is a FILE-level
# proxy: a file writing one page and assembling an unrelated terminal line would be counted here
# wrongly. Measured `20260911.215028` it reads exactly 2, both of them genuinely written to disk,
# and both repaired on the lap this meter was seated -- so the proxy is gated at zero and a false
# refusal costs one line of explanation and a conversion the rule's own table already spells.
#
# THE SECOND READING IS THE SHARP ONE. `tools/rye/enrich/enrich_file.rye:25` assembles a Markdown
# sentence carrying an em dash and writes it into documentation pages; two tracked pages carry that
# character on disk today. `tools/fixtures/a/ascii_document_scan.sh` gates and ratchets those pages
# and reads nothing of the tool that puts characters into them. A generator feeding a gated meter,
# standing outside every meter, is the shape this reading exists to close.
#
# THE UNIT IS A CHARACTER, counted by its UTF-8 lead byte in the C locale, the byte range spelled in
# OCTAL -- both conventions inherited from the sibling meters, and both bought with a red there.
# `\x00-\x7F` is a GNU awk extension the BWK awk parses as literal characters, and `LC_ALL=C` pins
# awk to bytes so one em dash reads 1 under either.
#
# THE SHELL HALF IS OPEN, and its size is named rather than guessed. `tools/fixtures/a/amphora_pour.sh`
# writes a vessel header carrying an em dash, and `tools/fixtures/a/amphora_vessel_lap1.bron` is a
# stored vessel carrying one. Both sit in `fixtures/`, which every meter in this family reads past
# by design -- the planted mojibake control MUST keep its high bytes or its own prove-red leg proves
# nothing. A shell writer's meter is its own lap; the residue is 2 characters in 2 files.
#
# USAGE
#   sh tools/fixtures/r/rye_written_ascii_scan.sh          # count
#   sh tools/fixtures/r/rye_written_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode=${1:-}

# A symlink is skipped for the sibling's reason: `git ls-files` lists a link AND its target as two
# paths, and following both counts one set of bytes twice (REDS %340).
list=$(git ls-files "*.rye" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513, learned by every sibling. The awk
# lives in a function so its exit status can be read: an empty answer from a refused read is
# byte-identical to an empty answer from a clean file, and the second is the one everyone hopes for.
count_file() {
  LC_ALL=C awk '
    BEGIN { depth = 0; in_str = 0; in_raw = 0; say = 0 }
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
        # A comment runs to the end of the line and belongs to the comment meter.
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
          # Read the identifier back from the parenthesis, WHOLE. A longer name ending in these
          # letters must never certify itself as an assembling call.
          j = i - 1
          while (j >= 1 && substr(s, j, 1) ~ /[A-Za-z0-9_]/) j--
          id = substr(s, j + 1, i - j - 1)
          if (depth > 0) depth++
          else if (say > 0) say++
          else if (id == "bufPrint" || id == "bufPrintZ" || id == "allocPrint" || id == "writeFile") depth = 1
          else if (id == "print") say = 1
          i++
          continue
        }
        if (c == ")") { if (depth > 0) depth--; else if (say > 0) say--; i++; continue }
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
      # The six forms the rule names and spells are reported apart from the notation tail: one
      # number is a mechanical sweep, the other is a reader choosing a word.
      if (seq == "\342\200\224" || seq == "\342\200\223" || seq == "\302\267" ||
          seq == "\342\200\246" || seq == "\342\206\222" || seq == "\342\206\220" ||
          seq == "\342\206\224") t++
      return k
    }
  ' "$1"
}

written=0
named=0
persisted=0
persisted_named=0
files=0
dirty=0
persisted_files=0
absent=0
report=""

for f in $list; do
  [ -f "$f" ] || continue
  [ -L "$f" ] && continue
  files=$((files + 1))
  if ! pair=$(count_file "$f" 2>/dev/null); then
    absent=$((absent + 1))
    continue
  fi
  n=${pair% *}
  t=${pair#* }
  written=$((written + n))
  named=$((named + t))
  [ "$n" -gt 0 ] || continue
  dirty=$((dirty + 1))
  report="$report$n $f
"
  # The proxy: a file that also writes a file somewhere is a file whose assembled text may land
  # on disk. Named as a proxy in the header above rather than claimed as dataflow.
  if LC_ALL=C grep -q 'writeFile' "$f" 2>/dev/null; then
    persisted=$((persisted + n))
    persisted_named=$((persisted_named + t))
    persisted_files=$((persisted_files + 1))
  fi
done

if [ "$mode" = "--list" ]; then
  printf '%s' "$report" | sort -rn | head -40
fi

# THE CEILINGS. `written` ratchets -- it only falls, and a lane sweeping a file lowers it in the
# same commit. `persisted` is a WALL at zero: both of its characters were repaired on the lap this
# meter was seated, and a class standing at zero is walled rather than ratcheted, since a ceiling
# above zero on an empty population is decoration.
ceiling=290
persisted_ceiling=0

echo "files_read=$files"
echo "files_unreadable=$absent"
if [ "$absent" -gt 0 ]; then
  echo "instrument=failed"
else
  echo "instrument=ok"
fi
echo "files_with_written=$dirty"
echo "written=$written"
echo "written_named=$named"
echo "ceiling=$ceiling"
if [ "$absent" -gt 0 ]; then
  # A METER THAT READ NOTHING PRINTS A CLEAN CEILING TOO (REDS %513). A refused read answers no.
  echo "under_ceiling=no"
else
  if [ "$written" -le "$ceiling" ]; then echo "under_ceiling=yes"; else echo "under_ceiling=no"; fi
fi
echo "persisted_files=$persisted_files"
echo "persisted=$persisted"
echo "persisted_named=$persisted_named"
echo "persisted_ceiling=$persisted_ceiling"
if [ "$absent" -gt 0 ]; then
  echo "persisted_under_ceiling=no"
else
  if [ "$persisted" -le "$persisted_ceiling" ]; then echo "persisted_under_ceiling=yes"; else echo "persisted_under_ceiling=no"; fi
fi
if [ "$absent" -gt 0 ]; then
  echo "verdict=refused"
else
  echo "verdict=ok"
fi
