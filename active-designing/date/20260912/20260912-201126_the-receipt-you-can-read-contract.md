# The Receipt You Can Read -- product contract

**Stamp:** `20260912.201126` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Accepted for bounded synthetic implementation on Keaton's `20260913` word -- **mixed room**: the contract edge and landed Tally/Mantra rung are checkable; the remaining public types and acceptance cases stay proposed until their witnesses pass
**Milestone:** The receipt you can read
**Revised:** `20260918.105100` -- closes the last mile named `20260918.100854`. Two renamed
symlinks beside `mantra/src/receipt_offer_snapshot.rye`, `mantra/src/dimeroll_receipt_offer.rye`
and `mantra/src/linengrow_receipt_offer.rye`, cross Zig's module boundary into each product room --
each target module imports nothing beside `std`, so the symlink resolves cleanly (REDS %589's
reading 2). The carrier reads one replayed `ReceiptState` into each product's own `OfferSnapshot`.
`mantra/src/receipt_offer_snapshot_witness.rye` under
`tools/m/mantra_receipt_offer_snapshot_witness.rish` proves acceptance cases 1 through 3 chained
together from one `Log.append` and one `Log.replay`, plus case 5's expiration half; the product
braid guard, which reads past Mantra entirely, stays `verdict=unbraided`. No elder row, number, or
acceptance case was removed; this is the first commit to this page that adds a new checkable case.
**Revised:** `20260918.100854` -- tightens admission, on Keaton's `20260918` word. The four
borrowed rows named `20260916.065731` are replaced by their own derived numbers:
`product_digest` moves from a 96-byte ceiling to an exact 64-byte length (SHA3-256 written in
hex), `value_unit` moves to 32, `return_kind` to 48, `signature` to 192. Every borrowed number
was a ceiling wider than what a real value needs, so this narrows what the product accepts --
the one row this page's own text flagged as the change to watch for
(`active-designing/20260918-000154_three-numbers-and-a-name.md`). The five identifiers the
`each identifier` row governs are enumerated by name. `mantra/src/tally_receipt_offer_bounds.rye`,
`mantra/src/tally_receipt_refusal.rye` (a new `wrong_length` reason and `exact_length_refusal`
helper), and `mantra/src/receipt_offer.rye` carry the change; `product_digest` left the
`identifiers` array it travelled inside and reads its own exact-length check.
[`../../../tools/r/receipt_contract_ceiling_witness.rish`](../../../tools/r/receipt_contract_ceiling_witness.rish)
reads `verdict=agree` against this table.
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
| each identifier (receipt_id, holder_id, recipient_id, product_id, signer_id) | 96 | ASCII bytes |
| purpose | 80 | ASCII bytes |
| value basis | 120 | ASCII bytes |
| value amount | 9,000,000,000 | smallest declared units |
| product digest | 64 | ASCII bytes, exact length (SHA3-256, hex) |
| value unit | 32 | ASCII bytes |
| return kind | 48 | ASCII bytes |
| signature | 192 | ASCII bytes |
| receipt facts in this replay | 1 | fact |
| receipt-card width | 72 | cells |
| receipt-card height | 18 | rows |

**Four rows were borrowed rather than derived, and now carry their own numbers**
(`20260916.065731`, tightened `20260918.100854`). The contract first declared eight ceilings while
`ReceiptOfferFact` publishes fifteen fields, so admission reached for the nearest declared number:
`product_digest`, `value_unit`, `return_kind`, and `signature` were each refused at the 96 this
table declares for *each identifier*, and `product_digest` travelled inside an array literally
named `identifiers`. Naming the borrow first, on `20260916`, let a reader find `ceiling=96` on a
refusal line inside this table. Deriving each field's own number, on `20260918`, is what makes that
number honest rather than merely findable.

