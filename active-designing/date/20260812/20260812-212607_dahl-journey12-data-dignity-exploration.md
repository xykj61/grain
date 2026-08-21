# DAHL Journey 12 — Data-dignity, the keeper's word outliving the keeper (exploration)

**Stamp:** `20260812.212607` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — opens Journey 12 of Season 3 (Commons) in the 1,024-round itinerary
**Waymark:** **DAHL** (Harvest Equinox 3 — Commons, already seated; each journey is `DAHL-J<N>`)
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260812-210603_dahl-journey11-council-skies-exploration.md`](20260812-210603_dahl-journey11-council-skies-exploration.md) · [`../settlement/constellation.rye`](../settlement/constellation.rye) · [`../pond/apps/skate_group_signed.rye`](../pond/apps/skate_group_signed.rye) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the road stands

Season 3, Commons, Journey 11 (Council skies) stands complete end to end — a community loads a *sky* and the sky's odd fractal gives its council a tie-free majority quorum and a complete triad of modality roles. Journeys 9 through 11 built how living keepers meet: consent between two (Skate), quorum among many (Membership), a whole loaded shape (Council). The 1,024-round itinerary names Journey 12 as Commons' last and most tender crux — **Data-dignity**: what becomes of a keeper's data when the keeper is gone. The season promised *keepers meet each other with consent*; this journey extends that promise past a single lifetime — **consent, and the keeper's own word, outlive the keeper**.

This is a new domain, so the itinerary's filling law asks for a design read before the first round — this document.

## The durable promise this journey turns on

Everything the tree has built holds a keeper's data under a keeper's key: a settled identity, an owner-signed artifact, a signed circle, a signed council ballot. Each answers *whose is this, now*. None yet answers *whose is this when the keeper is no longer here to say* — and answering it badly is how custody systems betray the people they were built to serve. A steward who can seize a departed keeper's data has quietly held that power all along; an heir who inherits everything, including what the keeper meant to take to rest, has erased the keeper's last preference.

The settlement ledger already carries the seed of the honest answer. Its **transfer** ("hand") moves ownership on the keeper's word, and its **escape** re-parents a child *by its own word and the new sponsor's adoption, the old sponsor keeping no veto* — custody moves only when both the one who leaves and the one who receives consent, never by a third hand. Data-dignity carries that both-consent shape across the one boundary the ledger has not yet crossed: the keeper's absence. It is Lindy-durable because a succession rule is read for exactly as long as data outlives people — which is to say, always.

## The crux — succession honors the keeper's declared word, and rests what the keeper chose to rest

A naive succession hands the heir everything. A dignified succession hands the heir **exactly what the keeper willed to them, and no more** — and honors, as its whole point, the keeper's right to mark some holdings **rested**: extinguished at succession, inherited by no one, returned to no hand. The honest heart:

- **Custody passes only on two proofs, never one.** The keeper's own **directive** (their pre-declared word, sealed while they are present) *and* the heir's **acceptance** must both stand before succession fires. A directive without acceptance holds — an heir cannot be conscripted; an acceptance without a directive holds — a steward cannot manufacture a will. This is escape's no-veto, both-consent law carried to succession: neither the departing keeper's word alone nor the receiving heir's alone moves custody.
- **The heir inherits the bequeathed set exactly, and the rested set is extinguished.** Each holding the keeper wills is marked **bequeathed** (passes to the heir) or **rested** (the keeper's dignity choice — it is not seized, not inherited, held by no one after succession). After succession, a bequeathed item resolves to the heir and a rested item resolves to `rested` — never to the heir, never to a steward. The rested set's extinction is the promise made checkable: the count the heir holds equals the bequeathed count, and no rested item is ever the heir's.
- **The outcome is derived, never written.** Who holds an item is *computed* from the sealed will and the succession state — before succession the keeper, after it the heir-or-rested by the will's own marks — so no hand can write a holder the keeper did not authorize, exactly as the council's outcome is derived from its tally.

The crux is the **two-proof gate and the rested set together**: a keeper's data outlives them held by no more and no less than the keeper willed, and the one preference a departed person can no longer defend — to let some things rest — is the one the rule guards hardest.

## Why this shape, against the alternatives

- **Not the constellation's `transfer`.** The ledger's `hand` moves a *settled point's* ownership between two living keepers on the keeper's live word. Succession is different in kind: the granting keeper is *absent* at the moment custody moves, so their word must have been **sealed in advance** and the heir's acceptance must complete it. Data-dignity composes the both-consent *shape* of escape without reusing a transition that assumes a live grantor.
- **Not "the heir inherits everything."** That erases the keeper's last preference and hands a steward a seizure path dressed as inheritance. The rested set exists precisely so a keeper's dignity — the right to let some data end with them — is a first-class, checkable outcome, not an afterthought.
- **Not signed yet, at r1.** Round one fixes the *rule* as a pure bounded state machine — an estate, a sealed will of bequeathed/rested marks, a two-proof succession gate, a derived holder — exactly as `council_sky` r1 and `skate_group` r1 fixed their laws before signing. In r1 the keeper's directive and the heir's acceptance are recorded facts; r2 binds each to a settled Kumara identity, mirroring `skate_group_signed`, so the keeper's sealed word and the heir's acceptance are each a real signature a steward cannot forge.

## The four rounds (Lindy-first, crux-first)

- **r1 — The estate, the sealed will, the two-proof succession.** `pond/apps/data_dignity.rye`: a `Estate` opens naming a keeper and a distinct heir (`SelfHeir` refused — succession to oneself is empty); the keeper wills each holding **bequeathed** or **rested** (`AlreadyWilled` on a repeat, `EstateFull` at the bound), then **seals** the directive. The heir **accepts**. `succeed` fires only when the directive is sealed (`NotDeclared`) and the heir has accepted (`NotAccepted`) — either alone holds custody with the keeper. `holder_of` is derived: before succession every willed item is the keeper's; after, a bequeathed item is the heir's and a rested item is `rested` (no one's), an unwilled item `unknown`. The crux made checkable: succession from one proof alone refuses; after a two-proof succession the heir holds exactly the bequeathed set and every rested item resolves to `rested`, never the heir; the holder is derived, so no outcome can be written past the will.
- **r2 — Signed.** `pond/apps/data_dignity_signed.rye`: the keeper's directive is sealed by the keeper's settled Kumara identity over the exact facts (a tag, the estate id, the heir point, and the will's own marks), and the heir's acceptance is signed by the heir's identity, each verified against a caller-supplied keyring, mirroring `skate_group_signed`. A steward cannot forge either proof; alter a bequeathed-to-rested mark after the keeper sealed it and the directive signature falls.
- **r3 — Travels.** `pond/apps/data_dignity_bron.rye`: render an estate's keeper, heir, sealed will, and both signed proofs to a `format data-dignity-v1` Bron record and parse it back byte-for-byte, still dignity-honest offline (a directive signature flipped after the crossing refuses; the rested set still extinguishes on rebuild); unknown/missing field · bad header · bad hex each refuse.
- **r4 — Read-true.** `pond/apps/data_dignity_true.rye`: carry the reader onto a real fixture (`skate/fixtures/estate.bron`, real Ed25519 directive and acceptance signatures, produced reproducibly by an in-tree generator) and cross-check the bequeathed count, the rested count, and the heir-held count against an independent measure (an awk truth script) — two tools, one answer — so a succession's outcome can never drift from what a keeper can count by hand.

## Boundaries (custody-first)

Data-dignity records the *facts* of a keeper's sealed will and a succession, and holds nothing — it opens no network, moves no funds, generates no real identity, and touches no real seed. The maintainer's own succession, over the maintainer's real Kumara instance, is the maintainer's hand alone (gate #4-adjacent — a real seed and keeper); a succession served or enacted over the wire reaches the serve custody gate. Everything above — the pure rule, signing over demo seeds, Bron travel, reading a real fixture — is agent-doable and does not wait. Demo keeper and heir points (plain indices) only.

---

*May a keeper's word outlive the keeper, an heir receive only what was freely given, and whatever a person chose to let rest be allowed, with dignity, to rest.*
