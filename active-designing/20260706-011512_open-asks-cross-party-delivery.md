# Open Asks — Cross-Party Delivery (OA-L2)

*The movement's ask leaves the poster's machine and returns as a signed application under Comlink's seal — OA-L1's closed loop unchanged on the canonical log, the carriage proven on hosted UDP first, device wire for the civic story already green from SLC-L2.*

**Stamp:** `20260706.011512`
**Voice:** Rio 3, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md) · CIVIC · Gall · Hammock
**Register:** active-designing — names only our modules
**Status:** Seated — checkable-room lap brief; **OA-L2 landed** `20260706.011512`; witness at parity **157**

**Ground:** [`20260706-002912_open-asks-hammock-scope.md`](20260706-002912_open-asks-hammock-scope.md) · [`20260706-000812_slcl2-sealed-delivery.md`](20260706-000812_slcl2-sealed-delivery.md) · [`linengrow/open_asks.rye`](../linengrow/open_asks.rye) · [`linengrow/delivery.rye`](../linengrow/delivery.rye) · [`comlink/wire_format.rye`](../comlink/wire_format.rye)

**Direction:** [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md) · **Granular plan:** [`../work-in-progress/TASKS.md`](../work-in-progress/TASKS.md)

---

## The Problem, Plainly

OA-L1 proved the **closed ask loop** on one append-only log — post, apply, accept, complete, verify — with every fact signed and every transition checkable by pure fold. That loop is honest **locally**: poster and applicant keys can share one process and one log file.

Real boards coordinate **across machines**. Flockwork posts an ask; an applicant on another host applies. The grain we owe them is the same signed facts OA-L1 already names — carried identity to identity under Comlink's seal, the same discipline SLC-L2 proved for a stipend receipt.

OA-L2 is the **smallest cross-party whole** on that spine: one request travels out, one application travels back, the poster's log folds to `applied` without trusting the UDP seam.

---

## What OA-L2 Is

| Word | Meaning for this lap |
|------|----------------------|
| **Simple** | Two facts, two UDP hops, one fixture ask, deterministic test keys from OA-L1 |
| **Lovable** | The $100 animation micro-gig request reaches the applicant's machine; the application returns sealed |
| **Complete** | send request → recv verify → send application → recv verify → fold `applied` closes on metal |

The **outer seal** uses Comlink fixture keys (poster → applicant on request; applicant → poster on application). The **inner facts** use OA-L1 Ed25519 signers — two layers, honestly named, same pattern as SLC-L2.

OA-L3 grows **MALA bounty escrow** (M1→M2 ladder). OA-L4 grows **reputation-as-fold**. OA-L2 deliberately stops at **request + application carriage**; acceptance and completion remain local append on the poster's canonical log until a later lap names delivery for those facts.

---

## Payload Shape — Compact, Bounded

OA-L1 facts fit under `wire_format.max_message` when hex-encoded on a log line; cross-party carriage uses a **compact binary payload** mirroring SLC-L2:

| Region | Size | Content |
|--------|------|---------|
| signature | 64 bytes | Ed25519 over canonical `.bron` bytes |
| fact_len | u32 LE | length of canonical fact |
| fact | ≤ 512 bytes | canonical request or application (fixture fits) |

Encoded beside `linengrow/open_asks.rye`; sealed by `wire_format.sealMessage`.

---

## The Pipeline — Send, Recv, Send, Recv, Fold

| Step | Actor | Machine | What happens | Reuses |
|------|-------|---------|--------------|--------|
| **Post (local)** | Poster | A | Sign request fact → hold in send buffer | `open_asks.rye` parsers |
| **Deliver request** | Poster → Applicant | A → B | `sealMessage` → UDP to applicant listen port | `wire_format`, hosted UDP |
| **Recv request** | Applicant | B | Open datagram → verify poster signature → compute `request_ref` | `open_asks` verify path |
| **Apply (local)** | Applicant | B | Sign application fact with matching `request_ref` | OA-L1 application shape |
| **Deliver application** | Applicant → Poster | B → A | `sealMessage` → UDP to poster listen port | same carriage |
| **Recv application** | Poster | A | Open datagram → verify applicant signature → append to log | append discipline |
| **Fold** | Anyone | A | Pure fold over log: `posted` + `applied` for fixture `request_ref` | `open_asks.foldLog` |

