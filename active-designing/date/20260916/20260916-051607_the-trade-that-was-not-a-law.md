# The trade that was not a law

**Stamp:** `20260916.051607`
**Language:** EN
**Room:** mixed -- the three readings are checkable and bound by a green witness; what the finding recommends for a store is a proposal and waits for Keaton's word.
**Status:** Landed -- the measurement stands; the disposition it suggests is a recommendation.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Witness:** [`../tools/t/key_trade_witness.rish`](../tools/t/key_trade_witness.rish) -- scan [`../tools/fixtures/t/key_trade_scan.sh`](../tools/fixtures/t/key_trade_scan.sh), control [`../tools/fixtures/t/key_trade_control.sh`](../tools/fixtures/t/key_trade_control.sh)
**Answers:** the named next step of [`20260915-181000_the-key-that-carries-locality.md`](20260915-181000_the-key-that-carries-locality.md), and through it row 5 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)

Yesterday this lane priced the crudest locality-bearing key there is -- a file's own leading two
bytes -- against the SHA3-512 digest, and found three properties moving together:

> Locality, evenness and confidentiality are not three properties for a clever key to trade against
> one another. **They are one quantity read in three directions.**

That page closed on a sentence naming its own next step, and it named it precisely:

> Whether a similarity-preserving sketch lands better on the same trade. It will land better in
> magnitude. Whether it **changes a sign** is a different key, a different reading, and the honest
> next step for anyone who wants one.

This is that reading, and it takes the step twice over. It builds the sketch the elder page named --
a 16-bit SimHash over word tokens -- and it builds a **third** key that page never proposed, derived
from a file's path rather than from its bytes. The sketch lands where the elder page forecast:
better in magnitude, same sign. **The third key changes a sign.**

## What was measured, and how

Three keys, each a 16-bit value whose high byte is the x coordinate and whose low byte is the y,
so no key gets a fold of its own:

| Key | Built from | Locality it is built to carry |
|---|---|---|
| **sha3** | bytes 0 and 1 of SHA3-512 over the file's bytes -- the name a Tablecloth on this pier would actually carry | none; built to avalanche |
| **path** | FNV-1a over the **directory** in the high byte, FNV-1a over the **basename** in the low | the room relation, by construction: two files of one directory share x exactly |
| **simhash** | a 16-bit SimHash: each word token's FNV-1a votes each of 16 accumulators up or down, and the signs are the key | the content relation: documents sharing most tokens agree on most signs |

Three populations, taken from the elder scan unchanged so the two papers read one shape: **random**
disjoint pairs from a strided sample of the tracked listing, **samedir** disjoint pairs of files
sharing a directory, and **onebit** a file beside the same file with its first byte substituted.

And three metrics, because a key read only in the torus's metric reports a fact about the **fold**
as though it were a fact about the **key**. Each has a closed form for uniform 16-bit keys, derived
rather than tabled and proven against a planted uniform population by the control:

| Metric | What it measures | Closed form |
|---|---|---|
| **torus** | toroidal Manhattan on (x, y), each axis wrapped | **128** |
| **ring** | circular distance on the whole 16-bit key read as one coordinate | **16384** |
| **hamming** | bits differing between the two keys | **8** |

Read `20260916.051607` over **512** tracked files drawn from **18,246** by stride, sitting in
**215** distinct directories with the largest holding **5.66 percent** of the sample. The bounds are
512 names, 96 one-bit pairs, 256 same-directory names, and 512 word tokens per SimHash.

## Observation: one key reads even and carries adjacency at once

| Key | chi-squared over 64 cells (df 63, p=0.001 critical **103.51**) | even | adjacency, own-baseline |
|---|---|---|---|
| **sha3** | **65.25** | yes | **none of six readings** |
| **path** | **98.00** | yes | **all six readings** |
| **simhash** | **1087.50** | no | four of six readings |

The instrument prints `verdict=both_available`, and the sentence it prints beside it is the finding:
*a key reads EVEN and carries adjacency at once -- the trade both elder papers claimed is refuted,
and a store may have locality without paying in placement.*

**The elder chain, and the word it turns on.** The elder page derives its trade in three sentences,
each following from the one before *by the definition of the key* rather than from any fact about
this tree:

> A key that lets a reader find neighbours is a key that groups documents, **so** it groups them
> unevenly. A key that groups documents is a key that tells an observer which group each document
> is in.

The first *so* is where the path key walks through. Grouping documents crowds **cells** only when
the groups are few, or unequal, or both. This tree's sample sits in **215 directories** with the
largest holding **5.66 percent** of it, and 215 comparable groups spread over 64 cells land about
as evenly as 512 independent draws do.

The elder page's own key shows why that premise usually holds, and why it is a premise rather than
a law: a leading-two-bytes key groups by *how a file starts*, and files here start with a shebang,
a Markdown heading, or a `const std` -- a short list, read at chi-squared **13134.05**.

So the path key's two properties come from two mechanisms. Evenness comes from **having many
comparable rooms to spread over**; adjacency comes from **agreeing with itself inside a room**.
One mechanism says nothing about the other, and the elder chain's *second* sentence stands
untouched -- which the leak reading below confirms rather than contradicts.

## Observation: the correction that changed a verdict

Every related population is read **twice** -- against the metric's closed form, which asks whether
the key is uniform, and against **the key's own random baseline**, which asks whether the key
carries the relation. Only the second is what locality means, and the difference is not academic:

> `pop path random torus mean=95.164 expected=128.000` -- the path key's *unrelated* pairs already
> sit 33 nearer than a uniform key would.

So a same-directory mean under 128 would count the path key's global concentration as though it
were the room relation. The contrast reading takes the gap against 95.164 instead, with a
two-sample standard error, and it **moved a verdict**: SimHash's same-directory pairs read
`distinguishable` at torus distance against the closed form and `indistinguishable` against their
own baseline. One reading of nine was a false positive, and it was the interesting one.

The control proves this from both sides, on a planted population that is concentrated and carries
no relation at all: the closed-form reading calls it **nearer, distinguishable**; the own-baseline
reading calls it **indistinguishable**; and the adjacency verdict follows the second. Removing the
contrast is one of the four mutations, and it bites.

## Observation: SimHash carries content locality, and the fold survives it

The sharpest single number on the page is SimHash's one-bit reading:

> `contrast simhash onebit hamming pop_mean=0.146 random_mean=5.457 gap=5.311 threshold=0.467`

Two documents differing in **one byte** sit **0.146 bits apart** where unrelated documents under the
same key sit 5.457 apart. And the locality survives the fold into coordinates: the same pairs read
`torus pop_mean=5.365` against a random baseline of 101.977. That answers a question worth asking
before the measurement -- whether Hamming-near keys stay near once cut into two bytes and wrapped --
and the answer is yes, because a key differing in a fraction of a bit on average keeps its high-order bits almost always.

Set that beside the digest, on the same pairs: `contrast sha3 onebit hamming gap=0.109
threshold=0.232 verdict=indistinguishable`. The digest reads two nearly identical documents as two
strangers, which is the elder papers' finding reproduced here on their own population.

## Observation: the leak is where the elder page left it

The elder page's third reading is carried over here unchanged, so the two may be set side by side:
the share of files an observer holding **keys alone** places in the right top-level room by guessing
the plurality of each cell, against the same guess made with no key at all. Over 512 files in
**41** top-level rooms at a 64-cell grid:

| What the observer holds | Share placed correctly | Lift over no key |
|---|---|---|
| nothing -- guess the commonest room | **0.3516** | -- |
| every file's **sha3** key | **0.4082** | 0.0566 |
| every file's **path** key | **0.4473** | 0.0957 |
| every file's **simhash** key | **0.4473** | 0.0957 |

**Both locality keys leak more room than the digest does, and the elder finding survives intact.**
A key that groups documents does tell an observer which group each is in, and that sentence never
depended on the *so* that the path key broke.

**And for the path key the measurement is a floor rather than a reading.** Its high byte is
FNV-1a over the **directory**, so an observer holding keys recovers the directory exactly whenever
that byte is unshared -- the 0.4473 above is what a coarse 8 x 8 cell can see of a leak that is
total by construction. Stating it as a definition is more honest than stating it as a number, and
the number is printed anyway so a reader can watch it move.

