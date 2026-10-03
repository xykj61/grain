**Style:** Gauge at Field - **Status:** checkable -- the reading is run on metal, not argued from
source comments alone
**Stamp:** `20261002.230126` - **Lane:** Diffuser (moonshots and research)

# The divergence window equals the last node's own content

The prior essay in this kin arc found that forward-order and LIFO-order frees land on the same
total arena capacity at `n=550, s=48` -- this tree's own `rye/src/std` file count and average
path length -- across every trailing allocation size tried, because the final node's own
birth-slack dwarfs anything either free order could win back. It named one falsifier rather than
attempting it: push one function's own list past the 4,096-file ceiling named at
`rye/src/main.rye:224`, where items span more than one node, and the two orders should part ways
again.

## The question

Does the falsifier fire? And if it does, what shape does the divergence take -- does LIFO simply
read cheaper everywhere past some line, or does something narrower happen?

## What was measured

A second scratch Zig module ran against the same vendored `std.heap.ArenaAllocator`
(`vendor/zig-toolchain/zig` 0.16.0), built and deleted before this lap ends. Same method as the
prior essay: allocate `n` same-sized items through one arena, free them forward or LIFO, allocate
a further `r`-byte block, and read `queryCapacity()` after each stage.

**At `n=4096, s=48` -- the production ceiling itself -- the two orders tied outside one window and
parted inside it:**

```
r=  50000 forward=  257668 lifo=  257668 diff=0
r=  52000 forward=  257668 lifo=  257668 diff=0
r=  52200 forward=  483482 lifo=  257668 diff=225814
r=  60000 forward=  495182 lifo=  257668 diff=237514
r=  95000 forward=  547682 lifo=  257668 diff=290014
r=  98200 forward=  552482 lifo=  257668 diff=294814
r=  98400 forward=  552782 lifo=  552782 diff=0
r= 100000 forward=  555182 lifo=  555182 diff=0
```

Below `r~52,100` and at or above `r~98,300`, the two runs tie exactly. Between those two lines,
every `r` tried diverges, by 225,000 to 295,000 bytes.

**The falsifier fires, and the fired shape is a bounded window, not a one-sided win.** LIFO
reads cheaper only inside roughly `[52,100, 98,300]` -- a 46,200-byte-wide band on the `r` axis --
and outside that band the two orders cost the backing allocator the identical number of bytes,
exactly as they did at `n=550`.

## Why, read from the node structure this run actually built

Watching `queryCapacity` grow across all 4,096 allocations, with no frees yet, shows six growth
events -- six nodes, not one:

```
node 1 born at item   43: capacity   4,032 ->  10,190
node 2 born at item  192: capacity  12,192 ->  24,542
node 3 born at item  490: capacity  28,464 ->  52,982
node 4 born at item 1000: capacity  52,982 ->  89,868
node 5 born at item 1810: capacity  93,878 -> 155,332
node 6 born at item 3132: capacity 159,350 -> 257,668
```

Node 6 is the live tail at the moment any free runs. It holds items 3132 through 4095 -- 964
items, 46,272 bytes of real content (`964 x 48`) -- inside a node whose own birth added
`257,668 - 159,350 = 98,318` bytes to the arena's total capacity. Node 6's own unused slack, the
day it is born and before any item is freed, is `98,318 - 46,272 = 52,046` bytes.

`ArenaAllocator.free` (lines 608-636) checks one thing: does this slice sit at the CURRENT
node's own tail. **Forward order** frees item 0 first through item 4095 last. Every call before
the last one is a no-op, since the tail sits at item 4095 until that final call. Item 4095's own
free then reclaims exactly 48 bytes -- the same single-item result the prior essay found at
`n=550`. **LIFO order** frees item 4095 first, which is genuinely the tail. Item 4094 is now the
tail, and so on down through all 964 members of node 6: a true unwind, reclaiming the full
46,272 bytes node 6 holds. The unwind stops there, because the run freed exactly the items that
live inside node 6 plus every item before it. One question stays open rather than chased: how the
free check reads a node boundary that still holds live data from an earlier pass. The measured
numbers below already explain the whole result without it.

