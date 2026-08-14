# FORA25 — Constel learner: a new member joins non-voting, catches up, then earns the vote

**Stamp:** `20260814.073705` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **waymark** FORA · **rung** FORA25
**Kin:** [`../constel/reconfig.rye`](../constel/reconfig.rye) (FORA13) · [`../constel/catchup.rye`](../constel/catchup.rye) (FORA15) · [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9) · [`../constel/roster.rye`](../constel/roster.rye) (FORA1)

---

## The rung

FORA13 (reconfig) proved the safe way to **change** who votes — a joint-consensus step where the union of the old and new configs must both agree. This rung proves the safe way to **add** a member in the first place: bring it in as a non-voting **learner** (Raft, Ongaro thesis §4.2.1, "catching up new servers"), let it replicate and apply the log out of the critical path, and admit it to the voting set only once it is caught up.

## The gap it closes

A brand-new member's log is empty. If it joins straight as a **voter**, it immediately enlarges the majority the leader must reach for every commit — yet it cannot ack the entries it does not yet hold. So while a fresh voter catches up, the cluster spends its spare fault tolerance on a member that answers nothing: a single slow or partitioned old voter is now enough to **stall** commits. Raft's fix is the learner. The new member replicates and applies the log like a follower, but the voter majority does not grow and its ack never counts toward commit, so availability is untouched while it catches up. Once its match index sits within a bounded lag of the leader's commit, it is safe to **promote** to a full voter.

## Where it sits in the family

The learner is the staging role between two rungs already proven:

- **FORA15 (catchup)** carries a lagging log forward — the mechanism a learner runs while it is non-voting.
- **FORA25 (learner)** is the role a member lives in *during* that catch-up: present, replicating, counting toward nothing.
- **FORA13 (reconfig)** admits the member to the vote — and now has a predicate (`may_promote`) to consult so it never enlarges the vote with an empty replica.

## The shape

`voter_count(roles)` counts the voters among the membership (`roles` is one flag per member — true for a voter, false for a learner); `voter_majority(roles)` draws `quorum.majority_of` over that count alone, so a learner never raises the bar. `ack_counts(roles, slot)` and `commit_backing(roles, acks)` skip a learner's ack, so an empty replica can never be mistaken for backing a commit. `caught_up(learner_match, leader_commit, lag_bound)` measures the lag in `u64` so a far-ahead leader never wraps; `may_promote` is its predicate and `require_caught_up` its guarded form, refusing `NotCaughtUp` until the learner's match is within the bound. Everything is bounded to `roster.max_piers`.

## The crux, proven

A healthy three-voter sky (majority 2) tolerates one slow voter. A brand-new empty member arrives while one old voter is partitioned away:

- **As a voter (the wrong way):** the config is now four voters, majority 3. The partitioned old voter answers nothing, and the new voter's log is empty so it cannot ack the latest entry — only the leader and one other old voter ack. Backing 2 of a threshold 3: the entry **cannot commit**. Adding the voter stalled the cluster.
- **As a learner (the right way):** the voter set is unchanged at three, majority 2. The same one old voter is partitioned — yet the leader and one other old voter still make a majority. The entry **commits**. The learner catches up out of the critical path; only once caught up is it promoted.

## What it does not touch

Purely local — bounded per-pier role flags and index scalars on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed (custody gate #2 — real hardware / any real wire — and gate #4 — real Kumara — both untouched).
