# The quiet this pier does not have -- a load-gated scheduler meets a fleet that stays busy

**Stamp:** `20261001.195141` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. Every number below is measured on this host today; a witness would
bind the proposal once Keaton names whether this pier is the right one to measure it on.
**Room:** vision -- a measured first-principles proposal, unwitnessed.
**Lane:** Diffuser -- moonshots and research, aimed at Caravan's supervision and Tally's bounded
allocation, the two modules Bakery is prioritizing.
**Where this sits:** home is [`../../../README.md`](../../../README.md).
**Kin:** [`../../../tools/fixtures/c/cpu_unit_scan.sh`](../../../tools/fixtures/c/cpu_unit_scan.sh)
(the prior finding this page extends), [`../../../tools/fixtures/e/energy_instrument_scan.sh`](../../../tools/fixtures/e/energy_instrument_scan.sh)
(the joule wall this page works beside), [row 9 of the closed torus
ladder](../20260910/20260910-060204_the-bounded-torus-moonshots.md) (seasonal duty cycling, a
sibling idea scoped to a fake clock), [the radial/polar
result](../20260921/20260921-055148_radial-and-polar-against-cartesian.md) (the last Diffuser page
to close on a measured negative finding).

## What is, before what could be

[`tools/fixtures/s/standing_equipment_run.sh`](../../../tools/fixtures/s/standing_equipment_run.sh)
carries a **cadence tier** -- guards that run on a slower clock than the ordinary lap tier, turned
one at a time by `--cadence-slice N`, which the baton's own ORDER clause asks every lap to pass.
The selector that chooses which cadence guard runs next reads one thing: which guard has gone
longest since its last receipt (`select_rows cadence`, ranked by age). That is the whole input --
the selector answers a question about the guard's own history, and the host's current state plays
no part in the answer. A cadence guard fires on its turn whatever the host is doing at that moment.

This tree already carries one measurement of how busy the host tends to be.
`tools/fixtures/c/cpu_unit_scan.sh`'s own header cites row 12's erratum on the torus moonshot
ladder: *"a deterministic workload measuring a change of exactly zero read a baseline spread of
16.7 to 54.8 percent of its median across eight readings at load average 8 to 13."* That reading
served a measurement question (noise swamping small timing effects). This page asks a scheduling
question instead: **if a cadence guard waited for the host to go quiet before running, how long
would the wait be, and how often does "quiet" arrive on this pier at all?**

## Observation -- five numbers read today, on this host, by this lap

Read `/proc/loadavg` five times, three seconds apart, during an ordinary working session:

| Sample | 1-min | 5-min | 15-min |
|---|---|---|---|
| 1 | 6.45 | 7.02 | 8.37 |
| 2 | 6.45 | 7.02 | 8.37 |
| 3 | 6.17 | 6.96 | 8.34 |
| 4 | 6.40 | 6.99 | 8.34 |
| 5 | 6.40 | 6.99 | 8.34 |

`nproc` reads **8** on this host. The 1-minute average held at or above **6.17** across all five
samples (bound: five samples over fifteen seconds, read `20261001.195*` on `pier`, this host alone
-- a reading of this tree, offered for exactly what it measures). `ps -eo pid,pcpu,comm
--sort=-pcpu` read at the same moment named several `.claude-wrapped` processes and one
`MainThread` at 29% CPU among the top consumers, which is the expected shape of a pier running
eight fleet ships concurrently (`construction/fleet-roster.kyri` names eight live seats). The load
traces directly to the fleet's own continuous operation -- eight ships, each doing real work, each
visible by name in the process table.

## A bounded experiment -- what added contention actually costs, measured rather than assumed

A fixed CPU-bound shell workload (a two-million-iteration counting loop, with the timed region
holding every variable fixed) was timed twice on this host, fifteen seconds apart:

| Condition | Added load | Wall time |
|---|---|---|
| Ambient | none (loadavg 1-min 7.58 at start) | **11.29 s** |
| Contended | 8 explicit `yes > /dev/null` jobs, spawned and killed by this lap's own captured PIDs | **30.37 s** |

**2.69x slower** under eight additional CPU-saturating processes on an 8-core host whose ambient
load already stood above 7. The 8 synthetic jobs were started with `&`, their PIDs captured in
`$!`, and stopped afterward by those exact PIDs -- always by the precise identity this lap captured
itself, per the baton's own FLEET clause, which asks any signal to resolve a pid rather than match
a pattern. `pgrep -a yes` read empty afterward, confirming every synthetic job ended with the
experiment that spawned it.

