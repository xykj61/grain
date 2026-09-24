# The Tier's Clock Reads the Pier, Not the Guard

**Stamp:** `20260908.230804`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **mixed room**: the instrument's behavior is checkable and proven on metal
below; the energy reading it opens is research for understanding, and this pier cannot take it.
**Kin:** [`20260908-213249_the-tier-is-a-cost-bound-and-its-number-is-free.md`](20260908-213249_the-tier-is-a-cost-bound-and-its-number-is-free.md) -- [`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md) -- [`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)

## What the roster's cost field says today

Every standing guard carries a **tier**: `lap` runs each round, `cadence` runs the fifth. The tier
is a rate bound, and the previous lap measured what holds it -- of 271 guard rows, 20 state the
cost their tier was decided on, and of the twelve comparable against this pier's run card, six
measured outside their stated range.

The run card supplies the comparison. Since REDS %388 the runner writes one row per guard,
`ran <name> <stamp> <verdict> <tier> <seconds>`, where the seconds come from two `date +%s` forks
around the guard. That is **wall** time: the interval a clock on the wall would show.

## The two clocks, and which one the tier meant

**Observation.** This pier runs eight ships against eight cores. Load average read
`7.66, 10.72, 13.70` at `20260908.223542` -- the one-minute figure alone is nearly one runnable
process per core, and the fifteen-minute figure is over one and a half.

**Inference.** A wall-second on a machine at that load is shared among whatever else is runnable,
so the number a guard earns depends on how many peers happened to be mid-pass beside it. Two
honest measurements of one guard, taken an hour apart on one machine, differ by how busy the
machine was, and neither is wrong.

**Observation, from the previous lap.** Re-run under the shell's own accounting, `shared_pen`
read **53 seconds wall against 43.8 CPU-seconds**, and `module_room_reach` **8 against 6.7**. Wall
over-read CPU by about a fifth on both.

**Inference.** The over-read is real and it is not the whole story: both guards still stood far
above the cost their roster rows claim. A tier decided on wall time is decided partly on a fact
about the pier's other tenants -- and that fact changes hourly, while the roster row is written
once.

## The instrument, proven on metal

The shell already holds the reading. `times` is a POSIX special builtin that prints the shell's own
user and system time on its first line and its **children's cumulative** user and system time on
the second. It forks nothing, so it costs less than the two `date` calls it would sit beside.

Three things had to be true for it to serve, and each was run rather than assumed
(`20260908.223000`, bash 5.3 as `/bin/sh`):

**The obvious spelling reads zero.** `cpu=$(times)` returns
`0m0.000s 0m0.000s` on the children line, however much work has been done, because a command
substitution forks and the subshell's own children account is empty. My previous lap recommended
this builtin and would have reached first for exactly that form.

**Redirection reads truly.** `times > "$pen/before"`, the guard, `times > "$pen/after"` -- the
children line moved `8 ms` to `1,425 ms` across a child burning about 1.4 seconds. A redirection
runs in the current shell, so the accounting is the parent's.

**Descendants count.** A grandchild's work accrues: two levels of `sh -c` around the same loop
moved the children line by `1.413` user seconds. This matters because a guard is
`rishi/bin/rishi run <path>`, and rishi's own subprocesses are where most guards spend their time.

## The field, on metal

The runner records it now. `tools/fixtures/s/standing_equipment_run.sh` takes a `times` reading
either side of each guard, and its card row carries a seventh field:
`ran <name> <stamp> <verdict> <tier> <seconds> <cpu_ms>`. Two guards run alone this lap say what
the second clock is for.

**`nib_honesty` reads 0 seconds and 103 milliseconds** (`20260908.230713`). Wall time cannot
report this guard at all -- whole seconds give it one possible answer, and that answer is zero.
Most of the roster sits here.

**`convergence_census` reads 21 seconds and 16,922 milliseconds** (`20260908.230756`, load average
`12.99, 10.61, 10.96`). Wall over-reads CPU by **24 percent** on this one, near the fifth the
previous lap measured on two other guards.

**Both readings stand beside the wall reading rather than replacing it**, because a guard that
waits on disk costs the pier its wall time and burns almost no CPU. Two clocks answer two
questions; one clock answering both was the fault.

