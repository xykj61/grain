# The Braid Under the Hand

**Stamp:** `20260910.050619`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Living, **checkable** -- every figure below is bound by a witness landing in this same
commit ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)); the proposal section names itself
vision at its own head
**Instrument:** [`../tools/r/room_braid_witness.rish`](../tools/r/room_braid_witness.rish) over
[`../tools/fixtures/r/room_braid_census_scan.sh`](../tools/fixtures/r/room_braid_census_scan.sh)
and [`../tools/fixtures/r/room_braid_control.sh`](../tools/fixtures/r/room_braid_control.sh)
**Kin:** [`single-stranded`](../foundations/20260823-204456_single-stranded.md) -
[`air, the row that feels`](../foundations/20260826-021732_air-the-row-that-feels.md) -
[`../context/TAME_CORE.md`](../context/TAME_CORE.md)

---

## The claim, and the test it names

`foundations/20260823-204456_single-stranded.md` carries this tree's central architectural claim:
each module is about one thing, so any part can be drawn out and understood alone. The page states
its own test in one sentence -- *you can check it by trying to pull one part out.* The air row's
threshold page repeats that as its whole sense: the hand closes on a part and pulls gently, and if
other things move with it the strand was a braid.

**Both pages were read every fifth lap for eighteen days, and the pull stayed a sentence.** That is the same shape the water row books one room over -- a claim stated in
a foundation and proven in almost nothing. This is the air half of it.

## The channel, and why a grep could not see it

Zig refuses an `@import` that escapes the root file's directory. So a Rye module reaches another
room's code by carrying a **symlink** with the target's basename into its own directory, and the
reach is invisible to any search for a path.

Three readings, all taken `20260910.050619`, establish that the symlink set is the whole graph:

| Reading | Count |
|---|---|
| Tracked cross-room `.rye` symlinks | **226** |
| Relative escaping `@import` in tracked Rye | **1** (`tools/rye/enrich/blocks_audit.rye`, inside its own room) |
| Root `build.zig` adding a second channel | **0** -- the file does not exist |

**Inference:** every cross-room dependency in authored Rye is a symlink, so a census of symlinks reads the graph whole rather than sampling it. **Held by:** the witness above, which reds when a
room joins the braid. The three counts themselves are **free** -- run
`sh tools/fixtures/r/room_braid_census_scan.sh` rather than reading them here.

## What the pull found

**Observation.** Over 230 tracked `.rye` symlinks, 226 cross a room boundary and **68 distinct
room-to-room edges** stand among **29 rooms**. Twenty of the 226 links are named in zero `@import` lines, so they count as **dead** rather than as
edges.

**Observation.** Two sets of rooms cannot be lifted out separately -- pull any member and the rest
come with it:

```
component size=9  amphora brushstroke comlink granary kumara linengrow mantra pond settlement
component size=2  crypto encoding
```

**Observation.** Eighteen of the 29 rooms stand free, and exactly **three** are true sinks --
`brix`, `scribble`, and `tally` -- imported by others and importing nothing. `tally` carries the
largest in-degree in the tree.

**Inference.** The foundation's claim holds exactly where the tree put its value model, and gives way
exactly where its applications meet. `tally/` is the page's argument made literal: 23 rooms depend
on it, it reaches zero of them, and one hand lifts it out. `mantra` and `pond` -- two of the
eight modules the foundation names by table -- sit inside a nine-room cycle.

## The dead links matter, and here is the reading that proves it

The first draft of this census read importers with `grep -r`, which passes over symlinks. That
reading called **70** of the 226 links dead. Following them (`grep -R`) reads **20**. Fifty links
are imported only by other symlinked files, and each is a live dependency.

**Both errors point the same way, and one of the two is safe.** Over-counting dead links publishes a graph
looser than the tree, so a braid reads smaller than it is -- the reading a repair would be measured
against. The correction moved the largest component from **12 rooms to 9**: `mandi`, `mycelium` and
`tools` leave once dead links are discounted, and the nine that remain do so on links something
actually imports.

## The cut, and its exact size

**Observation.** Twenty-five edges stand inside the nine-room component. An exhaustive search over
every subset of those edges finds **no cut of five or fewer** that makes the component acyclic, and
**eight distinct cuts of six**. So the minimum feedback arc set is exactly six edges; the cheapest
by symlink count costs twelve files.