**Canonical log home (v1):** the **poster's machine** holds the append-only log. The applicant verifies the request off-wire; only the returned application appends on the poster side. Acceptance, completion, and full OA-L1 close remain on that log — OA-L2 proves **carriage**, not the entire escrow story.

---

## Modules

| Module | Role |
|--------|------|
| `linengrow/open_asks.rye` | Fact parsers, `requestRefHex`, `foldLog`, `foldAppliedLog`, compact encode/decode |
| `linengrow/open_asks_delivery.rye` | OA-L2 send / recv / demo / selftest |
| `linengrow/delivery.rye` | SLC-L2 reference — same hosted UDP pattern |
| `comlink/wire_format.rye` | `sealMessage` — arbitrary bounded plaintext |

Port **38474** — distinct from SLC-L2 delivery (**38473**) and hosted wire demo (**38472**).

### Device wire variant (landed `20260706.012112` · application return `20260706.012412`)

| Guest | Role |
|-------|------|
| `comlink/guest_open_asks_tx.rye` | Seal witness request, virtio TX |
| `comlink/guest_open_asks_rx.rye` | Open datagram, verify request + `request_ref` |
| `comlink/guest_open_asks_application_tx.rye` | Seal witness application, virtio TX |
| `comlink/guest_open_asks_poster_rx.rye` | Open application, verify, `foldAppliedLog` |
| `comlink/run_open_asks_wire_lab.sh` | QEMU socket lab — request **15557**, application **15558** |

`virtio_net.max_frame` **554** — virtio/eth headers plus full `wire_capacity` datagram (**528**).

---

## Witness — `tools/open_asks_lap2.rish`

**Welcome path:**

1. Build `linengrow/bin/open-asks-delivery`
2. `selftest` — seal request, open verify, seal application, open verify, fold `applied`
3. `demo` — applicant child + poster child round trip on ports **38474** / **38475**
4. `comlink/run_open_asks_wire_lab.sh` — sealed request **and** application over virtio-net (two hops)

**Unwelcome path:** application cites wrong `request_ref` → verify refuses (hosted selftest).

**Parity:** one block after OA-L1 → **157** (wired).

---

## Edge of Complete

### In scope

- Hosted UDP delivery of **request** and **application** facts under Comlink seal
- Reuse `tools/fixtures/open_asks_request.bron` and OA-L1 deterministic seeds (`0x51` / `0x52`)
- Poster-side fold reaches `applied` after cross-party round trip
- Witness green on metal

### Horizon for later laps

- Delivery of acceptance or completion facts cross-party
- Device wire variant (civic proof path — carriage pattern already green from SLC-L2)
- Caravan-supervised peers
- MALA mint, escrow, release — OA-L3
- Reputation fold — OA-L4
- Board interop — publish to Flockwork; horizon

---

## Build Order (after Kaeden affirms edge)

1. **Affirm this scope note** — edge in/out; no new module names beyond `open_asks_delivery`
2. **Compact encode/decode** in `open_asks.rye` beside existing parsers
3. **Hosted `.rye`** — `linengrow/open_asks_delivery.rye`
4. **Witness** — `tools/open_asks_lap2.rish`
5. **Device wire brief** — only after hosted witness green

---

## Three Questions (SLC checklist)

- **Simple** — one ask, one application, two sealed hops, one poster log?
- **Lovable** — would the movement trust this round trip on their own metal before a board API?
- **Complete** — does send → recv → send → recv → fold `applied` close without escrow or reputation?

When all three hold and the witness is green, OA-L2 is ready to share.

---

## Relationship to OA-L1 and SLC-L2

| Lap | Proves |
|-----|--------|
| **SLC-L1** | Signed stipend receipt folds locally |
| **SLC-L2** | That receipt travels under Comlink seal |
| **OA-L1** | Ask vocabulary folds locally on one log |
| **OA-L2** | Request and application travel under the same seal |

The boards remain **honored peers** ([`20260702-192712`](../external-research/20260702-192712_the-movements-open-asks.md)). OA-L2 publishes our carriage grain toward them — signed facts, pure folds — without replacing their coordination surfaces.

---

*May the ask find its answering hand across the wire. May the seal open to the same fact that left. And may the poster's log stay honest when the application returns home.*
