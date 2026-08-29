#!/bin/sh
# tools/fixtures/t/tame_style_compound_assert.sh -- compound asserts, without the string literals.
#
# WHY THIS EXISTS. The compound-assert ban asks that `assert(a and b)` be split, so a failure names
# which half failed rather than only that some half did. Its first reading was a plain
# `grep 'assert(.* and .*)'`, and a grep cannot tell a conjunction from a quoted string. Six Glow
# lowering witnesses assert that a generated source CONTAINS a string like
# "pair.p == 5 and pair.q == 3" -- one condition, `indexOf(...) != null`, with the word `and`
# living inside the text being searched for. Those six read as violations and were not, which is
# why the ban could not widen past them (REDS %304).
#
# WHAT IT DOES. Strips double-quoted string content and then the trailing `//` comment from each
# line before looking, the way tame_style_ban_noncomment_files.sh strips comment lines before
# looking. What remains is code, and an `and` in the code inside an assert's parentheses is a real
# conjunction. The comment strip came second (20260828): a full `//` line was already skipped, yet
# a TRAILING one was still read as code, so `assert(cand_grants == 5); // ... (equal) and the two
# behind (candidate ahead)` in constel/vote.rye read as a violation on the strength of English
# prose. Quotes are blanked FIRST so a `//` inside a literal cannot truncate real code.
#
# USAGE: sh tools/fixtures/t/tame_style_compound_assert.sh <file>...
# Prints `file:line: text` per hit; exits 1 when any hit stands, 0 when none do.
set -eu

[ "$#" -gt 0 ] || { echo "usage: $0 <file>..." >&2; exit 2; }

hits=$(awk '
  FNR == 1 { next_is_doc = 0 }
  {
    line = $0
    # a /// or // line names the ban rather than committing it
    stripped = line
    sub(/^[ \t]*/, "", stripped)
    if (stripped ~ /^\/\//) next
    # remove double-quoted content, so a conjunction inside a literal is not read as code
    code = line
    gsub(/"[^"]*"/, "\"\"", code)
    # then remove the trailing // comment, so English prose after the statement is not read as code
    sub(/\/\/.*$/, "", code)
    if (code ~ /assert\(.* and .*\)/) printf "%s:%d: %s\n", FILENAME, FNR, line
  }
' "$@" 2>/dev/null || true)

if [ -n "$hits" ]; then
  echo "$hits"
  exit 1
fi
exit 0
