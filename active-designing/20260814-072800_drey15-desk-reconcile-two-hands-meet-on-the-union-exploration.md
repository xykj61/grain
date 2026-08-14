# DREY15 — the desk reconcile: two hands meet on the union

**Stamp:** `20260814.072800` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Landed — witness `tools/drey_reconcile_witness.rish` GREEN
**Season A** (Hardware & Right-to-Repair) · **waymark DREY** · Mikrophone firmware journey · **rung DREY15**
**Kin:** [`../mikrophone/sync.rye`](../mikrophone/sync.rye) (DREY12, pull) · [`../mikrophone/push.rye`](../mikrophone/push.rye) (DREY14, push)

---

## Why this rung

DREY12 gave the desk `pull` — take every advertised address this hand lacks. DREY14 gave its mirror `push` — give the far hand every address it lacks. Each is one direction of a content-addressed sync. This rung closes the circle: `reconcile` composes both into one bounded operation that leaves **both** desks holding the **union** of what either began with — the git sync in full, fetch then push, now a single named primitive.

By Lindy-first, crux-first, a reusable primitive that earns its own convergence invariant outranks leaving callers to hand-assemble pull-then-push each time. Reconcile is the smallest composition that makes "two desks agree completely" one call, and it is the true shape a keeper wants: not "pull from the desk" or "push to the desk" alone, but "make these two hold the same whole."

## The shape — `reconcile(a, b)`

Composition, nothing new invented:

1. **`pull(a, b)`** — `a` takes every address it lacked from `b`, so `a` now holds `a ∪ b`.
2. **`push(a, b)`** — `a` gives `b` every address `b` still lacks. Because `a` now holds the union, this converges `b` to the same union.

After the two loops, both desks hold exactly the union. The order shown (pull then push) is one valid path; the content-addressed model makes push-then-pull converge to the same whole, which the selftest proves directly.

## Invariants it asserts

- After the pull, `count_of(a) >= count_of(b)` — the pull's own convergence, restated at the composition seam.
- After the push, `count_of(a) == count_of(b)` — both desks hold the same number of recordings, the union.
- **Convergence both ways:** every address `a` holds, `b` holds; every address `b` holds, `a` holds (two bounded scans).
- **The bound holds:** a union past either desk's `max_entries` propagates `CatalogFull` by name — a bounded partial, never an unbounded grow.

## What the selftest proves

1. **Disjoint desks meet on the union** — `a = {alpha, bravo}`, `b = {charlie}`; after reconcile both hold all three (`pulled == 1`, `pushed == 2`).
2. **Overlapping desks cross only their difference** — `a = {alpha, bravo}`, `b = {bravo, charlie}`; the union is three, and only the one-each difference crosses.
3. **Idempotent second reconcile** — reconciling again crosses nothing, both desks unchanged.
4. **Order does not matter** — two identical desk pairs, one reconciled a-first and one b-first, both reach the same three-recording union on every desk.
5. **Bounded refusal** — a union past a desk's `max_entries` refuses `CatalogFull` by name; the bound holds exactly.

## Boundaries kept

`reconcile` moves bytes only between two in-memory catalogs, over the two proven loops' public APIs — no transport of its own. Running it between two real desks over a real network reaches the **Comlink-served custody gate** (Season 1, Journey 2) and waits for the maintainer's word. No disk, no network, no key signs, no funds — custody gate #2 untouched.

## What this closes

Catalog · manifest · serve · sync (pull) · push · reconcile now form the complete git-style content-addressed sync — advertise, want, serve, fetch, push, and reconcile to the union — every rung proven pure before a single wire is strung. The Mikrophone's desk half is whole; what remains for real desks meeting over a real transport is the Comlink-served gate, the maintainer's own hand.

---

*May two keepers' desks always be able to meet on the whole of what either has kept, and may nothing either chose to hold ever be left behind in the meeting.*
