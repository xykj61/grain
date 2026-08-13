# The Purse — a double-spend by one holder, decided per account by the agreed order

**Stamp:** `20260813.070923` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design capture, self-approved round) · **Season:** double-seat expansion D — Kresfa & Mycelium
**Kin:** [the Mycelium Cord](20260813-032851_mycelium-consensus-cord-exploration.md) · [the Till](20260813-064129_mycelium-till-double-spend-exploration.md) · [the Tenure](20260813-060935_mycelium-tenure-contested-name-exploration.md) · [the Knot checkpoint](20260813-050903_mycelium-cord-knot-checkpoint-exploration.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)
**Gratitude (clean-room, concepts only):** the per-account double-spend is the shape every real value ledger carries — TigerBeetle's debit/credit account model and the Bitcoin/UTXO lineage are studied plainly as the world's answers; the code here is the tree's own, folding over the Cord's arrival-order-independent commit (`mycelium/cord.rye`) and reusing `mycelium/fold`'s signed-fact model unchanged.

---

## Where this sits on the road

The Till closed the treasury's first hard question over a **global supply**: when two keepers each reach into one shared drawer for more than it can pay both, the agreed order pays the first draw and the second comes up short as a lawful no-op. Its own honest scope note named the horizon it deliberately left open, twice — the treasury there is a *global supply* (`fold.rye` folds `issued − taxed`, never who holds what), so the double-spend it carries is a **supply-exhaustion race**, the truest that model can hold. The **truest** double-spend a value ledger carries is smaller and sharper: **one holder spends the same coins twice** — Alice, holding a hundred, signs one transfer of a hundred to Bob and another hundred to Carol at the same round, each affordable against her balance alone, together asking for twice what she holds.

This is the per-account double-spend, and it is why the world built consensus in the first place. The Cord already derives one total order from the mesh regardless of arrival (`cord.commit`); the **Purse** reads that order as each account's verdict — the first of Alice's two transfers the order places moves her coins, the second finds her purse already empty and comes up short as a lawful no-op, and every honest node in the mesh names the same winner.

This document seats no code. It fixes the shape, the name, and the four crux-first rounds, so the round that follows opens a spine already known correct.

## The crux, in one line

**A transfer a holder cannot pay because an earlier transfer of theirs in the agreed order already emptied their purse is a lawful no-op the verdict records — the same loser on every honest node, whatever order the blocks arrived — while a transfer for more than that holder ever *received* by its turn still refuses the whole resolution, because that was never a race, only a demand no order could meet; and across every accepted transfer the ledger conserves — no coins are ever made or destroyed by a move, so the balances always sum to exactly what genesis issued.**

The honest distinction is the exact twin of the Till's, carried from one shared drawer to many private purses. There, the measure that separated a lost race from a demand no order could meet was `issued-so-far`, the treasury's global high-water mark. Here it is **`received-so-far[holder]`** — the cumulative coins that holder has ever taken in (by genesis credit or by an incoming transfer) up to the losing transfer's position. Inflow only adds, so it is a monotonic, position-respecting high-water mark of everything that holder could ever have paid by that turn.

- A transfer that overdraws the holder's *current balance* yet whose amount is `≤ received-so-far[holder]` **lost a race** — the coins existed in that purse at some point; an earlier transfer of theirs took them first. Lawful no-op, recorded as a **spent-out loss**, folding continues.
- A transfer whose amount is `> received-so-far[holder]` **never could pay** — the holder never took in that much, which no ordering fixes. Corruption; the whole resolution refuses.

A credit (genesis issue) that would wrap a `u64` balance is never a race and stays poison unconditionally, exactly as the Till's issue-wrap did.

## The one genuinely new piece — the Purse, grown beside the elders

