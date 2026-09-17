#!/bin/sh
# loom_trend.sh -- read a measurement back out of the journal, across days.
#
# WHY THIS EXISTS. `.claude/rules/session-logs.md` asks a lap to record what it measured on a `loom`
# line, and promises the reason plainly: *so a future Loom-aware reader can trend them across logs*.
# Measured `20260907.222830`, that promise had never been kept -- **3,426 loom measurements stand
# across 1,577 session logs and NOTHING IN THE TREE READS ONE.** A grep for a reader found no tool.
#
# The convention itself is healthy, which is what makes the gap worth closing rather than the habit
# worth gating: 115 of 116 logs on `20260907` carried a loom line. The tree is writing diligently
# into a book nobody opens.
#
#   sh tools/l/loom_trend.sh <key>              # every value of <key>, oldest first, with its day
#   sh tools/l/loom_trend.sh <key> --summary    # first, last, min, max, and the direction of travel
#   sh tools/l/loom_trend.sh --keys             # the 60 most frequent keys, by how often,
#                                               with keys_distinct beside keys_shown
#   sh tools/l/loom_trend.sh --keys --all       # every key the journal holds
#   LOOM_FAMILY=roster sh tools/l/loom_trend.sh seconds --summary   # only lines naming that family
#
# A BARE KEY COLLIDES ACROSS FAMILIES, and the first reading proved it: `seconds` returned a minimum
# of 0.4 beside a maximum of 1806, because a roster pass and something far smaller both write a key
# by that name. `LOOM_FAMILY` keeps a reading to loom lines carrying that word, so a trend answers
# about ONE thing. Without it the reading is honest and broad; with it the reading is comparable.
#
# A KEY IS `name=value` ON A LOOM LINE, which is the shape the law names and the tree writes:
#   loom roster=standing_equipment_run guards=109 green=99 red=10 seconds=1562
# so `seconds`, `guards` and `red` are all keys, and `roster` is one too with a text value.
#
# WHAT IT REFUSES, each in the safe direction. A key nobody has written returns nothing and says so
# rather than printing an empty trend that reads like a flat line. A value that is not a number is
# carried through in the listing and skipped by the summary, since a mean of `standing_equipment_run`
# is not a fact. And the reading is ordered by the log's own STAMP rather than by file order, because
# a shelf holds its rows newest-first and a trend read backwards tells the opposite story.
#
# BOUNDS: at most 4000 logs read, at most 2000 values reported, and `--keys` lists the 60 most
# frequent keys of however many the journal holds -- `keys_distinct` beside `keys_shown` says
# which, and `--keys --all` lifts that third cap. All three are named here because an unnamed
# cap reads as completeness.
set -eu

