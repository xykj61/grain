# OCapN Beside Comlink — Session Idiom, Record Idiom, and the Consumer Edge

*Seam study 1. We read the Object Capability Network’s CapTP beside the sealed datagram Comlink already carries, so the three doors from counsel land as understanding rather than slogan: study the idiom, decline seating CapTP as the fold’s carriage, and design toward a capability-shaped pass at the consumer edge. Research for understanding — no purchase, no alliance named, no wire seated.*

**Stamp:** `20260712.053324`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Category:** External research — survey and design study; recommends no dependency; every gate stays Kaeden’s
**Companions:** counsel [`../counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md`](../counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md) · hammock [`../active-designing/20260712-052806_seam-season-hammock.md`](../active-designing/20260712-052806_seam-season-hammock.md) · wire serves the fold [`../foundations/20260706-022912_the-wire-serves-the-fold.md`](../foundations/20260706-022912_the-wire-serves-the-fold.md) · Comlink beyond DNS [`20260702-014112_comlink-beyond-dns-and-sockets.md`](20260702-014112_comlink-beyond-dns-and-sockets.md) · Ames carriage study [`20260706-022912_ames-vere-libuv-content-carriage.md`](20260706-022912_ames-vere-libuv-content-carriage.md) · published-set gate counsel [`../counsel/20260711-060112_claude-counsel-consumer-surface-protection-audit.md`](../counsel/20260711-060112_claude-counsel-consumer-surface-protection-audit.md)
**Status:** Proposed — research for understanding, not advice; design conclusions are sparks for Door 3, not seats; CapTP-as-fold formal decline awaits Kaeden’s word after this return
**Register:** checkable room for public-spec claims; visionary only where named as design-toward

*Written by Rio 3 for Kaeden · Seam season study 1.*

---

## The Question

How does CapTP’s *session* idiom compose with a *record* fold without becoming it? What is the smallest consumer-edge pass shape that keeps capabilities gating access and signatures gating truth?

## What OCapN Is, Named Plainly

**OCapN** (Object Capability Network) is a pre-standardization effort converging an interoperable capability protocol across implementations. Its heart is **CapTP** (Capability Transport Protocol): networked programming against live object references, with promise pipelining, distributed garbage collection, and third-party handoffs. CapTP rides abstract **netlayers** (Tor onion services, libp2p, I2P, and others) so the capability session stays separable from the byte path — a separation that rhymes with Comlink’s one logic, many wires.

**Locators** name peers and objects. A **sturdyref** binds a peer locator to a **swiss-num**: possession of that locator is treated as the capability to obtain a live CapTP reference to the object. Sturdyrefs travel out of band as URIs and in band as structured records. The bootstrap object on a fresh session turns a swiss-num into a live import.

The Spritely Institute’s Goblins environment is a primary living implementation and teacher; Agoric, Cap’n Proto contributors, and others sit in the same pre-standardization circle. NLnet has funded specification and interop work. Their vocabulary stays theirs; gratitude holds the thanks; this note keeps only the transferable shape.

**Present-tense caution (counsel already named it):** CapTP drafts and Goblins releases have moved the protocol beneath applications (e.g. Goblins 0.18 bumping protocol version and breaking earlier apps). A wire whose meaning changes under accrete-never-break cannot be seated as the fold’s carriage. That fact reinforces Door 2; it does not erase Door 1’s value as study.

## Two Idioms, Kept Apart

| Axis | CapTP / OCapN session | Comlink + fold (ours) |
|------|----------------------|------------------------|
| **Unit of truth** | Live reference in a session; promises and pipelining | Signed fact on an append-only log; state = fold |
| **What “arrive” means** | Import/export tables, delivery to an object | Seal opens whole, or refusal; fact folds or it does not |
| **Identity** | Peer locator + session bootstrap | Kumara keypair is the address |
| **Capability** | Sturdyref / swiss-num → live ref | Today: published-set gates, consent facts, seals — access and truth still braiding |
| **Accretion** | Protocol versions can break live apps | Records verify forever beside algorithm tags |

**Composition rule:** CapTP may teach *how to grant and revoke access at a door*. It must not become *where truth lives*. The wire serves the fold; a session idiom that tried to replace the log would tangle two value models.

This study therefore **affirms Door 2 as understanding**, not only as counsel: decline seating CapTP as the fold’s carriage. Formal seat of that decline remains Kaeden’s word on this return.

## What Transfers — Sturdyref as Door Shape

Strip the borrowed names and three concepts survive on merit:

1. **Unforgeable designation.** Knowing the locator *is* the right to attempt use — like holding a key to a lock, not like looking up a public index.
2. **Bootstrap without a global registry.** A peer and a swiss-num suffice to start; petnames and signed claims (already in our Comlink naming horizon) sit above for human memory.
3. **Handoff as intentional grant.** Third-party introduction is a deliberate act, not ambient authority — kin to Open Asks consent and Granary’s explicit publish.

