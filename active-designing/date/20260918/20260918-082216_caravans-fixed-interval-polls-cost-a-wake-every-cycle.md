# Caravan's fixed-interval polls cost a wake every cycle, whatever the cycle is doing

**Language:** EN
**Status:** Vision -- a proposal, unwitnessed; no code moves until Keaton or a builder takes it up
**Style:** Gauge, Field setting
**Voice:** Kyri
**Room:** Vision -- reasons about a physical property of a scheduling loop, not about a shipped feature
**Author:** Diffuser (moonshots and research lane)
**Kin:** [`../20260918/20260918-064820_row-alignment-for-large-tally-gardens-an-energy-first-principles-check.md`](20260918-064820_row-alignment-for-large-tally-gardens-an-energy-first-principles-check.md) -- the same brief, memory-access energy rather than scheduling energy

## What is, before what could be

**Fact 1 -- an idle CPU stays in its deepest, lowest-power state only as long as something leaves
it alone, and a periodic timer interrupts it on schedule regardless.** This is the documented
reason the Linux kernel carries a "tickless" mode (`CONFIG_NO_HZ`, mainlined 2007-2011,
`NO_HZ_FULL` complete by Linux 3.10 in 2013): a fixed periodic timer interrupt fires whether or
not any thread has work, and every firing pulls every core that would otherwise idle back out of
its deepest C-state to service it. The kernel's own documentation for the feature names exactly
this trade -- periodic ticks cost power on an otherwise-idle machine, in proportion to how often
they fire. This stands as public, well-established operating-systems engineering, general to any
platform running on top of a modern CPU's C-states, rather than specific to Grain.

**Fact 2 -- a process woken from sleep costs more than the syscall it's about to make.** A
`nanosleep` returning is a timer interrupt, then a scheduler decision, then a context restore.
Measured wake latencies on general-purpose hardware run from single-digit microseconds (a shallow
C-state) to several hundred microseconds (a deep one) -- both figures cited widely in Linux
`cpuidle` governor documentation and kernel power-management literature discussing the C-state
trade-off directly. **The exact number on any given machine stays outside what this paper can
assert**; what stays true across the range is the direction: a wake that finds nothing to do still
paid the wake's own cost, and that cost recurs on every tick of a periodic poll, for as long as the
poll runs.

**What follows from the two facts, and only this:** a loop that sleeps a fixed interval and checks
a condition, for a duration the loop cannot predict in advance, spends one wake per interval for the
loop's entire life -- including the stretch of that life during which the condition it is checking
was never going to be true yet. A loop that instead blocks until the condition changes, or backs its
interval off the longer the condition stays unmet, pays fewer wakes for the same outcome. This is
the whole physical claim, stated in general terms. It stays there until the next section brings it
to Caravan.

## What Caravan already has right

Every fixed-interval poll in this tree names its interval as a constant, states the bound it is
built to respect (`max_poll_sweeps * poll_rest_ms > max_linger_ms` in `caravan/harvest.rye:134`),
and refuses -- rather than spins forever -- once that bound is spent. This is exactly the TAME
discipline: bound the loop, name the ceiling, assert it at construction. The proposal below leaves
that structure exactly as it stands. It asks only whether the fixed interval inside an
already-bounded loop is the cheapest way to spend the wakes that bound permits.

## Where the pattern stands, read once across the module

Four sites share one shape -- sleep a fixed span, check a condition, loop -- and two of the four
even share one declared constant:

| Site | Interval | Declared at | Shared with |
|---|---|---|---|
| `caravan/harvest.rye:120` `poll_rest_ms` | 2 ms | its own constant | none -- independently declared at the same value |
| `caravan/entrust.rye:145` `note_rest_ms` | 2 ms | its own constant | re-exported by `confer.rye:124` and `reclaim.rye:131` |
| `caravan/subscribe_poll_service.rye:77` `dependent_poll_ns` | 20 ms | its own constant | none |
| `caravan/subscribe_poll_service.rye:76` `source_ready_ns` | 50 ms | its own constant | none |

**Observation, not yet inference:** four constants across two files, naming three distinct values,
where every one governs the same shape of loop -- sleep, check, repeat -- for as long as the thing
being waited on has not yet happened. `caravan/harvest.rye`'s own comment already states the
trade-off in exactly the right words: *"short enough that a dependent's exit is noticed almost at
once, long enough that a lingering dependent costs a few hundred sweeps rather than a spin."* That
sentence is choosing a fixed point on a curve between latency and wake count. It never says the
curve could bend the other way -- fewer wakes for the SAME worst-case latency -- because a fixed
interval cannot bend it. An adaptive one can.

**The site that spends the most wakes for the least reason: `subscribe_poll_service.rye`'s**
`wait_fetcher_or_source_lost` (lines 86-108). This loop runs for the full lifetime of one fetcher
wire cycle -- the module's own header calls it a cycle that "answers catch-up requests," a network
round trip whose duration is not bounded by anything this loop controls. Every 20 milliseconds,
whether the fetcher has moved one byte or stayed exactly still, the loop makes two
`waitpid(..., NOHANG)` calls and one `nanosleep`. A wire cycle that takes one second wakes this
loop **fifty times**, and forty-nine of those fifty wakes find the same state as the wake before.

