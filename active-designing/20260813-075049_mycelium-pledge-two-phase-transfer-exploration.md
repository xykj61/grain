# Mycelium Pledge — the two-phase transfer decided by the order

**Stamp:** `20260813.075049` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — opens Mycelium's next journey (the Pledge arc, r1–r4)
**Kin:** [`../mycelium/purse.rye`](../mycelium/purse.rye) · [`../mycelium/cord.rye`](../mycelium/cord.rye) · [`../mycelium/fold.rye`](../mycelium/fold.rye) · the closed arc [`20260813-073500_mycelium-purse-true-real-fixture-exploration.md`](20260813-073500_mycelium-purse-true-real-fixture-exploration.md)

---

## Where the road stands

The Mycelium consensus engine stands: the **Cord** derives one total order from a
Byzantine mesh, the **Knot** ties off the committed past so a ledger runs forever, and
three application ledgers read that order as their own law — **Tenure** (a contested
name names one holder), **Till** (a shared treasury's double-spend), and **Purse** (a
per-account double-spend). Each reused fold's signed-fact machinery and folded its own
law over the agreed order, editing none of cord, fold, or kumara.

Every ledger so far settles a transfer in a **single** committed fact: the coins move, or
the transfer comes up short, the moment the order places it. Yet the truest thing a value
ledger owes a real trade is **atomicity across two steps** — funds reserved now, and
*then* either honored or released, so a multi-party exchange either wholly commits or
wholly reverses. That is TigerBeetle's signature: the **two-phase transfer** (pending →
post-or-void). It is the next Lindy-first crux on the whole Mycelium road, and it is the
first ledger whose honesty lives not in one fact but in the *relationship* between two.

## The crux — one pledge, resolved once by the order

A **pledge** reserves coins without moving them: the signer's spendable balance falls, a
matching **reserved** amount rises, and an open pledge record is seated under a pledge id.
A later **post** honors the pledge — the reserved coins reach the named recipient. A later
**void** releases it — the reserved coins return to the pledger. The pledge is settled
exactly once.

The crux is what happens when a holder **equivocates** — signs *both* a post and a void
for the same pledge at the same round, exactly as the Purse's double-spender signed two
transfers of coins she held once. No arrival order may leave the pledge both honored and
released, and no two honest nodes may disagree on which won. The Cord already answers this:
its total order is deterministic regardless of arrival, so the **first** resolution the
order places decides, and the second is a lawful no-op. Every honest node names the same
outcome — proven, as the Purse proved it, by resolving every arrival permutation to one
identical verdict.

Conservation is the standing invariant, widened by one column: at every step the sum of
all **spendable balances** plus all **reserved holdings** equals exactly what genesis
issued. A pledge moves coins from balance to reserved (sum unchanged); a post moves them
from reserved to a recipient's balance (sum unchanged); a void moves them from reserved
back to balance (sum unchanged). No coin is made or destroyed by any phase.

## How a phase rides the Cord, editing nothing

`fold.verify_fact` trusts a fact by its signature over `kind · amount · star · body` — it
does not restrict the kind, so the Purse already folds its own law over `kind_tax` facts,
reading the recipient from the signed body. The Pledge reads the same signed facts and
discriminates the phase by a **body tag**, an honest structured body bound to the signer's
signature so it cannot be redirected:

- **Pledge** — body `P · id(16) · to(32)`: reserve `amount` from the signer.
- **Post** — body `H · id(16)`: honor the pledge named by `id`.
- **Void** — body `V · id(16)`: release the pledge named by `id`.

A post and a void carry the pledge's own amount (positive, so `mint_fact` accepts a
`kind_tax` fact), and the resolution's signed amount **must equal** the referenced pledge's
amount, else the fact is malformed — the signature binds the phase, the id, and the sum
together.

## The verdicts, honestly

- **Reserve past balance, once affordable** (`amount <= received-so-far`) — a lost race, a
  lawful no-op, exactly the Purse's spent-out short; folding continues.
- **Reserve past ever-received** — never could pay, no order fixes it; refuses whole.
- **Resolve an unknown pledge id** — a resolution referencing nothing; refuses whole.
- **Resolve a pledge already settled** — the order already decided; a lawful no-op.
- **Resolve by a signer who is not the pledger** — only the pledger settles their own
  pledge; refuses whole.
- **A resolution whose amount disagrees with its pledge, a malformed body, an unknown
  kind, a star reserve** — each refuses whole, honest to its own resource.

## The arc (r1–r4, the seated rhythm)

1. **r1 — the crux.** `mycelium/pledge.rye`: reserve · post · void folded over a
   code-seated scene; the equivocation resolved once across every arrival permutation;
   conservation over balance + reserved; every refusal held.
2. **r2 — travels as a record.** `pledge_bron.rye`: the verdict renders to a
   `format pledge-v1` record and parses back byte-for-byte, conservation as the record's
   own law.
3. **r3 — reads across a Knot.** `pledge_knot.rye`: the two-phase verdict reads one hand
   whether the pledge lives in a full Cord or a sealed checkpoint.
4. **r4 — true to the bytes.** `pledge_true.rye` + `pledge_fixture_gen.rye` + an
   independent awk: a real on-disk record carrying a genuine pledge-equivocation reads
   true (app == awk over the same bytes a keeper can walk).

## Discipline

Additive — composes `cord` + `fold` + `kumara` public API only, editing none of them, as
Tenure · Till · Purse each did. Siloed, dev-only, demo seeds — no real key, no funds, no
network, no custody. A served pledge reaches the Comlink-served gate (Keaton's hand), the
same held horizon every Mycelium ledger names.

*A promise held in the dark, and one order to decide whether it is kept or let go — never
both, and the same for every honest hand. The Pledge arc opens here.*