**Each of the four now carries the shape its own field wants.** `product_digest` is a 256-bit
digest written in hex -- SHA3-256 here, and any 256-bit scheme reads the same 64 characters -- so
its bound is an **exact length** rather than a ceiling: `mantra/src/tally_receipt_offer_bounds.rye`
checks `value.len != product_digest_len` rather than `value.len > ceiling`, and a too-short digest
refuses exactly as a too-long one does. This is the one row that **tightens** admission: the
65-to-96-byte range a malformed digest could pass through before `20260918` now refuses at the
door. `value_unit` carries a unit name plus the mandatory `-simulated` suffix and measures **18**
in the fixture against its new ceiling of **32**; `return_kind` measures **14** against **48**.
`signature` measures **20** as a fixture signature against a ceiling of **192**, chosen to hold an
Ed25519 signature in either base64 (88) or hex (128) encoding with room for a scheme prefix --
**not** a real post-quantum signature, which a detached, digest-referenced shape must carry
instead of a wider number
([`../../20260918-000154_three-numbers-and-a-name.md`](../../20260918-000154_three-numbers-and-a-name.md)
names the arithmetic and the shape question this leaves for a second milestone).

**A guard now asks the question that found them** (`20260917.024441`). `%767` recorded in its own
second field that nothing in this tree asked whether every field a contract publishes carries a
ceiling that contract declares, so the borrow was visible only on a refusal line at runtime.
[`../../../tools/r/receipt_contract_ceiling_witness.rish`](../../../tools/r/receipt_contract_ceiling_witness.rish)
over [`../../../tools/fixtures/r/receipt_contract_ceiling_scan.sh`](../../../tools/fixtures/r/receipt_contract_ceiling_scan.sh)
reads this table, the `max_*` constants of `mantra/src/tally_receipt_offer_bounds.rye`, and every
ceiling site in `mantra/src/receipt_offer.rye`, and holds two classes at **zero**: a field refused at
a ceiling no row names, and a row stating a number other than the one the code refuses at. It reads
**14 sites, all named**.

**The hole the earlier repair reported is closed for the field it named.** The `each identifier`
row now names its five members by hand -- `receipt_id`, `holder_id`, `recipient_id`, `product_id`,
`signer_id` -- and `product_digest` left the `identifiers` array in
`mantra/src/receipt_offer.rye` it travelled inside, reading its own exact-length check instead.
`borrowed_rows` now reads **0**. The scan's own `population_undeclared` reading stays **1**: it
counts a population row structurally, by whether every field leaning on it names its own row, and
does not parse the parenthetical this table now writes -- so a future population row would meet the
same reported (never gated) reading even when its members are written in plain English right beside
it. `row_unenforced` still reads **2** -- `receipt-card width` and `receipt-card height`, described
here and drawn by nothing yet.

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

**Superseded by the `20260918.100854` revision above.** The `borrowed_rows=4` reading is testimony
of that hour; the ceiling guard reads `borrowed_rows=0` from the tightening onward, and the table
this section cites is the one above rather than the one this paragraph describes.

**What a reader could not take from it is how far the first whole stands from its own edge.** Of
the four types this contract publishes:

| Public type | Declared in tracked Rye |
|---|---:|
| `ReceiptOfferFact` | **4** sources (`20260918.105100`) |
| `ReceiptState` | **4** sources (`20260918.105100`) |
| `LinengrowReceipt` | **2** sources |
| `DimerollReceiptIntake` | **2** sources (`20260918.105100`) |

The count is a word-presence reading across `mantra/src/`, `linengrow/`, and `dimeroll/` -- a
module head naming the boundary it keeps counts alongside a declaration, since both are the same
grep and this page has read it that way since `20260916`. Run it fresh rather than trusting the
table:

```sh
grep -rl '\bReceiptState\b' --include='*.rye' mantra/src linengrow dimeroll | sort -u
```

**So `cross_type=0` was a true reading over a population where neither projection type had been
written, and it stays true now that one has.** The braid guard is right and its own header says
why -- a boundary is cheap to hold before the code exists, which is the whole reason it was built
early, and the same boundary proved cheap to hold once one side arrived: `dimeroll/` grew from
five files to eight and `cross_type` stayed zero.

