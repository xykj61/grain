# Kumara — identity, from a key to a deed

**Language:** EN
**Status:** Living — the identity template, first tilaks seated `20260809.154500`
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Voice:** Kyri
**Equinox:** JARL (Identity & Network) · Journey 1

Kumara is Grain's identity. It begins where trust actually begins — a keypair — and grows into a small family of type-marked records, **tilaks**, that say who a key is, who keeps it, and how it may move. This module seats the first two, the pair every other hangs from.

## What an identity is made of

- **The key.** An Ed25519 keypair, deterministic from a 32-byte seed the pilot keeps in their own jail. The crypto lives at one seam, `../tally/kumara.rye` (symlinked here as `kumara.rye`): `keypair_from_seed`, `sign`, `verify`. Every module reaches identity through that one home.
- **The point** — the deed. A number within a scarcity shape, its keeper, and a version that climbs by exactly one on every change. A point number decodes to its place in the **d12·d60 fractal** (`../comlink/topology.rye`) — a **galaxy**, a **star** within it, or a **planet** within that — and the place is the tier. The elder Azimuth ranks (2⁸/2¹⁶/2³²) are retired (Keaton's word `20260810`); the tiers stay legible as address grammar rather than a hierarchy of power.
- **The bind** — the marriage of the key to its keeper, signed **both ways**: the key signs the keeper, and the keeper signs the key. Neither signature alone is the identity; the mutual claim is. A bind that verifies in only one direction is refused whole.

- **The rotation** (turn) — the networking key Comlink reads on every handshake, with two counters that only ever climb: one on an ordinary rotation, one on a reset (which zeroes the first). The identity key signs it, so a rotation is authentic.
- **The capabilities** (tend · sow · hand) — the three lendable powers, management · spawn · transfer, each a keeper-signed grant naming exactly one holder. A capability moves by a fresh signed grant, never by copying an old one.
- **The parent link** (sponsor) — every point has a topology default parent (its d12·d60 sponsor); a child may escape to a chosen one, and that escape is the child's word alone, signed by the child's own key.

All five tilaks are seated, and each carries a signature by its authorizing party: the bind's mutual pair, the turn under the identity key, each capability under the keeper, the sponsor escape under the child. Every claim traces to a signature; every tamper refuses.

## Template and instance

A **template** is this shape; an **instance** is one filled quintet of tilaks for a real pilot. `kumara/tilak.rye` builds and verifies an instance from two seeds and serializes it to Bron facts — the first identity template plus a witnessed example instance. It never invents a real pilot's key: the example uses two plain seeds (`0x11…`, `0x22…`), and the maintainer's own instance is filled by his hand, from his own seed, when he words it.

## Build and prove

```
rye build kumara/tilak.rye -femit-bin=kumara/bin/tilak
kumara/bin/tilak selftest      # a bind verifies both ways; a tampered bind refuses (diagnostics on stderr)
kumara/bin/tilak emit          # print an example instance as Bron facts (data on stdout)
rishi/bin/rishi run tools/k/kumara_tilak_witness.rish
```

The example instance lives at [`example-instance.bron`](example-instance.bron) — a point fact and a bind fact, both signatures present at full Ed25519 length, the point kept by the keeper the bind names.

## Settled since, and held still

The **settlement ledger** is built on **Sui** (`../settlement/constellation.rye`), and the **scarcity** is the **d12·d60 fractal** — the elder Azimuth ranks retired (Keaton's word `20260810`). What remains a JARL journey past this one: the **human-name custody park** (how a number becomes a spoken name), and how small the **shared surface** can shrink. This module lands the whole tilak shape — the identity in hand, signed and witnessed.

---

*A key becomes a name when someone keeps it, and says so in a signature both hands sign.*
