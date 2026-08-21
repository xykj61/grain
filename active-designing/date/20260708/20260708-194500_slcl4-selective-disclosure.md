# SLC-L4 — Selective Disclosure

*A hammock scope note: three Linengrow-native ZK passes named so the selective-disclosure lap stays tied to real sanctuary and open-asks needs — not a generic credential demo.*

**Stamp:** `20260708.194500`
**Voice:** Rio 3
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md) · CIVIC · Hammock
**Status:** Checkable-room hammock — lap 1 (fixed-tier Sigma) **landed** `20260709.194437` at parity **200**; later passes still design. Path [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md); study [`223327`](../external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md) kept for Sui record.

**Ground:** counsel [`041000`](../counsel/20260708-041000_claude-counsel-settlement-recommendation-july-2026.md) · six open points [`221612`](../counsel/20260708-221612_claude-counsel-six-open-points.md) · Zig-native path [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md) · ZK study [`223327`](../external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md) · SLC-L3 scope [`20260708-182500_slcl3-settlement-rail.md`](20260708-182500_slcl3-settlement-rail.md) · OA-L4 reputation [`20260706-232812`](../session-logs/archive/20260706/20260706-232812_open-asks-lap4-reputation-fold.md)

**Direction:** [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md) · [`../work-in-progress/TASKS.md`](../work-in-progress/TASKS.md)

---

## The Problem, Plainly

After SLC-L1–L3, civic facts on our log can be signed, delivered under seal, and settled on a thin rail — yet some claims must be **proved without revealing the underlying data**. A sanctuary admission rule, a donor's exact amount, or a reputation floor for an open ask each need a verifiable pass that keeps privacy at the seam.

SLC-L4 names three concrete shapes on the ladder so the lap stays Linengrow-native rather than a category label.

---

## What SLC-L4 Is

**SLC-L4** is the first selective-disclosure whole on the Linengrow track: a **ZK proof** that a named claim holds, linked to our signed facts and settlement receipts, without exposing the private fields the claim depends on.

| Word | Meaning for this lap |
|------|------------------------|
| **Simple** | One claim shape, one proof object, one verify path per pass |
| **Lovable** | Sanctuary eligibility, donor privacy, or reputation threshold — each a real civic need |
| **Complete** | prove → receipt → verify closes for one pass before the next opens |

---

## Three Passes — Named Exactly

Per counsel `041000`:

| Pass | Claim proved | Data kept private |
|------|----------------|-------------------|
| **Sanctuary eligibility** | Donor or participant meets sanctuary admission rules | Identity and history behind the rule |
| **Donor-amount privacy** | A donation occurred and satisfies policy | Exact amount on the public fold |
| **Reputation-threshold privacy** | Applicant meets a reputation floor for an open ask | Full reputation ledger |

Each pass inherits **OA-L4** consent-before-counting discipline where reputation is involved. Each links to **SLC-L3** settlement receipt shape when dollar settlement is part of the claim.

---

## Proof Receipt — Fields (Proposed)

The proof receipt is a **`.bron` value** — one field per line, space-separated, no quotes. Field set refined after path correction `023112` (Pedersen + Sigma, Curve25519):

| Field | Meaning |
|-------|---------|
| `claim` | one of `sanctuary-eligibility` · `donor-amount-privacy` · `reputation-threshold` |
| `log_digest` | digest of the signed fact the proof references |
| `commitment` | hex Pedersen commitment (`amount·G + blinding·H`) |
| `tier_claimed` | fixed tier id from the public set (lap 1: `1000` · `5000` · `10000` smallest units) |
| `proof` | hex Sigma-protocol transcript (Fiat-Shamir via SHA3-256) |
| `stamp` | `YYYYMMDD.HHMMSS` witness pin |

Live Sui `groth16` verify may join later as an on-demand seam; v1 offline prove+verify belongs in parity once green.

---

## Edge of Complete — In and Out

### In scope (when the lap opens)

- One pass GREEN on metal with welcome + unwelcome verify paths
- Proof receipt `.bron` golden per pass
- Witness wired to parity increment
- Offline prove+verify pair in `tools/parity.rish` once green (Zig-native, deterministic)
- Live Sui verify stays on-demand (same category as chain-read; point 5)

### Horizon for later seasons

- Mainnet treasury
- All three passes in one binary — one pass per lap iteration
- Generic credential marketplace
- Code before Kaeden's lap word (path corrected `023112` — Zig-native ground checked; build still gated)

---

## What SLC-L3 Already Provides

| Inherited | From |
|-----------|------|
| Signed civic fact + log digest | SLC-L1 |
| Sealed cross-party carriage | SLC-L2 |
| Settlement receipt linking log + chain tx | SLC-L3 `182500` |
| Reputation fold + consent facts | OA-L4 |

SLC-L4 attaches at the **privacy seam** — the proof proves the claim; the log remains source of truth.

---

*May each pass wait on a real claim, and may the proof stay verifiable without betraying what it protects.*
