#!/bin/sh
# tools/fixtures/r/rishi_quoted_program_scan.sh -- every awk program a Rishi witness hands to the
# shell is one awk will actually read.
#
# THE MECHANISM, in one paragraph a reader can rebuild from. Rishi keeps `\"` exactly as written
# in a string literal, so the backslash arrives at `sh` intact. Standing outside quotes, `sh`
# reads the pair as a plain `"` and the program works. Standing inside a SINGLE-quoted region --
# how every awk, sed, and perl program in this tree is written -- both characters travel on into
# the interpreter's own program text. awk then treats a string literal spelled that way as a
# syntax fault: it writes one line to stderr and prints nothing at all. Downstream `wc -l`
# answers 0, the pipeline's exit status belongs to its LAST command, and `.ok` reads true. The
# witness above it hears silence and calls it a law.
#
# WHAT IT COST, measured `20260910.031353` on three guards, all three green at the time:
#   tools/b/bricks_exist_witness.rish       -- read 0 of 20 brick paths, saying "all 20 resolve"
#   tools/g/gen_home_witness.rish           -- rostered `tier lap`; a planted stray desk in the
#                                              wrong letter room left it GREEN, proven on metal
#   tools/r/reds_row_present_witness.rish   -- its gap arithmetic answered 0 of 7 where 5 stood
#                                              open, so "every spine row found" was a sentence
#                                              its own run had skipped
#
# WHICH INTERPRETER BALKS WAS MEASURED, rather than assumed (`20260910.031353`, this pier). `grep`
# and `sed` read `\"` as a plain `"` and match correctly. `awk` warns inside a regex and carries
# on. Inside a STRING LITERAL awk stops. So the reading splits along that seam:
#
#   `awk_fatal`  -- held at ZERO. An awk program carrying `\"` is one awk may stop reading, and
#                   the witness above it hears the stop as silence.
#   `tolerated`  -- reported under a ceiling that only falls. Eighteen sites hand `\"` to grep,
#                   sed, or printf, each of which reads it correctly; a wall drawn around the
#                   whole spelling would refuse all eighteen, and the ceiling still catches a
#                   nineteenth arriving.
#
# A `\"` OUTSIDE single quotes stays welcome: it is how this tree spells a literal quote for the
# shell, it stands in dozens of living witnesses, and every interpreter reads it.
#
# HOW A SITE IS REPAIRED. Hand the literal in through `awk -v k=file '$1 == k'`, or reach for
# `grep` and `cut` where the comparison is that plain.
#
#   sh tools/fixtures/r/rishi_quoted_program_scan.sh          # the counts
#   sh tools/fixtures/r/rishi_quoted_program_scan.sh list     # interpreter, file, line per site
#
# BOUNDS: at most 8192 sources read. A corpus of zero refuses rather than reporting a clean
# sweep, because a corpus of zero is a red and never a reading (REDS %170).
set -eu

root=${QPROG_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_SOURCES=8192

if [ -n "${QPROG_LIST:-}" ]; then
  sources=$(cat "$QPROG_LIST")
else
  sources=$(git ls-files '*.rish' | head -"$MAX_SOURCES")
fi

count=$(printf '%s\n' "$sources" | grep -c . || true)
[ "$count" -gt 0 ] || { echo "refused: no .rish sources to read -- a corpus of zero is a red, never a clean sweep" >&2; exit 2; }

# The walk: a line that opens a `run [` is scanned character by character. A `'` toggles the
# single-quoted region; inside it, a backslash immediately followed by a quote is the fault.
# Comment lines are read past, since prose about the fault must be free to name it.
# ONE `grep -l` NARROWS THE POPULATION BEFORE ANY PER-FILE WALK. Two thousand four hundred
# sources is two thousand four hundred awk processes and twenty seconds; the fault needs a
# backslash-quote to exist at all, so `grep -l` hands the walk the handful of files that could
# carry one. Diffuser's tax, one room over: the counts are identical and the pass is a fifth of
# a second.
candidates=$(printf '%s\n' "$sources" | while IFS= read -r f; do [ -f "$f" ] && printf '%s\n' "$f"; done | xargs grep -l '\\"' 2>/dev/null || true)

report=$(printf '%s\n' "$candidates" | while IFS= read -r f; do
  [ -f "$f" ] || continue
  awk -v path="$f" '
    function opener(prefix,   best, who, i, w, start, q) {
      # the interpreter word standing LAST before the region opens is the one reading it
      best = 0; who = "other"
      split("awk sed grep perl", W, " ")
      for (i = 1; i <= 4; i++) {
        w = W[i]
        start = 0
        while (1) {
          q = index(substr(prefix, start + 1), w)
          if (q == 0) break
          start = start + q
          if (start > best) { best = start; who = w }
        }
      }
      return who
    }
    /^[[:space:]]*#/ { next }
    index($0, "run [") == 0 { next }
    {
      sq = 0; open_at = 0
      for (i = 1; i <= length($0); i++) {
        c = substr($0, i, 1)
        if (c == "\047") { if (sq == 0) open_at = i; sq = 1 - sq; continue }
        if (sq == 1 && c == "\\" && substr($0, i + 1, 1) == "\042") {
          print opener(substr($0, 1, open_at)) "\t" path ":" FNR
          next
        }
      }
    }
  ' "$f"
done)

fatal=$(printf '%s\n' "$report" | grep -c '^awk' || true)
tolerated=$(printf '%s\n' "$report" | grep -c '^\(sed\|grep\|perl\|other\)' || true)

sites=$(printf '%s\n' "$report" | grep -c . || true)

if [ "$MODE" = list ]; then
  # An `if` rather than `[ -z ... ] ||`, so the print is a branch rather than a value standing in
  # for a failure -- `instrument_refusal` reads the second shape as a fallback, and it is right to
  # (REDS %681, and this scan reddened it on the lap it was written).
  if [ -n "$report" ]; then printf '%s\n' "$report" | sed 's/^/quoted-program: /'; fi
fi

echo "sources=$count"
echo "quoted_program_sites=$sites"
echo "awk_fatal=$fatal"
echo "tolerated=$tolerated"
echo "tolerated_ceiling=${QPROG_CEILING:-18}"
if [ "$fatal" -eq 0 ] && [ "$tolerated" -le "${QPROG_CEILING:-18}" ]; then echo "verdict=ok"; else echo "verdict=refused"; fi
