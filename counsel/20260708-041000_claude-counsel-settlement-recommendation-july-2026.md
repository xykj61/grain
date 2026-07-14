# Claude Counsel — Settlement Recommendation; SLC-L4 Shapes; the Visual Track Meets Linengrow

**Stamp:** `20260708.041000 UDT`
**Voice:** Rio 3
**Register:** informational counsel toward the witness; **SLC-L3 gate unchanged** — Kaeden's word only
**Ground:** [`external-research/20260708-041000_settlement-horizon-refresh-july-2026.md`](../external-research/20260708-041000_settlement-horizon-refresh-july-2026.md) · witness proposal [`20260707-222500`](../external-research/20260707-222500_settlement-seat-refresh-and-slcl3-witness-proposal.md) · spawn lap 2 closed [`7dfdf46`](../session-logs/archive/20260708/20260708-033600_spawn-lap2-aurora-run-complete.md)

*Written by Kaeden and Claude; filed by Rio 3.*

---

## Aurora Witness — Verified, Appropriately Scoped

`tools/aurora_run_witness.rish` tests only what needs no QEMU: missing-stage **exit 2** and `args` defaulting. The landed `tools/aurora_run.rish` refines the first draft with two original-script details: **explicit `exit 2`** for missing stage (not assert's default **1**), and **honoring pre-set `RYE_ZIG`** before vendored fallback.

Not wired to `parity.rish` — correct. Six stages, no fixed stdout; developer utility, not witness shape.

---

## Settlement — Run the Witness, Do Not Crown a Winner in Prose

Fresh horizon research (July 2026) in [`041000`](../external-research/20260708-041000_settlement-horizon-refresh-july-2026.md):

- **Sui:** ~five clean weeks post-May 30; post-mortem names three engineering remediations; liveness-only harm class holds.
- **Monad:** ~7.5 months mainnet; no chain-level halt found in search; Aave V3 + MetaMask Money Account (Mastercard) are real adoption signals — **not** substitutes for adversarial seasons.

**Counsel:** the gap between lanes reads **narrower** than two months ago. That is the strongest argument for **executing the two-lane testnet witness**, not for picking a chain in counsel. Proposal `222500` needs **no changes**.

**SLC-L3 remains Kaeden's gate** — real money, custody, stop-and-park.

---

## SLC-L4 — Three Concrete Shapes (Design, Not Code)

Beyond "ZK credential" as category, three **Linengrow-native** passes deserve names on the ladder:

| Shape | Claim proved | Data kept private |
|-------|----------------|-------------------|
| **Sanctuary eligibility** | Donor or participant meets sanctuary admission rules | Identity and history behind the rule |
| **Donor-amount privacy** | A donation occurred and satisfies policy | Exact amount on the public fold |
| **Reputation-threshold privacy** | Applicant meets a reputation floor for an open ask | Full reputation ledger |

Each is a real OA / sanctuary need — not a generic ZK demo. Implementation waits on SLC-L3 receipt shape and Sui ZK foundations; **no lap opens without ground.**

---

## Visual Track = Linengrow Track (Same Road)

The Realidream lane and Linengrow SLC ladder are **one road seen two ways**. A **settlement receipt** — civic fact on our log + verifiable chain digest — is the first real object the Visual Track will need to **show** (sanctuary page, donor transparency, reputation surface). Designing Realidream views without SLC-L3 receipt shape would sketch UI over air.

---

## Offer — Witness Scaffolding (Not Built; Kaeden's Word)

When wanted, the bench can land **non-chain scaffolding** for the SLC-L3 witness:

- `.bron` fixture handling
- SLC-L1 fold reuse
- Receipt assembly and verify path

…with **only** the two chain-specific calls stubbed. Opening day then needs credentials + Kaeden's gate — not greenfield plumbing.

**This counsel does not authorize building that scaffolding** — say the word when the gate is near.

---

## What Rio Should File

| Item | Action |
|------|--------|
| Horizon refresh | [`external-research/20260708-041000_…`](../external-research/20260708-041000_settlement-horizon-refresh-july-2026.md) |
| TASKS | SLC-L4 three shapes; horizon refresh pointer |
| ROADMAP | SLC-L4 detail; Visual Track ↔ settlement receipt line |
| Witness scaffolding | **Hold** until Kaeden |

---

*May measurement finish what momentum cannot — and may the selective-disclosure passes wait on real claims, not on category labels.*
