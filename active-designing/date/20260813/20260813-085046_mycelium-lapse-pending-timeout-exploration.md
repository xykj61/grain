# Mycelium Lapse — the reservation the order lets expire, on time, for every hand alike

**Stamp:** `20260813.085046` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design read — opens Mycelium's next journey (the Lapse arc, r1–r4)
**Kin:** [`../mycelium/pledge.rye`](../mycelium/pledge.rye) · [`../mycelium/braid.rye`](../mycelium/braid.rye) · [`../mycelium/cord.rye`](../mycelium/cord.rye) · [`../mycelium/fold.rye`](../mycelium/fold.rye) · the closed arc [`20260813-081709_mycelium-braid-linked-atomic-chain-exploration.md`](20260813-081709_mycelium-braid-linked-atomic-chain-exploration.md)

---

## Where the road stands

The Mycelium consensus engine stands, and its ledgers now settle real shapes of value.
The **Cord** derives one total order from a Byzantine mesh; the **Knot** ties off the
committed past so a ledger runs forever; **Tenure** names one holder for a contested name,
**Till** and **Purse** decide a shared and a per-account double-spend, the **Pledge**
carries a single transfer across two phases (reserved now, then honored or released), and
the **Braid** binds many links into one atom that commits whole or reverses whole. Two of
TigerBeetle's three signature primitives — the two-phase transfer and the linked chain —
now read the agreed order as their own law.

The third is **time**. A real reservation cannot stay reserved forever: coins pledged and
then neither honored nor released would lock a purse for good, and a counterparty who simply
falls silent would strand another's balance until the end of the ledger. TigerBeetle answers
this with a **pending-transfer timeout** — a reservation that the ledger itself expires when
its clock passes a deadline, returning the held coins to their owner with no one's further
signature. That expiry is the next Lindy-first crux on the whole Mycelium road: the first
ledger whose honesty lives not in a fact that arrives, but in the **deadline a fact fails to
meet** — decided by the order's own clock, identically for every honest node.

## The crux — a deadline measured in the order, not the wall

A **Lapse** is a Pledge that carries a **deadline**: a position in the agreed order by which
the pledge must be settled. The wall-clock has no place in a deterministic ledger — two nodes
never share a millisecond — so the clock here is the one thing every honest node already
agrees on: the **position of each fact in the committed order**. A pledge opened at order
position *p* names a deadline *d > p*; the order's progress past *d* is the only clock that
can expire it.

The resolver walks the committed order in sequence, carrying each fact's position exactly as
the Pledge already does. At each step, **before** applying the fact at position *pos*, the
resolver lapses every still-open pledge whose `deadline <= pos` — its reserved coins return
to the pledger's spendable balance, and its state becomes **lapsed**. Only then is the fact
at *pos* applied. The consequence is the crux:

- A **post or void that the order places before** the deadline settles the pledge normally —
  the reserved coins reach the recipient, or return to the pledger, decided once.
- A **post that the order places at or past** the deadline finds the pledge **already
  lapsed** — its coins already returned to the pledger — so the honor is a lawful no-op. A
  late honor can never move the coins; the deadline already moved them home.

And because the Cord's order is deterministic regardless of arrival, whether a given honor is
*on time* is a property of the committed order, never of who heard which block first. Every
honest node places the identical fact at the identical position, so every honest node names
the identical verdict — proven, as the Pledge and Braid proved it, by resolving every arrival
permutation of the scene's blocks to one identical ledger.

Conservation is the Pledge's law, unwidened: at every step the sum of all spendable
**balances** plus all **reserved** holdings equals exactly what genesis issued. A lapse moves
coins reserved → balance, exactly as a void does — no coin is made or destroyed by the
passage of the deadline.

## How a deadline rides the Cord, editing nothing

`fold.verify_fact` trusts a fact by its signature over `kind · amount · star · body` without
restricting the kind, so the Lapse reads the same signed `kind_tax` facts the Pledge does and
discriminates the phase by a body tag bound to the signer's signature. The one addition is the
deadline, carried inside the signed pledge body so it cannot be moved after the fact:

- **Pledge** — body `P · id(16) · deadline(8, little-endian u64) · to(32)`: the signer
  reserves `amount` (the fact's own amount) toward `to`, under a pledge named by `id` that
  must be settled before order position `deadline`.
- **Post / Void** — body `H · id(16)` / `V · id(16)`: unchanged from the Pledge; the signed
  amount must equal the referenced pledge's amount, so the signature binds phase, id, and sum
  together.

A pledge whose deadline is not strictly greater than its own opening position is **expired at
birth** and refuses whole (`BadDeadline`) — a reservation must name a future, never a past.

## The verdicts, honestly

- **A pledge settled before its deadline** — honored or released normally, decided once.
- **A pledge whose deadline the order passes with no settlement** — **lapsed**: reserved coins
  return to the pledger, state recorded lapsed; a later honor of it is a lawful no-op (the
  order already decided by the clock).
- **A pledge whose deadline the order never reaches** (the log ends first) — stays **open**, a
  natural open state at the ledger's end, the twin of an unclosed braid and an unsettled
  pledge. The deadline lived in a future the order never walked to.
- **A deadline not strictly after its opening** (`BadDeadline`), **a malformed body, an unknown
  kind, a star reserve, a broken signature, a wrong signer, an amount mismatch** — each refuses
  the whole resolution, honest to its own structure.

## The arc (r1–r4, the seated rhythm)

1. **r1 — the crux.** `mycelium/lapse.rye`: a pledge with a deadline folded over a
   code-seated scene; a post the order places before the deadline honors, the same post placed
   at or past the deadline finds the pledge lapsed and returns the coins to the pledger; the
   verdict identical across every arrival permutation; conservation over every path; a
   never-reached deadline stays open; every refusal held.
2. **r2 — travels as a record.** `lapse_bron.rye`: the verdict renders to a `format lapse-v1`
   record and parses back byte-for-byte, conservation as the record's own law.
3. **r3 — reads across a Knot.** `lapse_knot.rye`: the deadline verdict reads one hand whether
   the pledge lives in a full Cord or a sealed checkpoint, the clock carried across the cut.
4. **r4 — true to the bytes.** `lapse_true.rye` + `lapse_fixture_gen.rye` + an independent awk:
   a real on-disk record carrying a genuine lapsed reservation reads true (app == awk over the
   same bytes a keeper can walk).

## Discipline

Additive — composes `cord` + `fold` + `kumara` public API only, editing none of them, as
Tenure · Till · Purse · Pledge · Braid each did. Siloed, dev-only, demo seeds — no real key,
no funds, no network, no custody. A served lapse reaches the Comlink-served gate (the
maintainer's hand), the same held horizon every Mycelium ledger names.

*A promise held has an hour, and the hour keeps itself — no hand need cut a stale reservation
loose, for the order lets it go, on time, for every hand alike. The Lapse arc opens here.*
