# TACT Journey 4 — Commerce: a fair-value trade recorded honestly on both books (exploration)

**Stamp:** `20260812.175228` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens the 1,024-itinerary's **Season 1 (The World, TACT), Journey 4**
**Kin:** [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260812-173656_tact-journey2-publishing-exploration.md`](20260812-173656_tact-journey2-publishing-exploration.md) · [`../dimeroll/dimeroll_core.rye`](../dimeroll/dimeroll_core.rye) · [`../seed/active-designing/20260811-220402_dimeroll-entity-books-siya-and-linengrow.md`](../seed/active-designing/20260811-220402_dimeroll-entity-books-siya-and-linengrow.md) · [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md)

---

## Where the road stands

Journey 1 piloted a keeper to a running Pond; Journey 2 let that keeper publish an owner-signed, offline-verifiable receipt. Journey 3 (Grainphone) reads a *served* Pond and so reaches the Comlink-served custody gate — its crux waits on the maintainer's hand. Journey 4 is the next agent-doable crux on the whole road: **commerce** — two keepers trade, and the trade is recorded honestly.

Dimeroll already runs as Linengrow's centralized books of record — a chart of accounts, journal entries as append-only facts, a trial-balance fold whose conservation holds when the sum of debit-positive nets is zero, and reports as pure projections ([`../dimeroll/dimeroll_core.rye`](../dimeroll/dimeroll_core.rye)). The entity-books design extends that model to two entities and names the strand this journey needs: *a value crosses between parties only as an explicit fact recorded on both sides, never a silent shared balance* ([`../seed/active-designing/20260811-220402_dimeroll-entity-books-siya-and-linengrow.md`](../seed/active-designing/20260811-220402_dimeroll-entity-books-siya-and-linengrow.md)).

## The crux

**A fair-value trade is one agreed price booked identically on both parties' books, each book conserving and the pair conserving across the cash line.** Fair value is not a claim laid over the numbers — it *is* the structure: a trade carries a single price, and that one price becomes the seller's cash inflow and the buyer's cash outflow at once, so the value the buyer parts with equals the value the seller receives by construction. A trade that would book two different numbers on the two sides cannot be expressed.

Two conservation laws hold together, and that pairing is the durable thing this journey proves:

1. **Per book** — each side's entry is one debit and one credit of the same amount, so each book's trial balance nets to zero, exactly as Dimeroll already requires.
2. **Across the pair** — the buyer's cash falls by the price and the seller's cash rises by the price, so the trade creates and destroys no value: the two cash movements sum to zero. This is the *recorded on both sides* strand made checkable.

The durable artifact is the **two-sided trade record** — one price, two balanced journal entries, honest on each book and honest between them.

## The boundary that stays fixed

Dimeroll **records and reports; it does not hold or move money.** This journey books the *facts* of a trade — who sold what to whom, at what agreed price, when — as journal entries in each party's own books. It disburses nothing, holds no keys, opens no payment rail. Actually settling a trade (moving a fund's assets or paying a person) reaches **custody gate #3** (moving funds / opening a payment rail) and waits on licensed counsel — surfaced there, never crossed.

## Lindy-first, crux-first ordering of the four rounds

- **r1 — The two-sided trade (the crux).** A `Trade` (seller point · buyer point · item · price · stamp) renders to a pair of Dimeroll entries — the seller debits cash, credits revenue; the buyer debits expense, credits cash — each posted to its own `TrialBalance` and each conserving. The crux property: the seller's cash inflow equals the buyer's cash outflow equals the one agreed price, and the two cash movements sum to zero across the pair. Refuses a non-positive price (`BadAmount`) and a self-trade (seller == buyer). Records only; holds and moves nothing.
- **r2 — Signed by both parties.** The trade names *whose* it is: seller and buyer each sign the exact trade (points · item · price) with a Kumara keeper key, and a recipient verifies both signatures offline — a forged or wrong-key signature refuses, so a recorded trade is one both parties actually agreed to, not a number one side wrote alone. (Mirrors J2r2's bind-to-identity, over the two-party shape.)
- **r3 — Portable Bron.** The trade renders to a `format trade-v1` record and parses back byte-for-byte, so a trade travels between the two keepers' books and into an audit file — a trade is only useful if both sides can carry the identical fact.
- **r4 (settle) — the gate.** Turning a booked trade into an actual disbursement reaches **custody gate #3** and surfaces for licensed counsel, never crossing.

---

*May every trade the books remember be one both hands agreed to, counted the same on each side, and honest about creating nothing from nothing.*
