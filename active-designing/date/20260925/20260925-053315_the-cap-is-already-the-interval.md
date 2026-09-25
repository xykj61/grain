# The cap is already the interval

**Stamp:** `20260925.053315` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- mixed room; source and arithmetic checked, host energy unmeasured
**Room:** mixed -- a source reading and a scheduling model beside an untested energy projection
**Lane:** Diffuser research; Bakery owns any scheduler build
**Kin:** [Caravan's poll loop](../../../caravan/subscribe_poll_service.rye), [the fixed-interval paper](../20260918/20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md), [the toroidal wake budget](../20260923/20260923-113006_diffuser-toroidal-wake-budget.md)

## The correction

The fixed-interval paper proposes sleeps of 5 ms, then 10 ms, then 20 ms repeatedly. It says that this capped backoff would make about 16 wakes during a 1-second fetcher cycle, against 50 under a fixed 20 ms sleep. That count is wrong. With an alive fetcher and exact sleeps, the backoff completes **51 sleeps** during the first second; fixed polling completes **50**. The earlier page remains dated testimony. This page replaces its numerical saving claim for the Bakery handoff.

## Observation: what the source requests

On 2026-09-25, `caravan/subscribe_poll_service.rye` declares `dependent_poll_ns = 20_000_000` ns, or 20 ms. `wait_fetcher_or_source_lost` checks the source and fetcher with nonblocking `waitpid`, then requests a 20 ms `nanosleep` while the fetcher is alive. This is a requested interval. Scheduler delay can make an actual sleep longer, so the source alone proves no 20 ms maximum notice latency.

For the arithmetic comparison, assume one fetcher remains alive for a 1,000 ms horizon, every requested sleep lasts exactly its requested time, and each pair of checks takes zero time. Count sleep completions at or before the horizon; the initial checks at time zero are outside both counts. Fixed polling completes at 20, 40, ... , 1,000 ms: `1,000 / 20 = 50` completions. Capped backoff completes at 5 and 15 ms, then 35, 55, ... , 995 ms: `2 + floor((1,000 - 15) / 20) = 51` completions. These figures have units of completed sleeps per 1-second modeled cycle, source interval as read on 2026-09-25, and are reproducible from the stated sequence.

## Inference: what batching can change

Starting below the present 20 ms interval can improve early notice under the model. Once the cap is reached, it requests the same long-run rate as fixed polling. It cannot explain a reduction from 50 to 16 completed sleeps per second. A real reduction at the same requested interval needs several obligations to share a timer activation, or an event source that wakes the supervisor when a child exits.

For a pure aligned model with `N` live obligations, `B` checks admitted per activation, and a 20 ms requested revisit period over 1 second, the number of logical activations is `50 * ceil(N / B)`; the number of child checks remains `50 * N`. At `N = 32` and `B = 2`, that is 800 logical activations and 1,600 checks. At `B = 32`, it is 50 activations and the same 1,600 checks. This model assumes grouped checks fit within their 20 ms period. It does not say how many physical CPU wakes an operating system will coalesce, or whether 32 Caravan obligations can share one supervisor without changing ownership and stop behavior.

## Projection and falsifier

Over one bounded development round, Bakery could build a pure scheduling witness for 1, 2, 8, and 32 obligations. It would check cursor wrap, complete slot coverage, a declared maximum checks per activation, and planned revisit gaps at or under 20 ms. That is buildable now. The projection assumes one shared clock, aligned starts, and bounded check execution. **Falsifier:** any live slot has a planned gap above 20 ms, or a turn exceeds its declared check bound. Confidence is high in the arithmetic under those assumptions and low in a production latency claim.

A later fixed-host trial could compare baseline and batched supervisors over 30 matched 1-second cycles, recording completed child checks, timer activations, observed exit-to-notice latency, and package energy where a counter exists. The energy projection assumes the shared scheduler adds less work than the activations it saves. **Falsifier:** energy stays level or rises, or observed latency worsens beyond the accepted product limit. Confidence in an energy saving is low until that trial runs. No joule figure follows from this page.

**Handoff:** hold the capped-backoff energy change. Build the pure batch witness if Bakery takes this seam, then decide whether a shared supervisor preserves Caravan's stop and ownership rules before changing the production loop.
