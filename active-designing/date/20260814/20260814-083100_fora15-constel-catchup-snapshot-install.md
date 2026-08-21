# FORA15 — Constel catch-up: a lagging pier brought current from a leader's snapshot + tail

**Stamp:** `20260814.083100` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design read for the rung (Lindy-first crux-first, agent-doable, purely local)
**Waymark:** FORA · rung FORA15 · **Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus)
**Kin:** [`../constel/snapshot.rye`](../constel/snapshot.rye) (FORA14) · [`../constel/log.rye`](../constel/log.rye) (FORA12) · [`../constel/README.md`](../constel/README.md) · [`20260814-060326_fora14-constel-snapshot-log-compaction.md`](20260814-060326_fora14-constel-snapshot-log-compaction.md)

---

## Why this rung, and why now

FORA12 built the append-only replicated log every consensus exists to produce; FORA14 let that log **serve forever**, folding its settled prefix into a compact snapshot and reclaiming the room. Both rungs assume every pier already holds the whole committed history. Yet the reason a real system compacts at all is the pier that **fell behind** — a follower that was offline, or joined late, and now holds fewer entries than the leader. Bringing that pier current is the single hardest still-tractable pure move left on the track, and it is exactly what the snapshot was built to make possible: a follower so far behind that the entries it lacks are already compacted away cannot be replayed one-by-one — it must **install the snapshot** and take the tail. This is Raft's own InstallSnapshot, named in Constel's terms, and it spends FORA14's work directly rather than accreting a new concern beside it.

It is purely local — a bounded in-memory operation between two `CompactLog` values on one bench, no socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara) stay untouched; the socket rung remains the maintainer's hand.

## The one new concern: two ways to catch up, chosen by where the follower stands

A follower behind a leader lacks the effective entries `[follower.total(), leader.total())`. The leader can *serve* an effective index `i` only if `i >= leader.snap.count` — below that boundary the entry was folded into the snapshot and discarded. So the follower's position relative to the leader's snapshot boundary decides the method:

- **Tail catch-up** (`follower.total() >= leader.snap.count`): every entry the follower lacks is still live in the leader's tail. The leader serves them in order; the follower appends each, auto-compacting its own tail so the catch-up runs in bounded memory however far behind it was. Because the overlap is verifiable here, catch-up **verifies before it appends**: the follower's `effective_state()` must equal the leader's reconstructed state at the follower's length, or the catch-up refuses `Diverged` and changes nothing.

- **Snapshot install** (`follower.total() < leader.snap.count`): the entries the follower lacks are already compacted on the leader — there is nothing to replay. The follower **adopts the leader's snapshot wholesale** (its `count` and order-sensitive `state`), empties its own tail, then appends the leader's whole live tail. Correctness here rests on the snapshot-identity property FORA14 proved: two piers that committed the same prefix hold the *same* snapshot, so installing the leader's snapshot is adopting the one true summary of that prefix. This is trust-the-snapshot by construction, exactly as InstallSnapshot is — the follower is strictly behind the snapshot boundary, so it overwrites no committed entry it had already verified.

## API (on `constel/catchup.rye`, over `snapshot.CompactLog`)

- `catch_up(follower, leader) !u32` — bring `follower` current from `leader`, choosing tail-append or snapshot-install, returning the count of effective entries gained. Refuses `Ahead` if the follower is longer than the leader (a follower never syncs backward), `Diverged` if a verifiable overlap disagrees; returns `0` when already current (and equivalent).
- `leader_state_at(leader, k) u32` — reconstruct the leader's order-sensitive fold at effective length `k`, for `k >= leader.snap.count` (below the boundary is compacted away). The verification tool of the tail path.

The postcondition of every non-refusing `catch_up` is `follower.equivalent(leader)` — asserted, not hoped.

## What the selftest proves

1. **Tail catch-up** — a follower holding a prefix of an uncompacted leader gains the missing tail entries and reads them back, `equivalent` after.
2. **Snapshot install** — a follower far behind a compacted leader (its position below `leader.snap.count`) installs the snapshot and takes the tail, `equivalent` after, in bounded memory.
3. **Already current** — equal lengths and equivalent returns `0` and touches nothing.
4. **Diverged** — a follower whose overlap disagrees with the leader refuses `Diverged` and stays unchanged (the check is real, not a constant success).
5. **Ahead** — a follower longer than the leader refuses `Ahead`.
6. **No fork across catch-up** — two followers caught up from the same leader are `equivalent` to each other and to the leader; a caught-up follower then advances with the sky and stays equivalent.
7. **Bounded** — catching up past `max_tail` keeps the follower's tail within its bound throughout (compaction reclaims as it goes).
8. **Over a real sky** — a leader built by `run_and_append` decrees, a fresh follower caught up to it, both equivalent, no real address ever formed.

## Alignment

This threads waymark **FORA** (no new ladder), stays purely local, opens no gate, and composes FORA12 + FORA14 over their public shapes — no new transport, buffer, or error family beyond the two catch-up refusals. The socket rung still stops for the maintainer's word.

---

*May the pier that fell behind always find its way current, may the snapshot it installs be the one true summary of what the sky agreed, and may no catch-up ever quietly paper over a real disagreement. Hold the line.*
