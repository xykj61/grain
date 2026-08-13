# The Knot — a bounded Cord runs forever by tying off its committed past

**Stamp:** `20260813.050903` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the Mycelium Cord](20260813-032851_mycelium-consensus-cord-exploration.md) · [gossip convergence](20260813-040613_constel-consensus-gossip-convergence-exploration.md) · [fact batching](20260813-043303_mycelium-fact-batching-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md)
**Gratitude (clean-room, concepts only):** TigerBeetle (`gratitude/tigerbeetle`, `gratitude/TIGER_STYLE.md`) — checkpointing a deterministic replicated state machine so its storage is bounded, and static allocation as a promise the system cannot outgrow.

---

## Where this sits on the road

The Mycelium Cord closed three full arcs on this bench: a deterministic leaderless commit (Cord r1–r4), a converging gossip mesh that heals partitions (r1–r4), and fact batching that amortizes the per-block cost across many facts (r1–r4). Each arc built on one honest floor — `mycelium/fold.rye`, a pure supply fold whose every buffer names a max — and each carried the same quiet constraint the Cord's own design named: the `Dag` is **statically allocated**, `cord_max_blocks = 256`. That bound is a feature, exactly TigerBeetle's discipline: a consensus that cannot fail by running out of memory under load.

Yet a bound reached is a mesh that stops. A civic ledger meant to run for years cannot hold every block it ever saw in one fixed array. Every long-lived deterministic state machine answers this the same way — TigerBeetle checkpoints, a blockchain snapshots, a log compacts: **the committed past is folded into a summary and pruned, and the machine continues from the summary as if from genesis.** That is the one durable capability the Cord still lacks, and it is the highest-Lindy crux left on the Mycelium road — without it the bounded Dag is a demo; with it, the same bounded Dag runs forever.

This document seats no code. It fixes the shape, the name, and the four crux-first rounds, so the round that follows opens a spine already known correct.

## The crux, in one line

