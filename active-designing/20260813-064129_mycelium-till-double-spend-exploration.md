# The Till — a contested draw is decided by the agreed order

**Stamp:** `20260813.064129` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the Mycelium Cord](20260813-032851_mycelium-consensus-cord-exploration.md) · [the Tenure](20260813-060935_mycelium-tenure-contested-name-exploration.md) · [the Knot checkpoint](20260813-050903_mycelium-cord-knot-checkpoint-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)
**Gratitude (clean-room, concepts only):** the double-spend problem is the oldest reason a value ledger wants consensus at all — TigerBeetle's deterministic replicated state machine and the Mysticeti DAG consensus are studied plainly as the world's answers; the code here is our own, folding over the Cord's own arrival-order-independent commit (`mycelium/cord.rye`).

---

## Where this sits on the road

The Tenure closed the namespace's first hard question: when two honest keepers reach for the same *name* at once, the agreed order names one holder and turns the other away without harm. A name forgives only one holder, so a name-contest loss (`StarTaken`) is a lawful no-op the verdict records rather than a corruption that poisons the ledger.

A value ledger has a twin question, and it is the oldest reason a ledger wants consensus at all: when two honest keepers each reach into the same treasury for more than it can pay *both*, who gets the coins? This is the **double-spend**. TigerBeetle answers it by replicating one deterministic state machine; Mysticeti answers it by ordering a DAG of blocks. Mycelium already derives one total order from the mesh regardless of arrival (`cord.commit`); the **Till** reads that order as the treasury's verdict — the first draw the order places takes the coins, a later draw the treasury can no longer pay comes up empty, and it comes up empty as a **lawful no-op**, never a poison.

This document seats no code. It fixes the shape, the name, and the four crux-first rounds, so the round that follows opens a spine already known correct.

## The crux, in one line

**A draw the treasury cannot pay because an earlier winning draw in the agreed order already emptied it is a lawful no-op the verdict records — the same loser on every honest node, whatever order the blocks arrived — while a draw that asks for more than the treasury has *ever issued* by its turn still refuses the whole resolution, because that was never a race, only a demand no order could meet.**

The honest distinction this draws is the whole crux, and it is the exact twin of the Tenure's. `mycelium/fold.fold_fact` returns one `Overdraw` for two different facts: a spend that lost a race (affordable alone, refused only because a competing spend drained first) and a spend that never could pay (more than the treasury ever held). For a single hand-built log both are refusals, which is right there. For a **mesh** the first is a verdict and only the second is corruption — otherwise one node could break the whole ledger simply by front-running a spend someone else was about to make, exactly the front-run the Tenure already refuses to let corrupt a name.

The measure that separates them is monotonic and position-respecting: **`issued-so-far`**, the treasury's cumulative issue at the losing draw's position in the agreed order. Issues only add (the fold invents no release or expiry — `fold.rye`), so `issued-so-far` is the high-water mark of everything the treasury could ever have paid by that turn.

- A draw that overdraws yet whose amount is `≤ issued-so-far` **lost a race** — the coins existed for it at some point; an earlier winning draw took them first. Lawful no-op, recorded as a **spent-out loss**, folding continues.
- A draw that overdraws and whose amount is `> issued-so-far` **never could pay** — it asked for more than the treasury had ever issued by its turn, which no ordering fixes. Corruption; the whole resolution refuses, exactly as `fold` decrees.

An issue that overdraws (a `u64` wrap in `fold.fold_fact`) is never a race — it stays poison unconditionally.

This is the twin of the Tenure's guarantee carried from names to coins. There, the agreed order means a contested loser loses the *name* yet the ledger stands. Here, the agreed order means a contested loser loses the *coins* yet the ledger stands — because the order already ruled who spent first.

## The one genuinely new piece — the Till, grown beside the elders

The resolution layer earns its own clear, warm, safe name (`comlink-tendency.md`). A **till** is the drawer a treasury's coins sit in; when two hands reach into one till and the coins for both are not there, the first draw takes them and the second finds the till already emptied — and breaks nothing. **Till** collides with nothing in the code namespace (grepped `mycelium/ mantra/ pond/ tally/ comlink/`: zero module or type), reads plainly on the ten-thousandth day, is a pleasure to say, and can never parse as an address. It is born-named when r1's code lands (`mycelium/till.rye`), grown *beside* `mycelium/cord.rye`, `mycelium/fold.rye`, and `mycelium/tenure.rye`, editing none, composing their public API only (the reviving-not-renaming discipline).

`till.resolve(dag)` commits the Cord's Dag to one total order (`cord.commit`), then walks the committed facts one at a time through `fold.fold_fact` — the per-fact primitive, never the all-or-nothing `fold_log`:

