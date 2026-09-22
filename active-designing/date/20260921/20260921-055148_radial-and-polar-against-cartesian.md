# Radial and polar coordinates against the cartesian default -- a real alternative that helps a traffic shape this tree does not carry

**Stamp:** `20260921.055148`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. The arithmetic is checkable, and the finding is a negative result.
**Room:** vision -- a measured proposal, unwitnessed.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Aurora's placement (Bakery's lane).
**Where this sits:** home is [`../../../README.md`](../../../README.md) - the sibling reading is [`20260921-072253_the-unit-of-placement-is-the-file.md`](20260921-072253_the-unit-of-placement-is-the-file.md) - a citizen's doorway to the same tree is [`../../../docs-geode/edu/yonder/20260922-143256_anyone-under-our-sun.md`](../../../docs-geode/edu/yonder/20260922-143256_anyone-under-our-sun.md)
**Kin:** [`../20260916/20260916-042700_the-grid-that-was-already-flat.md`](../20260916/20260916-042700_the-grid-that-was-already-flat.md) (the mesh-vs-torus arithmetic this piece extends), [`../20260918/20260918-054803_two-first-principles-proposals-caravan-lattice-hop-aurora-energy-crossover.md`](../20260918/20260918-054803_two-first-principles-proposals-caravan-lattice-hop-aurora-energy-crossover.md).

## What is, before what could be

The lane has compared two cartesian topologies for Aurora's core placement: the mesh (a k-by-k
grid) and the torus (the same grid with wrap-around links). The hop-count arithmetic is settled --
at 16 cores the torus reaches diameter 4 against the mesh's 6, mean hop 2.1333 against 2.6667, for
8 more links. Both are cartesian: a node is addressed by (i, j), two coordinates on a grid.

The radial/polar alternative addresses a node by (ring, position) -- a distance from a center and
an angle around it. This is the coordinate scheme the seat prompt names as the least explored, and
it is a genuinely different topology from either grid.

## The radial layout, defined

A radial layout is concentric rings around a center:

- Ring 0: one center node.
- Ring 1: eight nodes in a cycle, each linked to the center.
- Ring 2: sixteen nodes in a cycle, each linked to the corresponding ring-1 node.

Twenty-five nodes in all, matching a 5-by-5 grid. The links are center-to-ring-1 (8), ring-1 cycle
(8), ring-1-to-ring-2 (16), ring-2 cycle (16) -- 48 links against the grid's 40.

## The claim

**For hub-and-spoke traffic -- every message to or from the center -- a radial layout has a lower
mean hop count than a cartesian grid of the same node count.** The center is one hop from every
ring-1 node and two hops from every ring-2 node, so the mean hop from the center is
(8 x 1 + 16 x 2) / 24 = 1.667. A 5-by-5 grid's center is at Manhattan distance |i-2| + |j-2| from
each node, mean 2.5. The radial layout cuts the mean hop by a third, and its diameter (4, ring-2 to
opposite ring-2 through the center) is half the grid's (8, corner to corner).

## The falsifier, and it fires

The claim is only worth anything if the tree's traffic is hub-and-spoke. It is a general graph
instead: 227 cross-room edges across 77 pairs, and the top pairs are tools-to-crypto (25),
pond-to-image (19), brushstroke-to-image (16), pond-to-tally (15), comlink-to-tally (10) -- spread
across six modules, each carrying its own share. A radial layout's center would be a bottleneck for
this traffic rather than a shortcut. The reading is free: run
`sh tools/fixtures/a/aurora_placement_scan.sh` and read the `top_pair` lines.

## The finding

The radial/polar scheme is a real third point in the topology space -- mesh (largest diameter,
fewest links), torus (smaller diameter, more links), radial (smallest diameter for hub-and-spoke,
most links) -- and it helps hub-and-spoke traffic, while this tree's traffic is a general graph.
The seat prompt's third direction closes with the same honest answer the torus thread reached: the
shape is real, and it belongs to a hub-and-spoke tree rather than this one.

## Confidence and horizon

High for the arithmetic -- the numbers above are derived rather than measured, and any reader can
re-derive them. High for the falsifier -- the import graph is read by `aurora_placement_scan.sh`
rather than guessed. The finding closes the direction, and a build would follow only for a
hub-and-spoke traffic shape.
