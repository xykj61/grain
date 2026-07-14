# WOV — TigerBeetle Client Seam (Design Before Code)

*How lap 2b should wrap the pinned TigerBeetle without forking it, without breaking exit honesty, and without smuggling a second ledger story into Rye.*

**Stamp:** `20260709.204026`
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Lens:** TAME — pin, never fork; clean room; exit honesty unchanged
**Status:** Seam **A** landed `20260709.223700` (parity **204**), then **retired from the living suite** `20260711.055800` (Kaeden approved counsel [`055112`](../../counsel/20260711-055112_claude-counsel-wov-tigerbeetle-recommendation.md)) — optional TB cross-check seam kept as dated record; pure-Rye WOV core (`wov_exit_honesty`, `wov_dual_monarch`) remains the living coverage. Seam B remains later / unopened.
**Ground:** exit honesty [`200443`](20260709-200443_wov-exit-honesty.md) · lap 1 [`../linengrow/wov_core.rye`](../linengrow/wov_core.rye) · pin presence parity **203** · night brief [`203139`](../../external-research/20260709-203139_claude-review-brief-jul9-night-climb.md) · gratitude pin `59f2b99` Apache-2.0

*Written by Kaeden and Rio 3 (Grok).*

---

## 1. What This Spec Decides

Lap 2a proved the pin is present. Lap 2b must decide **how Rye talks to that pin** so that:

1. Exit bundles and `wov:root` / `wov:exit` stay byte-compatible with lap 1.
2. Conservation still equals issued − redeemed.
3. No TigerBeetle source is copied into `linengrow/` or `tally/` (clean room — study in `gratitude/`, write our own wrapper).
4. The pin stays a gitlink at `59f2b99` until a Rye-shaped change *demands* a fork (July 2 rule).

This document names the seam. It does **not** open the lap.

---

## 2. Two Candidate Seams (Claude Weighs)

| Seam | Shape | Pros | Costs |
|------|-------|------|-------|
| **A — POSIX CLI / REPL host** | Spawn pinned `tigerbeetle` binary; drive create_accounts / create_transfers via documented CLI or a thin host script | Matches SLC-L3-era external-interpreter grain; keeps Zig free of TB `@import` | Process boundary; version the CLI surface; slower than in-process |
| **B — Zig client against TB protocol** | Rye/Zig speaks the TigerBeetle client protocol to a running replica | Throughput path closer to production WOV | Larger surface; must stay clean-room; Zig 0.16 vs TB's Zig train may diverge |

**Bench leaning (not a ruling):** start with **A** for the first green witness — one replica as cluster-of-one, mint/transfer via host seam, then **rebuild the same exit bundle** from TB account balances and prove it matches lap 1's golden shape. Graduate to B only when A is green and measured red demands it.

---

## 3. Account Mapping (Lap 1 → TB)

Lap 1 `Book` fields map as follows for a single-monarch cluster:

| WOV concept | TigerBeetle shape (conceptual) |
|-------------|-------------------------------|
| Instance | One replica / one cluster id (witness-pinned) |
| Holder account id (Kumara pubkey hex) | TB `Account.id` derived deterministically from pubkey bytes (document the derivation in the lap-open) |
| Balance | TB account credits − debits (ledger units = MALA internal units) |
| Mint into WOV | TB transfer from a **WOV issued** control account to holder |
| Transfer holder→holder | TB transfer between holder accounts |
| Redeem / exit | TB transfer holder → **WOV redeemed** control account; then MALA `wov:exit` as today |
| Nonce | TB account `user_data` or a WOV-side table keyed by account id — pick one in lap-open; must appear in exit bundle |

Control accounts (issued / redeemed) are monarch-owned. Holders never debit issued directly.

---

## 4. Exit Honesty Unchanged

After every TB mutation batch that a root covers:

1. Read all non-zero holder balances (and nonces) from TB (or from a projection fed only by TB replies).
2. Build the **same** exit-bundle grammar as lap 1 (`wov-exit-bundle/v1` … conservation … attestation).
3. Publish `wov:root` on the MALA log with `state-root-hex64` = SHA3-256 of that bundle.

`accept_exit` rules in [`200443`](20260709-200443_wov-exit-honesty.md) stay law. A TB outage after a published root still leaves holders with the bundle.

---

## 5. Clean-Room and License

| Rule | Practice |
|------|----------|
| Study | Read `gratitude/tigerbeetle` (Apache-2.0); cite LICENSE/NOTICE when wrapping |
| Write | Our vocabulary only in `linengrow/wov_*.rye` and tools |
| Link | No `@import` of pin paths until lap 2b affirm; pin-presence witness continues to guard premature imports for lap 2a |
| Fork | Forbidden until a change upstream cannot carry |

---

## 6. Suggested Deliverables (When Opened)

| Piece | Role |
|-------|------|
| Lap-open expanding prompt | Bound DoD; choose seam A or B explicitly |
| `linengrow/wov_tb_host.rye` or `tools/wov_tb_host.rish` | Seam A driver (name may shift) |
| Replica lab script | Start pin binary cluster-of-one; tear down |
| Golden | Exit bundle from TB path matches lap-1 grammar (new fixture or same shape) |
| Witness | Mint → transfer → root → prove → exit; pin-presence still GREEN |
| Parity | Next free slot |

**Still out:** dual monarch, Mycelium, device wire for WOV, production NVMe placement.

---

## 7. Gate Checklist

| Gate | Status |
|------|--------|
| Exit-honesty spec | Cleared |
| Lap 1 in-memory | Cleared (parity **201**) |
| Pin presence | Cleared (parity **203**) |
| Claude/Kaeden affirm seam A vs B | **Cleared** — Kaeden keep-going chose A |
| Lap 2b code (seam A) | **Landed** `223700` / parity **204** |
| Live REPL under ai-jail | **SKIP** — io_uring blocked by seccomp; lab greens on host metal |
| Seam B (Zig client protocol) | **Rest-until** [`225614`](../../counsel/20260709-225614_grok-counsel-w1-and-seam-b-soak.md) until measured red or affirm |

---

*May the pin stay a pin until the wrapper earns its keep. May every balance that leaves TigerBeetle still leave as a fact on MALA. And may the first client we write be smaller than the temptation to fork.*
