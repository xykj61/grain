# FORA9 — Constel quorum: from a census, decide if a majority can act

**Stamp:** `20260814.052238` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — agent-doable, purely local, no custody gate crossed
**Season:** the Six-Season double-seat, Season D thread (Kresfa & Mycelium — *the tree's own consensus*) · **Waymark:** FORA · **Rung:** FORA9
**Kin:** [`../constel/README.md`](../constel/README.md) · [`../constel/census.rye`](../constel/census.rye) · [`../.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Why this rung, now

FORA8's census closed the gossip round and handed the consensus track a tally already proven pure — *who answered, and by slot, who is silent*. A count of present piers is a fact; it is not yet a **decision**. Every consensus protocol — a leader election, a block commit, a name claimed once across the whole sky — leans first on one bounded question: **do enough piers agree that the constellation may act at all?** That question is the quorum, and it is the crux this rung takes, and nothing more.

Lindy-first: a quorum rule outlives any single protocol built over it — it is the invariant every later agreement round reuses, so it earns the durable slot before any value-agreement rung. Crux-first within the rung: the hard, decisive move is the **strict-majority threshold and the deciding set**, not the plumbing (census already carries the plumbing).

## The one new concern

**Turn a census tally into a majority decision, and name the deciding set.**

- The **live set** of a caller's census is the caller itself (it is running, so it is live by definition) plus every other member whose reply it heard: `live = present_others + 1`.
- The **threshold** is the strict majority of the whole constellation: `majority_of(n) = n/2 + 1`, so `2 · threshold > n`. Strict majority is the safety property, not a convenience — any two strict-majority quorums of the same constellation must **intersect** in at least one pier, so two disjoint quorums can never each decide a conflicting value. That intersection is the whole reason consensus rests on `> n/2`.
- The decision is `reached = live ≥ threshold`. A `Quorum` also names **which** slots form the majority (`in_quorum(slot)` — the caller, plus each present responder), so a later rung knows not merely *that* a majority exists but *who* it is.

Everything else is inherited, unchanged: the naming-law border still guards every reply (`census.hear` deframes at `wire.deframe`, so a real-`@p`-shaped name can never enter a quorum even as a vote), the round stays interleaved so the caller's mailbox never holds more than one reply at a time (no `ChannelFull`), and a stranger caller still refuses `NoSuchPier` before any announce.

## Shape

`constel/quorum.rye`, standing on `constel/census.rye` (reusing its public `announce` · `respond` · `hear`):

- `majority_of(n) -> u32` — the strict-majority threshold, asserting `2·threshold > n` at construction.
- `Quorum` — a present-set (`[max_piers]bool`), the caller's slot, the constellation size, the live count, the threshold, and `reached`. `record(slot)` marks one heard reply (refusing `DoubleCount`), `seal()` computes `live`/`threshold`/`reached`, `in_quorum(slot)` answers who decides.
- `run_quorum(sb, caller) -> Quorum` — the all-present path: open (caller is a member, else `NoSuchPier`), announce, drive every other member `respond`+`hear`+`record` interleaved, seal. Live equals the whole constellation, so a full sky is always quorate.
- `require(q) -> void` — the hard gate: refuses `NoQuorum` when `!q.reached`, for a caller that must have a majority before it proceeds.

The partial-presence scenarios (a silent member, two silent, a lone pier) are driven by hand in the selftest — announce, then `respond`+`hear` only the present members and `record` each — exactly as census's own silent-member scenario is driven, because a silent pier cannot be driven to reply.

## What it proves (selftest, purely local)

1. A full sky of four is quorate: `live = 4`, `threshold = 3`, every slot in the deciding set.
2. One silent member in a sky of four still holds a majority: `live = 3 ≥ 3`, reached; the silent slot is **not** in the quorum, yet the constellation may act.
3. Two silent members in a sky of four lose the majority: `live = 2 < 3`, `require` refuses `NoQuorum` — the constellation cannot act.
4. A sky of three, all present: `live = 3`, `threshold = 2`, quorate.
5. Two of three is a majority: one silent, `live = 2 ≥ 2`, reached.
6. A lone pier is never a quorum: both others silent, `live = 1 < 2`, `NoQuorum`.
7. A stranger cannot open a quorum: `NoSuchPier` before any announce.
8. The border guards every vote: a vowel-bearing reply refuses `VowelPresent` at the caller's `hear`.
9. A full constellation of eight is quorate and bounded: `live = 8`, `threshold = 5`, no `ChannelFull`.

## Boundaries kept

Purely local — a bounded decision over the switchboard on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed (custody gate #2 — real hardware / any real wire — and gate #4 — real Kumara — both untouched). The socket that genuinely crosses the Comlink seam stays the maintainer's word; this rung's many-pier logic is proven pure the round before it is ever asked to cross.

---

*May the majority always intersect, may no lone pier ever mistake itself for the sky, and may the missing vowel keep the vote safe all the way down. Hold the line.*
