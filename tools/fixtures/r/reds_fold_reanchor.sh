#!/bin/sh
# tools/fixtures/r/reds_fold_reanchor.sh -- re-anchor a REDS row's links as it moves one level down.
#
# WHAT THIS IS FOR. A REDS row lives in `construction/REDS.md` and folds onto a shelf in
# `construction/archive/`. Accrete-never-break asks that a row's prose move byte for byte, and a
# relative link is the one kind of prose whose truth depends on where its file sits. Read this
# filter's whole job in one line: a row written from `construction/` is rewritten to read correctly
# from `construction/archive/`, one directory deeper.
#
#   sh tools/fixtures/r/reds_fold_reanchor.sh < rows.txt > rows-reanchored.txt
#
# THE FILTER IS GENERAL AND ITS NAME IS NOT (`20260908.104232`). Nothing here is REDS-specific: it
# rewrites relative links for any prose moving from `construction/` down into `construction/archive/`,
# which is the same move an ITINERARY landed-accounts shelf makes on every send. That shelf is
# written BY HAND, by the send, with no tool in its path -- and the depth fault it causes fired five
# times in one week from five different hands, each repairing it afterward.
#
#   ITINERARY account shelf, at the moment the block is written:
#     sh tools/fixtures/r/reds_fold_reanchor.sh < account-block.txt >> construction/archive/<stamp>_itinerary-landed-accounts.md
#
# Prevention at write time and repair after the fact are two different tools and both are wanted:
# this filter is the first, `tools/f/fold_shelf_link_repoint.sh` is the second, and the second exists
# because the first was reachable and unknown rather than absent.
#
# THE TWO CLASSES, and only one of them was named. REDS %247 named this fault; REDS %270 met it a
# second time and specified the fix as re-anchoring `](../` to `](../../`, with `](../REDS.md)`
# held as written. Measured `20260826` over the living pin, a second form is there too:
# `](archive/NAME)` points from `construction/` into the shelf directory, and from a shelf it would
# resolve to `construction/archive/archive/NAME`. Today that form lives only in recital pointers,
# which are paragraphs rather than rows, so handling it here is prevention -- and it costs one
# substitution, which is cheaper than the round it would otherwise take later.
#
# THE ONE EXCEPTION IS `](../REDS.md)`, and it is protected first. From `construction/archive/` that
# link reads `construction/REDS.md`, which is exactly where a shelf's own `Folded:` header points.
# Every shelf this filter ever touches depends on that header surviving, so the form is masked out
# before the general rule runs and restored after.
#
# WHERE THIS STOPS. A bare path in backticks -- `../tools/x`, wrapped in no `](...)` -- names a path
# in prose where a link would invite a click, and the tree's own link guards read `](...)` syntax
# alone (REDS %268). Leaving it exactly as written keeps the filter on a row's links and off its
# words, which is what accrete-never-break asks. Proven by `reds_fold_control.sh`.
set -eu

# The mask is a token a row would have to go out of its way to carry: this tree writes plain 7-bit
# ASCII prose (ascii-first), and an at-sign pair around an uppercase word is absent from the whole
# ledger. Checked before use, so a collision refuses rather than corrupts.
MASK='@@REDS_PIN_SELF@@'

input=$(cat)

case "$input" in
  *"$MASK"*)
    echo "reds-fold-reanchor: refused -- the input already carries the mask token $MASK" >&2
    exit 2
    ;;
esac

printf '%s\n' "$input" \
  | sed -e "s|](\.\./REDS\.md)|](${MASK}REDS.md)|g" \
        -e 's|](\.\./|](../../|g' \
        -e 's|](archive/|](|g' \
        -e "s|](${MASK}REDS\.md)|](../REDS.md)|g"
