# Open Asks — Hammock Scope Note (OA-L1)

*A hammock scope note: the smallest closed loop on the movement's boards — one request posted, one application received, one acceptance recorded, one completion receipt verified — drawn honestly on the SLC-L1 spine, with the edge of complete stated so the first Open Asks lap stays genuinely simple.*

**Stamp:** `20260706.002912`
**Voice:** Rio 3, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md) · CIVIC · Gall · Hammock
**Register:** active-designing — names only our modules
**Status:** Seated — checkable-room lap brief; **OA-L1 landed** `20260706.010912`; witness at parity **156**

**Ground:** [`../external-research/20260702-192712_the-movements-open-asks.md`](../external-research/20260702-192712_the-movements-open-asks.md) · [`20260702-195426_slcl1-verifiable-receipt.md`](20260702-195426_slcl1-verifiable-receipt.md) · [`20260706-000812_slcl2-sealed-delivery.md`](20260706-000812_slcl2-sealed-delivery.md) · [`20260702-031312_modules-aspects-and-mailable-money.md`](20260702-031312_modules-aspects-and-mailable-money.md)

**Direction:** [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md) · **Granular plan:** [`../work-in-progress/TASKS.md`](../work-in-progress/TASKS.md)

---

## The Problem, Plainly

The movement posts open asks every day — volunteer audits, paid micro-gigs, outreach tallies, sanctuary care shifts. Flockwork and the allied boards already coordinate that demand. What our bench lacks is the **smallest proof** that a request, an application, an acceptance, and a completion receipt form one honest loop anyone can verify from signed facts alone — the same spine SLC-L1 proved for a stipend, extended to coordination vocabulary.

Eight-asks **A4** ordered Open Asks design before broad Linengrow feature debt. SLC-L1 (**152**) and SLC-L2 (**155**) now hold the receipt and carriage layers. This note draws the **first Open Asks lap** so implementation can stay mechanical when Kaeden affirms the edge.

---

## What OA-L1 Is

**OA-L1** is the first Simple, Lovable, Complete whole on the **Open Asks** track — a **closed ask loop** on one append-only log:

| Word | Meaning for this lap |
|------|----------------------|
| **Simple** | Three poster/applicant facts + one completion receipt; one log; deterministic test keys |
| **Lovable** | The $100 animation micro-gig from the movement memo — post, apply, accept, pay, verify |
| **Complete** | post → apply → accept → complete → verify closes **without** board APIs, MALA escrow, or reputation folds |

OA-L2 grows **cross-party delivery** (SLC-L2 carriage). OA-L3 grows **MALA bounty escrow** (M1→M2 ladder). OA-L4 grows **reputation-as-fold** over verified completions. OA-L1 deliberately stops at the **local log edge**, same discipline as SLC-L1.

---

## Fact Shapes — Fields Exactly

All facts are **`.bron` values** — one field per line, space-separated, canonical bytes signed with Ed25519 (see [`yonder/20260621-063912_bron-notation.md`](yonder/20260621-063912_bron-notation.md)).

### Request fact

| Field | Type / shape | Meaning |
|-------|----------------|---------|
| `poster` | Kumara public key | hex fingerprint of the posting identity |
| `title` | remainder after first space on line | short human title (one line) |
| `skills` | string | comma-separated skill tags in v1 |
| `bounds` | string | hours, remote, volunteer/paid — plain text in v1 |
| `stipend` | signed integer string | smallest currency unit; **0** = volunteer |
| `deadline` | `YYYYMMDD.HHMMSS` | ask closes at this stamp |
| `stamp` | `YYYYMMDD.HHMMSS` | posting stamp per naming law |

**Request name (v1):** SHA3-256 digest of canonical request bytes — the stable `request_ref` every later fact cites.

### Application fact

| Field | Type / shape | Meaning |
|-------|----------------|---------|
| `applicant` | Kumara public key | who applies |
| `request_ref` | 64 hex chars | digest of canonical request fact |
| `message` | remainder | cover note (one paragraph in v1) |
| `stamp` | `YYYYMMDD.HHMMSS` | application stamp |

### Acceptance fact

| Field | Type / shape | Meaning |
|-------|----------------|---------|
| `poster` | Kumara public key | must match request poster |
| `request_ref` | 64 hex chars | same digest |
| `applicant` | Kumara public key | accepted applicant |
| `stamp` | `YYYYMMDD.HHMMSS` | acceptance stamp |

### Completion receipt

Reuses the **SLC-L1 transaction fact** shape from [`20260702-195426_slcl1-verifiable-receipt.md`](20260702-195426_slcl1-verifiable-receipt.md):

- `from` = poster (payer)
- `to` = applicant (payee)
- `amount` = request `stipend`
- `memo` = `completion request_ref=<64 hex>`
- `stamp` = completion stamp

