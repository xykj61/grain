# The fold that had nothing to hold

**Stamp:** `20260912.042053`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every figure below is published by
[`../tools/fixtures/t/torus_fold_scan.sh`](../tools/fixtures/t/torus_fold_scan.sh) and the
instrument
is walled by [`../tools/t/torus_fold_witness.rish`](../tools/t/torus_fold_witness.rish)
**Reads:** row 5 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Kin:** [`../foundations/20260823-222020_what-tablecloth-is.md`](../foundations/20260823-222020_what-tablecloth-is.md) -- [`20260912-021711_the-privilege-that-was-never-a-line.md`](20260912-021711_the-privilege-that-was-never-a-line.md) -- [`20260911-195059_the-field-with-no-distance.md`](20260911-195059_the-field-with-no-distance.md)

---

## The claim, and the shape of its answer

Row 5 of the bounded-torus moonshots proposes folding Tablecloth's hash space onto a 2-torus, so
that **"names that sit near each other in the fold sit near each other in storage."** Its stated
falsifier is clustering: a fold that crams real names into a few cells would trade lookup evenness
for adjacency at a price the store declines.

**The falsifier fails, and its failing is what kills the row.** The fold is even -- measurably,
on two independent byte offsets, over the tree's own bytes. It is even because a cryptographic
hash is built to scatter, and that same scattering is precisely what leaves the fold's adjacency
carrying no relation at all. The two halves of row 5 are one property read twice, from opposite
sides, and one property answers one question.

## What was measured, and over what

**Observation.** Tablecloth names a thing by SHA3-512 over its bytes
([`what-tablecloth-is`](../foundations/20260823-222020_what-tablecloth-is.md)), so the names a
store on this pier would carry are the digests of the files this pier tracks. The reading takes
512 tracked files by a deterministic stride over `git ls-files`, hashes each with the tree's own
`crypto/sha3_digest.rye`, and reads two bytes of each digest as coordinates on a 256 by 256 torus.
Every figure below was read at `20260912.042053` against 17,742 tracked files, and every one is
**free** -- the tree grows and the stride moves with it. Run
`sh tools/fixtures/t/torus_fold_scan.sh` rather than trusting the numbers here.

**The expectation is a closed form rather than a simulation.** Toroidal distance on one axis is
`min(d, 256 - d)`. For two independent uniform coordinates the circular difference is uniform on
0..255, and `(0 + 1 + ... + 127) + 128 + (127 + ... + 1) = 16384`, so the per-axis mean is exactly
**64** and a pair's Manhattan distance averages exactly **128**. The control checks that sum rather
than quoting it.

### Reading one -- evenness, the stated falsifier

| Fold offset | Grid | df | Expected per cell | Chi-squared | Critical, p=0.001 | Clusters |
|---|---|---|---|---|---|---|
| bytes 0, 1 | 8 x 8 | 63 | 8.00 | **58.50** | 103.51 | no |
| bytes 30, 31 | 8 x 8 | 63 | 8.00 | **71.75** | 103.51 | no |

A chi-squared statistic has mean equal to its degrees of freedom, so a reading near 63 is the even
case. Both offsets sit under it. Of 512 names, 512 and 508 landed in distinct cells of the fine
plane -- the birthday arithmetic over 65,536 cells expects about 510.

**The falsifier stayed silent.** Row 5 is clear on its own stated terms.

### Reading two -- adjacency, the claim's own value

Three populations, each compared against the closed form 128, each drawn as **disjoint** pairs so
one observation is one pair.

| Population | Offset | Pairs | Mean | Standard error | Deviation | 3-sigma threshold | Verdict |
|---|---|---|---|---|---|---|---|
| random | 0 | 256 | 124.234 | 3.298 | 3.766 | 9.894 | indistinguishable |
| same directory | 0 | 128 | 126.250 | 4.466 | 1.750 | 13.398 | indistinguishable |
| one byte edited | 0 | 96 | 130.844 | 5.209 | 2.844 | 15.628 | indistinguishable |
| random | 30 | 256 | 124.441 | 3.254 | 3.559 | 9.762 | indistinguishable |
| same directory | 30 | 128 | 122.531 | 5.128 | 5.469 | 15.384 | indistinguishable |
| one byte edited | 30 | 96 | 122.469 | 4.965 | 5.531 | 14.895 | indistinguishable |

**The one-byte-edit population is the sentence worth reading twice.** Each pair is a file and the
same file with one byte substituted -- two documents a store holds side by side, differing in a
single character, which is the relation any adjacency scheme would most want to keep. They land
**130.844 and 122.469** apart, which is where two strangers land.

The same-directory population is the relation a store would most plausibly be asked for, and it
reads the same.

### Reading three -- the fold offset is not the story

Every reading above was taken twice, on digest bytes 0 and 1 and on bytes 30 and 31. A finding
that held for one arbitrary pair of bytes while the next pair answered otherwise would be a fact
about the choice rather than about the fold. Both offsets answer alike on both readings.

## Why one property answers both questions

**Inference.** A cryptographic hash is specified to **avalanche**: one input bit changed
redistributes the output, and an attacker given a digest learns nothing about the bytes behind it.
Both halves of row 5 read that one property from opposite sides.