root=${LOOM_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
cd "$root"

MAX_LOGS=4000
MAX_VALUES=2000
# How many keys `--keys` lists. `--keys --all` raises it to the whole vocabulary.
KEYS_SHOWN=60

KEY=${1:-}
MODE=${2:-list}
[ -n "$KEY" ] || { echo "usage: loom_trend.sh <key> [--summary] | --keys" >&2; exit 2; }

# THE VALUE READ IS SPELLED ONCE, IN A SIBLING (`20260917`). A second reader --
# `tools/fixtures/l/loom_sitting_scan.sh` -- asks a different question of these same values, and two
# readers spelling one read is two readings free to come to disagree. So the read lives in
# `tools/fixtures/l/loom_values.sh`, sourced here rather than copied there, and the move was proven
# by this file's own output standing byte-identical before and after it.
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$here/../fixtures/l/loom_values.sh"

work=$(mktemp -d "${TMPDIR:-/tmp}/loom-trend.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

LOOM_MAX_LOGS=$MAX_LOGS
export LOOM_MAX_LOGS
git ls-files 'session-logs/date/*/*.kyri' 2>/dev/null | head -"$MAX_LOGS" > "$work/logs.txt"
# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
[ -s "$work/logs.txt" ] || { echo "refused: no tracked session logs -- every reading below would be empty" >&2; exit 2; }

if [ "$KEY" = "--keys" ]; then
  # Every key written, by how often -- the most frequent KEYS_SHOWN of them, and then the size of
  # the whole vocabulary beside the size of the listing, so the cap is never silent. `--keys --all`
  # lifts it to every key counted.
  #
  # THE CAP USED TO BE THE LAST WORD OF THIS PIPELINE AND NOTHING SAID SO (`20260917`). This branch
  # ended `| head -60`, the header called the mode *the map of what the journal actually holds*, and
  # `.claude/rules/session-logs.md` told every ship the same. It showed 60 of 9,767. A cap is lawful
  # -- this tree bounds everything -- and a cap contradicting its own tool's account of itself is
  # not, because a reader cannot tell a small journal from a truncated reading of a large one.
  # Two laps on one day took the sixty for the vocabulary: one built a premise wrong by two orders
  # of magnitude, and one sampled `loom_name`'s verdicts over a population that frequency had
  # already selected -- and *written by many families* is the definition of the verdict it drew 60
  # times out of 60.
  while IFS= read -r f; do
    grep '^loom ' "$f" 2>/dev/null || true
  done < "$work/logs.txt" \
    | tr ' ' '\n' | grep -E '^[A-Za-z_][A-Za-z0-9_]*=' | cut -d= -f1 \
    | sort | uniq -c | sort -rn > "$work/keys.txt"
  distinct=$(grep -c . "$work/keys.txt" || true)
  [ -n "$distinct" ] || distinct=0
  if [ "$MODE" = "--all" ]; then shown=$distinct; else shown=$KEYS_SHOWN; fi
  # A listing never claims more rows than it holds, so a journal under the cap reads the two equal.
  [ "$shown" -le "$distinct" ] || shown=$distinct
  head -"$shown" "$work/keys.txt"
  echo "keys_distinct=$distinct"
  echo "keys_shown=$shown"
  exit 0
fi

# The log's own stamp orders the trend. A basename carries it, so no file need be opened to sort.
loom_values "$KEY" "$work/raw.txt" || exit 2
sort "$work/raw.txt" > "$work/values.txt"

n=$(grep -c . "$work/values.txt" || true)
[ -n "$n" ] || n=0
if [ "$n" -eq 0 ]; then
  echo "key=$KEY"
  echo "values=0"
  echo "verdict=key_never_written"
  exit 0
fi

if [ "$MODE" = "--summary" ]; then
  awk -F'\t' -v key="$KEY" '
    { v[NR]=$2; s[NR]=$1
      if ($2 ~ /^-?[0-9]+(\.[0-9]+)?$/) { num++; x=$2+0
        if (num==1) { mn=x; mx=x; first=x; firsts=$1 }
        if (x<mn) mn=x
        if (x>mx) mx=x
        last=x; lasts=$1; sum+=x } }
    END {
      printf "key=%s\n", key
      printf "values=%d\n", NR
      printf "numeric=%d\n", num+0
      if (num > 0) {
        printf "first=%s at %s\n", first, firsts
        printf "last=%s at %s\n", last, lasts
        printf "min=%s\nmax=%s\n", mn, mx
        printf "mean=%.2f\n", sum/num
        d = last - first
        printf "direction=%s\n", (d > 0 ? "rising" : (d < 0 ? "falling" : "level"))
      } else {
        printf "direction=not_numeric -- these values are names rather than measurements\n"
      }
    }
  ' "$work/values.txt"
  exit 0
fi

# THE WHOLE LOOM LINE IS SHOWN, NOT ONLY THE VALUE (`20260908.011352`). A key is comparable only
# within one scope, and this reader merged two that were not: `legs=hole wall_s=10` -- a single fast
# leg -- read beside `wall_s=1502` for a whole witness run, which looks like a 150x regression and is
# a leg measured against a run. Printing the line the value came from makes the scope visible, so a
# reader can see incomparability rather than infer a trend from it.
head -"$MAX_VALUES" "$work/values.txt" | while IFS="$(printf '\t')" read -r stamp v f; do
  ctx=$(grep -h "^loom .*[ =]${KEY}=${v}\([ ]\|$\)" "$f" 2>/dev/null | head -1 | cut -c1-96)
  printf '%s\t%s\t%s\n' "$stamp" "$v" "${ctx:-$f}"
done
echo "key=$KEY"
echo "values=$n"
