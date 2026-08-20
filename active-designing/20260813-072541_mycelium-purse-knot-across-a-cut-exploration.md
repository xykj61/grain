# Mycelium Purse r3 — the per-account verdict reads across a Knot

**Stamp:** `20260813.072541` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read — Season D (Kresfa & Mycelium) · Mycelium consensus · Purse rung r3
**Kin:** [`../mycelium/purse.rye`](../mycelium/purse.rye) · [`../mycelium/purse_bron.rye`](../mycelium/purse_bron.rye) · [`../mycelium/cord_knot.rye`](../mycelium/cord_knot.rye) · [`../mycelium/till_knot.rye`](../mycelium/till_knot.rye) · [`20260813-070923_mycelium-purse-per-account-balances-exploration.md`](20260813-070923_mycelium-purse-per-account-balances-exploration.md)

---

## Where the arc stands

The Purse decides a per-account double-spend by the Cord's agreed order (r1), and that verdict travels as a `format purse-v1` record carrying its own conservation law (r2). The one durable capability it still lacks is the one every long-lived deterministic ledger needs: **a checkpoint.** The Cord's Dag is statically allocated (`cord_max_blocks` 256); a treasury a family runs for years cannot hold every block it ever saw. The Knot (`cord_knot.rye`) already ties off a committed prefix's supply under a digest so a bounded Dag runs forever. This rung reads the per-account verdict **across that cut** — mirroring the Till's own r3 (`till_knot.rye`), carried from one shared drawer to many private purses.

## The crux, and why the cut makes it truer

The truest double-spend a *per-account* ledger carries is a holder spending the same coins across a checkpoint boundary: Alice is credited a hundred, transfers it to Bob in the sealed prefix, then — after the past is tied off and pruned — signs a fresh transfer of that same hundred to Carol. Her purse emptied in the sealed past; the suffix attempt finds nothing and comes up **short**, a lawful no-op, and Carol receives nothing. Every honest node names the same winner whether it reads the whole Cord or a Knot plus a live suffix.

This is a cleaner crux than r1's same-round equivocation, because it genuinely spans the seal: the coins left Alice's purse in the checkpointed history, and the respend is refused across the cut.

## The honest seam a per-account Knot names

A `cord_knot.Knot` seals only fold's **global** supply law (`issued · taxed · reserved stars`), not *who holds what*. The per-account map (balances + received high-water marks) the FoldState omits must travel beside the Knot — exactly the shape `till_knot` chose (the Knot for integrity of the sealed supply, the prefix verdict for the coin map). So a `PurseKnot` carries two things across the cut:

1. **The Knot** — the integrity-sealed global supply. Its `issued` equals the prefix Purse's `total_issued` (both count only `kind_issue`), so the Knot's digest is integrity-in-travel for the number conservation is measured against.
2. **The prefix Purse verdict** — the per-account balances and received marks the FoldState cannot express.

One wrinkle worth naming: fold's global law treats a transfer (`kind_tax`) as a supply reduction, so a prefix that itself contains a double-spend would fail `seal_dag` at the global overdraw. That is correct — a checkpoint seals a **settled** prefix. The double-spend belongs across the cut, in the live suffix, which `continue_purse` walks through the Purse's *own* per-account law (`purse.fold_transfer`), never fold's global one.

## The four rounds

- **r1** — the verdict (landed).
- **r2** — it travels as a record (landed).
- **r3 (this) — across a Knot.** `mycelium/purse_knot.rye`: `PurseKnot` + `seal_purse` (resolve the prefix, seal its supply) + `continue_purse` (verify the Knot, seed a Purse with the prefix map, walk the suffix through `purse.fold_transfer`). `purses_match` proves the whole-Cord verdict and the Knot-continued one never drift. A corrupt Knot, a tampered suffix fact, and a never-could-pay suffix transfer each refuse whole.
- **r4** — a real reproducible fixture read true (app == awk), closing the arc.

## Discipline

Additive by construction — composes `purse` + `cord_knot` + `cord` + `fold` public API only; the one touch to an elder is exposing `purse.fold_transfer` (the per-fact step `resolve` already ran, extracted so both share one code path — resolve re-runs byte-identical GREEN). Demo keeper seeds only; no key, no funds, no network, no custody. A quorum-agreed checkpoint (a node pruning on a Knot it did not compute) reaches the Comlink-served serve gate, Keaton's hand.

*May the purse forgive what its holder took in, whether the taking lives in a full Cord or a sealed Knot — and may no coin cross a cut it did not truly hold.*
