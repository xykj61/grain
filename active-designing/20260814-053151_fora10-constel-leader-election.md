# FORA10 — Constel leader election: the majority decides one leader

**Stamp:** `20260814.053151` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read for a self-approved round — the crux-first pure rung after FORA9 quorum
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA10
**Kin:** [`../constel/quorum.rye`](../constel/quorum.rye) · [`../constel/census.rye`](../constel/census.rye) · [`../constel/README.md`](../constel/README.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md)

---

## Where the journey stands

FORA9 answered one bounded question — **may a majority act at all?** It turned a census tally into a strict-majority decision (`majority_of(n) = n/2 + 1`) and proved the one property the whole track rests on: `2·threshold > n`, so any two quorums of a constellation must share at least one pier. That intersection is stated in `quorum.rye` yet not yet *spent*. A quorum knows the sky may act; it does not yet name **what** the sky acts on.

## The one new concern

FORA10 spends the intersection for the first real decision every consensus leans on: **one leader, chosen once.** Each pier casts a single vote for a candidate slot; the constellation elects the candidate that a strict majority names, and refuses when no candidate holds one. The crux is not the counting — it is the **safety proof carried over from the quorum**: because any two majorities intersect and a pier votes exactly once, **at most one candidate can ever reach a majority.** Two piers can never each believe a different leader was elected. That uniqueness is the load-bearing invariant, asserted at the seal, not merely hoped.

This is the canonical first application of a quorum, and it stays strictly one keystone: the *decision*. The medium that carries a vote — announce, respond, hear, the naming-law border, the `ChannelFull`-free interleave — is already proven in FORA6–FORA9 and is reused unchanged.

## The shape

- **`Ballot`** — one vote per roster slot: `choice[voter] = candidate`, a `cast[voter]` bool, and the constellation `size`. `vote(voter, candidate)` records one honest vote, refusing `DoubleVote` when a voter votes twice — a pier votes once per round, exactly as the quorum records a reply once.
- **`tally(candidate)`** — how many cast votes name a candidate. Bounded by `size`.
- **`elect()`** — scan the candidates, return the slot a strict majority named, else refuse `NoLeader`. The seal asserts the uniqueness invariant: **no second candidate also reaches the majority** — the quorum-intersection property, made checkable.
- **`run_election(sb, choices)`** — a real round over the switchboard: announce a ping, drive each reachable member `respond`+`hear` (so a vote counts only from a member proven present at the border), record each member's own `choices[slot]`, then elect. The vote's *content* is the voter's honest choice; the *right* to vote is proven over the wire. A stranger caller refuses `NoSuchPier` before any announce; a vowel-bearing reply refuses `VowelPresent` at `hear`.

## What it proves (selftest)

1. A clear majority elects a leader — a sky of four, three naming slot 1, elects slot 1.
2. A split refuses `NoLeader` — a sky of four evenly divided (two for 1, two for 2) elects no one; a minority never leads.
3. **Uniqueness** — across a sky, no arrangement of single votes lets two different candidates each reach a majority (the intersection property, checked directly).
4. A unanimous sky elects unanimously; a lone vote never elects (`NoLeader`).
5. `DoubleVote` refuses a pier voting twice.
6. A stranger cannot open an election (`NoSuchPier`); the border guards every vote (`VowelPresent` at `hear`).
7. A full constellation of eight elects and stays bounded (no `ChannelFull`, the round interleaves respond and hear).

## What stays out (custody-first)

Purely **local** — a bounded decision over the switchboard on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) stay untouched. The one rung that crosses the Comlink seam — the socket — remains the maintainer's word, unchanged by this round.

---

*A count became a decision at FORA9; at FORA10 the decision names a leader, and the quorum's intersection makes that leader unique. May the sky always agree on one, and may the missing vowel keep the vote safe all the way down.*
