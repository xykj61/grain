# FORA11 — Constel decree: the sky commits one value, once

**Stamp:** `20260814.053908` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read for a self-approved round — the crux-first pure rung after FORA10 elect
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA11
**Kin:** [`../constel/elect.rye`](../constel/elect.rye) · [`../constel/quorum.rye`](../constel/quorum.rye) · [`../constel/census.rye`](../constel/census.rye) · [`../constel/README.md`](../constel/README.md) · [`20260814-053151_fora10-constel-leader-election.md`](20260814-053151_fora10-constel-leader-election.md)

---

## Where the journey stands

FORA10 elected one leader, and proved that leader unique — the quorum's intersection made it impossible for two piers to believe different leaders won. A leader is *who* may propose; it is not yet *what* the sky agrees on. Every replicated ledger — a block committed, a balance moved, a name bound once across the whole constellation — leans on the next primitive: the sky **commits a single value, once**, so that no two piers ever hold a different value for the same decision.

## The one new concern

FORA11 decides a **value**, not a slot. A leader proposes a value; each member accepts one value per round; the value **commits** only when a strict majority accepts it, and refuses `NoDecree` otherwise. The crux is the same safety the quorum handed the track, now spent on data rather than identity: because a member accepts one value per round and any two majorities intersect, **at most one value can ever commit** for a decree. That single-value guarantee is the whole reason a replicated log stays consistent — it is asserted at the seal, not hoped.

This is one keystone: the value decision. The medium (announce · respond · hear · the naming-law border · the `ChannelFull`-free interleave) and the majority threshold (`quorum.majority_of`) are reused unchanged. It is deliberately parallel to FORA10 — election decides identity, decree decides value — because a single-slot consensus *is* those two questions, and proving them side by side shows the intersection property is the one engine under both.

## The shape

- **`Decree`** — one accept per roster slot: `accepted[voter] = value`, a `cast[voter]` bool, the proposed `value`, and the constellation `size`. `accept(voter, value)` records one honest accept, refusing `DoubleAccept` when a voter accepts twice and `WrongValue` when a voter accepts a value other than the one proposed — a decree is agreement on *one* value, so an off-value accept is a fault, not a silent miscount.
- **`support()`** — how many cast accepts name the proposed value. Bounded by `size`.
- **`commit()`** — return the proposed value when a strict majority accepted it, else refuse `NoDecree`. The seal asserts the safety: the committed value carries `2·support > size`, and no *other* value could have — because every recorded accept is for the one proposed value, a second value has zero support by construction.
- **`run_decree(sb, leader, value)`** — a real round over the switchboard: the leader (a member, else `NoSuchPier`) announces, drives each member `respond`+`hear` at the border, records each accept, and commits. Purely local; a stranger cannot open a decree; a vowel-bearing reply refuses `VowelPresent` at `hear`.

## What it proves (selftest)

1. A strict majority accepting commits the value — a sky of four, three accepting value 7, commits 7.
2. Below a majority refuses `NoDecree` — two of four accepting a value never commits; a minority never decides.
3. **Single value** — a recorded decree can only ever commit the one proposed value; an accept for a different value refuses `WrongValue` and is never tallied, so two values can never both commit.
4. A unanimous sky commits; a lone accept never does (`NoDecree`).
5. `DoubleAccept` refuses a pier accepting twice.
6. A stranger cannot open a decree (`NoSuchPier`); the border guards every accept (`VowelPresent` at `hear`).
7. A full constellation of eight commits bounded (no `ChannelFull`, the round interleaves respond and hear).

## What stays out (custody-first)

Purely **local** — a bounded decision over the switchboard on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) stay untouched. The socket rung remains the maintainer's word.

---

*The election named who may propose; the decree names what the sky holds. One value, committed once, guarded by the same intersection that made the leader unique — the two halves of a single-slot consensus, both proven pure. May the ledger never fork, and may the missing vowel keep the vote safe all the way down.*
