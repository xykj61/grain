# What a Kept Answer Costs Per Read

**Stamp:** `20260909.152110`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Landed, **checkable** -- every figure below is bound by a witness landing in this same
commit ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)); the projection section says so at its
own head
**Instrument:** [`../tools/q/query_wire_retention_witness.rish`](../tools/q/query_wire_retention_witness.rish)
over [`../comlink/query_wire_retention_cost.rye`](../comlink/query_wire_retention_cost.rye) and
[`../tools/fixtures/q/query_wire_retention_control.sh`](../tools/fixtures/q/query_wire_retention_control.sh)
**Kin:** [`a retained reply needs its own bytes`](20260909-072836_a-retained-reply-needs-its-own-bytes.md) -
[`a kept answer has its own budget`](../active-designing/20260909-084736_a-kept-answer-has-its-own-budget.md) -
[`the tier a joule is measured at`](20260908-234506_the-tier-a-joule-is-measured-at.md)

---

## The question this closes

Two papers stand behind this one. The first proved that a decoded `QueryWireResponse` **borrows**
its text from the payload it was decoded from, so a caller keeping the answer keeps those bytes.
The second gave a retained answer its own reservation in a bounded budget. Both left one sentence
unmeasured, and it appeared in the live card twice in one day: *elapsed time and energy remain
unmeasured.*

The design question underneath it is small and sharp. Having kept the payload, should a caller
**also** keep the decoded struct beside it, or decode again on every read? One shape spends memory
once. The other spends instructions per read. Nothing in the arc said what the exchange rate was.

This paper reads it off a counter.

## How it was measured

[`comlink/query_wire_retention_cost.rye`](../comlink/query_wire_retention_cost.rye) opens a
self-scoped retired-instruction counter through `perf_event_open` with pid 0, which needs no root
and no `perf` binary -- the shape proven by
[`tools/rye/perf_self_count.rye`](../tools/rye/perf_self_count.rye). It builds one concrete answer,
encodes it to wire bytes, and then runs two workloads:

- **keep bytes** -- hold the payload; `decode_response` on every read, then read one field.
- **keep both** -- hold the payload and the decoded struct; read the same field directly.

The two alternate sample by sample, so a host drifting warmer or busier during the run moves both
readings together rather than one of them. Each publishes the **median of seventeen samples**, an
odd count, so the figure is a reading that happened rather than an average of two.

**Both loops read a rotating hit index, and that detail is the measurement.** A first draft read one
fixed hit, which made the cached loop's body loop-invariant: under `-OReleaseFast` the whole
twenty-thousand-read loop compiled to **six instructions**, and the harness published a saving that
was really an elimination.
[`tools/fixtures/q/query_wire_retention_control.sh`](../tools/fixtures/q/query_wire_retention_control.sh)
plants that fault back into a copy of the harness and requires the planted copy to collapse -- a
defense shown only from the passing side cannot be told from a coincidence. It passes five checks.

## The reading

Observation, on this pier: a Vultr instance under a Microsoft hypervisor, AMD EPYC-Rome, 8 visible
cores, Linux 6.18.41, read `20260909.152110`. One answer of four hits: **126 payload bytes**, and
`@sizeOf(QueryWireResponse)` = **456 bytes** for the decoded struct beside it. Instructions retired
per read, median of seventeen samples of twenty thousand reads each:

| Build mode | keep bytes | keep both | saved per read | spread, keep bytes |
|---|---|---|---|---|
| `Debug` | 1,806 | 105 | 1,701 | 6 |
| `ReleaseSafe` | 394 | 14 | 380 | 1 |
| `ReleaseFast` | 181 | 3 | 178 | 2 |

The spread is the whole range across seventeen samples of twenty thousand reads -- **two
instructions**, at `ReleaseFast`, over 3.6 million counted. This run is stable enough to publish.

**Inference: optimization shrinks the prize and raises the ratio.** The absolute saving falls
1,701 -> 380 -> 178 as the mode rises, while the ratio between the two shapes grows 17x -> 28x ->
60x. A reader who measures in `Debug` and reasons about a shipped binary will overstate what caching
buys by roughly tenfold, and understate how lopsided the two shapes are.

## The exchange rate depends on the answer's size, and only on one side

