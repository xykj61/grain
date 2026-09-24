# The Address That Does Not Fit

**Stamp:** `20260906.061229`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Mixed. The latency curve is measured and its instrument refuses seven ways; every
sentence about what Caravan or Tally should do with it is inference, marked as such
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Instrument:** [`../tools/fixtures/t/tlb_reach_census.sh`](../tools/fixtures/t/tlb_reach_census.sh)
over [`../tools/fixtures/t/tlb_reach_probe.rye`](../tools/fixtures/t/tlb_reach_probe.rye);
refusals proven by [`../tools/fixtures/t/tlb_reach_control.sh`](../tools/fixtures/t/tlb_reach_control.sh)
**Elder:** [`20260906-042838_the-table-that-fits.md`](20260906-042838_the-table-that-fits.md), whose
bound this paper completes, and one of whose attributions it corrects -- see *The elder sentence,
measured*, added `20260906.091039`

---

## What this paper claims, before the argument

**A table's cost is decided twice: once by how many bytes it touches, and once by how many pages
those bytes are spread across.** The elder study measured the first and named the boundary worth
designing to -- fit the first cache, and a dependent read costs 1.65 ns. That reading holds. This
paper measures the second boundary and finds it lands somewhere the first says nothing about.

**Measured on this board, `20260906`: a walk over 64 pages costs 1.65 ns per read, and the same
walk over 65 pages costs 3.90 ns.** Same bytes touched, same instructions, same cache sets, one
more page. Across five census runs the step read **2.17x to 2.38x**, and all five placed the
boundary at the same two page counts -- 64 free, 65 charged. It holds flat from there to 512 pages.

**The step is translation, proven by removing it.** Handing the identical walk 2 MiB pages returns
the ratio to **0.98x to 1.00x** across the same five runs, with 32,768 kB of huge pages read back
from the kernel as actually granted each time.

**The engineering sentence, and it is about allocation shape rather than size:** a structure that
fits the first cache in bytes can still miss on every access, if its bytes arrived in pieces.

## Scope

One machine, one access pattern, one measurement, on `20260906`. AMD EPYC-Rome, 4 cores, 8 threads,
32 KiB L1d, 512 KiB L2, 16 MiB L3, 4 KiB pages, 2 MiB huge pages, transparent huge pages in
`madvise` mode -- every figure read from `/sys` and `/proc` at run time rather than assumed.
Latency, never energy: this board exposes no RAPL counter, no MSR, and no perf event, checked
`20260906` and unchanged. Time is the observable available here.

**And one more limit, named at the door:** no counter on this board reports a translation miss. The
argument therefore rests on a **matched control** rather than on an event count, and the whole
design below exists to make that control worth trusting.

## The gap the elder paper left

The elder study's own closing sentence names a second axis and leaves it: the plateau past the last
cache reads 161.84 ns, and every one of those reads also paid for **address translation**, which
the study neither separated nor bounded. A load's virtual address is translated before any cache is
asked. Translations are cached in a structure of their own, that structure holds a fixed number of
entries, and its capacity is counted in **pages**.

So two tables of identical size can cost differently. Observation supports this; the rest of the
paper measures how much.

## The instrument, which is a control before it is a timer

Two walks touch exactly the same number of cache lines, in the same order, through the same
dependent-load instruction stream. One thing varies.

| Layout | Where line `i` sits | Pages for `n` lines |
|---|---|---|
| **packed** | byte `i * 64` | `n / 64` |
| **spread** | byte `i * 4096 + (i * 64 mod 4096)` | `n` |

Same bytes. Same instructions. Sixty-four times the translations. A difference in time is
translation, because translation is what differs.

**The control that makes the pair fair, and it nearly went missing.** A cache set is chosen by
address bits 6 through 11 -- above the line offset, below the 4 KiB page boundary. Put every spread
line at offset 0 of its own page and all `n` lines land in one set, and the pair would measure
conflict misses while claiming to measure translation. The spread offset is therefore
`(i * 64 mod 4096)`, which walks bits 6 through 11 through exactly the sequence the packed layout
walks. `assert_set_parity` proves that holds for **every** node before any timing runs, so the
claim is checked rather than argued.

**Where the pair is exact, and where it is suggestive.** L1d is indexed by bits below the page
boundary, so the parity above makes the two layouts identical to L1d at every point. L2 and L3
index using bits from the page frame, which the layouts do not share. The exact claim therefore
lives at 512 nodes and below, where all touched bytes are L1d-resident in both layouts; everything
larger is reported and marked.

**The probe defeats the same three liars the elder one did** -- a deleted loop, a predicted stride,
and a shared cache line -- by the same three means: every address comes from the previous load out
of a runtime-filled buffer, the walk is a random single cycle, and one node occupies a whole line.
The cycle is walked and counted before it is timed, so "working set" means what it says.

