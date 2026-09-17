#!/bin/sh
# tools/fixtures/r/rish_dangling_else_scan.sh -- in `if COND then assert X else MSG`, whose
# `else` is it?
#
#   sh tools/fixtures/r/rish_dangling_else_scan.sh [--list] [--explain <path>]
#
# THE GRAMMAR FACT, read from the interpreter rather than from a habit. `do_if` in
# `rishi/src/main.rye` splits its then arm at the FIRST top-level ` else ` that `find_word_op`
# reports, and only then hands each arm to `eval_statement`. `do_assert` looks for its own
# optional ` else "message"` in the argument it receives. So when both appear on one line the
# `if` takes the `else` first and the `assert` is handed a bare condition. The message the author
# wrote never reaches the parameter it was written for.
#
# THAT HAS TWO EFFECTS, and only one of them has ever been seen (REDS %806).
#
#   condition FALSE -- the false arm is whatever followed `else`, handed to `eval_statement`. A
#                      bare string literal is no statement, so the run refuses `UnknownStatement`
#                      and the guard reds. This is the half the row recorded, found on a pier
#                      that happened to take the false branch.
#   condition TRUE  -- the assert runs with NO message and reports the bare condition as its
#                      reason. The author's sentence is discarded in silence, on every pier, in
#                      the branch the author DID run, and nothing says so.
#
# Both were pressed against the built binary in a pen before this reading was written.
# Parenthesizing the condition does not help, since `find_word_op` tracks depth and the ` else `
# still stands at top level; a valid statement in the else arm does not help either, since the
# swallow happens before the arms are looked at.
#
# THE TWO POPULATIONS, and why a fact rather than a guess tells them apart. A top-level `else`
# after an `assert` always swallows the message -- yet a hand may have MEANT an ordinary
# conditional with a message-less assert in one arm and real work in the other. Nothing in the
# text says which was intended, so the reading splits on what can be decided:
#
#   dangling_else        -- the else arm is a BARE STRING LITERAL. A string is never a Rishi
#                           statement, so it can only ever have been written as the assert's
#                           message. Both faults above fire. GATED as a ratchet.
#   assert_else_shadowed -- the else arm IS a statement (`say`, `let`, `assert`, ...). The
#                           message is still swallowed on the true branch, at real cost, and the
#                           false branch runs as written. REPORTED, because whether that was the
#                           intent is a judgment about one line's author.
#
# WHY A RATCHET RATHER THAN A WALL. `%806` names two repair doors and neither is a lap's to take.
# Rewriting a site changes what a standing guard asserts, which belongs to the lane that owns it;
# teaching Rishi to bind `else` to the nearer `assert` is a grammar change wanting every standing
# `then assert` site proven unmoved. A wall would red whichever ships own these files for a
# ruling none of them has been given. The ceiling carries no slack and falls in the commit that
# sweeps a site.
#
# WHAT IT DOES NOT REACH. A Rishi statement is one physical line, so nothing here spans lines and
# the reading is exact in that direction. It reads `if` statements alone: the same swallow inside
# a `for-each ... do if ...` body is read, since that `if` stands on the line, while an `assert`
# reached through a user function is invisible to any static reading. It says nothing about
# whether a given assert's condition is worth asserting.
#
# THIS SCAN IS NOT IN ITS OWN POPULATION: it is `.sh` and the reading opens `.rish` alone. Its
# control plants into a `mktemp` pen outside the tree, so no planted line reaches tracked bytes.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/src" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"
cd "$_fd_root" || exit 2

# THE CEILING, taken the lap this scan was seated, with no slack: a ceiling carrying room is a
# ceiling that welcomes the next copy. Lower it in the same commit that sweeps a site.
CEILING=6

# BOUNDS an order above the live reading, so a wildly wrong enumeration meets a named refusal.
MAX_SOURCES=20000
MAX_ROWS=4000
# A statement nests `if` arms a handful deep at most; past this the line is named unreadable
# rather than walked further, so a pathological line meets a bound instead of a long loop.
MAX_NEST=8

MODE=count
TARGET=
case "${1:-}" in
  '')        ;;
  --list)    MODE=list ;;
  --explain) MODE=explain; TARGET=${2:-} ;;
  *) echo "$0: unknown argument '$1' (want --list or --explain <path>)" >&2; exit 2 ;;
esac
if [ "$MODE" = explain ] && [ -z "$TARGET" ]; then
  echo "$0: --explain wants a path" >&2
  exit 2
fi

work=$(mktemp -d) || exit 2
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files -- '*.rish' > "$work/sources.txt" || exit 2
sources=$(wc -l < "$work/sources.txt" | tr -d ' ')
if [ "$sources" -gt "$MAX_SOURCES" ]; then
  echo "$0: $sources tracked Rishi sources past the bound of $MAX_SOURCES" >&2
  exit 2
fi