Observation, same host and mode (`ReleaseFast`), varying the answer:

| Hits | Payload bytes | Cache bytes | keep bytes | keep both | saved per read |
|---|---|---|---|---|---|
| 1 | 33 | 456 | 52 | 0 | 52 |
| 2 | 64 | 456 | 95 | 3 | 92 |
| 4 | 126 | 456 | 181 | 3 | 178 |
| 8 | 250 | 456 | 385 | 3 | 382 |

*The one-hit row's `keep both` figure is an elimination rather than a reading:* at a single hit the
rotating index degenerates to a constant and the loop hoists, exactly as the control demonstrates.
Its saving is therefore an upper bound, and the three rows below it are readings.

**Inference: decoding is linear in hits; the cache is constant.** The decode cost fits about 45
instructions per hit over an 8-instruction floor. The cache costs 456 bytes whatever the answer
holds, because `QueryWireResponse` carries a fixed `[max_wire_hits]QueryWireHit` array.

So the exchange rate, in instructions saved per read per byte of cache held, runs **0.11 at one hit
to 0.84 at eight** -- a **7.3x** swing driven entirely by the fixed-size array. A caller whose
answers are mostly small pays the full price of the cache for a fraction of its benefit, and nothing
in the caller's own code says so.

## What this means for the answer budget

The budget model reserves **one answer slot per admitted request**. This reading says a slot has two
possible prices, and the caller chooses which to pay:

- **keep bytes:** 126 bytes for this answer, and 181 instructions on every read.
- **keep both:** 582 bytes -- 4.6x the payload -- and 3 instructions on every read.

Neither is the right default for every caller, which is the finding. A caller reading an answer once
should keep bytes; a caller reading it hundreds of times should keep both; and a caller holding many
**small** answers should keep bytes almost regardless of read count, since the fixed array makes the
cache poor value there.

## What this does not reach

**Joules.** This is a **work** measurement, and this pier answers `tier=counters` with no readable
energy counter, per
[`the tier a joule is measured at`](20260908-234506_the-tier-a-joule-is-measured-at.md). An
instruction retired is not a joule spent, and the two are related by a factor this host cannot show
us. Every figure above is instructions.

**Elapsed time.** The counter reads work, and a cache miss costs wall time the instruction count
never sees. The `keep both` shape touches 456 bytes of cache line where `keep bytes` touches 126,
and a run under memory pressure could reverse the comfortable reading above.

**Other microarchitectures.** One host, one compiler backend, one afternoon.

**Concurrency, lifetime, and cleanup.** The harness runs one thread over an answer nobody frees.

## Projection

**This section is projection, and nothing in it is bound by the witness.**

*Horizon:* the next Caravan or Mantra caller that retains a query answer.

*Assumptions:* the answer shape stays the length-prefixed `QueryWireResponse` this codec writes;
the caller reads whole hits rather than a single field of one.

*Claim:* replacing the fixed `[max_wire_hits]QueryWireHit` array with a hit count and a bounded
variable region would make the cache's price proportional to the answer, closing most of the 7.3x
swing above and making **keep both** the safe default rather than a judgment call.

*Falsifier:* a variable-length decoded form measured on this harness whose cache bytes for a
one-hit answer still exceed roughly a quarter of the fixed form's 456. That would place the cost in
the per-hit representation rather than in the array, and the same command settles it:
`rishi/bin/rishi run tools/q/query_wire_retention_witness.rish`.

*Confidence:* high that the array dominates the cache size, since `8 x 56 = 448` of the 456 bytes
are the array; moderate that a variable form is worth its complexity, since that trade wants a
caller with real answer-size data and this tree has none yet.

## For BAKERY

**Buildable now:** the harness takes any two bounded workloads over one answer. Pointing it at the
`run_client_query` review already on the card would give that review a number rather than a
judgment, in one sitting, with no host change.

**Worth a lap:** measure a real caller's answer-size distribution before anyone reshapes
`QueryWireResponse`. The 7.3x swing above only matters if small answers are common, and nobody has
counted.

**Waiting on a better rung:** any claim that either shape saves energy in watts. That wants a host
answering `tier=joules`, and the energy instrument announces the day it arrives.

---

*May every kept answer know what it costs, and may the caller who keeps it choose with a number in
hand.*
