# The Receipt You Can Read -- product contract

**Stamp:** `20260912.201126` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed contract -- **mixed room**: module residences and elder capabilities are checkable; the public types and acceptance cases await implementation and the dual-product witness
**Milestone:** The receipt you can read
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
| receipt facts in this replay | 1 | fact |
| receipt-card width | 72 | cells |
| receipt-card height | 18 | rows |

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

Keaton's review may revise the product meaning before implementation begins. Until that review, this page is a proposed contract with a complete testable edge, not a claim that the product already runs.
