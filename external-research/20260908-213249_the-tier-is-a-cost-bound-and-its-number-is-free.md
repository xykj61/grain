# The Tier Is a Cost Bound, and Its Number Is Free

**Stamp:** `20260908.213249`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Proposed, **research for understanding** -- the census is checkable, the energy reading
and the proposal stay proposed until a witness binds them
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Instrument:** [`../tools/fixtures/t/tier_cost_drift_census.sh`](../tools/fixtures/t/tier_cost_drift_census.sh)
**Kin:** [`the-bound-that-names-a-joule`](20260905-232224_the-bound-that-names-a-joule.md) -- the
paper that argued extent bounds and cost bounds are different questions, and left this measurement
unrun

---

## What this paper claims, before the argument

**Every `tier` field in the standing roster is a cost bound, the only kind this tree has, and the
number behind it is free in Gauge's own sense: nothing holds it still.** Twenty of 271 guard rows
state the cost their tier was decided on. Twelve of those twenty can be checked against this pier's
own run card, and **six of the twelve have moved** -- one from a stated 14 seconds to a measured 47.

**The instrument that found the drift over-reads by about a fifth, and the drift survives the
correction.** The runner times each guard with `date +%s`, so it records wall seconds on a pier
where eight ships share eight cores. Two of the drifted guards were re-run with the shell's `times`
builtin reading child CPU time beside the wall clock. `shared_pen` came back **53s wall against
43.8 CPU-seconds**; `module_room_reach` came back **8s wall against 6.7 CPU-seconds**. Both still
stand well above what their rows claim.

**So the tree cannot say what its own discipline costs in joules, and the reason is one measurement
in one loop.** Wall time is a reading of the host's contention as much as of the work; CPU time is
the invariant, and CPU time is also what converts to energy. The change is one shell builtin and no
forks.

**Scope.** Everything measured here was measured on one pier -- an 8-vCPU AMD EPYC-Rome guest -- on
`20260908`, under a load average between 9.3 and 12.1. The paper leaves guard correctness entirely
alone: a guard that costs more than its row says may still be worth every second.

---

## What a tier is, from first principles

A guard on `tier lap` runs on every roster pass. A guard on `tier cadence` runs on the fifth round.
Nothing else distinguishes them, so the field answers exactly one question: **how often may this
work be done?**

That is a bound with a time denominator -- a rate -- and the roster's own header says why it exists:
*COST DECIDES THE TIER, AND SO DOES WHAT IS MOVING*. A cheap guard on the fast clock costs little
and catches faults early. An expensive guard on the fast clock taxes every lap of every ship. The
field is where that trade is settled.

**This is the tree's only cost bound, and it lives outside every program.** The bound-kind census
run today over 642 distinct named bounds in authored Rye answers `energy_names=0`, `rate_names=3`,
`duration_names=3`, `work_names=26`, and `extent_names=610`
([`../tools/fixtures/b/bound_kind_census.sh`](../tools/fixtures/b/bound_kind_census.sh),
`20260908`). The companion paper predicted the shape and declined to test it. The shape holds, and
the interesting part sits beside it: the one real cost governor this tree runs is a data field in a
roster, expressed as a cadence, and no census of bounds would ever have found it.

## What the roster states, and what it leaves unstated

`construction/standing-equipment.kyri` carries 271 guard records. Each names a path, a seating
stamp, and -- for 209 of them -- a tier word, with the rest defaulting to every run. Many rows
justify their tier in a comment, and dozens of those justifications carry a measured figure:
*"measured 3s -- cheap enough to run every lap"*, *"105s measured here 20260829.175031"*,
*"runs 111 rungs in 8m31s"*.

Read by [`../tools/fixtures/t/tier_cost_drift_census.sh`](../tools/fixtures/t/tier_cost_drift_census.sh)
on `20260908.213249`:

| Reading | Count |
|---|---|
| guard records | 271 |
| rows stating a cost figure | **20** |
| rows stating none | 251 |
| rows on the lap tier / the cadence tier | 201 / 70 |
| stating rows, by tier | 15 lap / 5 cadence |
| rows whose stated high is 4x their stated low or more | **7** |

**Two hundred fifty-one cost decisions state no cost.** That is the first reading, and it needs no
comparison to be interesting: a tier is a claim about expense, and seven rows in eight make it
without a number.

**Seven of the twenty that do state one cannot drift.** A row keeps its elder figures on purpose --
accretion is the law -- so a row that has been measured four times states a range. `scope_trace`
spans 4 to 58 seconds; `glow_desk_run` spans 1.38 to 325. Any plausible measurement falls inside.
The accretion is honest and it spends the check, which is a trade worth seeing rather than
averaging away.

## What has moved

The runner writes `construction/standing-equipment-runs.kyri` -- one `ran <name> <stamp> <verdict>
<tier> <seconds>` line per guard, untracked, per pier. That card is the measured side. Holding the
stated figures against it:

| Reading | Count |
|---|---|
| comparable | **12** |
| agree | 6 |
| measured above the stated high | **4** |
| measured below the stated low | 2 |
| stated under two seconds, below the card's whole-second grain | 1 |
| cadence rows this pier has ever recorded | **0** |

