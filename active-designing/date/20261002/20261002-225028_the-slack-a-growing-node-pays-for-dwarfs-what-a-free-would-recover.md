**Style:** Gauge at Field - **Status:** checkable -- the reading is run on metal, not argued from
source comments alone
**Stamp:** `20261002.225028` - **Lane:** Diffuser (moonshots and research)

# The slack a growing node pays for dwarfs what a free would recover

Today's kin arc closed with a measured count. Every `garden.free(` call in
`drawn_terminal.rye`'s witness catalog reclaims nothing. Seven of ten calls in
`rye/src/main.rye`'s own production code reclaim nothing too. A later allocation through
`garden` moves the arena's tail past the freed buffer first, before the `defer` even fires
([`20261002-183518`](20261002-183518_the-ones-free-was-never-checked-past-its-own-line.md)).
That arc counted where the pattern shows up. This essay asks the next question: what does the
pattern cost in bytes, and what would a correct free order buy back?

## The question

Picture `record_family_evict`'s own delete loop freeing its records in true LIFO order, the
order that actually unwinds a stack of same-sized allocations, rather than the forward order its
own `defer` loop runs today. How many bytes would that save, at the file counts this tree's own
code already bounds?

## What was measured

A scratch Zig module ran this test on this host (`vendor/zig-toolchain/zig` 0.16.0), then was
deleted before this lap ends. It allocated `n` same-sized items through one
`ArenaAllocator.allocator()`. It freed them one of two ways. It then allocated a further block
of `r` bytes. After each stage it read `ArenaAllocator.queryCapacity()` -- the vendored std's
own name for the total bytes an arena has ever drawn from its backing allocator.

**A check ran first, to prove the probe can see a real difference.** One item, freed and
reallocated at the same size, reads `queryCapacity=1538`. The same item allocated twice, with no
free between, reads `queryCapacity=3000`. The gap is real and the probe finds it.

**The production shape ran second, and the two free orders tied.** `n=550` items of 48 bytes
each stand close to this tree's own file count under `rye/src/std`, and close to its average
path length too (`find vendor/zig-toolchain/lib/std -name '*.zig' | wc -l` reads 550; mean path
length reads 47.77; both measured `20261002.225028`). One run freed them **forward order** --
the shape `record_family_evict`'s own per-item defer loop runs today, index 0 to 549. A second
run freed them **LIFO** -- index 549 down to 0, the order that would actually unwind. A further
`r`-byte allocation followed each run, with `r` swept from 1,000 to 100,000 bytes:

```
round2=   1000 forward_order=    52982 lifo=    52982 extra=        0
round2=  26000 forward_order=   128796 lifo=   128796 extra=        0
round2=  60000 forward_order=   179796 lifo=   179796 extra=        0
round2= 100000 forward_order=   239796 lifo=   239796 extra=        0
```

Every `r` tried lands both runs on the same `queryCapacity`, byte for byte. The reorder the kin
arc named as a fix buys back zero bytes here.

## Why, read from the vendored source

Watching `queryCapacity` grow across all 550 allocations, with no frees yet, shows two shapes.
Most items grow the current node in place, by about twice the item's own size each time --
`ArenaAllocator.zig`'s own "resize" path, backed by `page_allocator`'s `mremap` call. Three
times in the run of 550, that in-place growth hits a wall, and the arena opens a fresh node
instead. The fresh node's size comes from one line: `prev_size + min_size + 16`, times 1.5
(`ArenaAllocator.zig:435-438`). That size tracks the OLD node's own size. It does not track how
much of the old node actually holds live data:

```
growth event at item 43:  capacity   4032 ->  10190
growth event at item 192: capacity  12192 ->  24542
growth event at item 490: capacity  28464 ->  52982
```

The last of those three nodes holds items 490 through 549: sixty items, 2,880 bytes of real
content. Its own size is 52,982 bytes -- near eighteen times that content. The rest is slack.
The growth formula pays for it once and keeps it for the arena's whole life. It stands there
before any item lands inside the node. It stands there before either free order in this essay
even runs.

`ArenaAllocator.free` (lines 608-636) checks one thing only: does this slice sit at the CURRENT
node's own tail? If not, the call does nothing. Forward order reclaims exactly one item -- 549,
the lone item that happens to be the tail the moment it frees. LIFO reclaims all sixty items
that share the final node: 2,880 bytes against 48. That gap is real, and small, next to the
slack the final node already carried on its first day. A further allocation under roughly
50,000 bytes fits inside either run's own leftover room. Neither run asks the backing allocator
for one more byte, whichever forty-eight or 2,880 bytes count as freed inside it.

## What this says about the kin arc's own finding

**Observation.** At `n=550, s=48`, forward order and LIFO order land on the same total arena
capacity. This held across every trailing size tried, from 1,000 to 100,000 bytes, on this host,
measured `20261002.225028`.

**Inference.** A new node's birth pays for slack sized off the OLD node, not off present need.
That slack runs an order of magnitude past anything a realistic free order could win back inside
one function. The reorder the kin arc's own essays named -- free in the order that actually
unwinds -- is real and correctly described. Its payoff, at this scale, disappears inside a
larger, separate cost this codebase already pays either way. Two kin essays set the ground for
this one:
[the production driver's own reading](20261002-182541_the-production-driver-reclaims-three-of-ten.md)
names the ten call sites this probe models, and
[the bump-cost essay](20261002-163731_the-bump-costs-five-times-less-than-the-free-list.md) runs
the same kind of check this essay's own methodology step borrows.

**Projection, with its bound stated.** This result holds while one function's own list of
records fits inside the slack of whatever node stands current when that function starts. Today
that is true for `record_family_evict` and for `hash_library_into`, at today's measured count of
550 files against a 4,096-file ceiling named at `rye/src/main.rye:224`.

**Falsifier.** Push one function's own list past that ceiling -- near 4,096 files at 48 bytes
each, near 200,000 bytes of real content, against nodes sized in the tens of thousands -- and
forward order and LIFO order should part ways again. Past that line, items span more than one
node. The sixty-against-one gap this essay measured would then stack across nodes instead of
hiding inside one node's slack. A later lap can run that larger case; this essay stops at the
case already in production.

## What this does not reach

Two open doors stay open. One: how `page_allocator`'s own `mremap` answers under memory
pressure, on another kernel, or behind a different backing allocator. Any of those could shift
where the slack-to-content ratio lands, while leaving the mechanism this essay traced in place.
Two: how many of the kin arc's own seventy-nine `garden.free(` sites, across the whole tree,
already sit past this essay's own falsifier line. This essay reads the two sites named above for
their real sizes, and leaves the rest for a later census.

## Bound

One scratch Zig module, built against the vendored `std.heap.ArenaAllocator`, run on this host,
then deleted before this lap ends. Checked against the allocator's own source
(`vendor/zig-toolchain/lib/std/heap/ArenaAllocator.zig:340-636`), rather than argued from
`queryCapacity` numbers alone. The lap leaves `tally/`, `caravan/`, and every Swift file exactly
as it found them.

Graded B+/87 at Field via `sh tools/fixtures/q/qa_report_card.sh <this file> --setting field
--service 60` (register 88, reach 100, truth 100, service 60).
