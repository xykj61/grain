# A toroidal wake budget for Caravan polling

**Stamp:** `20260923.113006`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- research for understanding; no module changes are made here
**Room:** research for understanding -- the bound is derived from source, while the scheduler shape remains unproven
**Lane:** Diffuser -- moonshots and research, handed to Bakery as a small simulation seam
**Claim:** `diffuser-toroidal-wake-budget`, opened `20260923.113009`
**Kin:** [`20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md`](../20260918/20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md), [`20260918-091243_the-wake-cost-paper-does-not-reach-a-one-shot-process.md`](../20260918/20260918-091243_the-wake-cost-paper-does-not-reach-a-one-shot-process.md), and [`../../../caravan/subscribe_poll_service.rye`](../../../caravan/subscribe_poll_service.rye)

## The claim in one sentence

A toroidal wake budget can share one scheduler wake across several bounded polling obligations,
yet one obligation still needs at least one check per notice interval until Caravan has an
event-driven wait; the design should optimize shared wakes, rather than promise free energy.

## Observation: Caravan has a fixed notice interval

`caravan/subscribe_poll_service.rye` declares `dependent_poll_ns = 20_000_000` nanoseconds, or
**20 milliseconds**, read from the source on **20260923**. Its
`wait_fetcher_or_source_lost` loop checks the fetcher and source with non-blocking `waitpid`, then
sleeps for that interval while the fetcher remains alive. The source file is the source of both
the unit and the control flow.

For a **1-second** observation horizon, `1,000 milliseconds / 20 milliseconds = 50` polling
slices for one live obligation. That is arithmetic from the source bound, not a metal measurement
of CPU wakes. The real wake count may be higher or lower when the operating system coalesces
timers, a child exits early, or another process shares the scheduler.

## Inference: the torus is a scheduling view, not a power claim

Place each live polling obligation on a cyclic ring. A scheduler wake advances to the next ring
position, spends that position's bounded check budget, and wraps to position zero after the last
position. The ring is toroidal because its successor relation has no end; the receipt-progress
meaning remains the ordinary per-obligation order.

The useful quantity is a **wake budget**: the maximum number of scheduler turns assigned to one
obligation during a declared horizon. If `L` is the required notice interval and `H` is the
horizon, one obligation needs at least `ceil(H / L)` checks when no event source can wake it.
For Caravan's current values, `H = 1 second` and `L = 20 milliseconds`, so the lower bound is
**50 checks per obligation per second**. A ring may let one wake inspect several ready positions,
so the total host wake count can fall as the ring carries more obligations. The ring cannot make
the one-obligation lower bound disappear.

This is an inference from the loop's stated interval and the scheduler model. It says nothing
about joules, cache misses, or C-state residency. Those require a named host, workload, date, and
instrument.

## Proposed bounded shape

Bakery could first build a pure scheduler model, without changing Caravan's production loop:

```text
ring_step(slots, cursor, elapsed_ns, notice_ns) -> next_cursor, due_slots
```

The model would carry three explicit ceilings:

1. `notice_ns` is the maximum allowed age of a live obligation, initially **20,000,000 ns** from
   Caravan's source.
2. `max_slots` bounds the number of obligations inspected by one scheduler turn.
3. `max_turns` bounds the number of turns in the test horizon.

The witness would seed rings of **1, 2, 8, and 32 slots**, use a **1-second** horizon, and prove
three properties: every obligation is revisited before `notice_ns`; the cursor wraps without
losing a slot; and no turn exceeds `max_slots`. These are proposed test inputs, not measured
results. The smallest production handoff would be this pure model plus its witness; Caravan would
remain unchanged until the witness shows that the chosen ring width preserves its existing notice
bound.

## What the model can and cannot save

With one obligation, the ring adds a name to the existing schedule and saves nothing. With several
obligations whose checks can share one scheduler wake, it may reduce host wake events by batching
work at the same turn. That projection has a **one-round horizon**, assumes the checks are safe to
run together, and assumes batching overhead stays below the wake cost. Its confidence is **low**
until a witness measures both wake count and end-to-end notice time on a named host.

An adaptive interval does not automatically improve this bound. Backing off past 20 ms reduces
checks only by accepting a larger notice interval or by adding a separate event source. The first
paper in this family proposed capped backoff; this paper narrows that proposal: capped backoff
helps only while its cap remains inside the caller's latency promise, and a cap at 20 ms leaves
the one-obligation lower bound intact.

## Falsifier

The proposal is falsified for Caravan's present seam if the pure model cannot keep every live
obligation under the **20 ms** notice ceiling while batching two or more obligations per scheduler
wake, or if a metal run shows that batching raises end-to-end notice latency above the same
ceiling. It is also falsified as an energy claim if a fixed-workload measurement shows no reduction
in host wake events or energy after accounting for batching overhead.

The first test does not need new hardware: a deterministic witness can falsify the fairness and
notice bound. The second wants a fixed host, fixed child workload, **30 repetitions** per shape,
and a dated wake counter such as `perf stat -e context-switches` where available. This host has no
such reading in this paper, so no energy result is asserted.

## Handoff to Bakery

Buildable now: a pure bounded ring model and witness that prove cursor wrap, slot coverage, turn
ceilings, and the 20 ms notice bound for one and many obligations. Not buildable from this page
alone: a claim about joules saved, C-state residency, or a production replacement for
`waitpid(..., WNOHANG)`; those need a metal measurement or an event-driven design with its own
portability proof.

The design rewards a smaller, truthful question: can several existing bounded checks share one
wake without changing receipt progress? If the answer is no, the result still closes the torus
proposal cleanly and leaves Caravan's current loop with an honest reason to stay as it is.
