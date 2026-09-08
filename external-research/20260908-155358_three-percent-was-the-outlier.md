# Three Percent Was the Outlier

**Language:** EN
**Stamp:** see the filename -- one clock, `America/New_York`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Proposed -- **research for understanding**: every count and timing below is checkable by
rerunning the named command on this pier, and the single-process roster it argues for is unbuilt.
Nothing here enters the checkable room until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Kin:** [`20260908-135808_the-collection-costs-a-fifth-of-a-second.md`](20260908-135808_the-collection-costs-a-fifth-of-a-second.md)
-- the paper that named this falsifier and left it unrun -
[`20260908-111149_the-fork-bill-is-a-shape.md`](20260908-111149_the-fork-bill-is-a-shape.md) -- the
per-item fork pattern, priced -
[`20260907-215928_the-falsifier-that-was-never-run.md`](20260907-215928_the-falsifier-that-was-never-run.md)
-- why a named kill condition is worth nothing until somebody runs it

---

## What this runs, and what bounds it

The paper before this one ranked three cuts at the fork bill and gave each a kill condition. Its
third cut -- **fewer, larger processes inside each shell guard** -- carried the honest word
*unknown*, because its falsifier was a survey nobody had run: *killed if a survey of the 188 text
scans finds most already batched*. One guard, `exec_bit_scan`, gave 3% of its CPU to process
creation, and one guard was the whole evidence.

**This paper runs that survey, and then checks it against metal.** The survey's answer is that most
are not batched. The metal's answer is larger and different: **three percent was the outlier**.
Twelve of twelve scans sampled give between 18% and 42% of their CPU to creating processes, and the
costliest one measured spends **10.6 CPU-seconds** starting processes in a single run.

**Bounds, before any number.** Every figure was measured on the Dallas pier holding
`grain-diffuser`, an AMD EPYC-Rome instance reporting `nproc=8` and 15 GB of memory, on `20260908`
between `15:22` and `15:40` America/New_York, at git nib `82281186a7`. The pier held eight ships,
several running roster passes, and a full pass of this tree's own roster ran throughout: the
one-minute load average read **12.4 on eight cores**. Every reading is on a warm page cache. The
collection stood at **16,605 tracked files** by `git ls-files`.

**A CPU-second is not a joule, and this pier still cannot tell you the difference.**
`/sys/class/powercap` is absent on this instance, so no RAPL counter was read and no energy figure
appears below. CPU time is the proxy, and its falsifier is named at the end.

**One constant is borrowed rather than remeasured.** The cost of a single process creation,
**0.908 ms of CPU**, comes from the prior paper's 2,000-iteration `/bin/true` loop on this same
pier. The pier's creation rate reproduces cleanly beside it -- `/proc/stat` read at `15:28` gives
289,477,062 processes over 252,675 s of uptime, a lifetime mean of **1,145 per second** against the
prior reading of 1,137 -- so the machine is in the same state the constant was taken in.

## The population, reproduced

`git ls-files 'tools/fixtures' | grep '_scan\.sh$'` returns **280** scan fixtures. Stripping comments
and asking which invoke a compiler or an interpreter --

```
sed 's/#.*//' "$f" | grep -qE '(^|[^-a-z])(rye|rishi|zig)([ /]|$)'
```

-- answers **94 build or run a program**, leaving **186 text-and-index scans**. The prior paper read
this split as 92 and 188; the two-file difference is a wording difference in the pattern, named here
rather than reconciled, because nothing below turns on it.

## Method: what the static test asks, and what it cannot see

For each scan, an `awk` pass finds loop headers -- `while read`, `for x in` -- tracks depth to the
matching `done`, and asks whether the loop body invokes an external command from a fixed list
(`basename`, `grep`, `sed`, `awk`, `cut`, `stat`, `git`, `find`, `xargs`, and the rest of the usual
hands). Three verdicts follow: **per_item** when a loop body forks, **loop_no_fork** when a loop runs
on shell builtins alone, and **batched** when there is no such loop at all.

**Two limits, stated before the counts.** The test is a **lower bound**: it finds forks written
inside a visible loop body and misses forks inside a shell function the loop calls, forks in
repeated straight-line code, and forks inside a program the scan runs. Both false negatives in the
sample below are of exactly that kind. And the test is **blind to iteration count** -- a loop over
sixteen thousand tracked files and a loop over twelve rooms read identically. The metal sample
answers the second limit; the first stays open and makes every count below a floor.

## Observation: most text scans are not batched

| Verdict | All 280 scans | The 186 text-and-index scans |
|---|---|---|
| **per_item** | 127 | **90** -- 48% |
| batched | 106 | 64 -- 34% |
| loop_no_fork | 47 | 32 -- 17% |

**The falsifier is not met.** Cut three dies if *most* text scans are already batched; a third are,
by a test that can only undercount. The ratchet survives.

## Observation: a third of a pass's seconds sit in that class

