# SLC-L3 — The Settlement Rail

*A hammock scope note: the thin crossing edge where our signed civic fact meets a dollar-denominated stablecoin on a public testnet, and a third party verifies the settlement receipt without trusting our folder.*

**Stamp:** `20260708.182500`
**Voice:** Rio 3
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md) · stop-and-park on custody
**Status:** Hammock record — checkable room; landed `182500`; implementation removed `152612` (MALA path); parity **197**.

**Ground:** [`external-research/20260707-222500_settlement-seat-refresh-and-slcl3-witness-proposal.md`](../external-research/20260707-222500_settlement-seat-refresh-and-slcl3-witness-proposal.md) · counsel [`041000`](../counsel/20260708-041000_claude-counsel-settlement-recommendation-july-2026.md) · apply prompt [`20260707-222500_apply-slcl3-settlement-witness.md`](../expanding-prompts/20260707-222500_apply-slcl3-settlement-witness.md)

**Gate:** Kaeden opened SLC-L3 settlement `182500` — witness runs; no winner crowned in prose.

---

## What SLC-L3 Is

**SLC-L3** is the first lap where a civic transaction fact on **our** log is **settled** with a dollar-denominated stablecoin on a **public testnet**, and a third party verifies the settlement receipt **without trusting our folder**.

| Word | Meaning for this lap |
|------|------------------------|
| **Simple** | One fact, one settlement tx, one receipt object, one verify path per lane |
| **Lovable** | A sanctuary donation settled on testnet — delayed receipt still true |
| **Complete** | Both lanes run the same flow; witness scores three axes; recommendation waits on Kaeden |

SLC-L1 proved the local log edge. SLC-L2 proved sealed delivery. SLC-L3 proves the **thin rail** at the crossing edge.

---

## The Settlement Receipt — Fields Exactly

The receipt is a **`.bron` value** — one field per line, space-separated, no quotes.

| Field | Type / shape | Meaning |
|-------|----------------|---------|
| `log_digest` | 64-char hex | SHA3-256 of the signed SLC-L1 log line |
| `chain` | string | public chain id (`sui-testnet`, `monad-testnet`) |
| `asset` | string | settlement stablecoin id (`usdsui`, `usdc`) |
| `tx_id` | string | chain transaction digest verifiable on explorer |
| `amount` | signed integer string | matches the SLC-L1 fact amount in smallest unit |
| `fact_stamp` | `YYYYMMDD.HHMMSS` | stamp from the settled fact |
| `stamp` | `YYYYMMDD.HHMMSS` | witness pin for this lap |

`log_digest` is computed at runtime from the signed log — goldens pin the other six fields.

---

## Two Lanes — Identical Flow

```
tools/fixtures/slcl1_fact.bron  →  sign + append (SLC-L1 discipline)
       ↓
lane seam (POSIX external interpreter)  →  testnet-shaped settlement response
       ↓
settlement_receipt.bron  →  links log digest + chain tx + asset id
       ↓
verify  →  three-axis score + unwelcome paths
```

| Lane | Chain | Asset | Seam |
|------|-------|-------|------|
| **A** | Sui testnet | USDsui | `tools/fixtures/slcl3_lane_a_settle.sh` |
| **B** | Monad testnet | USDC | `tools/fixtures/slcl3_lane_b_settle.sh` |

Live mode (`SLCL3_LIVE=1`) exits **2** on this bench — pinned selftest is the witness contract.

---

## Three Axes the Witness Measures

| Axis | What green means |
|------|------------------|
| **Settlement integrity** | Chain tx confirms; amount matches fact; lane binding holds |
| **Receipt verifiability** | Third party checks receipt from public data only |
| **Settlement-asset integrity** | Asset peg metadata recorded; freeze/governance surfaces named |

---

## Edge of Complete — In and Out

### In scope (landed `182500`; implementation removed `152612`)

- One pinned `slcl1_fact.bron` settled on **both** testnet lanes — **was** GREEN before removal
- ~~`linengrow/settlement.rye`~~ — **removed**
- ~~`tools/slcl3_settlement_witness.rish`~~ — **removed** from parity (**197**)
- Settlement receipt goldens — **removed**; counsel/hammock kept as record

### Horizon for later seasons

- Mainnet treasury or real funds
- MALA mint
- Multi-party market
- SLC-L4 ZK selective disclosure
- Crown winner in prose — counsel holds that for Kaeden after witness scores

---

## Implementation Map (historical — files removed `152612`)

| File | Role |
|------|------|
| ~~`linengrow/settlement_core.rye`~~ | Removed |
| ~~`linengrow/settlement.rye`~~ | Removed |
| ~~`tools/fixtures/slcl3_lane_*_settle.sh`~~ | Removed |
| ~~`tools/fixtures/settlement_receipt_lane_*.bron`~~ | Removed |
| ~~`tools/slcl3_settlement_witness.rish`~~ | Removed from parity |

---

*The log remains source of truth; the chain is toll gate, not oracle. May the crossing stay thin and the receipt stay verifiable.*
