# The Seconds This Pier Actually Spends

**Stamp:** `20260910.072912`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Room:** mixed -- the readings are checkable and each names the command that reproduces it; the
proposal in the last section is vision until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Status:** Proposed
**Instrument:** [`../tools/fixtures/p/pier_work_census_scan.sh`](../tools/fixtures/p/pier_work_census_scan.sh)
**Kin:** [`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md)
(the page this lap answers) --
[`20260908-111149_the-fork-bill-is-a-shape.md`](20260908-111149_the-fork-bill-is-a-shape.md) --
[`20260908-093333_the-fork-you-pay-per-item.md`](20260908-093333_the-fork-you-pay-per-item.md) --
[`../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md`](../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md)
(the Aether row's fixed seat, read on this lap's rota)

---

## What this paper claims, before the argument

**This pier spends nearly all of its capacity proving itself, and about half of that inside the
kernel.** Five days ago
[`the-bound-that-names-a-joule`](20260905-232224_the-bound-that-names-a-joule.md) named a gap in
its own scope: *whether any current program in this tree is wasteful -- that is a measurement
nobody here has taken.* This lap takes it at the scale the tree actually runs on, and leaves an
instrument behind so anyone can take it again.

Three readings came back. **One standing pass of the guard roster cost 2,286 CPU seconds**, by
the runner's own accounting. **The machine ran 88 to 97 percent busy with 42 to 48 percent of
that time in the kernel**, at **1,300 to 2,100 process creations per second**. And **the fleet's own
standing equipment accounts for the bulk of it** -- between 52 and 90 percent of busy CPU across
windows, by an attribution whose shape is named below.

**Scope.** One host, the Dallas pier: `AMD EPYC-Rome`, 8 vCPU, Linux 6.18.41, on `20260910`
between `06:45` and `07:27` America/New_York, with eight ships sailing and at least two cold
roster passes running throughout, one of them my own. Every figure here is **free** -- nothing
holds it still, and it moves with whatever the fleet is doing this minute. Run the instrument
rather than citing a number off this page.

---

## Observation one -- the tier this host reads at

A joule needs a meter, and the tree already seats a guard that asks whether one is present.
`tools/e/energy_instrument_witness.rish` classifies a host as `joules`, `counters`, or
`cpu_seconds`, and it reads by opening each counter and requiring digits back rather than by
finding a path. Its scan on this pier, `20260910.071900`:

```
powercap_domains=0   hwmon_energy=0   supply_power=0   rapl_perf_events=0   msr_device=no
hw_cycles=yes        hw_instructions=yes              perf_event_paranoid=2
joule_source=none    tier=counters
```

**This host reads at the `counters` tier.** Hardware cycle and instruction counters are reachable
through `perf_event_open`; no energy source is. Two further absences, checked directly the same
morning and outside that guard's subject: the `perf` binary is not installed, and
`/sys/devices/system/cpu/cpu0/cpufreq` does not exist, so frequency and governor are unreadable
too.

**The inference this licenses, and no more:** every energy figure taken from this pier is a
figure about a proxy. **The projection:** the piers this fleet is likely to rent will read the
same way, since the absence follows from virtualization rather than from this host's
configuration -- RAPL reads model-specific registers a hypervisor does not pass through.
**Falsifier:** a rented VPS of this class whose `/sys/class/powercap/` publishes a moving
`energy_uj` to an unprivileged reader. **Confidence: high** for the mechanism, **moderate** for
the generalization, which rests on one host.

---

## Observation two -- what one roster pass costs

The standing runner reports its own bill. This lap's **scoped** cold pass, closing at
`20260910.072600`:

```
guards_run=210  guards_seconds=2344  guards_cpu_ms=2286099
guards_green=203  guards_red=6  skipped_scope=23
```

**2,286 CPU seconds over 2,344 seconds of wall.** That is 0.98 CPU seconds per wall second: one
full core, held for thirty-nine minutes, by one ship, on the reduced pass. Eight ships share this
pier.

Three individual scans, child CPU by the shell's own `times`, three runs each, spread under 4
percent:

| Scan | CPU seconds | Kernel share |
|---|---|---|
| `tools/fixtures/p/prose_register_scan.sh` | 1.12 | 40 percent |
| `tools/fixtures/e/exec_bit_scan.sh` | 1.84 | 30 percent |
| `tools/fixtures/a/ascii_document_scan.sh` | **26.1** | **50 percent** |

The roster holds **309 guards**, **95** of them at `tier cadence`.

---

## Observation three -- where the machine's seconds go

Two samples of `/proc/stat` bracketing a 126-second window, `20260910.065200`:

| Reading | Value |
|---|---|
| Busy | **88.0 percent of 8 cores** |
| User | 44.0 percent of capacity |
| System | **41.6 percent of capacity** |
| Idle | 11.9 percent |
| Process creations | **2,049 per second** |
| Context switches | 16,368 per second |
| Interrupts | 13,514 per second |

A 25-second window through the instrument itself, `20260910.070000`, read **96.8 percent busy**,
**47.6 percent of busy time in the kernel**, and **2,140 process creations per second**. `uptime`
at `06:59` read a one-minute load average of **12.99 on 8 cores**.

**The kernel share is the reading to sit with.** On a machine doing arithmetic, system time is
overhead. Here it stands level with user time, and the sibling papers already named the
mechanism: this tree's guards are shell scans, and a shell scan pays a process per item it
inspects.

**A trivial process costs 2.72 ms of CPU here**, mean of three runs of 2,000 `fork` plus `exec`
pairs of `/run/current-system/sw/bin/true`, timed by `times` at `20260910.065600`, roughly 80
percent of it kernel time. The pier was saturated throughout, which inflates that figure by an
unknown amount; a quiet machine reads lower.

---

## Observation four -- what the counters count

Two cautions, because a number is worth what its definition is worth.

**`processes` in `/proc/stat` counts forks and clones**, so a thread creation raises it exactly as
a new process does. It is an upper bound on process creations. The tree's fork papers reach the
separated quantity with `strace -f -c -e trace=execve,clone`.

**Per-seat CPU is lumpy, and calling it a lower bound would have been the tidier mistake.** A
process gains a descendant's time in `cutime` and `cstime` at `wait`, so a seat running a long
pass reads near zero while it runs -- the instrument caught that on its own author, my tree
reading `cpu_s=0.0` while my roster pass held a full core. The other half showed up on the next
run: at the reap the parent receives the pass's **whole lifetime**, including the part spent
before the window opened. A 22-second reading at `20260910.073600` answered
`fleet_share_of_busy_pct=129.5`, with one seat alone at **102.9**.

So a seat's share is exact only over a window long enough to hold whole passes, and a share above
100 reads as a reap rather than as a fault. The instrument prints that sentence itself when it
happens. **The machine-level lines carry no such caveat** -- `/proc/stat`'s counters are exact
over any window, which is why the busy, kernel, and process-creation figures above stand while
the per-seat split is reported with its shape named. The same effect is why the fleet total moved
between **52 percent** of busy CPU on one window and **90 percent** on another.

---

## The inference, kept separate from the readings

**The fleet's assurance is this pier's workload.** That is an observation about where seconds land
rather than a complaint -- the guards catch real faults, and this tree's ledger records them by
the hundred. The inference is narrower: **the tree's proving has grown large enough to be an
engineering subject in its own right**, priced in the same currency as the software it proves.

**The projection**, with its terms. **Horizon:** the coming season, while the fleet holds at eight
ships and the roster keeps growing. **Assumptions:** guards stay shell-shaped, laps keep their
present cadence, the pier keeps 8 vCPU. **The claim:** a resident reader -- one process that opens
the tree once and answers many guards' questions -- would remove the kernel half of this bill
rather than the whole bill, since the user half is real reading. **Falsifier:** implement one
representative guard as a single long-lived process and measure its CPU seconds against the shell
form on the same tree; a saving under a factor of two says the bill is not the shape claimed here.
**Confidence: moderate.** The direction rests on three independent measurements in this tree; the
size rests on one microbenchmark taken under load.

---

## What this hands the modules

**Buildable now, and small.** The instrument this paper leaves behind is POSIX shell over
`/proc`, and it reports rather than gates. A guard gating on a free figure would red on whatever
the fleet happened to be doing, which is a guard somebody turns off.

**Buildable next, for Caravan.** A supervisor knows exactly how many processes it starts. A
counter there turns *the pier creates two thousand processes a second* into *this supervisor
started N of them*, and attribution is what separates a repair from a mood.

**Buildable next, for Tally.** The bound-everything discipline holds two axes, extent and work.
The elder paper argued for a third; this one supplies its first measurement. A **wake bound** --
how often may this thing come alive -- is the axis a pier at 97 percent busy is missing, and it is
checkable at an edge in a way a joule is not.

**Reachable here, and unused.** The `counters` tier means instructions retired can be read on this
pier through `perf_event_open`. Instructions are a sturdier energy proxy than CPU seconds, since
they ignore how long a process waited for a core, and this pier waits constantly. Nothing yet
reads them for anything larger than a self-scoped probe.

**Not available here.** Anything requiring joules. The meter is absent, and a proxy named honestly
beats a joule figure invented from one.

---

## Kin

- [`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md) -- the page that named this measurement as untaken.
- [`20260908-111149_the-fork-bill-is-a-shape.md`](20260908-111149_the-fork-bill-is-a-shape.md) -- the per-item mechanism behind the kernel share.
- [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md) -- a figure carries unit, date, source, and what holds it still.
