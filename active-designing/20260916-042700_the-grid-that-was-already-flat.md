# The grid that was already flat

**Stamp:** `20260916.042700` -- **Status:** Landed -- **Room:** checkable
**Style:** Gauge at Field -- **Voice:** Kyri -- **Seat:** diffuser
**Grades:** row 7 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Instrument:** [`../tools/fixtures/a/aurora_placement_scan.sh`](../tools/fixtures/a/aurora_placement_scan.sh)
-- **Pen:** [`../tools/fixtures/a/aurora_placement_control.sh`](../tools/fixtures/a/aurora_placement_control.sh)
-- **Witness:** [`../tools/a/aurora_placement_witness.rish`](../tools/a/aurora_placement_witness.rish), rostered `aurora_placement`, `tier lap`

Row 7 of the bounded-torus moonshots proposes Aurora on a 4-core or 16-core network-on-chip
**whose topology Grain knows to be a torus**, so that placement and routing become computable
ahead of time. Its first witness is a placement map -- which module sits on which node, and the
hop count for every pair. Its falsifier reads: *the reachable boards are mesh rather than torus,
which would leave the wrap-around hops the map depends on unavailable.* Its confidence is low,
and the row says so plainly.

It was the last of the twelve rows carrying no erratum, and the reason it stayed last is the
reason it was worth reading: every other row could be graded by running something, and this one
names a board that does not exist. **Both of its halves turn out to be gradeable before any
board exists** -- one in arithmetic, one on this tree's own bytes.

## The geometry: at four cores the wrap is a duplicate

A `k x k` mesh links each node to its neighbors where those stay on the grid. A torus adds the
wrap. At **k = 2** that wrap repeats what the mesh already holds: `i + 1 mod 2` and
`i - 1 mod 2` name the same node, so each wrap link duplicates a link the board built already.

| Grid | Nodes | Torus diameter | Mesh diameter | Torus links | Mesh links | Torus mean hop | Mesh mean hop |
|---|---|---|---|---|---|---|---|
| 2 x 2 | 4 | 2 | 2 | 4 | 4 | 1.3333 | 1.3333 |
| 3 x 3 | 9 | 2 | 4 | 18 | 12 | 1.5000 | 2.0000 |
| 4 x 4 | 16 | 4 | 6 | 32 | 24 | 2.1333 | 2.6667 |
| 8 x 8 | 64 | 8 | 14 | 128 | 112 | 4.0635 | 5.3333 |

Read `20260916.042700` by `sh tools/fixtures/a/aurora_placement_scan.sh`. **Every figure in this
table is HELD**: the reading derives it in arithmetic, so it stands whatever this tree does, and
the closed forms are `2 * floor(k/2)` for the torus diameter and `2 * (k - 1)` for the mesh.

**So the row's own falsifier cannot fire at the grid the row names first.** A 2 x 2 torus and a
2 x 2 mesh are one graph -- same diameter, same distinct link count, same mean pair distance.
Both are the 4-cycle. A board arriving as a mesh leaves the map exactly as it stood, the wrap
having been a duplicate all along.

**At sixteen cores the falsifier fires, and it is worth something.** Diameter falls 6 to 4, mean
hop 2.6667 to 2.1333 -- a fifth of the average distance -- bought with 8 more links. That is the
grid where *knowing the topology is a torus* buys a placement map anything at all, and it is the
second grid the row names rather than the first.

**Which is why this is a re-aim rather than a re-rank.** The row is right about what a wrap
buys, and it points the start one grid too small. Its sentence offers 4 cores and 16 cores as
two sizes of one claim, and they are two different claims: at 4 the claim is empty, at 16 it is
real.

## The operand: this tree holds structure, not traffic

A placement map minimizes `sum over pairs of w(i,j) x hops(i,j)`. The hops come from the
topology, which the half above settles. The **`w`** is a communication weight between two
modules, and that is the term the row assumes and never names.

Measured on this tree `20260916.042700`:

| Reading | Value |
|---|---|
| Tracked Rye sources in a room | 1,987 |
| Rooms carrying Rye | 44 |
| Import sites read | 1,084 |
| Directed room pairs | 75 |
| Cross-room import edges | 225 |
| `loom` keys in the tracked journal | 9,188 |
| ... naming a module room | 242 |
| ... naming **two** rooms | 4 |

**Every figure here is FREE** -- the tree grows and the journal grows with it -- so run the scan
rather than reading them.

**The graph exists, and it measures a different quantity.** Zig refuses an import that escapes
the root file's directory, so every cross-room dependency in this tree arrives as a bare name
pointing at a hand-filed symlink; following those gives 75 directed pairs, the heaviest being
`tools -> crypto` at 25, `pond -> image` at 19, `brushstroke -> image` at 16, and `pond ->
tally` at 15. That is a **static dependency count**: one edge per importing source file. A
module read once at startup and a module called in a hot loop contribute exactly the same edge.
Placing by it would optimize for how the code was filed rather than for what it says to what.

**And the traffic term is not recorded anywhere.** Of 9,188 distinct `loom` keys the fleet has
written into its journal, 242 name a module room and **4 name two** -- `amphora_rye_paths`,
`amphora_rye_symlinks`, `caravan_tools`, and `tally_kumara`. All four count files or symlinks.
Not one measurement in the tree's own history carries a message count, a byte count, or a call
count between two named modules, which is the shape a weight must wear.

**That is row 12's finding arriving on a second road.** Row 12's erratum measured that across
all twelve row bodies the count of numeric effect claims reads zero, so its comparison of degree
had no operand. Row 7's placement has no operand either, for the same underlying reason: this
tree measures what it *is* far more than what it *does*.

**One more thing the row's sentence never states.** 44 rooms outnumber 4 nodes eleven to one,
and 16 nodes nearly three to one. A placement map at either grid is first a **coarsening** --
which rooms share a node -- and only then a placement. The coarsening is the harder half, it is
where a weight would actually be spent, and the row names neither.

## What the witness proves, and what it leaves open

`tools/a/aurora_placement_witness.rish` is GREEN on metal, read `20260916.042700` in **12
seconds**, over a control of **54 legs and 0 failures** building a real git repository in a
throwaway pen. Four mutations are planted and each is asserted to bite: removing the
wrap-duplicate collapse, replacing cyclic distance with plain distance, leaving import symlinks
unfollowed, and dropping the self-edge guard.

**One property is proven by input rather than by a mutation.** Room names are matched against a
key's underscore segments rather than as substrings, so `mandate_rows` names its own two
segments and stops. The pen carries exactly that pair -- a room `mand`, a key `mandate_rows` --
and asserts the key is refused. A substring reader would have counted it, and the real tree
holds the same trap in `mandate`, `mandi`, and `mand`.

**Where this reading stops.** Whether a 16-core torus board becomes reachable at all, which is
the row's own horizon of a year or more and untouched by anything here. Whether a weight
gathered later would place these 44 rooms well. And whether the static import graph, read as a
*lower bound* on coupling rather than as a weight, would be enough to start -- a question this
reading raises and declines to answer.

## The disposition

**Re-aim, keeping the rank.** Keep the row and keep its placement map as the first witness. Drop
the 4-core grid from the sentence, since the claim holds from 16 cores up. State the coarsening
as the first step rather than as an unmentioned one. And replace the falsifier with one that can
fire at the size the row means: *at the smallest grid the row names, the torus and the mesh are
the same graph* -- which is now measured, or *no measurement in this tree gives a weight between
two named modules*, which is also measured and is the door the row's own first witness waits
behind.

May a map wait for the distance it means to measure, and may the board, when it comes, find the
weight already gathered.
