# The axis that finally paid

**Stamp:** `20260916.033000`
**Room:** mixed -- the three readings are checkable and bound by a green witness; the disposition at the close is a proposal and waits for Keaton's word.
**Status:** Landed -- the measurement stands; what it recommends for row 7 is a recommendation.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Witness:** [`../tools/a/aurora_placement_witness.rish`](../tools/a/aurora_placement_witness.rish) -- scan [`../tools/fixtures/a/aurora_placement_scan.sh`](../tools/fixtures/a/aurora_placement_scan.sh), control [`../tools/fixtures/a/aurora_placement_control.sh`](../tools/fixtures/a/aurora_placement_control.sh)
**Reads:** row 7 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)

**Superseded `20260916.095958`:** this reading was written at `20260916.033000` and its lap ended before any
send, so it stood in a round-open stash on no ref until `20260916.095958`. The living reading of row 7 is
[`20260916-042700_the-grid-that-was-already-flat.md`](20260916-042700_the-grid-that-was-already-flat.md),
whose instrument is the one the tree carries; the scan shape the figures below came from never
landed, so no run reproduces them. It is carried here because a session log of that lap names it,
and a record nothing carries is a record the tree has quietly dropped. Every word below is kept as
it was written.

Row 7 was the last of the twelve carrying no erratum, ranked twelfth on *paper until a board
exists*. It says this:

> **Claim.** Aurora targets a 4-core or 16-core network-on-chip whose topology Grain knows to be a
> torus, so placement and routing are computable ahead of time.
>
> **Falsifier.** The reachable boards are mesh rather than torus, which would leave the wrap-around
> hops the map depends on unavailable.

The ranking is honest about the board. It is wrong about the falsifier, which needs no board at
all -- because what a wrap is *worth* is arithmetic, and arithmetic is available at three in the
morning on a laptop.

## Observation: the row names two grids, and they answer oppositely

The claim says *a 4-core or 16-core network-on-chip* in one clause, as though the two were the same
proposition at two sizes. `tools/fixtures/a/aurora_placement_scan.sh` walks every ordered pair of
nodes on each, by breadth-first search over the real adjacency, and checks each walk against its
closed form. Read `20260916.032501`:

| Grid | Torus diameter | Mesh diameter | Ring diameter | Torus avg hop | Mesh avg hop | Ring avg hop |
|---|---|---|---|---|---|---|
| 2 x 2, 4 cores | 2 | 2 | 2 | 1.000000 | 1.000000 | 1.000000 |
| 4 x 4, 16 cores | 4 | 6 | 8 | 2.000000 | 2.500000 | 4.000000 |

**At 4 cores the falsifier cannot fire.** On a 2 x 2 torus the two neighbours in each dimension are
`(i + 1) mod 2` and `(i - 1) mod 2`, and those are the same node. The wrap link duplicates the
direct link, so the 2 x 2 torus *is* the 2 x 2 mesh -- and is also the 4-node ring. A mesh board at
this grid takes nothing away, because there was nothing there to take. The scan reads
`wrap_degenerate=yes`, `torus_equals_mesh=yes`, `hop_cut_share=0.000000`, `diameter_cut=0`.

**At 16 cores it fires, and it costs.** The wrap takes a fifth off the average hop against a mesh
and a third off the diameter. A mesh board there is a real loss, measurable before anyone buys one.

## Observation: this is the first row on the page where the second axis pays

The page has been hard on the torus, and rightly. Row 5's second erratum found *a torus hands down
a fixed offset set, `{1, g}`; a ring chooses, and choosing wins*. Row 8 found the wrap worth exactly
one cut, and stopped there. Row 11 found *the maximum among the supported ones reads 1 on a page
titled for a torus*. Three rows, three findings that the second axis carried nothing a line did not
already carry.

So this reading was built to ask the same question a fourth time, against a **ring of the same node
count** rather than only against a mesh. The answer comes out the other way:

| Grid | Placement cost, torus | Placement cost, ring | Second axis worth |
|---|---|---|---|
| 4 cores | 57 | 57 | 0.000000 |
| 16 cores | 286 | 478 | **0.401674** |

**Inference: the axis pays exactly where the coordinate means something.** Rows 5, 8 and 11 each
laid a torus over a *keyed* population -- SHA3 digests, capability masks, roster coordinates --
where the key avalanches by design or carries no distance at all. Row 7 lays one over *physical
cores*, where distance is wire length and is metric by construction. A second axis is worth having
when moving along it changes a real cost, and a hash coordinate is built so that it does not.

That sentence is the finding this lap would keep if it kept only one, and it reaches past row 7: it
predicts which of the page's remaining torus proposals are worth measuring at all.