- **Evenness needs the output to be indistinguishable from uniform.** It is, by design, and so any
  fold reading bits of it is even. This is why the falsifier stayed silent.
- **Adjacency needs the output to preserve some input relation.** Preserving a relation is exactly
  what avalanche is built to destroy. A digest that placed similar documents near one another
  would be leaking input structure -- a property with a name in the literature, and the name is a
  weakness.

**So the trade-off row 5 anticipated -- evenness bought at adjacency's price -- stands outside
what a hash offers.** The dial it reaches for is absent. The fold is even and empty together, and
a hash offering the other side of that trade would be a weak one.

**What this does NOT say:** that no name could carry relation worth folding. A locality-sensitive
hash is built for exactly that, and deliberately gives up the three properties
[`what-tablecloth-is`](../foundations/20260823-222020_what-tablecloth-is.md) opens with -- same
bytes, same name; different bytes, different name; a name is a proof. Row 5 asks for adjacency
over Tablecloth's names, and Tablecloth's names are the ones that cannot supply it.

## What survives, and it is not nothing

**Even fill is a real property, and it belongs to placement rather than to adjacency.** Two things
stand once the adjacency claim is set down:

**A fold gives even shards for free.** Reading `k` bits of a digest partitions a store into `2^k`
pieces of equal expected size, with no balancing pass, no rehashing on growth beyond a power of
two, and no hot cell. That is measured above at 8 x 8 and holds at any grid the reading chooses.

**A torus gives a bounded neighbour set, uniform at every cell.** Every cell has exactly four
neighbours, and the count is a property of the topology rather than a row in a table -- which is
row 1's wrap ([`the wrap is the bound`](20260910-060204_the-bounded-torus-moonshots.md)) applied
to storage. A replica rule reading "this cell and its four neighbours" is uniform everywhere,
where the same rule on a square needs a corner case at each of four corners and each of four
edges. That is a genuine simplification, and it needs none of the adjacency this reading declines.

**Recommended re-aim rather than re-rank.** Row 5 keeps its place if its claim is rewritten from
*adjacency means relation* to *even placement with a wrap-bounded replica set*. Its first witness
would then measure shard evenness under growth and the replica rule's uniformity, both of which
the instrument here already half-holds. The adjacency sentence should go, since it is the half
that was measured and declined.

## What the pen caught in the instrument itself

**A guard against a degenerate divisor silenced the loudest signal the scan can receive.** The
first draft asked `se > 0 && dev > sigma * se` before calling a population distinguishable, to
keep a zero divisor out of the comparison. A planted population whose partners all sat exactly one
cell apart has `se` exactly zero -- every pair at the same distance -- so `se > 0` read false and
a mean **126 away from the expectation** was reported as
*indistinguishable*. The strongest possible effect read as absence. Dropping the guard is correct
in both directions: at `se` zero any real deviation exceeds it, and a deviation of zero stays
inside it.

**A chi-squared grid fixed ahead of the sample was arithmetic that did not hold.** A 16 x 16 grid
over 512 names expects two per cell, where the Pearson approximation wants about five. The first
draft read **316 against a critical 330** and called the fold even on a statistic that was not
valid at that grid. The grid is chosen from the sample size now, and the critical value is derived
by Wilson-Hilferty rather than tabled -- checked against published values at three degrees of
freedom, within one percent at each.

**A lattice is even and is not random, and the plant has to mean what the claim means.** The pen's
first even population was a regular grid: even by chi-squared, and with every pair at an identical
distance, so its `se` was zero and every population read as an effect. An even fold means
scattered rather than regular. The plants are drawn from a deterministic congruential generator now.

## What is gated, and what deliberately is not

The witness gates the **control** -- 28 behaviors, both verdicts reachable from planted
populations, the closed forms checked, three mutations bitten -- and the live reading's **shape**.
It does not gate the live **verdict**.

**The reason is the rate at which the reading refuses by chance, which it publishes itself.** A
three-sigma test refuses about one time in 370 on a population where the effect is zero; across
six populations that is roughly one run in sixty. A gate on the
verdict would red this tree at a rate its own instrument publishes, on a fact about SHA3-512 that
is correct. What must stay loud is the instrument, since a scan answering *even and uninformative*
for every input would have produced this finding on a name that genuinely carried relation -- which
is why the pen plants one that does, and watches the scan say so.

## The falsifier of THIS reading

**A same-directory or one-byte-edit mean sitting more than three standard errors below 128, at a
pair count large enough to hold it, would refute this page.** The instrument reports that verdict
by name -- `adjacency_informative` -- and the pen proves it reachable.

**What the reading could have seen, and where it stops:** the three-sigma thresholds sit at **7.6
to 12.2 percent** of the 128 being compared against. An effect smaller than that is invisible
here,
and a reader wanting a finer answer raises the pair count rather than trusting the word
*indistinguishable*. That resolution is printed beside every population for exactly this reason.

**Confidence: high** for the two readings as taken, since both rest on a property of SHA3-512 that
is a design requirement rather than an accident. **Medium-high** for the re-aim, whose evenness
half is measured here and whose replica-uniformity half is argued rather than run.

---

*May a measurement that clears a falsifier still be allowed to close the question, and may the
instrument that takes it be proven able to say the other thing.*