## What was measured

One census run, `20260906`; minimum of 4 repetitions of 2,000,000 dependent loads per point, on
the board named above. Latency in nanoseconds per read. The run-to-run range for the step itself is
given below the table.

| Pages spanned | packed | spread | ratio |
|---|---|---|---|
| 8 | 1.74 | 1.65 | 0.95x |
| **64** | **1.65** | **1.65** | **1.00x** |
| **65** | **1.65** | **3.90** | **2.36x** |
| 128 | 1.66 | 3.97 | 2.39x |
| 512 | 1.66 | 4.02 | 2.42x |
| 768 | 4.31 | 6.97 | 1.62x |
| 1280 | 4.32 | 7.12 | 1.65x |
| 1408 | 4.36 | 23.54 | 5.40x |
| 2048 | 4.37 | 27.01 | 6.18x |
| 4096 | 4.36 | 48.38 | 11.10x |

**The first boundary is one page wide.** The sweep walks 64, 65, 66, 67, 68, 69, 70, 71, 72 one at
a time for exactly this reason: a doubling sweep can only ever answer "between 64 and 128", and the
answer here deserved better. Sixty-four pages cost nothing; sixty-five cost 2.36x, and so does
every count above it to 512.

**Below the boundary the pair reads alike, which is what earns the reading above it.** The census
gates this: across every point at or below 64 pages the two layouts differ by at most **2 to 6
percent**, run to run, and a pair differing by more than 20 refuses under `flat_below_knee`. Two
walks that already disagree before any translation structure is stressed would make the step above
them worthless.

**And the boundary itself reproduces exactly.** Five census runs on `20260906` each reported
`reach_pages=64` and `broke_at=65`, with the step reading 2.17x, 2.29x, 2.32x, 2.37x and 2.38x. The
*magnitude* moves a tenth between runs on a shared host; the *location* did not move at all.

**A second boundary sits between 1,280 and 1,408 pages**, where the ratio moves from 1.65x to 5.40x
and the spread latency moves from 7.12 ns to 23.54 ns. This one is reported rather than gated: the
census locates the first step and stops, and beyond 512 nodes the layouts no longer share L2 and L3
set distribution, so part of that rise belongs to the confound named above.

**The two boundaries have different shapes, and the difference is worth a sentence.** The first
arrives across a single page. The second spreads across the interval between 1,280 and 1,408.
*Inference, offered with moderate confidence:* a fully-associative structure breaks exactly at
capacity, while a set-associative one starts missing before it is full, because a random spread of
page numbers overfills some sets while others still have room. If that reading is right, the first
boundary reports a true capacity and the second reports a **usable reach below** whatever the part's
real capacity is. A designer who needs the second number should measure it rather than read a
vendor table, and this instrument is how.

## The falsifier, run rather than named

**If the step is translation, then giving the same walk fewer translations must remove it.** The
probe re-runs the entire sweep on 2 MiB pages, requested by `madvise(MADV_HUGEPAGE)` before the
arena's first touch -- order matters, since the advice steers a page fault and a region already
faulted in small pages stays that way.

| Pages spanned | ratio, 4 KiB pages | ratio, 2 MiB pages |
|---|---|---|
| 65 | 2.36x | **1.00x** |
| 128 | 2.39x | **1.01x** |
| 512 | 2.42x | 1.84x |
| 1408 | 5.40x | 3.92x |
| 4096 | 11.10x | 3.88x |

**At the boundary the penalty vanishes entirely**, and the second boundary vanishes with it -- the
huge-page curve holds flat near 17 ns from 768 pages to 8,192, where the small-page curve climbs to
50 ns.

**And the leg proves its own plant arrived.** The probe reads `AnonHugePages` back from
`/proc/self/smaps_rollup` after the walks and reports **32,768 kB** granted; the census refuses when
that reads zero, and refuses again when the kernel declines the advice. A plant that did not run is
not evidence. This tree published a control one lap earlier whose plant silently failed to build and
reported itself proven, which is why that check is a leg here rather than a comment.

**What the huge-page leg leaves behind is honest and useful.** From 768 pages upward a residual near
3.9x survives huge pages, and by construction it is **not** translation -- 8,192 nodes across 32 MiB
need 16 huge-page translations. That residual is the L2 and L3 confound this paper declared before
measuring, standing where it was predicted to stand. Read the two columns together and they
decompose the cost: at 4,096 pages, 11.10x total, 3.88x of it locality, the remaining **2.86x**
translation.

## The elder sentence, measured

*Added `20260906.091039`, on a later lap of this same seat. The movement above bounds its exact
claim at 512 nodes and leaves the elder study's own sizes alone. This one goes and reads them.*

