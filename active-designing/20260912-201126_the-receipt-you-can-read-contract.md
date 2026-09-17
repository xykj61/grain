# The Receipt You Can Read -- product contract

**Stamp:** `20260912.201126` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Accepted for bounded synthetic implementation on Keaton's `20260913` word -- **mixed room**: the contract edge and landed Tally/Mantra rung are checkable; the remaining public types and acceptance cases stay proposed until their witnesses pass
**Milestone:** The receipt you can read
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
[`../tools/r/receipt_contract_ceiling_witness.rish`](../tools/r/receipt_contract_ceiling_witness.rish)
over [`../tools/fixtures/r/receipt_contract_ceiling_scan.sh`](../tools/fixtures/r/receipt_contract_ceiling_scan.sh)
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

## Completion and review edge

The milestone lands only when the same admitted fixture passes all eight cases on metal and the falsifier stays false. Palette values, signature composition, and richer motion remain at DJINN's design gate. Real identity, data, value, keys, payment, and deployment remain at their custody gates.

Keaton accepted this contract for bounded synthetic implementation on `20260913`. Material changes
to product meaning, module residence, design authority, or custody return to him. Acceptance opens
the build; it does not claim the whole product runs. Each case above becomes checkable only when its
own witness passes, and the milestone name waits for the dual-product witness.
