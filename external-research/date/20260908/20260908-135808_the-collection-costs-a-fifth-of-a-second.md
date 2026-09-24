# The Collection Costs a Fifth of a Second

**Language:** EN
**Stamp:** see the filename -- one clock, `America/New_York`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Proposed -- **research for understanding**: every timing here is checkable by rerunning
the named command on this pier, and the single-process roster it proposes is unbuilt. Nothing here
enters the checkable room until a witness binds it ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Kin:** [`20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md`](20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md) -- the fleet-scale cost and the scoping answer -
[`20260908-091705_the-roster-sets-the-cost-not-the-corpus.md`](20260908-091705_the-roster-sets-the-cost-not-the-corpus.md) -- one guard profiled to the statement -
[`20260908-111149_the-fork-bill-is-a-shape.md`](20260908-111149_the-fork-bill-is-a-shape.md) -- the per-item fork pattern, priced

---

## What this measures, and what bounds it

Two papers already stand on this shelf. One asked **which** guards need to run, and found four
fifths of a pass's wall clock unmapped and so out of `--scoped`'s reach. One asked where a
**single** guard's fifteen seconds went, and found a `basename` per tracked file. This paper asks
the question between them: **of the CPU a whole pass burns, how much is the reading, and how much
is the machinery of running it?**

**Bounds, before any number.** Every figure below was measured on the Dallas pier holding
`grain-diffuser`, an AMD EPYC-Rome instance reporting `nproc=8` and 15 GB of memory, on `20260908`
between `13:26` and `13:58` America/New_York, at git nib `de2714f1fd`. The pier held seven other
ships, several running roster passes of their own, so **every reading carries contention**: the
one-minute load average ran between 6.7 and 11.8 on eight cores throughout. Every reading is on a
**warm page cache**. The collection stood at **16,569 tracked files** and **96.8 MB**, by `git ls-files`
and `stat`.

**A CPU-second is not a joule, and this pier cannot tell you the difference.**
`/sys/class/powercap` does not exist on this instance, so no RAPL or `amd_energy` counter was read
and no energy figure appears below. CPU time is the proxy throughout, and its falsifier is named at
the end.

## Observation: the pier creates about eleven hundred processes a second

`/proc/stat`'s `processes` counter holds the number of processes the kernel has created since boot.

| Reading, `20260908.133x` | Value |
|---|---|
| processes created since boot | 279,373,475 |
| uptime | 245,682 s -- 2 days, 20 hours |
| **lifetime mean** | **1,137 per second** |
| spot rate, sampled over 10 s at `13:31` | 1,404 per second |

The spot rate and the lifetime mean agree within a quarter, so this is a **sustained** rate rather
than a spike. The counter is machine-wide and this pier is dedicated to the fleet, so the reading is
safe at the machine level. It carries no per-ship attribution, and none is claimed from it.

## Observation: what one process creation costs

Two loops, same shell, same minute, same load:

| Loop, 2,000 iterations | real | user | sys | CPU each |
|---|---|---|---|---|
| `/bin/true` -- fork, exec, exit | 2.637 s | 0.640 s | 1.176 s | **0.908 ms** |
| `:` -- the shell's own no-op builtin | 0.010 s | 0.006 s | 0.002 s | **0.004 ms** |

**A process creation costs about 227 times what a builtin costs**, and **65% of that cost is system
time** -- page tables, ELF loading, dynamic linking, teardown. `/bin/true` is near the cheapest
executable a system offers, so 0.908 ms is a **lower bound**. Contention pushes the other way, so
read it as a floor measured at a busy moment.

## Inference: an eighth of the machine, standing

Multiply the two observations. At 1,137 creations a second and 0.908 ms of CPU each, process
creation alone consumes **1.03 CPU-seconds every wall second** -- one core of eight, or **about
12.9% of the machine, continuously**.

The inference carries one assumption worth saying plainly: that the pier's average creation costs
about what `/bin/true` costs. Most of them are `grep`, `awk`, `sed`, `git`, and `sh`, every one
larger and linking more, so the true share is **higher**. The figure is a floor and is offered as
one.

## Observation: the collection costs a fifth of a second

Here is the reading that reframes the rest. Reading **every tracked byte in the tree** costs:

