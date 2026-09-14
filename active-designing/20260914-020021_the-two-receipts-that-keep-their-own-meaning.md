# The Two Receipts That Keep Their Own Meaning

**Stamp:** `20260914.020021` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Reverse-reading packet -- **Room:** mixed; the cited code and contracts are checkable, while the implementation handoff remains proposed
**Present priority:** [The Receipt You Can Read](20260912-201126_the-receipt-you-can-read-contract.md)
**Disposition:** **standfasted** -- keep the proven transaction receipt as an elder kind; let the offer receipt earn its own witness

## The matter

The accepted offer contract and the `20260704` Linengrow program both use the word *receipt*. The
shared word can make the elder witness look like proof for the new milestone. Their deciding facts
show two different product meanings, so one cannot stand in for the other.

## Reverse walk -- newest to oldest

The `20260912` contract admits a `ReceiptOfferFact`. Linengrow presents an offered value and a
promised return. Dimeroll classifies the same fact as an unrecognized offer and produces zero
journal entries. Its first whole requires one replay to preserve both readings without importing
either product's public projection type into the other.

The [current Linengrow itinerary](../construction/LINENGROW_ITINERARY.md) keeps price, permitted use,
return, and settlement as separate records. The [current Dimeroll itinerary](../construction/DIMEROLL_ITINERARY.md)
keeps offer value, recognized value, obligation, and settled value distinct.

The elder [SLC-L1 scope](date/20260702/20260702-195426_slcl1-verifiable-receipt.md) names a transaction
fact with `from`, `to`, `amount`, `memo`, and `stamp`. The living `linengrow/receipt.rye` program
signs that fact, appends one record, folds the amount into a balance, and verifies the result. Its
tamper refusal is useful metal evidence for signing and verification. Its balance is also the mark
that separates it from an unrecognized offer.

The oldest deciding premise is [The Wire Serves the Fold](../foundations/20260706-022912_the-wire-serves-the-fold.md):
the record owns the meaning, while later carriage preserves it. A newer type may reuse proven
machinery. It may reuse an elder meaning only when the records are the same kind.

## Forward judgment -- oldest evidence first

The elder receipt remains a sound proof of a signed transaction fold. Reclassifying it as an offer
would turn its `balance == 100` assertion into the journal effect the accepted contract expressly
refuses. Treating the elder witness as acceptance evidence would therefore make one green line
answer two incompatible questions.

**Disposition: STANDFASTED.** Keep SLC-L1 and `linengrow/receipt.rye` as testimony for the elder
transaction-receipt kind. Give `grain.receipt-offer.v1` its own type-mark, fields, replay result,
Linengrow projection, Dimeroll zero-entry intake, and dual-product witness. Shared signature or
canonical-encoding helpers may be reused only through their ordinary module boundaries.

## Evidence and handoff

- The elder program asserts a folded balance of `100`; its scope names a transaction fact.
- The accepted offer contract asserts `recognition_status=unrecognized-offer` and
  `journal_entry_count=0` for the same admitted offer fact.
- The current product walls separate an offer from recognized value, obligation, and settlement.
- Incense owns contract meaning. Patchouli and Pheromone own the implementation seams. This packet
  asks them to cite the elder proof as a machinery precedent, never as the new acceptance witness.

No dated testimony or module file moves in this audit.
