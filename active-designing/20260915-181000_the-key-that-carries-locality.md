# The Key That Carries Locality

**Stamp:** `20260915.181000`
**Room:** checkable -- every figure below is bound by `tools/l/locality_key_witness.rish`, and the three trade verdicts are reported by its scan rather than gated.
**Status:** Landed -- the reading is on metal; what it recommends is a proposal.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Reads:** [`the bounded torus moonshots`](20260910-060204_the-bounded-torus-moonshots.md) row 5, and the two readings that closed it -- [`the fold that had nothing to hold`](20260912-042053_the-fold-that-had-nothing-to-hold.md) and [`the axis that carried nothing`](20260915-175000_the-axis-that-carried-nothing.md).

## The door these two readings left open

Two readings in this lane closed row 5 of the torus moonshots, and both closed it on the same
sentence. A cryptographic digest avalanches. Change one byte of a file and every bit of its digest
moves, so two documents differing in a single character land as far apart as two strangers. The
first reading killed the adjacency the row wanted; the second killed the placement remainder the
first left alive.

Each close names the same door in the same words: *a key built to carry locality on purpose.* No
row in that page proposed one. This reading opens it.

The answer is a price rather than a yes.

## The key, and why the crudest one

The key priced here is the file's own leading two bytes, read as a number. Two files beginning
alike get keys sitting alike, by construction, with no hashing at all.

That is deliberately the crudest member of its family. A real design would reach for a
similarity-preserving sketch -- a simhash, a Hilbert or Morton curve over a feature vector, a
learned embedding quantised into cells. Each of those is a better key than a raw prefix, and every
one of them is the same kind of key: a function chosen so that similar inputs produce similar
outputs.

The crudest member is the right one to measure first for one reason. The trade this reading finds
belongs to the family rather than to the member, so the member that shows it at full size, with no
parameter a reader has to take on trust, is the one that makes the shape legible. A sketch would
shrink every number below without changing a sign.

## What the key buys

**Observation, read at the extreme.** A real file is copied, one byte is flipped at offset 32 --
well past the key -- and both keys are asked whether they noticed. Over the tree's own tracked
bytes on `20260915`, the prefix key survived every probe and the digest survived none.

That is the locality property stated as arithmetic rather than as a correlation, which is why the
witness gates it. A digest surviving an edit would be a collision; a prefix moving would mean the
edit landed in the key.

**Observation, read across the population.** Two files drawn from the same top-level room sat
**0.410** cells apart under the prefix key and **15.693** apart under the digest, on a 64-cell ring
where two independent uniform keys give **16.000** exactly. Read over 510 tracked files sampled by
stride, 466 same-room pairs.

**Inference.** The buy is real and it is large. A store keyed this way would find a file's
neighbours by looking beside it, which is the whole thing row 5 wanted and never got.

## What the key sells, first half: evenness

**Observation.** Pearson chi-squared on cell occupancy over the same 510 files at the same 64-cell
grid, against a p=0.001 critical value of **103.51** at 63 degrees of freedom:

| Key | Chi-squared | Even? |
|---|---|---|
| SHA3-512 digest | **79.05** | yes |
| leading two bytes | **13134.05** | no |

**Inference.** The prefix key reads 127 times its own critical value on a population where the
digest is comfortably even. Evenness is the property both torus readings found the digest hands
over for free, and this key gives the whole of it back.

The cause is visible by eye and needs no statistic. This tree's files begin with a small number of
things: a shebang, a Markdown heading, a `const std`, a comment naming the file's own path. A key
reading those bytes is a key reading a short list.

## What the key sells, second half: confidentiality

This is the reading the other two exist to frame, and its argument is one sentence.

> A key that preserves a relation on its inputs hands that same relation to anyone holding only
> keys.

**The measurement.** For each cell, take the largest single room among the files in it; sum over
cells and divide by the population. That is the share of files an observer holding keys alone
places in the right room by guessing each cell's plurality. Its honest baseline is the same guess
made with no key at all -- the plurality room share over the whole population.

