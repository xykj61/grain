#!/bin/sh
# tools/fixtures/c/calfive_schedule_scan.sh -- find a Calfive round claim that disagrees with
# the formula context/SPELLBOOK.md's own `round load` spell already states: a round's place
# in its orbit is (count - 1) % 15 + 1. A planning page in expanding-prompts/ often states both
# a commit count and the orbit round it names for that count, by hand. This scan recomputes the
# round from the stated count and names every page where the two disagree -- a scheduling
# conflict a reader would otherwise have to re-derive fifteen numbers by eye to catch.
#
# invariant: a page naming no count, or a count with no round claim beside it, is read past
# rather than guessed at -- this scan only compares a count and a round the page itself paired.
#
# Usage: sh tools/fixtures/c/calfive_schedule_scan.sh [--room DIR]

set -eu

ROOM="expanding-prompts"
if [ "${1:-}" = "--room" ]; then
  ROOM="${2:-expanding-prompts}"
fi

count=$(git rev-list --count HEAD)
orbit_round=$(( (count - 1) % 15 + 1 ))
quest_place=$(( (count - 1) % 75 + 1 ))
orbit_in_quest=$(( (quest_place - 1) / 15 + 1 ))
quest_start=$(( count - quest_place + 1 ))
quest_end=$(( quest_start + 74 ))

echo "calfive-scan: count=${count} orbit_round=${orbit_round} quest_place=${quest_place} orbit_in_quest=${orbit_in_quest}"
echo "calfive-scan: this_quest=${quest_start}-${quest_end} next_quest_opens=$(( quest_end + 1 ))"

# The round-load table in context/SPELLBOOK.md must name rounds 1..15 exactly once -- a row
# dropped, doubled, or out of range is a conflict in the canon itself, ahead of any page that
# cites it.
table_rounds=$(grep -oE '^\| [0-9]+ \|' context/SPELLBOOK.md | grep -oE '[0-9]+' | sort -n | tr '\n' ' ')
expect_rounds=$(seq 1 15 | tr '\n' ' ')
table_verdict=ok
if [ "$table_rounds" != "$expect_rounds" ]; then
  table_verdict=conflict
  echo "calfive-scan: TABLE CONFLICT -- context/SPELLBOOK.md round-load table reads [${table_rounds}], wanted 1..15 once each"
fi

# A planning page stating both a commit count and the orbit round it claims for that count,
# on one line, is a claim this scan can check against the live formula.
conflicts=0
checked=0
for f in "$ROOM"/*.md; do
  [ -f "$f" ] || continue
  while IFS= read -r line; do
    case "$line" in
      *"rev-list --count HEAD"*"orbit round is"*) ;;
      *) continue ;;
    esac
    stated_count=$(printf '%s\n' "$line" | grep -oE 'is [0-9]+,?[0-9]+\.' | head -1 | tr -dc '0-9' || true)
    stated_round=$(printf '%s\n' "$line" | grep -oE 'orbit round is [0-9]+' | head -1 | grep -oE '[0-9]+$' || true)
    [ -n "$stated_count" ] && [ -n "$stated_round" ] || continue
    checked=$((checked + 1))
    want_round=$(( (stated_count - 1) % 15 + 1 ))
    if [ "$want_round" != "$stated_round" ]; then
      conflicts=$((conflicts + 1))
      echo "calfive-scan: CONFLICT ${f} -- count ${stated_count} claims round ${stated_round}, the formula gives ${want_round}"
    fi
  done < "$f"
done

echo "calfive-scan: pages_checked=${checked} conflicts=${conflicts} table=${table_verdict}"
if [ "$conflicts" -eq 0 ] && [ "$table_verdict" = "ok" ]; then
  echo "verdict=ok"
  exit 0
else
  echo "verdict=conflict"
  exit 1
fi
