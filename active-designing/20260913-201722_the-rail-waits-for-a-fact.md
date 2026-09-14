# The Rail Waits for a Fact

**Stamp:** `20260913.201722` (EDT)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed handoff -- **Room:** mixed; the dependency reading is checkable from living contracts, while the future component boundary remains design
**Lane:** Diffuser -- Brushstroke and Skate product surface
**Falsifier:** If the accepted first-receipt contract gains grant and revoke facts, or a landed module already supplies them, the sequencing conclusion below is wrong and the Consent Rail may begin from that evidence.

## Finding

**Observation:** The living product ladder places the Receipt Card in *The receipt you can read* and the Consent Rail in *The consent you can change*. The latter requires one purpose-bound grant, one revoke fact, Caravan capability checking, Pond enclosure, and preserved Mantra history ([product itinerary](../construction/LINENGROW_ITINERARY.md)).

**Observation:** The accepted first-receipt contract exposes `ReceiptOfferFact`, `ReceiptState`, `LinengrowReceipt`, and `DimerollReceiptIntake`. Its only receipt status values are `offered` and `expired`; it defines neither a grant nor a revoke action ([receipt contract](20260912-201126_the-receipt-you-can-read-contract.md)).

**Observation:** Skate now owns a fixed Receipt Card with a **72-cell width**, **18-row height**, and **12 rendered rows**. Its accessibility reader derives text from the same stored cells ([ReceiptCard.swift](../skate/Sources/SkateCore/ReceiptCard.swift)).

**Inference:** A working Consent Rail built from today's public types would have to invent at least one of three things: authority, revocation meaning, or mutable product state. Any one would move a product boundary before its owning modules have supplied the fact.

**Conclusion:** Diffuser should keep the Receipt Card whole and leave Consent Rail behavior unimplemented until the grant/revoke seam lands. The honest surface for an offer today is its visible expiration and `offered | expired` status, already carried by the card.

## The buildable handoff

Patchouli can make the next surface buildable by landing one immutable grant fact and one immutable revoke fact through Mantra, with Tally bounds stated before append. Caravan can then expose a capability decision, and Pond can expose whether the action runs inside the intended enclosure. The surface needs values from those modules; it does not need their private storage types.

When those inputs exist, Diffuser can implement one description with these fields:

```text
ConsentRailDescription
  receipt_id
  purpose
  recipient_id
  granted_at
  expires_at
  revoked_at: absent | stamp
  capability: allowed | refused
  action: revoke | none
```

The field list is a proposal, not a public type ruling. The product owners may rename or reshape it while preserving the deciding meanings.

## Bounds for the first implementation

These are proposed ceilings for the first witnessed rail, with confidence stated against the evidence available on `20260913`.

| Reading | Proposed ceiling | Unit | Horizon | Assumptions | Confidence |
|---|---:|---|---|---|---|
| width | 72 | cells | first Consent Rail implementation | shared alignment with the landed Receipt Card | high |
| height | 6 | rows | first Consent Rail implementation | one purpose, one party, one expiration, one status, one action | medium |
| settle duration | 1,000 | milliseconds | every state transition in the first implementation | living design-system ceiling remains accepted | high |
| response pulses | 4 | pulses per admitted action | first implementation | response remains local and changes no product state | high |
| response radius | 4 | cells from the focused action | first implementation | the rail remains a text grid rather than a free canvas | low |
| response lifetime | 400 | milliseconds | first implementation | one brief confirmation remains perceivable without delaying the state | low |
| focus targets | 1 | target when active | first implementation | `revoke` is the only action; expired or revoked rails have none | medium |

**Falsifier for the six-row ceiling:** Render the accepted grant fixture with every deciding field and the revoke label. If it needs a seventh nonempty row at **72 cells**, raise the declared bound before allocation rather than abbreviating meaning.

**Falsifier for the four-cell radius and 400-millisecond lifetime:** A keyboard and reduced-motion review must show the response without relying on spatial motion or elapsed time. If either reading loses confirmation, remove Respond from the first rail; the complete Still state remains.

## Witness contract

The rail becomes checkable only when one native Skate test can consume the landed projection and prove all of these statements:

1. Still contains purpose, recipient, expiration, authorization status, and the available action in one fixed reading order.
2. Settle ends on bytes identical to Still within **1,000 milliseconds** of its admitted start time.
3. Reduced motion, renderer loss, and a hidden document select Still before an animated frame is published.
4. Respond admits at most **4 pulses**, each within the declared radius and lifetime, and leaves the product-state digest unchanged.
5. Keyboard order equals accessibility order and contains exactly the actionable targets present in Still.
6. A revoke refusal leaves the elder complete frame and Mantra bytes unchanged.
7. An admitted revoke removes the action, says `revoked` in text, and keeps the grant and revoke facts reachable.

**Projection:** Once the four upstream inputs exist, the first implementation should fit one Swift source, one Swift test source, and one README paragraph. This is a scope forecast, not an effort estimate. It assumes the landed projection already gives all eight description fields; any adapter that interprets private Mantra or Caravan state falsifies that assumption.

## Handoff

**Buildable now:** keep proving the existing Receipt Card on compatible Swift/macOS metal and connect it only to the accepted `LinengrowReceipt` seam.

**Not buildable now:** grant, revoke, capability, enclosure, and Consent Rail action behavior. Those meanings belong to Patchouli's Mantra/Tally work and the later Caravan/Pond milestone before they belong to Skate.

The rail is not late. It is waiting at the exact boundary that keeps a visible control from promising authority the product does not yet possess.
