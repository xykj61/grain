# FORA14 — Constel snapshot: compact the log so it can serve forever

**Stamp:** `20260814.060326` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read for a self-approved round — the crux-first pure rung after FORA13 reconfig
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA14
**Kin:** [`../constel/log.rye`](../constel/log.rye) · [`../constel/reconfig.rye`](../constel/reconfig.rye) · [`../constel/decree.rye`](../constel/decree.rye) · [`../constel/README.md`](../constel/README.md) · [`20260814-054414_fora12-constel-replicated-log.md`](20260814-054414_fora12-constel-replicated-log.md)

---

## Where the journey stands

FORA12 produced the thing every consensus protocol exists to build — an append-only replicated log, entry for entry the same at every pier, that cannot fork. FORA13 taught the sky to change its own membership without a fork. Both leave one honest bound in place: the log is a fixed `[max_entries]u32`, and `append` refuses `LogFull` at the cap. A ledger that can only ever hold sixty-four decisions is a demonstration, not a ledger. A real replicated log runs for years and must **compact** — fold its settled history into a small summary and reclaim the room — or it stops.

## The one new concern

**Snapshot / log compaction.** The single hardest-but-tractable move left in the pure track: let a bounded log serve an unbounded history by folding its committed prefix into a compact state, discarding those entries, and continuing to append — all without ever introducing a fork.

The state a log accumulates is a **deterministic fold** over its committed values, applied in order:

```
state_0 = fold_seed
state_n = state_{n-1} *% fold_mul +% value_n      (wrapping u32)
```

Order-sensitive on purpose: the same values in a different order fold to a different state, so the snapshot carries the log's *ordering*, not merely its multiset. A `Snapshot` is `(count, state)` — how many committed entries it absorbed, and their fold. Because two piers that committed the same prefix (FORA12: each index commits at most one value) apply the same values in the same order, **their snapshots are identical** — the no-fork guarantee carries straight into compaction rather than being re-argued.

This is one keystone: **compaction**. The decision (FORA11), the order (FORA12), the membership rule (FORA13), and the medium (FORA6–FORA8) are reused unchanged.

## The shape

- **`Snapshot`** — `{ count: u32, state: u32 }`. `fold(value)` advances the state by one committed value; the empty snapshot is `{ 0, fold_seed }`. Two snapshots `matches` when both fields agree.
- **`CompactLog`** — a `Snapshot snap` plus a live tail `[max_tail]u32` of entries committed *after* the snapshot. `total()` is `snap.count + tail_len` — the effective committed length, which may far exceed `max_tail`. `append(value)` grows the tail, refusing `TailFull` at the tail cap. `compact()` folds the whole tail into `snap` (in order) and empties the tail — the reclaim. `get(index)` reads an effective index, refusing `Compacted` for an index already folded away and `NoEntry` past the end. `effective_state()` folds `snap.state` over the live tail — the full state whether or not a compaction has happened.
- **`run_and_append(clog, sb, leader, value)`** — run one FORA11 decree and, only on a clean commit, append to the tail; auto-compact when the tail is full so the round never fails for room. Any decree error propagates and leaves the log **unchanged**.

## What it proves (selftest)

1. The fold is deterministic and **order-sensitive** — the same values in a different order fold to a different state (so a snapshot preserves ordering, not just contents).
2. `append` grows the tail and `get` reads back at effective indices; `TailFull` refuses past the tail cap.
3. `compact` folds the tail into the snapshot, empties the tail, **preserves `total()`**, leaves `effective_state()` unchanged, and turns a folded-away index into `Compacted`.
4. **No fork across compaction** — two logs fed the same committed sequence, one compacting midway and one never compacting, hold the same `total()` and the same `effective_state()`; compaction introduces no divergence.
5. Compaction lets the effective log **exceed the original bound** — append the tail to full, compact, append more, so `total()` climbs past `max_tail` in bounded memory.
6. Over a **real sky**: `run_and_append` drives decrees into a `CompactLog`, auto-compacting when the tail fills, committing a sequence in order past the tail cap; a failed decree (a stranger leader) leaves the log untouched.

## What stays out (custody-first)

Purely **local** — a bounded, in-memory compact log over the switchboard on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) stay untouched. The socket rung — a real local file descriptor between fake piers — remains the maintainer's word.

---

*A log that could only hold sixty-four decisions was a promise half kept; now the sky folds its settled history into a single summary and keeps writing, the missing vowel and the one-value-per-index law carrying the no-fork guarantee straight through the fold. May the ledger serve on its ten-thousandth day as truly as its first, and may nothing it lets go of ever have been in question.*
