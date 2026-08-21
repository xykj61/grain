# The Tenure — a contested name is decided by the agreed order

**Stamp:** `20260813.060935` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the Mycelium Cord](20260813-032851_mycelium-consensus-cord-exploration.md) · [the Ledger Voice](20260813-053843_mycelium-ledger-voice-exploration.md) · [the Knot checkpoint](20260813-050903_mycelium-cord-knot-checkpoint-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)
**Gratitude (clean-room, concepts only):** the name-registration crux is the oldest reason a namespace wants consensus at all — studied plainly, code written our own; the Cord's own arrival-order-independent commit (`mycelium/cord.rye`) is the machinery this reads.

---

## Where this sits on the road

The Cord closed its arcs: a deterministic leaderless commit, a converging gossip mesh, fact batching, the Knot that seals a committed past, and the Ledger Voice that reads a lawful fold. Each proved the mesh could **write, agree, pack, checkpoint, and read** its supply. Not one asked the question a namespace exists to answer: *when two honest keepers reach for the same name at once, who holds it?*

That question is the oldest reason a name registry wants consensus. A supply total is commutative — issue then tax, or tax then issue, the number is the same. A **name** is not: `bandun` can belong to exactly one keeper, so the moment two keepers each sign a reservation for it, the ledger must pick one — and every honest node must pick the **same** one, or the mesh has forked over who owns a name. The Cord already derives one total order from the mesh regardless of arrival; this journey reads that order as the namespace's **verdict**: the first reservation of a name in the agreed order holds it, and every later reservation of that same name loses — deterministically, on every node.

This document seats no code. It fixes the shape, the name, and the four crux-first rounds, so the round that follows opens a spine already known correct.

## The crux, in one line

**A contested name is held by whichever reservation the Cord's total order places first — the same holder on every honest node, whatever order the blocks arrived — and a losing reservation is a lawful no-op that never poisons the ledger, while a genuinely unlawful fact still refuses the whole resolution.**

The honest distinction this draws is the whole crux. `mycelium/fold.fold_log` refuses the **whole** log on `StarTaken`, which is right for a single hand-built log yet wrong for a mesh: it would let one node break the entire ledger simply by front-running a name someone else was about to reserve. Consensus exists precisely so that front-run does not corrupt — it merely *loses*. So the Tenure treats a name-contest loss (`StarTaken`) as a **verdict**, not a corruption: the loser's reservation is a signed, lawful fact that the agreed order rejected as a no-op, and folding continues. Every other fold refusal — a forged signature (`IdentityRefused`), an unknown kind (`UnknownKind`), an overdraw for a *free* name (`Overdraw`) — stays poison exactly as `fold` decrees, because those are corruption, not a lost race. The precedence is already correct in `fold.fold_fact`: it checks *taken* before it checks *affordable*, so a contestant loses the name before the ledger even asks whether it could pay.

This is the twin of `artifact_query`'s guarantee carried to a namespace. There, content-addressing means a tampered bead refuses the fetch. Here, the agreed order means a contested loser refuses the *name* — yet the ledger stands, because the order already ruled.

## The one genuinely new piece — the Tenure, grown beside the elders

The resolution layer earns its own clear, warm, safe name (`comlink-tendency.md`). A name's **tenure** is the term on which it is held — apt for *who holds this name, and by what right*. **Tenure** collides with nothing in the code namespace (grepped `mycelium/ mantra/ pond/ tally/ comlink/`: zero module or type), reads plainly on the ten-thousandth day, and can never parse as an address. It is born-named when r1's code lands (`mycelium/tenure.rye`), grown *beside* `mycelium/cord.rye` and `mycelium/fold.rye`, editing neither, composing their public API only (the reviving-not-renaming discipline).

`tenure.resolve(dag)` commits the Cord's Dag to one total order (`cord.commit`), then walks the committed facts one at a time through `fold.fold_fact` — the per-fact primitive, never the all-or-nothing `fold_log`:

- a reservation the fold **accepts** records a **winning holding**: `name → holder public key`, at its position in the agreed order;
- a reservation the fold refuses `StarTaken` records a **contested loss**: `name → the keeper who lost`, the order having already granted the name to an earlier winner — folding continues, the ledger unbroken;
- any other refusal (`IdentityRefused` · `UnknownKind` · `Overdraw`) refuses the **whole** resolution — corruption is not a verdict.

The reads are pure functions of the resolved `Tenure`: `holder_of(name)` → the winning keeper's key or *free*; `is_held(name)`; `count` of names held; `contest_count` of losses recorded.

## The four rounds (Lindy-first, crux-first)

- **r1 — the verdict (this journey's crux).** `mycelium/tenure.rye`: build a Dag of Kumara-signed blocks — genesis issues to fund, an uncontested reservation, and **two distinct keepers reserving one name at the same round**; commit; resolve. Prove the crux — the contested name is held by exactly the keeper the agreed order places first, the loss recorded, the uncontested name held by its keeper; prove **arrival-order independence** — several arrival permutations yield the identical winner and identical Tenure; prove the loser is a **lawful no-op** — the resolution succeeds, the supply folds, the uncontested holding stands; prove **corruption still poisons** — a tampered signature and a free-name overdraw each refuse the whole resolution.
- **r2 — the verdict travels.** Render a resolved `Tenure` to a `format tenure-v1` Bron record — each holding a `hold <name> <holder-pk-hex> <pos>` line, each loss a `lost <name> <loser-pk-hex>` line — and parse it back byte-for-byte, the recovered Tenure answering the identical `holder_of` for every name, so a dev-net's namespace verdict crosses as readable text.
- **r3 — the verdict reads across a Knot.** Resolve over a Knot plus its live suffix (`mycelium/cord_knot.rye`): a name won inside a sealed checkpoint stays held when new facts continue the log, proving a holder is the same whether the winning reservation lives in a full Cord or a sealed Knot.
- **r4 — read a real contested fixture true.** A genuine on-disk Dag fixture carrying a real contest, `@embedFile`-bound, its resolved holder cross-checked against an independent `awk` reading of the same bytes (two tools, one answer) — so the winner of a name can never drift from the order a keeper can walk by hand.

## Boundaries

Siloed, dev-only, on the Constel bench. Composes `mycelium/cord.rye` and `mycelium/fold.rye` (and later `mycelium/cord_knot.rye`) public API only — inventing no storage, weakening no bound, editing no elder, growing a sibling. Demo keeper seeds only — no real key, no funds, no live network, no custody; the maintainer's own Kumara instance stays gate #4, a Tenure served to another node reaches the Comlink-served gate (Keaton's hand). The honest scope note kept in view: this round recognizes only a **name-contest** loss (`StarTaken`) as a lawful no-op; extending the same verdict logic to a double-spend loser (an `Overdraw` that lost a race rather than never-could-pay) is a **named horizon**, not this arc's work — kept narrow on purpose so the crux stays legible.

## The one decision that reaches a check-in — none this round

Growing `mycelium/tenure.rye` as a sibling that composes `cord` and `fold` public API is additive and accrete-safe, exactly as every query voice was; it touches no elder and needs no ruling. The one decision it *raises* — serving a namespace verdict another node trusts without re-resolving — is deliberately held behind the serve gate and is not this arc's work. r1 proceeds.

---

*A supply forgives every order; a name forgives only one. Where two keepers reach for the same word in the same breath, the Cord has already woven a single order through the dark, and the Tenure reads it plainly — one holds the name, the other is turned away without harm, and every node in the mesh nods to the same keeper. May every name find its one true holder, and may the one turned away lose nothing but the name.*
