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
position. The ring is toroidal because its successor relation wraps; the receipt-progress meaning
remains the ordinary per-obligation order.

The useful quantity is a **wake budget**: the maximum number of scheduler turns assigned to one
obligation during a declared horizon. If `L` is the required notice interval and `H` is the
horizon, one obligation needs at least `ceil(H / L)` checks before an event source can wake it.
For Caravan's current values, `H = 1 second` and `L = 20 milliseconds`, so the lower bound is
**50 checks per obligation per second**. A ring may let one wake inspect several ready positions,
so the total host wake count can fall as the ring carries more obligations. The one-obligation
lower bound remains.

This is an inference from the loop's stated interval and the scheduler model. Joules, cache misses,
and C-state residency require a named host, workload, date, and instrument.

## Proposed bounded shape

Bakery could first build a pure scheduler model while Caravan's production loop stays unchanged:

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
losing a slot; and no turn exceeds `max_slots`. These are proposed test inputs awaiting a measured
witness result. The smallest production handoff would be this pure model plus its witness; Caravan would
remain unchanged until the witness shows that the chosen ring width preserves its existing notice
bound.

## What the model can and cannot save

With one obligation, the ring adds a name to the existing schedule and saves zero turns. With several
obligations whose checks can share one scheduler wake, it may reduce host wake events by batching
work at the same turn. That projection has a **one-round horizon**, assumes the checks are safe to
run together, and assumes batching overhead stays below the wake cost. Its confidence is **low**
until a witness measures both wake count and end-to-end notice time on a named host.

An adaptive interval improves this bound only when its cap preserves the caller's latency promise.
Backing off past 20 ms reduces
checks only by accepting a larger notice interval or by adding a separate event source. The first
paper in this family proposed capped backoff; this paper narrows that proposal: capped backoff
helps only while its cap remains inside the caller's latency promise, and a cap at 20 ms leaves
the one-obligation lower bound intact.

## Falsifier

The proposal is falsified for Caravan's present seam if the pure model misses the **20 ms** notice
ceiling while batching two or more obligations per scheduler wake, or if a metal run shows that
batching raises end-to-end notice latency above the same ceiling. It is also falsified as an energy
claim if a fixed-workload measurement shows stable or higher host wake events or energy after
accounting for batching overhead.

The first test runs on current hardware: a deterministic witness can falsify the fairness and
notice bound. The second wants a fixed host, fixed child workload, **30 repetitions** per shape,
and a dated wake counter such as `perf stat -e context-switches` where available. This paper leaves
the energy reading for that metal follow-up.

## Handoff to Bakery

## Deterministic model reading

**Observation, measured 20260924:** a one-second arithmetic run with a **20 ms** notice bound
requires **50 checks per obligation**. With a `max_slots` ceiling of **2**, the model visits all
slots on schedule for rings of **1, 2, 8, and 32** slots and takes **50, 50, 200, and 800
batched turns**, respectively. The transcript is
`session-output/toroidal-wake-budget-20260924.txt`; the source interval is
`caravan/subscribe_poll_service.rye:77`, and the run is arithmetic only.

**Inference:** batching reduces the model's scheduler turns from **50 × slots** to
**50 × ceil(slots / 2)** while preserving the 20 ms revisit bound. The result supports a pure
model seam for Bakery; operating-system wake events, joules, and cache behavior belong to the
metal follow-up.

**Projection:** over a **one-second** horizon, a Bakery witness could test the same four ring
sizes against cursor wrap, full slot coverage, and the 20 ms ceiling. This assumes each grouped
check is safe to run in one turn and that the model's clock is the production notice clock. The
falsifier is a missed slot or a revisit older than 20 ms. Confidence is **medium for the stated
arithmetic and low for host savings** until a named-host measurement exists.

Buildable now: a pure bounded ring model and witness that prove cursor wrap, slot coverage, turn
ceilings, and the 20 ms notice bound for one and many obligations. A claim about joules saved,
C-state residency, or a production replacement for `waitpid(..., WNOHANG)` belongs to a later
metal measurement or an event-driven design with its own portability proof.

The design rewards a smaller, truthful question: can several existing bounded checks share one
wake while receipt progress stays unchanged? If batching fails, the result still closes the torus
proposal cleanly and gives Caravan's current loop an honest reason to stay as it is.