**Mantra's side had begun, and now both projections have too -- and neither has met Mantra yet.**
`mantra/src/` carries `receipt_offer.rye`, its two witnesses, and the two Tally bound modules.
`dimeroll/` carries `receipt_offer.rye` and `receipt_offer_witness.rye` (`20260918.043437`),
proving `DimerollReceiptIntake`'s own mapping -- unrecognized offer, zero journal entries, before
and after expiry -- against an `OfferSnapshot` built from the contract's own fixture values.
`linengrow/receipt_offer.rye` and `receipt_offer_witness.rye` (`20260918.100854`) prove
`LinengrowReceipt`'s own mapping the same way -- product, recipient, purpose, offered value, value
basis, promised return, issue and expiration times, and status, before and after expiry -- and
carry the naming decision below: the new module is `receipt_offer.rye`, the type stays
`LinengrowReceipt`.

**The last mile is closed, `20260918.105100`.** `mantra/src/receipt_offer_snapshot.rye` is the
carrier both projection modules named as still missing: two renamed symlinks placed beside it,
`mantra/src/dimeroll_receipt_offer.rye` and `mantra/src/linengrow_receipt_offer.rye`, resolve
cleanly because REDS %589's own reading 2 applies -- each target module imports nothing beside
`std`, so the symlink needs no further sibling resolution. The carrier reads one replayed
`ReceiptState` and builds each product's own `OfferSnapshot`, writing no field either product does
not already declare. `mantra/src/receipt_offer_snapshot_witness.rye`
(`tools/m/mantra_receipt_offer_snapshot_witness.rish`) proves acceptance cases 1 through 3 chained
together from **one** `Log.append` and **one** `Log.replay` -- Linengrow's reading and Dimeroll's
reading of the very same replay, rather than three fixtures that merely happen to agree -- both
before and after the expiration boundary (case 5's chained half). The product braid guard runs
alongside it and reads `verdict=unbraided` still, because the carrier lives in Mantra, the one room
that guard reads past by its own header's own words: "Mantra is shared on purpose."

**The naming collision named below is resolved, on Keaton's `20260918` word.** `linengrow/` already
held `receipt.rye`, `receipt_core.rye` and `receipt_verify_guest.rye` -- **SLC-L1's verifiable
receipt**, sign, append, fold, verify, an elder and unrelated subject -- and a hand implementing
this milestone's projection could have reached for exactly those names. It instead reaches for
`linengrow/receipt_offer.rye`, echoing `mantra/src/receipt_offer.rye` across the two rooms the
same two words already name, and the elder three files stand untouched
([`../../20260918-000154_three-numbers-and-a-name.md`](../../20260918-000154_three-numbers-and-a-name.md)
Three). `LinengrowReceipt` keeps the contract's own word rather than moving to
`LinengrowReceiptOffer`, since the braid guard reads the type off this page's residence table and
nothing elsewhere hunts for the name.

**Three of the eight acceptance cases now carry their own witness, `20260918.105100`.**
`tools/m/mantra_receipt_offer_snapshot_witness.rish` is case 1 (admit and replay), case 2
(read as Linengrow), and case 3 (read as Dimeroll), each proven against the same one replay
rather than separately. Case 5's expiration half rides along the same chain. Cases 4, 6, 7, and 8
still want their own: 4 waits on Brushstroke and Skate, which this milestone has not begun; 6 and
7 want a refusal-side witness reading the same chain rather than the admission module's own
refusal tests, which prove the field but not yet the chain; 8 is the falsifier's code half, already
held by the product braid guard. The two earlier rostered guards -- the ceiling guard and the braid
guard -- hold ground no acceptance case names, and stay real work of a different kind from proving
a case.

## Completion and review edge

The milestone lands only when the same admitted fixture passes all eight cases on metal and the falsifier stays false. Palette values, signature composition, and richer motion remain at DJINN's design gate. Real identity, data, value, keys, payment, and deployment remain at their custody gates.

Keaton accepted this contract for bounded synthetic implementation on `20260913`. Material changes
to product meaning, module residence, design authority, or custody return to him. Acceptance opens
the build; it does not claim the whole product runs. Each case above becomes checkable only when its
own witness passes, and the milestone name waits for the dual-product witness.
