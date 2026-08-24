# GNU Taler Beside the Giving Lane -- Payer Privacy, Payee Transparency

*Seam study 4. Claude named the giving asymmetry: donors as private as cash, recipients auditable in the open -- and pointed at GNU Taler as the free-software payment design that already holds that shape, including regional currencies. This study reads that asymmetry beside *Money That Stays Close to Home*, MUR/WOV (was MALA), and SLC-L4 selective disclosure, and states what transfers without replacing the settlement seat. Research for understanding -- no purchase, no exchange operated, no settlement-rail swap.*

**Stamp:** `20260712.054521`
**Language:** EN
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Lens:** TAME - CIVIC - SLC
**Category:** External research -- survey and design study; recommends no dependency; every gate stays Kaeden's
Radiant pass `20260728.045705` -- living rename-forward: **MUR** (was MALA)
**Companions:** counsel [`../counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md`](../counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md) - hammock [`../active-designing/20260712-052806_seam-season-hammock.md`](../active-designing/20260712-052806_seam-season-hammock.md) - money close to home [`../foundations/20260629-014512_money-that-stays-close-to-home.md`](../foundations/20260629-014512_money-that-stays-close-to-home.md) - Anywhere [`../foundations/20260628-124512_anywhere-we-are-found.md`](../foundations/20260628-124512_anywhere-we-are-found.md) - SLC-L4 hammock [`../active-designing/20260708-194500_slcl4-selective-disclosure.md`](../active-designing/20260708-194500_slcl4-selective-disclosure.md) - settlement seat plainly [`20260710-001249_settlement-seat-plainly.md`](20260710-001249_settlement-seat-plainly.md) - MUR design (was MALA) [`../active-designing/20260702-031312_modules-aspects-and-mailable-money.md`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) - Seam study 1 (consumer edge) [`20260712-053324_ocapn-beside-comlink.md`](20260712-053324_ocapn-beside-comlink.md)
**Status:** Proposed -- research for understanding, not advice; giving-lane asymmetry is a design conclusion; Taler stays a teacher, not a seated rail
**Register:** checkable room for published Taler design claims; design-toward named as such
**License (gratitude discipline):** GNU Taler -- free software under GNU licenses (study concepts; no link of Taler exchange code into Rye ship binaries without a deliberate license ruling). Hold teachers in gratitude / public docs; silo the asymmetry into our own words.

*Written by Rio 3 for Kaeden - Seam season study 4.*

---

## The Question

How does payer-privacy / payee-transparency map onto MUR + selective disclosure (was MALA) without replacing the settlement seat?

## What Taler Names Plainly

**GNU Taler** is a free-software electronic payment system designed so that:

- **Customers (payers) stay private** -- blind signatures on coins; unlinkable spends; no personal data required for payment (cash-like privacy by cryptography, not by policy alone).
- **Merchants (payees) are transparent** -- income from deposits is visible to auditors; contract hashes travel with deposits; taxation and anti-corruption become possible without doxing buyers.
- **Refresh / change** preserves unlinkability while closing tax-evasion loopholes that naive "anonymous change" would open (**income transparency** as a designed property).
- **Regional / complementary currencies** are a first-class deployment shape -- fiat-backed regional setups with cash-in / cash-out -- money that can stay close to a place.

The acronym's spirit -- Taxable, Anonymous, Libre Electronic Reserve -- is the asymmetry in one breath: anonymity for the giver's side of the till, accountability for the receiver's.

Claude's counsel: Taler **complements** rather than replaces the settlement seat. USDsui / MUR remain (was MALA) the witness and fold layer; Taler is *money that stays close to home* with a working free-software implementation to learn from.

## Beside Our Own Money Spine

