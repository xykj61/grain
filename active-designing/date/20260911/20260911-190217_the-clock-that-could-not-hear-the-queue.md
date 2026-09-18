# The clock that could not hear the queue

**Stamp:** `20260911.190217`
**Room:** mixed -- the three closed forms and their simulation are **checkable** and run today;
the seasonal duty cycle itself stays **vision** until a real workload is measured against them
**Status:** Living -- row 9's falsifier, run before its estimate was spent
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Subject:** row 9 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Program:** [`../tools/rye/duty_cycle_backlog.rye`](../tools/rye/duty_cycle_backlog.rye)
**Kin:** [`../external-research/20260908-005732_the-share-that-is-not-a-property-of-the-parts.md`](../external-research/20260908-005732_the-share-that-is-not-a-property-of-the-parts.md) -
[`20260911-081019_the-unit-this-pier-can-carry.md`](20260911-081019_the-unit-this-pier-can-carry.md) -
[`20260911-111917_the-loop-that-already-refused.md`](20260911-111917_the-loop-that-already-refused.md)

---

## The mechanism, first

`tools/rye/duty_cycle_backlog.rye` is a new Rye program with three pure functions --
`stable_park_max`, `drain_ticks_form`, and `wait_ticks_form` -- and one `simulate` function that
runs a tick loop over sixteen cycles of eight sectors, parking the first `k` sectors of each and
serving work during the rest. `check_row` calls both and asserts the loop's measurement against
each closed form. Six configurations run at startup. Everything is integer: work is carried in
micro-units of one awake sector-span, rates in parts per million.

Built and run on this pier `20260911.190217`:

```
RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build tools/rye/duty_cycle_backlog.rye
./duty_cycle_backlog
```

## What the row asked for, and what it asked about

Row 9 of the moonshot page proposes a first witness and a falsifier. Read them side by side:

> **First witness.** A fake clock that parks 3 of 8 sectors, with the parked and running sector
> counts printed each tick.
>
> **Falsifier.** Parked sectors accumulate a backlog that the waking sectors take longer to clear
> than the parking saved.

The witness measures one quantity: how many sectors the parking rule parked. That quantity is a
property of the rule, so the clock reports its own input back. The falsifier asks about a backlog,
and a backlog is built from two quantities the clock holds nowhere -- how fast work arrives, and
how fast a waking sector serves it. **So the proposed first witness stays green whatever the
falsifier does**, which is the shape the grain page states plainly: a guard that cannot red guards
nothing.

This is the third row of the same page to answer before its estimate was spent. Row 6 was ranked
on *one host read away* and the read said no; row 10 was ranked at three to six weeks and already
stood. Row 9 was ranked fifth at one to two weeks, and the hour below is what it actually cost.

## Three forms, and the one that surprised

Write `S` for the sectors in a cycle, `k` for the sectors parked, and `rho` for the utilization a
never-parking processor would run at -- arrivals over service, a fraction.

**The park a workload's headroom allows.** Over one cycle, arrivals total `rho * S` spans of work
and capacity totals `S - k` spans. A queue returning to where it started needs `rho * S <= S - k`,
so:

> **k <= S * (1 - rho)**

**The drain.** A park accumulates `k * rho` spans of work. Awake, the queue falls at `1 - rho`
spans of work per span, so it clears in:

> **k * rho / (1 - rho) spans**

**The wait, which is where the interesting answer sits.** Work arriving at the first tick of a
park finds an empty queue in steady state, and waits exactly until wake. So:

> **the worst wait is k spans, and utilization enters it nowhere**

That third form is the finding worth carrying. **Latency cost is set by the park's own length;
utilization sets how long a park you may take.** Those are two separate quantities, and row 9's
falsifier -- *the waking sectors take longer to clear than the parking saved* -- compares a
duration against an energy and reaches for one number where two live. Each half is real, and each
half wants its own reading.

## What the tick loop proved

Six configurations, each measured against all three forms, run `20260911.190217`:

| k | rho (ppm) | peak queue, sim / form | drain ticks, sim / form | worst wait, sim / form |
|---|---|---|---|---|
| 1 | 500,000 | 500,000 / 500,000 | 1,000 / 1,000 | 1,000 / 1,000 |
| 3 | 500,000 | 1,500,000 / 1,500,000 | 3,000 / 3,000 | 3,000 / 3,000 |
| 3 | 600,000 | 1,800,000 / 1,800,000 | 4,500 / 4,500 | 3,000 / 3,000 |
| 5 | 300,000 | 1,500,000 / 1,500,000 | 2,143 / 2,142 | 5,000 / 5,000 |
| 2 | 750,000 | 1,500,000 / 1,500,000 | 6,000 / 6,000 | 2,000 / 2,000 |
| 6 | 200,000 | 1,200,000 / 1,200,000 | 1,500 / 1,500 | 6,000 / 6,000 |

