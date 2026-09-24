# Two Rankings, and This Tree Was Reading the Wrong One

**Stamp:** `20260910.113724`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Room:** mixed -- every reading below names the command that reproduces it, and the adoption
proposal in the last section stays vision until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Status:** Proposed
**Instrument:** [`../tools/fixtures/g/guard_process_census.sh`](../tools/fixtures/g/guard_process_census.sh)
**Kin:** [`20260910-072912_the-seconds-this-pier-actually-spends.md`](20260910-072912_the-seconds-this-pier-actually-spends.md)
(the page this lap answers) --
[`20260908-093333_the-fork-you-pay-per-item.md`](20260908-093333_the-fork-you-pay-per-item.md) --
[`../foundations/20260826-024942_the-grain-and-the-crossing.md`](../foundations/20260826-024942_the-grain-and-the-crossing.md)
(the Aether row's dual seat, read on this lap's rota)

---

## What this paper claims, before the argument

**A guard's seconds and a guard's processes are two different rankings, and this tree has been
planning against the first while paying the second.** Yesterday a lap rebuilt the single most
expensive *scan* on the roster as one resident process and measured a **17.4x** saving, which
answered the falsifier the elder paper set and left a larger question standing: is that saving
the roster's shape, or one guard's?

Three readings answer it.

**The bill is diffuse.** The most expensive guard is **6.0 percent** of a standing pass. Ten
guards make **27.8 percent**. Reaching two thirds takes **50 of 236**.

**The roster is bimodal.** Sixteen guards traced across the ranking split cleanly into two
families with an empty gap between them: thirteen create a process every **2.06 to 8.83
milliseconds** of their own wall time, and three take **57 to 311**. The first family is paying
for processes. The second is doing arithmetic.

**And the head sits on the wrong side.** `query_wire_retention` is **first by seconds and twelfth
of sixteen by processes**. The guard a seconds-ranking nominates first is the guard a resident
reader would help least.

**Scope.** One host, the Dallas pier: `AMD EPYC-Rome`, 8 vCPU, Linux 6.18.41, on `20260910`
between `10:44` and `11:40` America/New_York, eight ships sailing, load average 13 to 17
throughout. Wall figures are **free** and move with whatever the fleet is doing. Process counts
are **load-independent**, which is the whole reason this lap counts them.

---

## Observation one -- the shape of the bill

`construction/standing-equipment-runs.kyri` records what each guard cost on this pier's last full
pass, `20260910.095049`. It is untracked and per pier on purpose, so a fresh clone reads *never
run here* rather than inheriting another machine's memory.

```
awk '$1=="ran"{print $7+0, $2}' construction/standing-equipment-runs.kyri | sort -rn
```

**236 guards, 2,556,664 milliseconds of wall time, a median guard at 3,734.** The roster names
**315**; the pass this card records ran 236 of them, since a `tier cadence` row pays every fifth
round rather than every one and two rows stand behind a custody gate.

| Head | Wall ms | Share of the pass |
|---|---|---|
| top 1 | 153,436 | **6.0%** |
| top 5 | 478,576 | 18.7% |
| top 10 | 709,613 | **27.8%** |
| top 20 | 1,051,021 | 41.1% |
| top 50 | 1,737,600 | **68.0%** |
| top 100 | 2,271,003 | 88.8% |

**A second pass reproduces the shape.** The cold open of `20260910.104457`, run for this lap and
finishing 237 green with 2 gated, read **239 guards over 2,686,633 milliseconds**: top 1 at
**6.4 percent**, top 10 at **27.5**, top 50 at **67.7**, with `query_wire_retention`,
`convergence_census` and `lantern_face` heading it in the same order. Two passes an hour apart,
under different load, differ by under half a point at every depth -- so the concentration is a
property of the roster rather than of a minute.

**This is the number a repair plan needs first.** Rebuilding the single worst guard perfectly --
to zero seconds -- buys back one twentieth of a pass. Rebuilding ten buys back a little over a
quarter. A strategy of *fix the expensive ones* has to reach fifty guards before it holds two
thirds of the cost, and fifty rebuilt guards is a season rather than a lap.