**The forecast the elder page made about magnitude holds for the sketch.** SimHash reads chi-squared
**1087.50** where the prefix key read 13134.05 -- an order of magnitude better and still ten times
its critical value. Better in magnitude, same sign, exactly as written.

## What each key actually costs

**The path key's evenness sits at 95 percent of its own critical value**, and that figure is
**FREE** -- nothing holds it still, and it moves with the shape of this tree's directories. Run
`sh tools/fixtures/t/key_trade_scan.sh` rather than reading 98.00. The mechanism behind the near
miss is printed beside it: the key spreads 215 rooms of **unequal size** over 64 cells, and rooms
are unequal in every tree anyone keeps. A tree with forty directories, or one where a single
directory held a third of the files, would read this key uneven -- and that is the elder trade
arriving on schedule for a tree shaped differently from this one.

**The path key's one-bit reading is 0.000 by construction and is not a finding.** A record corrected
in place keeps its path, so it keeps its key exactly. That is the property a store would want and it
is a definition rather than a measurement, and the scan's own header says so.

**The path key also files by a name rather than by content**, which is the thing a content-addressed
store exists to avoid. Naming a file by where it sits gives up deduplication, gives up the
tamper-evidence a digest carries, and makes a move a rewrite. This paper measures a key's geometry
and stops there.

**SimHash is genuinely uneven** -- chi-squared 1087.50 against a critical 103.51 -- and its
distinct-key count is **430 of 512** against 507 for the digest, so it collides eight times as
often. That is what a key pays when its output distribution follows its input distribution.

## The falsifier of this reading, and what would fire it

**This paper claims:** the elder trade is a property of the keys measured so far rather than a law
of keys, because one key holds evenness and adjacency at once.

**It is refuted by** the path key reading uneven on a population where it also reads adjacent --
because the only key on this page holding both properties would then hold neither, and the elder
trade would stand unbroken on four keys out of four. `chi_squared` above `critical` for the path
key is that reading, and it is **five points away**. The scan prints both numbers on one line so
the refutation can arrive on this one instrument.

**It is also refuted by** a reader who rejects the path key as a content-addressed name at all, on
the grounds above. That is an argument rather than a measurement, and it is a good one; what it
cannot do is restore the claim that evenness and adjacency **must** trade, since the argument is
about custody rather than about geometry.

**Confidence.** High on the arithmetic, which the control proves in both directions on planted
populations. Moderate on the path key's evenness, which sits near its threshold on one tree at one
stamp. The paper says which of the two any given sentence rests on.

## What this leaves for the shelf

**The elder proposal stands, and this reading strengthens two thirds of it.** A content-addressed
store keeps its avalanche key and supplies locality through a separate index, protected on its own
terms. Nothing here touches that, because the key that changed a sign is a *path* key, and a store
that names content by its path has stopped being content-addressed.

**What changes is the reason.** The elder page grounded its proposal on a trade it read as
following from the definition of a locality key. The trade holds for every key here that reads
*content* -- and its cause is narrower than the definition: **the number and evenness of the groups
a key induces**, which for a content key is set by how alike the corpus starts. So the proposal
rests on a measurement of this corpus rather than on a necessity, and a corpus shaped differently
would want the reading taken again.

**And row 5's disposition is unchanged.** Its second erratum recommended **breach** on the ground
that a torus hands down a fixed offset set `{1, g}` where a ring chooses. That finding never
depended on any key, and nothing on this page disturbs it.

## What this does not reach

**Whether Tablecloth should change its key.** That is a custody-weight decision about a
content-addressed store, and the arguments against are named above rather than weighed. The proposal stays off this page.

**How much a key that leaks similarity leaks about content.** The room-recovery reading above
measures the group; a SimHash published as a name tells anyone holding it which documents resemble
which, before either is opened, which is a finer thing. That wants its own falsifier and its own
lap; this paper reads the group and stops there.

**Whether either locality is the locality a store wants.** Room membership and token overlap are two
relations that happened to be measurable on this tree's bytes today. A store's real access pattern
is a third, and this tree still holds no measurement of it -- which is row 7's *the map has no
operand*, arriving on a third road.

---

*May the key say what it knows, and may the reading name what it cost.*
