# FORA24 — Constel tenure: a leader holds its title only while a majority answers

**Stamp:** `20260814.084900` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **waymark** FORA · **rung** FORA24
**Kin:** [`../constel/read.rye`](../constel/read.rye) (FORA20) · [`../constel/prevote.rye`](../constel/prevote.rye) (FORA22) · [`../constel/transfer.rye`](../constel/transfer.rye) (FORA23) · [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9)

---

## The rung

FORA20 proved a linearizable read that refuses to serve from a deposed leader — a **reactive** guard: a stale leader is caught the moment it tries to confirm leadership for a read. This rung adds the **proactive** half, Raft's **CheckQuorum** (§6.2 / §9.6): a leader that can no longer reach a majority steps *down* to follower on its own, without waiting for a read to expose it.

## The gap it closes

A leader partitioned into a minority keeps believing it leads. It cannot commit — the majority is elsewhere — yet it lingers, holding a title the sky has moved past, and under a lease-based read scheme it could even serve a stale value. CheckQuorum is the fix: each election-timeout window the leader counts how many piers **answered** its heartbeats, always counting itself. If that **backing** falls below the majority threshold, the leader relinquishes leadership. So a minority-partition leader stops leading promptly, and the majority partition's own election is never shadowed by a ghost leader that thinks it still rules.

## Where it sits in the family

CheckQuorum is the natural companion to the two rungs just before it:

- **FORA22 (pre-vote)** keeps a *rejoining* node from disrupting a healthy leader.
- **FORA24 (CheckQuorum)** keeps an *isolated* leader from lingering.
- **FORA23 (transfer)** hands off leadership on purpose.

Together the sky neither disrupts a good leader nor clings to a stranded one — and CheckQuorum + the FORA20 read-index guard the same stale-read hazard from both sides: the leader steps down proactively, and any read it might still attempt is refused reactively.

## The shape

`backing(acks)` counts the leader itself plus every peer that answered (`acks` is one flag per *other* pier, the roster minus the leader). `still_commands(acks, threshold)` is `backing ≥ threshold`; `should_step_down` is its exact inverse. The threshold is the same `quorum.majority_of` that made the leader unique at election — now measured against who still answers. Everything is bounded to `roster.max_piers`.

## What it is not

Purely local — bounded per-peer ack flags and a count on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. A served heartbeat reaches the Comlink-served gate; the socket rung stays the maintainer's hand (custody gate #2 / #4 untouched).

## Witness

`tools/fora_tenure_witness.rish` — builds, runs the selftest, asserts the GREEN line: backing counts self plus acks; a leader hearing a majority still commands and one that does not steps down; the minority-partition leader steps down while the majority partition's leader commands; the boundary is exact at the threshold; a lone or fully-connected leader behaves; bounded over a full roster.

---

*Stamp note: the live host clock read `20260814.072016` EDT, earlier than the prior newest `.084700`; following the ladder's established convention, the one-clock monotonic law is honored by stamping `.084900`, just after the work it follows, with the real reading recorded here.*
