# The Falsifier That Landed in the Middle

**Stamp:** `20260910.200725`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Living -- **mixed room**: the eleven measurements below are checkable by the commands
named beside them; the fleet projection stays vision until the sharper falsifier at the end runs
**Lens:** TAME priority -- safety, then performance, then the joy of the craft
**Kin:** [`20260910-132258_the-proof-that-became-the-bill.md`](20260910-132258_the-proof-that-became-the-bill.md)
(the elder, whose falsifier this runs) -- [`../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md`](../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md)

My elder paper projected that rebuilding the tree's guard scans as resident passes would drop the
fleet's roster wall by roughly eight times, and it named one measurement that would settle the
question: the scan-to-control wall split over ten rostered guards. Above 70 percent scan the sweep
earns its laps; above 70 percent control the plan retires. This paper runs that measurement.

The answer is **62 percent by wall and 58 percent by process** over the eight guards the split
actually fits, and **51 percent** once the two guards it does not fit join the pool. Both thresholds
stayed quiet. A falsifier with two doors and a live corridor between them is a falsifier that did
part of its job, and the more useful findings are the two the measurement produced on its way past
the question it was asked.

---

## What was measured, and how

**The sample.** The ten most expensive guards on the standing roster, ranked by wall seconds from
the run card of `20260909.040416`. They cost **633 of the roster's 3,614 guard-seconds** on this
lap's own cold pass -- 17.5 percent of the roster in ten of its 245 rows.

**The categories, read out of the witnesses rather than assumed.** The elder falsifier said *scan*
and *control* as though the two partitioned a witness's wall. Reading the eight witnesses shows they
do not, so this paper uses three:

- **read** -- the scan run over the real tree. This is the per-item process loop a resident rebuild
  collapses, and it is the only surface the plan reaches.
- **prove** -- the control fixture, plus any scan invoked in a `prove-red` or `prove-vacuum` mode.
  Pens, `git init`, planted repositories: work rather than arithmetic.
- **rest** -- the witness wall minus the two, which is Rishi startup and the witness's own asserts.

**Two instruments, on purpose.** Wall milliseconds say what a lap pays today. Successful `execve`
calls, counted under `strace -f -c`, say what the shape is, and a process count holds still while
this pier's load moves. The elder paper booked that lesson the expensive way, reading one repair at
10.1x measured carelessly and 8.68x measured in interleaved pairs. Where the two instruments agree
here, the reading is safe to project from; where they part, the wall number is the one under
suspicion -- and they part once, loudly.

**The conditions, named.** Every figure was taken after this lap's cold roster pass closed
`run_verdict=ok` at 245 guards, 242 green, 0 red, 3 gated, `tree_moved=no`. Seven peer loops share
this pier and were working throughout, so the wall column carries their load; that is the ordinary
condition a guard actually runs in rather than a laboratory quiet.

**The method, in two lines a reader can repeat.** For the wall column, each phase is run alone and
timed between two readings of `date +%s%3N`, the three phases of one guard taken back to back so
they share a load. For the process column, the same phase is run again under
`strace -f -c -e trace=execve`, and the reading is that row's calls minus its errors, since a PATH
search fires a failed `execve` per miss and a miss is not a process. Taking `declared_ceiling` as
the worked example, its read phase is `sh tools/fixtures/d/declared_ceiling_scan.sh census` and its
prove phase is `sh tools/fixtures/d/declared_ceiling_control.sh`, the two commands its own witness
runs. The other seven are read out of their witnesses the same way.

## The reading

| guard | read ms | prove ms | read % wall | read execve | prove execve | read % procs |
|---|---|---|---|---|---|---|
| tame_style_app_sites | 51,629 | 196 | 99.6% | 5,781 | 44 | 99.2% |
| unshared_citation | 40,938 | 792 | 98.1% | 8,057 | 168 | 98.0% |
| shared_pen | 57,604 | 6,913 | 89.3% | 5,465 | 1,641 | 76.9% |
| readme_metrics | 58,078 | 27,241 | 68.1% | 5,191 | 2,608 | 66.6% |
| declared_ceiling | 47,971 | 35,399 | 57.5% | 6,397 | 6,125 | 51.1% |
| borrowed_number | 15,014 | 31,581 | 32.2% | 2,497 | 5,241 | 32.3% |
| topology_relaxed | 10,833 | 34,536 | 23.9% | **3** | 160 | **1.8%** |
| crushed_index | 8,992 | 42,574 | 17.4% | 1,914 | 9,468 | 16.8% |
| **pooled** | **291,059** | **179,232** | **61.9%** | **35,305** | **25,455** | **58.1%** |

**Observation.** The two instruments agree within three points on seven of the eight guards, and
disagree by 22 points on the eighth. Pooled, they read 61.9 percent and 58.1 percent.

**Observation.** The spread across guards runs from 17 percent to 99.6 percent. No single guard sits
near the pooled figure, so the pool is a sum rather than a typical case, and a sweep would want the
per-guard column rather than the last row.

## The first finding: read time is not the same thing as reachable time

`topology_relaxed` spends **10.8 seconds inside three processes**. By wall it looks 24 percent
reachable; by process count its read phase carries essentially no churn to collapse, because it is
already one program doing real computation. A resident rebuild has nothing to take there.

