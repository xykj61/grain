# Mycelium Braid — the linked chain that commits whole or not at all

**Stamp:** `20260813.081709` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design read — opens Mycelium's next journey (the Braid arc, r1–r4)
**Kin:** [`../mycelium/purse.rye`](../mycelium/purse.rye) · [`../mycelium/pledge.rye`](../mycelium/pledge.rye) · [`../mycelium/cord.rye`](../mycelium/cord.rye) · [`../mycelium/fold.rye`](../mycelium/fold.rye) · the closed arc [`20260813-075049_mycelium-pledge-two-phase-transfer-exploration.md`](20260813-075049_mycelium-pledge-two-phase-transfer-exploration.md)

---

## Where the road stands

The Mycelium consensus engine stands, and four ledgers read its order as their own law.
The **Cord** derives one total order from a Byzantine mesh; the **Knot** ties off the
committed past so a ledger runs forever; **Tenure** names one holder for a contested name,
**Till** decides a shared treasury's double-spend, **Purse** decides a per-account
double-spend, and **Pledge** carries a single transfer across two phases — reserved now,
then honored or released, decided once by the order (TigerBeetle's two-phase transfer).

Each of those settles the fate of **one** transfer. Yet a real exchange is rarely one move:
a payment routes through a hop, a swap trades one thing for another, a settlement touches
three books at once — and every step must land **together or not at all**, so no observer
ever sees the chain half-applied. That all-or-nothing across *several* linked moves is
TigerBeetle's other signature — **linked events** — and it is the next Lindy-first crux on
the whole Mycelium road: the first ledger whose honesty lives not in one fact, nor in the
relationship between two, but across an ordered **chain** of many.

## The crux — a chain that commits whole or reverses whole

A **Braid** is an ordered chain of linked transfers sharing one 16-byte **braid id**, each
link a signed `kind_tax` fact carrying its **sequence** in the chain and a flag marking the
**last** link. The links chain on the Cord causally — link `k+1` names link `k`'s block as
its parent — so the agreed order always places `seq 0, 1, 2, …` in order, no matter what
order a node first *heard* the blocks. When the final link commits, the chain is complete,
and the order resolves it as **one atom**:

- If **every** link can afford its transfer at its point in the chain — reading each
  sender's balance forward through the chain's own earlier moves — the whole braid
  **commits**: every coin moves.
- If **any** link cannot afford its transfer, the whole braid **rejects**: not one coin
  moves, not even the earlier links that would have paid on their own.

The crux is exactly that last line. A three-link braid whose first two steps each afford
alone, but whose **final** step overdraws, must leave the ledger **untouched** — the atom
is indivisible, so an early success cannot survive a late failure. And because the Cord's
order is deterministic regardless of arrival, every honest node names the identical
commit-or-reject verdict — proven, as the Purse and the Pledge proved it, by resolving
every arrival permutation of the chain's blocks to one identical ledger.

Conservation is the standing invariant, unwidened: a committed braid moves coins between
accounts (no coin made or destroyed), and a rejected braid moves nothing, so the balances
always sum to exactly what genesis issued.

## How a link rides the Cord, editing nothing

`fold.verify_fact` trusts a fact by its signature over `kind · amount · star · body`
without restricting the kind, so the Braid reads the same signed `kind_tax` facts the Purse
does and discriminates a link by a body tag bound to the signer's signature, so it cannot be
redirected:

- **Link** — body `L · id(16) · seq(1) · last(1) · to(32)`: the signer transfers `amount`
  (the fact's own amount) to `to`, as sequence `seq` of the braid named by `id`; `last=1`
  closes the chain.

A link's `amount` is positive (so `mint_fact` accepts the `kind_tax` fact), and every link
in a braid may carry a **different signer** — the chain routes coins hand to hand, which is
the whole point of atomic linking. A genesis credit is a `kind_issue` whose body names the
account to fund, exactly as the Purse's.

## The verdicts, honestly

- **A braid whose every link affords** (forward through the chain) — commits whole; every
  coin moves; the braid is recorded committed.
- **A braid any link cannot afford** — rejects whole; no coin moves; the braid is recorded
  rejected (a lawful atomic failure, folding continues — the twin of the Purse's spent-out
  short, carried from one move to a chain).
- **A braid whose final link never arrives** — stays **pending**; no link applied; a
  natural open state at the ledger's end, the twin of an open pledge.
- **A link out of sequence** (a gap, a repeat, a seq past the chain bound), **a malformed
  body, an unknown kind, a star reserve, a broken signature** — each refuses the whole
  resolution, honest to its own structure.

## The arc (r1–r4, the seated rhythm)

1. **r1 — the crux.** `mycelium/braid.rye`: a linked chain folded over a code-seated scene;
   an all-affording chain commits whole, a chain whose last step overdraws reverses whole;
   the verdict identical across every arrival permutation; conservation over every path;
   every refusal held.
2. **r2 — travels as a record.** `braid_bron.rye`: the verdict renders to a
   `format braid-v1` record and parses back byte-for-byte, conservation as the record's own
   law.
3. **r3 — reads across a Knot.** `braid_knot.rye`: the linked-chain verdict reads one hand
   whether the braid lives in a full Cord or a sealed checkpoint.
4. **r4 — true to the bytes.** `braid_true.rye` + `braid_fixture_gen.rye` + an independent
   awk: a real on-disk record carrying a genuine reverting chain reads true (app == awk over
   the same bytes a keeper can walk).

## Discipline

Additive — composes `cord` + `fold` + `kumara` public API only, editing none of them, as
Tenure · Till · Purse · Pledge each did. Siloed, dev-only, demo seeds — no real key, no
funds, no network, no custody. A served braid reaches the Comlink-served gate (Keaton's
hand), the same held horizon every Mycelium ledger names.

*Many strands drawn tight into one — they hold together or come undone together, and never
does one hand see the braid half-woven. The Braid arc opens here.*
