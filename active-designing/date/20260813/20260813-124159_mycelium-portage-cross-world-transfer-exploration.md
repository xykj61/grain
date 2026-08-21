# Portage — value carried across two worlds, atomic on both ledgers or neither (Exploration)

**Stamp:** `20260813.124159` · **Status:** Vision -- Living (self-approved design read) · **Voice:** Kyri
**Register:** Radiant · **Season:** D (Kresfa & Mycelium) — the double-seat expansion
**Kin:** [`the Freight migration`](20260813-121424_puddle-freight-world-state-migration-exploration.md) (a world moves whole) · [`the Pledge`](20260813-075049_mycelium-pledge-two-phase-transfer-exploration.md) (two phases within one ledger) · [`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## What Portage is

The Mycelium season built a value ledger that settles honestly **within one world** — the Purse conserves coins, the Pledge reserves and honors them in two phases, Statement reads any account's position, and Puddle and Freight proved a whole world can move hosts and arrive with its state byte-identical. Yet every coin so far lived and died inside a single Cord. A real economy is many ledgers, and its truest question is the one no single-world ledger can answer: **how does value cross from one world to another without a moment where it exists in both or in neither?**

A **portage** is that crossing — the old word for goods carried overland between two navigable waters that share no channel. Alice banks on World A; Bob banks on World B; the two worlds keep separate Cords with no shared total order. A portage moves N coins from Alice to Bob so that either both ledgers record the move or neither does, and the two worlds **conserve together** — the sum of value across the pair is exactly what it was before. This is cross-shard atomic settlement: the frontier the vision names as the one worth beating TigerBeetle and Mysticeti at ([`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md), Season D).

## The blind spot, and the trap it hides

Every module the season built conserves value it can see in **one** order. Two independent Cords have two independent orders; nothing forces them to agree. The naive cross-world transfer — debit A, then credit B — hides the deepest trap in distributed value: a window where the coins are gone from A and not yet on B (a loss), or, if you credit first, present on both (a double). A scheduler that reshuffled *placement* safely (Puddle) says nothing about *value* crossing between the worlds it placed. Who guarantees the coins that left one world are exactly the coins that arrived at the other, and that no failure leaves them in the gap?

Banks answer with a correspondent and a settlement window you must trust. The content-addressed grain the season already keeps answers differently, and for free: **a credit on World B may reference the burn on World A by its own signed digest, so B can only mint coins whose matching debit it can verify, and A's debit is a reservation that reverses if B never lands it.** The atomic decision is a pure function of both ledgers' bytes — no correspondent to believe.

## The crux (r1) — value leaves A, arrives on B, and the pair conserves

The decisive, hard-but-tractable move is to show one portage moves N and conserves across the two worlds, and that World B cannot conjure value. A portage carries a content id: its **digest** is a SHA-256 over `id · amount · from-account · to-world · to-account`, so the two halves are bound to the same crossing and neither can be forged apart from the other. The portage law holds exactly when:

- **The coins genuinely leave World A.** A signed **portage-out** fact (`O·id·amount`, bound to the digest) removes N from Alice's spendable balance on World A's Cord — read through `statement.statement_for(lapse.resolve(dag_a), alice)`, her balance falls by exactly N.
- **The coins genuinely arrive on World B.** A signed **portage-in** fact (`I·id·amount`, bound to the identical digest) credits N to Bob on World B's Cord — read through Statement, his balance rises by exactly N.
- **The pair conserves.** The two-world sum — every position on A plus every position on B — is byte-identical before and after: the N that left A is the N that reached B, no coin made or destroyed by the crossing.
- **World B refuses an unbacked credit.** A portage-in whose digest matches no verified portage-out on World A refuses `NoMatchingBurn` — B cannot mint coins whose burn it has not seen, so value cannot be conjured across the gap. A second portage-in for one portage-out is a lawful no-op (`AlreadyLanded`): the crossing lands once.

The credit is **derived from a verified burn, never re-declared** — there is no `set_balance` on World B; the receiving world reads the sending world's signed out-fact exactly as its own keeper would, so no steward hands Bob coins that no Alice paid.

## The method — content-addressing makes the crossing free and safe

The insight mirrors Freight's: because each half of the portage is a signed fact carrying the identical content digest, the *decision* to honor the crossing is a pure function of the two ledgers' bytes, not of any correspondent's word. World B verifies the portage-out's signature and digest before it credits; World A's out-fact is a reservation, not a spend, so if B never presents the matching in-fact the reservation reverses and Alice keeps her coins (r2). The work is not to compute a settlement — it is to **prove** the honest crossing is the only one the bytes admit: that value left, that value arrived, that the sum held, and that the two dangerous cases (a credit without a burn, a burn never landed) are caught rather than trusted. Portage inherits accrete-never-break from the Cords it joins — a crossing is two appends, never a rewrite.

## The four rounds

- **r1 — the portage crux.** `mycelium/portage.rye`: two worlds, each its own Cord ledger; a signed portage-out burns N from Alice on A, a signed portage-in bound to the identical digest credits N to Bob on B; Alice falls by N, Bob rises by N, the two-world sum is byte-identical across the crossing, and a portage-in with no matching burn refuses `NoMatchingBurn` (a re-land is a lawful no-op).
- **r2 — atomic all-or-nothing.** The crossing is two-phase across shards: the portage-out reserves (like a Pledge) rather than spends, and the portage is committed only when the matching portage-in lands on B. A crossing whose in-leg never lands **reverses on the source** — Alice's reserved coins return, and the two-world sum is the same as if the portage never began. Neither a loss (gone from A, absent on B) nor a double (present on both) survives any arrival order.
- **r3 — the portage travels as text.** A `format portage-v1` record carries `id · from · to-world · to-account · amount · digest · out-head · in-head`; it renders and parses byte-for-byte, and a receiving world accepts a cross-world transfer by reading its record alone — the correspondent replaced by a readable receipt.
- **r4 — reads true.** A real on-disk fixture, produced reproducibly, cross-checked against an independent `awk` reading — two tools, one answer — so a fleet's cross-world settlement can never drift from a record a keeper reads by hand.

## Custody, held plainly

Demo world and keeper seeds only — no key held, no funds, no network, no real value crossed. A **served** portage (World B fetching World A's out-fact over Comlink) reaches the Comlink-served gate (Keaton's hand); a real Aurora host for either world reaches gates #2/#4. This journey builds the portage law on the bench, exactly as Pledge runs the two-phase law and Freight runs the migration law under quarantined demo seeds.

## Gratitude to silo

**Two-phase commit** and the **atomic-commitment** lineage (the distributed-database idea that a transaction spanning independent stores must decide once for all) — studied clean-room, carried as concept; here the coordinator is content, not a correspondent. **TigerBeetle** (deterministic double-entry over a single replicated log) and **Mysticeti** (low-latency BFT consensus) — thanked as the ledgers we learn from and mean to widen across shards; our own bounded Rye, our own SHA-256 digest binding the two halves.

---

*Two waters that share no channel, and one crossing that reads the same from either shore — may the coins that leave arrive, may none be lost to the gap between, and may the sum a keeper counts across both worlds be the sum that was always there.*