The static verdict is a property of a file. What a pass costs is a property of the clock, so the two
are joined here: each of the 260 rostered guards in `construction/standing-equipment.kyri` names a
witness, each witness names at most one scan fixture, and the last full pass recorded in
`construction/standing-equipment-runs.kyri` -- 196 guards at stamp `20260908.143237` -- gives each
guard its seconds.

| Class | Guards | Seconds | Share of the pass |
|---|---|---|---|
| batched | 66 | 676 | 37.6% |
| **per_item** | **51** | **579** | **32.2%** |
| unmapped -- the witness names no scan | 59 | 416 | 23.1% |
| loop_no_fork | 20 | 129 | 7.2% |
| **total** | **196** | **1,800** | |

**The join is not sensitive to that first-named choice.** Twenty-two of the 170 mapped witnesses
name more than one scan; classing each by its **worst** scan instead moves the per_item share from
**32.2% to 33.8%** and the batched share from 37.6% to 33.6%. The finding is the same either way, so
the simpler join is reported above.

**Roughly a third of a pass's guard-seconds run in scans that fork inside a loop.** The unmapped
quarter is witnesses that build or run a program directly, and their cost is the work itself.

## Observation on metal: twelve of twelve, between 18% and 42%

Twelve scans were traced with `strace -f -c -e trace=clone,clone3,vfork` for process creations, then
timed with `time -p` for CPU, both while the roster pass ran. Ten were drawn from the two-to-eight
second band of the runs ledger so they would finish under trace; two were drawn from the slow tail
on purpose, to test whether the band was flattering the reading. Fork CPU is creations times
0.908 ms.

| Scan | Static verdict | Creations | CPU s | Fork CPU s | Fork share |
|---|---|---|---|---|---|
| `declared_ceiling` -- slow tail | per_item | 11,716 | 25.070 | 10.638 | **42%** |
| `amphora_bounds_agree` | per_item | 281 | 0.620 | 0.255 | **41%** |
| `commit_message_guard` | batched | 1,071 | 2.590 | 0.972 | **38%** |
| `fleet_key_locality` | per_item | 327 | 0.840 | 0.297 | **35%** |
| `glow_gate_answer` | per_item | 229 | 0.750 | 0.208 | **28%** |
| `fascia_home_link` | per_item | 124 | 0.420 | 0.113 | **27%** |
| `ales_roster_bijection` | batched | 24 | 0.090 | 0.022 | **24%** |
| `compass_station` | batched | 24 | 0.090 | 0.022 | **24%** |
| `loop_prompt_parse` | loop_no_fork | 204 | 0.930 | 0.185 | **20%** |
| `dated_pattern` | per_item | 112 | 0.530 | 0.102 | **19%** |
| `fleet_roster` | loop_no_fork | 6 | 0.030 | 0.005 | **18%** |
| `crushed_index` -- slow tail | per_item | 2,577 | 7.120 | 2.340 | **33%** |

**Every scan sampled gives at least a fifth of its CPU to starting processes.** The static test
predicts the absolute cost well -- its per_item class holds the top of the table -- and it does not
predict the floor, because the floor is everywhere.

**The slow tail is worse, not better.** `declared_ceiling` starts **11,716 processes** in one run
and spends **10.6 CPU-seconds** doing it, which is nearly five times the entire CPU of
`exec_bit_scan`, the guard the prior paper read as evidence that no guard is fork-bound. A roster
runs twice a lap, cold and hot, so that single guard costs about **21 CPU-seconds a lap** in process
creation alone.

## Inference: the share is a ratio, and the prior reading held the denominator

`exec_bit_scan`'s 3% is arithmetic rather than virtue. Its 75 creations cost 0.068 CPU-s against
**2.200 CPU-s** of its own work -- one `git grep` across the whole collection. The share is small
because the denominator is large, not because the numerator is.

Turn that around and the ten readings above stop being surprising. A scan that reads a roster of
twenty rooms does little reading and starts dozens of processes, so its ratio is high on a small
base. A scan that reads a hundred megabytes starts a few dozen processes and its ratio is low on a
large base. **The absolute fork bill tracks the number of items walked, and the share tracks how
much reading rides along with each fork.**

Both numbers matter, and they answer different questions. The **share** says how much a given guard
would gain from batching. The **absolute seconds** say what the pass would gain. On this sample the
absolute range is 0.005 to 10.638 CPU-s, which is three orders of magnitude, so a ratchet that fixes
the top of that range and skips the bottom is doing nearly all of the available work.

## Inference: a high share is not the same as waste

`commit_message_guard` sits third from the top at 38% and **should not be touched.** It feeds the
real shipped `tools/hooks/commit-msg` a planted message for every shape that matters -- twenty-five
cases, refusals and welcomes alike -- and each case is a process because the thing under test is a
process. Its forks are its job.

That is the line the survey has to hold: **forks spent reading the collection are the target; forks
spent running the thing under test are the work.** The static test happens to select the first kind,
which is why its false negatives -- `commit_message_guard` and `loop_prompt_parse`, both running
programs per planted case -- are false negatives worth having. A test that flagged them would be
proposing to break the guards that prove the tree can red.

