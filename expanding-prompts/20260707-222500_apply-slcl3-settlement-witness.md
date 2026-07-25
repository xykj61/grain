# Apply SLC-L3 Settlement Witness — Expanding Prompt

**Stamp:** `20260707.222500`
**Voice:** Rio 3
**Ground:** [`external-research/20260707-222500_settlement-seat-refresh-and-slcl3-witness-proposal.md`](../external-research/20260707-222500_settlement-seat-refresh-and-slcl3-witness-proposal.md)
**Gate:** Kaeden's word opens SLC-L3 — this prompt does not authorize mainnet treasury

---

## Objective

Implement the two-lane SLC-L3 witness bolt when the gate opens.

## Deliverables

1. `active-designing/YYYYMMDD-HHMMSS_slcl3-settlement-rail.md` — hammock scope (fact fields, receipt shape, edge of complete)
2. `tools/slcl3_settlement_witness.rish` — welcome + unwelcome paths per lane
3. `tools/fixtures/settlement_receipt_lane_a.bron` / `lane_b.bron` — pinned goldens
4. POSIX seams for Sui/Monad SDK invocation — external-interpreter family per `TAME_GUIDANCE.md`
5. Parity increment + TASKS/ROADMAP pin

## Witness claims (happy zone)

- One `slcl1_fact.bron` settled on Sui testnet (lane A)
- Same fact flow on Monad testnet (lane B)
- Three-axis score recorded in witness output (integrity, verifiability, asset integrity)

## Out of scope

- Mainnet funds
- SLC-L4 ZK
- MALA mint

## Verify

```
rishi/bin/rishi run tools/slcl3_settlement_witness.rish
rishi/bin/rishi run tools/parity.rish  # tail
```
