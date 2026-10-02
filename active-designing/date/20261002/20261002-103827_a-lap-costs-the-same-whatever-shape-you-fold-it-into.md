# A lap costs the same whatever shape you fold it into -- the ring's N-1 is a walk length, not a layout

**Stamp:** `20261002.103827`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. Two claims: one proven by standard graph fact plus a bound read
from tracked source, the other named as unbuilt and falsifiable.
**Room:** vision -- a measured proposal, unwitnessed.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Caravan.
**Kin:** [`20261002-101339_a-ring-buys-verified-state-a-chain-buys-a-claim.md`](20261002-101339_a-ring-buys-verified-state-a-chain-buys-a-claim.md)
(the N-1 reading this piece takes as given) -
[`20261002-102258_the-crossover-is-arithmetic-not-yet-metal.md`](20261002-102258_the-crossover-is-arithmetic-not-yet-metal.md)
(the correction that fixed N-1 in place) -
[`../20260917/20260917-224502_two-independent-rings-in-caravan-a-torus-nobody-composed.md`](../20260917/20260917-224502_two-independent-rings-in-caravan-a-torus-nobody-composed.md)
(a different torus claim -- `(lap, slot)` addressing, not touch cost) -
[`../20260921/20260921-055148_radial-and-polar-against-cartesian.md`](../20260921/20260921-055148_radial-and-polar-against-cartesian.md)
(the mesh/torus/radial hop-count comparisons this piece's parallel-sub-ring idea borrows from) -
[`../../../caravan/cycle.rye`](../../../caravan/cycle.rye) - [`../../../caravan/regions.rye`](../../../caravan/regions.rye)

## What is, before what could be

Two essays landed today on `caravan/cycle.rye`'s ring: a full lap of `alder -> birch -> cedar ->
alder` (N=3 domains) touches 2 domains other than the origin before the ask comes home, and the
corrected general rule is N-1 touches for an N-domain ring -- read off the module's own metal
transcript rather than off a comment. Both essays reasoned about a *one-dimensional* ring: every
domain names exactly two peers, and the lap closes in a single directed walk.

This tree has also spent real reasoning on *two-dimensional* layouts for a different question --
Aurora's core placement, where a torus (grid with wraparound) was shown to cut mean hop count
against a flat mesh, and a radial layout was shown to cut it further for hub-and-spoke traffic.
Each essay stayed inside its own question: the mesh/torus/radial pieces left `cycle.rye` alone, and
`cycle.rye`'s own N-1 essay left topology shape alone. This piece asks the question that sits
between them: **does folding a ring of domains into a 2D torus change the N-1 touch cost
`cycle.rye` just measured?**

## The bound that governs any attempt to find out

[`caravan/regions.rye:35`](../../../caravan/regions.rye) declares `max_domains: u32 = 8`. Every
declaration this build accepts -- the one `caravan/read.rye` parses and `caravan/cycle.rye` checks
-- is capped at 8 domains, full stop. The prior essay's own crossover reading (tie at N=4,
chain-cheaper from N=5) sits comfortably inside that ceiling; a torus built from the same budget
tops out at an 8-domain graph, which in practice means a 2-by-4 layout or a plain 1-by-8 ring at
most. Every claim below stays bounded by this number, named once here rather than re-derived per
section.

## The first claim: the walk length stays fixed

**A Hamiltonian cycle on N nodes has exactly N-1 non-origin edges, whatever graph the nodes sit
in.** The walk alone decides this -- visit every node once, return home -- whatever *layout* the
walk is drawn across. A torus grid graph (the Cartesian product of two cycles, C_r x C_c) is
Hamiltonian for r, c >= 3, a standard graph-theory fact rather than a new derivation; folding 8
domains from a straight 8-ring into a 2-by-4 torus leaves the single serial lap exactly as long,
because a lap that visits 8 domains and returns always crosses 7 edges, whichever 7 edges of the
richer graph it happens to choose.

**So the honest finding is a flat one, stated precisely:** 2D layout leaves the one thing
`cycle.rye`'s own ring already does today exactly as costly -- one ask, one lap, one verified round
trip. The N-1 cost `caravan/cycle.rye`'s own `check_shape` and `check_lap` measure is a property of
the task alone, true whatever dimensionality diffuser's prior torus/mesh/radial essays varied. This
closes the question rather than opening a build: a torus-shaped `serial_cycle.kyri` would cost the
same lap as the straight-ring one already landed, for the same job.

## The second claim, named as unbuilt: what a richer graph buys instead

A torus layout's real difference from a ring sits elsewhere: a shorter **set of disjoint laps that
can run at once**, rather than a shorter single lap. An 8-domain ring arranged as a 2-by-4 torus (two
rows of 4, each row itself a 4-cycle, columns wired the same way) admits two independent 4-domain
sub-rings, each a legal `cycle.rye`-style declaration on its own: 4 domains, 4 flow regions, one
tail region, well inside `max_regions: u32 = 12` and `max_grants: u32 = 24`
([`caravan/regions.rye:40,46`](../../../caravan/regions.rye)). Each sub-ring's own lap costs 3 touches
(N-1 for N=4) rather than one 8-domain ring's 7 -- less than half, run twice, concurrently rather
than serially.

**What this would buy, if it works:** two verified round trips covering all 8 domains in the wall-
clock time of the slower one (3 touches), against one verified round trip covering the same 8
domains serially (7 touches). A roughly 2.3x wall-clock improvement in touches-to-cover-everyone,
at the cost of running two supervised processes-per-ring instead of one.

**What this would cost, still open:** `cycle.rye`'s own ring produces one verified view -- a domain
inside it can total the lap it is part of (minus its own closed segment), because every grant in
that one system's declaration was checked against that one declaration's own capability roster. Two
independent sub-rings are two independent declared systems, each verified within itself. **What
`caravan/capabilities.rye`, `caravan/regions.rye`, and `caravan/cycle.rye` compose today stops at
one system** -- a domain in row 1 holds grants scoped entirely to row 1, by the same rule that gives
the single ring its honest "no vantage point" finding. So the 2.3x speed-up buys two *faster, narrower*
verified views rather than one *faster, equally wide* one; whether that trade is worth taking
depends entirely on whether a caller wants the wide view or can live with two narrow ones --
exactly the caller question the Caravan torus-addressing essay from `20260917` already named and
left open.

## The falsifier

This piece's first claim (walk length is layout-invariant) stands on settled graph theory, resting
entirely on the arithmetic checked above -- a counting error is the only thing that could overturn
it.

**The second claim is unbuilt and needs one declaration file to settle.** Write two 4-domain
`serial_cycle`-style `.kyri` declarations, launch both through `caravan/cycle.rye`'s own `dependent`
harness in one process tree, and read whether the supervising parent (the one vantage point either
shape admits, per the module's own header) can hold both sub-rings' tails within
`fixed_argv_words + capabilities.max_caps_per_dependent + notify.max_peers_per_dependent <= 32`
([`caravan/cycle.rye:106`](../../../caravan/cycle.rye)). That is real Rye and real process-supervision
work, squarely past a reading of source -- exactly the kind of step the `20261002.102258` essay
already named as belonging to "whichever lane next touches that module for its own reasons."

## Confidence

**High** on the layout-invariance claim: it rests on a named standard graph fact (torus grid
Hamiltonicity) and arithmetic checked against bounds read directly from tracked source
(`max_domains`, `max_regions`, `max_grants`). **Low** on the parallel-sub-ring composition claim
being realizable as sketched: it is a structural guess about what the supervising parent process
*could* do, unchecked against `caravan/notify.rye`'s actual per-dependent peer-wiring limits beyond
the one bound cited, and entirely unbuilt.

## What this closes, and what it leaves

Closes: whether a torus shape helps the one task the ring already does, one verified lap covering
every domain. The walk's own arithmetic answers it, and the arithmetic belongs to graph theory
rather than to this codebase. Leaves open, named rather than built: whether a caller ever wants two
narrow verified views over one wide one badly enough to justify running two supervised ring
processes instead of one. This piece stays a vision-room reading alone -- tracked source and
standard graph theory, with its build, its witness, and its `ITINERARY.md` line all waiting for a
caller.
