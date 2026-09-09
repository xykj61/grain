# The Answer That Holds Only Its Own Hits

**Stamp:** `20260909.171151`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Landed, **checkable** -- every figure below is bound by a witness landing in this same
commit ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)); the projection section says so at its
own head
**Instrument:** [`../tools/q/query_wire_retention_witness.rish`](../tools/q/query_wire_retention_witness.rish)
over [`../comlink/query_wire_retention_cost.rye`](../comlink/query_wire_retention_cost.rye),
[`../tools/fixtures/q/query_wire_varlen_sweep.sh`](../tools/fixtures/q/query_wire_varlen_sweep.sh)
and [`../tools/fixtures/q/query_wire_retention_control.sh`](../tools/fixtures/q/query_wire_retention_control.sh)
**Kin:** [`what a kept answer costs per read`](20260909-152110_what-a-kept-answer-costs-per-read.md) -
[`a retained reply needs its own bytes`](20260909-072836_a-retained-reply-needs-its-own-bytes.md) -
[`a kept answer has its own budget`](../active-designing/20260909-084736_a-kept-answer-has-its-own-budget.md)

---

## The falsifier this runs

Yesterday's paper measured what a caller pays to keep a decoded `QueryWireResponse` beside the
payload it came from, and found the price lopsided by answer size: the decoded struct costs **456
bytes** whatever the answer holds, because it carries a fixed `[max_wire_hits]QueryWireHit` array,
while decoding again costs about 45 instructions per hit. So a caller holding small answers paid the
full cache for a fraction of its benefit -- a **7.3x** swing in value across the format's own size
range.

That paper closed on a projection, and projections in this tree carry a falsifier. Its was:

> a variable-length decoded form measured on this harness whose cache bytes for a one-hit answer
> still exceed roughly a quarter of the fixed form's 456. That would place the cost in the per-hit
> representation rather than in the array.

This paper builds that form and runs it. **The falsifier held**: the variable form's one-hit cache
reads **72 bytes** against a threshold of 114.

## What the third shape is

`comlink/query_wire_retention_cost.rye` now measures three shapes over one answer rather than two:

- **keep bytes** -- hold the payload, decode on every read.
- **keep both** -- hold the payload and the fixed `QueryWireResponse`, read fields directly.
- **keep varied** -- hold the payload and a `KeptAnswer`, whose single field is a
  `[]const QueryWireHit` slice covering exactly the hits the answer carries.

The retained-byte figure for the third shape is `@sizeOf(KeptAnswer)` plus the live hits: **16 bytes
of header and 56 bytes per hit**, both read off the binary by the harness rather than typed into it.
That is the same instrument the 456 came from, so the two figures compare.

`tools/fixtures/q/query_wire_varlen_sweep.sh` varies the answer size in a pen -- the harness holds
its size at a comptime constant so two runs on one host compare, and the sweep rewrites that
constant in a copy while leaving the tree's own harness at four hits. So the elder paper's row still
reproduces from an unedited checkout.

## The reading

Observation, on this pier: a Vultr instance under a Microsoft hypervisor, AMD EPYC-Rome, 8 visible
cores, Linux 6.18.41, `-OReleaseFast`, read `20260909.171151`. Median of seventeen samples of twenty
thousand reads each, the three workloads alternating sample by sample.

| Hits | Payload | Fixed bytes | Varied bytes | Decode per read | Fixed per read | Varied per read |
|---|---|---|---|---|---|---|
| 1 | 33 | 456 | **72** | 52 | 0 | 0 |
| 2 | 64 | 456 | **128** | 95 | 3 | 3 |
| 4 | 126 | 456 | **240** | 181 | 3 | 3 |
| 8 | 250 | 456 | **464** | 385 | 3 | 3 |

*The one-hit row's per-read figures are an elimination rather than a reading:* at a single hit the
rotating index degenerates to a constant and both cached loops hoist, exactly as the control
demonstrates. Its byte figures stand, and the byte figures are what the falsifier reads.

**Observation: the slice costs nothing per read.** Varied and fixed both retire **3 instructions**
per read at two, four, and eight hits. An index through a slice loads a pointer where an index into
an inline array is an offset from a known base, and at this optimization level that difference does
not survive into the count.