The elder study published: **"Crossing the L3 boundary, from 4 MiB to 32 MiB, costs 7.87x."** That
sentence names a cause. Its sweep moved bytes and pages together, so it could not separate the two,
and on this board its largest single jump sits at **8 MiB** -- which is half of the 16 MiB L3 the
kernel reports, and is **2,048 pages of 4 KiB**, well past the second translation boundary the
paired sweep above locates for itself: between **1,280 pages** (1.65x) and **1,408** (5.40x),
measured on this board `20260906`. The elder study's 4 MiB point, at 1,024 pages, sits inside that
reach; its 8 MiB point sits outside it. Two mechanisms predict a step in the same place, and the
elder sweep could name only the one it had a number for.

**The instrument runs the elder study's own packed layout, at its own three sizes, under both page
sizes.** Nothing else changes: same bytes, same cycle, same permutation, same board, the two legs
minutes apart. Five run pairs, `20260906`, minimum of four repetitions of two million dependent
loads each, with 32,768 kB of huge pages read back from the kernel as granted on every large-page
leg.

| Working set | Pages, at 4 KiB | ns per read, 4 KiB pages | ns per read, 2 MiB pages | ratio |
|---|---|---|---|---|
| 4 MiB | 1,024 | 17.85 - 18.46 | 17.35 - 18.06 | **1.00x - 1.05x** |
| **8 MiB** | **2,048** | **30.43 - 48.25** | **18.00 - 19.82** | **1.68x - 2.43x** |
| 32 MiB | 8,192 | 147.41 - 158.44 | 101.21 - 111.26 | **1.40x - 1.51x** |

**Observation.** At 4 MiB the page size makes no difference the instrument can see. At 8 MiB it
makes a factor of two. At 32 MiB it makes a factor of 1.4 to 1.5.

**Observation, second.** The large-page reading at 8 MiB is steady across five runs -- 18.00 to
19.82 ns, a spread of 10% -- while the small-page reading at the same size swings from 30.43 to
48.25, a spread of 59%.

**Inference.** The elder span itself reads **8.26x to 8.71x** here under 4 KiB pages, which
reproduces the published 7.87x within day-to-day variation, and **5.81x to 6.16x** under 2 MiB
pages. So most of that span is genuinely cache, and the elder study's direction holds. **Yet the
largest single step inside it is not.** From 4 MiB to 8 MiB the walk costs **1.70x to 2.67x** more
under small pages and **1.04x to 1.10x** more under large ones -- at a working set that still fits
the 16 MiB L3 with room to spare. The step the elder study attributed to the L3 boundary is
majority page walk.

**Inference, second.** The instability at 8 MiB under small pages is what sitting exactly at a
capacity looks like from outside: how many of the 2,048 translations stay resident depends on what
else touched the machine. Under 2 MiB pages the same walk needs four translations and has nothing to
contend for, which is why that column is the quiet one.

**What this corrects, and what it leaves standing.** The elder study's bound -- fit the first cache
and a dependent read costs 1.65 ns -- is untouched; it was measured at sizes where the page count
never mattered. Its 2.60x step at 48 KiB is real cache behavior, at a size spanning twelve pages.
What moves is one clause: the cost at 8 MiB was named for the cache boundary nearest to it, and it
belongs mostly to the one nobody had measured. **A curve that varies two things names its cause by
proximity, and proximity is not a measurement.**

**Falsifier, and it is cheap.** Run the same three sizes on a part whose translation reach --
located the way the paired sweep locates it, rather than read off a datasheet -- extends past 8 MiB
of small pages, or with 1 GiB pages, where 32 MiB needs one translation. If the 8 MiB step survives,
it is not translation and this movement is wrong. Equally: on any board, the elder step should
appear above that board's own measured second knee and not below it. If the two came apart, the
mechanism named here is not the one operating. **Confidence: high** that the 8 MiB step on this board is majority
translation, since it is removed by changing only the page size and the removal reproduces across
five pairs. **Confidence: moderate** that the same holds on other parts, which is one board's
reading generalized by a mechanism rather than by a second measurement.

**Where it is gated.** `elder_arm_ran` refuses when either leg is missing its elder readings, or
when the two legs read different sizes -- an arm that quietly did not run prints no attribution and
reads exactly like an arm that ran and found nothing. The magnitudes are **reported and not gated**,
because they belong to this board where the legs above test a property.

