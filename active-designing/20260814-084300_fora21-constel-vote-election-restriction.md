# FORA21 — a vote goes only to an up-to-date log (the election restriction)

**Stamp:** `20260814.084300` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** Six-Season double-seat, Season D (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA21
**Stands on:** [`constel/repair.rye`](../constel/repair.rye) (FORA17 — the `TermedLog`, its `last_term` and length) · [`constel/quorum.rye`](../constel/quorum.rye) (FORA9 — `majority_of`, the intersection lemma) · [`constel/commit.rye`](../constel/commit.rye) (FORA18 — the committed prefix whose completeness this guarantees)
**Kin:** [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The claim FORA18 leaned on, not yet proven

FORA18 stated the Figure 8 commit rule and rested its transitive commit on a promise: *"Leader Completeness guarantees no future leader can be elected without them."* That promise is not free — it is earned by one rule this ladder has not yet written, Raft's **§5.4.1, the election restriction**:

> A voter grants its vote to a candidate **only if the candidate's log is at least as up-to-date as its own.** "Up-to-date" is compared by the last entry: a higher last **term** wins; at an equal last term, the **longer** log wins.

Without it, a candidate whose log is *missing a committed entry* could still gather a majority of votes and win — and then, as leader, either overwrite that committed entry or never learn of it, forking a ledger that FORA12 through FORA18 worked to keep whole. The restriction is the single rule that makes **Leader Completeness** true: every committed entry survives every future election, because no candidate lacking it can ever win.

## The crux — an incomplete candidate cannot win

FORA21 introduces `constel/vote.rye`: the voting restriction, and the completeness it buys, proven by the same intersection lemma that made the leader unique (FORA9) and the commit safe (FORA18).

- **`at_least_as_current(cand_last_term, cand_len, voter_last_term, voter_len)`** — Raft §5.4.1 exactly: `cand_last_term > voter_last_term`, or an equal last term with `cand_len >= voter_len`. The whole "up-to-date" comparison in one predicate.
- **`grant_vote(voter_log, cand_last_term, cand_len)`** — a voter (holding its own `TermedLog`) grants iff the candidate is at least as current. This is the AppendEntries-free half of a RequestVote.
- **`poll(voter_logs, cand_last_term, cand_len)`** — how many of a bounded roster would grant; a candidate wins iff the count reaches the majority threshold.

## What the witness proves

`tools/fora_vote_witness.rish`, six blocks:

1. **The up-to-date predicate is Raft §5.4.1** — a higher last term wins regardless of length; at an equal term the longer (or equal) log wins; a shorter log at an equal term loses; a lower last term loses even when longer. The full truth table.
2. **A vote is granted to an up-to-date candidate and refused to a stale one** — `grant_vote` over real `TermedLog`s: an equal-or-better candidate is granted, a candidate one entry short at the same term refused.
3. **THE ELECTION RESTRICTION KEEPS AN INCOMPLETE CANDIDATE FROM WINNING (the crux).** An entry is committed on a strict majority of logs; a candidate whose log *lacks* it stands. Every majority the candidate would need intersects the committed majority at a voter that holds the entry — and that voter, being strictly more up-to-date, **refuses** its vote. The candidate's grant count falls **below** the threshold: it cannot win. Leader Completeness, made concrete.
4. **A complete candidate still wins** — a candidate whose log holds the committed entry (equal to or ahead of the majority) gathers the whole majority's votes and wins. The restriction blocks only the incomplete, never the current.
5. **The dominance is by the entry, not by luck** — the intersecting voter refuses *because* it holds an entry the candidate lacks (its last term/length strictly dominate), not by any tie-break; shown by pointing at the exact refusing voter.
6. **Bounded** — the poll runs over a full roster within the pier cap; a unanimous up-to-date poll grants every vote, no overrun.

## Why this is the right crux now (Lindy-first, crux-first)

This is the safety rule the whole commit stack silently assumed. FORA18 is only *true* once FORA21 holds — so among all remaining pure rungs it is the most Lindy-durable: it closes the last open safety debt in the consensus core, rather than adding a convenience. It is also a clean crux: one predicate, one intersection argument, composing FORA9 · FORA17 · FORA18 public API only.

## The gate stays the gate

Purely **local**: bounded in-memory `TermedLog`s and a vote count on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. A **served** election (real RequestVote RPCs over Comlink) reaches the Comlink-served gate; the socket rung stays the maintainer's hand (custody gate #2).

---

*May a sky choose only a leader that carries its whole settled history, and may an entry the sky has truly committed outlive every election that follows it.*
