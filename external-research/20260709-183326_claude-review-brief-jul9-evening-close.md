# Jul 9 Evening Close — Full Review Brief for Claude

**Stamp:** `20260709.183326`
**Voice:** Rio 3
**Editor:** Cursor (desktop) · **Model:** Composer 2.5
**Register:** Decision briefing — MALA realignment, settlement removal, parity **197**, MALA M1 lap-open filed
**Status:** Checkable-room research — Claude review brief; **superseded** by [`203139`](20260709-203139_claude-review-brief-jul9-night-climb.md) for Claude analysis
**Ground:** `b7c5ef6` on all four remotes before this push; supersedes [`20260709-034527`](20260709-034527_claude-review-brief-jul9-late-arc.md); night climb continues at [`203139`](20260709-203139_claude-review-brief-jul9-night-climb.md)

*Written for Claude counsel review before the evening `go` commit.*

---

## Executive Landscape

Kaeden directed **own L1 via MALA** — backtrack from Sui/Monad external interpreters. Counsel [`152612`](../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md) found the July 2 design already in tree. Settlement + chain-read implementation **deleted** (not merely superseded — no external dependents). Parity **197**. Full suite **GREEN** on metal (~150s). **MALA M1 lap-open brief [`182354`](../expanding-prompts/20260709-182354_mala-m1-one-issuer-one-holder.md) filed**; M0 gate verified. **SLC-L4 [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md) still ready** on Kaeden's lap word.

| Milestone | Stamp | Parity | Status |
|-----------|-------|--------|--------|
| Jul 9 late brief | `034527` | **198** | Superseded by this brief |
| MALA/WOV counsel | `152612` | — | **Active** direction |
| Settlement + chain-read removal | `163549` arc | **197** | **Deleted from tree** |
| MALA M1 lap-open | `182354` | — | Ready on lap word |
| SLC-L4 lap-open | `031612` | — | Ready on lap word (unchanged) |
| Parity verified | `182051` | **197** | GREEN on metal |

**Remote tip before push:** all four at **`b7c5ef6`**.

---

## The Strategic Pivot — Own L1, Not Sui/Monad

Counsel `152612` names what changed and what was already designed:

| Piece | Role | Consensus needed? |
|-------|------|-------------------|
| **MALA** | Single-issuer mailable money — Kumara signs, Weave orders | **No** at M1–M3 |
| **WOV** | Rye overlay on vendored `gratitude/tigerbeetle` | 1–2 monarchs; never three |
| **Mycelium** | Byzantine agreement among strangers | **Gated at M4** — Kaeden's July 2 conclusion, not a new objection |

**Kaeden's removal directive:** `comlink/chain_read_*.sh`, `linengrow/settlement*.rye`, witnesses, grpcurl bootstrap, bron goldens — **gone from tree**. Hammock [`182500`](../active-designing/20260708-182500_slcl3-settlement-rail.md), session logs, and counsel remain as dated record.

---

## What This Commit Deletes (~782 lines)

| Path | Was |
|------|-----|
| `linengrow/settlement.rye` | Two-lane Sui/Monad selftest |
| `linengrow/settlement_core.rye` | Receipt parse/write, lane verify |
| `tools/slcl3_settlement_witness.rish` | Parity stanza (dropped → **197**) |
| `comlink/chain_read_{sui,monad}.sh` | Live chain-read POSIX seams |
| `tools/chain_read_*` + witnesses | Rishi hosts |
| `tools/ensure_grpcurl.sh` | grpcurl bootstrap for Sui gRPC |
| `tools/fixtures/settlement_receipt_lane_*.bron` | Pinned goldens |
| `tools/fixtures/slcl3_lane_*_settle.sh` | Lane settle fixtures |

**Kept as record:** counsel, external-research, hammocks, session logs (including what landed at `182500`).

---

## Parity and Witness State

| Witness | Before | After | Notes |
|---------|--------|-------|-------|
| Full suite | **198** | **197** | SLC-L3 stanza removed |
| SLC-L3 settlement | in parity | **removed** | Implementation deleted |
| Chain-read | on-demand | **removed** | No live network seams |
| OA-L3 escrow | **198** | **197** | Unchanged; hung ~30 min on stale subprocesses, clean run GREEN |
| Doorway scan | failed → fixed | **GREEN** | Status lines on 4 forward-facing pages |
| MALA M1 (future) | — | **198** (proposed) | When lap lands |
| SLC-L4 Sigma (future) | **199** (proposed) | **198** (proposed) | One witness slot freed |

**Verification:** `rishi/bin/rishi run tools/parity.rish` — exit 0, ~150s, all witnesses GREEN including OA-L3, doorway, Comlink device wire.

