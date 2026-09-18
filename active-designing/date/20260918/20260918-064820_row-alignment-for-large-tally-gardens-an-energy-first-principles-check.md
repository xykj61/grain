# Row alignment for large Tally gardens -- an energy first-principles check

**Language:** EN
**Status:** Vision -- a proposal, unwitnessed; no code moves until Keaton or a builder takes it up
**Style:** Gauge, Field setting
**Voice:** Kyri
**Room:** Vision -- reasons about a physical property of memory, not about a shipped feature
**Author:** Diffuser (moonshots and research lane)

## What is, before what could be

Two facts, cited to their public sources, bound before any claim rides on them.

**Fact 1 -- a DRAM access costs far more energy than a compute op.** Mark Horowitz's ISSCC 2014
keynote, "Computing's Energy Problem (and what we can do about it)," names representative 45nm
process figures. A 32-bit integer add costs about 0.9 pJ. A 32-bit floating-point add costs about
4.6 pJ. An off-chip DRAM access costs on the order of 1,300 to 2,600 pJ. That gap runs roughly
**three orders of magnitude** past the compute it feeds. Later surveys of "dark silicon" and
near-memory computing repeat this figure in the same shape. So it stands here as a widely cited,
textbook-level number in computer architecture, general to the field rather than specific to Grain.

**Fact 2 -- within DRAM, a ROW ACTIVATION dominates the per-access cost, and reuse is free.** DRAM
holds its bytes in rows. A typical row runs 1 to 8 KiB, and the exact size varies by device and
rank. Reading any address opens ("activates") its row into a row buffer. A further read or write to
that SAME open row costs a small fraction of the activation's energy. A read to a DIFFERENT row
must first close the open row, then activate the new one, paying the full cost again. This
row-buffer-hit/miss split is standard DRAM controller behavior. Every DRAM datasheet's own timing
parameters (`tRCD`, `tRP`, `tRAS`) name it, and the DRAMSim and Ramulator simulator literature
studies it in depth. **The precise row size on any given machine stays outside what a bounded
assert can query portably.** This proposal treats it as an unknown constant `row_bytes`, and
reasons about it symbolically, naming the approximation openly rather than hiding it.

**What follows from the two facts, and only this:** a memory access pattern that visits few
distinct DRAM rows, and revisits each open row many times before moving to the next, spends less
energy per byte touched. A pattern that jumps between rows on every access spends more. This is
the whole physical claim, stated in general terms. It stays there until the next section brings it
to Tally.

## What Tally already has right

`tally/region.rye`'s `Region` is a bump allocator. One buffer, one cursor, moving forward only.
`tally/gardens.rye`'s `Gardens` holds up to `max_gardens` (8) such regions by name. Each is carved
from caller-owned memory. Each is written and read in sequence, within its own bound. This is
already the access pattern Fact 2 rewards: a sequential fill of one region touches each row it
spans once, in order. For any region larger than one row, it reuses every row's buffer for every
byte between row boundaries before moving on. A general-purpose heap allocator, with its free lists
and fragmentation, offers a much weaker guarantee. Two objects allocated moments apart can land in
DRAM rows far apart, and a scan across them thrashes the row buffer on every step.

So the first, honest finding stands ahead of any proposal. **Tally's bump-allocation discipline is
already the energy-favorable shape.** TAME's own bounded-allocation rule was written for safety and
simplicity, and the energy-favorable design arrives as a side effect of that reasoning, rather than
by intent. This is worth stating plainly. A research lane's job includes saying "this is already
right" as often as "here is what to change."

## The one place left to check -- garden START addresses, and only for large gardens

A sequential scan reuses a row's buffer only WITHIN that row. The byte that crosses a row boundary
still pays a fresh activation, however sequential the access. When a garden's own start address
sits away from `row_bytes`'s grid, its first partial row goes to waste. The region pays one full
row activation to serve fewer bytes than a row holds. Every later boundary inside the garden then
falls at an offset from the true row grid, rather than on it. For a garden whose SIZE is a large
multiple of `row_bytes`, this misalignment costs at most one extra row activation total, the
leading partial row. That is a fixed, small, one-time cost, and it shrinks toward zero as the
garden grows. **For a garden whose size is small relative to `row_bytes`, alignment stays below the
reach of measurement**, since the whole garden already fits inside a single row's activation
regardless of where it starts.