## What this changes in the arc

The prior paper's section heading read *no single guard is fork-bound*, on the strength of one
guard. That heading was true of the guard it measured and does not generalize. The corrected
statement, measured on ten:

> **A shell guard on this pier gives a fifth to two fifths of its CPU to process creation, and the
> exceptions are guards that do heavy reading per fork.**

The machine-level floor from the prior paper -- at least 12.9% of the pier's CPU spent creating
processes -- and this guard-level reading now agree from two directions rather than pulling apart.
One arithmetic bridge is available, and its assumption is stated rather than hidden: the class
weighting is in **wall seconds** from the runs ledger while the sample shares are in **CPU**, so
multiplying them assumes the two track each other across guards. Under that assumption the per_item
class at 32.2% and a mid-sample share near 28% accounts for roughly **9% of a pass's CPU**, and the
remaining classes at their own shares carry the total toward the machine-level floor. That is the
arithmetic one would want. It is an estimate resting on an assumption a single tracing pass over the
whole roster would replace with a measurement, and it is offered as an estimate.

## The three cuts, re-ranked by what was measured

1. **A single-process text roster for the 186 non-building scans** -- unchanged as the moonshot, and
   better supported: 90 of the 186 fork per item, and the sample says those forks are a fifth to two
   fifths of what those scans spend. **Killed if** a five-in-one Rye program fails to beat the five
   guards it replaces by 5x on the same tree at the same load. Confidence it clears 5x: **moderate**,
   unchanged -- this survey raises the size of the prize rather than the odds of the build.
2. **A shared collection handed to the shell guards that stay** -- still declined, still by its own
   price.
3. **Fewer, larger processes inside each shell guard** -- **survives its falsifier and rises.** The
   survey it waited on has been run: a third of text scans are batched, not most. Confidence:
   **moderate-to-high** that batching the ten costliest per_item scans returns real seconds, since
   the absolute fork bill in the sample spans two orders of magnitude and the top of that range is
   where the whole gain sits. **Killed if** batching the three costliest per_item scans returns less
   than a tenth of their measured CPU each.

**The ranking flips for the next lap.** Cut three is now the cheap, checkable one -- it needs no new
program, only a rewrite of a loop -- and cut one is the durable one. The order to work them is cut
three first as the ratchet, cut one as the moonshot behind it, exactly as Lindy-first, crux-first
would place them: the hardest solvable problem is the roster; the ratchet is what keeps the tree
honest while it is built.

## What would refute this paper

- **The static test's blindness.** It reads shell text and cannot see a fork inside a function the
  loop calls. Trace all 186 text scans with `strace -f -c` and count creations directly; if the
  per_item class does not separate cleanly from the batched class on real creation counts, the 32.2%
  weighting is measuring a property of shell style rather than a property of cost. Horizon: one lap.
  Expected direction: the classes stay separated and the batched class rises, which widens the
  problem rather than closing it.
- **The borrowed constant.** 0.908 ms per creation is a `/bin/true` figure. The processes these
  scans start are `grep`, `git`, and `awk`, which cost more to load. Every fork share above is
  therefore a **floor**, and remeasuring with a real mix would move all ten readings up. If it moves
  them *down*, the constant was wrong and this paper's headline weakens.
- **The sample size.** Twelve scans of 186. Ten were chosen for a two-to-eight-second duration in
  the runs ledger so they would finish under trace, which is a selection this paper's first draft
  named as its weakest sentence; two slow-tail scans were then traced to test it, and both read
  **higher** than the band rather than lower. The claim is about the twelve, and the extrapolation
  to the class remains the weakest sentence here -- it is now supported at both ends of the cost
  range rather than at one.
- **The proxy.** A CPU-second is not a joule. On a host exposing `intel-rapl` or `amd_energy`,
  compare measured joules per creation against the CPU-second proxy. If creation draws power out of
  proportion to its CPU time, every share above translates differently.
- **The denominator argument.** If a guard is found with few creations, little reading, and a high
  share, the ratio explanation is incomplete. None appeared in ten.

## What BAKERY can build from this, and what it cannot

**Buildable now, no new law:** batch the loop bodies in the three costliest per_item scans --
`declared_ceiling` at 11,716 creations is the place to start -- and measure before and after with the
same two commands used here. That is cut three, it is a ratchet
under `.claude/rules/reds-first.md` rather than a red, and its kill condition is written above.

**Not buildable from this paper:** the single-process roster. It needs a bounded Rye collection
reader under Tally -- one arena, one named maximum, one pass over the tree -- and this paper adds
evidence for the prize without adding a line of it. It stays a hypothesis with a named kill
condition until something runs.

**Not proposed at all:** touching a guard whose forks are its job. `commit_message_guard` runs the
shipped hook twenty-five times because that is what proving both directions costs, and a paper that
counted its processes without reading it would have sent a lap to break the tree's own wall.
