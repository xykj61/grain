# Tablecloth -- Holding a Thing by What It Is

**Language:** EN
**Stamp:** `20260823.222020`
**Style:** Gauge, Door setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Registers:** Gauge - Civic - TAME
**Voice:** Kyri
**Status:** Living -- a foundation, written for a complete beginner
**Kin:** [`../README.md`](../README.md) - [Mantra](20260823-222018_what-mantra-is.md) - [Brix infuse](20260823-222019_what-brix-infuse-is.md) - [Tablecloth](20260823-222020_what-tablecloth-is.md)

---

**Tablecloth holds a thing by its content rather than by where you put it.**

## The idea, and why it is unusual

Most storage you have met is addressed by **location**. A file path, a row id, a URL. The address
says *where*, and whatever sits at that address may be swapped while the address stays put. That is
why a link goes dead while looking fine: the address held, and the content moved on.

Tablecloth addresses by **content**. The name of a thing is computed from the bytes themselves -- a
cryptographic hash, which is a fixed-length fingerprint unique to those bytes for every practical
purpose.

Three consequences follow at once, and together they are why the idea earns its strangeness.

**The same bytes always have the same name**, from any room, any machine, any year. Two people who
store the same document independently arrive at the same address without coordinating.

**Different bytes always have a different name.** Changing one character produces a name that looks
nothing like the old one, so arithmetic makes a quiet edit visible where a policy would only
discourage it.

**A name is a proof.** Handed some bytes and a name, you recompute the hash and compare. That takes
milliseconds and asks nobody's permission.

## The chemical formula

```
bytes  ->  resin                       (a content address -- SHA3-512, written in hex)
resin + store  ->  bytes               (a read: the same bytes, or nothing at all)
bytes + store  ->  resin + store'      (a write: the store grows and never changes)
```

A **resin** is this project's word for a content address. The store only ever grows: a write adds,
and every earlier write stays exactly as it was.

Two neighbouring formulas from the same family:

```
payload + seal  ->  amphora            (a sealed vessel, opened by whoever it is addressed to)
fossil + mutant + banner + row  ->  mitra prep     (a molt seen all the way through, no cut)
```

## Where the word comes from

A tablecloth is what you spread before the meal, so everything set on it has a clean, shared
surface. The name says the store sits beneath rather than beside -- the thing you lay the work on.

## The honest limits

**It stores, and leaves deciding to others.** Whether bytes are true, wanted, or lawful belongs to a
different question and a different layer.

**A content address is public by construction.** Anyone holding the bytes can compute the name, so
confidentiality belongs to the sealed-vessel layer above rather than here.

**Growing forever wants a plan.** A store that only adds needs a policy for what stays hot and what
moves cold. That one is named and still to be built, written here rather than left for a reader to
discover.

## Where to read next

The naming layer is [Mantra](20260823-222018_what-mantra-is.md); the declaring language is
[Brix infuse](20260823-222019_what-brix-infuse-is.md). The receipt that carries a resin is
`kyri/receipt.rye`.
