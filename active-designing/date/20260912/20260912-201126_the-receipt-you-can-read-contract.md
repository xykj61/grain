# The Receipt You Can Read -- product contract

**Stamp:** `20260912.201126` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Accepted for bounded synthetic implementation on Keaton's `20260913` word -- **mixed room**: the contract edge and landed Tally/Mantra rung are checkable; the remaining public types and acceptance cases stay proposed until their witnesses pass
**Milestone:** The receipt you can read
**Revised:** `20260918.043437` -- purely additive. Dimeroll's projection lands:
`dimeroll/receipt_offer.rye` publishes `DimerollReceiptIntake` and `from_snapshot`, and
`dimeroll/receipt_offer_witness.rye` proves acceptance case 3's own half -- unrecognized offer,
zero journal entries, both before and after expiry -- GREEN under
`tools/d/dimeroll_receipt_offer_witness.rish`, which reads the product braid guard beside it. No
elder row, number, sentence, or acceptance case was removed, and nothing this tree admits or
refuses moved.
**Revised:** `20260917.234833` -- purely additive. One section reports what stands built, measured
against the tree; no elder row, number, sentence, or acceptance case was removed, and nothing this
tree admits or refuses moved. The review found no claim on this page in need of correction.
**Revised:** `20260917.090914` -- purely additive. One paragraph pair joined the acceptance cases,
naming the guard that now holds the falsifier's code half; no elder row, number, sentence, or
acceptance case was removed, and nothing this tree admits or refuses moved.
**Revised:** `20260916.065731` -- purely additive. Four ceiling rows joined the bounds table and two
paragraphs name them as borrowed; no elder row, number, or sentence was removed, and nothing this
tree admits or refuses moved. The reasoning is booked in `construction/REDS.md` at that stamp.

**Falsifier:** If one replay cannot produce both product readings below from the same admitted facts, or either product must import the other's projection type, this contract is wrong.

## The promise

One person offers one small synthetic data product for one stated purpose, at one stated value, until one visible expiration. The receipt shows those terms in a complete ASCII view. The same admitted facts reach Dimeroll as accounting evidence without turning the person's receipt into a journal entry.

This first whole stays local and synthetic. It moves no money, uses no real personal data or identity, opens no network service, and makes no tax or valuation claim.

## The one fixture

Every first witness uses these values. A test may change one field to prove a refusal; the passing case stays byte-identical.

```text
schema                 grain.receipt-offer.v1
receipt_id             receipt:sample-pollinator-counts:20260912
holder_id              person:sample-holder
recipient_id           org:sample-steward
product_id             data:weekly-pollinator-counts
product_digest         7f2d5e4b3b7f4d9ca1e8bfe4dcbddf40e67a4a880f961c27ee6a28c92f17e8a1
purpose                 habitat-planning
value_amount            1200
value_unit              USD-cent-simulated
value_basis             one-purpose license offer
return_kind             service-credit
issued_at               20260912.120000-0400
expires_at              20261012.120000-0400
signer_id               person:sample-holder
signature               fixture-signature-v1
```

`product_digest` names fixture bytes held outside the public frame. `signature` is a deterministic test signature accepted only by the fixture verifier. Neither value may be presented as production cryptography.

## Public types

The first seam exposes four types. Their names describe their jobs; module-private storage and drawing types stay private.

```text
ReceiptOfferFact
  schema, receipt_id, holder_id, recipient_id, product_id, product_digest
  purpose, value_amount, value_unit, value_basis, return_kind
  issued_at, expires_at, signer_id, signature

ReceiptState
  offer: ReceiptOfferFact
  status: offered | expired

LinengrowReceipt
  receipt_id, product_id, purpose, recipient_id
  offered_value, value_unit, value_basis, promised_return
  issued_at, expires_at, status

DimerollReceiptIntake
  receipt_id, source_fact, evidence_status
  offered_value, value_unit, recognition_status, journal_entry_count
```