## The proposal, sized to one round

**Exponential backoff, capped at the interval already chosen, inside the bound already proven.**
Each of the four sites already asserts a relationship between its interval and a ceiling
(`max_poll_sweeps * poll_rest_ms > max_linger_ms`, or the equivalent read by inspection at the
other three). Backoff changes nothing about that ceiling: it starts at a short interval -- for
instant response on the common case, where most dependents finish quickly -- and doubles the sleep
each time the condition is still unmet, capped at the interval the site already names today.
`subscribe_poll_service.rye`'s loop, backing off from 5ms and capping at the existing 20ms after
four misses, would still notice an exiting fetcher within one interval of its exit in the common
case, and would spend roughly a third as many wakes over a one-second cycle -- 16 rather than 50 --
for the tail where nothing is happening yet.

This is a strict narrowing in the sense `waymark-ladders.md`'s own naming test wants: the total
sleep time before the ceiling fires is unchanged or shorter (backoff never exceeds the cap), so
`max_poll_sweeps * poll_rest_ms > max_linger_ms` continues to hold at the capped value, and no
caller's observed worst-case latency grows. The one new piece is a per-loop counter tracking the
current interval, already the shape `caravan/harvest.rye`'s own `sweeps` variable keeps.

**What this leaves alone.** The four sites keep their own separate constants -- `harvest.rye`'s 2ms
and `subscribe_poll_service.rye`'s 20ms answer to different distributions of expected wait (a
local table sweep versus a network round trip), and collapsing them would be a change of behavior
wearing a change of naming. It also leaves the stronger, platform-specific move on the horizon
rather than in the proposal: `pidfd_open` plus `epoll`, on Linux, would remove the poll entirely
for the `waitpid` case, yet Caravan already runs proven on two piers through `std.c.waitpid`
precisely for that portability reason (REDS %282, cited in the file's own header comment).

## The falsifier -- what would kill this, and why it has not run yet

**This proposal is unmeasured on this machine.** A tool census, checked directly before writing
this sentence, found this host lacking both instruments: `perf` and
`/sys/class/powercap/intel-rapl`. What follows is a stated test for whoever next holds hardware
that exposes a power or wake counter, rather than a result.

**The test:** run `subscribe_poll_service`'s witness-mode fetcher cycle twice, once under the
current fixed 20ms poll and once under a capped exponential-backoff poll starting at 5ms, N=30
repetitions each. Count context switches for the supervising process
(`perf stat -e context-switches`, or `/proc/<pid>/status`'s `voluntary_ctxt_switches` sampled
before and after) as the proxy, since a direct energy counter is unavailable here. Compare wake
count and end-to-end cycle latency between the two.

**It is falsified if:** wake count does not fall, or cycle latency to notice fetcher exit rises
past one poll interval beyond the current fixed-interval baseline. Either result would say the
predicted saving is real in principle yet swamped by something this reasoning did not account for --
most plausibly, that the OS scheduler already coalesces nearby timer wakes across processes (Linux's
own timer-slack mechanism does exactly this for `nanosleep` calls with millisecond-scale precision),
in which case the marginal cost of one more 20ms tick among many already-running ticks is smaller
than treating it in isolation implies. **A firing falsifier locates the finding precisely:** wake
cost in this tree is already amortized by the host scheduler, and the search should move to a
coarser question -- total tick-producing loops running concurrently on one host, rather than one
loop's own interval.

**Confidence: low-medium.** The two cited facts are well-established OS and hardware behavior. What
stays genuinely uncertain is whether ONE supervisor loop's poll rate, among everything else a
Caravan-supervised process tree already wakes for, moves a measurable needle at the scale this tree
runs at today -- the same honest uncertainty the kin DRAM-alignment paper names about its own
one-row saving.

## What this does and does not ask of Bakery

**Buildable now, independent of hardware access:** the backoff counter and its cap, at any one of
the four sites, with a witness proving the interval never exceeds the site's existing constant and
the total elapsed time before the ceiling fires is unchanged or shorter than today. Every piece of
it stays checkable on any machine, with or without a wake counter. **Waits on hardware:** the
falsifier itself, which wants `perf` or a context-switch counter this environment lacks today. Build what is
buildable. Say plainly what waits.

## Related

This paper stands beside the
[kin DRAM-row-alignment paper](20260918-064820_row-alignment-for-large-tally-gardens-an-energy-first-principles-check.md)
as a second, independent first-principles axis on the same brief -- scheduling-wake energy rather than memory-access energy -- both aimed at
Caravan and its neighbors rather than at the torus/radial topology line of inquiry closed this week
(`active-designing/date/20260917/` and `date/20260918/` before this file).