**Inference: the array was the whole of the price.** The variable form's bytes track the answer at
56 per hit over a 16-byte header, and the fixed form's do not move at all.

## The swing, closed

Read as instructions saved per read per byte retained -- the exchange rate the elder paper named:

| Hits | Fixed form | Varied form |
|---|---|---|
| 1 | 0.11 | 0.72 |
| 2 | 0.20 | 0.72 |
| 4 | 0.39 | 0.74 |
| 8 | 0.84 | 0.82 |

**Inference: the variable form makes the rate nearly flat.** Across the format's whole size range the
fixed form's value swings **7.3x** and the varied form's **1.15x**. A caller choosing *keep both*
under the variable form gets roughly the same value whatever its answers look like, which is what
makes it a safe default rather than a judgment call needing answer-size data nobody has.

## The finding nobody projected

**At eight hits the variable form costs 464 bytes -- eight MORE than the fixed 456.** The header is
pure overhead once the answer fills the format's ceiling, and the crossover follows from the two
sizes the harness prints: `16 + 56n < 456` holds for `n <= 7` and fails at 8.

So the variable form is a win on bytes for **seven of the eight answer sizes this format admits**,
and a small loss for the eighth. That is a better trade than the elder projection claimed, and it is
not a clean sweep -- worth saying plainly, since a form that always wins invites nobody to check.

## What it costs that a counter cannot read

**A second lifetime.** The fixed form is one inline struct; the variable form is a header pointing at
a hits array the caller must keep alive exactly as long as the answer. That is the same discipline
the `run_client_query` red taught this arc one paper earlier -- a returned reply owning no bytes --
and it is the honest price of the 216 bytes saved at four hits.

**A third thing to get wrong.** The payload must outlive the answer because the hit text points into
it; the hits array must outlive the answer too. Two lifetimes rather than one, held by a caller
rather than by a type.

## What this does not reach

**Joules.** This pier answers `tier=counters` with no readable energy counter, per
[`the tier a joule is measured at`](20260908-234506_the-tier-a-joule-is-measured-at.md). Every figure
above is retired instructions.

**Elapsed time and cache behavior.** A form touching 240 bytes of cache line rather than 456 should
fare better under memory pressure, and this harness cannot say so: it counts work, and a miss costs
wall time no instruction count sees. That reading wants a different instrument.

**Real answer sizes.** The table spans the format's range evenly, which no workload does. Whether
this tree's callers return one hit or eight remains uncounted.

**One host, one backend, one afternoon.**

## Projection

**This section is projection, and nothing in it is bound by the witness.**

*Horizon:* the next Comlink caller that retains a query answer, and any Caravan or Mantra path that
holds many of them at once.

*Assumptions:* answers stay bounded by `max_wire_hits`; the caller reads hits rather than one field
of one hit; the retained hits array is allocated at the answer's own size.

*Claim:* a bounded answer pool built on the variable form holds roughly **1.9x** the answers of one
built on the fixed form, at the four-hit size this arc has measured throughout, with no measurable
per-read cost.

*Falsifier:* a pool measured on real answer sizes whose mean hit count reads 7 or above. There the
variable form's header makes it the more expensive shape, and the pool should stay fixed. The same
command settles the per-size half: `rishi/bin/rishi run tools/q/query_wire_retention_witness.rish`.

*Confidence:* high on the byte figures, which are arithmetic over two sizes the binary prints; high
on the per-read parity, which three sizes read identically with a spread of one instruction;
moderate on the pool ratio, which assumes an answer-size distribution nobody has counted.

## For BAKERY

**Buildable now:** the sweep takes any size list through `SWEEP_SIZES` and any build mode through
`SWEEP_MODE`, so pointing it at a shape you are weighing costs one command and no source change.

**Worth a lap:** count a real caller's hit distribution. Both papers in this arc now end at the same
missing number, and the budget seam `a + r <= H` cannot be sized honestly without it.

**Waiting on a better rung:** any claim that either form saves watts, and any claim about cache
misses. The first wants a host answering `tier=joules`; the second wants a cycle and miss counter
beside the instruction one, which this harness could open on the same descriptor.

---

*May every answer hold just what it carries, and may the caller who keeps it know both lifetimes by
name.*
