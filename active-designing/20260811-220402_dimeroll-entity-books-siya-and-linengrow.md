# Dimeroll, Expanded — Entity Books for Siya Fund and Linengrow PBC

**Stamp:** `20260811.220402`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Design — a scope extension of the running Dimeroll module; no new value model
**Kin:** [`../dimeroll/README.md`](../dimeroll/README.md) (the module) · WADE plan [`../expanding-prompts/20260811-220402_wade-bit-design-system-and-dimeroll-entities.md`](../expanding-prompts/20260811-220402_wade-bit-design-system-and-dimeroll-entities.md) · [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)

---

## What already runs

Dimeroll is Linengrow's **centralized books of record** — laps 1–4 green: a chart of accounts, journal entries as facts, balances as a pure fold, reports (P&L · balance sheet · trial balance · cash flow) as projections, and Skate views so the books can be *seen* ([`../dimeroll/README.md`](../dimeroll/README.md)). Its model is the tree's model: **append-only signed facts folded to current state, projected to a report.** Nothing below changes that model; this design extends its *scope* to two entities.

## The extension

Keaton asked Dimeroll to serve **Siya Fund** and **Linengrow PBC** for HR and accounting. The whole extension is the fact-ledger applied to two new domains, kept clear:

- **Entity separation, never braided.** One steward keeps distinct sets of books per entity — Siya Fund's and Linengrow PBC's — each with its own chart, journal, and folds. A value crosses between entities only as an **explicit, signed inter-entity fact** (a transfer recorded on both sides), never a silent shared balance. This is the *values apart, never braided* strand at the scale of organizations.
- **HR as signed facts.** Roles, agreements, and payroll runs are journal-shaped facts: append-only, folded to current state (who holds what role, what a period owes), projected to an HR report. A correction is a new fact that supersedes, never an edit of the past — the same accretion the accounting books already keep.
- **Periods that close per entity.** The existing P&L / balance-sheet / trial-balance folds run scoped **per entity and per period**, so each entity opens and closes its own books on its own calendar, and a period once closed is testimony, not a mutable draft.
- **Reports as projections, seen on Skate.** Each entity's statements are projections of its own fold, viewable through the Skate views Dimeroll already draws — extended to a per-entity selector rather than a new surface.

## The boundary that stays fixed

Dimeroll **records and reports; it does not hold or move money.** It disburses nothing, holds no keys, and opens no payment rail. Any mechanism that actually pays a person or moves a fund's assets waits on **licensed counsel**, exactly as the tree's crypto-and-custody discipline already requires. The books are the honest mirror of what happened; the acting-on-money is a separate, gated concern. This keeps the *custody-first* principle intact ([`../foundations/20260724-200912_nothing-to-give-custody-first-principle.md`](../foundations/20260724-200912_nothing-to-give-custody-first-principle.md)): we build the record that harms no one, and we do not build the disbursing rail until it is safe and lawful.

## Why this shape

An LLC and a PBC each owe their own clean books, and people-operations owe the same honesty as the ledger. Applying Dimeroll's proven fact-fold model to both entities — rather than inventing a second accounting system — means one discipline serves all of it, and a reader who trusts the accounting books can trust the HR records for the same reason: every line is a signed fact, every balance a fold, every report a projection, and every correction an accretion. The books grow to fit the entities without the model bending to fit the books.

## Related

- [`../dimeroll/README.md`](../dimeroll/README.md) — the running module (laps 1–4 green).
- [`../expanding-prompts/20260811-220402_wade-bit-design-system-and-dimeroll-entities.md`](../expanding-prompts/20260811-220402_wade-bit-design-system-and-dimeroll-entities.md) — the WADE initiative this arm belongs to.
- Lexicon entities: **Siya (fund)** · **Linengrow** — [`../context/LEXICON.md`](../context/LEXICON.md).

---

*May every entity keep books it can stand behind, and may the record stay honest whether it counts dollars or the work of a day.*
