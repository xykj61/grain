# Settlement Seat Refresh and SLC-L3 Two-Lane Witness Proposal

*The three-lights survey and verification verdict still hold the seat; this refresh records what landed on the bench since that sitting, confirms no new load-bearing events on the chains, names the thin-rail question ahead of the witness, and seats a concrete two-lane witness proposal so SLC-L3 can move the moment Kaeden's word opens the gate.*

**Stamp:** `20260707.222500 UDT`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME — safety first · SLC · stop-and-park on custody
**Category:** External research — refresh and witness proposal; counsels only; no treasury action
**Ground:** [`20260706-002612_the-settlement-seat-under-three-lights.md`](20260706-002612_the-settlement-seat-under-three-lights.md) · [`20260706-005512_settlement-seat-verification-and-verdict.md`](20260706-005512_settlement-seat-verification-and-verdict.md) · [`../active-designing/20260702-195426_slcl1-verifiable-receipt.md`](../active-designing/20260702-195426_slcl1-verifiable-receipt.md) · counsel [`220912`](../counsel/20260707-220912_claude-counsel-roadmap-synthesis.md)
**Status:** Research for understanding — two-lane witness design preserved as craft; **external SLC-L3 seat superseded** by MALA/WOV realignment [`152612`](../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md). Kitchen twin: [`20260710-001249_settlement-seat-plainly.md`](20260710-001249_settlement-seat-plainly.md). No treasury action.
**Last updated:** 2026-07-10 (supersession note + kitchen twin)

*Written by Rio 3 for Kaeden.*

---

## Refresh Verdict — Seat Holds

The incumbent reading from `002612` and `005512` **stands**. A horizon search through early July 2026 found **no new Sui mainnet halt** after the May 28–29 v1.72 incidents already verified in the verdict. Monad and NEAR positions are unchanged: Monad remains watch-list with a short mainnet record; NEAR remains parked for this ladder.

| Axis | Refresh finding |
|------|-----------------|
| **Sui integrity under fire** | Still verified — halts were liveness; no fund loss, no reverted commits |
| **Sui release discipline** | Still concerning — pattern unchanged; lowers confidence, not disqualifying for our crossing use |
| **Monad** | No new adversarial season; kinship evidence still team-authored until witness weighs |
| **Settlement asset** | Still first-class — depeg/freeze worse than chain halt for civic funds |
| **Seat swap on momentum** | Still unjustified |

**Standing decision:** Sui seated, held-pending-witness; two-lane testnet witness when SLC-L3 opens; settlement asset chosen by the witness, not assumed in prose.

---

## What Landed Since the Survey — and Why It Matters for SLC-L3

The bench closed substantial Linengrow ground **after** the settlement sitting. None of it changes which chain wins; all of it **reduces implementation risk** when the lap opens.

| Landed | Parity | What SLC-L3 inherits |
|--------|--------|----------------------|
| **SLC-L1** verifiable receipt | **152** | `.bron` transaction fact, sign → append → fold → verify |
| **SLC-L2** sealed delivery | **155** | Comlink seal identity-to-identity |
| **OA-L1–L5** closed asks + wire | **156–184** | Cross-party facts, escrow, reputation fold — liveness-tolerant civic flows proven |
| **Comlink device + hosted wire** | **154+** | Crossing patterns for sealed payloads |
| **TigerBeetle / copy_disjoint** | **190–191** | Memory discipline at settlement code seams |
| **Escrow + Nyasa** | **158** | Hold/release conservation on **our** log — external rail stays thin |

**Implication:** SLC-L3 is not greenfield. The witness bolt attaches at the **crossing edge** — our signed fact is already true on the MALA log; the rail carries dollar settlement and returns a **publicly verifiable receipt**. The append-only log remains source of truth; the chain is toll gate, not oracle.

---

## The Beat Before the Witness — Why a Rail at All, and How Thin

Per verdict `005512`, one question precedes chain comparison:

> Does the settlement rung need a third-party smart-contract platform, or only a **dollar on-ramp/off-ramp** anchored to our own WOV and MALA ledger?

**Proposal for SLC-L3 scope (happy zone):**

