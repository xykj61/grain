# Jul 9 Evening Arc — Full Review Brief for Claude

**Stamp:** `20260709.015832`
**Voice:** Rio 3
**Editor:** Cursor (desktop) · **Model:** Composer 2.5
**Register:** Decision briefing — what landed after the iOS session handoff, what counsel answered, where the bench sits, what Kaeden and Claude should open next
**Status:** Checkable-room research — Claude review brief; superseded by [`034527`](20260709-034527_claude-review-brief-jul9-late-arc.md). **Implementation removed `152612`** (settlement / chain-read); this note is dated record.
**Ground:** `3630cb5` → `51b7c1e` on all four remotes; desktop Composer session Jul 8–9 2026

*Written for Claude counsel review.*

---

## Executive Landscape

The iOS session left parity **198** and SLC-L4 as design-only. The desktop evening arc **seated six open points** (`221612`), **pinned Sui ZK ground** for donor-amount privacy (`223327`), **closed grain-sketchbook shelf-only** (`222852`), **built and wired chain-read data seams** (bundle 40, already at `4b7ce20`), and **added commit-message mention hygiene** (`011912`). The bench is **between laps**: design ground for SLC-L4 is complete; **no SLC-L4 code** until Kaeden's lap word.

| Milestone | Stamp | Parity | Status |
|-----------|-------|--------|--------|
| Handoff summary | `3630cb5` | **198** | Session log only |
| Six open points counseled | `221612` | — | Seated in TASKS |
| ZK ground pin (donor-amount) | `223327` | — | Study only; `sui::groth16` |
| Sketchbook shelf-only | `222852` | — | Kaeden override; hold dir removed |
| Bundle 41 shipped | `de04722` | — | Counsel + study + wiring |
| memcpy mention hygiene | `011912` | — | Forward-only; no history rewrite |
| Log backlog + bundle 42 | `51b7c1e` | — | Four remotes aligned |

**Remote tip:** all four at **`51b7c1e`** after this brief's `go` pass.

---

## Commit Arc (`3630cb5` → `51b7c1e`)

| Commit | Summary |
|--------|---------|
| `3630cb5` | Jul 8 evening handoff session log |
| `de04722` | Bundle 41 — counsel `221612`, ZK study `223327`, sketchbook shelf, SLC-L4 hammock wiring, TASKS/ROADMAP |
| `51b7c1e` | memcpy mention hygiene `011912`; git-signing rule pair; Jul 8 log backlog (`224627`, `224900`, `012913`, `013817`) |

**Prior arc (already on remotes before handoff):**

| Commit | Summary |
|--------|---------|
| `59631ac` | Chain-read POSIX seams — live verified testnet |
| `ed5822f` | `ensure_grpcurl.sh` bootstrap |
| `4b7ce20` | Native hosts + witness split (`chain_read_*`) |

---

## Six Open Points — Answered (`221612`)

Source: [`counsel/20260708-221612_claude-counsel-six-open-points.md`](../counsel/20260708-221612_claude-counsel-six-open-points.md)

| # | Question | Answer seated |
|---|----------|---------------|
| 1 | Settlement-seat crown | **Deferred** until mainnet — both-GREEN proves viability, not preference |
| 2 | Mainnet treasury | **Separate custody event** — Kaeden word + `settlement_core` scrutiny + legal/tax counsel; testnet trial period first |
| 3 | SLC-L4 first pass | **Donor-amount privacy**; ZK pin `223327` (`sui::groth16` + Circom threshold); zkLogin/Seal/Nautilus out of v1; **lap still Kaeden-gated** |
| 4 | Realidream viewer UI | **Still held** — data seams remove future blocker; Pond/Dexter gates unchanged |
| 5 | Network-seam parity | **Do not wire** `chain_read_*_witness` into `parity.rish` — on-demand category only |
| 6 | Grain-sketchbook | **Closed shelf-only** (`222852`) — single `gratitude/grain-sketchbook.md`; archive outside tree |

---

## ZK Ground Pin (`223327`)

**Study:** [`external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md`](../external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md)

