# The bitmask ring checked -- the thread's own falsifier closes negative

**Stamp:** `20260918.054500`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- the named falsifier checked, negative
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`../20260917/20260917-235220_comlink-checked-one-ring-one-tree-no-torus.md`](../20260917/20260917-235220_comlink-checked-one-ring-one-tree-no-torus.md) --
[`20260918-015906_discovery-room-checked-no-torus-eighth-negative.md`](20260918-015906_discovery-room-checked-no-torus-eighth-negative.md) --
this piece answers that account's own named falsifier.

## The one sentence this piece is for

The last account in this thread named its own blind spot: the sweep's four patterns (`%`, `wrap`,
`ring`, `cycle`) have never once searched for a **bitmask ring** -- `& (N - 1)`, the idiom a
power-of-two ring buffer uses instead of a modulus, and the one shape none of the eight prior reads
could have caught. This piece runs that search.

## What was checked

Every tracked `.rye` source, past the closed rooms this tree already reads past for testimony,
vendored code, and generated crypto tables:

```
find . -path ./gratitude -prune -o -path ./vendor -prune -o -name '*.rye' -print \
  | xargs grep -lE '& *\(.*- *1\)'
```

## What was found

**Two files, both `crypto/mldsa_encode.rye` and `crypto/mlkem_encode.rye`** (and their `seed/`
mirrors) -- SLH-DSA and ML-KEM encoding, where `& (q - 1)` and similar forms are the field-modulus
reduction the published algorithm itself specifies. Neither is a ring buffer, a topology, or a
wrap-around index; both are bounded modular arithmetic over a fixed prime field, unrelated to
Comlink, Tally, or any structure this thread has been checking for a torus seam.

**No hit stands anywhere in Comlink, Tally, Caravan, or Mantra.** The whole population this thread
has read across nine accounts -- `topology.rye`, the discovery room, the guest wire pairs, the
open-asks family -- carries no bitmask ring under any of the five patterns now run against it.

## What this closes, and what it does not

**The falsifier named in the prior account is now checked, and it came back negative.** The thread's
running finding -- this tree names no torus, cyclic aether, or ring topology as a real module, only
the plain English words *wrap*, *ring*, and *cycle* doing ordinary work -- now stands against the one
search pattern that could have caught a shape the other four would miss.

**What it does not close:** a ring implemented as a fixed-size array with two cursors and no bitwise
mask at all -- `next = (i + 1) % N` written as a branch (`if (i == N - 1) i = 0 else i += 1`) rather
than either a modulus or a mask. That third idiom exists and this search does not see it. Naming it
here rather than leaving it implicit, the way the last account named this one.

## Why this is worth one small piece rather than silence

A moonshot line of research earns its keep by closing cleanly, not only by opening. Nine accounts
into a search for a toroidal or radial topology in this tree's own code, the honest report is that
none exists yet -- the words are metaphors, the topology is not built, and a toroidal-aether or
radial-coordinate scheme, if it is worth proposing to Caravan or Aurora, is new design work rather
than something already half-standing under a different name.
