# What the fleet spends on knowing it is green

**Stamp:** `20260907.020817`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- **research for understanding**: a measurement of the standing roster's cost and of how much of it is
recomputation. Nothing here is bound by a witness yet; the proposed room is where it sits
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Kin:** [`../.claude/rules/the-baton.md`](../.claude/rules/the-baton.md) -
[`../construction/standing-equipment.kyri`](../construction/standing-equipment.kyri) -
[`../active-designing/20260825-173153_reprove-only-what-moved.md`](../active-designing/20260825-173153_reprove-only-what-moved.md)

## What this measures, and what bounds it

Every ship opens a lap by running the standing roster and closes it by running the roster again.
This paper asks one question: **what does that cost, and how much of it is a computation the fleet
has already performed?**

**Bounds, before any number.** Every figure was measured on the Dallas pier on `20260907` between
`01:40` and `02:08` America/New_York, on an AMD EPYC-Rome instance reporting `nproc=8` and 15 GB of
memory, at git nib `ff20e44f66`. The roster figures come from one cold pass I ran myself, recorded
in `construction/standing-equipment-runs.kyri`, which the runner writes with `date +%s` around each
guard. The commit figures come from `git log --since="24 hours ago"` on the same tree. **Every pass
measured here ran while other ships were also running passes**, so the wall figures carry
contention; where that changes a reading, it is named. The fleet held eight seats on this date.

## Observation: what one pass costs

My cold pass ran **160 guards in 1,074 wall-seconds** -- roughly eighteen minutes -- and the
runner's own totals read `guards_run=160`, `guards_seconds=1074`. Guards run serially in one loop,
so the sum is also the pass.

The cost is spread rather than concentrated. Taking the same tier from the immediately prior pass
recorded on this pier, 157 guards over 1,088 seconds:

| Slice | Seconds | Share of the pass |
|---|---|---|
| the 5 costliest guards | 261 | 24.0% |
| the 10 costliest | 411 | 37.8% |
| the 20 costliest | 613 | 56.3% |
| the 40 costliest | 838 | 77.0% |

**55 of the 157 guards cost one second or less.** So there is no single hot guard to fix; reaching
three quarters of the pass means reaching forty of them.

## Observation: what the scope map reaches

`--scoped` reproves only what moved since the last full green receipt. It decides by consulting
`tools/fixtures/s/standing_equipment_scope_map.sh`, one row per guard naming a watch-set, and its
own rule is that **a guard the map does not name always runs** -- absence is the answer that runs,
which is the safe direction.

Measured against my own pass:

| | Guards | Seconds | Share of count | Share of seconds |
|---|---|---|---|---|
| mapped | 43 | 213 | 26.9% | **19.8%** |
| unmapped | 117 | 861 | 73.1% | **80.2%** |

The map holds 56 rows and names no guard `DISCOVERY`. **Four fifths of the pass's wall clock is
unmapped**, so `--scoped` cannot reach it however little has changed.

**The map's coverage runs against cost.** A mapped guard averages 5.0 seconds; an unmapped one
averages 7.4. The rows written so far are the ones that were easy to write, which is the ordinary
way a map gets built and is worth naming because it is the thing to change.

## Observation: how often a watch set is actually touched

For each of the 56 mapped guards I counted how many of the **123 commits** in the trailing 24 hours
touched a file matching its watch patterns. The distribution is sharply **bimodal**:

| Touch rate | Guards |
|---|---|
| 0% | 17 |
| under 5% | 20 |
| 5-25% | 8 |
| 25-50% | 1 |
| **50% and over** | **10** |

Thirty-seven of fifty-six guards watch something that fewer than one commit in twenty touches. Ten
watch something nearly every commit touches. Almost nothing sits in between.

Naming a few watch sets directly, over the same 123 commits:

| Watch set | Commits touching it | Share |
|---|---|---|
| `caravan/` | 0 | 0.0% |
| `glow/` | 3 | 2.4% |
| any `*.rye` | 15 | 12.2% |
| any `*.rish` | 69 | 56.1% |
| `tools/` | 84 | 68.3% |
| `construction/ITINERARY.md` or `REDS.md` | 120 | 97.6% |
| `session-logs/` | 121 | 98.4% |

**Weighted by measured cost, a perfect cache over the mapped set would skip 156 of its 213 seconds
-- 73.2% of the mapped work, and 14.5% of the whole pass.**

## Inference: there are two kinds of guard, and only one is worth caching

The bimodality is not noise. It follows from what a guard watches.

A **record guard** watches the files every lap writes -- the ledger, the operator card, the session
logs, the day shelves. Its watch set is touched in 97 to 99 percent of commits, so its verdict is
stale almost as soon as it is computed. `reds_row_present`, `reds_status_consistency`,
`reds_pin_capacity`, `index_fold` and `log_has_a_row` all read at 98% or above. Caching them saves
nothing, and they are cheap in any case.

A **code guard** watches a module. `caravan/` was touched by **zero** of 123 commits and `glow/` by
three, while `caravan_roster_bijection` ran on my pass and `caravan_suite` sings 111 rungs on
cadence at a recorded 840 seconds. **The fleet spends its largest single blocks of compute
re-proving code that has not changed in a day.**

That is the finding, stated plainly: the expensive work is the work whose subject sits still.

## Inference: the map is the precondition, not the optimization

An obvious cheaper design is to skip the map and key each verdict on the whole-tree hash, which
costs one `git rev-parse HEAD^{tree}` and needs no per-guard declaration. The measurement rules it
out.

The fleet landed **123 commits in 24 hours**, one every 11.7 minutes. A pass takes 18.1 minutes.
**HEAD moves about 1.5 times during a single pass**, so a whole-tree key is invalidated before the
pass that computed it has finished. A tree-keyed cache would hit almost never.

A watch-set key survives, because a guard's own subject moves far more slowly than HEAD does -- that
is exactly what the 0% and 2.4% rows above say. So the map is not an optimization layered over
caching; **without it there is nothing to cache.**

## Observation: what this costs the pier, measured two ways

**By arithmetic.** 123 commits a day, roughly one lap each, two passes a lap (cold at the open, hot
after `git add`) gives 246 passes a day. At 1,074 wall-seconds each that is 264,204 pass-seconds
against 86,400 seconds in a day -- **3.06 passes running concurrently, around the clock.**

**By sampling.** I counted the live `standing_equipment_run.sh` invocations every 15 seconds for
three minutes: 4, 4, 4, 3, 2, 2, 3, 3, 3, 3, 3, 3. **Mean 3.08.** Load average fell from 10.52 to
4.77 across the window, so the window sat on a falling shoulder rather than at the daily mean.

The two methods share no inputs and agree to within one percent. That agreement is the strongest
thing in this paper.

**Turning passes into threads.** I timed three guards individually with `TIMEFORMAT`, under 14-way
concurrency at load 8.23:

| Guard | real | user + sys | CPU per wall second |
|---|---|---|---|
| `comlink_topology` | 13.46s | 17.49s | 1.30 |
| `width_check` | 38.58s | 71.30s | 1.85 |
| `shell_dialect` | 18.73s | 16.68s | 0.89 |

**Guards fan out; they are not single-threaded**, which corrects the natural assumption. At the
three-sample mean of 1.35 CPU-seconds per wall-second, 3.07 concurrent passes occupy about **4.1 of
the pier's 8 threads -- roughly half the machine, continuously.**

Two honest qualifications. Three samples with a range of 0.89 to 1.85 do not establish a rate, and
contention stretches wall time while leaving CPU roughly fixed, so a ratio measured under load
understates the idle ratio. Confidence in the **order** -- tens of percent of the machine, not
single digits -- is high; confidence in the figure 52% is low.

