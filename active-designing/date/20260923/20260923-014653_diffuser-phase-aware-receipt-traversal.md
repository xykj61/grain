# A phase-aware polar view for bounded receipt lookup

**Stamp:** `20260923.014653`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- a bounded design study; no module changes are made here
**Room:** checkable -- the field order, ceilings, and falsifier have named witnesses
**Lane:** Diffuser -- moonshots and research, handed to Bakery as a possible one-round build
**Claim:** `diffuser-phase-aware-receipt-traversal`, opened `20260923.014701`
**Kin:** [`../../../mantra/src/receipt_offer.rye`](../../../mantra/src/receipt_offer.rye), [`../../../linengrow/receipt_offer.rye`](../../../linengrow/receipt_offer.rye), [`../../../tally/receipt_offer_bounds.rye`](../../../tally/receipt_offer_bounds.rye), and [the readable receipt contract](20260912-201126_the-receipt-you-can-read-contract.md)

## The claim in one sentence

The first receipt has a small, fixed field set, so a reader can address a field by a semantic
phase and a bounded position inside that phase while the stored and wire order stays unchanged.
This software coordinate view speaks to naming and lookup; physical polar wiring and electricity
remain separate research questions.

## Observation: the receipt already has a bounded shape

`mantra/src/receipt_offer.rye` declares `ReceiptOfferFact` with **15 fields**, read from the source
on `20260923` and held by `offer_fact_fields = 15`. The same module compares every declared field
with an inline reflection loop, so a field added without a comparison fails its own compile-time
assertion. `tally/receipt_offer_bounds.rye` caps one encoded fact at **4,096 bytes**, with each
identifier at **96 bytes**, the purpose at **80 bytes**, and the value basis at **120 bytes**.
These are source observations; the cited files are the source of the figures.

`linengrow/receipt_offer.rye` publishes an **11-field** readable projection, held by
`receipt_fields = 11`. Its order carries identity, purpose, value, return, time, and status in one
straight reading. `tally/receipt_offer_bounds.rye` also declares a **72 by 18** receipt-card size;
that dimension belongs to the product surface and stays separate from this paper's lookup.

## Inference: a semantic coordinate can make the order easier to use

The contract has three useful phases:

| Phase | Meaning | Example fields | Local bound |
|---|---|---|---:|
| identity | which fact and people it names | `schema`, `receipt_id`, `holder_id`, `recipient_id`, `product_id`, `product_digest`, `signer_id` | 7 fields |
| meaning | what is offered and on what basis | `purpose`, `value_amount`, `value_unit`, `value_basis`, `return_kind` | 5 fields |
| time-and-proof | when it stands and whether its proof holds | `issued_at`, `expires_at`, `signature` | 3 fields |

The coordinate is `(phase, slot)`. `slot` starts at zero inside its phase and wraps only at that
phase's declared width. A reverse function maps the coordinate to the existing field name. The
coordinate is useful when a card, an accessibility reader, or a future lookup asks for “the second
meaning field” rather than for an unlabelled global offset. The existing declaration order and
`fact_refusal` validation order remain canonical; the coordinate is a view over them.

This is an inference from the two source structures above. The phase table adds a small lookup;
a caller that already has a field name may find the direct path clearer.

## Proposed one-round shape

Bakery could test a small pure module, for example `tally/receipt_phase_index.rye`, with three
comptime phase widths and two functions:

```text
phase_slot(phase, slot) -> field_name
field_phase_slot(field_name) -> (phase, slot)
```

The module would accept the **15** declared fields, bound phases to `0..3`, bound slots to each
phase's declared width, and prove both directions over the complete table. It would preserve
`ReceiptOfferFact` order, field ownership, refusal precedence, and the Swift receipt-card boundary.
A witness should exercise every coordinate, every phase edge, and the round trip
`field -> coordinate -> field`.

The proposal rewards readable field access and a single checked vocabulary. A new abstraction earns
its place when a real caller needs semantic lookup; otherwise this page remains the design study
and the module stays out of the tree.

## Electricity and locality: the boundary stays clear

This study measured the bounded field structure; energy, cache misses, wire length, and NUMA
distance await a separate instrument. The design performs integer and name lookup on the same
hosted machine, while a polar field name leaves the Cartesian memory bus unchanged. Any hardware
claim requires a fixed workload, a named host, and a measured comparison.

## Falsifier and test plan

The proposal earns a useful-build falsifier in two ways: direct field-name access stays clearer in
every consumer, or a complete witness needs a duplicate contract table to prove the round trip. A
controlled benchmark also falsifies the performance idea when it shows a material regression under
a stated workload; this page reserves performance judgment for that run.

The first witness should prove, over the 15-field table, that each valid pair maps to one declared
field, each field maps back to its original pair, and every invalid edge reports its boundary. A second reading
should compare one direct field-name consumer with one phase-coordinate consumer over **10,000
synthetic lookups**, a count chosen only for repeatability. The run should record wall time in
milliseconds and allocation count on the named host. The comparison is informative rather than a
release gate; its falsifier is a coordinate path that adds cost without making a real consumer
clearer.

## Hand-off

Buildable now: the pure index and its bounded witness, if Bakery accepts the caller-shaped need.
Separate work owns the energy-saving claim, hardware-topology claim, Swift surface decision, and
receipt-admission change. Those need their own owner, instrument, or design word. The narrowest next step is a witness-first prototype against the existing 15-field
fact, followed by a decision to keep or withdraw the coordinate based on a real reader.

**Confidence:** medium for the field inventory and bounds because the cited source files state
them directly; low for usefulness until a consumer exists. **Horizon:** one future build round for
the pure index and witness, with production adoption decided after a reader and the falsifier are
both present.
