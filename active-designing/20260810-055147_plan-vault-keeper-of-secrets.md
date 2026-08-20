# Vault — the keeper of secrets, custody first

**Language:** EN
**Status:** Mixed -- Design brief — no code, no keys, no witness yet
**Voice:** Riyo
**Equinox:** JARL (Identity & Network) · a keeper beside Kumara
**Molt-supersedes:** the elder Urbit **Jael** (the vane that kept a ship's secrets and PKI)

Kumara names *who a key is*. Vault names *how a person keeps the key alive* — through fire, through hurricane, through a decade, through a mind that forgets. Where Kumara's tilaks prove a keypair belongs to a keeper, Vault is the module that keeps the seed behind that keypair recoverable by its owner and by no one else. It molt-supersedes Urbit's Jael: Jael held a ship's keys and its view of the network's PKI inside the kernel; Vault holds a family's secrets under the same discipline that governs everything else in this tree — bounded, asserted, explicit-width, and above all **custody first**. The tree holds design and fake-seed witnesses only. A real key never enters it.

## The word we never write

The elder art calls the top of a key hierarchy the "master key." Vault never writes that word. As git chose **main** over **master**, Vault names the root of a keeping the **main key** — the one seed from which every derived key, every share, and every brain phrase descends. This is not decoration: the name appears in every tilak mark, every emitted Bron fact, and every witness line, so the discipline is enforced by grep, not by memory. Any occurrence of "master" in a Vault source file is a red the style check must turn away.

## What Vault keeps, and what it refuses to hold

Vault keeps the *shape* of a keeping — how a secret is split, where its shares live, how a brain phrase derives, how a recombination is proven — as type-marked, signed, versioned records in the tilak tradition Kumara already seated. Vault refuses to hold the secret itself in the tree. This line is the whole design:

- **In the tree, forever:** the marks (tilaks), the split arithmetic, the derivation rule, the recombination proof, and witnesses that run the whole cycle on a **fake seed** whose bytes are plainly `0x11…` — never a real pilot's seed.
- **Never in the tree:** a real main key, a real share, a real brain phrase, or any byte from which a live identity could be reconstructed. A pilot fills a real keeping by his own hand, in his own jail, from his own entropy, exactly as `kumara/tilak.rye` already fills a real instance today.

Custody first means the module is designed so that *building it cannot destroy anything*. A recombination witness that failed must leave the fake shares intact; a re-shard must accrete a new version rather than overwrite an old one; a wipe of key material is an explicit, named, refused-by-default act, never a side effect.

## The tilaks — Vault's type-marks

Vault follows Kumara's pattern exactly: each record is a `struct` with a `format vault-<mark>-v1` Bron head, a version that climbs by exactly one, a signature by the authorizing party, and a `make` / `verify` / `emit` triad proven by a selftest that refuses every tamper. Six marks carry the whole design.

| Tilak | What it is | Signed by | Holds |
|---|---|---|---|
| **keeping** | the root record of one person's custody — names the main-key public identity, the sharding shape (`n` shares, `t` threshold), and the derivation rule in force | the main key | never the main key itself — only its public identity and the shape |
| **shard** | one Shamir-style share of a split secret: its index, its share bytes, the location-class it lives in, and a commitment binding it to the keeping | the keeping's main key | a **fake** share in every witness; a real share only in a pilot's own hand |
| **brainkey** | the rule (not the phrase) for deriving a brain-memorizable key **from** the main key — the KDF name, the salt, the word-count, the checksum shape | the main key | the derivation *rule*; never the derived phrase, never the words |
| **glacier** | a Glacier-Protocol-compatible cold record: the paper-friendly encoding, the redundancy count, and the verification digest an air-gapped machine recomputes | the main key | the encoding shape and digest; never the plaintext |
| **relic** | a hardware-wallet attestation: which right-to-repair device (Ledger, Trezor, a RISC-V open device from Crowd Supply) holds a share, and its public attestation key | the device's attestation key | the device's public identity; never its internal seed |
| **recover** | a recombination event: which `t` shares were presented, the reconstructed **public** identity, and a proof the reconstruction matches the keeping | the recovering keeper | the *proof* of recovery; never the reconstructed secret |

Each mark is small, bounded by a named maximum, and emitted as immutable Bron so a `scribe/`-style reader can dispatch on its `format` line the way it already dispatches Kumara facts. The **shard** count `n` and threshold `t` carry named ceilings (a keeping splits into at most `max_shares` pieces; `t` never exceeds `n`, never falls below two), asserted at construction with a `// invariant:` comment on each.

## Sharding across the world — the disaster shape

The disaster design is the reason Vault exists as its own module rather than a field on a Kumara point. A single seed in a single place dies with that place. Vault splits the main key into `n` shares by Shamir's scheme — any `t` of them reconstruct it, any `t-1` reveal nothing — and each share carries a **location-class** naming where in the world it rests:

- **home** — one share on an air-gapped machine at the pilot's own hearth.
- **kin** — shares held by trusted people in other cities, other continents.
- **cold** — a Glacier-style paper or steel share in a bank box or a buried cache.
- **relic** — a share sealed inside a right-to-repair hardware wallet.
- **brain** — the one share that lives in no place at all, because it is **derived from the main key and memorized**. This is the design's quiet gift: a keeping can set `t` such that the brain-derived share plus any `t-1` physical shares recover the whole, so a pilot who loses every object he owns — house, safe, devices — still carries one share out of the fire in his own head.

Fire, hurricane, and tsunami are the named threats. The shape answers each: no single location's destruction drops the share count below `t`, and the brain share survives the loss of *all* locations at once. The witness proves this as arithmetic — remove any single location-class, and `t` shares still remain.

## Air-gapped by construction

Every operation that touches real key material is designed to run on a machine with no network — the `aurora/` boot already gives Grain an offline posture, and Vault leans on it. The tree-side model touches no device and no network; it proves the *shape* of an air-gapped ceremony (split here, carry there, recombine on a cold machine) so that when a pilot runs the real thing, the arithmetic and the marks are already witnessed. Vault emits Bron; a human carries the Bron; nothing dials out.

## The right-to-repair hardware lane

The **relic** tilak names hardware honestly. Ledger and Trezor are the common devices; the design's preference — in the spirit of custody and of owning what you run — leans toward open, repairable, RISC-V hardware wallets of the kind Crowd Supply carries, whose firmware a keeper can read and rebuild. Vault does not link any device SDK into Rye (the gratitude-license clean room forbids it); it models the *attestation* a device offers — a public key and a signature over "share `k` lives in me" — so a keeping can prove which relic holds which share without ever reading the device's internal seed. Naming a specific vendor is an **invitation**, consent-gated: Vault ships with no vendor blessed, and a pilot chooses his own.

## The smallest witnessed first lap

One lap, small enough to hold in mind, proving the load-bearing claim the whole module hangs from: **a fake key splits, and any threshold of shares recombines it exactly.**

`vault/shard.rye` seats the **shard** tilak and a Shamir-style split-and-join over `GF(256)`, bounded by a named `max_shares`. Its selftest, on a fake seed of `0x11…`:

1. **splits** the fake key into `n = 5` shares at threshold `t = 3`, each a signed `shard` tilak with a location-class;
2. **recombines** three different subsets of exactly `t` shares and asserts each reproduces the original fake seed **byte for byte**;
3. **refuses** `t-1` shares — two shares reconstruct nothing, proven by asserting the join of any two disagrees with the seed;
4. **refuses a tampered share** — flip one byte of one share's bytes and the signature fails to verify, exactly as every Kumara tilak already refuses a tampered field;
5. **survives a lost location** — drop every share of one location-class and assert `t` shares still remain among the rest;
6. **emits** the shards as `format vault-shard-v1` Bron and re-reads them, so the round-trips through notation.

The witness `tools/vault_shard_witness.rish` builds the binary, runs the selftest, checks the GREEN line and the tamper-refusal line, counts five `format vault-shard-v1` records in the emitted Bron, and confirms every share carries a full-length signature — the same witness shape `kumara_tilak_witness.rish` already uses. GREEN here means the disaster shape's arithmetic is real, on a fake key, with no real secret anywhere near the tree.

The **brainkey**, **glacier**, **relic**, and **recover** marks follow in later laps, each its own small witnessed step, each accreting beside the one before.

## Risks, named plainly

- **Real key material is the highest-stakes surface in the tree.** The mitigation is structural, not procedural: the tree holds only fake seeds (`0x11…`), witnesses assert the fake-seed bytes so a real seed could never masquerade as the example, and the style check turns away any file that hard-codes 32 bytes of anything but the blessed fake pattern. Custody first is the whole posture: build nothing that can destroy a key, and place no key to destroy.
- **Shamir over `GF(256)` is easy to get subtly wrong.** The mitigation is the clean room and the witness: Vault studies the scheme, writes its own bounded implementation in Rye, and proves recombination exactness and `t-1` secrecy on every build — a green-before-claim discipline this tree already lives by.
- **A brain-derived share trades a stolen head for a lost one.** Memorization removes a share that fire cannot burn, yet coercion or death can lose it. The design answers this with the threshold itself: the brain share is *one* of `t`, never the sole path, so a keeping never depends on a single skull. The derivation rule (brainkey tilak) is designed so the phrase is reconstructible from the main key on a cold machine, not a second secret to independently lose.
- **Hardware vendors are trust anchors we did not build.** The mitigation is the right-to-repair lean and the attestation-only model: Vault reads a device's public attestation, never its seed, and prefers open RISC-V hardware a keeper can audit — while blessing no vendor by default and treating every named device as a consent-gated invitation.
- **Glacier-Protocol compatibility is a moving external target.** The mitigation is to model the *shape* (paper encoding, redundancy, verification digest) as a versioned tilak that climbs by one on every change, so compatibility is a checkable claim in `docs-implementation-sync` terms rather than an assumed one — and to keep the elder art in `gratitude/` as reading, never as linked code.
- **Naming.** `vault`, `shard`, `brainkey`, `glacier`, `relic`, and `recover` grep clean against seated module and waymark names today (only incidental prose mentions of "wallet"/"shard" exist, no seated homes). Before the first `vault/` file lands, re-grep the tree and seat the six marks in the Lexicon, per the comlink-tendency discipline — clear, warm, safe words a newcomer grasps at once, and never the word "master."

---

*A key kept in one place dies with that place. A key split across the world, with one share carried in a mind, outlives the fire — and never, in this tree, is a real one of them written down.*