**`width_check` spent 40.4 seconds in `sys` against 30.9 in `user`.** More than half its cost is
kernel time: process creation and file reads, the shape of a shell script that forks per file. The
roster's bill is substantially spawn overhead rather than computation, which matters because spawn
overhead is the part a cache removes completely.

## Projection: what mapping twenty more guards would buy

**Horizon:** the next fifty laps, on a fleet of this size and commit rate.
**Assumptions:** the roster keeps its present shape; ships keep landing about 123 commits a day;
the currently unmapped guards, once mapped, skip at rates like the mapped ones.

The twenty costliest unmapped guards carry **506 seconds, 47.1% of the pass.** Mapped and skipped at
the measured 73.2%, they would return about 370 seconds a pass. Added to the 156 seconds already
available, that is roughly **49% of every pass**, and at 3.07 concurrent passes something near a
quarter of the pier's compute.

**Falsifier, and it is cheap.** The 73.2% skip rate is measured on the guards somebody has already
chosen to map, which may be the easy and quiet ones. Declare watch sets for the five costliest
unmapped guards -- `declared_ceiling` (72s), `standing_equipment` (68s), `width_check` (45s),
`lantern_face` (40s), `crushed_index` (36s) -- and count their touch rate over the same 123 commits.
**If the cost-weighted mean exceeds about 30%, this projection fails** and the remaining saving is
small.

**Partial evidence already stands, and it points both ways.** `width_check` watches `*.rye`, touched
by 12.2% of commits, so it would skip about 88% -- the projection holds there. `living_card_ascii`
(26s) reads the operator card and the ledger, touched by 97.6%, so it would skip about 2% -- the
projection fails there. **The costly unmapped set is itself a mixture of record guards and code
guards**, and the honest expectation sits between the two extremes rather than at either.

**Confidence:** moderate that mapping the code-watchers among the top twenty returns more than 20% of
a pass; low on any figure past that.

## What is buildable, for whoever takes it

Three things, smallest first, each independently useful.

1. **Rank the map by what it would save.** The value of mapping a guard is its cost multiplied by
   one minus its touch rate. Both factors are already on disk -- cost in
   `construction/standing-equipment-runs.kyri`, touch rate from `git log --name-only`. A scan that
   prints that ranking tells whoever writes the next map rows which rows to write. This is the
   cheapest of the three and it gates the other two.
2. **Print the reuse census as a reading.** The tables above are computed from the roster, the run
   card, the scope map, and `git log`, with no new state. As a fixture scan beside a witness it
   becomes checkable rather than asserted, which is what moves it out of the proposed room.
3. **Key verdicts on the watch-set hash, so the fleet shares them.** Eight ships computing one
   verdict eight times is the whole finding restated. This is the largest of the three, it needs the
   map that item 1 ranks, and it should wait for both.

**Said plainly: item 3 is not buildable today**, because 80.2% of the pass is unmapped and a cache
without a map has nothing to key on. Items 1 and 2 are buildable now and neither needs a ruling.

## What this does not reach

**Whether any guard should run less often.** Every reading here is about not recomputing an
unchanged answer; none is about weakening a check. A cached verdict and a recomputed one are the
same verdict, which is the only reason this is worth doing at all.

**Watts.** My lane names electricity and this paper never measures it. The pier's power draw is not
readable from inside the instance and I did not estimate one, because a wattage invented to decorate
a CPU-hour figure would be the kind of number this style exists to refuse. The compute share is
measured; the energy claim is not made.

**The daily mean.** The sampling window ran three minutes on a falling load and the arithmetic
assumes two passes a lap. A day-long sampler would settle both, and the agreement between the two
present methods is evidence rather than proof.

**Whether the fleet should be this size.** Eight ships sharing one 8-thread box is the fact this
paper measures inside; whether that is the right shape is a different question and Keaton's.
