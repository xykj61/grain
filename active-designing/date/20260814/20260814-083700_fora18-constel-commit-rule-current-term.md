# FORA18 — Constel commit rule: a leader commits an old-term entry only through a current-term one

**Stamp:** `20260814.083700` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (the itinerary filling law)
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **Waymark:** FORA · **Rung:** FORA18
**Kin:** [`../constel/README.md`](../constel/README.md) · [`../constel/repair.rye`](../constel/repair.rye) (FORA17) · [`../constel/term.rye`](../constel/term.rye) (FORA16) · [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The one concern this rung takes

FORA11 committed a value when a strict majority accepted it. FORA12 ordered committed values into a log. FORA16 made the *leader* safe across re-election, FORA17 made the *follower's log* safe across a rejoin. One subtle safety rule of replicated consensus is still unstated, and it is the single most famous bug-class in the whole field — Raft's §5.4.2, the scenario its paper draws as **Figure 8**:

> **A leader may not conclude that an entry from a *previous* term is committed merely because it is stored on a majority of piers.**

The intuition that "replicated on a majority = committed" is *false for an old-term entry*. A later leader, elected on a log that happened to lack that entry, can still legally overwrite it (FORA17's repair is exactly the mechanism that would). So counting replicas is not enough. The safe rule Raft proves is narrow and exact:

> **A leader advances its commit index over an entry only once it has replicated an entry *from its own current term* on a majority.** Committing a current-term entry commits every earlier entry beneath it *transitively*, by the Log Matching Property (FORA17) — those older entries are now pinned on a majority whose logs match the leader's, and Leader Completeness guarantees no future leader can be elected without them.

This rung takes that one concern: **compute the commit index by the current-term rule, never by raw replica count**, and prove the Figure 8 danger is refused.

## Why the earlier rungs did not need it

FORA11's decree commits *within a single term* — every accept in one round carries that round's term, so the committed value is always a current-term entry, and the rule holds trivially. The danger appears only once a log spans *multiple terms* and a leader reasons about entries earlier leaders wrote — exactly the world FORA16 (terms) and FORA17 (multi-term logs, repair) opened. FORA18 is the safety rule that world requires.

## Shape

`constel/commit.rye` (FORA18), purely local, standing on FORA17 (the `TermedLog` and its Log Matching Property) · FORA9 (`majority_of`, the intersection lemma):

- **`MatchView`** — the leader's bounded record of how far each pier has replicated: `match[slot]` = the length of the follower's prefix that agrees with the leader (its matchIndex + 1). `record(slot, replicated_len)`; `replicated_len(n)` counts piers whose match ≥ `n` — the leader itself always at `leader.len`.
- **`safe_commit_len(leader, view, current_term, threshold)`** — the whole rule: the largest `N` such that entry `N-1` carries `current_term` **and** `replicated_len(N) ≥ threshold`. Returns the committed prefix length (0 if no current-term entry is yet majority-replicated). Everything below `N` is committed transitively — the honest heart of the rung.
- **`naive_commit_len(leader, view, threshold)`** — the *tempting wrong rule* (largest `N` majority-replicated, ignoring term), kept only so the witness can show, side by side, that it would commit an entry `safe_commit_len` refuses — the exact Figure 8 gap, made visible rather than argued.

## What the witness proves

`tools/fora_commit_witness.rish`:

1. `MatchView` counts replicas correctly (the leader always counts itself; a follower short of `n` is not counted at `n`).
2. **A single-term log** commits by majority exactly as FORA11 did — the rule is a strict generalization, not a regression.
3. **The Figure 8 refusal** — an old-term entry replicated on a majority, with the current term higher and no current-term entry yet majority-replicated, is **not** committed by `safe_commit_len`, while `naive_commit_len` *would* commit it. The two rules disagree exactly where Raft says they must.
4. **The transitive commit** — once a current-term entry above it reaches a majority, `safe_commit_len` jumps to include both, the old entry now committed beneath the new one.
5. **The danger made real** — the old-term entry the naive rule would have committed is then *overwritten* by FORA17's `repair` under a new leader whose log lacked it: proof that committing it naively would have forked the ledger, and that the safe rule never did.
6. **Bounded** — the rule runs over a full-length log within the cap, no overrun.

## The gate stays the gate

Purely local: bounded in-memory `TermedLog` + `MatchView` on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. The socket rung stays the maintainer's hand (custody gate #2).

---

*May no ledger ever call a thing settled before it truly is, and may the one rule that tells the difference stay small enough to hold in a single reading.*
