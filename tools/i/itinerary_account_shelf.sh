#!/bin/sh
# tools/i/itinerary_account_shelf.sh -- write an ITINERARY landed-accounts shelf, links re-anchored.
#
# WHAT THIS IS FOR. Every send folds a ship's live-front account off `construction/ITINERARY.md` onto
# a shelf in `construction/archive/`. That move takes the block one directory deeper, so every
# relative link in it must gain a level -- and the one instrument that performs exactly that rewrite,
# `tools/fixtures/r/reds_fold_reanchor.sh`, has never stood on this path. Measured `20260909`: 208
# account shelves exist, all of them written by hand, and NOTHING in `tools/` writes one.
#
#   sh tools/i/itinerary_account_shelf.sh --stamp 20260909.001122 --seat DIFFUSER < block.txt
#
# WHY A WRITER RATHER THAN A REMINDER. The filter is general, it is reachable, and its own header
# spells this exact invocation -- seated `20260908.104232`. The fault fired again the same day, from
# more than one ship. A prevention that is reachable and unknown fails the same way an absent one
# does, and the tree has already ruled on this shape twice: `%620` and the row of `20260908.113404`
# both end in the tool handing a hand what the hand kept mistyping. So the re-anchoring happens here
# because the writer does it, rather than because a hand recalled a pipe.
#
# WHY THIS INVENTS A HEADER WHERE ITS REDS SIBLING REFUSES TO. `reds_fold.sh` refuses `shelf_absent`
# on purpose: a REDS shelf's header names which rows moved and what they taught together, which is
# judgment, and a tool guessing at meaning would be worse than a hand writing it. An account shelf
# carries no such clause. Its header says which seat, which stamp, and that the block moved whole --
# and the seat and the stamp are arguments. Nothing here is judged, so nothing here is guessed.
#
# WHAT IT REFUSES, each in the safe direction:
#   not_at_root     -- `construction/ITINERARY.md` is absent, so this is not the tree's root.
#   stamp_shape     -- `--stamp` is not `YYYYMMDD.HHMMSS`, the one-clock form.
#   seat_shape      -- `--seat` is not an uppercase ship name.
#   shelf_exists    -- the target already stands. A shelf is immutable once written
#                      (accrete-never-break), so this never overwrites and never appends.
#   value_absent    -- a flag arrived last, with nothing after it. Shifting past the end is a shell
#                      error rather than a refusal, and a caller deserves the name.
#   block_empty     -- nothing arrived on stdin. An empty shelf records nothing.
#   block_too_long  -- past MAX_BLOCK_BYTES. Every collection names a maximum (TAME).
#   block_non_ascii -- a byte outside printable ASCII, tab, or newline (`.claude/rules/ascii-first.md`).
#   reanchor_absent -- the filter is missing. The rewrite is computed there, never here.
#
# WHAT IT PRINTS. `shelf=<path>` and `card_link=archive/<basename>` -- the second being exactly the
# spelling the live card needs, so the link the card carries is also handed over rather than typed.
# Beside them `asks_shelved=<n>`, and one `ask: ` line per question the block carries, so the fold
# speaks the questions it takes off the card.
#
# THE ASKS LEAVING THE CARD, SAID OUT LOUD. A ship writes its question for Keaton inside its own
# account block -- `**YOURS:** whether Tally seats a wake bound` -- and this writer moves the block
# whole, so the question leaves the one surface he reads by the same act that holds the card under
# its bound. Measured `20260910` on this tree: **72** `**YOURS` asks stand across **54 of the 339**
# account shelves; of the eight asks living on the card, **one** was ever carried forward by the
# ship that wrote it; and an account block's median life on the card is **104 minutes**, read from
# consecutive same-seat shelf stamps, with **283 of 292** lives under eight hours -- so a question
# written in the night reaches a shelf before morning. Every one of those figures is FREE, held by
# no gate, and a grep for `**YOURS` under `tools/` returns one line of unrelated prose, so nothing
# in this tree reads a shelf for a question. The move was therefore silent. It speaks here: each
# ask prints as it goes, and the hand folding the card sees what is leaving it.
#
# WHAT THAT READING IS. `**YOURS` is the live front's own ask sigil, so the count reads that token
# rather than meaning -- a question written in plain prose passes free, and a reader stays the
# standard. The listing is bounded at MAX_ASKS_PRINTED lines of ASK_PRINT_BYTES each, and a block
# carrying more names the remainder in `asks_unprinted=`. The COUNT reads the whole block before
# any truncation, since a truncating reader reporting its own truncation as the finding is a fault
# this tree has already booked.
#
# WHERE THIS STOPS, and the line is the same one that let it write a header. It never edits
# `construction/ITINERARY.md`. Splicing the card means deciding where a ship's block begins and ends,
# and eight ships shape those blocks differently -- that is judgment, and this tool does none. It
# hands back `card_link=` so the one line a hand must paste is also the one line it never has to
# retype, and the editing of the live front stays where the judgment is.
#
# BOUNDS: MAX_BLOCK_BYTES below. The write goes through a temporary and then `cat > "$target"`, so a
# refusal leaves the tree exactly as it stood.
set -eu

