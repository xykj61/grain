# The axis that carried nothing

**Stamp:** `20260915.175000`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every figure below is published by
[`../tools/fixtures/t/torus_place_scan.sh`](../tools/fixtures/t/torus_place_scan.sh) and the
instrument is walled by
[`../tools/t/torus_place_witness.rish`](../tools/t/torus_place_witness.rish)
**Reads:** row 5 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md),
as its elder erratum left it
**Kin:** [`20260912-042053_the-fold-that-had-nothing-to-hold.md`](20260912-042053_the-fold-that-had-nothing-to-hold.md)
-- [`../foundations/20260823-222020_what-tablecloth-is.md`](../foundations/20260823-222020_what-tablecloth-is.md)
-- [`../foundations/20260818-081438_the-three-depths-of-removal.md`](../foundations/20260818-081438_the-three-depths-of-removal.md)

---

## What was left standing

Row 5 of the bounded-torus moonshots proposed folding Tablecloth's hash space onto a 2-torus, so
that names near each other in the fold would sit near each other in storage. An earlier reading
killed that half outright: a cryptographic digest avalanches, so two documents differing in one
byte land as far apart as two strangers, and toroidal fold-distance carries no relation at all.

That reading kept the row alive on a remainder, and named it in one sentence: **even shards for
free at any grid, and a bounded four-neighbour replica set uniform at every cell.** It also named
what it had not touched -- *whether a torus is a good placement scheme, which is a different
claim.* This page reads that claim.

## The one question worth asking

A shape earns its keep against the simpler shape beside it. So every property in the remainder is
compared against a **ring** of the same cell count: one axis where the torus has two, a circle of
`C` cells where the torus has a `g` by `g` grid with `C = g * g`. A property the ring also has is
not a property the second axis supplies.

Three properties, three answers.

## Evenness belongs to the digest

Read `20260915` over 511 tracked files sampled by stride, their SHA3-512 digests folded onto 64
cells twice. The torus takes the high three bits of two digest bytes as `(x, y)` and stores at
`y * g + x`. The ring takes the high six bits of the same leading byte pair as one index.

| Fold | Chi-squared | Critical at p=0.001, 63 df |
|---|---|---|
| torus, 8 by 8 | **74.02** | 103.51 |
| ring, 64 cells | **73.02** | 103.51 |

Both even. The two folds read different bits, so they are genuinely different functions, and the
count of names they place in the same cell says so: **8 agreements out of 511**, against the
**7.98** that chance alone gives. Two different functions, equally even.

**Every figure in this section is FREE** -- the tree grows and the stride moves with it -- so run
`sh tools/fixtures/t/torus_place_scan.sh` rather than reading them.

The conclusion is the elder reading's own cause arriving in a new room. Evenness came from
SHA3-512, which is built to spread. Neither shape contributed to it, and a third shape would read
even too.

## Uniformity belongs to vertex-transitivity

Every cell of a torus has exactly four neighbours with no edge case. That is true, and it is true
of a ring as well: every cell has two neighbours at distance one and four within distance two, also
with no edge case. Both graphs are vertex-transitive, which is the property the word *uniform* was
reaching for.

This one is stated rather than measured, because it is geometry. A measurement that reported
*the torus replica set is uniform at every cell* would be reporting the definition of a torus back
to its reader, and a reading that can only come out one way is not a reading.

## Spread belongs to the offsets, and a ring chooses them better

What genuinely separates two placement rules is where the replicas **sit in the linear storage
order**. So the scan measures the shortest contiguous run of storage indices whose loss destroys
every copy of some cell, computed over every cell at one grid, for three rules that each hold five
copies and are each uniform:

| Rule | Offsets | Run that kills a cell, at `C = 64` | Closed form |
|---|---|---|---|
| **torus4** -- the grid's own neighbours | `{+1, -1, +g, -g}` | **17** | `2g + 1` |
| **ring4adj** -- a ring taking its nearest four | `{+1, -1, +2, -2}` | **5** | `5` |
| **ring4wide** -- a ring free to choose | `{+g, -g, +2g, -2g}` | **33** | `4g + 1` |

All three measurements match their closed forms exactly, which is what the witness gates.

The wide ring survives a contiguous loss nearly **twice as long** as the torus. So the second axis
is not merely matched on spread; it is beaten, by one axis choosing better offsets.

**A closed form holds only where its five copies are distinct cells**, and the scan says so rather
than refusing: `4g + 1` needs `4g < C`, so at a 4 by 4 grid the wide ring aliases around a short
cycle and its closed form reads `na`. A precondition is not a refusal, and the control proves the
instrument still passes there.

## What a torus actually is, here

A torus hands down a **fixed offset set**, `{1, g}`, chosen by its shape rather than by the
problem. A ring hands down nothing and lets the offsets be chosen. Since the property worth having
is that replicas sit far apart in the storage order, the shape that fixes the offsets is the shape
that cannot improve.

The name for choosing replica offsets far apart in the storage order is **declustering**, and it
needs no torus, no second axis, and no geometry at all.

## What this means for row 5

**The remainder does not survive.** Its two halves are a property of SHA3-512 and a property of any
vertex-transitive graph, and the third property, the one that would have justified the shape, comes
out against it. The honest depth here is a **breach** rather than a molt: the row is superseded in
the living page, and the history keeps every word it wrote.

**One door stays open, and it is the same door the elder reading left.** Every reading in both
papers rests on a key that avalanches. A key that carried locality on purpose -- a path, a time, a
tenant -- would fold differently, and a torus over such a key is a claim nobody in this tree has
proposed yet. Row 5 proposed a hash. That is the claim that is answered.

## The falsifiers, named

This page would be wrong if any of these read otherwise, and each is one command away:

- **Either fold reading far above its critical value.** The digest would be clustering, which is
  the elder scan's own falsifier arriving again.
- **`runkill_ring4wide` at or below `runkill_torus4`.** The second axis would genuinely supply
  spread a line cannot, and the conclusion above would invert.
- **A measured run-kill length disagreeing with its closed form** where the precondition holds.
  The arithmetic under the comparison would be wrong, and the witness reds on exactly this.
- **Imbalance failing to fall as the population grows.** The fold would cluster under growth, and
  the erratum's own recommendation would have been the wrong one.

**Confidence: high**, and the reason is that two of the three readings are arithmetic rather than
sampling. The run-kill lengths are computed over every cell and match closed forms; only the
evenness reading is statistical, and it is reported rather than gated because a p=0.001 test taken
twice refuses about one run in five hundred on a digest behaving correctly.

## What this reading does not reach

The real store, which it never opens. Whether contiguous-run loss is the failure model a given
medium has; it is the model named here, and a different one wants its own reading. And whether a
locality-bearing key would be worth folding, which is the open door above rather than a finding.
