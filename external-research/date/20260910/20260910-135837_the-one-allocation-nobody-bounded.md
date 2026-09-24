# The One Allocation Nobody Bounded

**Stamp:** `20260910.135837`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Room:** mixed -- the readings below each name the command that reproduces them, and the bound
this paper proposes stays vision until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Status:** Proposed
**Instrument:** [`../tools/fixtures/g/guard_cpu_census.sh`](../tools/fixtures/g/guard_cpu_census.sh)
(new this lap) -- sibling of
[`../tools/fixtures/g/guard_process_census.sh`](../tools/fixtures/g/guard_process_census.sh)
**Kin:** [`20260910-113724_two-rankings-and-this-tree-was-reading-the-wrong-one.md`](20260910-113724_two-rankings-and-this-tree-was-reading-the-wrong-one.md)
(the page whose falsifier this lap runs) --
[`../context/TAME_CORE.md`](../context/TAME_CORE.md) and
[`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)
(this lap's air rota, read for the boundary question) --
[`../tally/README.md`](../tally/README.md) (where bounds live)

---

## What this paper claims, before the argument

**A process is an allocation, and it is the one allocation this tree has never named a maximum
for.** Tally bounds memory. Caravan bounds the dependents alive at one instant, and the restarts a
failing dependent may take. Nothing anywhere bounds the count of programs a run may start, and
this pier's standing roster starts them by the hundred thousand.

Three readings and one built instrument stand behind that.

**The count is the one figure a gate could hold still.** Wall seconds move with whatever the fleet
is doing; joules this pier does not expose; a count of `execve` is the same number on a quiet
machine and a saturated one.

**A cheap classifier reproduces the expensive one.** The process census separates the roster's two
families with ptrace, at two to four times a guard's own wall. The kernel share of a guard's CPU,
read by the POSIX `times` builtin for the price of a shell wrapper, separates them the same way.

**And the bound must be a rate rather than a count.** A count ceiling per guard reds the day a
peer writes a lawful file, which is the defect two other ships booked this week in two other rooms.

---

## What the tree already bounds, and the one thing it does not

TAME's first root rule is one sentence: *every allocation, collection, loop, pipeline names a
**max*** -- named at construction, checked at the edge, refused with a named error
([`../context/TAME_CORE.md`](../context/TAME_CORE.md), stamp `20260811.200854`). Caravan keeps
that rule at three edges at once. A dependent's memory budget is **256 bytes**
(`caravan/bounded.rye:48`). The instantaneous population of dependents is **4**
(`caravan/capabilities.rye:20`), with **2** in flight in `caravan/concurrent.rye:109` and **3** in
`caravan/cohort.rye:105`. A dependent that keeps failing is restarted at most **5** times
(`caravan/bounded.rye:51`).

Read those four together and one shape is missing. Memory has a max. The population alive at any
instant has a max. Restarts of one dependent have a max. **The cumulative count of programs a run
may start has no name anywhere in this tree** -- not in Tally, where bounds live, and not in
Caravan, which owns the spawn seam.

A concurrency bound and a wake bound are different measurements on different axes, in exactly the
sense [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)
uses for simple and easy. A concurrency bound answers *how many at once*, and it protects the
machine from being swamped in a moment. A **wake bound** answers *how many in all*, and it prices
what the run costs from beginning to end. Four dependents at a time, started thirty-four thousand
times, satisfies the first bound completely and is the shape this pier actually pays for.

## Observation one -- the elder sample's falsifier, run

The kin paper set its own falsifier in plain terms: *trace a second stratified sample at a
different step -- every seventeenth rank rather than every twentieth -- and a pooled rate outside 6
to 10 milliseconds per process says sixteen guards were too few to speak for 236.*

```
sh tools/fixtures/g/guard_process_census.sh --every 17
```

**Fourteen guards, 127,258 milliseconds of card wall, 19,942 programs, pooled 6.38 milliseconds per
process.** That sits inside the interval the elder paper named, so the elder sample stands and its
projection stands with it.

| Rank step | Guard | Wall ms | Processes | ms per process |
|---|---|---|---|---|
| 17 | `unshared_citation` | 37,530 | 8,233 | 4.56 |
| 34 | `mantra_weave_annotate` | 25,641 | 207 | **123.87** |
| 51 | `rye_compile_reach` | 18,711 | 6,052 | 3.09 |
| 68 | `mantra_gen_floor_a1_gate` | 13,555 | 134 | **101.16** |
| 85 | `mantra_glow_tend_limb4` | 8,559 | 160 | **53.49** |
| 102 | `signal_trap` | 7,456 | 1,510 | 4.94 |
| 119 | `sow_allow_reach_control` | 4,556 | 1,227 | 3.71 |
| 136 | `shell_dialect_touch` | 3,428 | 890 | 3.85 |
| 153 | `acme_dx` | 2,878 | 244 | 11.80 |
| 170 | `rule_twin` | 2,093 | 556 | 3.76 |
| 187 | `readme_reach` | 1,456 | 255 | 5.71 |
| 204 | `crypto_count_guard` | 971 | 380 | 2.56 |
| 221 | `tube5_mantra_revision` | 350 | 27 | 12.96 |
| 238 | `remember_git_nib` | 74 | 67 | 1.10 |

**The finding survives and its boundary moved.** Pool both samples and thirty guards sort into
**twenty-four** between 1.10 and 12.96 milliseconds per process and **six** between 53.49 and
311.23, with nothing at all in between. The elder gap ran from 8.83 to 57.17, a factor of six and a
half; this sample put 11.80 and 12.96 into its lower side and 53.49 into its upper, so the empty
band is now **12.96 to 53.49** -- a factor of **4.1**, narrower and still empty.

**One thing the wider sample changes materially.** The elder read thirteen of sixteen in the
process-bound family and this reads twenty-four of thirty, so the family's share of the roster
holds at roughly four fifths by count. What moved is the second family's membership: all three of
the new upper-family guards are Mantra witnesses -- `mantra_weave_annotate`,
`mantra_gen_floor_a1_gate` and `mantra_glow_tend_limb4` -- each compiling and running one program
that thinks, which is the same shape `query_wire_retention` wears at the head of the roster.

## The figure that was braided, and the two readings inside it

The kin paper sorted guards by **milliseconds per process** and found two families. That column is
a free numerator over a held denominator: the milliseconds come from the run card and move with
whatever the fleet is doing, while the process count is the same on a quiet pier and a saturated
one. A ratio built that way carries one honest half and one that drifts, and no reader of the
column can tell which half a given digit came from.

Pull it apart and there are two questions wearing one number.

**How many programs does this guard start?** `execve`, counted exactly, load-independent, and the
unit a bound would be drawn in.

**Where does this guard spend its CPU?** The kernel share, load-independent for a different reason
-- both terms of the ratio live inside one guard's own accounting.

Neither needs the other, and each answers a question the pair could only gesture at. The braided
column was good enough to find the families; it is not good enough to draw a line between them,
because the line would sit at a threshold that moves with the pier's load.

## The instrument this lap built, and why it is cheap

`tools/fixtures/g/guard_process_census.sh` answers the count exactly and charges for it: `strace
-f --seccomp-bpf -c -e trace=execve` needs ptrace, and a process-bound guard runs two to four times
its own wall under it -- `unshared_citation` read 37,530 milliseconds on the run card and 143,598
traced, on the same pier within the hour.

`tools/fixtures/g/guard_cpu_census.sh` asks a nearby question for the price of a shell wrapper. It
runs the guard inside `sh -c '<guard>; times'` and reads line two of the POSIX `times` builtin,
which is the cumulative user and system CPU of every reaped child. **The reading is
`sys_share = sys / (user + sys)`** -- the fraction of a guard's CPU spent inside the kernel.

**The hypothesis, stated before the measurement.** Starting a program is kernel work: fork, exec,
map, fault in, tear down. Arithmetic is not. So a guard in the process-bound family should spend
most of its CPU in the kernel, and a guard running one program that thinks should spend most of it
in user space -- and the split the process census bought with ptrace should be visible in a ratio
any shell can read.

**Two properties recommend it over seconds.** CPU time is load-independent, near enough: eight
ships sailing lengthen a guard's wall clock and leave its user and system seconds where they were.
And the reading is a **ratio inside one guard's own accounting**, so even the second-order effects
of a saturated host -- cache pressure inflating user time, a busy scheduler inflating neither --
move both terms rather than one.

**The declared limits, before the table.** `times` counts children the shell has **reaped**, so a
guard that leaves a dependent running past its own exit is undercounted. Cache contention on a
loaded host inflates user time somewhat, which biases `sys_share` **down** for every guard alike --
against this paper's own hypothesis rather than for it. And a guard that reads a slow disk spends
kernel time on IO rather than on `execve`, which is the confound this instrument cannot see and its
strace sibling can.

## Observation two -- the cheap classifier, against the expensive one

```
sh tools/fixtures/g/guard_cpu_census.sh --top 5
sh tools/fixtures/g/guard_cpu_census.sh --every 20
```

**Seventeen guards, 686.8 seconds of child CPU, pooled kernel share 0.380.** Over a third of the
sampled assurance bill is spent inside the kernel rather than computing an answer.

**Four of the seventeen carry a process count from the strace sibling, and two more were run
singly for this comparison -- six pairs in all.**

| Guard | ms per process | `sys_share` |
|---|---|---|
| `query_wire_retention` | 311.23 | **0.071** |
| `mantra_tablecloth_query_wire` | 57.17 | **0.175** |
| `convergence_tree_prove` | 8.22 | 0.385 |
| `readme_metrics` | 7.07 | 0.302 |
| `convergence_census` | 4.00 | **0.574** |
| `fixture_depth` | 2.21 | **0.694** |

**The two orders agree.** Rank the six by milliseconds per process and by kernel share and the
sequences match but for one adjacent swap, between two guards whose rates differ by 1.15
milliseconds. Both members of the compute family read **at or under 0.175**; all four members of
the process-bound family read **at or above 0.302**. Any threshold in that band separates the six
without error, and **0.25** is the round number inside it.

**Applied to the thirteen sampled guards that carry no process count, the classifier answers
this:**

| Reads process-bound (`sys_share` >= 0.25) | Reads compute (`sys_share` < 0.25) |
|---|---|
| `living_docs_roster` 0.718, `tally_caller_map` 0.699, `living_pin_near_bound` 0.687, `link_counted` 0.675, `caravan_roster_bijection` 0.596, `silent_leg` 0.515, `waymark_rung_drift` 0.385, `rish_join_split` 0.367, `shared_pen` 0.319 | `topology_stretch` 0.013, `mantra_weave_v1_write` 0.204, `mantra_glow_tend_limb2` 0.168, `amphora_pour_negative` 0.185 |

**And one corroboration arrives from a direction neither instrument was aimed at.** The Mantra Glow
gates land in the compute family twice over, by different guards under different tools:
`mantra_glow_tend_limb4` reads 53.49 milliseconds per process under strace, and
`mantra_glow_tend_limb2` reads a kernel share of 0.168 under `times`. Two guards of one shape, two
instruments, one verdict.

## Observation three -- the two instruments priced the same seconds

`convergence_census` is where the two instruments check against each other most sharply, since it
is the roster's process champion, and the arithmetic between the readings closes.

It starts **34,593** programs -- traced by the strace sibling on `20260910` between 10:44 and
11:40, per the kin paper's own scope line. A trivial fork plus exec costs about
**2.72 milliseconds** of CPU on this host (measured `20260909` over three runs of 2,000 pairs, cited
by the kin paper). That models **94.1 seconds** of kernel work purely in starting programs.

Its measured system CPU this lap is **152.7 seconds**, beside 113.5 seconds of user time.

**So process starts account for about 62 percent of that guard's kernel time**, and the remaining
58 seconds are the file opens, reads, and closes those programs make once they exist. Two
instruments taken an hour apart, one counting programs and one counting seconds, agree on the same
guard within the slack their assumptions allow.

**This is inference rather than observation**, and its weak joint is the 2.72 milliseconds, a
figure read on an unloaded host and applied to a loaded one. Treat 62 percent as *most, rather than
all* -- which is the shape of the claim that matters, since it says a resident reader would take
back the majority of that guard's kernel time and never all of it.

## Where the programs actually come from, read structurally

The roster names **316** guards and every one of them is a Rishi script -- `awk '$1=="path"'` over
`construction/standing-equipment.kyri` returns 316 paths and 316 `.rish` extensions. Yet only
**five** of those witnesses hold a loop and a `run [` together. The loops are one level down:
**268 of the 316 witnesses (84.8 percent) name a path under `tools/fixtures/`**, and the kin paper
measured **250 of 313 `*_scan.sh` fixtures (79.9 percent)** carrying a loop whose body starts an
external program.

Two independent readings agreeing in direction, and neither one proves a count: a loop cannot tell
you whether it runs over six thousand files or three. What they do settle is **where a wake bound
would have to be checked** -- in the scan fixtures, which is where the tree's own shell loops live,
rather than in the witnesses that read as thin wrappers around them.

---

## The shape a wake bound must take, and the two shapes it must refuse

**A per-guard count ceiling is the obvious form, and it is the one form this tree already knows to
be wrong.** A guard that reads 1,127 authored sources three times over starts 3,381 programs, and
the day somebody writes the 1,128th source it starts three more. A ceiling on that count reds on a
peer's lawful file. That shape was named twice this week on the live card -- BAKERY's
`unnamed_population` pinned by equality, which rose seven times in three days as other lanes wrote
runners, and five dated equinox guards that pin counts of a growing surface and now read red. A gate that reds on ordinary work is a gate somebody turns off, so a count ceiling would
buy one week of attention and then be disabled.

**A per-item rate is the true invariant.** The honest statement is *this guard starts k programs
per item it examines*, and k is a property of how the guard is written rather than of how large the
tree has grown. `rune_assert_sweep` is the tree's own worked example: three `grep` calls per file
across 1,127 sources is k = 3 and 3,381 programs; three list-wide readings plus `comm` is six programs
whatever the population, so k falls to effectively zero -- which took that witness from 47.4 to 2.0
seconds
([`../context/TAME_CORE.md`](../context/TAME_CORE.md), measured `20260908.161651`). A rate is
load-independent and growth-independent at once, which no other figure in this arc manages.

**Its cost is a number a guard declares about itself.** Reading k needs an item count, and 316
roster rows do not carry one. A field a guard fills in is a field a guard can fill in wrongly, and
nothing would catch it -- which is the unheard-guard shape this fleet has spent two days on:
BAKERY's `unheard_guard_witness` one room over, and PATCHOULI's silent leg one level below that.

**So the affordable first instrument is neither.** It is a **census column**, reported and gated
nowhere: every guard's programs-started beside its sys share, printed each pass, argued over by
hands. A number nobody enforces still moves behavior when it is visible, and this tree has the
receipts -- the `unnamed_population` floor, the ratchets that only fall, the ceiling that made a
sweep worth taking. Gate it later, at the rate, for guards born after the word.

## The proposal, in the form a hand could seat

**Named where bounds live, checked where programs start.** Tally is the tree's home for a bound
that any module may import without taking on a dependency ([`../tally/README.md`](../tally/README.md)),
and Caravan owns the spawn seam. So a wake bound reads as one constant and one check:

```
tally: pub const max_wakes: u32 = <a number a hand argues for>;
caravan: assert(wakes < tally.max_wakes) at the spawn edge, refused with a named error
```

That is TAME root rule 1 said in Rye rather than in English -- named at construction, checked at
the edge, refused with a name -- for the one allocation the rule has never reached.

**Three questions belong to Keaton rather than to a lap.**

**First, whether the bound is enforced at all, or only counted.** A count printed every pass moves
behavior without ever refusing lawful work, and this tree has watched a reported figure do exactly
that. An enforced bound stops a run, which is the only thing that actually caps a bill.

**Second, whose bound it is.** A Caravan supervisor spawning dependents is a different population
from a roster pass spawning guards, and the second is where the seconds are. A constant in Tally
serves the first honestly and reaches the second only if the roster runner asks it.

**Third, the number.** Nothing in this paper derives one. What it derives is the unit -- programs
started, load-independent, countable exactly -- and the shape that unit must wear if a gate is
ever hung on it: a rate per item, never a count per guard.

---

## What holds these figures still

**Process counts are held by their own nature.** A count of `execve` reads the same on a quiet
machine and a saturated one. Every guard here was traced while eight ships sailed and a full roster
pass ran beside them.

**Kernel shares are held by being a ratio inside one accounting.** Load lengthens a guard's wall
clock without moving its user and system seconds much, and what load does move it moves in the
direction that works against this paper's hypothesis: cache pressure on a busy host inflates user
time, which pushes every `sys_share` **down**.

**Wall figures are free.** `card_wall_ms` was read at `20260910.095049` under whatever the fleet was
doing that minute, and `probe_wall_ms` under whatever it was doing during this lap. Both are printed
for scale and neither is offered as a finding.

**The roster's own composition is free.** 316 guards, every one a `.rish` path, read from
`construction/standing-equipment.kyri` by `tools/fixtures/s/standing_equipment_run.sh` on every
pass. Run the awk line rather than trusting the number here: the roster grows most weeks.

## The projection, with its terms

**Horizon:** the coming season, while the fleet holds at eight ships and the roster grows past 316
guards.

**Assumptions:** the guards sampled here speak for the roster; guards stay shell-shaped, delegating
their loops to scan fixtures; this pier keeps 8 vCPU and exposes no energy counter.

**The claim:** a standing pass is priced in programs rather than in seconds, that price is
countable exactly and load-independently, and the kernel share of a guard's CPU sorts guards into
the two families for the cost of one shell wrapper -- so triage across all 316 guards is a single
affordable pass rather than sixteen traced ones.

**The falsifier, stated as a number:** run `guard_cpu_census.sh` across the roster and find a guard
whose `sys_share` and whose `ms_per_process` disagree about which family it belongs to. A handful
of disagreements at the boundary is a threshold to argue over; a scatter with no separation says
the cheap classifier is dead and `strace` remains the only instrument.

**Confidence: moderate** for the classifier, which rests on a sample small enough to name in one
sentence and a gap wide enough to survive its own noise. **Low** for any single threshold value,
which this paper deliberately declines to fix.

## What this arc does not reach

**Whether a guard's programs are worth starting.** A wake count prices a run and says nothing about
what the run proves. `unshared_citation` starts 8,233 programs and holds a real wall at zero across
the living surfaces; the count is a bill rather than a verdict.

**Joules, and the reason is measured rather than assumed.** On this pier `/sys/class/powercap`
does not exist and `/sys/class/hwmon` is empty, read `20260910.140224`, so the guest sees no energy
counter and no thermal one either -- an ordinary property of a virtual machine rather than a fault.
An energy claim here would be a model wearing a measurement's clothes. A process count is what this
machine actually answers, which is why the bound is drawn at that edge and not at the one a
moonshot would prefer.

**The other seven ships.** Every figure here is the Dallas pier's, read while eight ships sailed. A
clone on other hardware would read different seconds and, this paper predicts, the same counts.

## What this hands the next lap

**Buildable today, by any ship.** `guard_cpu_census.sh` runs across the whole roster in one pass at
no more than the roster's own cost, since it adds a shell wrapper and nothing else. That pass would
give 316 kernel shares and turn this paper's six-pair validation into a real distribution.

**Buildable after a word.** A `wakes` column on `construction/standing-equipment-runs.kyri`,
written by the runner and gated nowhere, so the pier's own run card carries the count beside the
seconds it already carries.

**Waiting on Keaton.** Whether Tally names `max_wakes` at all; whether it is counted or enforced;
and whose population it bounds -- Caravan's dependents, the roster's guards, or both.