**One honest note on the residual above.** The movement before this one reads a 3.88x residual at
4,096 pages surviving huge pages, and calls it the declared L2 and L3 confound. Counted directly
from the layout arithmetic while this arm was being built: the spread layout places node `i` at
`i * 4096 + (i * 64 mod 4096)`, which makes the within-page offset a function of `i mod 64` -- the
same `i` that supplies the page-index bits -- so its cache-set index reaches **64 of this board's
1,024 L2 sets, at every size**, capping effective L2 capacity at 32 KiB. The residual is therefore
set conflict rather than capacity. This changes nothing the paper claims: the exact claim was
already bounded at 512 nodes, where the touched bytes fit L1d in both layouts and the parity
assertion holds. It names the mechanism of a residual the paper had honestly declared and not
explained.

## What it means for a table

**Span and size are different quantities, and only one of them appears in `@sizeOf`.**

For a **single contiguous allocation**, the elder bound binds first and this one never fires: 32 KiB
of L1d spans 8 pages, comfortably inside 64. A designer who allocates one array and indexes into it
can read the elder paper alone and be right.

**This bound bites when a structure arrives in pieces.** Measured budgets from the census, at the
64-page reach this board reports:

| Entry size | Entries within a 256 KiB span |
|---|---|
| 4 bytes | 65,536 |
| 8 bytes | 32,768 |
| 16 bytes | 16,384 |
| 64 bytes | 4,096 |

*Inference, high confidence:* 720 entries of 8 bytes in one array occupy 2 pages and pay nothing.
The same 720 entries handed out one at a time by a general allocator, landing on 720 distinct pages,
span 11x the reach and pay 2.4x on every lookup -- while `@sizeOf` reports 5,760 bytes either way,
and the elder paper's bound says both are free.

**So the design rule this measurement supports is one Tally already holds for other reasons:** a hot
lookup structure is one bounded allocation rather than a graph of small nodes. What is new is the
number attached to it. *Confidence: high for the mechanism, moderate for the magnitude on other
parts, since reach is a property of the part.*

## The deflation, which belongs in the paper that found the effect

**At the scale this tree actually runs, the new bound is inert, and saying so is the point.** A
ring's revocation table at 720 points is 5,760 bytes: **2 pages** contiguous, against a reach of 64.
The ladder's is 312 bytes: **1 page**. A contiguous revocation table would need to reach **32,768
points** before it spanned 64 pages, which is 45x the whole sky.

**So the effect is real in mechanism and absent at our scale, exactly as its elder was.** What
survives the deflation is the *shape* rather than the threshold: the hazard is fragmentation, not
growth, and fragmentation arrives at any size. A 720-entry table allocated node by node is over the
reach on the day it is written.

## What BAKERY can build from this

**One buildable, small.** A `comptime` assertion beside the elder footprint one, asserting that a
hot lookup structure is a single array rather than a pointer graph -- checkable in Zig's type
system, since `[N]T` and `[]T` into one allocation are distinguishable from a structure of pointers
at compile time. Cost: one declaration per table. This is the half worth taking.

**One number, portable.** 64 pages, 256 KiB of span, on this board. A different part answers
differently, and `tlb_reach_census.sh` answers in about two minutes on any Linux board with a
vendored toolchain -- so the number travels as a *measurement anyone can retake*, never as a
constant to copy.

**One thing that stays research.** Whether translation cost shows up in a power budget stays
unmeasured, for the same reason the elder paper gave: this board exposes no energy counter. The
mechanism is suggestive -- a page walk is additional memory traffic -- and suggestion is where it
stops.

## What would kill this

**The controlled pair is wrong.** If the two layouts differ in some way beyond page count that the
set-parity check misses, the step measures that instead. *Falsifier:* the huge-page leg, already
run -- an unmodelled difference would survive a change of page size, and this one did not.

**The step is a prefetcher artifact.** *Falsifier:* the walk is a random single cycle whose length
is asserted equal to the node count before timing, so no stride exists to predict. A reader who
doubts it can plant a constant stride and watch the curve flatten.

**The board is lying about huge pages.** *Falsifier:* `/proc/self/smaps_rollup` is read after the
walks rather than before, and the census refuses at zero.

**The knee is noise.** *Falsifier:* re-run the census, which takes about two minutes. Five runs on
`20260906` placed the boundary at the same page count every time, with the step between 2.17x and
2.38x against a below-knee spread of at most 6 percent.

**The reach generalizes.** It does not, and this paper claims otherwise nowhere: 64 pages is this
part's answer. *Falsifier for anyone tempted:* run the census on a second part and read a different
number.

## What this does not reach

**Energy**, for want of a counter. **Instruction-side translation**, which this probe never
stresses. **Whether a real routing lookup has this access pattern** -- the probe measures a
dependent chase because that is the shape of a lookup whose next address depends on the current
one, and a real router doing several independent lookups at once would overlap some of this cost.
**And the second boundary's true capacity**, which this instrument bounds from below and leaves
there.

The measurement stands where it was taken: one board, one day, seven legs that can refuse, and a
falsifier that ran.