`ReceiptOfferFact` is the shared immutable input. `ReceiptState` is Mantra's replay result. `LinengrowReceipt` means what the holder offered and what return was promised. `DimerollReceiptIntake` means what evidence the books received. For this milestone, Dimeroll reports `recognition_status=unrecognized-offer` and `journal_entry_count=0`: an offer is evidence, while no use, obligation, or settlement has happened.

No public type contains raw product bytes, a private key, mutable widget state, or a Dimeroll account number.

## Bounds and refusals

Tally declares these ceilings before Mantra appends anything:

| Field or population | Ceiling | Unit |
|---|---:|---|
| encoded fact | 4096 | bytes |
| each identifier | 96 | ASCII bytes |
| purpose | 80 | ASCII bytes |
| value basis | 120 | ASCII bytes |
| value amount | 9,000,000,000 | smallest declared units |
| product digest | 96 | ASCII bytes -- borrowed |
| value unit | 96 | ASCII bytes -- borrowed |
| return kind | 96 | ASCII bytes -- borrowed |
| signature | 96 | ASCII bytes -- borrowed |
| receipt facts in this replay | 1 | fact |
| receipt-card width | 72 | cells |
| receipt-card height | 18 | rows |

**Four of those rows are borrowed rather than derived, and they say so** (`20260916.065731`). The
contract declared eight ceilings while `ReceiptOfferFact` publishes fifteen fields, so admission
reached for the nearest declared number: `mantra/src/receipt_offer.rye` refuses `product_digest`,
`value_unit`, `return_kind`, and `signature` at the 96 this table declares for *each identifier*,
and `product_digest` travels inside an array named `identifiers`. The four rows above write the
number already enforced, so every admission and every refusal stands exactly where it stood. What
they buy is a reader meeting `ceiling=96` on a refusal line and finding that number in the contract rather than
inferring it from a neighbour's row.

**Each of the four still owes its own derivation**, and the honest shapes differ. `product_digest`
is a SHA-256 hex digest of exactly **64** bytes, so its bound is an exact length rather than a
ceiling, and moving it to 64 would refuse the 65-to-96 range that passes today -- a tightening, and
the one change here that alters what the product admits. `value_unit` carries a unit name plus the
mandatory `-simulated` suffix and measures **18** in the fixture; `return_kind` measures **14**;
`signature` measures **20** as a fixture signature and will measure something else entirely when a
real detached signature arrives, which is why guessing it small now would cost more than the
borrow does. Choosing those four numbers changes what the product admits, so it returns to Keaton
under this page's own closing clause.

**A guard now asks the question that found them** (`20260917.024441`). `%767` recorded in its own
second field that nothing in this tree asked whether every field a contract publishes carries a
ceiling that contract declares, so the borrow was visible only on a refusal line at runtime.
[`../../../tools/r/receipt_contract_ceiling_witness.rish`](../../../tools/r/receipt_contract_ceiling_witness.rish)
over [`../../../tools/fixtures/r/receipt_contract_ceiling_scan.sh`](../../../tools/fixtures/r/receipt_contract_ceiling_scan.sh)
reads this table, the `max_*` constants of `mantra/src/tally_receipt_offer_bounds.rye`, and every
ceiling site in `mantra/src/receipt_offer.rye`, and holds two classes at **zero**: a field refused at
a ceiling no row names, and a row stating a number other than the one the code refuses at. It reads
**14 sites, all named**.

**What it reports rather than gates is the structural cause the repair left standing.** This table
declares `each identifier` at 96 and never enumerates which fields are identifiers, and
**five fields lean on that row alone** -- `receipt_id`, `holder_id`, `recipient_id`, `product_id`,
`signer_id`. An undeclared membership is exactly the hole `product_digest` fell through, since it
travels inside an array named `identifiers` and the borrow read as compliant from both sides.
Enumerating the population changes what this page publishes, so it returns to Keaton with the four
derivations rather than being taken by a lap. Two more readings ride beside it: `borrowed_rows`
counts the four rows above, and `row_unenforced` reads **2** -- `receipt-card width` and
`receipt-card height`, described here and drawn by nothing yet.