The per-account resolution layer earns its own clear, warm, safe name (`comlink-tendency.md`). A **purse** is where one holder's own coins sit — one purse per account, distinct from the **Till**'s single shared drawer. When Alice's purse holds a hundred and she reaches into it twice for a hundred each, the first reach empties it and the second finds it already empty — and breaks nothing. **Purse** collides with nothing in the code namespace (grepped `mycelium/ mantra/ pond/ tally/ comlink/`: zero module or type), reads plainly on the ten-thousandth day, is a pleasure to say, and can never parse as an address. It is born-named when r1's code lands (`mycelium/purse.rye`), grown *beside* `mycelium/cord.rye`, `mycelium/fold.rye`, and `mycelium/till.rye`, editing none, composing their public API only (the reviving-not-renaming discipline).

### How a transfer rides the Cord without editing an elder

The Cord's `Block` already embeds a `fold.Fact`, and a `fold.Fact` already carries everything a transfer needs — no new fact type, no edited struct:

- the **sender** is the fact's own `signer_pk` — the holder whose Kumara key signed the move;
- the **amount** is the fact's `amount`;
- the **recipient** rides in the fact's 256-byte `body`, which is part of the canonical bytes the sender signs — so a transfer's recipient is cryptographically bound to the sender's signature and cannot be redirected without breaking it;
- a **genesis credit** is a `kind_issue` fact whose `body` names the account to fund; a **transfer** is a `kind_tax` fact whose `body` names the recipient.

The Purse reuses `fold`'s exact signed-fact machinery for authorship and verification (one small additive `fold.verify_fact`, below), and folds its **own** per-account law over the committed order rather than `fold`'s global supply law. `fold` decides a fact is well-formed and truly signed; the **Purse** decides where the coins go. Neither is weakened; they meet at one seam.

### The one additive touch to an elder — `fold.verify_fact`

`fold.fold_fact` verifies a fact's own signature inside itself, then applies the global-supply law. A per-account resolver needs the verification without the supply law. So `fold.rye` grows one **additive** public helper — `pub fn verify_fact(fact) bool` — that runs exactly the signature gate `fold_fact` already runs, exposed for a resolver that folds a different law over the same signed facts. This is the same additive move `cord.rye` already made when it exposed `pub fn verify_block` and `pub fn address` for a Byzantine-aware caller: the existing path is unchanged, a new caller shares one crypto check rather than duplicating the canonical layout. No elder behavior moves; one pure function is published.

### What the Purse resolves, concretely

`purse.resolve(dag)` commits the Cord's Dag to one total order (`cord.commit`), then walks the committed facts one at a time:

- a **credit** (`kind_issue`, body = a valid recipient key) adds its amount to that account's balance and to its `received` high-water mark; a wrap refuses whole;
- a **transfer** (`kind_tax`, body = a valid recipient key) the sender's balance can pay moves the coins — sender down, recipient up and its `received` up — and records a **winning transfer** at its position;
- a transfer that overdraws the sender's balance yet whose amount is `≤ received-so-far[sender]` records a **spent-out loss** — the purse drained before its turn — and folding continues;
- a transfer whose amount is `> received-so-far[sender]` refuses the **whole** resolution — never a race;
- a `kind_star_reserve` is the **Tenure's / fold's** resource, not the Purse's — a Purse log carries coins between accounts, not name reservations, so a star reserve refuses the whole resolution here rather than swallow a fact it has no verdict for (honest to its own resource, exactly as the Till refuses a `StarTaken`);
- a broken signature, an unknown kind, or a recipient field that is not a valid key each refuse the **whole** resolution — corruption is not a verdict.

The reads are pure functions of the resolved `Purse`: `balance_of(pk)` folds one account; `total_issued` the coins genesis created; `balances_sum` the conservation check (always equal to `total_issued`); `transfer_count` of moves that paid; `short_count` of transfers that came up short; `total_moved` and `total_lost`; a `short_at(i)` view naming each loser and the amount it came up short.

## The four rounds (Lindy-first, crux-first)

