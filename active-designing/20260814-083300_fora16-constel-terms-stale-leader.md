# FORA16 — Constel terms: leadership made safe across re-election (an old leader can't commit)

**Stamp:** `20260814.083300` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design read for the rung (Lindy-first crux-first, agent-doable, purely local)
**Waymark:** FORA · rung FORA16 · **Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus)
**Kin:** [`../constel/elect.rye`](../constel/elect.rye) (FORA10) · [`../constel/decree.rye`](../constel/decree.rye) (FORA11) · [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9) · [`../constel/README.md`](../constel/README.md)

---

## Why this rung, and why now

Every rung from FORA10 on assumes **one stable leader** — FORA10 elects a leader once, FORA11 lets that leader commit values, FORA12 orders them into a log. Yet a real network re-elects: a leader crashes, a partition heals, a new leader rises. The single hardest safety question a consensus protocol answers is what happens to the **old** leader — the one that was elected, then superseded, yet still believes it leads and tries to commit. Without a defense, that stale leader could commit a value the sky has already moved past, and the ledger forks in time rather than in space. This rung takes that one concern: a **term** — a monotonic logical clock on leadership — so that *an old leader can never commit.* It is the pure crux that makes the whole elect·decree·log stack safe under repeated leadership, and it composes FORA9's intersection lemma with FORA11's decree rather than adding a new medium.

Purely local — a bounded in-memory term table and a decree guarded by it, no socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 and gate #4 stay untouched; the socket rung remains the maintainer's hand.

## The one new concern: a monotonic term, and the stale-leader refusal

A **term** is a `u32` that only ever climbs. Every pier tracks the highest term it has seen (`current`, ground term `0` before any leader). A leader is elected *for a term*, and a decree carries *its* term. The rule is one line, and it is the whole safety:

- A voter whose `current` term is **greater** than a decree's term refuses `StaleTerm` — it has already moved to a newer leader, so it will not lend its vote to an older one.
- A voter whose `current` term is **at or below** the decree's term adopts the decree's term (monotonically — it never moves backward) and accepts as in FORA11.

The safety follows directly from FORA9's intersection lemma. Once a **strict majority** has advanced to term `T` (which is exactly what electing a leader in term `T` does), any decree in a term `< T` can gather accepts from **at most the minority** that has not yet advanced — below the threshold — so it can never commit. Two majorities intersect; the majority that moved to `T` is disjoint-in-vote from any stale decree, so the stale decree is starved. The old leader is not forbidden by fiat; it is out-voted by construction.

## API (on `constel/term.rye`)

- `TermTable` — a bounded `[max_piers]u32` of each slot's current term. `current(slot)`; `observe(slot, t)` advances to `max(current, t)` and returns whether it moved (monotonic — never lowers); `at_least(t)` counts slots at term ≥ `t` (the majority argument, made countable).
- `TermedDecree` — an FORA11 `Decree` plus its `term`. `accept(terms, voter, value)` refuses `StaleTerm` if the voter has moved on, else adopts the term and records the accept (inheriting `DoubleAccept` / `WrongValue`); `support`; `commit` (majority ⇒ value, else `NoDecree`).
- `run_termed_decree(sb, terms, leader, term, value)` — the whole round over the switchboard: announce, then each member responds+hears at the naming-law border and attempts a termed accept; a `StaleTerm` member is simply **not gathered** (the round continues), a real fault still surfaces; commit reflects only the up-to-date majority.

## What the selftest proves

1. **Monotonic** — `observe` advances a term up and never down; a lower observe is a no-op; `current` reads back.
2. **Ground commit** — a fresh termed decree in term 1 with every pier at ground commits (all adopt term 1).
3. **StaleTerm** — a voter already at a higher term refuses a lower-term accept, its vote not recorded.
4. **An old leader can't commit (pure value)** — a term-1 decree commits over a sky of four; a majority then advances to term 2; the old term-1 leader now gathers only its own vote (the others refuse `StaleTerm`) and refuses `NoDecree`, while the new term-2 leader commits.
5. **An old leader can't commit (real sky)** — the same story driven over the switchboard through real announce/respond/hear, the border guarding every accept.
6. **Bounded** — a full constellation of eight runs a termed decree bounded.

## Alignment

Threads waymark **FORA** (no new ladder), purely local, opens no gate, composes FORA9 + FORA11 over their public shapes with one new error (`StaleTerm`) and one new bounded table. The socket rung still stops for the maintainer's word.

---

*May every leader know its season, may the one that has passed step aside without a fork, and may the term that names the sky's true leader only ever climb. Hold the line.*
