# Kumara — identity, from a key to a deed

**Language:** EN
**Status:** Living — the identity template, first tilaks seated `20260809.154500`
**Voice:** Riyo
**Equinox:** JARL (Identity & Network) · Journey 1

Kumara is Grain's identity. It begins where trust actually begins — a keypair — and grows into a small family of type-marked records, **tilaks**, that say who a key is, who keeps it, and how it may move. This module seats the first two, the pair every other hangs from.

## What an identity is made of

- **The key.** An Ed25519 keypair, deterministic from a 32-byte seed the pilot keeps in their own jail. The crypto lives at one seam, `../tally/kumara.rye` (symlinked here as `kumara.rye`): `keypair_from_seed`, `sign`, `verify`. Every module reaches identity through that one home.
- **The point** — the deed. A number within a scarcity shape, its keeper, and a version that climbs by exactly one on every change. A point number below 2⁸ is a **galaxy**, below 2¹⁶ a **star**, otherwise a **planet** — Azimuth's legible tiers, honored as address grammar rather than a hierarchy of power.
- **The bind** — the marriage of the key to its keeper, signed **both ways**: the key signs the keeper, and the keeper signs the key. Neither signature alone is the identity; the mutual claim is. A bind that verifies in only one direction is refused whole.

The other three tilaks — **rotation** (the networking key with its two never-descending counters), the **capabilities** (management · spawn · transfer, lendable but never copied), and the **parent link** (sponsorship with an arithmetic default and a child's escape) — are named for the JARL journeys past this one, held for Keaton's word.

## Template and instance

A **template** is this shape; an **instance** is one filled quintet of tilaks for a real pilot. `kumara/tilak.rye` builds and verifies an instance from two seeds and serializes it to Bron facts — the first identity template plus a witnessed example instance. It never invents a real pilot's key: the example uses two plain seeds (`0x11…`, `0x22…`), and the maintainer's own instance is filled by his hand, from his own seed, when he words it.

## Build and prove

```
rye build kumara/tilak.rye -femit-bin=kumara/bin/tilak
kumara/bin/tilak selftest      # a bind verifies both ways; a tampered bind refuses (diagnostics on stderr)
kumara/bin/tilak emit          # print an example instance as Bron facts (data on stdout)
rishi/bin/rishi run tools/kumara_tilak_witness.rish
```

The example instance lives at [`example-instance.bron`](example-instance.bron) — a point fact and a bind fact, both signatures present at full Ed25519 length, the point kept by the keeper the bind names.

## Held for Keaton's word

The settlement ledger (Sui or Grain-native), the final scarcity tiering, the rotation and capability and sponsor tilaks, and the human-name custody park are the JARL journeys past this one. This module lands the deed and the marriage; the rest of the identity, and the network it lives on, follow.

---

*A key becomes a name when someone keeps it, and says so in a signature both hands sign.*
