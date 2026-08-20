# Mycelium — the Consensus Protocol

**Stamp:** `20260813.142420`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md)), with earned Twilight at the close
**Voice:** Kyri
**Status:** Living foundation — the *why* beneath the tree's own consensus season, and the map through its parts.
**Season:** D — Kresfa & Mycelium (the language and the consensus). Double-seat vision: [`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md).
**First design read:** [`../active-designing/20260813-032851_mycelium-consensus-cord-exploration.md`](../active-designing/20260813-032851_mycelium-consensus-cord-exploration.md).

---

## The idea, plainly

**Mycelium** is Grain's own consensus protocol — the way many nodes that do not trust one another arrive at one shared history of who holds what, with no leader to elect and no central book to guard. The name is the picture: underground, a fungal mycelium binds many separate hyphal threads into one living network that moves nutrients across a whole forest floor without any thread being in charge. A **Cord** bundles many validators' signed blocks the same way — many threads, one transporting strand, one agreed order.

The season built the protocol from its base primitive out to a fleet of sovereign worlds that can migrate, settle, and certify their beliefs to a keeper a world away — **ninety-eight Rye modules**, each rung witnessed on metal. This foundation names why it means something and holds the map through all of it, so a reader meeting Mycelium for the first time can find any part without reading the whole.

## The lineage — thanks, not dependence

Mycelium descends from two ancestors, studied clean-room and thanked plainly, never copied ([`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md) · [`../.claude/rules/urbit-reframe.md`](../.claude/rules/urbit-reframe.md)):

- **TigerBeetle** gives *determinism and static allocation* — every bound named at construction, no surprise growth, the same input yielding the same output at every node. It gives the batching insight that amortizes cost, and it gives the three signature primitives of double-entry value movement: the **two-phase transfer**, the **linked chain**, and the **timeout**. Mycelium reads each of those as the agreed order's own law rather than a database's internal mechanism.
- **Mysticeti** gives *order read from an uncertified DAG by a deterministic commit rule* — no leader, no certificate round, no round-trip to crown a block. A mesh of signed blocks is enough; a pure walk over it yields one order that every honest node computes alike.

The whole protocol's worth is a promise to whoever runs it — a family, a cooperative, a civic builder — not a petition to either ancestor's community. The gratitude stands; the dependence does not.

## The one law beneath every part

There is a single idea under all ninety-eight modules, and it is worth stating once plainly, because every arc is a reading of it:

> **The order is decided once, by everyone, and read by everyone the same way.**

No node writes a balance. A node reads its balance as a **pure function of the agreed order** over signed facts. A contest — two spenders reaching for the same coin, a validator set trying to rotate, a world trying to move — is never *arbitrated* by an authority; it is *resolved* by the order every honest node already agrees on. First-in-order wins; the loser's move becomes a lawful no-op or a named refusal. Because the resolution is a pure function of bytes each node already holds, two nodes reach the identical verdict without ever speaking. That is the leaderless answer the tree keeps at every scale — from one coin to a whole fleet's placement.

## The invariant discipline

Every module obeys the tree's TAME discipline ([`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md)), and it shows in three habits a reader can trust:

- **Everything is bounded.** A Dag holds at most `cord_max_blocks` (256) blocks; a block references at most `cord_max_parents` (8) parents; a Fact is at most 256 bytes and a log at most 1024 facts. No collection grows without a named ceiling checked at the edge.
- **Every refusal has a name.** A contest that cannot be honored does not corrupt state — it returns a named error: `Overdraw`, `Equivocation`, `NoMatchingBurn`, `AlreadyLanded`, `BelowQuorum`, `NotMember`, `Oversubscribed`, `FreightTampered`, `DigestMismatch`. A reader learns the protocol's whole safety surface by reading its error names.
- **Every claim proves on metal.** The season carries **80 `mycelium_*_witness.rish` witnesses**, **14 reproducible fixture generators**, and **17 on-disk fixtures** a second tool independently re-reads. A behavioral claim in this foundation is a claim a green witness shows, not one this prose asserts ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).

