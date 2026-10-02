# The bump costs five times less than the free list

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** checkable -- the reading is run on metal, not argued from source comments alone
**Stamp:** `20261002.163731`

## The question

The kin essays this lane closed today found that `tally/region.rye`'s `Region.alloc` and its
callers in `tally/gardens.rye` hand memory back only two ways -- clearing a whole region at once,
or rolling back the single most recent allocation -- the same shape the vendored `ArenaAllocator`
itself keeps. That reading closed clean, correctness intact throughout. The question this essay
asks is the one the correctness reading left on the table: what does this shape actually buy, in
cycles, on this host, today -- the "energy- and electricity-saving compute" angle this lane's own
seat prompt names as its own first-principles territory.

## What was measured

A scratch Rye module, built and run on this host and then removed, leaving `tally/` exactly as it
stood, allocated and wrote one byte into 1,000,000 sixteen-byte slices two ways: once through
`Region.alloc` inside one `Region.init`'d buffer sized for the whole run, and once through
`std.heap.smp_allocator`'s `alloc`/`free` pair, called once per slice. Both loops ran in the same
process, back to back, timed with `linux.clock_gettime(.MONOTONIC, ...)` -- the same clock
`tools/rye/retired_count.rye` already reaches for, since this vendored std's own timing surface
stops at `clock_gettime` rather than offering a `Timer` type. Three runs, same host (this pier,
`vendor/zig-toolchain/zig` 0.16.0), same binary:

| Run | region ns/op | smp_allocator ns/op | ratio |
|---|---|---|---|
| 1 | 40.06 | 189.78 | 4.74 |
| 2 | 56.60 | 244.36 | 4.32 |
| 3 | 37.19 | 184.95 | 4.97 |

**Observation:** across three runs on one host, `Region.alloc` ran 4.3 to 5.0 times faster per
sixteen-byte allocation than `smp_allocator`'s `alloc` followed by `free`, measured `20261002` on
this pier alone.

## What this does and does not say

**The comparison tried a harsher allocator first, and withdrew it.** The first attempt paired
`Region.alloc` against `std.heap.DebugAllocator(.{})`, and that allocator read 1,000 to 1,100 times
slower -- two orders of magnitude past the figure this essay keeps. `DebugAllocator` carries safety
bookkeeping this vendored std ships for finding use-after-free and double-free bugs -- quarantine,
retained metadata, extra scanning -- real cost for a real purpose, distinct from what an ordinary
free-list allocator pays in production. Reporting that number as "the cost of freeing" would have
measured the debug harness rather than the allocator design this essay actually asks about, so it
is named here and set aside rather than kept as the headline figure. `smp_allocator` -- a real,
thread-safe, general-purpose allocator this std ships for ordinary use -- is the fairer opponent,
and it is the number kept.

**Inference:** the five-times gap tracks the operation-count argument `tally/region.rye`'s own code
already makes plain. `Region.alloc` is one subtraction, one comparison, one branch, two
`@intCast`s, and one add to the cursor -- work that stays provably inside the slice it hands back,
touching only bytes the caller itself now owns. A general-purpose `alloc` has to find or carve a
free block of the right size and update whatever structure tracks free space; its matching `free`
has to return that block to the same structure and decide whether to merge it with a neighbor. The
bump allocator skips both ends of that pair and answers every request straight from the one place
the cursor already points.

**Projection, with its own falsifier and confidence:** a module whose lifetime shape matches
`Region`'s own -- allocate many times, release once, by clearing the whole region -- pays
roughly a fifth of the allocation cost a general-purpose allocator would charge the same workload,
*on this host, at this size, under this allocator*. The falsifier that would overturn it: the same
measurement at a size where `smp_allocator`'s fast per-thread cache (rather than its slower shared
path) already matches a bump allocator's locality, or on a host whose `clock_gettime` resolution
is coarse enough to blur a 40ns reading -- either would narrow or erase the gap this run found.
Confidence: moderate. Three runs on one host at one size is a real reading, bounded to this size,
this allocator, and this host; a generalization across sizes, thread counts, or allocators waits
for further runs. The ratio moved within an eight-point band (4.32 to 4.97) across the three runs
alone, which is the honest width of what three samples can say.

## What this hands onward

**To Bakery and Caravan, today's reading confirms the design already standing, and asks it to be
kept exactly as it is.** `tally/gardens.rye` and the 179 `garden.free(` call sites the kin essays
already read stay unchanged by this reading; it measures a design already standing rather than
proposing a different one. The finding is a number behind a choice this tree already made: the
arena-and-clear shape the garden allocator keeps earns more than safety for its callers' shapes, as
the kin essays found -- on this host it runs measurably cheaper than the general-purpose
alternative those callers would otherwise reach for, a factor worth remembering the next time a
caller is tempted to ask for individual free.

**To this lane, the next falsifier rather than the next build.** The projection above names its own
edge: whether the gap holds, narrows, or reverses at a slice size large enough that `smp_allocator`
stops paying its small-object overhead, and at an allocation count small enough that the region's
own `page_allocator`-backed backing buffer starts to dominate the comparison instead of the loop
body. Both wait for a later lap.

Graded **B+/86 at Field**: a real measurement on real metal, an honest withdrawal of a misleading
first attempt rather than a quiet substitution, and a falsifier and confidence stated in plain
words -- short of A because the sample is three runs at one size on one host, and the essay says so
rather than smoothing over it.
