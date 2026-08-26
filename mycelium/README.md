# Mycelium -- Grain's consensus protocol

**Language:** EN
**Status:** Living -- the consensus season, whole and witnessed over demo seeds - README seated `20260813`
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Voice:** Kyri
**Kin:** the *why* beneath this directory -- [`../foundations/20260813-142420_mycelium-the-consensus-protocol.md`](../foundations/20260813-142420_mycelium-the-consensus-protocol.md) - the road that opened it -- [`../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md) (Season D)

**Mycelium** is Grain's own consensus protocol -- the way many nodes that do not trust one another arrive at one shared history of who holds what, with no leader to elect and no central book to guard. The name is the picture: underground, a fungal mycelium binds many separate threads into one living network that feeds a whole forest floor without any thread being in charge. A **Cord** bundles many validators' signed blocks the same way -- many threads, one strand, one agreed order.

This directory is the code. The [foundation](../foundations/20260813-142420_mycelium-the-consensus-protocol.md) holds the *why* and the lineage; this README is the *map* -- so a reader meeting Mycelium for the first time can find any part from one page.

## The one law beneath every part

> **The order is decided once, by everyone, and read by everyone the same way.**

A balance is read rather than written. Every node computes it as a **pure function of the agreed order** over signed facts. A contest -- two spenders reaching for one coin, a validator set trying to rotate, a world trying to move -- is *resolved* by the order every honest node already agrees on, rather than *arbitrated* by an authority. First-in-order wins; the loser's move becomes a lawful no-op or a named refusal. Because the resolution is a pure function of bytes each node already holds, two nodes reach the identical verdict independently, each from bytes it already holds.

## The lineage -- thanks, not dependence

Mycelium descends from two ancestors, studied clean-room and thanked plainly, every line here written from our own understanding ([gratitude-licenses](../.claude/rules/gratitude-licenses.md) - [the Urbit reframe](../.claude/rules/urbit-reframe.md)):

- **TigerBeetle** gives *determinism and static allocation* -- every bound named at construction -- the batching insight, and the three signatures of double-entry value movement: the two-phase transfer, the linked chain, and the timeout.
- **Mysticeti** gives *order read from an uncertified DAG by a deterministic commit rule* -- no leader, no certificate round; a mesh of signed blocks is enough, and a pure walk over it yields one order every honest node computes alike.

## How to read a module

Each family names a **base module** that fixes one crux, and stands beside a small set of companions that share its name:

| Suffix | What it holds |
|--------|---------------|
| *(base)* | the primitive itself -- bounded, asserted, refusing by name |
| `_bron` | the same fact **travels as text** -- a `format ...-v1` Bron record that round-trips |
| `_true` | reads a **real on-disk fixture** from [`corpora/`](corpora/), a second tool cross-reading the same bytes |
| `_knot` | **composition** -- the primitive checkpointed or joined with another |
| `_fixture_gen` | the **reproducible generator** that emits a `corpora/` fixture byte-identically |
| `_bench` | a **measured** run where throughput is load-bearing |

Every module carries a `mycelium_<name>_witness.rish` witness under [`../tools/`](../tools/); a claim below is one a green witness shows, and this prose reports what it showed ([the two rooms](../context/TWO_ROOMS.md)).

## The map -- nine families

### 1 - Identity & signing
- [`kumara.rye`](kumara.rye) -- deterministic keypair derivation and Ed25519 signing at the seam; identical seeds yield identical keys, so a name can *be* an identity. (Seam symlink to [`../tally/kumara.rye`](../tally/kumara.rye).)

### 2 - Supply & fold
- [`fold.rye`](fold.rye) -- the Mycelium supply read as a pure fold over signed facts; non-negative at every prefix, an overdraw or unknown fact-kind refusing whole. Every ledger move rests on this refusal logic.
- [`fold_persist.rye`](fold_persist.rye) -- the fold state carried across a cellar-shaped sleep and rebuilt identical.

### 3 - Core consensus -- the Cord
- [`cord.rye`](cord.rye) -- one agreed order read from a mesh of signed blocks; acyclic by construction, the commit a canonical topological walk (round, then author key, then block hash) identical at every honest node regardless of arrival order.
- [`cord_batch.rye`](cord_batch.rye) -- many facts sealed under one signature; batched and single-fact histories fold to byte-identical supply, so batching is throughput, never a change in meaning.
- [`cord_byzantine.rye`](cord_byzantine.rye) -- the leaderless DAG survives equivocation: one author speaks at most once per round, a second block at the same round refusing `Equivocation`.
- [`cord_knot.rye`](cord_knot.rye) -- a cord checkpointed across a cut, the order surviving the seam.

### 4 - Contest decided by order
The one law applied where two moves reach for the same thing.
- [`till.rye`](till.rye) -- a contested draw from a *shared treasury* decided by order; the first draw takes the coins, a later overdraw a lawful no-op if it merely lost a race, a refusal if it never could have paid.
- [`purse.rye`](purse.rye) -- the same double-spend resolution *per account*, over each holder's received-so-far.
- [`tenure.rye`](tenure.rye) -- a contested **name** decided by the same order; the first claim in the agreed sequence holds it, a later claimant lawfully losing.
- [`pledge.rye`](pledge.rye) -- the **two-phase transfer** (reserve now, post or void later), settled exactly once; equivocation between post and void resolved by order.
- [`lapse.rye`](lapse.rye) -- a two-phase transfer with a **timeout measured in order-position, never wall-clock**; a post at or past the deadline finds the pledge already lapsed.
- [`braid.rye`](braid.rye) -- a **linked atomic chain**: several transfers share one braid id and settle together or not at all; if any link overdraws, not one coin moves.

### 5 - Ledger & quorum proofs
- [`statement.rye`](statement.rye) -- one account's projected position (balance - reserved - received - pledge lines) read from the resolved ledger; reserved equals the sum of open outbound pledges, statements conserving across accounts by assertion.
- [`voucher.rye`](voucher.rye) -- a node's signed attestation of a holder's position, **bound to the order-head** inside the signature, so a reading can never be lifted off the order it was true for; it verifies offline.
- [`chorus.rye`](chorus.rye) -- a quorum of independent Vouchers agreeing on one order-head - account - position, signers proven distinct (no Sybil repetition) and meeting a Byzantine threshold.

### 6 - Authority & rotation
- [`muster.rye`](muster.rye) -- a known, bounded validator set with a Byzantine threshold `n - (n-1)/3` **derived from its size, never stored**; a quorum padded with a stranger's key refuses whole rather than being trimmed.
- [`warrant.rye`](warrant.rye) -- a validator set rotates **only when the current quorum certifies its successor** by signature over a content-address digest; the successor cannot crown itself.

### 7 - Fleet orchestration -- many sovereign worlds
- [`puddle.rye`](puddle.rye) -- a fleet places each **world** (a bounded Rye whole with its own Pond and Kumara identity) at exactly one **host** by a rule every node computes alike: highest weave-score, `SHA-256(domain - world-id - host-pk)` (the rendezvous/HRW idea, clean-room). An oversubscribed fleet refuses whole rather than strand a world.
- [`puddle_fleet_fixture_gen.rye`](puddle_fleet_fixture_gen.rye) -- the four-host, six-world fleet the Puddle rungs read, rendered to a `format puddle-fleet-v1` record byte-identically every run, so the on-disk fixture is what the Puddle emits rather than a hand-mock. Its name carries a base no module wears, which is why it is named here rather than reached by rule.
- [`puddle_convergence.rye`](puddle_convergence.rye) -- when a host departs, **only its worlds re-berth** (HRW's minimal-disruption property), every surviving world byte-identical.
- [`freight.rye`](freight.rye) -- a world carries its **whole signed ledger** to its new berth and arrives reading the byte-identical position it held before; a carrier that flips one fact byte is caught `FreightTampered`.
- [`freight_conservation.rye`](freight_conservation.rye) -- the *whole fleet's* state is conserved across a healing, the sum read before a host departs equal to the sum read after, proven *through* the migration.

### 8 - Cross-world value -- settlement across shards
- [`portage.rye`](portage.rye) -- value carried **between two worlds** that share no total order, bound by a content digest over `id - amount - from - to_world - to_account`; the receiving world credits only a digest it can verify against the sending world's burn, so no correspondent is trusted.
- [`portage_atomic.rye`](portage_atomic.rye) -- the crossing lands on **both worlds or neither** (stage - commit - revert), the Pledge's two-phase atomicity widened from two phases to two shards; never a loss, never a double.

### 9 - Dev-net -- a constellation you can boot by name
- [`constel.rye`](constel.rye) -- a named, reproducible test constellation whose every ship identity is a **pure function of its name** (`seed = SHA-256(name)`), so the whole network is determined by a list of names alone; names obey the [placeholder-ship-names law](../.claude/rules/placeholder-ship-names.md) and can never parse as a live `@p`.
- [`constel_depart.rye`](constel_depart.rye) -- a constellation tolerates `f` ships down and honestly fails `BelowQuorum` at the `(f+1)`th.
- [`testament.rye`](testament.rye) -- a named constellation's verdict travels as an **offline certificate**, verifiable holding only the roster *names*: a keeper a world away boots the exact roster, derives the threshold, and confirms the sealed voices are the constellation's own -- no Dag needed. A stranger's valid voice refuses `NotMember`.
- [`testament_fault.rye`](testament_fault.rye) -- a Testament sealed with `f` ships down still names the whole roster, so the verifier measures survivors against the full threshold.

**The intelligence reading the ledger** lives one directory over, in [`../pond/apps/`](../pond/apps/) -- `ledger_query.rye` and its companions carry the same Lantern-shaped Q-vane voice every other Grain module speaks, reading the resolved ledger a person could not otherwise read by hand. Its witnesses count among the eighty below.

**Borrowed from Tally by symlink**, so one implementation serves both rooms: [`parse_int.rye`](parse_int.rye) (strict-by-default integer parsing, a leading zero refused) and [`tally_copy.rye`](tally_copy.rye) (the disjoint copy with both preconditions asserted), beside `kumara.rye` above, which family 1 names.

Supporting the nine: [`refusal_storm.rye`](refusal_storm.rye) gathers five primitives refusing loudly in one witness; [`ship_sol.rye`](ship_sol.rye) seals a `.sol` proof as a Kumara-signed fact; [`build_bounds.rye`](build_bounds.rye) asserts the season's ceilings match the seated Brix.

## Build and prove

Every module builds with `rye` and proves through its witness. To read one primitive end to end:

```
rye build mycelium/cord.rye -femit-bin=mycelium/bin/cord
mycelium/bin/cord selftest
rishi/bin/rishi run tools/m/mycelium_cord_witness.rish
```

The witness names its Language - Style - Lens, then prints one `GREEN` line stating what it proved. Every other family runs the same shape -- swap `cord` for `purse`, `pledge`, `muster`, `puddle`, `portage`, `constel`, `testament`, and the rest.

## The surface, counted

| What | Count |
|------|-------|
| Rye modules | 99 |
| `mycelium_*_witness.rish` witnesses | 80 |
| Reproducible fixture generators | 14 |
| On-disk Bron fixtures ([`corpora/`](corpora/), `@embedFile`-bound) | 14 |

## The two rooms -- what runs, and what waits for a hand

Everything above **runs green today** over demo seeds -- no real key, no funds, no network, no custody. The protocol is proven; the world-touching acts are named and held, each a custody gate that stays the keeper's own hand ([ITINERARY](../construction/ITINERARY.md)):

- **Comlink-served** -- a node fetching a live roster, a moving world's freight, or another shard's out-fact over the real network reaches the serve gate.
- **A real Aurora host** for any world reaches the provisioning gate and the maintainer's own Kumara instance.
- **Real value** across a Portage reaches the funds gate, where licensed counsel stands.

This is the honest shape of the season: a consensus protocol whole and witnessed in the sandbox, its every real-world crossing marked and waiting -- custody first, always.

---

*Underground, no single thread carries the forest, yet the forest is fed. So may Mycelium bind many nodes that never meet into one honest history -- every coin conserved, every quorum earned, every belief a keeper can boot from a handful of names and know true. May the order be decided once and read by all the same, and may this directory stay a plain, glad door into it on its ten-thousandth quiet day.*
