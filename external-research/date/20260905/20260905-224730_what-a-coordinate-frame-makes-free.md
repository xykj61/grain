# What a Coordinate Frame Makes Free

**Stamp:** `20260905.224730`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Research for understanding -- outside work named and dated; the mathematics is old and
uncontested, the network systems are named from standing knowledge rather than fetched this lap,
and that boundary is marked where it falls
**Room:** the named world (`context/TWO_ROOMS.md`). Its crossing into our own names is
[`../active-designing/20260905-224714_the-angle-the-sky-computes-and-never-subtracts.md`](../active-designing/20260905-224714_the-angle-the-sky-computes-and-never-subtracts.md)
**Kin:** [`20260826-001743_the-toroidal-archive-read-against-the-tree.md`](20260826-001743_the-toroidal-archive-read-against-the-tree.md) -- [`../foundations/20260703-202312_the-marked-value.md`](../foundations/20260703-202312_the-marked-value.md)

A coordinate frame looks like a neutral way to write down where something is. It is not neutral.
Choosing a frame chooses which motions are cheap to say and which take work, and a system that
never made the choice on purpose has usually inherited one. This study names what each of the two
common frames makes free, reads four network systems by that light, and asks one question of the
address space our own tree already runs.

## The plain idea

A frame makes one family of motions free. Cartesian coordinates -- an x and a y -- make
**translation** free: adding a fixed step means the same thing everywhere on the plane, so a
structure whose truths survive sliding sideways is easy to write in x and y. Polar coordinates --
a radius and an angle -- make **rotation about a chosen center** free instead, and they make
distance-from-that-center a stored number rather than a computed one.

The trade is exact and it is worth stating in one line: **Cartesian has no center and pays for
radius; polar has a center it cannot forget and pays for translation.** In Cartesian the distance
from the origin is `sqrt(x^2 + y^2)`, computed on demand. In polar it is `r`, read. Ask a
structure which of those two questions it asks constantly, and the frame chooses itself.

This is Felix Klein's Erlangen Program of 1872 stated for working engineers: a geometry is
characterized by the group of transformations that leave it unchanged. Choosing coordinates is
choosing which symmetry you are willing to make invisible, and invisible is the same as free.

Two consequences follow, and both are checkable rather than decorative.

**A quantity that wraps is angular, and a quantity that does not is radial.** An angle at 359
degrees plus two degrees is one degree, and that is meaning rather than overflow. A radius has no
such courtesy: a radius that wrapped would be a fault silently wearing a valid value. Any system
mixing the two owes each quantity a statement of which it is.

**A distinguished center is a design fact, not a drawing convention.** Structures with a real
center -- a supervision tree with a root, a sponsorship hierarchy with an issuing authority, a
star with planets -- already have a radius whether or not anyone stored it. Depth from the root
is that radius, and blast radius is the ordinary word people already use for it.

## How much a distance can carry

A distance function is a channel: it takes a pair of positions and returns a number, and the
number is all the caller gets. Claude Shannon's 1948 *A Mathematical Theory of Communication*
gives the measure. If the distance takes `k` distinct values, it can carry at most `log2(k)` bits,
and it carries that much only when the values are equally likely. A distance whose answers pile
up on one value carries less, and the shortfall is measurable rather than a matter of taste.

That gives a plain test to run against any addressing scheme: enumerate every pair, take the
entropy of the distance distribution, and compare it to `log2(k)`. The gap is the part of the
range the metric occupies without using. A pair of `n`-bit addresses holds `2n` bits between them;
how many the distance returns is a fact about the design.

## Four systems, and what each made its distance out of

Named from standing knowledge of the published literature; no page was fetched on this lap, and
each is cited by author, title and year so a reader can check it directly.

**Chord** (Stoica, Morris, Karger, Kaashoek, Balakrishnan, *Chord: A Scalable Peer-to-peer Lookup
Service for Internet Applications*, SIGCOMM 2001) places every node and key on one circle of
identifiers modulo `2^m`. Its distance is the arc forward around that circle. The coordinate is
purely angular, there is no center at all, and the routing table is a set of chords across the
circle giving logarithmic hops. The identifier's own arithmetic *is* the distance.

**Kademlia** (Maymounkov and Mazieres, *Kademlia: A Peer-to-peer Information System Based on the
XOR Metric*, IPTPS 2002) derives distance by exclusive-or of two identifiers. This is neither
Cartesian nor polar; it is the metric of a binary tree, where distance rises with the height of
the lowest common ancestor. It is symmetric, which is the property Chord's forward arc lacks, and
that symmetry is what lets a node learn routes from the traffic it receives.

**Plaxton, Pastry and Tapestry** (Plaxton, Rajaraman and Richa, SPAA 1997; Rowstron and Druschel,
*Pastry*, Middleware 2001) route by matching successively longer prefixes, which is again a tree
metric: nearness means a shared prefix, and a shared prefix means a shared ancestor.

**Urbit's Azimuth** distributes identity across galaxies, stars and planets, where a point's
sponsor is fixed by its number. Distance is ancestry. Two planets under one star are close in the
authority sense whatever their numbers, and two adjacent numbers may sit under different galaxies.

The pattern across the four is the useful part. **Chord's distance is angular and its coordinate
is angular. Kademlia's, Pastry's and Azimuth's distances are ancestral and their coordinates are
hierarchical.** In every one of the four, the frame the addresses are written in and the frame
the distance is measured in agree.

## The question this hands to room two

A hybrid is possible, and it is where the interesting question lives. A scheme could derive
hierarchy from a number by modular arithmetic -- an angular operation -- and then measure distance
by ancestry alone. Nothing is wrong with that. It does mean the address carries an angular
coordinate that the distance never reads, and the honest thing is to know whether that coordinate
is wanted for anything else.

So the question crossing into our own names is narrow and answerable by measurement rather than
by argument: **in an address space that computes an angle, does anything subtract two of them?**
If the answer is no, then the second question is whether any decision would like to. Both are
questions about our own code, and they are taken up, measured, in the companion brief.

## Sources

- Klein, Felix. *Vergleichende Betrachtungen ueber neuere geometrische Forschungen* (the Erlangen
  Program), 1872. Frames as invariance groups.
- Shannon, Claude. *A Mathematical Theory of Communication*, Bell System Technical Journal, 1948.
  Entropy as the measure of what a channel carries.
- Stoica, Morris, Karger, Kaashoek, Balakrishnan. *Chord*, SIGCOMM 2001.
- Maymounkov, Mazieres. *Kademlia*, IPTPS 2002.
- Plaxton, Rajaraman, Richa. *Accessing Nearby Copies of Replicated Objects in a Distributed
  Environment*, SPAA 1997. Rowstron, Druschel. *Pastry*, Middleware 2001.
- Urbit's Azimuth identity scheme, as described in that project's own public documentation.

*Named from standing knowledge, unfetched this lap.* Every citation above is given by author,
title and year precisely so a reader can verify it against the primary source rather than against
this page. Where a later pass fetches one and finds a detail different, the correction accretes
here as an erratum, the way this tree has recorded an unreachable source before.