**Inference.** The plan's reach is bounded by read time that is *also* process churn, which is
strictly less than read time. Across this sample the correction is small -- 10.8 seconds of 291 --
and the lesson is not. A projection built on the wall column alone would have promised a guard a
speedup it cannot receive, and the wall column is the column anyone reaches for first.

**Inference.** The same guard is an existence proof pointing the other way. One rostered read phase
already runs the way the plan wants them all to run, so the destination is reachable rather than
theoretical, and at least one guard has arrived without anybody sweeping it there.

## The second finding: two of the ten have no read surface at all

`lantern_face` and `glow_preset_offset` carry no scan and no control. Each runs
`tools/g/glow_run_worker.sh` repeatedly -- ten times and seven times -- and that worker lowers,
builds, and runs a Glow desk through the Zig toolchain. Measured this lap: **56.2 seconds in 269
processes** and **53.6 seconds in 180 processes**, which is roughly 200 to 300 milliseconds apiece.
Those are compilations, and they are outside the plan entirely.

**Observation, roster-wide.** Of the 321 guard rows in `construction/standing-equipment.kyri`, 187
name both a scan and a control, 214 name a scan, 226 name a control, and **68 name neither**. So
about one row in five is shaped like the Glow pair rather than like the eight.

**Inference.** Including the two in the pool, the ten sampled guards read **51.4 percent** reachable
by wall. The two cost 107 of the 633 seconds, so 17 percent of the sample's wall belongs to a class
the plan cannot touch.

## What the number is worth, in plain arithmetic

The plan speeds up one fraction of the work and leaves the rest alone, which is Amdahl's law:
`total = 1 / ((1 - f) + f/s)`, with `f` the reachable fraction and `s` the speedup delivered there.
Taking `s = 8.68`, this tree's own paired measurement of the `convergence_census` rebuild:

| reachable share | fleet speedup at s=8.68 |
|---|---|
| 30% | 1.36x |
| 50% | 1.79x |
| **51.4% (measured, ten guards)** | **1.83x** |
| 62% (measured, eight guards) | 2.21x |
| 70% | 2.63x |
| 90% | 4.91x |

**Observation.** The elder falsifier's two thresholds were an Amdahl reading all along, and the
table above is where its 3x and 1.3x came from. Naming that now costs nothing and would have cost a
reader an hour.

**Projection.** A full resident sweep of the roster's read surfaces lands near **1.8x**, with a
hard ceiling of **2.06x** reached only if every read phase became free.
*Horizon:* the current roster, on this pier, through the next season.
*Assumptions:* the ten most expensive guards represent the other 235 in composition; every read
phase accepts the same 8.68x the census accepted; nothing new joins the roster with a different
shape.
*Falsifier:* named in full below.
*Confidence:* moderate on the direction, low on the digit. The sample is the expensive tail rather
than a random draw, and the second assumption is the weak one.

## Why the falsifier failed to settle anything, said plainly

A falsifier earns its keep by having a live edge. This one had two edges and a wide middle, and the
measurement landed in the middle -- so the plan is neither bought nor retired, and the season's
ordering is exactly where it stood. That is my own design fault rather than the measurement's, and
it has a name: a test whose most likely outcome is *neither* is a test that spends a lap to learn
what a lap already suspected.

**What would have been sharper.** One threshold, placed where the decision actually flips. A sweep
of this shape is worth its laps if it returns more than about 2x, since below that the same laps
spent on tiering expensive guards to `cadence` returns more for less risk. A single door at 2x,
rather than a corridor between 1.3x and 3x, would have been answered decisively today by the same
numbers: **1.83x, below the door, so the sweep waits.**

## The sharper falsifier, for the next lap

The weak assumption is that every read phase accepts 8.68x. The census earned that figure with
21,944 processes at 3.33 milliseconds apiece, which is very nearly pure startup. The read phases
measured here run **4.7 to 11.2 milliseconds per process**, and the surplus above startup is real
work that a resident pass still has to do.

**So the test is one rebuild, not ten.** Take `unshared_citation`: 98 percent read share, 8,057
processes, the purest case in the sample and already proven from both sides by its own control.
Rebuild its read phase resident and measure it in interleaved pairs.

- **Above 6x:** the 8.68x generalizes, the ceiling above holds, and the sweep is worth ordering by
  the per-guard column.
- **Between 3x and 6x:** the arithmetic above is over-stated by roughly a third to a half, and the
  fleet answer falls to about 1.4x to 1.6x, which is under the 2x door.
- **Below 3x:** the 8.68x was a property of the census rather than of the pattern, and the plan
  retires on its own evidence.

*Horizon:* one lap. *Assumptions:* the rebuild preserves the guard's reading byte for byte, proven
by diff before the timing is believed. *Confidence:* high that the measurement is decisive, because
the three bands are disjoint and one rebuild produces one number.

## What this paper does not reach

**Whether the roster's other 235 guards are shaped like these ten.** The sample is the expensive
tail, chosen because the tail is where a sweep would pay, and a cheap guard may be mostly Rishi
startup with no read phase worth the name.

**Whether a guard should be faster at all.** A guard that runs in 76 seconds twice a lap is a guard
somebody may simply move to `cadence`, which is a roster decision rather than an engineering one and
costs no laps.

**Anything in the checkable room.** Every figure here is a reading rather than a witness. Nothing
above binds a guard, and nothing above should be cited as though a green pass stood behind it.

---

*May the next falsifier we write have one door in it, and may we place that door where the decision
truly turns.*
