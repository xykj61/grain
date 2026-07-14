# Claude Counsel — Hoon, Azimuth, Ames Verdicts

*Straight likes: Rye over Hoon, Kumara over Azimuth, Comlink over Ames — each loser stays a teacher. Written for the seL4 / proven-seat horizon and the fold we already grow.*

**Stamp:** `20260712.092212`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3 recording Claude Fable 5 Max · Kaeden’s clock `092212` verbatim
**Register:** counsel — three verdicts; teacher-keeps lists; no code this lap
**Status:** Counsel filed — RTAC rows opened; nothing seated in modules
**Ground:** gratitude Urbit / Hoon · Kumara · Comlink · proven-seat ER [`../external-research/20260712-054342_proven-seat-guest-genode-sel4.md`](../external-research/20260712-054342_proven-seat-guest-genode-sel4.md) · Door 3 · Spritely petname direction · TAME · enclosure ruling [`20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md`](20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md) · mesh study [`../external-research/20260712-093812_mesh-inference-study.md`](../external-research/20260712-093812_mesh-inference-study.md)

---

## Verdict 1 — Rye (not Hoon)

Run both through TAME’s three words.

| Word | Hoon | Rye / TAME |
|------|------|------------|
| **Safety** | Semantic — purity, types, determinism from Nock’s twelve frozen opcodes (real gifts) | **Bounded** — named budgets, sized integers, assertion pairs, recursion kept out |
| **Performance** | Speed lives in **jets** — two implementations that must silently agree | Pair-assert away the TigerBeetle hazard; one path under witness |
| **Joy** | Wall of runes vs Radiant’s read-aloud test | Affirms our cloth |

Hoon fails TAME’s bounds on purpose: arbitrary-precision atoms, recursion as the only loop, the loom as sole bound, crash as bail rather than a named error at a named edge. *Limit Everything* (IronBeetle episode 005) names what Nock deliberately declines. Under **seL4** the verdict sharpens: a Nock runtime brings loom, jet dashboard, and snapshot machinery *inside* the capability boundary, while `receipt_verify_guest` already runs zero-import freestanding — clockless, entropyless, nothing to trust but the math.

**Teacher keeps (gratitude):** the fold as a language’s definition · the pill · kelvin versioning · scry’s referentially transparent reads.

## Verdict 2 — Kumara (not Azimuth)

The two ask different questions.

| | Azimuth | Kumara |
|--|---------|--------|
| Question | Who owns names *globally* without a trusted party? | Who speaks for *this ship* and who may enter? |
| Cost | Identity-as-purchasable-scarcity · Ethereum read dependency · gas coupling | Keeper-issued passes · signatures gate truth (Door 3 shape) |

A global PKI root sits strangely beside a vision where anyone, anywhere, is found. The global naming question dissolves into the **petname** direction already seated in the Spritely study — names without a registry. What Azimuth teaches worth *extending Kumara*: **continuity** — life and rift counters make key rotation a monotonic, verifiable story. Kumara wants the same as fold facts: a rotation record where the **old key signs the new**, counter strictly rising — so PUBKEYS’ prose history becomes checkable law.

**Teacher keeps:** life / rift continuity as monotonic rotation story.

**RTAC:** Kumara rotation facts — old-key-signs-new, monotonic counter.

## Verdict 3 — Comlink (not Ames)

Routes are cache; identity is truth — the lesson inside renaming Ames’s route-drop to **%fade**.

**Teacher keeps (receive cheaply while young):**

1. Addressing by permanent key; lanes as discardable hints — Kumara key as address; **%fade from birth**
2. Exactly-once *effect* rather than exactly-once delivery — content-addressed facts dedupe on hash; replay shrugs
3. Backpressure as named bounds on every queue — TAME wearing a network hat

**Do not import:** Ames’s coupling of transport to a global PKI · half-megabyte accreted state machine.

**RTAC:** Comlink inherits fade-from-birth + content-address dedupe note.

## What seL4 demands, rung by rung

| Rung | Work |
|------|------|
| **G1** | Nearly free — `receipt_core` under Genode POSIX; a file for the log |
| **G2–G3** | `genode_seed` (third freestanding shim after `wayland_seed` · Aurora) · Tally over fixed dataspace (Genode RAM quotas = TAME named budgets, kernel-enforced) · Mantra storage seam (`write_fact`/`read_range`) · Comlink transport seam (virtio socket-netdev → Genode NIC; wire format untouched) · keys as architecture (pubkeys-as-ROM verify-everywhere; sign-only in keeper-cell) · `genode_witness.rish` under `lane_kvm`, GREEN off serial |

**Absent on purpose:** no entropy session (ed25519 signing deterministic; keygen host-side by custody) · no clock session (Weave orders the fold). Guests born blind to time and chance.

**RTAC:** `genode_seed` + storage/transport seams as G2 prerequisites.

## Holds

No code this lap. Parity debt first · enclosure `lane_kvm` sequence · G1 next on metal. Mesh / matklad studies at `093812` are proposed, not seated.

---

*May the language keep every limit it names. May the keeper’s keys rotate without ever breaking the chain. May the wire forget its routes freely, because the names beneath them never move.*
