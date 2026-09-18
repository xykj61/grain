# The Angle the Sky Computes and Never Subtracts

**Stamp:** `20260905.224714`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- the measurement is checkable and re-derivable by the census named below; the
proposal at the end is proposed, and waits on a word
**Room:** the readings sit in the checkable room (`context/TWO_ROOMS.md`); the ring reading is a
proposal and says so at its own head
**Kin:** [`../external-research/20260905-224730_what-a-coordinate-frame-makes-free.md`](../external-research/20260905-224730_what-a-coordinate-frame-makes-free.md) (the named world this crossed from) -- [`20260826-001744_the-bound-in-the-shape.md`](20260826-001744_the-bound-in-the-shape.md) (wrap is a meaning, never a net) -- `comlink/topology.rye`
**Census:** `sh tools/fixtures/t/topology_metric_census.sh`

`comlink/topology.rye` gives every point in the network three coordinates and then measures
distance with two of them, read only for equality. This note measures what that costs, over
every ordered pair of both seated skies, and proposes one bounded addition. The measurement is
re-derivable in one command. The proposal is proposed.

## What was measured, and on what

**Bounds first.** One source file, `comlink/topology.rye`, at commit `88721dde7f` of this tree,
read `20260905.224714`. Two skies: `compass_sky` (12 galaxies, 5 stars each, 12 planets each, 720
points) and `council_sky` (15, 3, 9, 405 points). Every ordered pair of points in each, so
518,400 pairs and 164,025 pairs -- a complete enumeration rather than a sample. The instrument
is `tools/fixtures/t/topology_metric_census.sh`, which reads the sky constants from the module
rather than spelling them, and which proves its own model against the five hop counts the
module's selftest asserts before it reports a number.


## The three coordinates, and the two the metric reads
`decode` turns a point number into a galaxy index, a star index, and a planet index. Taking
the compass sky for the numbers: the galaxy index is the point number modulo the galaxy
count, which makes it a position on a circle of twelve, and the star index is a position on a
circle of five -- the module's own header names that circle the d5, *the circle it solves
problems with*. `outfit_seat` goes further and flattens star and planet into one seat index
inside the galaxy's circle, zero to fifty-nine here and zero to twenty-six in the council sky.

`route_hops` reads the star and planet indices at exactly two sites, and both times for
equality: is this the same star, and is this the same planet. It never subtracts them.
Equality is the coarsest question a coordinate can be asked -- it separates same from
different and discards every gradation between.

## The readings

| Reading | compass_sky | council_sky |
|---|---|---|
| Points | 720 | 405 |
| Ordered pairs | 518,400 | 164,025 |
| Diameter | 5 | 5 |
| Mean hops | 4.6819 | 4.5913 |
| Share of pairs at the diameter | 0.7703 | 0.7374 |
| Hop entropy | 1.0461 bits | 1.2092 bits |
| Ceiling for 6 distinct values | 2.5850 bits | 2.5850 bits |
| Same-galaxy cross-star planet pairs | 29,040 | 5,760 |
| Distinct hop counts among them | **1** | **1** |
| Numerically consecutive points at the diameter | 659 of 719 | 359 of 404 |
| Distinct points at zero hops | 0 | 0 |

Three of these carry the argument, and each is an observation rather than an inference.

**The metric is angle-blind.** All 29,040 same-galaxy, different-star planet pairs of the compass
sky return one hop count, four, and all 5,760 of the council sky return one hop count too. Two
planets under adjacent stars and two planets under opposite stars are the same distance apart.
This holds across both seated skies, so it is a property of `route_hops` rather than of one
sky's numbers.

**The metric is nearly constant.** Roughly three quarters of all ordered pairs sit at the
single largest value -- 77.03% in the compass sky, 73.74% in the council. The compass hop
distribution carries 1.0461 bits, and the council 1.2092, where six distinct values could
carry 2.5850 apiece; so each spends under half the range it occupies. A pair of compass
addresses holds about 19 bits between them, and the distance between them returns one.

**Number order and distance run against each other.** Because the galaxy index is the number
modulo twelve, two consecutive point numbers almost always land in different galaxies, and
different galaxies is the one condition that forces a bridge. So 659 of the compass sky's 719
consecutive pairs sit at the diameter, and 359 of the council's 404. Numbers next to each other
are as far apart as the network allows.

**And the metric never aliases.** Zero distinct points are called zero hops apart, in either
sky. That is the one property routing genuinely cannot do without, since a metric that calls two
points the same cannot deliver to either. It holds, and a guard for it has yet to be written.

## The claim, and what the falsifier did to it

**The claim.** The sky computes an angular coordinate for every point, names one of its circles
a circle, and exposes no way to ask how far apart two points sit on it. Every decision that
would want within-galaxy nearness -- where to place a replica, whom to gossip with first, which
peer to try before the bridge -- has no coordinate to read.

