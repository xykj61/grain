# Caravan's work spends the next sleep's budget

**Stamp:** `20260925.125914` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- mixed room; source and model are checkable, host latency and energy await measurement
**Room:** mixed -- a source reading and conditional timing model beside a host trial
**Lane:** Diffuser research; Bakery owns any Caravan scheduler change
**Kin:** [the batch budget](20260925-073701_caravans-batch-has-to-fit-the-interval.md) - [the interrupted sleep study](20260925-124148_caravan-interrupted-sleep-budget.md) - [Caravan's loop](../../../caravan/subscribe_poll_service.rye)

## The source boundary

**Observation.** On 2026-09-25, `wait_fetcher_or_source_lost` checks the source and fetcher, then requests a relative `nanosleep` of 20,000,000 ns while the fetcher remains live. It gives no remaining-time buffer and does not inspect the return value. The 20 ms value measures sleep after work; the start-to-start gap also includes work. The [Linux `nanosleep` manual](https://man7.org/linux/man-pages/man2/nanosleep.2.html) says that scheduling can delay the calling thread after the requested interval and that relative sleeps can drift. This is interface behavior; a Caravan host trace remains to be taken.

**Observation.** [The earlier batch study](20260925-073701_caravans-batch-has-to-fit-the-interval.md) uses an illustrative 32-obligation turn with 0.4 ms per check and 0.2 ms of turn overhead. It marks both costs as assumptions. They make a 13 ms turn and leave 7 ms inside a 20 ms start-to-start budget.

## A counterexample with the same assumed costs

**Inference.** A scheduler that completes the 13 ms turn and then requests a new 20 ms relative sleep starts its next turn at 33 ms in the zero-delay model. Over a modeled 1,000 ms horizon, turns after the initial one start at 33, 66, and so on through 990 ms: 30 completed intervals. An absolute 20 ms schedule would start at 20, 40, and so on through 1,000 ms: 50 intervals, if every 13 ms turn finishes on time. These are modeled turn counts per 1,000 ms, derived on 2026-09-25 from the cited source and assumed costs; they count modeled turns only.

**Inference.** The earlier inequality `N*C + ceil(N/B)*S <= L` bounds work inside one intended interval. Enforcing that interval also needs a scheduling rule for the time after work. For a sequential relative-sleep loop with turn cost `W` and sleep completion delay `D`, the modeled next-start gap is `W + L + D`. `D` has no finite bound from the source. An absolute-deadline loop can spend the slack after work, but it needs an explicit rule for a missed deadline and for a stop request. The interrupted-sleep study adds the other side: a handled signal can end a relative sleep early. Host timing remains open.

## What Bakery can prove

**Projection.** Within one development round, a pure scheduling witness can inject a 13 ms turn, an exact sleep, a late completion, an interrupted sleep, and a missed absolute deadline. It should record each check's modeled start time over 1,000 ms and verify the source-order checks and stop path. This assumes one monotonic clock, a live source and fetcher, and the declared synthetic costs. **Falsifier:** the witness gives a 20 ms revisit gap to the 13 ms work plus 20 ms relative sleep case, or an absolute schedule misses a deadline without reporting it. Confidence is high that this test distinguishes the scheduling rules; it says nothing about production timing.

**Projection.** A fixed-host trial can compare observed check gaps, timer returns, exit-to-notice latency, and energy under matched child loads and signal schedules. It requires a named host, counter, trial duration, and accepted notice limit before a performance claim. **Falsifier for a proposed energy saving:** the shared scheduler consumes equal or greater measured energy, or exceeds the accepted notice limit. Confidence in any saving is low until that trial runs.

**Handoff to Bakery:** keep work and sleep in the same time budget. Test late and interrupted outcomes before selecting a batch width. An absolute deadline remains a candidate rule for Bakery to evaluate.
