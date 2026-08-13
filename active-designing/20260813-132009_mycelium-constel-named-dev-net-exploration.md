# Constel — a named, reproducible dev-net constellation reaches quorum (Exploration)

**Stamp:** `20260813.132009` · **Status:** Living (self-approved design read) · **Voice:** Kyri
**Register:** Radiant · **Season:** D (Kresfa & Mycelium) — the double-seat expansion
**Kin:** [`the Portage crossing`](20260813-124159_mycelium-portage-cross-world-transfer-exploration.md) (value across two worlds) · [`the Muster`](20260813-110039_mycelium-muster-known-validator-set-exploration.md) (a known validator set) · [`the Chorus`](20260813-102533_mycelium-chorus-quorum-attestation-exploration.md) (quorum attestation) · [`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md) (Season D · Constel test networks) · [`placeholder-ship-names`](../.claude/rules/placeholder-ship-names.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## What Constel is

The Mycelium season built every piece of a Byzantine-fault-tolerant value ledger and proved each on metal: the Cord orders facts, the Voucher fingerprints a whole order, the Chorus gathers a quorum of distinct nodes attesting one reading, the Muster holds the known validator roll and passes a chorus only when its voices are all enrolled and meet the roll's Byzantine threshold, and Portage carried value across two worlds that share no channel. Yet every one of those witnesses **conjured its nodes inline** — `seeded(0x11)`, `seeded(0x22)`, three anonymous keypairs made up on the spot for one proof and forgotten. No round ever gave the dev-net a **name and a roster**: a stable, reproducible constellation of fake ships a keeper boots to exercise the whole stack as a *network of named nodes*.

A **Constel** is that named test constellation — the sovereign-lane echo of elder Urbit's fake-galaxy dev networks (fake ships, fake piers, run from a laptop), drawn for Grain's own metal and run **from inside the jailed pier**. It names a small roster of dev ships, derives each ship's identity as a **pure function of its name**, seats them as a Muster, and proves the named constellation reaches quorum on a real fact. The vision named this the Constel test network and **reserved its first names for a self-approved naming round** ([`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md), Season D · the Constel test-network naming law). This is that round.

## The blind spot, and why it is the next crux

Every consensus module stands proven alone; none has run as a *reproducible, named network*. A witness that makes up its nodes each time proves the law, yet it cannot be **booted twice and read the same** — there is no artifact a keeper hands another keeper that says *this is the dev constellation, these are its ships, boot it and watch them agree.* A dev-net's whole value is that it is the same every time: the same named ships, the same keys, the same quorum, so a failure reproduces and a fix is provable. That reproducibility is the Lindy asset — a testnet keepers run for years — and it is the one thing the inline-`seeded` witnesses cannot give.

The crux is to make the constellation a **pure function of its names**: a ship's keypair is `keypair_from_seed(SHA-256(name))`, so the whole roster — every public key, the Muster it seats, the quorum it reaches — is determined by the list of names alone. Boot it twice and every byte matches; hand another keeper the names and they boot the identical constellation. No stored keys, no random, no drift.

## The naming law, honored (siloed, never a real address)

The dev ships are named under the Constel naming law the vision sketched — the `queyqwinqkri` / `maicmalammurr` / `xykj61` / `xnkg30` family — and under the always-on [`placeholder-ship-names`](../.claude/rules/placeholder-ship-names.md) rule that guarantees a placeholder can **never parse as a live-network `@p`**. Each ship name is a single invented token of irregular length (nine or ten letters, no `~` prefix, no three-letter hyphenated syllable structure), so it is structurally incapable of naming a real galaxy, star, planet, moon, or comet. The first roster seated this round:

| Ship | Letters | Never-@p by |
|---|---|---|
| `xnvethqua` | 9 | no `~`, single token, length ≠ 3/6/12 |
| `kwelmirran` | 10 | no `~`, single token, length ≠ 3/6/12 |
| `xzobrilth` | 9 | no `~`, single token, length ≠ 3/6/12 |
| `murrqaveln` | 10 | no `~`, single token, length ≠ 3/6/12 |
| `xwendakosh` | 10 | no `~`, single token, length ≠ 3/6/12 |

These are dev fixtures only — siloed names for a jailed testnet, never a real point, never signing real value.