---

## MALA M1 — Lap-Open Brief (`182354`)

**M0 gate verified on metal:**

| Condition | Evidence |
|-----------|----------|
| Edit 5 | `designed_not_built_witness` GREEN; parity **143** |
| Amber first lap | `amber_first_ring` GREEN; parity **144** |
| Slot open | designed-not-built count **0** |

**M0 token-fact shapes (on paper):**

| Memo prefix | Meaning |
|-------------|---------|
| `mala:mint` | Issuer creates units; credits holder |
| `mala:send` | Transfer; fold enforces conservation |

Reuses SLC-L1 `.bron` envelope + `receipt_core` + Kumara. **No new dependencies.**

**M1 scope:** one issuer, one holder, one node — mint, send, fold balance, verify; four unwelcome paths. Proposed `linengrow/mala.rye`, `tools/mala_m1_witness.rish`. **No code until Kaeden lap word.**

---

## SLC-L4 — Unchanged, Still Ruling-Gated

Active path: counsel [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md) — Curve25519 Pedersen + Sigma-protocol, zero new tool deps.

Lap-open [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md):

| Bound | Detail |
|-------|--------|
| Tiers | `1000`, `5000`, `10000` — **single declared-tier proof per proof** (not disjunctive OR) |
| Crypto | Pedersen + Sigma; `H` from pinned `fromUniform` domain separation |
| Witness | Offline; parity-eligible when green |
| Non-claim | Selftest honesty only; lightweight design review before lap finish |

Study [`223327`](../external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md) kept for Sui record; seam table updated to mark SLC-L3 removed.

---

## Six Open Points (`221612`) — Updated

| # | Status after `152612` |
|---|----------------------|
| 1 Settlement crown | **Moot** — Sui/Monad path removed |
| 2 Mainnet treasury | Separate custody event; MALA path replaces external-chain settlement |
| 3 SLC-L4 first | Donor-amount privacy; Zig-native `023112`/Sigma; waits lap word |
| 4 Realidream UI | Held — thin-demo exception named in TASKS |
| 5 Network-seam parity | **Resolved** — witnesses removed with settlement |
| 6 Grain-sketchbook | Closed shelf-only `222852` |

---

## Doorway Hygiene (bundled in this push)

| File | Fix |
|------|-----|
| `active-designing/20260708-182500_slcl3-settlement-rail.md` | Status names checkable room |
| `external-research/20260708-211637_…` | Status line added |
| `external-research/20260709-015832_…` | Status line; superseded pointer |
| `external-research/20260709-034527_…` | Status line; parity **197** |

---

## Files in This Push (excluded: `tools/bin/`)

| Category | Files |
|----------|-------|
| Counsel | `counsel/20260709-152612_…` |
| Removal | deleted settlement + chain-read tree; `tools/parity.rish`; hammock `182500` |
| MALA | `expanding-prompts/20260709-182354_…`; TASKS/ROADMAP |
| Claude brief | this file |
| Session logs | `155520`, `163549`, `171101`, `182051`, `182354` + README |
| Wiring | ZK study `223327`; SLC-L4 prompt `031612` reference fix |

---

## Path Forward — Two Lap-Open Briefs, One Word Each

| Lap | Brief | Waits |
|-----|-------|-------|
| **MALA M1** | `182354` | Kaeden lap word — **front per `152612`** |
| **SLC-L4** | `031612` | Kaeden lap word — donor-amount privacy |

Neither requires Claude ruling before `kg` once the word lands — scope is bounded in expanding prompts.

---

## Questions for Claude Review

1. **Removal vs supersede** — **Answered** [`225508`](../counsel/20260709-225508_grok-counsel-evening-close-leftovers.md): on-touch one-liner; no mass rewrite. Headers added on `015832` / `034527` this stamp.

2. **MALA M1 fact shapes** — **Answered** by M1 land + **K0** `225343`: memo prefixes through M3; K1 gated.

3. **Lap sequencing** — **Answered** by metal: MALA M1–M2b then SLC-L4 then WOV (parity **198→205**).

4. **Sigma single-tier proof** — **Answered** by lap 1 + W0 review [`224426`](../counsel/20260709-224426_grok-counsel-slcl4-w0-lap1-review.md).

5. **WOV timing** — **Answered** by path: WOV after M2; pin, seam A, dual D1 on metal.

6. **M0 functional spec** — **Answered** [`225508`](../counsel/20260709-225508_grok-counsel-evening-close-leftovers.md): `182354` + M1 green suffice; no separate M0 functional-spec file required.

---

*May the coin we mail need no stranger's agreement. May every removal leave its record honest, and every lap that opens find its scope already written.*