## Observation: the artifact's input is derived, never declared

Row 7's first witness is *a placement map: which module sits on which node, and the hop count for
every pair*. A placement map takes a module-to-module communication weight as its input, and this
tree declares none -- `declared_weight_files` reads 1, which is this lap's own entry on the claim
board describing the absence.

A proxy stands, and it is a good one. Zig refuses an import that escapes the root file's directory,
so a room reaching another room's source does it by a **tracked symlink**, and the link target names
the room reached. Read the same stamp: **67 cross-room pairs over 33 rooms, total weight 228**. The
heaviest edges are `tools`-`crypto` at 25, `pond`-`image` at 19, `brushstroke`-`image` at 16.

**This is the reading's largest assumption and it is named rather than buried:** a symlink is a
*compile-time* dependency where a placement map wants a *run-time* message count. The scan emits
`operand=derived_proxy` so the word `proxy` travels with every figure drawn from it.

## Observation: placement is worth computing at one grid and is ceremony at the other

A map is worth building only if placements differ in cost. The scan costs a placement as
`sum over edges of weight * hops`, lays the heaviest `nodes` rooms by a bounded search over 27
deterministic room orders, and compares that against 2,000 deterministic random placements.

| Grid | Computed map | Random floor | Random mean | Gain against mean | Beats every sample |
|---|---|---|---|---|---|
| 4 cores | 57 | 57 | 65.632 | 0.131521 | no |
| 16 cores | 286 | 304 | 418.147 | 0.316029 | **yes** |

At 16 cores the computed map beats all 2,000 samples, and held at 20,000 samples across three
independent seeds -- floors of 294, 301 and 294 against a map that never moved off 286, since the
search is deterministic and the sampling is the only stochastic half. At 4 cores it ties the floor exactly,
because 24 placements is a space chance exhausts.

**So row 7's artifact is worth building at 16 cores and is ceremony at 4.** That is the same split
the falsifier made, arriving by a second road.

## What the control found, which is the part worth reading twice

The first draft costed a single greedy pass ordered by weight. `tools/fixtures/a/aurora_placement_control.sh`
planted a mutation disabling that ordering and asserted the cost would rise. **It fell, 286 to 201** --
and the reason was a genuine fault in the scan rather than a better heuristic. Varying the order also
varied *which* rooms got placed, so a name order laid four rooms that barely reach each other and
scored a smaller number against a different problem. The set is fixed now and only the order moves;
the weight order then wins all 27, which is the heuristic vindicated honestly rather than assumed.

That regression is a control leg in its own right: a moving set scores **below** the random floor,
which is the signature of comparing two problems rather than two answers.

A second control leg was thrown away for flakiness rather than for error. Pen release was first checked
by counting `/tmp` before and after a run, and `/tmp` **fell by three** during a reading that created
nothing -- eight ships share this pier, and a global directory count is a measurement of the fleet.
It is a structural check now: the scan contains no `mktemp`.

## Projection

**Horizon:** the life of row 7, which the page itself puts at a year or more.

**Assumptions:** the proxy graph's *shape* resembles the run-time message graph well enough that the
sign of the comparison holds; the module set stays near its present size; a board, if one arrives, is
a 2-D grid of one of these two sizes.

**Falsifier:** a run-time message count between rooms, once measured, ranks the placements
differently enough that the computed map stops beating the random floor at 16 cores. That is a real
measurement somebody can take, and it would retire the placement half of this paper without touching
the topology half, which rests on graph arithmetic alone.

**Confidence:** high on the topology readings, which are closed-form and checked from both sides;
moderate on the placement readings, which rest on the proxy; and the gain figure is a **floor rather
than a ceiling**, since 16! placements are unvisited and 286 is an upper bound found by search.

## Recommended disposition for row 7

**Re-aim rather than re-rank, and split the grid clause.** Keep the row. Say 16 cores rather than
*4-core or 16-core*, because at the smaller grid the row's own falsifier is vacuous and its artifact
is ceremony. Replace the falsifier with one that can fire on evidence this tree can gather: *a
run-time message weight between rooms, once measured, leaves the computed placement no better than
a random one at the grid the row names.* And note in the row that its first witness now has an
input -- derived, proxied, and 67 edges wide.

**On the rank, a proposal rather than a finding.** Twelfth was assigned on *paper until a board
exists*, and the paper turns out to be writable now. Whether that moves the row is Keaton's word;
what this lap establishes is that the ranking's stated reason no longer holds.

---

*May the coordinate mean something wherever we lay one down, and may the axes we add be the ones
that pay.*