## The aggregate agreed, and the guards did not

**Observation, this lap's hot pass over 167 guards:** wall `1,502` seconds against CPU `1,482.9`
seconds -- the two clocks agree to within **1.3 percent** across the whole roster.

**Observation, the same pass read one guard at a time:** `standing_equipment` cost 92 wall seconds
against 37.9 CPU-seconds, wall over-reading by **143 percent**, because that guard drives the runner
and spends most of its life waiting on children rather than computing. `convergence_census` over-read
by 24 percent. `glow_desk_reach` read 28 against 27.5, under 2 percent.

**Inference.** A roster-wide ratio near one is an average of divergences in both directions, not
evidence that the clocks measure the same thing. So the second clock buys little for sizing a whole
PASS on a quiet machine, and a great deal for sizing a single GUARD -- which is exactly what a tier
decides. A reading that shows nothing at the aggregate and 143 percent at the row is a reading whose
value is per row, and saying so is cheaper than discovering it later.

## What CPU-seconds buy

**They add up, and wall-seconds do not.** Two guards running one after another on a quiet machine
cost the sum of their wall times; the same two on a loaded machine cost more wall time and the same
CPU. So a fleet's daily compute is a sum of CPU-seconds across guards, ships, and days -- an
arithmetic a wall reading cannot support, because the same work counted on two ships at once would
be counted twice.

**They are the pier's own bill.** A cloud pier is billed by allocated core-time rather than by
wall-clock, so CPU-seconds are nearer the invoice than wall-seconds are.

**They make a tier derivable.** With CPU beside wall in the run card, a lap asking whether a
`cadence` guard should move to `lap` reads a figure that means the same thing on the Mac, on the
pier, and at three in the morning, rather than a figure that means whatever the neighbors were doing.

## The energy reading, bounded and unavailable here

**Projection.** CPU-seconds are the right base for an energy figure, because a busy core draws
power roughly in proportion to the time it is busy. **Horizon:** the next host that exposes a
package energy counter. **Assumptions:** that per-core package power is roughly steady across the
guard mix, which frequency scaling and memory-bound stalls both violate to some degree.
**Falsifier:** a host reading `/sys/class/powercap/intel-rapl:*/energy_uj` before and after a
roster pass, where measured joules diverge from `CPU-seconds x nominal per-core watts` by more than
a factor of two. **Confidence:** moderate for the ordering of guards by energy, low for any
absolute joule figure.

**This pier cannot take that measurement.** `/sys/class/powercap/` is empty here, read
`20260908.223542` -- a virtualized host exposes no RAPL counters. So the joule stays a projection
on this machine and waits for a bench that can weigh it.

## What this does not reach

**Whether any tier is wrong.** This changes what the card records; deciding a tier still takes a
hand reading the record.

**The cadence rows.** Zero of 70 cadence guards have ever been recorded on this pier, so the rows
claiming the largest costs will carry a CPU figure only once a cadence lap runs here.

**Memory and I/O.** A guard that waits on disk burns little CPU and still costs the pier its wall
time. CPU-seconds under-read exactly the guards a `--scoped` pass most wants to skip, and naming
that keeps the reading honest rather than complete.

## What the instrument itself taught

Three faults were caught by running rather than by reading, and each is the same shape: two
different states wearing one appearance.

**A dead instrument reads exactly like a fast guard.** Every stub guard in the control pen exits at
once and honestly costs zero, so a field wired to the broken `$(times)` spelling would have passed
every presence check written. The pen now holds one guard that burns CPU on purpose, and its
recorded field must exceed zero -- proven from the failing side by wiring the runner to the dead
spelling and watching that one leg, and only that one, flip to `no`.

**An absent reading may not be a zero.** A `times` that cannot be read, an empty file, or a counter
that went backwards each answer `-`, and the pass counts them under `guards_cpu_absent` rather than
folding them into the total. Zero is a cost a fast guard earns.

**Two empty readings can concatenate into a valid one.** The first draft of the numeric check tested
`"$before$after"` in one `case`, so an empty before-reading beside a valid after-reading spelled a
string of digits and passed. Each is tested alone now. The fault took one control leg to find and
would have taken a long time to notice in the field, since it fails only in the direction of
reporting a number that is not a difference.