The four that read high:

```
detail: over shared_pen         stated 14-14s  measured 47s
detail: over glow_desk_reach    stated 9-9s    measured 25s
detail: over module_room_reach  stated 3-3s    measured 9s
detail: over ascii_document     stated 2-4s    measured 5s
```

**Half the checkable cost figures no longer hold.** Each was true the day a hand typed it, and each
has gone on justifying a tier ever since.

**And the cadence tier is unchecked entirely.** This pier's run card holds 199 rows and every one
reads `lap`. The 70 cadence guards -- the ones whose prose carries the largest figures, the choirs
at eight and nine minutes apiece -- have no measured record here at all. The rows that cost the most
are the rows this pier has never re-read.

## The instrument is a reading of the pier

`date +%s` before a guard and `date +%s` after it measures **wall time**: the work divided by
whatever share of the host the guard could get. This pier runs eight ships against eight cores, and
the load average during every measurement above sat between 9.3 and 12.1. So a rising figure has two
possible causes -- the guard grew, or the pier filled -- and the card cannot tell them apart.

The shell's `times` builtin reports cumulative child CPU time, user and system, with no fork. Both
readings, taken on `20260908` at load 11.8 and 12.1:

| Guard | Stated | Card (wall) | Re-run wall | Re-run CPU | Wall over CPU |
|---|---|---|---|---|---|
| `shared_pen` | 14s | 47s | 53s | **43.8s** (28.9 user + 14.8 sys) | 1.21x |
| `module_room_reach` | 3s | 9s | 8s | **6.7s** (3.0 user + 3.7 sys) | 1.19x |

**The hypothesis this paper opened with was half wrong, and the measurement says so.** Contention
inflates the wall reading by about a fifth on this pier at this load -- real, worth correcting, and
far too small to explain a 14-second row measuring 44 CPU-seconds. Both guards grew. The instrument
also misleads. Neither finding cancels the other.

## Why CPU seconds, beyond reproducibility

**Energy is the second reason, and on the targets this tree aims at it is the first.** A joule spent
is roughly the active power of a core multiplied by the seconds that core was actually busy.
CPU-seconds is that quantity directly. Wall seconds on a loaded host counts time the guard spent
waiting, which costs nobody anything.

So a run card recording CPU-seconds would give this tree the reading it has never had: what its own
discipline costs to run, in a unit that adds up across guards, across ships, and across days, and
that converts to energy under one stated assumption.

**Observation.** The last full close on this pier measured 1,645 wall-seconds across 199 lap-tier
guards. The fleet wrote 129 session logs on `20260907` and 139 so far on `20260908`, and a lap runs
the roster twice -- cold at the open, hot after staging.

**Inference.** If the ~20% wall-over-CPU ratio measured on two guards holds across the pass, a full
pass costs on the order of 1,370 CPU-seconds, and the fleet spends on the order of 350,000
CPU-seconds -- near 100 core-hours -- per day on standing guards alone.

**Projection.** At an assumed 5 to 15 watts per busy core for this class of part, that is between
0.5 and 1.5 kilowatt-hours per day. **Horizon:** the current fleet shape, eight ships on one pier.
**Assumptions:** the two-guard ratio generalizes; per-core power sits in the stated bracket; laps
continue near 130 a day. **Falsifier:** a `times` reading taken across a whole pass, which would
settle the first assumption in one run; a host exposing RAPL, or a wall meter, would settle the
second. This bench exposes neither -- `/sys/class/powercap` is absent, checked. **Confidence:** low
on the kilowatt-hours, moderate on the core-hours, high on the wall-seconds.

## The buildable half

**One.** Record CPU-seconds beside wall-seconds in the run card. `times` costs no fork, where the
current pair of `date` calls costs two per guard. The card's format grows one field; every existing
row stays readable.

**Two.** Let the tier read from the card rather than from a comment. A guard's row would carry the
measurement the runner took, at the stamp it was taken, and a census could hold the stated figure
against the recorded one on every pass -- which is what this paper did by hand once.

**Three.** Give the cadence tier a measured record. Zero of 70 is the gap most worth closing, since
those rows carry the largest claims and the least evidence.

**What stays unbuilt, and named so a later lap can take it.** This census has no witness and sits on
no roster row. It reads a guard's own record and cannot tell whose cost a number in a comment
describes -- `sow_allow_reach` names 778 seconds for a whole cold pass, and `scope_trace` names 58
seconds for a trace of a different guard. Every such row prints as a detail line, and a hand
confirms. Attribution by hand is the honest state today.

## What this does not reach

**Whether any guard is worth its cost.** A 44-second guard that catches a fault worth an hour is a
bargain, and nothing here weighs the catch against the spend.

**Whether the drifted guards grew for a good reason.** `shared_pen`'s reach widened, by its own row's
account. Growth that follows a widened corpus is the guard doing more work, honestly; the fault is
that the row went on quoting the old number.

**Any pier but this one.** Every figure here is one pier's, on one day, under a load nobody chose.
Which is the paper's own argument, applied to itself.

---

*May the numbers this tree keeps be numbers it can re-read, and may the cost of care be a thing we
can add up.*