Rows three and six carry the point in numbers. **At `k=3` the wait reads 3,000 ticks whether rho
is 0.5 or 0.6, while the drain moves 3,000 to 4,500.** One form holds still under utilization and
the other tracks it, which is the two-quantity claim measured rather than argued.

The single-tick gap at `k=5, rho=0.3` is the tolerance the assert grants and the only place it is
spent: a loop counts whole ticks where the form divides exactly. Every other reading is equal.

**The guard reds.** Two mutations were planted in a pen under `.lap/` and both bit at `check_row`:
adding one tick to the wait form, and removing the `1 - rho` denominator from the drain. Lifting
each plant returns the program to a clean run. A form proven only in the passing direction cannot
be told from a form nobody checked.

## Row 9's own configuration, priced

Row 9 names *3 of 8*. Put `k=3, S=8` into the first form and the configuration states its own two
entry conditions:

- **Utilization at or under 62.5%.** Above it, the parked work outlives the waking run.
- **A latency budget of at least 3 sector-spans**, since that is the worst wait by construction.

Both are numbers about the workload rather than about the clock, and the proposed fake clock
measures neither.

## The surface

Feasible park across eleven utilizations and seven latency ceilings, 77 grid rows:

| rho (ppm) | park at ceiling 2 | park at ceiling 7 |
|---|---|---|
| 0 | 2 | 7 |
| 180,000 | 2 | 6 |
| 360,000 | 2 | 5 |
| 540,000 | 2 | 3 |
| 720,000 | 2 | 2 |
| 810,000 | 1 | 1 |
| 900,000 | 0 | 0 |

Two readings come off it. **A patient workload converts headroom into parked sectors almost one
for one**, which is the mechanism working. And **7 of the 77 rows park nothing at all** -- every
one of them at `rho = 0.9`, where a processor has under a tenth of its capacity spare and parking
has nothing to spend. The mechanism's reach is a function of one number, and that number is
measurable ahead of any implementation.

## What a park is worth, and why the two papers multiply

Energy saved is `k * (active - sleep)` against a whole cycle's `S * (baseline + active)`. Run on
the parts the sibling power paper already cites -- an ST MP23DB01HP microphone in low-power mode
at 1.8 V, a Nordic nRF52840 awake and idle-retaining at 3.0 V, converted exactly as
`tools/rye/power_budget_crossover.rye` converts them:

| k of 8 | saving |
|---|---|
| 1 | 11.91% |
| 3 | 35.73% |
| 5 | 59.56% |

So the relative saving factors cleanly into two terms: a **scheduling factor**, `k / S`, which
this page bounds, and a **hardware factor**, `(active - sleep) / (baseline + active)`, which the
power paper measures. The lane's two readings compose by multiplication, and each can be taken
without the other.

## The edge the assert caught

At zero utilization the first form offers the whole cycle, and a cycle with no waking sector is an
off switch rather than a duty cycle -- nothing remains awake to notice work returning. The
program's own `assert(k < sectors_per_cycle)` fired on the first run and named it. `stable_park_max`
clamps to `S - 1` now, with the reason written beside the clamp. **A bound stated honestly
finds its own edge the first time it runs**, which is the argument for stating it at all.

## What would falsify this page

**The forms rest on uniform arrivals.** A bursty workload delivers a cycle's work in a fraction of
a cycle, and its peak queue then exceeds `k * rho`. So: **a measured queue, fed uniformly, whose
worst wait exceeds `k` spans or whose drain exceeds `k * rho / (1 - rho)` spans, falsifies the
arithmetic here.** A bursty queue exceeding them confirms the model's own stated scope instead,
and wants a second reading with a burst term.

The second falsifier is about worth rather than correctness: **a real workload whose utilization
sits above 90% and whose latency budget is under one sector-span** would leave the mechanism with
no feasible park, making row 9 an idea with a proof and no customer.

**Horizon.** The arithmetic runs today. Binding it to a real workload waits on the workload trial
that row 12 of the same page already sequences, and on Bakery's own measurement of what Caravan
and Mantra actually arrive at.

**Confidence.** High for the three forms, since a tick loop checks each one and two planted
mutations bite. Medium for the saving, which rests on two datasheets and one parts pairing.
Medium-low for the mechanism's reach until a real utilization is measured.

## What row 9's first witness should be instead

> A queue fed at a declared arrival rate, served by a processor parked for `k` of `S` sectors,
> printing its peak queue, its drain, and its worst wait each cycle -- with the run asserting each
> against the closed form it claims to follow.

That witness costs what the fake clock costs and can red on the thing row 9 actually worried
about. The program on this page is that witness in its arithmetic half; the half still owed is a
real workload to point it at, and that half belongs to Bakery's lane rather than to this one.
