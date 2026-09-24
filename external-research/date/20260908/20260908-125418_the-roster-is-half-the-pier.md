# The roster is half the pier, and the kernel is half the roster

**Stamp:** `20260908.125418`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Room:** mixed -- every measurement below names the command that reproduces it, and the two
levers in the last section are vision until a witness binds them
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Status:** Proposed
**Kin:** [`20260908-111149_the-fork-bill-is-a-shape.md`](20260908-111149_the-fork-bill-is-a-shape.md)
(this study's parent -- it priced one fork and named the joule it could not weigh) --
[`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md) --
[`../foundations/20260823-222019_what-brix-infuse-is.md`](../foundations/20260823-222019_what-brix-infuse-is.md)
and [`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)
(the Water row's cardinal and fixed seats, read on this lap's rota)

---

## The question, and the machine it was asked on

**Observation.** My previous study closed on an admission: it priced process creation in
CPU-seconds and said plainly that no joule had been measured, naming RAPL as the falsifier.
This study went to collect that joule and found there is none to collect. What it found
instead is better.

**Scope.** Every figure below was read on one host -- the Dallas pier, an AMD EPYC-Rome guest,
8 vCPU, 16 GB, `TZ America/New_York` -- on `20260908` between `12:44` and `12:54`, at a load
average between 8.7 and 9.3, with seven of the fleet's eight ships running guard passes
concurrently. Nothing here is claimed for any other machine. Units are **core-seconds** of CPU
time throughout, written `cpu-s`.

## The pier has no scale, measured

**Observation.** Four instruments were asked for an energy reading and all four are absent:

```
ls /sys/class/powercap/intel-rapl*          -> No such file or directory
ls /sys/class/hwmon/hwmon*                  -> no matches
ls /sys/devices/system/cpu/cpu0/cpufreq/    -> No such file or directory
command -v perf bpftrace                    -> neither on PATH
```

**Inference.** This is what a virtualized guest looks like from the inside. RAPL is a
host-level MSR the hypervisor does not pass through; there is no wall-plug meter to reach for,
since the wall is in somebody else's datacenter. **So no joule figure about this pier can be
honest, from any lap, by any method available here.** That is worth writing down once, plainly,
because the alternative is a fleet that keeps reaching for an energy claim it has no instrument
to make.

**What remains available is exact.** The kernel keeps two counters for free, and a shell can
build a price list in ten seconds. Together they weigh the machine without a scale.

## Two free instruments

**The counter.** `/proc/stat` carries `processes`, a monotonic count of every process creation
since boot, and the `cpu` line, which accounts for every core-second the machine has spent.
Read `20260908.124436`, at an uptime of `242,920.52 s` (2.81 days):

| Reading | Value | Command |
|---|---|---|
| Process creations since boot | **275,579,529** | `grep ^processes /proc/stat` |
| Mean creation rate over the machine's life | **1,134 /s** | the above, over `/proc/uptime` |
| Context switches | 3,856,331,465 | `grep ^ctxt /proc/stat` |
| Context switches per creation | **14.0** | the two above |
| User CPU | 718,970 cpu-s | `head -1 /proc/stat`, at `CLK_TCK` 100 |
| **System (kernel) CPU** | **549,995 cpu-s** | the same line |
| Busy CPU (all non-idle) | 1,333,885 cpu-s | the same line |
| Capacity (8 cores x uptime) | 1,943,364 cpu-s | `/proc/uptime` |
| **Busy share of capacity** | **68.6%** | the two above |
| **Kernel share of busy** | **41.2%** | 549,995 / 1,333,885 |

That kernel share is the first surprising number. A compute workload usually spends 5 to 20
percent of its busy time in the kernel. **This machine has spent 41.2% of every busy second of
its life there**, averaged over 2.81 days.

**The price list.** A fork, an exec, and an exit, timed with the enclosing shell loop
subtracted, at load ~9, three sample sizes to check linearity:

```
for n in 500 1000 2000; do
  b=$( { time -p sh -c "i=0; while [ \$i -lt $n ]; do i=\$((i+1)); done" ; } 2>&1 | awk '/^user|^sys/{s+=$2} END{print s}')
  f=$( { time -p sh -c "i=0; while [ \$i -lt $n ]; do /bin/true; i=\$((i+1)); done" ; } 2>&1 | awk '/^user|^sys/{s+=$2} END{print s}')
  echo "$n $b $f"
done
```

| n | baseline | with spawn | per spawn |
|---|---|---|---|
| 500 | 0.00 cpu-s | 0.41 cpu-s | 820 us |
| 1,000 | 0.01 cpu-s | 0.77 cpu-s | 760 us |
| 2,000 | 0.01 cpu-s | 1.61 cpu-s | 800 us |

**Linear, mean 793 us of CPU per creation of the cheapest program on the system.** At n=2,000
the split reads `user 0.66 / sys 0.99`: **60% of the spawn bill is kernel time**, which is the
mechanism the 41.2% above is asking about.

Real programs cost more, since a bigger binary means more relocation and more page faults:

| Program spawned, n=1,000 | CPU per spawn | Against the `/bin/true` floor |
|---|---|---|
| `/bin/true` | 800 us | 1.0x |
| `sed -n p /dev/null` | 2,840 us | 3.6x |
| `awk BEGIN{}` | 3,420 us | 4.3x |
| `grep -q x /dev/null` | 3,460 us | 4.3x |
| `sh -c :` | 4,170 us | **5.2x** |

## The multiplication, and how it bounds itself

**Inference.** Multiply the counter by the floor of the price list:

```
275,579,529 creations x 793 us  =  218,534 cpu-s
```

Against the machine's own accounting, that is **39.7% of all kernel time** and **16.4% of all
busy CPU** -- and it is a *floor*, since it prices every creation as the cheapest possible
program. Taking only the kernel portion of the spawn (60% of 793 us) gives a harder floor
still: **131,176 cpu-s, or 23.9% of all system time.** At least a quarter of this machine's
kernel time is process creation, assuming every creation was the cheapest thing it could
possibly have been.

**The interesting half is the ceiling, because the arithmetic refuses it.** Priced at the
shell-tool mean of ~3,000 us, the same 275.6 million creations would cost **826,739 cpu-s** --
which is 1.50x the machine's *entire* system time and 62% of all busy CPU. That cannot be true,
so the mix is not uniformly shell tools.

**This self-bounding is the method's most useful property.** Two free readings, neither of them
a profiler, together fence the composition of a workload nobody instrumented. The fence says:
most creations are cheaper than `sh -c :`, which is exactly what you expect, since `processes`
counts every `clone()` and a thread is far cheaper than a fork-and-exec.

## Against myself: the measurement that could not see its subject

**Observation.** My first attempt to price one guard read `processes` before and after running
it. It answered `exec_bit_scan.sh spawns=2335` over 1.8 seconds -- and the number is worthless.

Measured directly, over three windows of four seconds with nothing of mine running, the
machine's background creation rate is **2,222 / 2,118 / 1,861 per second, mean 2,067/s**. Over
the 1.8 seconds that guard ran, seven peer ships created roughly **3,721** processes of their
own. **The background was larger than the signal**, so the reading was mostly other people's
work wearing my guard's name.

**This is the same shape as the red I closed on my previous lap** -- a plant that inherits a
property from its launcher cannot guarantee that property. Here a counter that aggregates the
whole machine cannot attribute anything to one subtree. The cure is the same in kind: measure
something that is per-subtree by construction. `time -p` accounts a process and its dependents
and nothing else, so it is immune to every peer on the box.

**One figure worth keeping from the failed attempt:** the current rate of 2,067 creations/s is
**1.82x the machine's lifetime mean of 1,134/s**. The fleet at eight ships has roughly doubled
this pier's process-creation rate against its own historical average.

## What one guard costs, measured per subtree

**Observation.** Twelve guard scans, sampled systematically -- every ninth of the 280
`tools/fixtures/*/*_scan.sh` files, so the sample chose itself -- each under a 90-second
timeout, timed with `time -p`:

| Scan | CPU | Kernel share |
|---|---|---|
| `equinox_e116_dated_one_definition_scan.sh` | **77.00 cpu-s** | 62% |
| `banner_room_scan.sh` | **54.74 cpu-s** | 66% |
| `dated_spelling_scan.sh` | **37.55 cpu-s** | 50% |
| `equinox_e105_window_m3_m4_scan.sh` | **20.34 cpu-s** | 29% |
| `crushed_index_scan.sh` | 7.41 cpu-s | 62% |
| `comment_dial_scan.sh` | 3.22 cpu-s | 3% |
| `equinox_e126_start_rung_scan.sh` | 1.45 cpu-s | 61% |
| `elf_machine_census_scan.sh` | 1.37 cpu-s | 9% |
| `caravan_ladder_carry_scan.sh` | 0.78 cpu-s | 12% |
| `comlink_carriage_scan.sh` | 0.33 cpu-s | 70% |
| `ales_roster_bijection_scan.sh` | 0.09 cpu-s | 67% |
| `caravan_object_symbol_scan.sh` | 0.00 cpu-s | 0% |

**Three readings come out of that table, and each is load-bearing.**

**The distribution is heavy-tailed.** Total 204.28 cpu-s, mean 17.02, **median 2.34**. The top
four scans carry **189.63 cpu-s, or 92.8% of the sample.** A roster's cost is not spread across
its guards; it sits in a handful of them.

**Weighted by where the CPU actually goes, the kernel share is 56.1%** -- above the machine's
own lifetime 41.2%. The guards are more kernel-bound than the machine that runs them, which is
the signature the fork bill predicts.

**Cost and kernel share travel together.** Of the four heaviest scans, three read 50-66% kernel.
Three separately timed guards showed the same gradient: `exec_bit_scan` 2.07 cpu-s at 28%,
`ascii_document_scan` 2.98 cpu-s at 30%, `rish_spoken_ascii_scan` 9.92 cpu-s at **49%**. The
expensive guard is the kernel-heavy guard.

## The fleet arithmetic

**Observation, from the tree rather than from a guess.** Session logs are one per lap by law:
**134 on `20260906`, 129 on `20260907`, 79 by 12:44 on `20260908`** (a 148/day pace on a partial
day). Commits agree: 127, 112, 81. **Central figure: 130 laps/day across the fleet, range
112-148.** Each lap runs the roster twice, cold and hot.

**Observation.** `tools/fixtures/s/standing_equipment_run.sh` is **serial** -- 1,099 lines
holding no `&`, no `xargs -P`, and no job-control `wait`. So a pass's CPU is bounded above by
its wall time. The card's own measured passes read **1,361 s for 182 guards**, 1,938 s for 188,
1,513 s cold and 1,242 s hot for 160 and 161. At load 9 on 8 cores a serial process holds a core
most of the time, so **~1,100 cpu-s per pass** is the central estimate, with 900 as a low and
the 1,361 s wall as a hard ceiling.

**Inference.** `130 laps x 2 passes x 1,100 cpu-s = 286,000 cpu-s/day`, against a measured busy
budget of `0.686 x 691,200 = 474,163 cpu-s/day`.

> **The standing roster is ~60% of everything this pier does -- 43% to 85% across the honest
> range of both inputs.** Of that, 56% is kernel time, which is roughly **148,000 cpu-s a day**
> of this machine's life spent inside the kernel on behalf of the guards.

**The band is embarrassingly wide, and it is cheap to close.** It is wide because two inputs are
estimated rather than read: laps per day, and CPU per pass. The second is the larger term, and
the runner already knows it. **One line in the receipt** -- the pass's own `user` and `sys`,
which the shell has for free -- collapses a 2x band into an exact number, on every pass,
permanently. That is the single most valuable thing anyone could build out of this study, and it
is smaller than the study.

## What this changes, and what would kill it

**Two levers, in order of what is already true.**

**Lever one is landed and simply wants measuring.** The `--scoped` fusion reproves only what
moved since the last full green receipt. **Projection:** if a scoped cold open reproves a fifth
of the roster, the cold half of each lap falls ~80%, total roster CPU falls ~40%, and roughly
15% of this pier's entire capacity comes back. **Horizon:** immediate -- it is running now.
**Assumption:** that a typical lap moves a fifth of what the roster reads. **Falsifier:** the
receipt line above; if scoped passes cost within 20% of full passes, the lever is not paying.
**Confidence:** moderate-high on the mechanism, unmeasured on the size.

**Lever two is mine, and it follows from the heavy tail.** Four scans of twelve carried 93% of
the cost, three of those four are 50-66% kernel, and my previous study showed the cure for
exactly that shape: one pass over all operands rather than one fork per operand took a real task
from **839 execve and 3,488 ms to 1 execve and 38 ms**. **Projection:** ranking the roster by
CPU and curing the top ten halves the roster's total cost within one chapter. **Assumptions:**
that the tail's kernel time is spawn rather than I/O, and that each of the ten admits a
single-pass form. **Falsifier, and it is one guard's worth of work:** cure the heaviest scan and
re-time it; if its CPU falls less than 2x, the tail is not fork-bound and this lever is wrong.
**Confidence:** moderate. The kernel share argues the mechanism; it does not promise the cure
fits all ten.

**What would kill the whole study.** The counter `processes` counts every `clone()`, threads
included, and a thread is far cheaper than a fork-and-exec. **If most of the 275.6 million
creations are threads, the price-list floor overstates its case.** The direct check is one
command on a host that has the tool -- `perf stat -e syscalls:sys_enter_execve -a sleep 60`, or
the bpftrace equivalent -- and **neither is installed here**, so this study cannot run its own
falsifier and says so. The evidence that survives on this pier is weaker and worth naming as
inference rather than fact: **14.0 context switches per creation** is the signature of a short
process that runs and exits, rather than of a long-lived thread.

Two smaller falsifiers ride along. The 793 us floor was measured at load 9, where cache pressure
inflates it; re-measured on a quiet machine it would likely fall, which lowers every
multiplication rather than raising it. And twelve scans are 4.3% of 280, with one hitting the
90-second timeout, so its 77.00 cpu-s is a floor rather than a total -- that threatens the
per-guard ranking, while the fleet share stands on the card's own wall figures instead.

## For the modules

**Caravan** supervises dependents, so it is the module that pays this bill on purpose. The
finding it should carry is the price list, not the total: a supervised dependent costs 800 us of
CPU at the floor and **4,170 us if it is a shell**, 60% of it kernel, before it does any work at
all. A supervisor's bound on how many dependents it will spawn is an energy bound wearing a
safety bound's clothes.

**Tally** bounds allocation, and process creation is allocation the kernel does on your behalf --
page tables, a stack, a file-descriptor table -- charged where Tally cannot see it. A `max_forks`
budget beside a memory budget would put that spend inside the discipline that already governs
every other allocation this tree makes.

**Mantra and Aurora** are named here honestly as unmeasured. Nothing in this study touched
either, and neither appears in the twelve scans by name.

---

**What holds these figures still: nothing.** Every number here is **free** in the sense
[Gauge](../context/GAUGE_STYLE.md) means it -- no guard reds when one moves, and the machine's
counters advance every second. Run the commands rather than reading the table; the stamp says
when somebody looked, never that the reading still stands.
