#!/bin/sh
# tools/fixtures/c/card_pin_claim_scan.sh -- does the operator card's claim about the ledger agree
# with the ledger's own instrument?
#
# WHAT THIS IS FOR. `tools/fixtures/r/reds_pin_capacity_scan.sh` derives whether
# `construction/REDS.md` can still accept a row, and prints `pin_deadlocked` and
# `pin_foldable_rows` on every lap pass. `construction/ITINERARY.md` is the page every lap of every
# ship reads WHOLE to choose its work, and a hand may write the same fact there in prose. Two
# spellings of one reading are two files that may come to disagree (REDS %231), and when they do it
# is the prose that is read and the instrument that is ignored -- because the card is read first and
# read whole.
#
# WHY IT IS A GUARD RATHER THAN A HABIT. The disagreement has now fired twice in one direction:
#
#   `20260910.140033` -- the capacity scan's doors line still read "no lawful fold exists here" from
#   a state that had passed. FOUR ships read that line in one morning and each carried
#   "yours, Keaton" onto `construction/ITINERARY.md` -- a wall where a door stood. Recorded in that
#   scan's own header.
#
#   `20260911.025632` -- the card's INCENSE work-in-progress clause read "the REDS pin holds ~8
#   bytes with every row OPEN, so no new red can be booked until the bound rises on your word".
#   `%701` had been marked BOOKED sixteen hours earlier, so the scan read `pin_deadlocked=0` and
#   `pin_foldable_rows=1` -- one `reds_fold.sh` away from headroom, with no word from anyone -- while
#   the card told eight ships that reds-first had no landing place.
#
# A lantern that fires twice becomes a loom (`.claude/rules/reds-first.md`). The cure is the one
# `%555` already seated for the waymark roster on the same card: the card names no roster, and a
# claim it does make is read against the instrument BOTH ways.
#
# WHAT IS GATED, at zero:
#   claim_disagreements  a line on the card asserting the ledger cannot accept a row, while the
#                        capacity scan reads `pin_deadlocked=0`. The repair is to strike the claim
#                        and cite the scan, or -- when a lawful fold stands -- to take it.
#
# WHAT IS REPORTED, never gated:
#   card_blocked_claims  how many such lines stand, agreeing or not.
#   pin_deadlocked       the capacity scan's own reading, quoted rather than recomputed.
#   silent_deadlock      the pin genuinely deadlocked while the card says nothing. That is a
#                        different fault with a different cure -- somebody must WRITE a line -- and
#                        gating it would ask every ship to edit the card, so it is printed.
#   card_cites_scan      whether the card names the capacity scan at all, which is the shape the
#                        cure wants the card to carry instead of a number.
#
# WHAT THIS READING DOES NOT REACH. It reads a PHRASE LIST rather than meaning, so a claim written
# in words this list lacks reads as silence. The list is drawn from the two firings above plus the
# plain variants; widening it is a lap, and the count of phrases is printed so a reader knows how
# large the net is. It also reads a claim about the REDS pin alone -- the card carries other
# hand-copied numbers, and each is its own question.
#
# A line that NAMES the capacity scan or this scan is read as a citation rather than a claim, since
# a page teaching a reader to run the instrument must be able to quote its refusal words.
#
#   sh tools/fixtures/c/card_pin_claim_scan.sh
set -eu

CARD=${CARD_PATH:-construction/ITINERARY.md}
CAPACITY=${CAPACITY_SCAN:-tools/fixtures/r/reds_pin_capacity_scan.sh}

# The claim shapes, one per line, lowercase. Drawn from the two firings and the plain variants a
# hand reaches for. Bounded and named, so a reader can see how wide the net is (TAME: bound
# everything, say why).
CLAIM_PHRASES='no new red can be booked
no red can be booked
no new red may be booked
cannot be booked
can no longer be booked
no lawful fold
nothing foldable
none foldable
no foldable row
pin is deadlocked
ledger is deadlocked
until the bound rises'

fail() { echo "card-pin-claim: refused -- $1"; echo "verdict=$2"; exit 2; }

[ -f "$CARD" ] || fail "the operator card $CARD is not here; run from the repository root" card_absent
[ -f "$CAPACITY" ] || fail "the capacity scan $CAPACITY is not here" capacity_absent

# The instrument's own answer, quoted rather than recomputed. A scan that recomputed the deadlock
# would be a third spelling of the reading this one exists to hold to two.
cap_out=$(sh "$CAPACITY" 2>/dev/null || true)
deadlocked=$(printf '%s\n' "$cap_out" | sed -n 's/^pin_deadlocked=//p' | head -1)
foldable=$(printf '%s\n' "$cap_out" | sed -n 's/^pin_foldable_rows=//p' | head -1)
headroom=$(printf '%s\n' "$cap_out" | sed -n 's/^pin_headroom=//p' | head -1)

# An instrument that cannot answer refuses, rather than letting a missing reading read as agreement.
# A silent pass is what the first firing shipped.
case $deadlocked in
  0|1) ;;
  *) fail "$CAPACITY printed no pin_deadlocked reading, so no agreement can be checked" capacity_silent ;;
esac

phrase_count=$(printf '%s\n' "$CLAIM_PHRASES" | grep -c .)

claims=0
disagreements=0
lineno=0
while IFS= read -r line; do
  lineno=$((lineno + 1))
  lower=$(printf '%s' "$line" | tr 'A-Z' 'a-z')
  # A line naming either instrument is teaching a reader to run it, never claiming its answer.
  case $lower in
    *reds_pin_capacity*|*card_pin_claim*) continue ;;
  esac
  hit=
  while IFS= read -r phrase; do
    [ -n "$phrase" ] || continue
    case $lower in
      *"$phrase"*) hit=$phrase; break ;;
    esac
  done <<PHRASES
$CLAIM_PHRASES
PHRASES
  [ -n "$hit" ] || continue
  claims=$((claims + 1))
  if [ "$deadlocked" = 0 ]; then
    disagreements=$((disagreements + 1))
    echo "detail: claim_disagrees $CARD:$lineno -- \"$hit\" stands while the instrument reads pin_deadlocked=0, pin_foldable_rows=$foldable"
  else
    echo "detail: claim_agrees $CARD:$lineno -- \"$hit\", and the instrument reads pin_deadlocked=1"
  fi
done < "$CARD"

silent=0
if [ "$deadlocked" = 1 ] && [ "$claims" -eq 0 ]; then
  silent=1
  echo "detail: silent_deadlock the pin reads pin_deadlocked=1 and $CARD names it nowhere"
fi

cites=no
if grep -q 'reds_pin_capacity' "$CARD"; then cites=yes; fi

echo "card=$CARD"
echo "claim_phrases=$phrase_count"
echo "pin_deadlocked=$deadlocked"
echo "pin_foldable_rows=$foldable"
echo "pin_headroom=$headroom"
echo "card_blocked_claims=$claims"
echo "claim_disagreements=$disagreements"
echo "silent_deadlock=$silent"
echo "card_cites_scan=$cites"

if [ "$disagreements" -gt 0 ]; then
  echo "card-pin-claim: the card asserts the ledger is walled and the instrument reads a door."
  echo "card-pin-claim: strike the claim and cite the scan, or take the fold -- sh tools/fixtures/r/reds_fold.sh"
  echo "verdict=claim_disagrees"
  exit 2
fi

echo "verdict=ok"
