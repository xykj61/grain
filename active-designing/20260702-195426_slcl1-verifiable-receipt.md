# SLC-L1 — The Verifiable Receipt

*A hammock scope note: the transaction fact named in `.bron`, the sign-append-fold-verify pipeline drawn honestly, and the edge of complete stated so the first Linengrow lap stays genuinely simple — no ledger, no market, one signer and one receipt anyone can check.*

**Stamp:** `20260702.195426`
**Voice:** Rio 3, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md) · CIVIC · Gall · Hammock
**Status:** Scope note — **first lap landed** `20260704.021800`; witness at parity **152**; Open Asks room gated until Kaeden affirms the edge

**Direction:** [`20260628-043542_thin-frontend-slc-direction.md`](20260628-043542_thin-frontend-slc-direction.md) · **Roadmap:** [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md) · **Granular plan:** [`../work-in-progress/TASKS.md`](../work-in-progress/TASKS.md)

---

## The Problem, Plainly

A sanctuary, a creator collective, or a single person keeping honest books today can sign a note and keep a spreadsheet — yet there is no smallest lap on our bench that proves *this signed fact was appended, and this receipt follows from that log alone*. Settlement, currency, and multi-party markets belong to later seasons. The first lovable whole is narrower: one Kumara key, one append-only log, one verifiable receipt folded from the log — the same spine Rye OS already grows, applied to Linengrow's trust promise.

SLC-L1 closes that gap on paper first, then in one witness: sign a transaction fact, append it, fold a receipt, verify without trusting the folder that holds the log.

---

## What SLC-L1 Is

**SLC-L1** is the first [Simple, Lovable, Complete](../context/SIMPLE_LOVABLE_COMPLETE.md) whole on the Linengrow track: a **verifiable receipt** — keypair signs a transaction fact, the fact appends to a plain log, a pure fold produces a receipt, and anyone recomputes and checks the signature.

| Word | Meaning for this lap |
|------|------------------------|
| **Simple** | One signer, one log file, one fold, one verify path |
| **Lovable** | A donation, a stipend record, an honest tally entry — provable on metal today |
| **Complete** | sign → append → receipt → verify closes without Comlink, Sui, or MALA |

SLC-L2 grows **sealed delivery** over Comlink. SLC-L3 grows **settlement** on Sui. SLC-L1 deliberately stops at the local log edge.

---

## The Transaction Fact — Fields Exactly

The fact is a **`.bron` value** — one field per line, space-separated, no quotes (see [`yonder/20260621-063912_bron-notation.md`](yonder/20260621-063912_bron-notation.md)).

| Field | Type / shape | Meaning |
|-------|----------------|---------|
| `from` | Kumara public key | hex fingerprint of the signing key (Ed25519 today) |
| `to` | Kumara public key | counterparty; for a self-directed memo, `from` and `to` may match |
| `amount` | signed integer string | smallest unit agreed for this log (e.g. cents); no float |
| `memo` | remainder of line after key | human-readable purpose; no nested structure in v1 |
| `stamp` | `YYYYMMDD.HHMMSS` | chronological stamp per naming law |

Example (illustrative keys):

```bron
# transaction fact — illustrative
from DBF853437A937B4E36B93611D949807AC26B2B99
to 06462132D3E63B834F976E03A81D720B9235FA7A
amount 100
memo stipend for animation micro-gig
stamp 20260702.195426
```

The **signed envelope** wraps the canonical `.bron` bytes (UTF-8, LF line endings, trailing newline on the last field line) with the ed25519 signature the parity suite already witnesses (`rye/tests/ed25519_sign_test.rye`).

---

## The Pipeline — Sign, Append, Fold, Verify