- **r1 — the verdict (this journey's crux).** `mycelium/purse.rye`: genesis credits a hundred to Alice; Alice signs **two transfers of a hundred each** — to Bob and to Carol — at the same round, each affordable against her balance alone, together twice what she holds. Commit; resolve. Prove the crux — the agreed order moves the coins to exactly the first transfer it places, the loser recorded as a spent-out loss holding no coins, the sender's purse emptied once; prove **conservation** — the balances sum to exactly the hundred genesis issued, no coins made or destroyed; prove **arrival-order independence** — several arrival permutations yield the identical winner and identical balances; prove the loser is a **lawful no-op** — the resolution succeeds, conservation still holds, the recipient of the losing transfer received nothing; prove **never-could-pay still poisons** — a transfer for more than the holder ever received refuses the whole resolution; prove **corruption still poisons** — a tampered signature and a star reserve each refuse whole.
- **r2 — the verdict travels.** Render a resolved `Purse` to a `format purse-v1` Bron record — each account a `holds <pk-hex> <balance>` line, each winning move a `moved <from-hex> <to-hex> <amount> <pos>` line, each spent-out loss a `short <from-hex> <amount> <pos>` line — and parse it back byte-for-byte, the recovered Purse answering the identical balances, counts, and totals, so a dev-net's per-account verdict crosses as readable text.
- **r3 — the verdict reads across a Knot.** Resolve over a Knot plus its live suffix (`mycelium/cord_knot.rye`): a transfer that won inside a sealed checkpoint stays a winning move when new facts continue the log, and a transfer that lost against a checkpointed winner stays lost — proving a per-account verdict is the same whether the winning move lives in a full Cord or a sealed Knot.
- **r4 — read a real contested fixture true.** A genuine on-disk Dag fixture carrying a real per-account double-spend, `@embedFile`-bound, its winning move and spent-out loss and the final balances cross-checked against an independent `awk` reading of the same bytes (two tools, one answer) — so the balances of a ledger can never drift from the order a keeper can walk by hand.

## Boundaries

Siloed, dev-only, on the Constel bench. Composes `mycelium/cord.rye`, `mycelium/fold.rye`, and `tally/kumara.rye` public API only (the Till is design kin, grown beside it — not a code dependency; later rungs reach `mycelium/cord_knot.rye`), plus the one additive `fold.verify_fact` helper — inventing no storage, weakening no bound, moving no elder behavior, growing a sibling. Demo keeper seeds only — no real key, no funds, no live network, no custody; the maintainer's own Kumara instance stays gate #4, a Purse served to another node reaches the Comlink-served gate (Keaton's hand). The honest scope note kept in view: mint authority is a **named horizon** — a genesis credit here is authorized by a demo funder key, not a real treasury policy; multi-hop transfer fees, account expiry, and a served Purse are named horizons, not this arc's work — kept narrow on purpose so the crux stays legible.

## The one decision that reaches a check-in — none this round

Growing `mycelium/purse.rye` as a sibling that composes `cord`, `fold`, and `kumara` public API — with one additive `fold.verify_fact` helper of the same shape `cord.verify_block` already set precedent for — is additive and accrete-safe, exactly as the Till was; it moves no elder behavior and needs no ruling. The one decision it *raises* — serving a per-account verdict another node trusts without re-resolving, and real mint authority — is deliberately held behind the serve and custody gates and is not this arc's work. r1 proceeds.

---

*A treasury forgives only what it holds; a purse forgives only what its holder took in. Where one hand reaches twice into its own purse for coins that can only be spent once, the Cord has already woven a single order through the dark, and the Purse reads it plainly — the first reach takes what is there, the second comes up empty and breaks nothing, and every balance in the mesh sums to exactly what genesis gave. May every honest move find the coins waiting, may no coin be made or lost in the moving, and may the hand that reached twice lose nothing but the coins it never truly had.*