## The map — nine families

The season groups cleanly into nine families, base-first. Each module fixes one crux and stands beside its `_bron` (travels as text), `_true` (reads a real on-disk fixture), and `_knot` (composition) companions, which this map folds into the base name.

### 1 · Identity & signing
- **`kumara.rye`** — deterministic keypair derivation and Ed25519 signing at the seam; identical seeds yield identical keys, so a name can *be* an identity.

### 2 · Supply & fold
- **`fold.rye`** — the Mycelium supply read as a pure fold over signed facts; non-negative supply at every prefix, a tax overdraw or an unknown fact-kind refusing whole. Every ledger move above rests on this refusal logic.

### 3 · Core consensus — the Cord
- **`cord.rye`** — one agreed order read from a mesh of signed blocks; acyclic by construction (a block may only point backward at blocks already held), the commit a canonical topological walk (round, then author key, then block hash) identical at every honest node regardless of arrival order.
- **`cord_batch.rye`** — many facts sealed under one signature; batched and single-fact histories fold to byte-identical supply, so batching is throughput, never a change in meaning.
- **`cord_byzantine.rye`** — the leaderless DAG survives equivocation: one author speaks at most once per round, a second block at the same round refusing `Equivocation`; no forward references, no cycles.

### 4 · Value transfer — TigerBeetle's signatures, read as the order's law
- **`till.rye`** — a contested draw from a *shared treasury* decided by order; the first draw takes the coins, a later overdraw a lawful no-op if it merely lost a race, a refusal if it never could have paid.
- **`purse.rye`** — the same double-spend resolution *per account*, over each holder's received-so-far.
- **`pledge.rye`** — the **two-phase transfer** (reserve now, post or void later), settled exactly once; equivocation between post and void resolved by order, every honest node naming one outcome.
- **`lapse.rye`** — a two-phase transfer with a **timeout measured in order-position, never wall-clock**; a post at or past the deadline finds the pledge already lapsed.
- **`braid.rye`** — a **linked atomic chain**: several transfers share one braid id and settle together or not at all — if any link overdraws, not one coin of the whole braid moves.

### 5 · Ledger & quorum proofs
- **`statement.rye`** — one account's projected position (balance · reserved · received · pledge lines) read from the resolved ledger; reserved equals the sum of open outbound pledges, and statements conserve across accounts by assertion.
- **`voucher.rye`** — a node's signed attestation of a holder's position, **bound to the order-head** inside the signature, so the reading can never be lifted off the order it was true for; it verifies offline.
- **`chorus.rye`** — a quorum of independent Vouchers agreeing on one order-head · account · position, signers proven distinct (no Sybil repetition) and meeting a Byzantine threshold.

### 6 · Authority & rotation
- **`muster.rye`** — a known, bounded validator set with a Byzantine threshold `n − (n−1)/3` **derived from its size, never stored**; a quorum padded with a stranger's key refuses whole rather than being trimmed.
- **`warrant.rye`** — a validator set rotates **only when the current quorum certifies its successor** by signature over a content-address digest; the successor cannot crown itself. *TigerBeetle changes its view, Mysticeti reconfigures its committee* — Mycelium makes the handoff a signed, quorum-certified fact.