- a fact the fold **accepts** advances the treasury; an accepted spend (tax or star reservation) records a **winning draw** at its position;
- a spend the fold refuses `Overdraw`, whose amount is `≤ issued-so-far`, records a **spent-out loss** — the treasury drained before its turn — and folding continues;
- a spend the fold refuses `Overdraw`, whose amount is `> issued-so-far`, refuses the **whole** resolution — never a race;
- a `StarTaken` name-contest loss stays the **Tenure's** verdict — the Till reads coins, not names, so it lets a name-contest refuse the whole resolution here rather than silently swallow a loss it has no verdict for; a mixed log's name contest is resolved by `tenure.resolve`, its coin contest by `till.resolve`, each honest to its own resource;
- any other refusal (`IdentityRefused` · `UnknownKind` · issue-wrap `Overdraw`) refuses the **whole** resolution — corruption is not a verdict.

The reads are pure functions of the resolved `Till`: `state` folds the winning draws; `draw_count` of draws that took coins; `spent_out_count` of draws the treasury could not pay; `total_lost` of coins asked-for-and-refused; a `spent_out_at(i)` view naming each loser and the amount it came up short.

## The one decision this round settles itself — StarTaken

The Tenure and the Till read the same Dag through the same `fold.fold_fact`, and a mixed log could carry both a name-contest and a double-spend. Each module stays **honest to its own resource**: `till.resolve` reads coins, so a `StarTaken` name-contest — a verdict about *names* the Till has no reads to report — **refuses the whole resolution** rather than swallow a loss it cannot speak to. A mixed log is resolved twice by design: `tenure.resolve` for the name verdict, `till.resolve` for the coin verdict, each returning a verdict object about exactly the resource it owns. This keeps each verdict legible and neither module pretending to rule on the other's resource. (If a later rung wants a single unified verdict object over both names and coins, it composes both resolvers — no elder edited.)

## The four rounds (Lindy-first, crux-first)

- **r1 — the verdict (this journey's crux).** `mycelium/till.rye`: build a Dag of Kumara-signed blocks — genesis issues a bounded treasury, an uncontested spend, and **two distinct keepers each drawing more than half the treasury at the same round** (each affordable alone, together over the top). Commit; resolve. Prove the crux — the agreed order grants the coins to exactly the first draw it places, the loser recorded as a spent-out loss holding no coins, the treasury folded to one honest supply; prove **arrival-order independence** — several arrival permutations yield the identical winner and identical Till; prove the loser is a **lawful no-op** — the resolution succeeds, the uncontested spend still stands, supply folds once; prove **never-could-pay still poisons** — a draw for more than the treasury ever issued refuses the whole resolution; prove **corruption still poisons** — a tampered signature refuses whole.
- **r2 — the verdict travels.** Render a resolved `Till` to a `format till-v1` Bron record — each winning draw a `drew <signer-pk-hex> <amount> <pos>` line, each spent-out loss a `short <signer-pk-hex> <amount> <pos>` line — and parse it back byte-for-byte, the recovered Till answering the identical counts and totals, so a dev-net's treasury verdict crosses as readable text.
- **r3 — the verdict reads across a Knot.** Resolve over a Knot plus its live suffix (`mycelium/cord_knot.rye`): a draw won inside a sealed checkpoint stays a winning draw when new facts continue the log, and a spend-out that lost against a checkpointed winner stays lost — proving a coin verdict is the same whether the winning draw lives in a full Cord or a sealed Knot.
- **r4 — read a real contested fixture true.** A genuine on-disk Dag fixture carrying a real double-spend, `@embedFile`-bound, its winning draw and spent-out loss cross-checked against an independent `awk` reading of the same bytes (two tools, one answer) — so the winner of a treasury can never drift from the order a keeper can walk by hand.

## Boundaries

Siloed, dev-only, on the Constel bench. Composes `mycelium/cord.rye` and `mycelium/fold.rye` public API only (the Tenure is design kin, grown beside it — not a code dependency; later rungs reach `mycelium/cord_knot.rye`) — inventing no storage, weakening no bound, editing no elder, growing a sibling. Demo keeper seeds only — no real key, no funds, no live network, no custody; the maintainer's own Kumara instance stays gate #4, a Till served to another node reaches the Comlink-served gate (Keaton's hand). The honest scope note kept in view: the treasury here is a **global supply** (`fold.rye` folds `issued − taxed`, not per-account balances), so a "double-spend" is a supply-exhaustion race, the truest double-spend this ledger can carry today; per-account balances are a **named horizon**, not this arc's work — kept narrow on purpose so the crux stays legible.

## The one decision that reaches a check-in — none this round

Growing `mycelium/till.rye` as a sibling that composes `cord`, `fold`, and `tenure` public API is additive and accrete-safe, exactly as the Tenure was; it touches no elder and needs no ruling. The one decision it *raises* — serving a treasury verdict another node trusts without re-resolving — is deliberately held behind the serve gate and is not this arc's work. r1 proceeds.

---

*A name forgives only one holder; a treasury forgives only what it holds. Where two keepers reach into one till for coins that cannot pay both, the Cord has already woven a single order through the dark, and the Till reads it plainly — the first draw takes what is there, the second comes up empty and breaks nothing, and every node in the mesh nods to the same hand. May every honest draw find the coins waiting, and may the one that came up short lose nothing but the coins it never truly had.*