**Observation**, over 44 rooms:

| What the observer holds | Share placed correctly |
|---|---|
| nothing -- guess the commonest room | **0.3471** |
| every file's digest key | **0.3980** |
| every file's prefix key | **0.5353** |

**Inference.** The prefix key alone names the room of more than half the population. The digest
key sits near the no-key baseline, and the gap above it is what a 64-cell grid gives by chance on
a finite sample.

**Bound on the claim, stated plainly.** Room membership in a public tree is public, so this figure
is a **lower bound** on what the key gives away over a corpus where it is not. The reading is also
about rooms because rooms are what this population has; a corpus of a person's own records would
be grouped by something they had more reason to keep.

## The finding

Locality, evenness and confidentiality are not three properties for a clever key to trade against
one another. **They are one quantity read in three directions.**

A key that lets a reader find neighbours is a key that groups documents, so it groups them
unevenly. A key that groups documents is a key that tells an observer which group each document is
in. Each sentence follows from the one before it by the definition of the key rather than by any
fact about this tree.

The instrument separates the last two, which is what keeps this from being one sentence said three
times. A planted population with prefixes clustered exactly as in the real case, and rooms assigned
round robin, sells evenness and keeps the room -- so unevenness and leakage are genuinely two
readings and the control proves it.

What follows for the lane is a reversal. The avalanche both torus readings kept running into is
not an obstacle those readings failed to route around. **It is what buys the other two properties**,
and it was doing its job the whole time.

## What would falsify this

Three facts would kill it, and the instrument reads all three from both sides.

**A prefix key reading even.** Chi-squared under the critical value would mean locality costs no
evenness on this population, and the trade named here is not a trade. The control plants exactly
this population and the scan says so.

**A prefix key at the uniform same-room distance.** That would mean the key carries no locality on
real bytes despite carrying it by construction, which would say this tree's files do not begin
alike.

**A room recovery at or under the no-key baseline.** That would mean the leak is below what a
64-cell grid can see, and the confidentiality half would want a finer instrument before it was
believed.

## What this does not touch

**Whether a similarity-preserving sketch lands better on the same trade.** It will land better in
magnitude. Whether it changes a sign is a different key, a different reading, and the honest next
step for anyone who wants one.

**Whether any locality key is safe to adopt.** That is a custody question and never a measurement.

**Any real store, wire, or index.** This reading opens none.

## The proposal, and its confidence

**Proposal.** A content-addressed store keeps its avalanche key, and any locality a reader needs is
supplied by a **separate index** that is stored and protected on its own terms -- rather than by
weakening the key that names the content.

**Horizon.** No code follows from this page today. The proposal is a constraint on a design, and
the first design it would bind is whichever store in this tree first wants neighbour lookup.

**Assumptions.** That the corpus resembles this one in beginning with a short list of things; that
the observer model worth defending against is one holding keys without content; that evenness is
wanted at all, which a store choosing deliberate skew would deny.

**Falsifier for the proposal, distinct from the reading's.** A workload where the index costs more
than the key saves -- measured as a real store's lookup latency and storage overhead against a
locality-keyed one -- would mean the separation is the wrong shape however clean the reading is.

**Confidence.** High on the reading, which is arithmetic over measured bytes with its falsifier
planted and fired. Moderate on the proposal, which is a design recommendation with no store behind
it yet.

## Where it stands

The reading is bound by [`tools/l/locality_key_witness.rish`](../tools/l/locality_key_witness.rish)
over [`tools/fixtures/l/locality_key_scan.sh`](../tools/fixtures/l/locality_key_scan.sh), with 43
behaviors proven on planted populations by
[`tools/fixtures/l/locality_key_control.sh`](../tools/fixtures/l/locality_key_control.sh) -- every
refusal planted and then lifted, four mutations bitten.

**Every figure on this page is FREE.** The tree grows, the stride moves with it, and the sample is
drawn by stride. Run `sh tools/fixtures/l/locality_key_scan.sh` rather than reading them here.
