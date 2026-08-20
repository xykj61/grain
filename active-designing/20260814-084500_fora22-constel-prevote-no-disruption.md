# FORA22 — a partitioned pier cannot disrupt a stable sky (pre-vote)

**Stamp:** `20260814.084500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** Six-Season double-seat, Season D (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA22
**Stands on:** [`constel/vote.rye`](../constel/vote.rye) (FORA21 — `at_least_as_current`, the up-to-date check a pre-vote reuses) · [`constel/term.rye`](../constel/term.rye) (FORA16 — the term a pre-vote refuses to bump prematurely) · [`constel/quorum.rye`](../constel/quorum.rye) (FORA9 — the majority threshold)
**Kin:** [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The disruption FORA16's terms let in

FORA16 made a monotonic **term** the ledger's guard against a stale leader: a leader whose term the sky has passed can never commit. That guard has a liveness cost, Raft's **§9.6**:

> A pier partitioned away from the sky keeps hitting its election timeout, and each timeout **increments its term** — so its term balloons in isolation. When the partition heals and it rejoins, its very high term forces the *current, healthy* leader to step down (a higher term always wins), triggering a needless election. The sky was stable; a single disconnected node **disrupts** it, and this can repeat every time that node's term climbs again.

The stale-leader safety of FORA16 is exactly what a partitioned node weaponizes. **Pre-vote** is Raft's answer: a candidate must win a *practice* election **before** it is allowed to bump its real term.

## The crux — bump the term only after a pre-vote passes

FORA22 introduces `constel/prevote.rye`: a candidate runs a **pre-vote** round in which **no node changes its term**, asking each peer "*would* you vote for me in the next term?" A peer pre-grants only when **both** hold:

1. **It has not heard from a current leader recently** — its own election timeout has elapsed. A peer still hearing a healthy leader answers **no**, because from where it stands the sky is fine.
2. **The candidate's log is at least as up-to-date** — FORA21's `at_least_as_current`, reused unchanged. A behind candidate is refused here exactly as it would be in a real vote.

Only if a **majority** pre-grant does the candidate increment its real term and start the true election. So a partitioned node, however high its *private* term has climbed, cannot force the sky to move: it never gets to bump a real term until a majority already agree the leader is gone.

## What the witness proves

`tools/fora_prevote_witness.rish`, six blocks:

1. **A peer pre-grants only when both conditions hold** — leader-silence *and* an up-to-date candidate; each condition alone is refused.
2. **A stable sky is not disrupted (the crux)** — a majority of peers still hear a healthy leader; a rejoining candidate (even one whose private term is far higher and whose log is current) fails the pre-vote, and its **real term is not bumped**. The healthy leader is undisturbed.
3. **A genuinely leaderless sky does elect** — when a majority *have* lost contact with the leader (real failure, timeouts elapsed) and the candidate is up-to-date, the pre-vote passes and only then is the term bumped. Pre-vote blocks disruption, never a true election.
4. **A behind candidate fails the pre-vote even in a leaderless sky** — the up-to-date check (FORA21) still binds, so pre-vote never elects an incomplete leader either.
5. **The term is bumped exactly once and only on success** — a failed pre-vote leaves the term unchanged (no disruption); a passed one advances it by exactly one.
6. **Bounded** — the pre-vote poll runs over a full roster within the pier cap.

## Why this is the right crux now

With the full safety set proven (through FORA21), the remaining Lindy-durable gap is **stability**: a correct consensus that can be disrupted into endless elections by one flapping node is correct yet unusable. Pre-vote is the standard, well-understood rung that closes it, and it composes FORA21 · FORA16 · FORA9 public API only — no new consensus, one new guard.

## The gate stays the gate

Purely **local**: a bounded pre-vote count and per-peer leader-contact flags on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address. A **served** pre-vote (real PreVote RPCs over Comlink) reaches the Comlink-served gate; the socket rung stays the maintainer's hand (custody gate #2).

---

*May a sky that is well left well, and may a pier long gone rejoin without asking the whole sky to begin again.*