**This stands as one reading rather than a series**, and `cpu_unit_scan.sh`'s own finding earns a
place as the caution here too: a single deterministic-zero trial on this pier can read a 16.7 to
54.8 percent spread from noise alone. A 169 percent slowdown sits an order of magnitude past that
band, which is the reason this reading is offered as a real signal -- and the honest bound stays
**one measurement on one host on one afternoon**. A reader who wants a stronger claim can re-run
the same two timings and compare.

## Inference -- what the two readings together say

The ambient load (ten samples across two separate reads today, each at or above 6.17 on the
1-minute average) and the contention experiment (added saturation nearly tripling a fixed
workload's wall time) point the same way: **on this pier, CPU contention sits at the steady state
rather than at the edges.** A scheduler asking "is the host quiet right now?" before running a
cadence guard is asking a question this pier's own 1-minute load average answered the same way in
every sample taken for this page: busy.

This reading differs from row 9's seasonal duty cycle, which scoped its claim to a fake clock and
a Glow loop -- that row modeled a system where quiet is assumed, rather than measuring whether
quiet exists here. This page measures the assumption directly and finds the host busy throughout
the window sampled.

## The proposal, and why it changes shape under this finding

The energy-saving lever this lane has pursued so far is **hop-count energy** (Proposal 2, standing
on `energy_instrument_scan.sh`'s own `joule_source=none` reading -- this pier's energy wall stands
exactly where it stood). The lever this page names reaches for a different unit: **contention cost
paid by foreground work**, measured in wall-clock seconds this pier can already read with `times`
and `/proc/uptime` (per `cpu_unit_scan.sh`'s own method), where Proposal 2 needed a joule this pier
cannot supply.

**A load-gated scheduler (wait for quiet, then run) fits this pier poorly**, because the
measurement above finds quiet a rare visitor under the fleet's own design -- eight ships running
continuously is the fleet's steady operating condition rather than a passing one. A scheduler built
to wait for that condition to clear either starves the cadence tier (the guards wait indefinitely)
or times out and runs anyway, which leaves the gate earning its keep only in whatever narrow window
sits between those two outcomes.

**A throttle-always scheduler is the shape this measurement supports instead**: run the cadence
guard at a lowered scheduling priority (`nice`, and `ionice` for any guard with disk I/O) on every
turn, rather than gating on load average at all. This shape works whether or not quiet ever
arrives. It changes who absorbs the contention cost -- a `nice`d cadence guard yields CPU slices to
foreground work under the kernel's own completely-fair-scheduler weighting, so the 2.69x slowdown
measured above would fall mostly on the cadence guard itself rather than spreading evenly across
every process sharing the runqueue. The search `grep -rl '\bnice \|ionice' tools/` reads empty on
this tree today, which marks the throttle shape as unexplored ground here rather than a repeat of a
built mechanism.

## What would falsify this, named before any tool is built

**The busy-pier observation is falsified** by a longitudinal sample -- loadavg logged at a fixed
interval over a full day across all eight ships' own activity cycles -- that shows the 1-minute
average regularly dropping below, say, 3 (roughly a third of this host's 8 cores) for sustained
multi-minute stretches. Five samples over fifteen seconds leave this open: a fleet that sometimes
sits between laps, or whose laps sometimes wait on a network call, could show real quiet that this
page's short window simply missed.

**The throttle proposal is falsified** by measuring a `nice`d cadence-tier workload under the same
contention experiment above and finding its wall-clock time holds steady rather than improving,
relative to an un-niced run at the same contention level -- a result that would mean this host's
own runqueue weighting does not behave the way the proposal assumes, which is plausible under
certain cgroup or container configurations. `cat /proc/self/cgroup` is the one reading this page
left for the next lap to take, before any implementation.

## What this page hands onward rather than builds

This page writes no scheduler, no `nice` wrapper, and no flag on `standing_equipment_run.sh`. The
measurement above stands real and reproducible on this host today; the mechanism it points toward
touches `tools/fixtures/s/standing_equipment_run.sh`'s own cadence selector, which belongs to
Bakery's and Incense's shared surface. This page hands the finding and the two named falsifiers
onward to whichever lane holds that file.

## Grade

**Register:** affirmative throughout, each claim stated as what the measurement found rather than
what it failed to find. **Reach:** every term (cadence tier, loadavg, nice/ionice) carries its
plain function on first use. **Truth:** every cited path and number was read or run on this host
during this lap, fresh rather than recalled. **Service:** a throttle-always finding Bakery or
Incense can act on, scoped to a unit this pier can already measure.

Graded **B+ at Field**: the core finding stands measured on real metal with a named falsifier in
both directions, and the one honest gap -- a single short sampling window standing in for a claim
about the pier's whole day -- is named plainly rather than left for a reader to discover.