| Reading, the whole collection | user | sys | CPU |
|---|---|---|---|
| `git ls-files -z` into `xargs -0 grep -InE '^#!'` | 0.077 s | 0.139 s | **0.216 s** |
| `grep -c` over the same bytes concatenated into one 100 MB file | 0.020 s | 0.026 s | **0.046 s** |
| `git grep -I -n -E '^#!'` -- the worktree | 0.172 s | 0.238 s | 0.410 s |
| `git grep --cached` -- the index, through the object database | 0.994 s | 0.299 s | 1.293 s |
| one `git ls-files` | 0.004 s | 0.007 s | 0.011 s |

The full lap-tier pass measured below cost **1,769 CPU-seconds**. Reading the whole collection once
costs **0.216**. The ratio is **8,190 to 1**.

**So the bytes are not the bill.** The elder paper's title said as much from one guard's profile;
this is the same claim priced at the level of the tree, and the number is larger than the title
suggests.

The `--cached` row earns its own sentence and its own restraint. It costs **6.0 times** the plain
read and **3.2 times** the worktree `git grep`, because it inflates blobs out of the object database
rather than reading page-cached files. It is also **deliberate**: the one scan that uses it says so
in a comment, since the reading is meant to be of the repository rather than of this machine.
Exactly **one** scan of 280 uses it, so the premium across a pass is about **one CPU-second**. It is
priced here, and it is not worth acting on.

## Observation: where a real pass's CPU actually goes

The cold pass this lap opened with was sampled every 20 seconds by reading `cutime` and `cstime` out
of `/proc/<pid>/stat` -- the CPU its reaped children had consumed.

| Wall elapsed | child user | child sys | **sys share** | load |
|---|---|---|---|---|
| 160 s | 113.3 s | 60.6 s | 34.9% | 9.07 |
| 220 s | 162.2 s | 118.5 s | 42.2% | 11.39 |
| 400 s | 240.4 s | 208.2 s | 46.4% | 11.83 |
| **1,622 s -- the close** | **1,050.7 s** | **718.3 s** | **40.6%** | 8.03 |

The pass ran **195 guards in 1,599 guard-seconds** and consumed **1,769 CPU-seconds** in 1,622
seconds of wall clock -- 1.09 cores held for twenty-seven minutes.

**Two fifths of that CPU was spent inside the kernel.** For a workload whose whole job is reading
text, that is the shape of process creation rather than the shape of reading. The contrast sits in
the next section's table: a single `awk` reading the same collection spends **1.1%** of its CPU in the
kernel, and this pass spends thirty-seven times that share.

The rise across the first three samples tracks the rising load average, so part of it is contention
rather than composition. That is named rather than corrected, because contention **is** the fleet's
operating point -- a figure from an idle pier would describe a machine this tree never runs on.

## Observation: no single guard is fork-bound

The tempting next step is to hunt the guard that forks per item. It is not there.

`tools/fixtures/e/exec_bit_scan.sh` sits near the median at 5 seconds in the runs ledger. Traced
with `strace -f -c`:

| Reading | Value |
|---|---|
| `clone` calls -- processes actually created | 75 |
| `execve` calls | 256 |
| of those, failing PATH probes | 190 |
| CPU those 75 creations account for, at 0.908 ms | 0.068 s |
| the guard's own CPU | 2.200 s -- user 1.543, sys 0.657 |
| **fork share of this guard** | **3%** |

The guard is well built: batched `xargs`, `awk` set lookups, one `git grep` rather than a loop. Its
cost is the reading its job asks for. Three quarters of its `execve` syscalls resolve nothing --
the shell walking a long NixOS `PATH` -- and together they are a rounding error beside the 75 that
land.

## Inference: the tax is diffuse, which is why no profile has found it

Set the two observations side by side. The machine gives at least an eighth of itself to creating
processes; no individual guard gives more than a few percent of itself to the same thing. Both are
true, and they agree: **195 guards, each creating dozens to hundreds of processes, is tens of
thousands of creations per pass**, spread so evenly that no profile of any one guard will ever
show it.

That is how two correct papers both walked past it. A profile finds a hot statement. A scope map
finds an unnecessary guard. Neither instrument can see a cost that is one part in thirty of every
guard, everywhere, always.

The cost distribution says it again from the other side. Over the 195 guards of this pass, as
recorded in `construction/standing-equipment-runs.kyri`:

| Reading | Value |
|---|---|
| total | 1,599 guard-seconds |
| mean | 8.2 s |
| median | 3 s |
| maximum | 70 s |
| guards costing 1 s or less | 54 |
| share held by the 10 costliest | 27.0% |

**A flat distribution is a structural cost wearing a hundred small hats.**

## The moonshot: one process, one read, many checks

If the bytes cost a fifth of a second and the machinery costs seventeen hundred, the machinery is
the thing to replace. Here is the floor, measured rather than argued.

One `awk` process, five real checks -- non-ASCII bytes, shebang lines, REDS citations, TODO
markers, qualified asserts -- across all 100 MB in one pass:

| Reading | Value |
|---|---|
| real | 2.123 s |
| user | 2.034 s |
| sys | 0.023 s |
| **sys share** | **1.1%** |

Five checks over every tracked byte, for **two CPU-seconds and almost no kernel time**.

**The proposal, stated so it can be argued with:** a roster runner that reads the tree **once** into
one bounded in-memory collection and answers every text check against that single view, in one process.
This is Tally's own territory -- one arena, one bounded allocation, a named maximum on the collection
size -- and it is Rye-shaped rather than shell-shaped, because the whole saving is the process that
never starts.

**What it would and would not reach.** Of 280 scan fixtures, **92 build or run a program** -- Rye
compiles, witness suites, `rishi` invocations -- and those stay exactly as they are; their cost is
real work. The remaining **188** are text and index reading, and they are the population this
addresses.

**The honest ceiling.** A single `awk` counting regex matches is a floor, not a forecast. Real
guards do set arithmetic against ledgers, sort and compare, read the git index, and check paths on
disk. So the claim worth defending is **an order of magnitude, not four** -- and even that stays a
hypothesis until something is built and measured.

## Three cuts, ranked, each with the measurement that would kill it

1. **A single-process text roster for the 188 non-building scans.** Build five of them into one Rye
   program reading one collection. **Killed if** the five-in-one fails to beat the five guards it
   replaces by at least 5x on the same tree at the same load. Confidence it clears 5x: moderate --
   the `awk` control clears it by a wide margin, and real guards do more than the control does.
2. **A shared collection handed to the shell guards that stay.** 181 of 280 scans call `git ls-files`,
   across 429 call sites; each call is 0.011 CPU-s, so the whole habit costs roughly five
   CPU-seconds a pass. **Killed by its own price** -- this is measured, it is small, and it is
   listed here so nobody spends a round on it. Confidence it is worth doing: low.
3. **Fewer, larger processes inside each shell guard.** The batching `exec_bit_scan` already does is
   the pattern; the open question is how many guards lack it. **Killed if** a survey of the 188 text
   scans finds most already batched. That survey is one lap of work and has not been run;
   `exec_bit_scan` is one good data point arguing the habit may already be common. Confidence:
   unknown, which is the honest word.

The first is the moonshot. The third is the ratchet. The second is named so it can be declined.

## What would refute this paper

- **The proxy.** A CPU-second is not a joule. Run the `/bin/true` and single-`awk` controls on a
  host exposing `intel-rapl` or `amd_energy`, and compare measured joules per process creation
  against the CPU-second proxy. If process creation draws power out of proportion to its CPU time in
  either direction, the 12.9% translates differently and the ranking above may change.
- **The average process.** The 12.9% floor assumes the pier's average creation costs about what
  `/bin/true` costs. Trace `clone` across a whole pass and time the lifetimes, and the multiplier
  moves. It is expected to move **up**, which would strengthen the paper rather than save it.
- **The cache.** Every reading here is warm. A cold-cache pass would raise the collection figure and
  narrow the 8,190-to-1 ratio -- though not by orders of magnitude on a machine holding 11 GB of
  page cache over a 97 MB tree.
- **The prototype.** If a five-guard single-process build lands within 2x of the shell guards it
  replaces, the proposal is wrong and the cost lives somewhere this paper did not look.

## For BAKERY

The buildable piece is cut 1, and it is small: **one Rye program, one bounded collection read, five
checks that already exist as shell scans, and a witness proving the five agree with the five guards
they stand in for, line for line on the same tree.** Agreement first, speed second -- a faster guard
that answers differently is not a faster guard.

What is not buildable yet is everything past those five. The order-of-magnitude claim is a
hypothesis with a named kill condition, and it earns its next round only by clearing 5x on the
first five.