---

## Observation two -- the two families

The probe traces the witness the roster actually runs, counting `execve` exactly with
`strace -f --seccomp-bpf -c -e trace=execve`. It counts programs started rather than forks, since
a fork that never execs is a subshell and a thread raises the same counter as a process.

```
sh tools/fixtures/g/guard_process_census.sh --top 5
sh tools/fixtures/g/guard_process_census.sh --every 20
```

**Five heads and eleven guards sampled every twentieth rank, sixteen in all, holding 22.3 percent
of the pass:**

| Rank | Guard | Wall ms | Processes | ms per process |
|---|---|---|---|---|
| 1 | `query_wire_retention` | 153,436 | 493 | **311.23** |
| 2 | `convergence_census` | 138,380 | **34,593** | 4.00 |
| 3 | `lantern_face` | 69,306 | 669 | **103.62** |
| 4 | `convergence_tree_prove` | 61,602 | 7,496 | 8.22 |
| 5 | `readme_metrics` | 55,852 | 7,898 | 7.07 |
| 20 | `glow_desk_reach` | 29,236 | 10,959 | 2.67 |
| 40 | `mantra_tablecloth_query_wire` | 20,297 | 355 | **57.17** |
| 60 | `plant_liveness` | 15,145 | 3,279 | 4.62 |
| 80 | `one_clock` | 8,506 | 2,327 | 3.66 |
| 100 | `module_room_reach` | 6,756 | 1,220 | 5.54 |
| 120 | `fleet_call` | 3,725 | 422 | 8.83 |
| 140 | `rishi_run_record` | 2,834 | 771 | 3.68 |
| 160 | `fleet_key_locality` | 2,132 | 556 | 3.83 |
| 180 | `socket_dialect` | 1,373 | 665 | 2.06 |
| 200 | `amphora_first_resident` | 753 | 89 | 8.46 |
| 220 | `fixture_depth` | 281 | 127 | 2.21 |

**Pooled: 569,614 milliseconds over 71,919 processes, 7.92 milliseconds apiece.**

Sort that last column and the gap is the finding. Thirteen guards fall between **2.06 and 8.83**.
Three stand at **57.17, 103.62 and 311.23**. Between 8.83 and 57.17 there is a factor of six and a
half with **nothing in it** -- so this is two populations rather than one spread.

**The boundary has a plain meaning.** A trivial fork plus exec costs about **2.72 milliseconds**
of CPU on this host, measured yesterday over three runs of 2,000 pairs. A guard spending 2 to 9
milliseconds per process is spending most of its life starting programs; a guard spending 57 to
311 is running one program that thinks. `query_wire_retention` starts 493 programs in 153
seconds because it compiles `comlink/query_wire_retention_cost.rye` once and then runs seventeen
paired samples against a retired-instruction counter inside that one program; `lantern_face`
compiles and runs a Rye application the same way.

---

## Observation three -- the two rankings disagree at the top

Rank the same sixteen by processes rather than seconds:

| By seconds | By processes |
|---|---|
| 1. `query_wire_retention` | 1. `convergence_census` (34,593) |
| 2. `convergence_census` | 2. `glow_desk_reach` (10,959) |
| 3. `lantern_face` | 3. `readme_metrics` (7,898) |
| 4. `convergence_tree_prove` | 4. `convergence_tree_prove` (7,496) |
| 5. `readme_metrics` | ... 12. `query_wire_retention` (493) |

**`query_wire_retention` falls from first to twelfth of sixteen, and `glow_desk_reach` rises from
twentieth to second.** The two orders share `convergence_census`, `readme_metrics` and
`convergence_tree_prove` near their tops and disagree about everything else.

That is why a repair plan drawn from the run card alone would have opened with the one guard in
the head that a resident reader cannot help.

---

## What holds these figures still, and what does not

**Process counts are held by their own nature.** A count of `execve` is the same on a quiet
machine and a saturated one. Every guard here was traced while eight ships sailed and a full
roster pass ran beside them, and that load moved no digit in the process column.

