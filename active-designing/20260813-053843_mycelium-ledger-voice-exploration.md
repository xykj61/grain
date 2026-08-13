# The Ledger Voice — the intelligence reads only a lawful supply

**Stamp:** `20260813.053843` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the Mycelium Cord](20260813-032851_mycelium-consensus-cord-exploration.md) · [gossip convergence](20260813-040613_constel-consensus-gossip-convergence-exploration.md) · [fact batching](20260813-043303_mycelium-fact-batching-exploration.md) · [the Knot checkpoint](20260813-050903_mycelium-cord-knot-checkpoint-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)
**Gratitude (clean-room, concepts only):** the Q-vane voice pattern already in the tree — `pond/apps/graph_query.rye` reads the living Mantra graph, `pond/apps/artifact_query.rye` reads only content-address-verified bytes. The Ledger Voice carries the same shape to Mycelium's folded supply.

---

## Where this sits on the road

The Mycelium Cord closed four full arcs on this bench: a deterministic leaderless commit (Cord), a converging gossip mesh that heals partitions, fact batching that amortizes the per-block cost, and the Knot that ties off a committed past so a bounded Dag runs forever. Each proved the ledger could be **written and agreed** — ordered, converged, packed, checkpointed. Not one let a person **read** it.

Yet every other module the tree built earned a voice. A Lantern-shaped request reads the living Realidream graph (BUHR J6), a stored Tablecloth artifact (BUHR J8), a real corpus of tree documents (GISM J5). The consensus ledger — the newest and most load-bearing module of all — has no such voice. A civic ledger a family runs for years is asked *what is the supply, which stars are held, what did this epoch tax* far more often than it is written; the reading path is read thousands of times over the writing path's one. That makes the Ledger Voice the highest-Lindy crux left on the Mycelium road, and it stays entirely on the honest local floor — a node reads its own fold; no quorum, no serve gate.

This document seats no code. It fixes the shape, the name, and the four crux-first rounds, so the round that follows opens a spine already known correct.

## The crux, in one line

**A voice reads a Mycelium ledger only after folding the whole log lawful — so the corpus proves itself before a single grain is reported.** Every answer (supply · issued · taxed · the count of reserved stars · whether a named star is held · the fact count) is a deterministic function of the same `fold.FoldState` every node computes; a log carrying one unlawful fact — a forged signature, an overdraw, a doubled star, an unknown kind — refuses the whole fold, and the voice answers **nothing at all** rather than read an illegal supply.

This is the exact twin of `artifact_query`'s own guarantee. There, content-addressed storage means a tampered bead refuses the fetch and the voice reads nothing; here, the fold law means a tampered fact refuses the fold and the voice reads nothing. Integrity is not bolted onto the reader — it is the reader's corpus refusing to exist in a corrupt form. The voice cannot report a supply the network would not agree to, because the only supply it can see is the one the fold law already accepted.

## The one genuinely new piece — the Ledger Voice, grown beside the elders

The reading layer over the fold is the **Ledger Voice** — `pond/apps/ledger_query.rye`, born-named when r1's code lands, grown *beside* `mycelium/fold.rye` and the Lantern contract, editing neither, composing their public API only (the reviving-not-renaming discipline). It joins the family of query voices already seated (`graph_query`, `artifact_query`, `corpus_query`) and answers under the same Lantern contract: validate the request, gate the model through the allow-list, meter the completion with a length stop when the budget bites, refuse an unknown op rather than invent an answer.

The corpus is a `fold.Log` — a set of signed Mycelium facts. The voice folds it (`fold.fold_log`), and only a lawful fold yields a `FoldState` to read. The operations are pure reads of that state:

- **`supply`** → the current supply (`issued − taxed`);
- **`issued`** / **`taxed`** → the running totals;
- **`stars`** → the count of reserved stars;
- **`star <name>`** → `held` when the name is reserved, `free` when it is not — the read the name registry rests on;
- **`facts`** → the number of facts the lawful log carries;
- **`summary`** → `supply=<n> stars=<m>`, the one-line state a keeper skims.

## The four rounds (Lindy-first, crux-first)

- **r1 — the voice reads a lawful fold (this journey's crux).** `pond/apps/ledger_query.rye`: route a prompt to an op, fold the demo log lawful, read the true answer, meter it by the Lantern contract. Prove each op reads the fold's true value; prove the integrity gate — a log with one tampered fact refuses **every** op with `IdentityRefused`, the voice reporting no supply at all; refusals with teeth — an unknown op, a disallowed model, and a zero budget each refuse; a summary that outruns the budget truncates with a length stop.
- **r2 — the voice reads the living Cord.** The corpus becomes a committed `cord.Dag` rather than a hand-seeded `Log` — the voice folds exactly the blocks the Cord ordered, so the supply it reports is the supply consensus agreed. Composes `cord.rye` public API; the Cord stays its own green binary.
- **r3 — the voice reads across a Knot.** The corpus becomes a Knot plus its live suffix — the voice reads the checkpointed supply continued by new facts, proving a reader sees the same total whether the past is a full log or a sealed Knot (the Knot's own equivalence, carried into the reader).
- **r4 — read a real ledger true.** A genuine on-disk fixture, `@embedFile`-bound, its folded supply cross-checked against an independent `awk` reading of the same bytes (two tools, one answer) — so a reported supply can never drift from the facts a keeper can add up by hand.

## Boundaries

Siloed, dev-only, on the Constel bench. Composes `mycelium/fold.rye`, `lantern/lantern_core.rye` (and later `mycelium/cord.rye`, `mycelium/cord_knot.rye`) public API only — inventing no storage, weakening no bound, growing a sibling module rather than editing an elder. Demo keeper seeds only — no real key, no funds, no live network, no custody. A voice serving its reading *to another node* over the wire reaches the Comlink-served serve gate every Cord rung has honored (Keaton's hand); r1–r4 stay on the honest floor of *a node reads its own lawful fold*.

## The one decision that reaches a check-in — none this round

Growing `pond/apps/ledger_query.rye` as a sibling query voice is additive and accrete-safe, exactly as every other query voice was; it touches no heavily-witnessed core and needs no ruling. The only decision the Ledger Voice *raises* — serving a reading another node trusts without re-folding — is deliberately held behind the serve gate and is not this arc's work. r1 proceeds.

---

*A ledger no one can read is a vault with no window; a ledger read without the law is a rumor. The Ledger Voice opens the window and keeps the law in one gesture — it reports only the supply the fold has already blessed, so a family asking what it holds hears the truth the whole mesh agrees to, and never a grain more.*