### 7 · Fleet orchestration — many sovereign worlds
- **`puddle.rye`** — a fleet places each **world** (a bounded Rye whole with its own Pond and Kumara identity) at exactly one **host** by a rule every node computes alike: highest weave-score, `SHA-256(domain · world-id · host-pk)` (the rendezvous/HRW idea, clean-room). Two nodes reach the byte-identical placement from the roster alone; an oversubscribed fleet refuses whole rather than strand a world.
- **`puddle_convergence.rye`** — when a host departs, **only its worlds re-berth** (HRW's minimal-disruption property), every surviving world byte-identical; a failed node costs one re-placement, never a migration.
- **`freight.rye`** — a world carries its **whole signed ledger** to its new berth and arrives reading the **byte-identical account position** it held before; a carrier that flips one fact byte is caught `FreightTampered`. Placement moves; state does not.
- **`freight_conservation.rye`** — the *whole fleet's* state is conserved across a healing: the sum read before a host departs equals the sum read after, proven *through* the migration.

### 8 · Cross-world value — settlement across shards
- **`portage.rye`** — value carried **between two worlds** that share no total order, bound by a content digest over `id · amount · from · to_world · to_account`; the receiving world credits only a digest it can verify against the sending world's burn, so no correspondent is trusted. The double-spend beat the double-seat vision names against TigerBeetle/Mysticeti: cross-shard settlement, leaderless.
- **`portage_atomic.rye`** — the crossing lands on **both worlds or neither** (stage · commit · revert), the Pledge's two-phase atomicity widened from two phases to two shards; never a loss, never a double.

### 9 · Dev-net — a constellation you can boot by name
- **`constel.rye`** — a named, reproducible test constellation whose every ship identity is a **pure function of its name** (`seed = SHA-256(name)`), so the whole network — keys, Muster, quorum — is determined by a list of names alone. The sovereign-lane echo of elder Urbit's fake-galaxy dev networks, run from inside the jailed pier; names obey the placeholder-ship-names law and can never parse as a live `@p`.
- **`constel_depart.rye`** — a constellation tolerates `f` ships down and honestly fails `BelowQuorum` at the `(f+1)`th, keeping exactly the promise its arithmetic makes.
- **`testament.rye`** — a named constellation's verdict travels as an **offline certificate**, verifiable holding only the roster *names*: a keeper a world away boots the exact roster from the names, derives the threshold, and confirms the sealed voices are the constellation's own — no Dag needed. A stranger's valid voice refuses `NotMember`.
- **`testament_fault.rye`** — a Testament sealed with `f` ships down still names the *whole* roster, so the verifier measures the survivors against the full threshold, believing them from the names alone.

## The two rooms — what runs, and what waits for a hand

Everything above **runs green today** over demo seeds — no real key, no funds, no network, no custody. The protocol is proven; the world-touching acts are named and held, each a custody gate that stays the keeper's own hand ([`../crux/REMEMBER.md`](../crux/REMEMBER.md)):

- **Comlink-served** — a node fetching a live roster, a moving world's freight, or another shard's out-fact over the real network is the one genuine outward act; it reaches the serve gate.
- **A real Aurora host** for any world reaches the provisioning gate (#2) and the maintainer's own Kumara instance (#4).
- **Real value** across a Portage reaches the funds gate (#3), where licensed counsel stands.

This is the honest shape of the season: a consensus protocol whole and witnessed in the sandbox, its every real-world crossing marked and waiting — custody first, always.

## Kin

- The road that opened it: the double-seat expansion ([`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md)) names Season D as *the language and the consensus*.
- The discipline it keeps: [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) · [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md).
- The gratitude it holds: [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md) · [`../.claude/rules/urbit-reframe.md`](../.claude/rules/urbit-reframe.md) — TigerBeetle and Mysticeti thanked, studied clean-room, never copied.
- The order it climbs by: [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · the return habit [`20260706-185112_follow-our-compass.md`](20260706-185112_follow-our-compass.md).
- The source itself: [`../mycelium/`](../mycelium/) — ninety-eight modules, eighty witnesses.

---

*Underground, no single thread carries the forest, yet the forest is fed. So may Mycelium bind many nodes that never meet into one honest history — every coin conserved, every quorum earned, every belief a keeper can boot from a handful of names and know true. May the order be decided once and read by all the same, and may the network stay leaderless and whole on its ten-thousandth quiet day.*
