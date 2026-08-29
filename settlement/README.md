# Settlement — where a Kumara point becomes an owned record

**Language:** EN
**Status:** Living — settlement constellation seated `20260809.224715`; shared-surface shrink (Deed/Commitment split) `20260810.004547`
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Voice:** Kyri
**Equinox:** JARL (Identity & Network) · Journey 4

Settlement is the ledger. Where `../comlink/topology.rye` is the geometry — which number sits where in the d12·d60 fractal — and `../kumara/tilak.rye` is the deed — who holds a number, and how it moves — this module is the record of who has actually **settled**: in what order, under whose authority, at what version.

Grain's settlement is chosen on Sui's ground, and a Sui ground has one deep gift for identity: every asset is an **object** with a globally unique id, an owner, and a version that climbs on every change. An owned object rides a fast path that spends no global ordering on one owner's own affairs. A Kumara point wants exactly that — most of what an identity does is its keeper's business alone, and only membership must be read together. This module is the Rye-side model of what a Sui contract would enforce; it touches no chain, wallet, or key.

## The owned deed and the shared commitment

Sui splits the world into **owned** objects (a fast path, no global ordering for one owner's affairs) and **shared** ones (paid for by consensus). Settlement keeps that split honestly:

- A **`Deed`** is the owned object — a point's identity key, keeper, networking key, and counters. It rides the fast path in the owner's own hand, and never sits on the shared surface. (136 bytes.)
- A **`Commitment`** is the shared surface — the *only* record the whole network reads together: a member's point, tier, sponsor, version, and a **digest** that binds its owned Deed. No key ever lives here. (56 bytes — the keys, 96 bytes of them, stay in the Deed.)

The `Constellation` holds Commitments alone. Any transition needing a member's private facts — a parent's keeper to authorize a spawn, a sponsor's keeper to adopt — takes that member's **Deed** and verifies it against its commitment by digest, so the shared surface stays minimal and private facts are proven on demand rather than stored for all to read. `verify(con, deed)` is the whole value of the split: anyone can prove an owned Deed is the current member, with no key ever leaving the owner's hand.

[`replay.rye`](replay.rye) keeps the order beside that state. It folds each
spawn, adoption, and transfer into a fixed 32-byte digest. The same sequence
returns the same bytes; a reorder returns a different digest even when the
member's visible sponsor and keeper finish equal.

## The constellation

A galaxy leads a **d60** — its five stars and their sixty planets. Those, with the galaxy itself, settle as a **constellation**: a bounded circle of at most sixty-six commitments. [`constellation.rye`](constellation.rye) holds it, and keeps the five commitments of the ledger shape in our own words:

| Commitment | How the constellation keeps it |
|---|---|
| A point is a single-keeper record | a `Deed` carries one keeper; its `version` climbs by exactly one per change, like a Sui object's, and each change re-commits the digest on the shared surface |
| Powers are capability records | `mint` needs a `sow` cap, `transfer` a `hand` cap, `rotate` a `tend` cap — the tilak powers, each signed by the keeper who grants it, each exercised by a holder who signs the specific act |
| Keys rotate on their own counters | `rotate` sets a new networking key from a signed turn; a reset outranks a key bump; the keeper's key never moves while the wire heals |
| Sponsorship is a default, never a cage | a child settles under its real fractal parent (`topology.parent`), yet `escape` may re-parent it to another settled sponsor one tier up — by the child's own word (the `sponsor` tilak) and the new sponsor's adoption; the old sponsor keeps no veto, and the child's number never moves |
| The ledger accretes | a number settles once — a re-mint refuses; versions only climb |

## The refusals it owes

A ledger is only as strong as what it turns away. `constellation.rye`'s selftest proves each refusal: an orphan whose sponsor never settled, a child claiming the wrong sponsor, a forged spawn capability, a valid capability wielded without the holder's signature, a re-mint, a stale rotation replayed, a turn signed by the wrong key, a galaxy trying to escape its own root, a forged escape request, and an escape without the new sponsor's adoption. The shared surface owes its own: it verifies a current deed and refuses a **stale** one (a version the owner rotated past), a **tampered** one (same version, a changed key — the digest binds the whole owned state), and a **ghost** (a deed for a point that never settled).

```
rye build settlement/constellation.rye -femit-bin=settlement/bin/constellation
settlement/bin/constellation selftest
rishi/bin/rishi run tools/s/settlement_constellation_witness.rish
rishi/bin/rishi run tools/s/settlement_replay_witness.rish
```

## The spoken name

A number is legible to a machine; a **name** is legible to a person. [`names.rye`](names.rye) is how a settled number comes to wear one — "alice" resolving to a point, and the point resolving back. Names are the one surface that genuinely needs **consensus**: a point's keys are its own business on the fast path, yet a *name* must be globally unique, so everyone agrees who "alice" is. The `NameRegistry` is that small, bounded shared surface.

It is custody, not mere registration. A keeper who **owns** the point (its Deed verifies against the constellation) and **signs** the exact name **claims** it; the same hand **releases** it. One name maps to one point; one point wears one name; resolution runs both ways. A name is a short lowercase DNS-like label — never confusable with an address. The refusals: a taken name, an already-named point, a non-owner, a forged signature, a wrongful release, and any malformed name.

```
rye build settlement/names.rye -femit-bin=settlement/bin/names
settlement/bin/names selftest
rishi/bin/rishi run tools/s/settlement_names_witness.rish
```

## JARL, settled

Every settlement door now stands, each witnessed GREEN: the five transitions, the scarcity unified on the **d12·d60 fractal** (Azimuth ranks retired, `20260810`), the **shared-surface shrink** (56-byte commitments over owned Deeds), and now **human-name custody**. What follows — the loadable *skies*, Pond, Kyri — opens with the next-season breach, after JARL, by Keaton's word.

---

*May a point settle once under its rightful place, its powers move only by a signed hand, and its keys heal without ever waking the deed.*
