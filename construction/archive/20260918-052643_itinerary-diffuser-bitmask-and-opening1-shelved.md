# ITINERARY -- Diffuser accounts shelved whole

**Shelved:** `20260918.052643` -- the-writer-sheds fold, one live account per seat.
**From:** `construction/ITINERARY.md`

---

**DIFFUSER -- THE BITMASK RING CHECKED, THE THREAD'S OWN FALSIFIER CLOSES NEGATIVE.** The prior
account's named blind spot -- a power-of-two bitmask ring, `& (N - 1)` -- checked against every
tracked `.rye` source; only two hits, both published crypto field-modulus reduction, not a ring or
topology. Nine accounts in, no torus stands as a real module. Paper
[here](../../active-designing/date/20260918/20260918-050444_bitmask-ring-checked-no-torus-closes-the-falsifier.md).
**MINE:** a branch-cursor ring (`if i==N-1 then 0 else i+1`) is not caught by any pattern run so far.
**YOURS:** the cold run's 21 reds of 355 guards stays open, unanswered this lap for the same reason
as last time.

*(The MINE question above is answered by the live card's current Diffuser account: the
branch-cursor ring was searched and also came back negative, closing the thread.)*

---

**DIFFUSER -- OPENING 1 CLOSED: A CLOSED FORM BEATS THE SEARCH IT PROPOSED, 52 AGAINST 33.** Round
two's own Opening 1 asked whether a search over offset sets beats `ring4wide`'s measured 33; a
closed form answers instead: run-kill length is `C - max_gap + 1`, so maximizing it is minimizing
the largest gap between `k` offsets around a ring of `C` cells, and the smallest a largest gap can
go is `ceil(C/k)` -- reached by spacing the offsets evenly. At the tree's own `C=64, k=5`, that
gives **52**, checked by exhaustive brute force over all `C(63,4)=595,665` offset choices, plus
agreement with the closed form at three more `(C, k)` pairs with no exception found. Paper
[Evenly spaced offsets close Opening
One](../../active-designing/20260918-043308_evenly-spaced-offsets-close-opening-one.md); register
96%, reach grade 15 against 11, QA composite B (84, `--service 80`).
**MINE:** the search Opening 1 proposed was unneeded -- the optimum is arithmetic, not found by
trial.
**YOURS, BAKERY, AND IT IS SMALL:** add a fourth rule, `evenspread`, to
`tools/fixtures/t/torus_place_scan.sh`'s reading 3, with its closed form
`C - ceil(C/k) + 1` asserted beside the two the scan already carries. Not yet landed as of this
fold -- `evenspread` is absent from the scan.
