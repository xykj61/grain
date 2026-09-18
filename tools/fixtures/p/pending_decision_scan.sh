#!/bin/sh
# tools/fixtures/p/pending_decision_scan.sh -- gather a decision left open across its four places.
#
# WHY THIS EXISTS. active-designing/20260918-000154_three-numbers-and-a-name.md measured a decision
# parked in four places at once -- a sentence naming Keaton's word inside living prose, a line
# already recording a word granted, a `YOURS:` row on the operator card, and an `Open doors for
# Keaton` section -- and found nothing reads them together. "What is waiting on me" was a question
# with four partial answers. This scan gives it one.
#
# THE FOUR PLACES, and how each is told from its neighbor:
#   parked  -- a living line naming Keaton's word, ruling, or call, carrying a forward-looking verb
#              (waits, awaits, wants, needs, returns, stays, pending, open, parks). This is the
#              open half.
#   granted -- a living line naming "on Keaton's word" carrying a past-tense granting verb (seated,
#              molted, revised, corrected, widened, amended, reframed, chosen, decided, ruled).
#              This is the closed half, reported so a reader can tell the two apart at a glance.
#   yours   -- a `YOURS:` line, Keaton's own open question left inside a living pin.
#   doors   -- every bullet under a `## Open doors for Keaton` heading.
#
# WHAT IT READS PAST. Dated, archived, yonder, and vendored shelves are testimony or held-external
# text; a decision granted last month reads there correctly and this scan is about what is open
# NOW. Read-scope's closed stacks (`.claude/rules/read-scope.md`) name the same shape.
#
# REPORTED, NEVER GATED. A pending decision is a state, not a fault -- Keaton's own pace decides
# when each closes. This scan always exits 0; `verdict=reported` says so plainly.
#
#   sh tools/fixtures/p/pending_decision_scan.sh            # counts, one line per match
#   sh tools/fixtures/p/pending_decision_scan.sh --root DIR # read a different tree (for the control)
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
if [ "${1:-}" = "--root" ]; then
  ROOT=$2
fi
cd "$ROOT"

# Bound: a page named twice (parked once, granted once) would double-count a decision, so a line
# is read for one classification only, in this order.
MAX_FILES=4000

closed_shelf() {
  case "$1" in
    */date/*|*/archive/*|*/yonder/*|vendor/*|gratitude/*|seed/*) return 0 ;;
    *) return 1 ;;
  esac
}

git ls-files '*.md' | head -"$MAX_FILES" > /tmp/pending_decision_files.$$
trap 'rm -f /tmp/pending_decision_files.$$' EXIT INT TERM

parked=0
granted=0
yours=0
doors=0
doors_sections=0

while IFS= read -r f; do
  closed_shelf "$f" && continue
  [ -f "$f" ] || continue

  in_doors=0
  while IFS= read -r line; do
    case "$line" in
      '## Open doors for Keaton'*)
        in_doors=1
        doors_sections=$((doors_sections + 1))
        continue
        ;;
      '## '*)
        in_doors=0
        ;;
    esac

    if [ "$in_doors" -eq 1 ]; then
      case "$line" in
        -\ *)
          doors=$((doors + 1))
          echo "doors $f: $line"
          ;;
      esac
      continue
    fi

    case "$line" in
      *"YOURS:"*)
        yours=$((yours + 1))
        echo "yours $f: $line"
        continue
        ;;
    esac

    case "$line" in
      *"Keaton's word"*|*"Keaton's ruling"*|*"Keaton's call"*)
        case "$line" in
          *seated*|*Seated*|*molted*|*Molted*|*revised*|*Revised*|*corrected*|*Corrected*|*widened*|*Widened*|*amended*|*Amended*|*reframed*|*Reframed*|*chosen*|*Chosen*|*decided*|*Decided*|*ruled*|*Ruled*)
            granted=$((granted + 1))
            echo "granted $f: $line"
            ;;
          *wait*|*Wait*|*await*|*Await*|*want*|*Want*|*need*|*Need*|*return*|*Return*|*stay*|*Stay*|*pending*|*Pending*|*open*|*Open*|*park*|*Park*)
            parked=$((parked + 1))
            echo "parked $f: $line"
            ;;
        esac
        ;;
    esac
  done < "$f"
done < /tmp/pending_decision_files.$$

echo "parked=$parked"
echo "granted=$granted"
echo "yours=$yours"
echo "doors=$doors"
echo "doors_sections=$doors_sections"
echo "verdict=reported"