| Step | What happens | Host seam today |
|------|----------------|-----------------|
| **Sign** | Kumara key signs the canonical fact bytes | ed25519 path in parity |
| **Append** | Signed envelope written as one record to a **plain log file** (one record per line: base64 or hex envelope — chosen at build, pinned in witness) | ordinary file I/O |
| **Receipt** | **Pure fold** over the log: for each verified record, update running balance per `(from, to)` pair or per `from` only in v1 | projection in foundations vocabulary |
| **Verify** | Recompute fold from log; re-check each signature; compare to claimed receipt | same ed25519 verify path |

**Receipt shape (v1):** a `.bron` value naming the log digest, the fold state at the tail, and the tail record's signature — so a third party checks the log without the writer's cooperation.

---

## Edge of Complete — In and Out

### In scope (SLC-L1 is done when these hold)

- [x] One signer, one log path, one receipt value produced and verified on metal (`linengrow/receipt.rye`, `20260704.021800`)
- [x] Transaction fact fields exactly as named above
- [x] Witness `tools/slcl1_receipt.rish` runs green: welcome path (sign → append → fold → verify match); unwelcome path (tampered log byte → verify fails)
- [x] Scope note and witness registered; parity **152** (`20260704.021800`)

### Horizon (SLC-L2 and later)

- **Settlement**, **currency**, **multi-party** consensus, **MALA** mint/send/market — M0–M4 ladder in [`20260702-031312_modules-aspects-and-mailable-money.md`](20260702-031312_modules-aspects-and-mailable-money.md)
- **Comlink** delivery (SLC-L2)
- **Sui** / USDsui ledger (SLC-L3)
- **Open Asks room** — OA-L1 scope drawn [`20260706-002912_open-asks-hammock-scope.md`](../active-designing/20260706-002912_open-asks-hammock-scope.md); implementation gated on Kaeden edge affirmation ([`../external-research/20260702-192712_the-movements-open-asks.md`](../external-research/20260702-192712_the-movements-open-asks.md))
- Full Mantra weave for transaction logs — v1 uses a **plain append file** beside the Mantra store; Amber compatibility for Linengrow logs rides Amber's first lap as horizon

### Open ruling (recommended yes)

The first Linengrow lap uses **pure foundations** — keypair + log + projection — with **no Sui**. Settlement deferred to SLC-L3 ([`TASKS.md`](../work-in-progress/TASKS.md) Open Questions).

---

## Witness Sketch — `tools/slcl1_receipt.rish`

Named now; **landed** `20260704.021800` at parity **152**.

**Welcome path:**

1. Load a fixture fact from `tools/fixtures/slcl1_fact.bron`
2. Sign with deterministic test key (same discipline as ed25519 witness)
3. Append to a temp log under `tools/fixtures/slcl1_log/`
4. Fold → receipt `.bron`
5. Verify → `(v.ok == true)` asserted; receipt fields match pinned golden

**Unwelcome path:**

1. Same log, one byte tampered in the signed envelope
2. Verify → `(v.ok == false)` asserted

**Parity:** one quartet block at tail when wired; increment documented in ROADMAP and TASKS.

---

## Build Order (after scope affirmed)

1. **Doors 1–3** and **Amber first lap** — per ladder ([`TASKS.md`](../work-in-progress/TASKS.md))
2. **Fixture fact + golden receipt** — pinned under `tools/fixtures/slcl1_*`
3. **Fold + verify in hosted `.rye`** — `linengrow/receipt.rye` (`20260704.021800`)
4. **Witness** — `tools/slcl1_receipt.rish`; registered in `tools/parity.rish` (**152**)
5. **SLC-L2 prompt** — sealed delivery over Comlink, only after L1 witness green

---

## Three Questions (SLC checklist)

- **Simple** — one signer, one log, one fold, one verify?
- **Lovable** — would a sanctuary treasurer trust this receipt on their own metal?
- **Complete** — does sign → append → receipt → verify close without the network or the ledger?

When all three hold and the witness is green, SLC-L1 is ready to share.

---

*May the first receipt stay small enough to verify by hand. May the log stay append-only, and may every fold stay pure over the facts alone.*