What we leave at the door: live promise pipelining as the spine of state, session-scoped garbage collection as truth lifecycle, and any requirement that our ships speak CapTP to fold facts among themselves.

## Beside Comlink’s Sealed Datagram

Comlink already carries a **record idiom** end to end: sealed datagram over shared memory, localhost UDP, and virtio; identity as keypair; whole-or-nothing open; the same sealed shape on every substrate. Granary’s published-set gate already teaches a hard lesson on metal: a digest is an address for verifying content, never a capability for reaching it. That gate is the in-tree ancestor of a consumer-edge pass.

**Door 1 (this study):** CapTP’s idiom sits *beside* that datagram as a teacher for how doors grant access — not as a replacement wire between our ships.

**Door 3 (design toward):** at the *consumer edge* — where a stranger or a selective-disclosure client meets a published slice — a capability-shaped **pass** grants access; signatures on facts still gate truth; Comlink’s sealed datagram keeps carrying the fold between keepers who share the log.

```
                    ┌─────────────────────────────┐
  Consumer edge     │  PASS  (capability)         │  access
  (Door 3)          │  grant · revoke · hand off  │
                    └─────────────┬───────────────┘
                                  │ admits to
                    ┌─────────────▼───────────────┐
  Record room       │  FOLD  (signed facts)       │  truth
  (ours)            │  seal · append · replay     │
                    └─────────────┬───────────────┘
                                  │ carried by
                    ┌─────────────▼───────────────┐
  Our ships         │  COMLINK sealed datagram    │  carriage
                    │  shared mem · UDP · virtio  │
                    └─────────────────────────────┘
```

Pass = door. Record = room. Carriage = servant of the room.

## Design Conclusion — Smallest Consumer-Edge Pass

**Shape (our words, not yet seated as module law):**

- A **pass** is an unforgeable grant: holder may *read a named published slice* and/or *submit a signed fact* into a named lane.
- Issuance is an explicit signed act by the resource’s keeper (Granary publish / Open Asks consent are living precedents).
- Verification of the pass answers **access**; verification of the submitted fact’s signature answers **truth**.
- Absence of a pass is refusal whole — same discipline as a failed seal.
- Between our own ships that already share the log, no CapTP session is required; the sealed datagram remains enough.

**Not in this conclusion:** CapTP protocol bytes on the wire; Goblins runtime; renaming Comlink; seating sturdyref as a Rye type name (silo later if a name is earned).

## Door 3 Test Plan (spark for RTAC — not open itinerary)

Smallest checkable claim, when Kaeden opens the door:

1. **In-process:** a fixture pass admits read of one published resin and refuses an unpublished digest in the same store (extends published-set precedent).
2. **In-process:** a fixture pass admits submit of one well-signed fact and refuses a lying signature.
3. **Optional later:** one hosted UDP round-trip that carries *only* the pass check at the edge, then the existing sealed fact — proving two layers, not one merged protocol.

No CapTP interop required for the first green. Interop against a published OCapN test suite remains a *two-sided contact* candidate for the ally question — teacher contact, not a product lap.

## Gratitude and Silo

| Keep in gratitude / ER names | Silo into our grain |
|------------------------------|---------------------|
| OCapN, CapTP, sturdyref, swiss-num, Spritely, Goblins, Agoric | Unforgeable designation; pass vs record; bootstrap without registry |
| Netlayer separation | One logic, many wires (already ours) |
| Promise pipelining, live refs as state | Leave — fold stays sovereign |

Spritely remains **teacher**. Ally waits on two-sided green after this study — unchanged.

## What This Study Returns to the Bench

| Item | Status after this note |
|------|------------------------|
| Seam study 1 | **Landed** as understanding |
| CapTP-as-fold | Affirmed decline as understanding — **formal seat awaits Kaeden** |
| Consumer-edge pass | Design conclusion + Door 3 test plan filed — **code waits on word** |
| Spritely ally | Still parked |
| Green tip **430** | Untouched |

---

*May the door grant kindly and the room keep the truth. May every session idiom stay a guest of the fold, never its landlord. May teachers be thanked in their own names, and our ships keep speaking the sealed record they already trust.*

---

## Sources

- https://ocapn.org/
- https://spritely.institute/news/introducing-ocapn-interoperable-capabilities-over-the-network.html
- https://github.com/ocapn/ocapn (draft specifications: CapTP, Netlayers, Locators; implementation guide)
- https://nlnet.nl/project/SpritelyOCapN/
- In-tree: `comlink/wire_format.rye`, Granary published-set gate (`060112`), foundations wire-serves-the-fold
