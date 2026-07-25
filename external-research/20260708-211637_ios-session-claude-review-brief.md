# iOS Cursor Session — Full Review Brief for Claude

**Stamp:** `20260708.211637`
**Voice:** Rio 3
**Editor:** Cursor (desktop) · **Model:** Composer
**Register:** Decision briefing — what landed on `gp36-github` during Kaeden's Cursor for iOS rounds, what it means, what still waits on counsel
**Status:** Checkable-room research — Claude review brief; iOS session handoff
**Ground:** `a115db3` → `605ac30` on `gp36-github/main` (10 commits, 2 merged PRs); desktop bench pulled and reconciled same stamp

*Written for Claude counsel review.*

---

## Executive Landscape

The counsel `171712` gate-sort held: six small proposals and one custody gate (SLC-L3). The iOS session **closed the six proposals**, **fixed the PUBKEYS gap**, **wired identity into parity**, **landed SLC-L3 settlement** (two-lane witness GREEN, parity **198**), and **filed SLC-L4 as design-only hammock scope**. Mainnet treasury and settlement-seat prose crown remain **out of scope** per counsel `041000`.

| Milestone | Stamp | Parity | Status |
|-----------|-------|--------|--------|
| Six proposals affirmed | `174500` | — | Kaeden's word seated in TASKS, LEXICON, gratitude |
| Identity check fixed | `180000` | — | `PUBKEYS.template.md` + context fallback |
| Identity witness wired | `180100` | **197** | `tools/parity.rish` stanza added |
| SLC-L3 settlement | `182500` | **198** | Two lanes GREEN; witness wired |
| SLC-L4 selective disclosure | `194500` | — | Design hammock only; no code |

---

## Commit Arc (`a115db3` → `605ac30`)

| Commit | Summary |
|--------|---------|
| `55eb331` | Progress read after counsel `171712` |
| `01619a5` | Kaeden **yes to all six** small proposals — TASKS, LEXICON, gratitude shelf |
| `dcd5452` | `PUBKEYS.template.md`; `identity_shape.rish` context fallback; `identity_check.rish` |
| `48ebc2b` | Identity witness wired into `tools/parity.rish` |
| `223e575` | Parity **197** GREEN on cloud (~2m28s) |
| `74378c5` | **SLC-L3** — `settlement_core.rye`, `settlement.rye`, lane seams, bron goldens, witness |
| `095e620` | Doorway fix for SLC-L3 hammock; post-land hygiene; parity **198** |
| `2fad0c0` | Merge PR #3 — SLC-L3 settlement branch |
| `e751b94` | SLC-L4 design hammock — three ZK passes named |
| `605ac30` | Merge PR #4 — SLC-L4 design branch |

---

## Kaeden's Six Proposals — All Affirmed (`174500`)

Source: counsel [`171712`](../counsel/20260708-171712_claude-counsel-every-gate-sorted.md). Session log: [`175200`](../session-logs/archive/20260708/20260708-175200_kaeden-six-proposals-yes.md).

| Proposal | Affirmation landed in |
|----------|----------------------|
| **Bron beside Brix** | `context/LEXICON.md` — Bron = immutable values at seams; Brix = composable descriptions |
| **Silo retirement** | LEXICON + gratitude README — module retired; Brix bonds; lowercase silo = astrology lane |
| **Linengrow home** | TASKS Open Questions — stay in repo until SLC-L3 witnessed + deployable whole |
| **TASKS.md name** | `work-in-progress/README.md` — keep name; "workbench" as alias only |
| **Two-backend seam** | TASKS — **wait** until Aurora needs sovereign framebuffer |
| **Realidream gratitude shelf** | `gratitude/hyperfiddle.md`, `matklad.md`, `noah-b-realidream.md`, `grain-sketchbook.md` (shelf-only) |

**Note:** grain-sketchbook archive stays outside the tree (Kaeden `222852`); the single shelf note is enough.

---

## Identity Layer — Gap Closed, Parity Wired

Counsel `171712` named a pre-existing gap (not a regression): missing template, canonical keys at `context/PUBKEYS.md`.

| File | Change |
|------|--------|
| `PUBKEYS.template.md` | New fork template at repo root |
| `tools/fixtures/identity_shape.rish` | Reads root `PUBKEYS.md` when present, else `context/PUBKEYS.md` |
| `tools/identity_check.rish` | Documents three worlds (template-only, context, root copy) |
| `tools/parity.rish` | Identity stanza added — parity **197** |

---

## SLC-L3 Settlement — Gate Crossed

**Hammock scope:** [`active-designing/20260708-182500_slcl3-settlement-rail.md`](../active-designing/20260708-182500_slcl3-settlement-rail.md)