**Proven from both sides** on a planted field in a throwaway pen: 39 behaviors, every refusal
planted and then lifted, and three mutations asserted to bite.

Admission refuses before durable state changes when a required field is empty, text is non-ASCII, a ceiling is exceeded, the schema is unknown, the signature fails, `expires_at` is not later than `issued_at`, or `value_unit` omits `-simulated`. A refusal names `field`, `value`, `ceiling`, `unit`, and `reason` where a ceiling applies; other refusals name the field and reason.

## Module residences

| Residence | Owns |
|---|---|
| Kyri | canonical encoding and decoding of `ReceiptOfferFact` |
| Tally | field, amount, fact-count, and frame ceilings |
| Mantra | append-only admission and deterministic replay to `ReceiptState` |
| Linengrow | `ReceiptState -> LinengrowReceipt` |
| Dimeroll | `ReceiptState -> DimerollReceiptIntake` |
| Brushstroke | bounded Receipt Card description from `LinengrowReceipt` |
| Skate | deterministic still frame and accessibility snapshot |
| Brix | the declared build and proof closure; no product state |

Amphora, Comlink, Caravan, Pond, Granary, Mandi, MUR, Lantern, Mycelium, and Cellar enter later milestones. The first whole needs no vessel, wire, capability, payment rail, explanation model, shared ordering, or archive layer.

## Acceptance cases

One dual-product witness runs every case and proves prior durable bytes remain unchanged after every refusal.

1. **Admit and replay.** Encode, verify, append, and replay the fixture. A second replay is byte-identical.
2. **Read as Linengrow.** The projection shows product, recipient, purpose, simulated offered value, value basis, promised return, issue time, expiration, and `offered` status. Raw product bytes stay absent.
3. **Read as Dimeroll.** Intake names the same receipt and source fact, classifies it as an unrecognized offer, and produces zero journal entries.
4. **Describe and render.** Brushstroke stays within 72 by 18 cells. Skate's Still frame and accessibility snapshot carry every deciding Linengrow field in the same reading order.
5. **Expire without erasing.** Replaying at the expiration boundary changes status to `expired`; the admitted fact and elder receipt remain reachable.
6. **Refuse incomplete input.** Removing each required field refuses by that field's name before append.
7. **Refuse false authority.** A changed digest or signature refuses before either product projects.
8. **Refuse a braided implementation.** The build fails if Linengrow imports `DimerollReceiptIntake` or Dimeroll imports `LinengrowReceipt`.


**A guard now holds the falsifier's code half** (`20260917.090914`). The falsifier above and acceptance
case 8 say one thing about code -- either product importing the other's projection type makes this
contract wrong -- and until this stamp that sentence stood on no instrument. Measured over 175
tracked Rye sources, `linengrow/` and `dimeroll/` named each other zero times, so the boundary read
clean and nothing was holding it clean. A boundary is cheap to hold before the code is written, and
this contract is accepted for implementation, which is exactly when one saved afternoon buys a
braid.
[`../../../tools/r/receipt_product_braid_witness.rish`](../../../tools/r/receipt_product_braid_witness.rish)
over [`../../../tools/fixtures/r/receipt_product_braid_scan.sh`](../../../tools/fixtures/r/receipt_product_braid_scan.sh)
reads the product pair off this page's own residence table -- so renaming a type here moves the
guard with it -- and holds two classes at **zero**: an `@import` reaching the peer room, and the
peer's projection type standing in a product room's source outside a comment and outside a string
literal.