root=${ITINERARY_SHELF_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
cd "$root"

MAX_BLOCK_BYTES=8192
MAX_ASKS_PRINTED=16
ASK_PRINT_BYTES=160

STAMP=
SEAT=
DRY=no
while [ $# -gt 0 ]; do
  case "$1" in
    --stamp) [ $# -ge 2 ] || { echo "refused: value_absent -- --stamp wants a value" >&2; exit 2; }
             STAMP=$2; shift 2 ;;
    --seat)  [ $# -ge 2 ] || { echo "refused: value_absent -- --seat wants a value" >&2; exit 2; }
             SEAT=$2; shift 2 ;;
    --dry-run) DRY=yes; shift ;;
    *) echo "refused: unknown argument $1 -- pass --stamp, --seat, or --dry-run" >&2; exit 2 ;;
  esac
done

[ -f construction/ITINERARY.md ] || { echo "refused: not_at_root -- construction/ITINERARY.md is absent" >&2; exit 2; }

case "$STAMP" in
  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]) ;;
  *) echo "refused: stamp_shape -- --stamp wants YYYYMMDD.HHMMSS, read from the one clock" >&2; exit 2 ;;
esac

case "$SEAT" in
  '') echo "refused: seat_shape -- --seat names the ship whose account is moving" >&2; exit 2 ;;
  *[!A-Z0-9-]*) echo "refused: seat_shape -- a seat name is uppercase, as the live front writes it" >&2; exit 2 ;;
esac

reanchor=tools/fixtures/r/reds_fold_reanchor.sh
[ -f "$reanchor" ] || { echo "refused: reanchor_absent -- $reanchor holds the rewrite, never this file" >&2; exit 2; }

day=$(printf '%s' "$STAMP" | cut -d. -f1)
time=$(printf '%s' "$STAMP" | cut -d. -f2)
base="${day}-${time}_itinerary-landed-accounts.md"
target="construction/archive/$base"

if [ -e "$target" ]; then
  echo "refused: shelf_exists -- $target already stands, and a shelf is immutable once written" >&2
  exit 2
fi

block=$(cat)
[ -n "$block" ] || { echo "refused: block_empty -- the account block arrives on stdin" >&2; exit 2; }

bytes=$(printf '%s\n' "$block" | wc -c | tr -d ' ')
if [ "$bytes" -gt "$MAX_BLOCK_BYTES" ]; then
  echo "refused: block_too_long -- $bytes bytes past MAX_BLOCK_BYTES=$MAX_BLOCK_BYTES" >&2
  exit 2
fi

if printf '%s\n' "$block" | LC_ALL=C grep -q '[^ -~	]'; then
  echo "refused: block_non_ascii -- ascii-first governs what this tree writes" >&2
  exit 2
fi

anchored=$(printf '%s\n' "$block" | sh "$reanchor")

# say_asks -- name every question the block is carrying off the live card.
# invariant: the count reads the whole block and only the listing is bounded, so a held-back line
# can never understate the population it is listing.
# invariant: this reports and never refuses -- answering an ask is Keaton's word, and a writer that
# declined to shelf a block holding a question would refuse ordinary work.
say_asks() {
  asks=$(printf '%s\n' "$block" | grep -cE '\*\*YOURS' || true)
  echo "asks_shelved=$asks"
  [ "$asks" -gt 0 ] || return 0
  printf '%s\n' "$block" | grep -E '\*\*YOURS' | sed -n "1,${MAX_ASKS_PRINTED}p" \
    | cut -c1-"$ASK_PRINT_BYTES" | sed 's/^/ask: /'
  if [ "$asks" -gt "$MAX_ASKS_PRINTED" ]; then
    echo "asks_unprinted=$((asks - MAX_ASKS_PRINTED))"
  fi
  return 0
}


shelf=$(
  printf '# ITINERARY -- landed accounts, shelved `%s`\n\n' "$STAMP"
  printf '**Language:** EN\n'
  printf '**Status:** Shelf -- immutable once written; the live card holds what is OPEN\n'
  printf '**Style:** Gauge, Meter\n'
  printf '**Voice:** Kyri\n'
  printf '**Room:** Checkable -- the account moved whole, its links re-anchored by the writer\n\n'
  printf 'The %s account the live card carried before the lap of `%s`, moved here whole so the live\n' "$SEAT" "$STAMP"
  printf 'front holds one account per ship. Accrete-never-break: nothing here is edited. Written by\n'
  printf '`tools/i/itinerary_account_shelf.sh`, which ran every relative link one directory deeper\n'
  printf 'through `tools/fixtures/r/reds_fold_reanchor.sh`.\n\n'
  printf -- '---\n\n'
  printf '%s\n' "$anchored"
)

if [ "$DRY" = yes ]; then
  printf '%s\n' "$shelf"
  echo "dry_run=yes shelf=$target card_link=archive/$base"
  say_asks
  exit 0
fi

tmp="$target.tmp.$$"
printf '%s\n' "$shelf" > "$tmp"
cat "$tmp" > "$target"
rm -f "$tmp"

echo "shelf=$target"
echo "card_link=archive/$base"
say_asks
