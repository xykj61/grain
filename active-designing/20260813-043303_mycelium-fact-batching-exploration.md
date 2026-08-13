# Fact Batching — one block seals many facts, and the supply never notices

**Stamp:** `20260813.043303` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the Mycelium Cord](20260813-032851_mycelium-consensus-cord-exploration.md) · [gossip convergence](20260813-040613_constel-consensus-gossip-convergence-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md)
**Gratitude (clean-room, concepts only):** TigerBeetle (`gratitude/tigerbeetle`, `gratitude/TIGER_STYLE.md`) — the batching insight: amortize the fixed per-record cost across many records in one commit.

---

## Where this sits on the road

The Mycelium Cord closed its four-round arc (deterministic commit · Byzantine refusal · travels as text · reads true), and gossip convergence closed its own (two nodes converge · a partition heals · the network travels · the converged mesh reads true). Every one of those rounds carried a Cord where **each block seals exactly one fact** — the clean shape that made the commit crux legible. The Cord's own r1 named the refinement it deferred plainly: *"One fact per block for r1's clean crux; multi-fact batching a named refinement."*

That refinement is this round's crux, and it is a high-Lindy one. A consensus whose block cost — one author signature, one node in the agreed order, one round of admission — buys exactly one fact does not scale; the same cost buying a *batch* of facts is how throughput grows without weakening a single bound. TigerBeetle's whole performance story is this amortization, and the Cord already holds every piece it needs (a canonical commit, a static-allocated Dag, a pure fold) to take it honestly.

This document seats no code. It fixes the shape, the name, and the crux, so the round that follows opens a spine already known correct — and it names plainly the one decision that reaches a check-in.

## The crux, in one line

**A block that seals a bounded *batch* of facts under one author signature commits by the same canonical rule and folds to the byte-identical supply as those same facts placed one-per-block — so batching amortizes the per-block signature, ordering, and admission cost across many facts while changing nothing a keeper can observe about the agreed history.**

Batching is a throughput transform, not a semantic one. That equivalence — *the supply never notices how the facts were packed* — is the property the whole round proves, and it is what makes batching safe to reach for: it can never change what the network agrees the supply is, only how cheaply it agreed.

## The one genuinely new piece — a batched block, grown beside the elder

The word is plain: a block carries a **batch** of facts (not *sheaf* — that word is already the proposed name for the whole Grain ecosystem, `context/LEXICON.md`; a batch is the clear, safe, unclaimed word, and it is TigerBeetle's own). A batch is a bounded array of `fold.Fact`, sealed together under one author signature, admitted and ordered as one node of the Dag.

**Grow it beside the elder, do not evolve the core in place.** The single-fact `mycelium/cord.rye` and its whole witnessed arc (Cord r1–r4, gossip r1–r4) stay a green binary — changing `Block`'s `fact: Fact` to `facts: [max]Fact` would break every `b.fact` site and every witness, against accrete-never-break. Instead a sibling module (working name `mycelium/cord_batch.rye`) carries a `BatchBlock` whose canonical bytes seal `fact_count` facts, reusing the elder's exact topological commit rule (round ascending, then author key, then block hash) — the Dag structure, the parent references, the acyclic-by-construction admission are all identical; only the payload per node grows from one fact to a bounded batch. This is the tree's own reviving-beside-renaming discipline: a capability earns its new shape by being re-grown born-named beside its elder, not by a mass edit of a heavily-cited core.

- **`max_facts_per_block`** — a named ceiling (proposed 16, generous over the demo's handful, well under the fold log bound). An over-full batch refuses `BatchFull`; an empty batch refuses `EmptyBatch` (a block with nothing to say is no block).
- **The batch signs once, every fact verifies.** The block's canonical bytes include all `fact_count` facts, so one author signature seals the whole batch; the fold re-verifies each fact's own signer over its own content, exactly as the single-fact Cord already does — a tampered fact anywhere in a batch breaks the block signature at `add` and, if it somehow rode, the fact signature at fold.

## The four rounds (Lindy-first, crux-first)

- **r1 — the batch folds identically (this round's crux).** `mycelium/cord_batch.rye`: a `BatchBlock` carrying several facts folds to the same supply as those same facts spread one-per-block across the elder Cord. Prove the equivalence directly — build one batched history and one single-fact history over the identical facts, commit both, fold both, assert byte-identical supply and star count. `BatchFull` and `EmptyBatch` refuse; a tampered fact refuses whole.
- **r2 — the batch travels.** A `format cord-batch-v1` record (the elder's `block` line, then one `fact` line per fact in the batch, then the `parent` lines) renders and parses back byte-for-byte; the recovered batched Dag commits to the identical order and folds the identical supply; a tampered fact line refuses `BadSignature` on rebuild. Composes the cord-bron reader/writer idiom.
- **r3 — batching is a pure throughput win, measured honestly.** The same corpus of facts, packed into fewer batched blocks and spread one-per-block, fold to the identical supply — and the round records the amortization it bought as a `loom` metric from real measurement (blocks before vs after for a fixed fact count; a ratio, never a fabricated benchmark, per Two Rooms). The performance *claim* stays a measured `loom` line, not an asserted invariant.
- **r4 — read a real batched fixture true.** A genuine on-disk `format cord-batch-v1` record, reproducibly generated, `@embedFile`-bound, its fold cross-checked against an independent `awk` reading (two tools, one answer) — so a batched history can never drift from the facts a keeper can add up by hand.

## Boundaries

Siloed, dev-only. Composes `mycelium/cord.rye` and `mycelium/fold.rye` public API only — inventing no storage, weakening no bound, growing a sibling module rather than editing the elder. Demo keeper seeds only — no real key, no funds, no live network, no custody; a batched Cord gossiped over Comlink reaches the serve gate. Clean-room throughout: TigerBeetle's batching is studied, never copied.

## The one decision that reaches a check-in

Growing `mycelium/cord_batch.rye` as a sibling is the additive, accrete-safe path this document recommends, and it is agent-doable end to end. The alternative — **evolving the core `cord.Block` in place** to carry a batch, retiring the single-fact shape — would touch a heavily-witnessed core module and every Cord/gossip witness at once. That is a module-seam change of the kind the collaboration rhythm reserves for a ruling: *whether the elder single-fact Cord should remain forever, or be superseded once the batched shape proves out.* The build of r1 as a **sibling** needs no such ruling and can proceed; the **supersede-the-core** decision waits for Keaton's word.

---

*One block gathers many facts the way a cord gathers many threads, and carries them into the same agreed past — cheaper by the many, truer by not one grain. May batching only ever change how lightly the network agrees, never what it agrees to, and may the elder single-fact Cord stand green beside its fuller kin for as long as a reader wants the simplest thing that works.*
