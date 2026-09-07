#!/bin/sh
# rota_declared_scan.sh -- a rota read that leaves no field cannot be told from one that never ran.
#
# WHY. The council rota asks each lap to deep-read one row of the 5 x 3 grid, and the whole value of
# that habit is that the corpus returns to living awareness on a schedule. Whether it happens is
# only knowable from the record, and on `20260906` the record answered three different ways across
# 109 session logs: **20** carried a `rota` FIELD, **52** named a row somewhere in prose, and **37**
# said nothing at all.
#
# The three-way split is the fault, and it is one observation carrying two claims -- the shape
# `foundations/20260823-204456_single-stranded.md` names. *A row appears in this log* is being asked
# to answer both *a rota was read* and *the reading was recorded*, and those come apart: a lap may
# read the rota and write about it in prose, or mention a row for an unrelated reason, or do neither.
# Separate them and each becomes checkable.
#
# THE FIELD ALREADY EXISTS AND NO LAW MENTIONS IT. `rota lap 3985, row 0 -- Aether, the row that
# hears` is written by a fifth of today's laps and by no rule, so a ship that follows the convention
# and a ship that never heard of it are indistinguishable from the law's side. This scan counts the
# field, so the convention can become a law with a number already attached.
#
#   sh tools/fixtures/r/rota_declared_scan.sh            # counts for the open day
#   sh tools/fixtures/r/rota_declared_scan.sh list       # one line per undeclared log
#   ROTA_DAY=YYYYMMDD sh tools/fixtures/r/rota_declared_scan.sh
#
# `day_source` names which day answered: `open` when today held a corpus, `fallback` when the newest
# earlier shelf did, `asked` when a caller named the day. See the walk below for why midnight needs it.
#
# THE FIELD HAS A FORM FOR AN HONEST ABSENCE. `rota none -- pure repair, no rota this lap` counts as
# declared, because the record then says which of the three things happened rather than leaving a
# reader to guess. Seated in the baton `20260907.002044` so every ship reads it.
#
# THE READING is deliberately a REPORT rather than a gate. A lap that legitimately did no rota read
# -- a lap that is pure repair, a lap that ends at a custody stop -- looks identical from outside to
# one that skipped it, and a gate unable to tell them apart would red on honest work, which is the
# gate everybody turns off.
#
# BOUNDS: one day shelf, at most 400 logs, at most 200 reported, at most 7 shelves walked back.
set -eu

root=${ROTA_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
DAY_ASKED=${ROTA_DAY:-}
DAY=${ROTA_DAY:-$(TZ=America/New_York date +%Y%m%d)}
MAX_LOGS=400
MAX_REPORT=200
# How many shelves back the walk below may look before it refuses. Seven is a working week, so a
# fleet that stops for a weekend still reads its last real corpus, and a tree genuinely abandoned
# for longer refuses rather than reporting a fortnight-old census as though it were today's.
MAX_LOOKBACK=7

work=$(mktemp -d "${TMPDIR:-/tmp}/rota-declared.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

# invariant: a corpus of zero is a red, never a reading (REDS %170) -- so the day this scan reports
# is always a day that actually holds tracked logs.
tracked_logs() {
  git ls-files "session-logs/date/$1/*.kyri" | head -"$MAX_LOGS" > "$work/logs.txt"
  [ -s "$work/logs.txt" ]
}

# THE OPEN DAY IS EMPTY AT MIDNIGHT, AND THAT IS A CLOCK FACT RATHER THAN A FAULT. The subject was
# `today` alone, so between 00:00 and the day's first COMMITTED log there is nothing to count and
# the scan refused -- daily, on every ship, healing itself an hour later. A withheld receipt makes
# every ship pay a full cold pass, so an ordinary daily state read as somebody's fault.
#
# A named day still refuses. A caller who writes ROTA_DAY asked about THAT day and is owed the
# refusal rather than a silent answer about another one; only the open day, which nobody named,
# falls back to the newest shelf that holds a corpus.
#
# The walk reads SHELF NAMES on disk in descending order rather than doing date arithmetic, so it
# needs no second reading of what yesterday is, and it never reads a shelf dated ahead of the day
# asked for.
if [ -n "$DAY_ASKED" ]; then
  day_source=asked
  [ -d "session-logs/date/$DAY" ] || { echo "refused: no day shelf at session-logs/date/$DAY -- nothing to read" >&2; exit 2; }
  tracked_logs "$DAY" || { echo "refused: the day shelf holds no tracked logs -- every count below would read zero" >&2; exit 2; }
else
  day_source=open
  if ! tracked_logs "$DAY"; then
    day_source=fallback
    found=
    seen=0
    for d in $(ls -1 session-logs/date 2>/dev/null | grep -E '^[0-9]{8}$' | sort -r); do
      [ "$d" -gt "$DAY" ] && continue
      seen=$((seen + 1))
      [ "$seen" -gt "$MAX_LOOKBACK" ] && break
      if tracked_logs "$d"; then found=$d; break; fi
    done
    [ -n "$found" ] || { echo "refused: no shelf within $MAX_LOOKBACK of $DAY holds tracked logs -- every count below would read zero" >&2; exit 2; }
    DAY=$found
  fi
fi

logs=$(wc -l < "$work/logs.txt" | tr -d ' ')
field=0; prose=0; silent=0
: > "$work/undeclared.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  # `rota none -- <why>` counts as DECLARED, and that is the whole point of the third answer. A lap
  # that honestly did no rota read has a way to say so, and the record then distinguishes it from a
  # lap that simply left no trace -- which the elder three-way split could not do.
  if grep -q '^rota ' "$f" 2>/dev/null; then
    field=$((field + 1))
  elif grep -qiE 'row [0-9]' "$f" 2>/dev/null; then
    prose=$((prose + 1))
    printf 'prose-only\t%s\n' "$f" >> "$work/undeclared.txt"
  else
    silent=$((silent + 1))
    printf 'silent\t%s\n' "$f" >> "$work/undeclared.txt"
  fi
done < "$work/logs.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/undeclared.txt" | while IFS="$(printf '\t')" read -r kind f; do
    case "$kind" in
      prose-only) printf 'prose-only: %s names a row and declares no rota field\n' "$f" ;;
      silent)     printf 'silent: %s records no rota reading at all\n' "$f" ;;
    esac
  done
fi

echo "day=$DAY"
echo "day_source=$day_source"
echo "logs=$logs"
echo "rota_field=$field"
echo "prose_only=$prose"
echo "silent=$silent"