This is where the proposal owes its own named example an honest reading. `tally/seed.rye`'s worked
region is "a 64-byte stack garden -- small enough to hold in mind, large enough to prove." A
commodity DRAM row runs from roughly 1 KiB to 8 KiB, well past sixty-four bytes. Aligning a garden
this small to a row boundary reaches for a difference Fact 2 predicts only above the row's own
size. **The proposal below applies only to gardens whose declared size is large relative to a
row** -- the kind Comlink's discovery table or a Tablecloth-scale buffer might carve. The small
near-stack examples `tally/seed.rye` teaches with stay exactly as they are.

## The proposal, sized to one round

Add an optional alignment parameter to `Region.init` (or a sibling constructor). It names a
caller's declared row-size hint. The region's effective start rounds up to that boundary, within
the buffer the caller already owns. It refuses, by name, when the buffer holds too little room for
both the padding and one useful byte. **The safe, portable proxy for `row_bytes` is the OS page
size** -- 4096 bytes on every target this tree currently builds for -- since the true row size
stays reachable only through platform-specific configuration. A page boundary carries no guarantee
of matching a DRAM row boundary. It stands a strictly better bet than an arbitrary offset, and it
is the one alignment figure a bounded assert can name honestly. Any harder hardware fact waits for
a platform-specific caller to supply it later. The doc comment names this approximation plainly,
rather than implying a precision the code does not carry.

This is a strict narrowing, in the sense `waymark-ladders.md`'s own naming test wants. Every garden
under the alignment threshold keeps its existing behavior exactly. The one new piece is a named
refusal (`InsufficientForAlignment` or similar) at construction. Every caller that skips the new
parameter continues exactly as it already runs.

## The falsifier -- what would kill this, and why it has not run yet

**This proposal is unmeasured on this machine.** A tool census, checked directly before writing
this sentence, came back empty. `perf` is absent, and so is `/sys/class/powercap/intel-rapl`. What
follows is a stated test for whoever next holds hardware that exposes an energy counter, rather
than a result.

**The test:** allocate two Tally gardens of equal size, several megabytes each -- large enough to
span many rows, small enough to fit comfortably in DRAM rather than cache. Align one to a page
boundary. Offset the other by a few dozen bytes. Run an identical sequential write-then-read pass
over each, N=30 repetitions. Read either the RAPL DRAM domain energy counter, on hardware that
exposes it, or a row-buffer-miss proxy counter (`perf stat -e mem_load_retired.l3_miss` or the
platform's equivalent) as a stand-in when direct energy stays unavailable.

**It is falsified if:** the aligned and unaligned runs land within 2% of each other at a 95%
confidence interval, on both counters. Fact 2's predicted one-row-activation saving is real, yet
small next to everything else a sequential few-megabyte scan already does. Cache line fills, TLB
behavior, and prefetcher activity could each swamp a one-row difference in practice, even where the
physics stays sound in principle. **A firing falsifier locates the finding precisely:** DRAM row
alignment sits away from where a bounded allocator's energy budget is actually spent. The search
then moves to a coarser question -- total distinct rows touched across a whole request, rather than
one boundary at one edge.

**Confidence: low-medium.** The two cited facts stand as well-established architecture, rather than
conjecture. What stays genuinely uncertain is whether a ONE-ROW saving at a garden's leading edge
runs large enough to survive measurement noise, at the scale gardens are actually sized in this
tree today. That uncertainty is exactly why this stays a falsifiable proposal, rather than a claim.

## What this does and does not ask of Bakery

**Buildable now, independent of hardware access:** the `Region.init` alignment parameter, its
refusal, and its own witness proving the rounding arithmetic and the refusal boundary. Every piece
of it is checkable on any machine, energy counter or none. **Waits on hardware:** the falsifier
itself, which wants RAPL or `perf` access this environment lacks today. Naming that split plainly
follows the same discipline `%457`'s own lesson asks for one room over. Build what is buildable.
Say plainly what waits. Let the unmeasurable half wait its turn, rather than hold the measurable
one back.

## Related

This paper stands independent of the torus/radial search closed this week
(`active-designing/date/20260917/` and `date/20260918/` before this file). It is a different
first-principles axis, memory-access energy rather than network/index topology. Both serve the same
brief: energy- and electricity-saving compute, argued from first principles, aimed at Tally and its
callers.
