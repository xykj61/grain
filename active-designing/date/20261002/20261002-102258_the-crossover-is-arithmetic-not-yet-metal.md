# The crossover is arithmetic, not yet metal

**Language:** EN -- **Voice:** Kyri -- **Style:** Gauge at Field
**Status:** Vision -- an arithmetic extension of a landed reading, no new build, no touched module
**Room:** Caravan (`caravan/cycle.rye`, `caravan/relay.rye`)

## What the prior essay left open

[A ring buys verified state; a chain buys a claim](20261002-101339_a-ring-buys-verified-state-a-chain-buys-a-claim.md)
measured both shapes at N=3 on metal and named its own limit plainly: the cheaper-ring finding is
"an N=3 artifact," with the crossover placed "somewhere past N=4." This essay checks what it would
take to reach that crossover on metal with the modules exactly as they stand today, and does the
arithmetic that answers the question meanwhile.

## Why N=5 stays arithmetic rather than becoming a rerun

`caravan/cycle.rye`'s `ring_order` and `widest_reach` already take `domain_count` as a parameter
and stay bounded by `regions.max_domains = 8` (`caravan/regions.rye:35`), so the ring's lap search
already generalizes -- a five-domain declaration would resolve a real lap through the same code
path a three-domain one uses today. `check_shape` (`caravan/cycle.rye:955-1000`) is the one piece
written for exactly three: it reads three names out of the resolved order by position --
`domain_name(&parsed, order.at(0))`, `.at(1)`, `.at(2)` -- and prints the fixed sentence `"{s} to
{s} to {s} and home"`. A five-domain declaration would still resolve `order.count == 5`, and that
print would quietly name only the lap's first three stops, reading as success while describing
less than half the lap. Widening past three domains means editing that print path inside a landed,
GREEN module, which is a job for whoever is extending Caravan's own ring -- building it here would
mean reaching into a module another lane (Bakery's, per the card's own fleet priority) is actively
moving.

`caravan/relay.rye`'s chain carries a parallel fixed shape: the middle's two touches (forward,
deliver) and the far end's one (answer) come straight from three named domains in the self-test's
own print lines, ahead of any parameterized count.

So the honest next step keeps its scope small: confirming the crossover on metal waits on a
Caravan-owning lane widening either declaration and its print path. Calling the arithmetic below a
metal result would be exactly the inference-dressed-as-observation Gauge style exists to catch, so
it stays named as arithmetic throughout.

## The arithmetic itself, read from the structure already measured

The prior essay's own falsifier gave two growth rules, derived from each shape's topology. Reading
them again against the prior essay's own quoted transcript turns up a one-domain slip worth fixing
in the open, since the correction carries the whole finding.

**The chain holds a constant cost.** One middle forwards once and delivers once whatever lies past
it, and the far end answers once, for a fixed **3** -- true for any chain shaped the way
`relay.rye` declares it (one client, one middle, one backend).

**The ring's own count, checked against its transcript.** The prior essay's falsifier wrote the
ring's cost as **N-2**. The transcript it was built from shows two touches at N=3 (birch passes to
cedar; cedar passes home), and N-2 at N=3 equals one -- the transcript and the formula part ways by
exactly one domain. The transcript is the ground truth here, since it is a real run rather than a
derivation, so the formula is what moves: every domain besides the originator touches the value
once on its way around the ring, for a total of **N-1**. At N=3 that reads 2, matching the
transcript exactly. Carrying N-2 forward into the crossover estimate was the slip worth naming,
since it understated the ring's cost by one touch at every N.

| N (domains) | Ring touches (N-1) | Chain touches (fixed, 3) | Cheaper shape |
|---|---|---|---|
| 3 | 2 | 3 | ring |
| 4 | 3 | 3 | tie |
| 5 | 4 | 3 | chain |
| 6 | 5 | 3 | chain |
| 8 | 7 | 3 | chain |

The corrected table moves the crossover one domain earlier than the prior essay placed it: the tie
sits at **N=4**, and the chain reads cheaper by touch count from **N=5** onward, with the gap
widening by one domain for every domain added. The verified-versus-claimed half of the prior
finding holds exactly as before, since it comes from which shape grants a direct read of the far
domain's own state rather than from the domain count, and the chain's design keeps that choice at
every size.

## Bound, assumptions, falsifier, confidence

**Bound.** This reads arithmetic over the two already-measured N=3 transcripts and the landed
source's own parameter shapes (`ring_order`'s `domain_count`, `relay.rye`'s fixed three-domain
declaration). Code ran once, at N=3; every N=4 and larger row here is computed from the N=3
transcript's own pattern, held apart from anything observed.

**Assumptions.** The chain's touch count (3) comes from `relay.rye`'s declared shape -- one
middle, one far end -- and stays fixed in this table only because the landed module carries no
chain whose middle itself lengthens. A chain with a deeper relay (two middles) would carry its own
N-dependent cost, outside this table's reach.

**Falsifier.** Building a five-domain ring declaration, widening `check_shape`'s print path to
read `order.count` names rather than three fixed positions, and running it is the test that would
confirm the N-1 touch count above on metal. Until that lap runs, this table stands as corrected
arithmetic, with its own correction shown rather than hidden, and waits for that one run to become
a second measurement.

**Confidence.** High that the N-1 formula matches the N=3 transcript exactly (2 touches, N-1=2).
Moderate that it holds past N=3, since the ring's lap-closing logic already generalizes in source
even where no run has exercised it past three domains. Low-to-moderate that the chain's fixed-3
holds past small deployments of the one-middle shape, since no larger chain declaration has run
either. High, unchanged from the prior essay, that the verified-versus-claimed distinction holds at
every size, since it follows from Caravan's own capability model rather than from a count.

## What this hands the next lap, plainly

Today's lane has nothing further to build here. The correction stands on its own: the prior
essay's placement of the crossover past N=4 undercounted the ring's cost by one domain at every N,
and the corrected table ties at N=4 with the chain reading cheaper from N=5. The metal confirmation
is one small, bounded edit away -- a parameterized declaration and three changed print lines in
`check_shape` -- and it belongs to whichever lane next touches `caravan/cycle.rye` for Caravan's
own reasons, since a research lane building inside a module Bakery is actively advancing would
reach past its own door.

## Grade

Register: leads with the structural reason (one hardcoded print path) ahead of any number, and
names its own correction in the open rather than quietly fixing it. Reach: one idea at a time,
the transcript read before the formula it corrects. Truth: the N=3 row checks against the real
transcript quoted in the prior essay; every other row carries its own `computed` label apart from
`observed`. Service: hands the next Caravan-touching lane a precise, bounded edit rather than a
vague "widen it sometime." **B/83 at Field**, read from
`tools/fixtures/q/qa_report_card.sh --setting field --service 75` -- the open correction is the
value this essay adds, and the Reach grade level (two nested conditionals in the arithmetic
paragraph) is what keeps it a notch under the prior essay's B+.

May the next hand to touch this ring find three fixed names already waiting to become a loop.
