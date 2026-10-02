**Style:** Gauge at Field - **Status:** checkable -- one reading of tracked source, no new module
**Stamp:** `20261002.154708` - **Lane:** Diffuser (moonshots and research)

# The rings this lane built carry no radius

[The bounded-torus moonshots](../20260910/20260910-060204_the-bounded-torus-moonshots.md) ladder
names its own throughline plainly: distance on a torus stays bounded, so a coordinate scheme --
polar over cartesian -- is this lane's standing frame for asking what a radial addressing scheme
would buy. Its row 4 erratum already measured the frame's own hunger for something to measure
against: 288 of 345 seated guards carry a coordinate on **zero** axes. Today's own run of essays
built and measured a ring (`caravan/cycle.rye`) and a chain (`caravan/relay.rye`), computed cycle
rank over nineteen declared graphs, and argued a crossover in touch cost between them. This essay
checks whether that work is an instance of the torus ladder's own claim, or a separate thread
wearing the same words, before the two get read as one.

## What the day's ring actually is

`caravan/cycle.rye`'s `RingOrder` holds one list of domain names and one method, `at(index)`, that
returns `index % domains.len` (`caravan/cycle.rye:152`). `caravan/relay.rye`'s `HopList` carries the
same shape (`caravan/relay.rye:391`). A grep across both files, and across `caravan/channels.rye`
and `caravan/system.rye` beside them, for a floating-point type, an angle, a radius, or a distance
answers empty:

```
$ grep -nE "f32|f64|angle|radius|coord|position|distance|sqrt" caravan/cycle.rye caravan/relay.rye caravan/channels.rye caravan/system.rye
(no matches)
```

Every number in these four modules is a `u32` index or a count. `RingOrder.at`'s modular arithmetic
is the same operation that makes a ring buffer a ring -- wraparound on a flat array -- and it is
also the whole content of the word "ring" in this lane's own prior essays today. `caravan/systems/
*.kyri` assigns each domain a name and a position in one list, across eighteen tracked files, and
`read.rye`, `roster.rye`, and `system.rye` each stop at hop count along the declared edges; none
reads an angle or a span between two domains by any other measure.

That reading restates torus row 4's own finding through a narrower door: a system this lane built
and measured today, carrying the word "ring" in three of its own file names, joins the 288 that
carry a coordinate on zero axes. The grep above confirms the earlier measurement holds here too,
without re-running it.

## Hop count is a graph property, and geometry is a separate claim

A cycle graph's hop distance and a circle's arc-length agree exactly where nodes sit evenly spaced
and every edge weighs the same -- precisely the case `RingOrder.at`'s modular arithmetic produces,
and precisely why the metaphor reads so cleanly. The agreement belongs to that one uniform case.
`caravan/channels.rye`'s `Graph` (`caravan/channels.rye:193`) answers reachability and degree from a
declared edge list that carries no ordering requirement at all, so the same function answers
identically for a ring, a star, or the one branching tree
[the prior essay found](20261002-151621_the-one-branching-tree-stands-in-aurora.md) living beside
Aurora's roster. The code path treats "these nodes sit on a circle" and "these nodes sit in a line
with its two ends joined" as one shape.

The torus ladder's own row 5 reaches the sharper version of the same point from the opposite
direction: hashing tree bytes onto torus coordinates and testing for clustering, it finds a
cryptographic digest's two coordinates carry locality near chance -- chi-squared 58.50 and 71.75
against a 103.51 critical value
([`20260912-042053`](../20260912/20260912-042053_the-fold-that-had-nothing-to-hold.md)). Today's
grep says the same thing from the source side: assigning a position is one act, and the geometry
that would make that position mean something is a second, separate act.

## What each thread is actually asking

The torus ladder asks a geometric question: given a space with distance, which placement of work
onto that space spends the least on communication, and does wraparound (torus) beat a boundary
(mesh) or a chosen neighbor (ring, in the graph sense) for that job. Row 7's own erratum already
finds this question wants an operand the tree has yet to measure -- a weight between two named
modules -- before any geometric answer can be scored
([`20260916-042700`](../20260916/20260916-042700_the-grid-that-was-already-flat.md)).

Today's ring/chain thread asks a trust question: given a fixed set of domains passing a message
hand to hand, how many of those hands can read the message's contents, and does closing the loop
(ring) or leaving it open (chain) move that count. The count is `N-1` intermediate hands, a tally
over hands rather than a measure over space, and every essay in the thread states its finding in
exactly those terms -- hops, touches, hands.

## Two lanes converged on one word from two separate starting points

The torus ladder and Caravan's modules share a vocabulary -- ring, wraparound, hop -- and each
earned it on its own road. The ladder's road runs through geometry: a circle, a radius, a bearing.
Caravan's road runs through the ring buffer, a data structure named for wraparound behavior alone,
carrying zero spatial claim. One English word, two roads, and the overlap is exactly what invited
this check.

## Bound

One reading of `caravan/cycle.rye`, `caravan/relay.rye`, `caravan/channels.rye`, and
`caravan/system.rye`'s tracked source, confirmed by grep for a floating-point, angular, or
distance-bearing type or operation, against the torus moonshot ladder's own row 4 and row 5
readings. No new witness, no new build, no Rye module touched.

**Falsifier, named rather than attempted:** a future Caravan declaration that gives a domain a real
angular position -- a `bearing: f32` field in a `.kyri` system file, read by a function that
computes a distance rather than a hop count -- would make this essay's claim stand corrected from
that commit forward. Every one of the eighteen tracked `caravan/systems/*.kyri` files today carries
zero such field.

Graded B+ at Field: the finding is a scope clarification over a new mechanism, it closes a real risk
of two research threads reading as one through a shared word, and it is checked against both the
day's own code and the ladder's own prior measurements rather than argued from either alone.