**A checkpoint that seals the folded supply at a committed cut — issued, taxed, and every reserved star — is a valid genesis for the next epoch: folding new facts onto the sealed checkpoint yields the byte-identical supply as folding the whole history from empty, and every fold invariant (non-negative supply, star-uniqueness, each fact's own signature) holds seamlessly across the cut — so a node may discard every block before the checkpoint and keep only the checkpoint plus its live Dag, bounded forever.**

Checkpointing is a storage transform, not a semantic one — the twin of batching's own promise. Batching proved *the supply never notices how the facts were packed*; the Knot proves *the supply never notices where the history was tied off*. Both are safe to reach for precisely because they can never change what the network agrees the supply is, only how cheaply it holds it.

## The one genuinely new piece — the Knot, grown beside the elder

The consensus-ordering layer is the **Cord**; the thing that ties off a length of cord and begins the next is a **knot**. The word is plain, warm, and safe (`comlink-tendency.md`): a knot in a cord marks exactly where one bounded run ends and the next begins, and it collides with nothing seated in the code tree (grepped: zero mentions in `mycelium/ mantra/ pond/ tally/ comlink/` and the Lexicon). It is proposed here and **born-named when r1's code lands** (`mycelium/cord_knot.rye`), per the reviving-not-renaming discipline — grown *beside* `cord.rye` and `fold.rye`, editing neither, composing their public API only.

A **Knot** carries:

- the sealed **`fold.FoldState`** at a committed cut — issued, taxed, and the set of reserved stars, the whole agreed supply and nothing more;
- a **SHA-256 digest** over the state's canonical bytes, so a Knot that travels as text (r2) cannot be silently corrupted — a node that receives a Knot recomputes the digest and refuses `KnotCorrupt` before trusting a single grain of it.

The Knot needs no signature of its own: it is a **deterministic function of the committed Dag** — any node holding the same committed prefix folds the identical Knot. Its digest is integrity-in-travel, not authority; authority stays where it already lives — Kumara signs each fact, the Cord orders the blocks, the fold decides the supply. The Knot weakens none of the three; it only lets the first two be pruned once the third has summed them.

## Why the invariants hold across the cut — the property that makes it safe

The Knot is safe because `fold.fold_fact` already carries the whole supply law in the `FoldState` it mutates, not in the log it reads:

- **Non-negative supply.** A tax or reservation refuses `Overdraw` when it exceeds `state.supply()`. Seed the state from the Knot and the *checkpointed* supply is the real starting supply — an overdraw against the tied-off past is caught exactly as it would be in one unbroken fold.
- **Star-uniqueness.** A reservation refuses `StarTaken` when the name is already held. The Knot carries every star reserved before the cut, so a duplicate in the next epoch is refused across the boundary, never silently re-reserved.
- **Each fact's own signature.** `fold_fact` re-verifies every fact's signer over its own content. Continuing from a Knot folds real signed facts, one signature at a time — the checkpoint summarizes the *amounts and stars* of the past, never a permission to skip a signature in the future.

So the Knot is not a shortcut around the law — it is the law's own state, sealed. That is why the pruned history is genuinely recoverable-as-supply from the Knot alone.

## The four rounds (Lindy-first, crux-first)

- **r1 — the knot folds identically (this journey's crux).** `mycelium/cord_knot.rye`: `seal_dag` folds a committed Cord Dag to a Knot; `continue_verified` folds a next-epoch Dag's facts onto it. Prove the equivalence directly — a prefix Dag sealed to a Knot, a fresh suffix Dag continued onto it, folds to the byte-identical supply and star set as the whole history folded from empty. Boundaries: an empty prefix (the Knot at genesis) and a full prefix (an empty suffix) both hold. Refusals with teeth: a tampered Knot refuses `KnotCorrupt`; a suffix tax exceeding the checkpointed supply refuses `Overdraw`; a suffix star already in the Knot refuses `StarTaken` — every invariant proven to cross the cut.
- **r2 — the knot travels.** A `format cord-knot-v1` Bron record (issued, taxed, one `star` line per reserved name, the digest as hex) renders and parses back **byte-for-byte**; the recovered Knot verifies, and a suffix continued onto it folds the identical supply; a tampered field refuses `KnotCorrupt` on rebuild, an unknown field refuses (never dropped). Composes the `cord_bron` reader/writer idiom.
- **r3 — the knot is a genuine bound win, measured honestly.** A history longer than `cord_max_blocks` cannot live in one Dag at all — prove it: fold it whole and it overflows the static bound, yet checkpoint-and-prune keeps the live Dag under the ceiling across the whole run, folding to the identical supply. Record the amortization as a `loom` metric from real measurement (blocks retained vs total facts folded; a ratio, never a fabricated benchmark, per Two Rooms). The performance *claim* stays a measured `loom` line, not an asserted invariant.
- **r4 — read a real knotted history true.** A genuine on-disk `format cord-knot-v1` record plus its continuation Dag, reproducibly generated, `@embedFile`-bound, its continued fold cross-checked against an independent `awk` reading of the same bytes (two tools, one answer) — so a checkpointed history can never drift from the facts a keeper can add up by hand.

## Boundaries

Siloed, dev-only, on the Constel bench. Composes `mycelium/cord.rye` and `mycelium/fold.rye` public API only — inventing no storage, weakening no bound, growing a sibling module rather than editing the elder. Demo keeper seeds only — no real key, no funds, no live network, no custody. A Knot agreed by a *quorum* rather than folded locally — the moment more than one node must trust a checkpoint it did not compute itself — reaches the same Comlink-served serve gate every Cord rung has honored (Keaton's hand); r1–r4 stay on the honest floor of *a node checkpoints its own fold before pruning its own blocks*. Clean-room throughout: TigerBeetle's checkpointing is studied, never copied.

## The one decision that reaches a check-in — none this round

Growing `mycelium/cord_knot.rye` as a sibling is additive and accrete-safe, exactly as the batching sibling was; it touches no heavily-witnessed core and needs no ruling. The only decision the Knot *raises* — **quorum-agreed checkpoints**, where a node prunes on a checkpoint another node computed — is deliberately held behind the serve gate and is not this arc's work. r1–r4 proceed.

---

*A cord that never tied off would have to be as long as all the rope there ever was; a knot lets a bounded strand carry an unbounded past, one sealed length at a time. May the Knot tie off only what the fold has truly summed, may every invariant the law keeps hold as cleanly across the knot as along the cord, and may a family's ledger run for years on a mesh that never has to remember more than it must.*