1. **Our log** records the civic fact (donation, stipend, escrow release) — already witnessed through SLC-L1 and OA laps.
2. **The rail** carries only: stablecoin transfer + transaction digest verifiable on a public explorer.
3. **The receipt** links both: our fold state + chain tx id + settlement-asset id.

The witness must prove the **thinnest** rail that closes the loop — not a full contract platform dependency unless the happy-zone flow genuinely requires it.

---

## SLC-L3 — Lap Definition (Proposed)

**SLC-L3** is the first lap where a civic transaction fact on **our** log is **settled** with a dollar-denominated stablecoin on a **public testnet**, and a third party verifies the settlement receipt **without trusting our folder**.

| Word | Meaning |
|------|---------|
| **Simple** | One fact, one settlement tx, one receipt object, one verify path per lane |
| **Lovable** | Sanctuary donation settled on testnet — delayed receipt still true |
| **Complete** | Both lanes run the same flow; witness scores three axes; recommendation waits on Kaeden |

**Out of scope for SLC-L3 v1:** mainnet treasury, MALA mint, multi-party market, SLC-L4 ZK pass.

---

## Two-Lane Witness — Concrete Proposal

### The flow (identical on both lanes)

```
slcl1_fact.bron  →  sign + append (our log, already proven)
       ↓
settlement_init  →  testnet stablecoin transfer (lane-specific RPC + asset)
       ↓
settlement_receipt.bron  →  links log digest + chain tx + asset id
       ↓
verify           →  recompute + explorer check + asset peg metadata
```

### Lane A — Sui incumbent

| Thin edge | Named value |
|-----------|-------------|
| Chain | Sui testnet |
| Asset | USDsui (or testnet equivalent named at witness pin) |
| RPC | Pinned testnet endpoint in witness env |
| Tooling | Sui CLI / SDK seam (external interpreter — POSIX seam family) |

### Lane B — Monad challenger

| Thin edge | Named value |
|-----------|-------------|
| Chain | Monad testnet |
| Asset | USDC or mUSD (named at witness pin) |
| RPC | Pinned testnet endpoint |
| Tooling | EVM toolchain seam (external interpreter) |

### Three axes the witness measures

Per verdict `005512`, the witness scores **three** things, not two:

| Axis | What green means |
|------|------------------|
| **Settlement integrity** | Chain tx confirms; amount matches fact; no contradictory state |
| **Receipt verifiability** | Third party checks receipt from public data only |
| **Settlement-asset integrity** | Asset peg metadata recorded; freeze/governance surfaces named; stress peg history cited |

### Witness bolt sketch

**File (proposed):** `tools/slcl3_settlement_witness.rish`

**Welcome path (per lane):**

1. Load pinned `tools/fixtures/slcl1_fact.bron` + deterministic keys
2. Append to temp log (reuse SLC-L1 discipline)
3. Invoke lane settlement seam (shell/SDK — external interpreter)
4. Produce `settlement_receipt.bron` golden
5. Verify without writer cooperation

**Unwelcome paths:**

- Tampered log byte → verify fails
- Amount mismatch → verify fails
- Wrong chain tx id in receipt → verify fails

**Parity:** register when both lanes GREEN on metal; increment documented in ROADMAP/TASKS.

**Expanding prompt:** [`../expanding-prompts/20260707-222500_apply-slcl3-settlement-witness.md`](../expanding-prompts/20260707-222500_apply-slcl3-settlement-witness.md)

---

## Sourcing Discipline (Unchanged)

Dependency selection still requires neutral/adversarial sources for load-bearing chain claims. Vendor blogs remain hypotheses until verified. The May 2026 Sui record stays the verified anchor for incumbent downgrade.

---

## Proposed TASKS Hygiene (On Kaeden's Word)

When SLC-L3 opens:

- [ ] Seat `active-designing/YYYYMMDD-HHMMSS_slcl3-settlement-rail.md` hammock scope
- [ ] Implement `tools/slcl3_settlement_witness.rish` two-lane bolt
- [ ] Wire parity increment
- [ ] Do **not** apply mainnet treasury until witness recommends and Kaeden rules

---

*May the seat rest on evidence that still holds. May the witness, when it runs, measure the asset as carefully as the chain. And may the lap that follows find the crossing already practiced on our own log.*