So the room available for the trailing `r`-byte allocation is:

- **forward:** `52,046` bytes of pre-existing slack, plus `48` bytes reclaimed = `~52,094`
- **lifo:** `52,046` bytes of pre-existing slack, plus `46,272` bytes reclaimed = `98,318`

Both figures match the measured boundaries almost exactly (`52,094` against the observed
`52,000-52,200` crossing; `98,318` against the observed `98,200-98,400` crossing, the small gap
in each case being allocator alignment overhead on the trailing request itself). **The window's
own width, 46,200 bytes measured against `46,272` bytes computed, is node 6's reclaimable content
-- the exact gap between what forward order wins back (one item) and what LIFO order wins back
(the whole node).**

## What this says about the kin arc's own finding

**Observation.** At `n=4096, s=48` -- the production file-count ceiling named in the prior
essay's own falsifier -- forward order and LIFO order diverge for trailing allocations between
roughly 52,100 and 98,300 bytes, and tie exactly outside that band. Measured `20261002.230126` on
this host; the prior essay's own `n=550` case was re-run in this same harness and still ties
everywhere from `r=0` to `r=250,000`, confirming the two essays measure comparably.

**Inference.** The falsifier the prior essay named is correct: past the file-count ceiling,
multiple nodes exist and the two free orders genuinely part ways. The mechanism is not "LIFO is
simply cheaper" -- it is that LIFO's reclaim adds the LAST node's own live content on top of that
node's own pre-existing birth slack, while forward order's single reclaimed item adds almost
nothing to that same slack. The divergence window is bounded above by the last node's own total
size and below by that node's own slack alone, so its width is exactly the last node's own
content, whatever that content happens to be on the day the free runs.

**Projection, with its bound stated.** For a function whose own list sits inside one node (the
`n=550` case, and the prior essay's claimed production range), free order never matters. For a
function whose own list spans the live tail node and ends there -- which `record_family_evict`
and `hash_library_into` do today, since both lists are built and then fully consumed in one pass
-- free order matters only for a trailing allocation whose size happens to land inside a
specific, computable band: between the tail node's own birth slack and that node's own full
size. A trailing allocation smaller or larger than that band costs the same number of backing-
allocator bytes whichever order frees first.

**Falsifier for a later lap.** This essay ran the two orders as the only two choices. A free
order that stops partway -- reclaiming some middle span of node 6 rather than its whole run --
was not tried. The vendored `free()` path for a slice that sits inside a node but not at its
current tail is read from the source comment alone here, never traced on metal. That path covers
a genuinely out-of-order free, rather than forward or LIFO. A later lap could build that case
directly.

## What this does not reach

**Whether a real caller's own trailing allocation falls inside the window.** `r` here is a
stand-in for whatever a function allocates after its own delete loop finishes; this essay did not
read `record_family_evict`'s or `hash_library_into`'s own post-loop code to check what, if
anything, each allocates there. That reading is the next honest step before claiming either
production site actually sees this divergence rather than merely being structurally able to.

**Whether the window's bounds hold at a different item size `s`**, or whether the six-node shape
measured here is itself sensitive to `s`. Every node's size and count come from the growth
formula `prev_size + min_size + 16`, scaled by 1.5. A different `s` moves every boundary named
here. The window's existence is the finding, rather than this run's specific byte counts.

## Bound

One scratch Zig module, built against the vendored `std.heap.ArenaAllocator`, run on this host,
then deleted before this lap ends, in the same harness shape the prior essay used. Checked against
the allocator's own source (`vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig:340-636`) for
the mechanism, and against a second, independent harness run of the prior essay's own `n=550`
case for a sanity check, rather than trusting this essay's new code on its own. The lap leaves
`tally/`, `caravan/`, `rye/src/main.rye`, and every Swift file exactly as it found them.

Graded B/83 at Field via `sh tools/fixtures/q/qa_report_card.sh <this file> --setting field
--service 60` (register 80, reach 90, truth 100, service 60).
