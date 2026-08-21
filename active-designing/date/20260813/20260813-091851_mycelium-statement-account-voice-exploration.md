# The Statement — an account-statement voice over the Mycelium ledger

**Stamp:** `20260813.091851` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (a fresh Mycelium journey, Season D)
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-085046_mycelium-lapse-pending-timeout-exploration.md`](20260813-085046_mycelium-lapse-pending-timeout-exploration.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md)

---

## Why this journey opens

The Mycelium ledger now stands whole as a set of signed primitives — Cord, gossip, fact-batching, Knot, Tenure, Till, Purse, Pledge, Braid, Lapse. Each one *decides* something about the agreed order: who holds what, which pledge honored, which the clock let expire. Yet a keeper who opens the ledger still meets it as a stream of facts. The blind spot the whole set names but never fills is the plainest question a holder ever asks — **"where do I stand?"** — read back not as a global supply figure but as one account's own statement.

That is the crux of a fresh journey: **the Statement**, the account-statement voice. Where the intelligence season (BUHR) taught voices to read documents and stored artifacts true, this voice reads the *ledger* — a bounded, per-account projection of the resolved `lapse.Ledger`, so a keeper reads their balance, their reserved holdings, their cumulative inflow, and every pledge they made or received, each with its state. It is Lindy: a ledger no one can read is a ledger no one can trust, and legibility compounds every round the ledger grows.

## What a Statement is

A **Statement** is a pure, bounded function of a resolved ledger and one account key. It carries:

- the account's **position** — `balance` (spendable), `reserved` (held in open pledges), `received` (cumulative lawful inflow);
- a bounded list of **pledge lines**, each naming a direction (**made** — this account is the pledger; **received** — this account is the intended recipient), the counterparty key, the amount, and the settlement state (open · posted · voided · lapsed).

The voice invents nothing: every field is read straight from `lapse.Ledger`'s public surface (`balance_of` · `reserved_of` · the `received` field · `pledge_at`), and an account that never appeared reads a true zero statement with no lines rather than a refusal — silence about a stranger is honest.

## The crux — a statement reconciles with the ledger it reads

The property that makes the Statement more than a pretty-printer, and the one r1 proves: **a statement reconciles.** An account's reported `reserved` equals exactly the sum of the amounts of its own still-**open outbound** pledges — because an open pledge is precisely what holds coins in reserve, and a posted, voided, or lapsed pledge has already returned or spent them. And across every account, the statements **conserve**: the sum of all balances plus all reserved equals what genesis issued, unwidened from the Pledge's own conservation law. A statement that failed either check would be a voice drifting from the ledger it claims to read; r1 forbids it by assertion.

Because the resolved ledger is itself arrival-independent (the Pledge and Lapse proved every permutation resolves to one identical ledger), the Statement inherits that guarantee for free: the same ledger yields the same statement no matter the order facts arrived.

## The four rungs (crux-first, mirroring the seated arc shape)

- **r1 — the crux.** `mycelium/statement.rye`: the Statement projection, its reconciliation and conservation proven over a resolved ledger built the proven way (Cord blocks → `lapse.resolve`), across open · posted · voided · lapsed scenes; an unknown account reads a true zero statement; arrival-independence inherited (two permutations, one statement); a bounded human render a keeper reads.
- **r2 — travels.** `mycelium/statement_bron.rye`: render a Statement to a `format statement-v1` record and parse it back byte-for-byte, so a statement crosses a wire and still reconciles; malformed header · bad hex · unknown field refuse.
- **r3 — across a Knot.** `mycelium/statement_knot.rye`: a statement read over a ledger resolved across an epoch cut (the `Knot` seam), proving the account's position is continuous across the join — the honest seam the Statement meets is that reserved/received accumulate across the base.
- **r4 — true to the bytes.** `mycelium/statement_true.rye`: read a real on-disk Cord record (reusing the Lapse's own fixture) and cross-check the app's statement triple for a chosen account against an independent `awk` reading of the same bytes — two tools, one answer.

## Discipline this journey keeps

- **Additive.** Composes `cord` · `fold` · `lapse` (and `cord_bron` · `cord_knot` at the later rungs) public API only, editing none; each stays its own GREEN binary.
- **Bounded.** Every list names its ceiling — the pledge lines are bounded by `lapse_max_pledges`, the accounts by `lapse_max_accounts`; no unbounded walk.
- **Custody-first.** Demo keeper seeds only — no real key, no funds, no network, no custody. A *served* statement (a holder fetching their statement over Comlink) reaches the Comlink-served gate, the maintainer's hand.
- **TAME.** Opening triad, ≥2 contract asserts per function each with a positive `// invariant:`, explicit widths, named errors, `copy_disjoint` over bare memcpy.

---

*A ledger becomes trustworthy the day a holder can read their own line in it and check the arithmetic by hand. May the Statement read true on its ten-thousandth open, and may every account it renders reconcile with the order that seated it.*