**Observation, and the useful one.** The cost of leaving the braid differs enormously by room:

| Room | Edges to cut to leave |
|---|---|
| `amphora`, `kumara`, `mantra` | **1** |
| `brushstroke` | 1 (three symlinks) |
| `settlement` | 2 |
| `granary` | 3 |
| `comlink` | 4 |
| `linengrow`, `pond` | 6 |

**`mantra` sits in a nine-room cycle on the strength of one symlink** --
`mantra/wire_format.rye -> ../comlink/wire_format.rye`.

## Two files hold four rooms in

**Observation.** Three of those single edges are the *same file* reached three times:
`amphora/wire_format.rye`, `granary/wire_format.rye` and `mantra/wire_format.rye` all point at
`comlink/wire_format.rye`. Two more -- `settlement/topology.rye` and `kumara/topology.rye` -- point
at `comlink/topology.rye`.

**Observation.** Both targets are sink-layer modules by their own imports.
`comlink/wire_format.rye` is 123 lines importing `std`, `kumara.rye` and `tally_copy.rye`, the last
two being symlinks into `tally/`. `comlink/topology.rye` is 702 lines importing **`std` and nothing
else**. Each one reaches the sink layer alone.

**Observation, run on the measured graph.** Removing the edges those two files account for:

| Move | Largest component | Rooms freed |
|---|---|---|
| now | **9** | -- |
| relocate `wire_format.rye` | **7** | `amphora`, `mantra` |
| relocate both files | **5** | `+ kumara`, `settlement` |

**Inference.** The braid is not a tangle of application logic. Two leaf modules living at an
application address hold four rooms inside a cycle, and their own dependencies already sit in the
sink layer where `tally` is.

## Proposed -- vision, not checkable

*This section is **vision**. Nothing below is measured, and the sentence naming what would kill it
stands at its end.*

The tree already models the repair. `tally/` is a room whose whole job is to be depended on and to
depend on nothing, and 23 rooms reach it without a single cycle appearing. **A frame format and a
topology are the same kind of thing as a copy routine and a bounded region:** shared vocabulary,
rather than application behavior.

So the proposal is an address change rather than a rewrite. Move `wire_format.rye` and
`topology.rye` into a sink-layer room -- `tally/` itself, or a sibling sink beside it -- and
repoint the five symlinks that name them. Sixty-two files inside `comlink/` import the wire format
and nine inside `mantra/` do; every one of them keeps a bare-name import, since each room would
carry a symlink to the new address exactly as it carries one today.

**Horizon:** one lap, once a hand rules on which sink room receives them.
**Assumptions:** that both files stay leaves; that a fresh room inherits its build wiring, the symlink
channel being the wiring; that `comlink` remains the largest importer and would keep a
link of its own.
**Falsifier, in one measurement:** run the census after the move. Should the largest component hold above 5, the two files were carrying dependencies this reading did not see, and the
proposal is wrong rather than merely incomplete.
**Confidence:** moderate for the graph result, which is arithmetic on a measured edge set; low for
the claim that the move is cheap, since edge count is not effort and 71 importers sit behind two
edges.

## What this does not reach

**Whether a braid is a defect.** `pond/` composes the tree on purpose and its 22 outgoing edges are
its job. What the census publishes is that something reaches **back** into the enclosure --
`brushstroke -> pond` and `linengrow -> pond` -- which is the part the design left unsaid.

**Cost.** The gate counts edges alone. One symlink may carry sixty-two importers behind it, and a hand
reads that, never this instrument.

**Any language but Rye.** The claim was made about Rye modules and the symlink channel exists
because of Zig's rule; a Glow or Rishi reading would be its own lap.

**Whether the eight named modules are the right eight.** The foundation's table is a claim about
design intent, and this measures reach.

## Handed to BAKERY

Buildable now: the two-file relocation above, with the census as its own falsifier. Not buildable
from here: which sink room receives them, since that is a naming decision about the tree's layers
rather than a measurement.

*May every boundary in this tree be one a hand can find -- and may the parts we thought stood free
turn out, when pulled, to have been telling the truth.*