## The crux (r1) — a named constellation reaches quorum over one head

The decisive, hard-but-tractable move: boot the named roster and show the whole stack agrees over it, reproducibly.

- **The roster is reproducible.** `boot(names)` seats each named ship with `keypair_from_seed(SHA-256(name))`; booting the same names twice yields **byte-identical** public keys, ship for ship — the constellation is a pure function of its names.
- **The constellation seats as a Muster.** Every ship enrolls as a validator; the roll's Byzantine threshold is read from its size (`n − (n−1)/3`), never stored.
- **The named quorum agrees.** One fact is proposed onto a shared Cord (a genesis issuing a demo account its position); a Chorus opens on the resulting order-head; **every ship in the constellation adds its own honest voucher**; `verify_chorus` confirms the voices are distinct and agree, and `pass_muster` confirms every attester is an enrolled constellation member meeting the Byzantine threshold — **the named constellation believes the reading.**
- **The teeth.** A **stranger ship** — a name not seated in the roster — whose voucher is offered refuses `NotMember` (an outsider never counts toward the constellation's quorum). A **thin quorum** short of the Byzantine threshold refuses `BelowQuorum` (the named constellation does not believe a reading too few of its ships attest).

The identity is **derived from the name, never declared** — there is no `set_key`; a ship *is* the deterministic keypair of its name, so the constellation cannot be forged apart from the names that define it.

## The method — content makes the roster reproducible and safe

The insight mirrors the whole season's: because a ship's key is a pure function of its name and the quorum a pure function of the roster, the constellation's *entire* agreement is a pure function of the bytes — the list of names — with no correspondent, no stored secret, no random seed to drift. The work is not to invent a network protocol; the stack already agrees. The work is to prove the named, reproducible constellation is the **same every boot** and that its two dangerous cases — an outsider's voice, a quorum too thin — are refused rather than trusted. Constel composes `kumara` + `cord` + `fold` + `voucher` + `chorus` + `muster` public API only, editing none.

## The four rounds

- **r1 — the Constel crux.** `mycelium/constel.rye`: a named roster boots reproducibly (same names → byte-identical keys), seats as a Muster, and reaches quorum on a real fact — every ship's voucher gathered, `verify_chorus` + `pass_muster` GREEN; a stranger ship refuses `NotMember`, a thin quorum refuses `BelowQuorum`.
- **r2 — a ship departs, the constellation still believes.** A dev ship leaves the roster (a node down); the remaining ships still meet the *new* Byzantine threshold, so the constellation reaches quorum with `f` down — the fault tolerance the roll's arithmetic promises, proven by removing ships until the quorum honestly fails.
- **r3 — the constellation travels as text.** A `format constel-v1` record carries the roster (name · public key per ship); it renders and parses byte-for-byte, and a keeper boots the identical constellation from the record alone — a dev-net a keeper hands another keeper.
- **r4 — reads true.** A real on-disk roster fixture, produced reproducibly, cross-checked against an independent `awk` reading (two tools, one answer), so the named constellation a keeper reads by hand is exactly the one the stack boots.

## Custody, held plainly

Demo ship and keeper seeds only — no key held, no funds, no network, no real value. The names are siloed dev fixtures, never real points. A **served** constellation (ships attesting to each other over Comlink rather than in one process) reaches the Comlink-served gate (Keaton's hand); a real Aurora host for any ship reaches gates #2/#4. This journey boots the named dev-net on the bench, exactly as elder Urbit's `-F` fake ships run a whole network from one laptop under quarantined identities.

## Gratitude to silo

Elder **Urbit's fake-galaxy dev networks** (`~zod` and its fake fleet, `-F` piers run from one machine) — the idea that a whole network can be booted reproducibly from named, throwaway identities on a single host, studied clean-room and carried as concept; our own bounded Rye, our own SHA-256-from-name derivation, our own never-@p naming law. **TigerBeetle** and **Mysticeti** — thanked again as the ledgers we learn from; here their quorum runs over a roster a keeper can name and boot twice.

---

*Name the ships, and the constellation is the same every night the keeper boots it — may the named fleet always agree on what is true, may an outsider's voice never pass for one of its own, and may a keeper who reads the roster by hand boot the very constellation the stack believes.*
