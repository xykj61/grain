# The Bead Is Coarser Than the Edit

**Stamp:** `20261002.065248`
**Room:** checkable -- every count below is read straight from this tree's own git history and
a synthetic control. Each one carries the command and script that produced it. Anyone with the
same clone can re-run every number.
**Status:** Landed -- runs the falsifier the byte-level essay named. The falsifier stays open after
this run.
[The Line-Level Proxy Was Misleading](../20261002/20261002-055959_the-line-level-proxy-was-misleading.md)
named its own open falsifier: read the 1,006 revision pairs it excluded for cost (the
560-585KB growth era), using "an algorithm that avoids the same cost wall." This essay runs that
read with `mantra/beading.rye`'s own content-defined chunker standing in for the algorithm. The
chunker's own bead granularity turns out too coarse to answer the question it was asked.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra, Tally, Caravan
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

Chunking the 1,006 excluded revision pairs with a faithful Python replica of
[`beading.rye`'s](../../../mantra/beading.rye) own gear-hash content-defined chunker, then diffing
at chunk-token granularity, reads **73.8 percent substitution-shaped** (3,142 of 4,256 hunks). That
reverses the byte-level essay's own prediction that the excluded era would read *more*
shift-shaped. A controlled synthetic test then finds the limit: the chunker's bead granularity
(64-256 bytes, averaging near 80) reads a true small insertion the same way it reads a true
same-length substitution. Every pure insertion of 10 bytes or fewer, across 200 trials, read as
"near-equal" -- the substitution label -- purely because the engulfing bead dwarfs the edit. So
this essay holds the 73.8 percent reading as untrustworthy, and the falsifier the parent essay
named stays open for a future lap.

## Observation 1: the chunk-level read, run as proposed

**The method.** Start from the same ordered revision-pair list the byte-level essay built,
following `construction/ITINERARY.md`'s renames back to `work-in-progress/REMEMBER.md`. Keep only
the 1,006 pairs where either blob exceeds 50,000 bytes -- the exact set the byte-level essay
excluded. Chunk each blob with a Python port of `beading.rye`'s own boundary rule: a 256-entry gear
table built from the module's own xorshift constants, a hash that resets to zero at each bead's own
start and shifts left one bit per byte (`h = (h << 1) + gear_table[byte]`), cutting a bead between
64 and 256 bytes wherever the hash's low 5 bits read zero. Diff the chunked sequences with Python's
`difflib.SequenceMatcher`, over the chunk tokens themselves (opaque byte strings, hashable, compared
for exact equality) rather than over raw bytes. Classify each non-equal opcode with the same 15
percent near-equal-length rule the byte-level essay used, applied to the summed byte lengths of the
chunks on each side of that opcode.

**A sanity check, run before trusting the chunker at all.** Insert 20 random bytes into 5,000 bytes
of random data. The result is exactly one SequenceMatcher opcode: a `replace` of one bead by one
bead, grown by the inserted amount, with every bead before and after it byte-identical on both
sides. A same-length substitution of 20 bytes produces the same shape -- one bead replaced by one
bead of identical length. That is the chunker resyncing correctly, the exact property it is built
for; `beading.rye`'s own header names it: "an edit shifts only nearby beads." Chunk counts before
and after both tests held equal (53 and 53 beads in one paired run), confirming that only the one
engulfing bead moved.

**The reading**, from the 1,006 excluded pairs, 4,256 hunks:

| | count | share |
|---|---|---|
| insert_only | 22 | 0.5% |
| delete_only | 1 | 0.0% |
| mixed_near_equal_len | 3,142 | 73.8% |
| mixed_length_changing | 1,091 | 25.6% |

Grouped the way the parent essays grouped it -- shift-shaped is insert-only plus delete-only plus
length-changing, substitution-shaped is near-equal:

| | shift-shaped | substitution-shaped |
|---|---|---|
| **chunk-level, excluded era, this essay** | 1,114 / 4,256 (26.2%) | 3,142 / 4,256 (73.8%) |
| **byte-level, included era, parent essay** | 58,996 / 70,795 (83.3%) | 11,799 / 70,795 (16.7%) |

Read alone, this reverses the direction the byte-level essay's own reasoning predicted: *"a card
growing by 585KB before being shed is, by construction, a long run of pure insertion followed by
one very large deletion, which would if anything push the excluded era's own shape further toward
shift rather than away from it."* The measured chunk-level reading points firmly the other way.

**One count disagrees with the parent essay, and this essay names the disagreement rather than
smoothing it over.** This essay's own revision-pair walk counts **4,916** non-identical consecutive
pairs across `ITINERARY.md`'s whole history. The parent essay's walk counted 4,887 -- a 29-pair
gap. The excluded-pair count agrees exactly (1,006 both times), so the gap sits somewhere in the
included population, clear of either essay's own excluded-era reading. This stays unresolved here,
named as an open assumption below.

## Observation 2: the reading fails its own control

A reading this far from its own prediction earns the same suspicion
[the parent essay gave its own discarded prefix/suffix method](20261002-055959_the-line-level-proxy-was-misleading.md#a-note-on-method-named-because-it-cost-real-time):
*"a cheap confirmation earns the most suspicion, and checking it against its own hunk-length
distribution is what caught this one."* So before trusting 73.8 percent, this essay tested the
chunker on data where the true edit shape is known by construction.

**The test.** Run 200 trials per insert size. Each trial starts from 3,000 bytes of fresh random
data, inserts a block of random bytes at a fixed midpoint, chunks both sides, and reads how the one
resulting opcode classifies:

| insert size | near_equal (reads as substitution) | length_changing (reads as shift) |
|---|---|---|
| 3 bytes | 200/200 (100%) | 0/200 |
| 5 bytes | 200/200 (100%) | 0/200 |
| 10 bytes | 200/200 (100%) | 0/200 |
| 20 bytes | 133/200 (66.5%) | 67/200 (33.5%) |
| 40 bytes | 56/200 (28.0%) | 144/200 (72.0%) |
| 60 bytes | 26/200 (13.0%) | 174/200 (87.0%) |

**Every one of these is a true insertion** -- bytes added, none removed, none substituted. By the
dedup-ratio essays' own vocabulary, this is the textbook shift case. Yet at bead granularity it
reads as substitution-shaped whenever the insert is small against the engulfing bead (64-256 bytes,
averaging near 80). The near-equal-length test compares the *bead's* total length before and after,
rather than the edit's own span. A 5-byte insertion into an 85-byte bead reads as "85 bytes versus
90 bytes, 5.9 percent different, near-equal" -- correct arithmetic, aimed at the wrong quantity.
Also worth naming: `insert_only` reads 0 across all 1,200 trials. True CDC resync produces no clean
"one new bead, everything else untouched" token sequence for a small insert. It always shows up as
one bead growing, which this classification scheme can only read as near-equal or length-changing,
never as a pure insert.

## Inference: the real excluded-era hunks sit where the bias bites hardest

This raises one question: are the real excluded-era hunks small enough, relative to a bead, for
this bias to matter? Measured directly from the same 1,006-pair run:

| | near_equal hunks | length_changing hunks |
|---|---|---|
| n | 3,142 | 1,091 |
| smaller-side bytes: median | 215 | 260 |
| smaller-side bytes: mean | 410.6 | 524.2 |
| old-side chunk count: median / mean | 2 / 4.1 | 3 / 14.9 |
| new-side chunk count: median / mean | 2 / 4.2 | 12 / 13.8 |
| one bead on both sides | 1,148 / 3,142 (36.5%) | 34 / 1,091 (3.1%) |

**The length_changing bucket reads clearly.** Its median span grows from 3 beads to 12 beads -- a
fourfold jump in chunk count -- a real, substantial addition by any reading, consistent with whole
rows or sections being appended to the card. The synthetic test's own `insert_only=0` result already
explains why this reads as length_changing rather than insert_only: CDC resync folds genuinely-new
content into a changed span rather than a clean append token, and a fourfold size difference clears
the 15 percent threshold by a wide margin regardless of which algorithm measured it.

**The near_equal bucket is the one that stays ambiguous, sitting squarely inside the bias.** More
than a third of its 3,142 hunks (36.5 percent) are a single bead replaced by a single bead -- the
exact shape the synthetic test ran. The rest average 4.1 to 4.2 beads on each side, near 320-340
bytes at roughly 80 bytes per bead -- still well inside the range where the synthetic test found the
bias operating. The test's own 60-byte insert, a smaller fraction of a multi-bead span than it was
of a single bead, already misread at 13 percent; a few-bead span absorbing one small real edit sits
closer to the heavily-biased end of that curve than the corrected end. **This essay can read the
near_equal bucket's total, yet it cannot tell, inside that bucket, how many of the 3,142 hunks are
genuine same-length substitutions and how many are small shifts the bead granularity swallowed.**
Settling that needs the true byte-level LCS the parent essay priced at 51 minutes unbounded, or 16
minutes with the large era excluded -- the exact cost wall this essay tried to go around.

## Projection: what this settles and what stays open

**Horizon:** already closed -- this reads history already written, and a synthetic control run on
this host.

**Confidence:** high that the chunk-level numbers above are correctly computed from the bytes and
the synthetic trials actually read. High that the bias demonstrated in observation 2 is real, and
that it inflates the near-equal (substitution-shaped) count. Low on whether the 73.8 percent reading
is a trustworthy estimate of the excluded era's true byte-level shape -- the evidence in observation
3 points toward inflation, short of naming a corrected number.

**What this leaves off the table:** summing this essay's 4,256 hunks with the byte-level essay's
70,795 to produce one grand combined percentage across all of `ITINERARY.md`'s history. The two
hunk counts come from different diff algorithms at different granularities, and this essay's own
measured bias means its "substitution-shaped" count overstates what a byte-level reading of the
same pairs would find. A combined figure would read as more authoritative than either input, and
sit less trustworthy than the byte-level-only reading the parent essay already published.

**Falsifier, now narrower than the parent essay's own.** A byte-level LCS of the excluded 1,006
pairs, run with an algorithm that avoids the cost wall this essay avoided by changing method
instead -- a C-implemented diff library, or a true rolling-hash resync that still operates on raw
bytes rather than bead tokens -- would settle whether the near_equal bucket's ambiguous majority is
substitution or shift. Until that runs, the most honest reading of the whole history's edit shape
stays the byte-level essay's own 83.3 percent shift-shaped, covering 79.4 percent of history, named
plainly as a partial read rather than stretched by a weaker method.

**A second, narrower falsifier this essay's own numbers suggest.** Say the near_equal bucket is
mostly small shifts misread as substitutions. Correcting for the bias should then move the true
excluded-era reading *toward* shift-shaped, reinforcing the byte-level essay's own prediction that
a long growth-then-shed run leans shift-shaped, rather than overturning it. This essay's evidence
sits consistent with that reinforcement, short of proving it.

## What this means for the crux Bakery was handed

Unchanged. [No caller wants a mutable identity](../20261001/20261001-193541_no-caller-wants-a-mutable-identity.md)
still stands as the open crux: today's callers each keep a name bound to the bytes they were first
given, so the chunking-strategy question stays a question for a future caller rather than a build
case. What moves here is narrower, and arguably more useful to that future caller than either the
withdrawn or the reasserted percentage: **a demonstrated hazard in using content-defined-chunk-level
diffs to classify edit shape at all.** Any instrument built on `beading.rye`'s own boundaries -- a
sync accountant, a dedup-savings report, a caller's own shift-or-substitution classifier -- inherits
this same bead-size blindness for any edit smaller than roughly two bead-widths. The dedup-ratio
essays' own edit sizes, a few bytes to a few hundred, sit well inside that range.

## A note on method, kept because the first instinct was to stop at the headline number

This essay's own first run produced 73.8 percent and 26.2 percent, and could have stopped there,
reported as "the excluded era read, closing the parent's falsifier." The parent essay's own habit --
checking a result against its distribution before trusting it -- caught this one too. Checking cost
two more measured passes over the same 1,006 pairs (a size-distribution read and a span-width read)
plus one controlled synthetic test. Each ran cheap next to the full byte-level LCS this essay set
out to avoid, and together they moved the honest conclusion from "closed" to "still open, with a
narrower question."

*May the next reading of this question earn the sixteen minutes the byte-level method already
proved affordable, rather than spend a faster method's unproven confidence.*