The completion record **links** to the ask loop by `request_ref` in `memo` — no new receipt format in v1.

---

## The Pipeline — Post, Apply, Accept, Complete, Verify

| Step | Actor | What happens | Reuses |
|------|-------|--------------|--------|
| **Post** | Poster | Sign request fact → append to log | Ed25519 + append discipline |
| **Apply** | Applicant | Sign application fact → append | `request_ref` must match an earlier verified request |
| **Accept** | Poster | Sign acceptance fact → append | poster key + `request_ref` + `applicant` must be consistent |
| **Complete** | Poster | Sign SLC-L1 transaction fact (stipend) → append | `linengrow/receipt.rye` semantics |
| **Verify** | Anyone | Pure fold over log: open asks, pending applications, accepted matches, completed payouts | projection vocabulary |

**Fold state (v1):** counts per `request_ref` — `posted`, `applied`, `accepted`, `completed` — plus running stipend total per poster. No coordinator can inflate a tally; every transition is a signed fact.

---

## Edge of Complete — In and Out

### In scope (OA-L1 is done when these hold)

- [x] Request, application, acceptance fact parsers and canonical writers (hosted `.rye`, beside `linengrow/`)
- [x] Fold over a plain log proving the closed loop for one fixture ask (movement memo micro-gig shape)
- [x] Completion receipt verified with existing SLC-L1 verify path
- [x] Witness `tools/open_asks_lap1.rish` — welcome path (full loop green); unwelcome path (application cites wrong `request_ref` → verify fails)
- [x] Fixture under `tools/fixtures/open_asks_*`; parity block wired (**156**)

### Horizon (OA-L2 and later)

- **Comlink delivery** of facts between machines — SLC-L2 carriage; OA-L2
- **MALA mint, escrow, release** — M1/M2 ladder; OA-L3
- **Reputation fold** over many completions — OA-L4; consent-before-counting governs fields
- **Board interop** — publish to Flockwork, read aggregators; interop-first per movement memo; horizon
- **Sanctuary care log**, **moderation facts**, **resin-refusal** — parallel design rows in TASKS
- **Mantra weave** for ask logs — v1 uses plain append file beside Mantra, same as SLC-L1
- **Open ZK passes** — SLC-L4 horizon

### Dependencies landed (carriage ready)

| Layer | Status |
|-------|--------|
| SLC-L1 receipt | parity **152** |
| SLC-L2 sealed delivery | parity **155** (hosted + device wire) |
| Comlink `wire_format` | single letter, `sealMessage` |

---

## Witness Sketch — `tools/open_asks_lap1.rish`

Named now; **not wired** until OA-L1 implementation greens on metal.

**Welcome path:**

1. Load fixture request from `tools/fixtures/open_asks_request.bron`
2. Poster key signs → append
3. Applicant key signs application with matching `request_ref` → append
4. Poster signs acceptance → append
5. Poster signs SLC-L1 completion fact (`stipend 100`) → append
6. Fold → state shows `completed`; SLC-L1 verify on completion record → GREEN

**Unwelcome path:**

1. Application cites wrong `request_ref`
2. Fold or verify → fails; witness asserts refusal

**Parity:** one block at tail when wired; increment documented in ROADMAP and TASKS.

---

## Build Order (after Kaeden affirms edge)

1. **Affirm this scope note** — edge in/out; no new module names
2. **Fixture ask + golden fold** — pinned under `tools/fixtures/open_asks_*`
3. **Hosted `.rye`** — `linengrow/open_asks.rye` (or beside receipt — one home, import `receipt_core`)
4. **Witness** — `tools/open_asks_lap1.rish`
5. [x] **OA-L2 brief** — [`20260706-011512_open-asks-cross-party-delivery.md`](20260706-011512_open-asks-cross-party-delivery.md); cross-party delivery over Comlink, after OA-L1 witness green

---

## Three Questions (SLC checklist)

- **Simple** — one ask, one applicant, one acceptance, one stipend receipt, one log?
- **Lovable** — would Flockwork's $100 animation gig trust this loop on their own metal?
- **Complete** — does post → apply → accept → complete → verify close without a board API or escrow?

When all three hold and the witness is green, OA-L1 is ready to share.

---

## Relationship to the Movement Memo

The boards are **honored peers**, not competitors ([`20260702-192712`](../external-research/20260702-192712_the-movements-open-asks.md)). OA-L1 proves our **grain** — signed facts, pure folds, verifiable receipts — on the smallest story from that reading. Interop laps publish *to* existing boards rather than replacing them.

---

*May every open ask find its answering hand. May the first loop stay small enough to verify by hand. And may the stipend receipt carry the same honesty the movement already asks for.*