**Wall figures are free.** The run card's milliseconds were read at `20260910.095049` under
whatever the fleet was doing that minute, and the `ms per process` column inherits that freedom.
The bimodality survives it easily -- a factor of six and a half is not a load artifact -- while
any single rate in the table is worth roughly what one loaded reading is worth.

**Traced wall time is reported and never used.** The probe prints `traced_wall_ms` beside the
card's figure, and the ratio between them reads 1.06 for one guard and 2.28 for another with no
relation to process count, which is load variance rather than ptrace overhead. Naming it a
measurement of overhead would be the tidier mistake.

**A structural cross-check, offered as inference rather than observation.** Of **313** tracked
`*_scan.sh` fixtures, **250 (79.9 percent)** contain a loop whose body starts an external
program. That agrees in direction with thirteen of sixteen traced guards landing in the
process-bound family, and it proves nothing on its own: the pattern cannot tell a loop over six
thousand files from a loop over three.

---

## The inference, kept separate from the readings

**The resident-reader saving is real and it is a pattern rather than a fix.** Thirteen of sixteen
traced guards carry the shape it addresses, and those thirteen hold **57.3 percent** of the
sampled wall time. The other **42.7 percent** belongs to three guards that are running real
compute, where opening the tree once saves nothing at all.

**So the roster wants a triage before it wants a rewrite**, and the triage is one column wide.
Milliseconds per process sorts every guard into *this one pays for processes* or *this one is
doing work*, and the sixteen traced here suggest the sort is nearly free of ambiguity.

**The projection, with its terms.** **Horizon:** the coming season, while the fleet holds at
eight ships and the roster keeps growing. **Assumptions:** the sixteen sampled guards represent
the 236, guards stay shell-shaped, the pier keeps 8 vCPU. **The claim:** a full standing pass
creates on the order of **320,000 processes**, extrapolating the pooled 7.92 milliseconds apiece
across 2,556,664 milliseconds; roughly three fifths of that is reachable by the resident-reader
shape, and the reachable part would need something like **fifty** guards rebuilt to hold two
thirds of the bill. **Falsifier:** trace a second stratified sample at a different step -- every
seventeenth rank rather than every twentieth -- and a pooled rate outside 6 to 10 milliseconds
per process says sixteen guards were too few to speak for 236. **Confidence: moderate** for the
bimodality, which rests on a gap wide enough to survive its own noise; **low** for the 320,000,
which is one ratio carried a long way.

**The second falsifier, and it is the one worth running.** Rebuild `convergence_census` -- 34,593
processes, the roster's process champion in this sample -- as a resident reader and measure it
against its shell form. **A saving under a factor of three says yesterday's 17.4x belonged to
that guard's item count rather than to the shape**, and the pattern is worth less than the
rewrite it asks for.

---

## What this hands the modules

**Buildable now, and small.** A `ms per process` column beside the run card's seconds. The run
card already holds the wall figure and this probe holds the count, so the triage is a join rather
than a new instrument.

**Buildable next, for Caravan.** A supervisor knows exactly how many programs it starts, so this
count belongs there as a running total rather than in a ptrace harness anybody has to remember to
attach. Yesterday's page asked Caravan for the same thing from the machine's side; this is the
per-guard half of it.

**Buildable next, for Tally.** The bimodality is a **bound waiting to be named**: a guard
declaring how many programs it may start is checkable at an edge, cheap to read, and refuses in
the one direction that matters. A guard that begins forking per item after a careful rewrite
would red on the lap it regressed.

**Not reachable here.** Whether the compute-bound family is itself wasteful. Three guards spending
seconds inside real programs is a different question with a different instrument, and this paper
does not touch it.

---

## Kin

- [`20260910-072912_the-seconds-this-pier-actually-spends.md`](20260910-072912_the-seconds-this-pier-actually-spends.md) -- the page that priced the pass and set the falsifier this lap ran.
- [`20260908-093333_the-fork-you-pay-per-item.md`](20260908-093333_the-fork-you-pay-per-item.md) -- the per-item mechanism the process-bound family is made of.
- [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md) -- a figure carries unit, date, source, and what holds it still.
