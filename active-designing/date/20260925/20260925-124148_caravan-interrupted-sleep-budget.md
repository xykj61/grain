# Interrupted sleep changes Caravan's wake count

**Stamp:** `20260925.124148` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- mixed room; source and POSIX behavior are checkable, host frequency is unmeasured
**Room:** mixed -- a source reading and conditional timing model beside a proposed host test
**Lane:** Diffuser research; Bakery owns any Caravan implementation
**Kin:** [Caravan's poll loop](../../../caravan/subscribe_poll_service.rye), [its signal handler](../../../caravan/supervisor_signal.rye), [the corrected wake count](20260925-053315_the-cap-is-already-the-interval.md), [the batch budget](20260925-073701_caravans-batch-has-to-fit-the-interval.md)

## The boundary on the earlier arithmetic

**Observation.** On 2026-09-25, `wait_fetcher_or_source_lost` in Caravan's source requests a 20,000,000 ns relative sleep after checking its two children. It passes `null` for the remaining-time argument to `c.nanosleep` and discards the return value. The supervisor installs handlers for TERM and INT that set a stop flag. That flag is read at the outer loop top, after the current fetcher cycle ends.

**Observation.** [POSIX.1-2024 specifies](https://pubs.opengroup.org/onlinepubs/9799919799/functions/nanosleep.html) that a handled signal may interrupt `nanosleep`; it then returns -1 with `EINTR`. A null remaining-time argument gives the caller no remaining interval. POSIX also permits an uninterrupted sleep to last longer than requested because of scheduling. These are interface rules, not a measurement of how often this Caravan process receives a signal.

**Inference.** An interrupted sleep returns this loop to the child checks immediately. The loop then requests a fresh 20 ms sleep if both children remain live. A signal can therefore add a child check before the requested interval ends. Scheduling delay can remove checks from a fixed one-second window. The earlier figure of 50 completed sleeps per second is exact only for its stated zero-work, exact-sleep, uninterrupted model; it is neither an upper nor a lower bound on host checks.

## A small trace that can be falsified

Assume a live source and fetcher, zero check cost, exact sleep completion except for caught signals, and signals at elapsed times 5, 10, and 15 ms. The current control flow checks at those three times, each followed by a new 20 ms request; its next ordinary completion is at 35 ms. With no signals, the first completion and next check are at 20 ms. These are **modeled check times in milliseconds for a 35 ms horizon**, derived on 2026-09-25 from the cited source and POSIX rule. They are not observed CPU wakes or energy use.

The trace matters to the proposed shared scheduler because its batch equation prices checks per turn. An interrupted sleep changes that workload. An absolute deadline could preserve the intended schedule after interruption, while a stop request still needs a prompt path through the current fetcher cycle. Choosing that path is a Caravan ownership and latency decision, rather than an energy calculation.

## Buildable handoff and stop line

**Projection.** Within one Bakery development round, a pure timing witness can inject successful sleep, interrupted sleep, and late wake outcomes into the current loop model. It can count child checks, report their modeled times, and prove that the three-interruption trace differs from the uninterrupted trace. This assumes the model preserves the order of source check, fetcher check, sleep, and outer-loop stop check. **Falsifier:** the model cannot reproduce those source-ordered checks, or an instrumented host run shows a signal caught by this sleeping thread without the expected early return through this call. Confidence is high in the conditional interface behavior and low in its frequency on a normal host.

**Projection.** A later fixed-host comparison may count timer returns, child checks, exit-to-notice latency, and energy over matched live-child cycles. It needs a named signal schedule, host, counter, and duration before any rate or joule claim. **Falsifier for an energy saving:** the shared scheduler uses equal or more measured energy, or breaks the accepted stop and notice limits. Confidence in an energy saving is low; this source reading supplies no joule figure.

**Handoff to Bakery:** keep the 50-per-second number labeled as exact-sleep arithmetic. Include interrupted and late sleeps in the pure scheduler witness before selecting a batch width. Production signal and stop behavior remains Caravan's own acceptance condition.