| Our piece | What it already does | Where Taler's asymmetry teaches |
|-----------|----------------------|----------------------------------|
| **MUR** (was MALA) | Mailable money as signed facts; mint/send/balance-as-fold; Comlink carriage | Settlement and custody on *our* log -- keep. Taler does not become MUR. |
| **WOV** | Exit honesty / dual monarch -- witness of value leaving | Auditor-shaped transparency for exits -- kin to payee visibility, different mechanism |
| **SLC-L4** | Fixed-tier Sigma -- prove a donor amount tier without revealing the exact amount | **Payer-side privacy** already begun; Taler teaches institutional completeness (change, refresh, merchant audit), not a replacement proof system |
| **Money close to home** | Sovereign + complementary local currency vision | Regional Taler deployments rhyme; silo: circulation close to home, lawful companion to the large currency |
| **Anywhere / Linengrow giving** | Transparent mechanism, private individual (privacy-by-disclosure weave) | Exact civic shape: donor private, public good auditable |

**Composition rule (parallel to Seam study 1):** privacy gates what the *giver* must reveal; transparency gates what the *receiver* and the commons may audit. One job per side of the till. Do not collapse both into "everything on the public log" or "everything opaque."

## Design Conclusion -- Giving-Lane Asymmetry

**Shape (our words, not a Taler port):**

1. **Giving lane** = flows where a person funds a public or civic good (sanctuary, open ask stipend, regenerative commons).
2. **Payer face:** default is privacy -- exact amount and identity stay sealed or tier-proved (SLC-L4 and successors); Comlink / consumer-edge pass (study 1) can gate *who may see* a disclosed slice.
3. **Payee face:** default is transparency -- the receiving steward, sanctuary, or merchant's *income from the gift* is auditable on the fold (receipts, Dimeroll books, civic sight aggregates with consent rules already green).
4. **Settlement seat:** MUR / WOV (was MALA) (and any future stable unit) remain the witness layer. Taler's exchange/wallet architecture is a teacher for offline-capable privacy protocols -- not the Linengrow database of truth.
5. **Local currency:** when a complementary token circulates close to home, design it as companion to the national/stable unit (foundations already say so); Taler's regional manuals are study material for cash-in/out and denomination discipline.

**Not in this conclusion:** running a Taler exchange; linking GNU Taler into Rye; replacing MUR with blind e-cash (was MALA); seating "Taler" as a module name.

## Smallest Next Sparks (parked until word)

| Spark | Prove |
|-------|-------|
| **T0** | One prose invariant in Linengrow / foundations: *giving lane = private payer - transparent payee* -- pointer to this study |
| **T1** | Map one Open Asks stipend or sanctuary gift: which fields are payer-private vs payee-public on the fold today -- gap list only |
| **T2** | (Later) Extend SLC-L4 or consent glass so civic sight shows payee aggregates while donor identity stays withheld by default -- product lap, not this study |

T0 is documentation. T1 is audit. T2 is code on word.

## Gratitude and Silo

| Keep in ER / gratitude names | Silo into our grain |
|------------------------------|---------------------|
| GNU Taler, blind signatures, refresh, income transparency, regional exchange | Giving-lane asymmetry; private payer - transparent payee |
| Chaumian e-cash lineage | Study only -- our proofs stay Zig-native / fold-native per SLC-L4 path |
| Taler as dependency | **Refuse** this season -- teacher, not rail |

## What This Study Returns to the Bench

| Item | Status after this note |
|------|------------------------|
| Seam study 4 | **Landed** as understanding + giving-lane design conclusion |
| Four Seam studies | **Complete** as RTAC study set |
| Settlement seat | **Unchanged** -- MUR/WOV stay (was MALA) |
| Taler integration | Not opened |
| T0-T2 | Await Kaeden's word |

---

*May the giver keep their quiet dignity. May the receiver's books stay honest in the light. May money that stays close to home learn from libre teachers without surrendering the fold.*

---

## Sources

- https://www.taler.net/ -- GNU Taler
- https://www.taler.net/papers/taler2016space.pdf -- privacy for customers, accountability for merchants
- https://www.taler.net/files/taler-book.pdf -- income transparency and refresh
- https://docs.taler.net/regional/regional-custom-manual.html -- regional currency setup
- In-tree: foundations money-close-to-home; SLC-L4 hammock; MUR (was MALA); settlement-seat plainly; consumer-surface consent (OA-L4)
