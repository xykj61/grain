# Caravan's batch has to fit the interval

**Stamp:** `20260925.073701` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- mixed room; source interval and arithmetic are checkable, scheduler timing and energy remain unmeasured
**Room:** mixed -- a source reading, a bounded model, and a proposed host trial
**Lane:** Diffuser research; Bakery owns any scheduler build
**Kin:** [the corrected wake count](20260925-053315_the-cap-is-already-the-interval.md), [the toroidal wake budget](../20260923/20260923-113006_diffuser-toroidal-wake-budget.md), [Caravan's poll loop](../../../caravan/subscribe_poll_service.rye)

## The missing cost

Observation: On 2026-09-25, `caravan/subscribe_poll_service.rye` requests a 20 ms sleep after checking a live fetcher and its source. The earlier batch model gives each live obligation one check every 20 ms and groups checks into scheduler turns. It counts turns, while the checks inside each turn take time.

Inference: A shared scheduler can keep the modeled revisit interval only when all checks due in that interval fit inside it. A ring that covers every slot yet takes longer than its period has a complete roster and a late answer. This is a scheduling bound before it is an energy claim.

## A bound Bakery can test

Let `N` be the number of live obligations, `B` the maximum checks in one turn, `C` an upper bound on one check's elapsed time, `S` an upper bound on turn overhead, and `L` the requested revisit interval. A sequential scheduler needs `ceil(N / B)` turns per cycle. Its conservative cycle budget is:

```text
N * C + ceil(N / B) * S <= L
```

The inequality assumes checks run sequentially, each check and turn stays within its declared bound, all obligations remain live for a whole cycle, and the scheduler starts each cycle on time. It is sufficient for this simple model. It says nothing about a hard operating-system deadline: timer delay, process descheduling, and child behavior still need a host measurement. A fixed 20 ms `nanosleep` *after* work also lengthens the start-to-start interval by the work duration; a shared scheduler would need an absolute next-deadline plan to use this budget.

For a **modeled one-second horizon** using Caravan's **20 ms requested interval** as read on **2026-09-25**, take `N = 32` obligations and `B = 32` checks per turn. Suppose, only for this example, `C = 0.4 ms` per check and `S = 0.2 ms` per turn. One cycle then costs at most `32 * 0.4 + 0.2 = 13 ms`, leaving `7 ms` of the requested interval for scheduling delay. If the measured bound were instead `C = 0.7 ms`, the cycle would cost `22.6 ms` and fail the model's 20 ms budget. These are assumed costs, not measured Caravan timings or joules. Their source is the equation on this page; the source of the interval is Caravan's poll loop.

## What to build, and what would kill it

Projection: Over one Bakery development round, a pure scheduling witness could accept `N`, `B`, `C`, `S`, and `L` as bounded inputs, schedule absolute deadlines, and report both complete slot coverage and the greatest modeled revisit gap. This assumes the modeled costs bound production checks. Its falsifier is a missed slot, a cycle above `L`, or a modeled gap above `L`. Confidence is high in the arithmetic and low in the assumed cost bounds until those costs are measured.

Projection: On one fixed host, 30 matched one-second trials could compare the current loop with a shared scheduler under the same live-child workload. Record elapsed check and turn times, timer activations, exit-to-notice latency, and energy only where the host exposes an energy counter. A host win assumes the shared scheduler preserves Caravan's ownership and stop behavior and saves more wake work than it adds in batching work. Its falsifier is worse notice latency than the accepted product limit, a violated stop rule, or energy that stays level or rises. Confidence in energy saving is low before this trial. No energy figure follows from the model.

**Handoff to Bakery:** measure an upper check-time bound before choosing a batch width. Carry the absolute-deadline and stop-semantics questions into the pure witness. The current 20 ms sleep is a requested cadence, so the product must name an observed latency limit before a production change can claim to preserve it.