| Pin | Detail |
|-----|--------|
| On-chain verify | `sui::groth16` — BN254 or BLS12-381 |
| Circuit shape | Circom threshold — private amount, public policy flag + binding digests |
| Scoped out of v1 | zkLogin (auth), Seal (encryption), Nautilus (TEE) |
| Receipt | `.bron` fields in hammock `194500` — `curve`, `vk_id`, `proof`, `public_inputs` (≤8) |
| Seam family | POSIX external interpreter — same as SLC-L3 lanes |

**Status:** study complete; build waits on Kaeden lap word.

---

## Chain-Read Data Seams (Realidream prep)

| Entry | Command |
|-------|---------|
| Monad host | `rishi/bin/rishi run tools/chain_read_monad.rish <tx_hash>` |
| Sui host | `rishi/bin/rishi run tools/chain_read_sui.rish <digest>` |
| Witnesses | `chain_read_*_witness.rish` — on demand, **not** in parity |

Live GREEN on metal `211637`; Sui needs `grpcurl` (`tools/ensure_grpcurl.sh`).

---

## memcpy Mention Hygiene (`011912`)

GitHub linkifies `@memcpy` in commit subjects (real unrelated account). Notifications removed Nov 2025 — cosmetic only. **No history rewrite.** Forward rule in `.claude/rules/git-signing.md` + new `.cursor/rules/git-signing.mdc`: no bare `@builtin` in commit subject/body; file content keeps `` `@memcpy` ``.

---

## Parity and Witness State

| Witness | Parity | Notes |
|---------|--------|-------|
| Full suite | **198** | SLC-L3 two-lane settlement included |
| Identity | **197** | PUBKEYS template + context fallback |
| Chain-read | — | On-demand only per `221612` point 5 |

---

## Bench Position — What to Open (Composer recommendation)

Kaeden asked: prioritize **A** (SLC-L4 backend), **B** (Realidream frontend), or **C** (codebase on-touch)?

**Composer recommendation: A's backend** — with immediate step = **Claude implementation-shape ruling + Kaeden lap word**, not circuit code yet.

| Path | Verdict |
|------|---------|
| **A — SLC-L4 donor-amount privacy** | **Strategic priority** — named next Linengrow whole; ZK pin done; extends SLC-L3 |
| **B — Realidream receipt viewer** | **Held** per counsel `221612` point 4; data seams ready; Pond/Dexter gates first |
| **C — On-touch hygiene** | **Opportunistic** — between laps; not season front |

Realidream ladder: rung 1 (SLC-2a drawn terminal) active; rungs 2–3 held; rung 4 horizon.

---

## What Is Not a Gate (unchanged)

| Item | Shape |
|------|-------|
| Agent-writing paste | Awaiting paste |
| Snapshot lap 4 | Kaeden's hands |
| MALA graduation | Trigger decides |
| Own MALA L1 / WOV L2 | Horizon 3 |
| Mainnet treasury | Custody event — not bench work |
| Settlement crown in prose | Mainnet-gated |

---

## Questions for Claude Review

*Several iOS-brief questions are now answered in `221612`; these are the live ones.*

1. **SLC-L4 implementation shape** — Donor-amount privacy is sequenced first; ZK pin names `sui::groth16` + Circom threshold. What should the first witness lap prove? Circuit fields, `.bron` receipt, prover POSIX seam, and parity policy (fixture-only vs on-demand chain verify)?

2. **Lap-open brief** — What belongs in the active-designing scope note and expanding-prompt before Cursor's first `kg` pass once Kaeden gives lap word?

3. **Realidream vs SLC-L4 ordering** — Composer prioritized A over B. Does counsel agree, or is a thin SLC-L3 receipt demo (chain-read + Skate, no Dexter graduation) worth a scoped exception?

4. **Settlement-seat crown** — Still deferred until mainnet per `221612`. Anything to add before that event?

5. **Testnet operations trial** — Counsel recommends real asks on testnet before mainnet. Shape of that trial as engineering work vs operational practice?

---

## Desktop Pass (this `go`)

Filed this brief; session logs for landscape read and full summary; push all four remotes.

*May the next lap open on ground already pinned, and may the proof stay verifiable without betraying what it protects.*
