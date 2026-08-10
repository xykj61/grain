# Settlement — where a Kumara point becomes an owned record

**Language:** EN
**Status:** Living — the settlement constellation seated `20260809.224715`
**Voice:** Riyo
**Equinox:** JARL (Identity & Network) · Journey 4

Settlement is the ledger. Where `../comlink/topology.rye` is the geometry — which number sits where in the d12·d60 fractal — and `../kumara/tilak.rye` is the deed — who holds a number, and how it moves — this module is the record of who has actually **settled**: in what order, under whose authority, at what version.

Grain's settlement is chosen on Sui's ground, and a Sui ground has one deep gift for identity: every asset is an **object** with a globally unique id, an owner, and a version that climbs on every change. An owned object rides a fast path that spends no global ordering on one owner's own affairs. A Kumara point wants exactly that — most of what an identity does is its keeper's business alone, and only membership must be read together. This module is the Rye-side model of what a Sui contract would enforce; it touches no chain, wallet, or key.

## The constellation

A galaxy leads a **d60** — its five stars and their sixty planets. Those, with the galaxy itself, settle as a **constellation**: a bounded circle of at most sixty-six owned records. [`constellation.rye`](constellation.rye) holds it, and keeps the five commitments of the ledger shape in our own words:

| Commitment | How the constellation keeps it |
|---|---|
| A point is a single-keeper record | `Settled` carries one keeper; its `version` climbs by exactly one per change, like a Sui object's |
| Powers are capability records | `mint` needs a `sow` cap, `transfer` a `hand` cap, `rotate` a `tend` cap — the tilak powers, each signed by the keeper who grants it, each exercised by a holder who signs the specific act |
| Keys rotate on their own counters | `rotate` sets a new networking key from a signed turn; a reset outranks a key bump; the keeper's key never moves while the wire heals |
| Sponsorship is topology's default | a child settles only under its real fractal parent (`topology.parent`), and every member chains back to the galaxy |
| The ledger accretes | a number settles once — a re-mint refuses; versions only climb |

## The refusals it owes

A ledger is only as strong as what it turns away. `constellation.rye`'s selftest proves each refusal: an orphan whose sponsor never settled, a child claiming the wrong sponsor, a forged spawn capability, a valid capability wielded without the holder's signature, a re-mint, a stale rotation replayed, and a turn signed by the wrong key.

```
rye build settlement/constellation.rye -femit-bin=settlement/bin/constellation
settlement/bin/constellation selftest
rishi/bin/rishi run tools/settlement_constellation_witness.rish
```

## Held for Keaton's word

The **scarcity** a settled number carries — the elder Azimuth ranks of 2⁸ · 2¹⁶ · 2³² that the Point tilak still names, or the d12·d60 shape the topology settles by — is one decision, weighed by his hand. The **shared surface** can shrink further still: today the constellation holds whole records, where a Sui contract would keep only a small membership commitment and let the point-objects ride the fast path. And **escape** — a child re-parenting to a chosen sponsor — is the next transition the constellation will read, from the `sponsor` tilak already built.

---

*May a point settle once under its rightful place, its powers move only by a signed hand, and its keys heal without ever waking the deed.*
