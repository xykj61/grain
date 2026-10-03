# Pheromone, inner

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** Living -- two consent shape pedestals landed `20261002`, next ruling awaited
**Room:** checkable -- the fruit names a measured ceiling and two options already on the card
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

**The second crux, named `20261001.112238`, closed `20261001.181632`.** `ConsentGrantFact` and
`ConsentRevokeFact` are sketched as Glow shapes -- field names, auras, and one refusal case each --
at
[`active-designing/date/20261001/20261001-181632_grant-and-revoke-fact-glow-shapes.md`](../active-designing/date/20261001/20261001-181632_grant-and-revoke-fact-glow-shapes.md),
sized against [milestone two's product
contract](../active-designing/date/20261001/20261001-145643_the-consent-you-can-change-contract.md).
Neither shape needed `max_fields` raised -- nine and seven faces, both under the fifteen the first
fruit seated. Nothing was lowered into Mantra; that stays Patchouli's and Incense's door. The
elder `construction/ITINERARY.md` account was shelved in the same lap and a new one opened naming
this sketch.

**Ruled `20261001.200649`.** The `.lap` Glow desk stays untracked; the sketch is the desk.
`orphaned-revoke` earned its `Reason` member in the consent lowering. A re-check of either closed
fruit is not a fruit.

**The fruit ruled `20261001.204655` closed `20261002.004500`.** Two shape pedestals landed in the
form `src/shape/shape-mantra-weave-field-count.glow` already uses: `src/shape/shape-consent-grant.glow`
(example 9) and `src/shape/shape-consent-revoke.glow` (example 7), naming the nine and seven fields
`ConsentGrantFact` and `ConsentRevokeFact` already carry in `mantra/src/consent_replay.rye`. One
witness, `tools/m/mantra_glow_tend_limb5_witness.rish`, proves both example counts against the rye
via `tools/fixtures/r/rye_struct_fields_scan.sh` and asserts `rune_shape.max_fields` stayed at 15.
Rostered into `construction/standing-equipment.kyri`, GREEN on metal both as the roster's own
`mantra_glow_tend_limb5` guard and run standalone. `.lap/shape-receipt-offer.glow` was not copied;
`mantra/src/consent_replay.rye` and `tally/receipt_refusal.rye` were not touched.

**Ruled `20261002.142242`.** `ReceiptOfferFact` stands one field to a line, so the field reader can see all fifteen. Lowering began on Patchouli's door. `orphaned-revoke` already names a `Reason` member, and the two consent facts stand in `mantra/src/consent_replay.rye`. This lane leaves `mantra/` and `tally/` closed. The next fruit is one pedestal, `src/shape/shape-receipt-offer.glow`, written fresh from `ReceiptOfferFact`'s field count in `mantra/src/receipt_offer.rye`, in the same form as `src/shape/shape-consent-grant.glow`. `rune_shape.max_fields` stays 15. The untracked `.lap` desk stays untracked. A new rune returns to Incense.

**This fruit closed `20261002.144821`.** `src/shape/shape-receipt-offer.glow` names `ReceiptOfferFact`'s
fifteen fields -- schema, receipt_id, holder_id, recipient_id, product_id, product_digest, purpose,
value_amount, value_unit, value_basis, return_kind, issued_at, expires_at, signer_id, signature --
read in order from the struct in `mantra/src/receipt_offer.rye`, the same form as
`shape-consent-grant.glow`. Fifteen sits AT `rune_shape.max_fields`'s own ceiling rather than under
it, the widest fact this room has named. `rye_struct_fields_scan.sh` assumes one field per line, and
`ReceiptOfferFact` first stood several to a line, so this lane's own first pass read the placard's
number against the struct by hand and against `offer_fact_fields`'s comptime assert alone -- then
Keaton's own commit (`6061691fbe`, co-authored with Cursor) filed the struct one field to a line,
touching no field, no type, and no order, so the scan could see all fifteen. On that reformat,
`tools/m/mantra_glow_tend_limb7_witness.rish` lands the same way limb5 proves the two consent
pedestals -- the placard's declared count and field order read straight out of the rye, the
comptime assert checked too, the desk lowered, built, and run. Rostered into
`construction/standing-equipment.kyri`. `src/shape/README.md` gained the three rows this lap found
missing while it was open -- consent grant, consent revoke, and this one -- since none of the three
stood in the table before. `mantra/src/receipt_offer.rye`'s one whitespace-only reformat aside,
`tally/` and `glow/rune_shape.rye` are untouched. A new rune returns to Incense.

**The fruit ruled `20261002.152352` closed `20261002.153600`.** Two more pedestals, read from
ITINERARY's own step 2 ("carry them through lowering into Mantra and both projections"):
`src/shape/shape-linengrow-receipt-field-count.glow` names `LinengrowReceipt`'s eleven fields
(the receipt contract's Linengrow projection) and `src/shape/shape-dimeroll-intake-field-count.glow`
names `DimerollReceiptIntake`'s seven fields (the Dimeroll projection), both read from
`mantra/src/linengrow_receipt_offer.rye` and `mantra/src/dimeroll_receipt_offer.rye` in the same
form limb5/limb7/limb8 already use. Two witnesses,
`tools/m/mantra_glow_tend_limb8_witness.rish` and `tools/m/mantra_glow_tend_limb9_witness.rish`,
each prove the placard's declared count and field order against the rye via
`tools/fixtures/r/rye_struct_fields_scan.sh`, check the struct's own comptime field-count
constant, lower and run the desk, and assert `rune_shape.max_fields` stayed at 15. Both GREEN on
metal. Rostered into `construction/standing-equipment.kyri` as limb8 and limb9.
`src/shape/README.md` gained the two rows. Neither `mantra/src/receipt_offer.rye`,
`mantra/src/consent_replay.rye`, `tally/`, nor `glow/rune_shape.rye` was touched. A new rune
returns to Incense.

**The fruit claimed `20261003.074404` closed `20261003` the same lap.** `src/shape/shape-receipt-refusal-field-count.glow`
names `tally/receipt_refusal.rye`'s `Refusal` three fields -- field, reason, measure -- the stable
admission-refusal record ITINERARY's own step 3 ("make refusal output stable: field, value,
ceiling, unit, and reason") already built in Rye and this pedestal now names in Glow. `tally/receipt_refusal.rye`
gained a published `refusal_fields` constant tied by a comptime assert to
`@typeInfo(Refusal).fields.len`, the same tie `offer_fact_fields` already holds for
`ReceiptOfferFact`, in the same form limb5/limb7/limb8/limb9 already use. `tools/m/mantra_glow_tend_limb10_witness.rish`
proves the placard's declared count and field order against the rye via
`tools/fixtures/r/rye_struct_fields_scan.sh`, checks the struct's own comptime constant, lowers and
runs the desk, and asserts `rune_shape.max_fields` stayed at 15. GREEN on metal. Rostered into
`construction/standing-equipment.kyri` as limb10. `src/shape/README.md` gained the row.
`tally/receipt_refusal_witness.rish` and `tools/t/tally_receipt_refusal_witness.rish` both stayed
GREEN after the one-field addition; neither `mantra/src/receipt_offer.rye` nor
`glow/rune_shape.rye` was touched. A new rune returns to Incense.

## gates

Keys, funds, provisioning, identity, and the public seed stay manual.
