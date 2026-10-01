# Pheromone, inner

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** Living -- the shape-rune fruit closed `20260923`; the sibling sketch named below
closed `20261001.152500`, grade B+/85, vision per Two Rooms
**Room:** checkable for the shape-rune fruit; vision for the grant/revoke sketch
**Outer prompt:** [`../tools/p/pheromone_seat_prompt.txt`](../tools/p/pheromone_seat_prompt.txt)

## closed

Commit `9726a654e` ("pheromone: admit fifteen Glow shape fields") landed every move the ruling
below names: `glow/rune_shape.rye`'s `max_fields` reads 15, `glow/tokens.rye`'s
`looks_like_shape_only` admits 3-18 lines, the planted refusal in `glow/refusal_witness.rye` sits
at sixteen fields, and `mantra/src/receipt_offer.rye`'s `ReceiptOfferFact` publishes fifteen
fields (`offer_fact_fields = 15`), checked by its own comptime assert. `glow_shape_capacity_witness`
reads `capacity_gap=0` -- the widest public type and the ceiling agree. Four laps across
`20261001` (`112435`, `113801`, `115149`, and this one) each re-read the same GREEN state by a
different path and found nothing moved. **A fifth re-check teaches nothing a fourth did not** --
the ruling and fruit below are kept as the record of what was asked and closed, rather than
rewritten, and this seat's next move wants a new ruling from the interactive bench: whether to
carry `.lap/shape-receipt-offer.glow`'s draft fifteen-field desk into a tracked Glow source (the
next step the ITINERARY lane names -- "express the receipt facts... in the smallest Glow form
already owned") is a scope question for Incense, not a continuation of this closed fruit.

## engine

**Claude.** The sailing loop is [`../tools/f/fleet-loop.sh`](../tools/f/fleet-loop.sh). The roster row reads claude. The fleet default is `claude-opus-5`; this tree resolves `claude-sonnet-5`.

## ruling

The interactive bench's recommendation, recorded `20260922.200759`. Keep `ReceiptOfferFact` as one shape. Do not split it into nested desks. That split would change the product meaning, which stays on the incense seat.

Raise `glow/rune_shape.rye`'s `max_fields` from 9 to 15 so fifteen fields are admitted and the sixteenth still returns `TooManyFields`. The check is `field_count >= max_fields` before the face is stored, which is why nine is admitted today and ten is the planted refusal in `glow/refusal_witness.rye`. Move that planted pair to fifteen admitted and sixteen refused.

Raise the shape-only peek with it. `glow/tokens.rye`'s `looks_like_shape_only` returns false when `glow_line_count` is above 11, and `glow/glow_run.rye` then falls through to the bare multi-line budget of 6. A fifteen-field desk is wider than 11 lines, so the peek's upper bound has to accept that desk's own line count, measured again on the contract's desk before the constant moves. Every array sized by `max_fields`, including the nine-literal demo lists, has to be filled out to 15 in the same change.

If a fresh count of the contract's fields is not 15, stop and bring the new count back. Change no other rune.

## fruit

**This fruit closed `20260923` and has been reconfirmed GREEN five times since, most recently
`20261001`.** The ruling above is history now, kept for the reasoning it carries, not a task.

**Closed `20261001.152500`:** [the sketch](../active-designing/date/20261001/20261001-152500_grant-and-revoke-as-glow-shapes.md)
names `consent-grant-shape` (nine fields) and `consent-revoke-shape` (seven fields), both inside
`glow/rune_shape.rye`'s standing fifteen-field ceiling, each with its own ceiling table drawn
forward from the consent contract and one catch case reusing the receipt's own
`receipt-refusal-shape`. Graded B+/85. Lowering either into a tracked `.glow` source, or into
Mantra, stays Patchouli's and Incense's door per the fleet-dependency order -- this seat's part is
done until a new ruling names the next move.

**If a re-check of either closed fruit looks tempting, read this line instead:** both are proven
and recorded; this seat's next move wants a new ruling from the interactive bench.

## gates

Keys, funds, provisioning, identity, and the public seed stay manual.