**Role decides, never room.** Two readings ride beside those, each reported: `cross_mention` counts
the peer type named inside a comment or a string, since a module head explaining the boundary it
keeps is doing the right thing; and `peer_word` counts the peer room's own word standing in code, a
tell only a reader can judge. **What it reaches** is one direction of case 8 over the two product
rooms, leaving every other room alone, because Mantra is shared on purpose. A braid routed through
a third module that imports both and hands each a view of the other wants a call graph rather than
a scan, and case 8's own build condition closes that half when the build lands. **Proven from both
sides** on real git repositories in a throwaway pen: 47 behaviors, every refusal planted and then
lifted, and five mutations asserted to bite.

## What stands built, measured

**Reviewed `20260917.234833` against the tree rather than against this page.** Every guard claim
above held on the run: the ceiling guard reads `sites=14 named=14 unnamed_ceiling=0
value_disagrees=0 borrowed_rows=4 row_unenforced=2` with 39 control legs, the braid guard reads
`cross_import=0 cross_type=0` with 47, and `linengrow/` and `dimeroll/` hold exactly the **175**
tracked Rye sources the braid paragraph names. Nothing on this page needed a correction.

**What a reader could not take from it is how far the first whole stands from its own edge.** Of
the four types this contract publishes:

| Public type | Declared in tracked Rye |
|---|---:|
| `ReceiptOfferFact` | **3** sources |
| `ReceiptState` | **1** source |
| `LinengrowReceipt` | **0** |
| `DimerollReceiptIntake` | **1** source (`20260918.043437`) |

**So `cross_type=0` was a true reading over a population where neither projection type had been
written, and it stays true now that one has.** The braid guard is right and its own header says
why -- a boundary is cheap to hold before the code exists, which is the whole reason it was built
early, and the same boundary proved cheap to hold once one side arrived: `dimeroll/` grew from
five files to eight and `cross_type` stayed zero.

**Mantra's side had begun and Dimeroll's now has too, and neither has met the other yet.**
`mantra/src/` carries `receipt_offer.rye`, its two witnesses, and the two Tally bound modules.
`dimeroll/` carries `receipt_offer.rye` and `receipt_offer_witness.rye`
(`20260918.043437`), proving `DimerollReceiptIntake`'s own mapping -- unrecognized offer, zero
journal entries, before and after expiry -- against an `OfferSnapshot` built from the contract's
own fixture values. It has not yet been chained through Mantra's actual `Log.append` and
`Log.replay`, because Zig's own module boundary refuses an `@import` that reaches outside its root
file's directory (REDS %589, proven on metal `20260917` in `rye/tests/mantra_weave_test.rye`), and
`dimeroll/receipt_offer.rye` says so in its own module head. The dual-product witness this
milestone's acceptance still wants is what closes that last mile, once Linengrow's own side and a
carrier for the room boundary both stand.

**A NAMING COLLISION WAITS AT THE FIRST IMPLEMENTATION STEP, and it is the finding worth carrying
off this page.** `linengrow/` already holds `receipt.rye`, `receipt_core.rye` and
`receipt_verify_guest.rye`, and those are **SLC-L1's verifiable receipt** -- sign, append, fold,
verify -- an elder and unrelated subject. A hand implementing `LinengrowReceipt` reaches for exactly
those names and lands in another milestone's module. Which name this product's projection takes is a
product-meaning decision, so it waits under the closing clause below with the other two.

**Of the eight acceptance cases, none yet carries its own witness.** The two rostered guards hold
the falsifier's code half and this page's ceiling declarations -- real work, and a different job
from proving a case. This page already says a case becomes checkable only when its witness passes;
the count is written here so a reader need not infer it.

## Completion and review edge

The milestone lands only when the same admitted fixture passes all eight cases on metal and the falsifier stays false. Palette values, signature composition, and richer motion remain at DJINN's design gate. Real identity, data, value, keys, payment, and deployment remain at their custody gates.

Keaton accepted this contract for bounded synthetic implementation on `20260913`. Material changes
to product meaning, module residence, design authority, or custody return to him. Acceptance opens
the build; it does not claim the whole product runs. Each case above becomes checkable only when its
own witness passes, and the milestone name waits for the dual-product witness.