### What it proves

A signed SLC-L1 civic fact settles on a **public testnet** thin rail; a third party verifies the settlement receipt **without trusting our folder**.

### Receipt shape (`.bron`)

Seven fields: `log_digest`, `chain`, `asset`, `tx_id`, `amount`, `fact_stamp`, `stamp`. Goldens pin six; `log_digest` computed at runtime.

### Two lanes

| Lane | Chain | Asset | Seam |
|------|-------|-------|------|
| A | Sui testnet | USDsui | `tools/fixtures/slcl3_lane_a_settle.sh` |
| B | Monad testnet | USDC | `tools/fixtures/slcl3_lane_b_settle.sh` |

### Three witness axes

1. **Settlement integrity** — tx confirms; amount matches; lane binding holds
2. **Receipt verifiability** — third party checks from public data only
3. **Settlement-asset integrity** — peg metadata; freeze/governance surfaces named

### Implementation

| File | Role |
|------|------|
| `linengrow/settlement_core.rye` | Receipt parse/write; digest, amount, lane verify |
| `linengrow/settlement.rye` | Two-lane selftest; welcome + unwelcome paths |
| `tools/slcl3_settlement_witness.rish` | Build + run; wired parity **198** |

### Bench fixes during land

- `std.process.spawn` redirect failed under Rye — switched to `std.process.run` with captured stdout
- Dangling slices from `build_slcl1_log` — re-parse canonical fact fields in `run_lane`
- Doorway witness failed until hammock `**Status:**` named checkable room

### Explicitly out of scope

- Mainnet treasury / real funds
- MALA mint
- Prose crown of lane winner — counsel `041000` holds that for Kaeden after witness scores

---

## SLC-L4 — Design Hammock Only

**Scope:** [`active-designing/20260708-194500_slcl4-selective-disclosure.md`](../active-designing/20260708-194500_slcl4-selective-disclosure.md)

Three Linengrow-native ZK passes named per counsel `041000`:

| Pass | Claim proved | Data kept private |
|------|----------------|-------------------|
| Sanctuary eligibility | Meets admission rules | Identity and history |
| Donor-amount privacy | Donation satisfies policy | Exact public amount |
| Reputation-threshold | Meets floor for open ask | Full reputation ledger |

**No code until:** Kaeden's lap word — ZK ground pinned [`223327`](20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md) (`sui::groth16`). Inherits OA-L4 consent discipline and SLC-L3 receipt shape where dollar settlement applies.

---

## Parity and Witness State

| Witness | Parity | Cloud bench |
|---------|--------|-------------|
| Identity check | **197** | GREEN ~2m28s |
| SLC-L3 settlement | **198** | GREEN (after doorway fix) |

Full `parity.rish` hung once on OA-L5 demo (>15m) during early SLC-L3 pass — killed; standalone OA-L5 ~9s. Later full run GREEN through **198**.

---

## What Is Not a Gate (unchanged)

| Item | Shape |
|------|-------|
| Agent-writing paste | Awaiting paste |
| Snapshot lap 4 | Kaeden's hands at a machine |
| Astrology lane | Declined this season |
| MALA graduation | Trigger decides (OA-L4 ruling) |
| Brix build · Pond policy · continuity rules | Each waits its foundation |

---

## Questions for Claude Review

1. **Settlement-seat recommendation** — Witness scores both lanes GREEN on pinned selftest. Does counsel `041000`'s "run witness, do not crown in prose" still hold, or is Kaeden ready for a lane recommendation brief?

2. **Mainnet treasury** — SLC-L3 v1 explicitly excludes real funds. When does mainnet become its own custody event vs. extension of L3?

3. **SLC-L4 lap open** — Three passes named; which pass should open first given OA-L4 reputation fold and sanctuary use cases?

4. **Realidream Visual Track** — ROADMAP unblocked for settlement-receipt views. Does a Realidream lap pair naturally with SLC-L4 design, or should visual work start on L3 receipt shape first?

5. **Grain-sketchbook** — **Closed shelf-only** (Kaeden `222852`): single `.md`; archive stays outside the tree.

6. **`let…in` / block-body** — Still optional per `171712`; no consumers blocked. Worth elevating or stay parked?

---

## Desktop Reconciliation (this pass)

Desktop bench was at `a115db3` with uncommitted four-remote reconcile log (`174336`). Pulled `gp36-github/main` fast-forward to `605ac30`. Merged README index; filed this brief; pushing all four remotes.

---

*May the witness scores speak plainly, and may the one question that still deserves weight — mainnet, crown, lap open — keep receiving it.*
