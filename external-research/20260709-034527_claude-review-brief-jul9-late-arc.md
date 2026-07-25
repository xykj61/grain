# Jul 9 Late Arc — Full Review Brief for Claude

**Stamp:** `20260709.034527`
**Voice:** Rio 3
**Editor:** Cursor (desktop) · **Model:** Composer 2.5
**Register:** Decision briefing — full arc through Zig-native SLC-L4 correction, lap-open prompt filed, MALA realignment
**Status:** Checkable-room research — Claude review brief; superseded by [`183326`](20260709-183326_claude-review-brief-jul9-evening-close.md). **Implementation removed `152612`** (settlement / chain-read); this note is dated record.
**Ground:** `bc97a93` → `e633386` on all four remotes; supersedes [`20260709-015832`](20260709-015832_claude-review-brief-jul9-evening-arc.md) for Claude analysis

*Written for Claude counsel review.*

---

## Executive Landscape

Parity **197** after SLC-L3 removal. SLC-L4 moved from design-only + Sui Groth16 pin (`223327`) through a **brief Circom detour** (`021112`, commit `9900aef`) to a **corrected Zig-native path** (`023112`, commit `e633386`). **Lap-open expanding prompt `031612` is filed and ready** — no code until Kaeden's lap word. Kaeden's **testnet → low-value → third-party audit** sequencing is affirmed and answers prior protocol-risk counsel.

| Milestone | Stamp | Parity | Status |
|-----------|-------|--------|--------|
| Jul 9 evening brief | `015832` | **198** | Superseded by this brief |
| Circom path counsel (detour) | `021112` | — | Dated artifact; superseded for implementation |
| Zig-native path counsel | `023112` | — | **Active** implementation direction |
| Lap-open expanding prompt | `031612` | — | Ready on lap word |
| Bundle 44 shipped | `e633386` | — | TASKS/ROADMAP/hammock corrected |

**Remote tip:** all four at **`e633386`**.

---

## Commit Arc (`bc97a93` → `e633386`)

| Commit | Summary |
|--------|---------|
| `9900aef` | **Superseded** — Circom/Groth16 path counsel `021112`; thin Realidream demo named |
| `e633386` | **Current** — Zig-native Sigma path `023112`; lap prompt `031612`; removes bundle 43 logs; hammock + study wiring |

**Earlier Jul 9 (still on remotes):**

| Commit | Summary |
|--------|---------|
| `bc97a93` | Claude review brief `015832` + landscape log |
| `51b7c1e` | memcpy hygiene `011912` + log backlog |
| `de04722` | Bundle 41 — six points `221612`, ZK study `223327`, sketchbook shelf |

---

## The Correction — Why Groth16/Circom Was Ruled Out

Counsel `023112` checked **vendored Zig 0.16 stdlib directly**:

| Finding | Consequence |
|---------|-------------|
| `std.crypto.pcurves` = P256, P384, secp256k1 only | No pairing-friendly curves |
| No pairing anywhere in crypto tree | **Groth16 impossible Zig-native** without building full pairing stack |
| `Edwards25519.mulDoubleBasePublic` | Pedersen commitment `amount·G + blinding·H` in one op |
| SHA3 Fiat-Shamir | Sigma-protocol threshold proof — no trusted setup |

Study [`223327`](../external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md) **kept for Sui on-chain record**; **superseded for Zig-only implementation**.

Counsel [`021112`](../counsel/20260709-021112_claude-counsel-slcl4-top-recommended-path.md) remains dated artifact (circomlib installed on bench); **do not implement from it**.

---

## Active Implementation Path (`023112` + `031612`)

### Lap 1 scope (expanding prompt)

**File:** [`expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md)

| Bound | Detail |
|-------|--------|
| Tiers | `1000`, `5000`, `10000` smallest units — **disjunctive** tier membership, not arbitrary range |
| Crypto | Pedersen + Sigma; `H` from `fromUniform` on pinned domain-separation bytes |
| Dependencies | **Zero new** — Edwards25519 + SHA3 only |
| Receipt | `.bron`: `claim`, `log_digest`, `commitment`, `tier_claimed`, `proof`, `stamp` |
| Witness | Offline prove+verify; welcome (3 tiers) + unwelcome (forged + wrong tier) |
| Parity | **Fully eligible** once green — deterministic, no network |
| Proposed modules | `linengrow/disclosure_core.rye`; maybe `tally/pedersen.rye` |

### Explicit non-claims

- Lap proves **selftest correctness only** — not adversarial protocol soundness
- Kaeden's **testnet-then-audit** plan supplies external scrutiny later
- Live Sui verify stays on-demand, after offline half lands
- Arbitrary-range proofs = separate harder lap

---

## Six Open Points (`221612`) — Still Seated

| # | Answer | Notes |
|---|--------|-------|
| 1 | Settlement crown deferred | Until mainnet |
| 2 | Mainnet treasury | Separate custody event + legal counsel |
| 3 | SLC-L4 first | Donor-amount privacy; **path now `023112`/Sigma** |
| 4 | Realidream UI | Held — Pond/Dexter gate |
| 5 | Network-seam parity | Do not wire `chain_read_*` |
| 6 | Grain-sketchbook | Shelf-only `222852` |

**Thin-demo exception** named in TASKS (`021112` row): chain-read render through SLC-2a drawn terminal only — parallel to SLC-L4 backend if it stays thin.

---

## MALA / WOV (Horizon 3)

Weave already = signed append-only ledger (Kumara/Ed25519). Own L1 adds **consensus among distrusting parties** — language-independent hard problem. **Kaeden sequencing affirmed:** testnet, low-value demos, third-party security audit before real value. Horizon 3 hold unchanged; reasoning updated.

---

## Parity and Witness State

| Witness | Parity | Category |
|---------|--------|----------|
| Full suite | **198** | Always-green |
| SLC-L3 settlement | **198** | In parity |
| Chain-read | — | On-demand only |
| SLC-L4 Sigma (future) | **199** (proposed) | Parity-eligible when lap lands |

---

## Local Untracked (excluded from commits)

| Path | Why |
|------|-----|
| `tools/fixtures/slcl4/` | Orphaned Circom artifacts from superseded `021112` path |
| `tools/bin/` | Standing exclude |

---

## Path Forward

1. Kaeden gives **lap word**
2. Cursor **`kg`** against expanding prompt `031612` — scope fully bounded
3. Wire parity **199** when witness GREEN
4. No Claude ruling required before `kg` — prompt is complete

---

## Questions for Claude Review

1. **Sigma-protocol shape** — Is disjunctive fixed-tier membership the right first lap, or should the three tiers use three separate proof templates?

2. **Generator pinning** — Any counsel on domain-separation string for `H` derivation and startup assertion pattern?

3. **Protocol-design review timing** — When in the testnet-then-audit sequence should external crypto review of the Sigma construction happen relative to parity **199** landing?

4. **Thin Realidream demo** — Does counsel `221612` point 4 still hold given the named thin-demo exception in TASKS?

5. **Study `223327` + live Sui** — After offline lap lands, is optional on-demand `sui::groth16` verify worth a later lap, or permanently out for Zig-only policy?

---

*May the corrected path be named as plainly as the gap that required it. May the lap that opens find its scope already written, and may nothing a green selftest earns be quietly borrowed against an audit still to come.*