# Candidates first, so the walk reads the few files that could carry the shape rather than all of
# them. The path list reaches grep through `xargs_lines`, newline-delimited on both piers -- a
# bare `$(cat ...)` splits a path on a space and hands grep two broken paths matching nothing.
xargs_lines "$work/sources.txt" \
  grep -lE '(^|[[:space:]])if[[:space:]].*[[:space:]]then[[:space:]]' \
  > "$work/candidates.txt" 2>/dev/null || true
candidates=$(wc -l < "$work/candidates.txt" | tr -d ' ')

# One row per `if ... then assert` site: `<path>:<line>\t<class>\t<else-arm>`.
: > "$work/rows.txt"
if [ "$candidates" -gt 0 ]; then
  xargs_lines "$work/candidates.txt" awk -v MAX_NEST="$MAX_NEST" '
    # The interpreters own walk: quote-aware and depth-aware, returning the first top-level
    # occurrence of `word` in `s`, or 0. Mirrors `find_word_op` in rishi/src/main.rye.
    function top_idx(s, word,   i, n, w, q, d, c) {
      n = length(s); w = length(word); q = 0; d = 0
      for (i = 1; i + w - 1 <= n; i++) {
        c = substr(s, i, 1)
        if (c == "\"") { q = 1 - q; continue }
        if (q) continue
        if (c == "(" || c == "[" || c == "{") { d++; continue }
        if ((c == ")" || c == "]" || c == "}") && d > 0) { d--; continue }
        if (d == 0 && substr(s, i, w) == word) return i
      }
      return 0
    }
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    {
      line = $0
      t = trim(line)
      # A Rishi comment is a whole line; there are no trailing comments, so a `#` mid-line is data.
      if (t ~ /^#/ || t == "") next
      # The `if` may open the line or stand as a `for-each ... do if ...` body.
      k = top_idx(" " t, " if ")
      if (k == 0) next
      stmt = trim(substr(" " t, k + 1))

      # WALK THE ARMS THE WAY `do_if` DOES, rather than matching one level. Each nested `if`
      # splits its then arm at the first top-level ` else `, so an `else` written for an inner
      # `assert` is taken by whichever `if` reaches it first. The arm that GETS taken is what
      # this loop carries out, which is the only thing that decides whether a message survives.
      claimed = ""
      steps = 0
      while (stmt ~ /^if[ \t]/) {
        if (steps >= MAX_NEST) { claimed = "?unreadable"; break }
        steps++
        ti = top_idx(stmt, " then ")
        if (ti == 0) { claimed = "?unreadable"; break }
        rest = trim(substr(stmt, ti + 6))
        ei = top_idx(rest, " else ")
        if (ei > 0) { claimed = trim(substr(rest, ei + 6)); stmt = trim(substr(rest, 1, ei - 1)) }
        else        { stmt = rest }
      }
      if (claimed == "?unreadable") { print FILENAME ":" FNR "\tunreadable\t" ; next }
      if (stmt !~ /^assert[ \t]/) next
      if (claimed == "") { print FILENAME ":" FNR "\tclean\t" ; next }
      # A bare string literal: opens and closes on a quote with no quote between, so the whole arm
      # is one literal and no statement keyword stands outside it. A string is never a Rishi
      # statement, so such an arm can only ever have been written as the assert s message.
      if (claimed ~ /^"[^"]*"$/) cls = "dangling_else"
      else                       cls = "assert_else_shadowed"
      print FILENAME ":" FNR "\t" cls "\t" claimed
    }
  ' >> "$work/rows.txt" 2>/dev/null || true
fi

rows=$(wc -l < "$work/rows.txt" | tr -d ' ')
if [ "$rows" -gt "$MAX_ROWS" ]; then
  echo "$0: $rows then-assert sites past the bound of $MAX_ROWS" >&2
  exit 2
fi

dangling=$(awk -F'\t' '$2 == "dangling_else"' "$work/rows.txt" | wc -l | tr -d ' ')
shadowed=$(awk -F'\t' '$2 == "assert_else_shadowed"' "$work/rows.txt" | wc -l | tr -d ' ')
files=$(awk -F'\t' '$2 != "clean" { split($1, p, ":"); seen[p[1]] = 1 } END { print length(seen) + 0 }' "$work/rows.txt")

if [ "$MODE" = list ]; then
  awk -F'\t' '$2 != "clean" { printf "%s %s arm=%s\n", $1, $2, $3 }' "$work/rows.txt" | sort
fi
if [ "$MODE" = explain ]; then
  awk -F'\t' -v t="$TARGET" 'index($1, t ":") == 1 { printf "%s %s arm=%s\n", $1, $2, $3 }' "$work/rows.txt" \
    | sort > "$work/explain.txt"
  if [ -s "$work/explain.txt" ]; then
    cat "$work/explain.txt"
  else
    echo "explain: $TARGET carries no if-then-assert site this reading can see"
  fi
fi

echo "sources_tracked=$sources"
echo "candidates=$candidates"
echo "then_assert_sites=$rows"
echo "dangling_else=$dangling"
echo "assert_else_shadowed=$shadowed"
echo "files_affected=$files"
echo "ceiling=$CEILING"
if [ "$dangling" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
else
  echo "verdict=ok"
fi
