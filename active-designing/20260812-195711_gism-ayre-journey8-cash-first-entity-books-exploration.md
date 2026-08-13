# Season 2 Journey 8 — Cash-first: entity books that balance, never braided

**Stamp:** `20260812.195711` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens Season 2, Journey 8 (Cash-first) of the 1,024-round itinerary
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260811-220402_dimeroll-entity-books-siya-and-linengrow.md`](20260811-220402_dimeroll-entity-books-siya-and-linengrow.md) · [`../dimeroll/README.md`](../dimeroll/README.md) · [`../pond/apps/commerce_trade.rye`](../pond/apps/commerce_trade.rye)

---

## Where the road stands

Season 2 (Yield) has proven every reading and owning module on real data, and now trades fairly: GISM read real tree documents and gave them a signed chain of custody; AYRE Journey 7 (Fair-trade) closed with a certificate bound to an honestly-booked fair-value trade. The itinerary's Season 2 names a last durable promise for the harvest's owning half — **Journey 8, Cash-first**: *books that balance for Linengrow PBC / Siya Fund — the accounting spine, custody and disbursement counsel-gated.*

## The crux, named

Dimeroll already keeps one steward's centralized books of record — a chart of accounts, journal entries as append-only facts, balances as a pure fold, and reports (income statement · balance sheet · trial balance · cash flow) as projections (laps 1–4 green). The entity-books design extends that model's *scope* to two organizations and names the one strand this journey turns on: **entity separation, never braided.** One steward keeps distinct books per entity — Siya Fund's and Linengrow PBC's — each with its own journal and folds, and a value crosses between them only as an **explicit inter-entity fact** recorded on both sides, never a silent shared balance.

So Journey 8's crux is *the segregated inter-entity transfer that conserves*: two entities whose own books each balance, a grant or transfer booked as one fact on both, the pair conserving across the cash line, and neither entity's fold ever seeing the other's entries. It is the *values apart, never braided* discipline at the scale of organizations — the same shape `commerce_trade` proved for a two-party trade, carried up from a single agreed price to two full entity journals that must each balance on their own.

## Grounding — real modules, no new value model

- **The fold** is `dimeroll_core`'s own `fold_journal` → `TrialBalance` → `fold_balance_sheet` / `fold_income_statement` / `fold_cash_flow`; nothing below changes the double-entry model. Each entity is a named journal folded exactly as the running module folds one steward's books.
- **The transfer** is a single inter-entity fact with two legs — the grantor debits an expense and credits cash; the grantee debits cash and credits revenue — booked on each entity's own journal, so the value the grantor parts with equals the value the grantee receives by construction (the same one-number tie `commerce_trade` proved across a trade's cash line).
- **The signing and travel** reach the halves the commerce and certificate rungs already proved — a steward signs the inter-entity fact (`kumara`, as `commerce_trade_signed` binds a trade), and a closed period travels as Bron (as the receipt and certificate rungs travel) — so the accounting spine inherits the tree's signed, portable, offline-verifiable discipline.

## The four rounds (Lindy-first, crux-first)

1. **J8r1 — the segregated inter-entity transfer (the crux).** Two named entities, each folding its own journal to a trial balance that conserves and a balance sheet that balances; a transfer booked as one fact on both entities' books; the pair conserves across the cash line (the grantor's cash falls by the amount, the grantee's rises by it, summing to zero); and segregation proven — an entry added to one entity's journal never changes the other's fold. Facts only; no funds move.
2. **J8r2 — the inter-entity fact signed.** The transfer is signed by the entities' stewards over the exact fact (grantor · grantee · amount · memo), mirroring `commerce_trade_signed`, so a transfer books between two entities only when both stewards vouched for the identical number.
3. **J8r3 — the closed period travels.** An entity's period folds to a sealed statement that renders to a `format entity-period-v1` Bron record and parses back byte-for-byte, still balancing — a closed period is testimony a recipient checks offline (mirroring the receipt and certificate travel rungs).
4. **J8r4 — the entity's books read true.** An independent measurement of a real journal fixture matches what the fold reports (mirroring GISM-J5r4's *true to the bytes*), so an entity's balance can never drift from the facts a keeper can add up by hand.

## Discipline this journey keeps

- **Records and reports; holds and moves nothing.** Dimeroll disburses nothing, holds no keys, opens no payment rail — actually paying a person or moving a fund's assets waits on **licensed counsel** (custody gate #3). The books are the honest mirror; acting on money is a separate, gated concern.
- **Additive.** Each rung composes `dimeroll_core` (and `kumara` where signed) over public API and re-runs the modules beneath it GREEN; nothing already seated is retired, and the double-entry value model does not bend.
- **Demo entities only.** Siya Fund and Linengrow PBC appear as named demo journals — no real ledger, no real steward key — exactly as the commerce and certificate rungs proved their shapes on demo seeds.
- **Witness before narrative.** Every rung closes on a GREEN witness on metal, TAME + width clean.

---

*May each entity keep books it can stand behind, may a value that crosses between them be one honest fact on both sides, and may the two never braid into a balance neither can explain.*