**The falsifier, stated before it was run.** Exhibit one caller in this tree that recovers
angular nearness from an address: any code that subtracts, orders, or ranks two star indices,
two planet indices, or two outfit seats. One such caller and the claim is wrong.

**It fired, partly, and the claim is narrower for it.** `classical-vedic-astrology/seat_nakshatra.rye`
does read the angular coordinate: it calls `council_sky.outfit_seat(point)` and uses the answer
at lines 45 and 87. It uses it as an index into a roster of names -- `nakshatras[seat]` -- so the
seat is read as a **label** and never as a **distance**. Sweeping every `.rye` source in
the tree for a comparison of two star or planet indices returns four sites and not one
ordering among them: two inside `route_hops`, one in the module's own selftest, and one
asserting a point number on a different struct. Every comparison this tree makes on these
coordinates is equality. So the corrected claim is the one that survives measurement: the
angular coordinate is computed, and it is read, and it is never subtracted.

## What the module taught the instrument

The census reproduces `route_hops` in awk, and its agreement leg refused the first run: it
answered three hops where the selftest asserts five. The cause is worth writing down, because it
is a property of the sky rather than a slip in the script.

`Address.of_planet(8, 0, 0)` encodes to the number 8, and `decode(8)` answers tier `galaxy`. The
number spaces nest inclusively, so 8 is primarily a galaxy and **wears** the planet outfit. Now
`route_hops` reads `tier`, through `depth()`, which means **a distance depends on which outfit
each end is wearing rather than on the two points alone.** The same two identities, addressed at
different tiers, are different distances apart. That is consistent, documented behavior of
inclusion; what still wants a line somewhere is that the distance function inherits it. The doc line
above `route_hops` reads *the hop count from `a` to `b`*, which a reader will hear as a fact
about two points.

Naming this is the honest yield of an instrument that proved itself before reporting. The census
enumerates by number, which is the primary-role reading a network routes between; its agreement
leg builds the selftest's five addresses at the tiers the selftest gives them.

## What a second reading would buy, and what it must never touch

**Authority stays a tree.** Sponsorship is who may mint whom, and that is ancestry rather than
nearness. `route_hops` answers the authority question correctly today and should keep answering
it exactly as it does. The grain says values stay apart rather than braided, and a distance
asked to answer two questions answers each of them badly.

**The proposal, and it is a proposal.** Add a second reading beside the first: `seat_arc(a, b)`,
the shorter way around the galaxy's own circle between two outfit seats, defined only for two
points under one galaxy and refusing across galaxies with a named error. It is a pure function of
two numbers already in hand, its allocation is zero, and every existing answer stands exactly as it
stands today, since it has yet to acquire a caller. Placement and gossip may read it; minting must not.

**What it would buy, bounded.** Within one galaxy, the pairs that today share a single hop count
-- 29,040 in the compass sky and 5,760 in the council -- would carry an ordering whose largest
arc is `prosperity()/2`: thirty seats in the compass sky, thirteen in the council. That is a
coordinate a placement rule could rank by. Whether
ranking by it helps depends entirely on whether traffic between points is correlated with
anything, and **nobody in this tree has measured traffic**, so the honest statement is that the
saving is currently unmeasurable rather than absent.

**The energy line, kept small on purpose.** A hop is a store and a forward, so hop count is a
proxy for the energy a message costs. Cutting a five-hop path to two would cut that proxy by
three fifths. The projection is bounded and its assumptions are load-bearing: it holds only for
traffic that is genuinely local, only where placement is free to move, and only once someone
measures which pairs actually talk. Horizon: a real Comlink deployment carrying a traffic log,
and later rather than sooner. Falsifier: measure pair traffic and find it uniform, and placement
buys nothing at any distance. Confidence: low on the size of the saving, high on the claim that
the tree cannot currently compute it.

## What is buildable now, and what is not

Buildable, and small enough for one lap:

1. **`seat_arc(sky, a, b)` in `comlink/topology.rye`** -- twenty lines, two asserts, refusing
   across galaxies with a named error, plus its selftest cases. It has yet to acquire a caller, so it adds a
   reading rather than changing one.
2. **A zero-hop witness.** Distinct points are never zero hops apart. Measured true on 682,425
   ordered pairs across both skies, and still awaiting a guard. It is the one property routing cannot
   survive losing.
3. **One doc line on `route_hops`** naming that its answer depends on the tier each address
   carries, which inclusion makes a real degree of freedom.

Not buildable, and named plainly as such: any claim about what a locality-aware placement saves.
That needs a traffic measurement this tree has never taken, and a number invented in its place
would be enthusiasm wearing a decimal point.

## What stays proposed

Everything after the readings table. The measurement stands and re-derives in one command; the
ring reading is a proposal that changes an interface, and interfaces are Keaton's word. This note
proposes it, prices it, and stops there.
