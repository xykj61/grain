# The pier that cannot hear its own joules

**Stamp:** `20260917.203312` -- **Status:** Landed -- **Room:** checkable -- every reading below is
emitted by one scan under one green witness.
**Language:** EN -- **Style:** Gauge, Field setting -- **Voice:** Kyri
**Grades:** row 6 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Instrument:** [`../tools/fixtures/e/energy_readout_scan.sh`](../tools/fixtures/e/energy_readout_scan.sh),
proven by [`../tools/fixtures/e/energy_readout_control.sh`](../tools/fixtures/e/energy_readout_control.sh)
under [`../tools/e/energy_readout_witness.rish`](../tools/e/energy_readout_witness.rish).

---

## The sentence this answers

Row 6, "Joules as a Tally unit," proposed that energy join bytes as a bounded quantity a lap could
declare the way it declares an allocation. Its own assumption named the one thing that would have
to be true before any Rye witness could be written:

> **Assumptions.** This pier's CPU exposes RAPL counters to a reader with the permissions we have;
> the counter resolution is fine enough for one lap.

Of the ladder's twelve rows, ten already carry a measured erratum, and row 6 is the check that
sentence was still waiting on.

## The method: ask five doors rather than one

A Linux host offers several paths to its own energy counters beside RAPL, so the scan probes all
five, each independently, before concluding anything about the row's approach as a whole:

- **powercap** -- `/sys/class/powercap/intel-rapl:*/energy_uj`, the sysfs interface most kernels
  expose when RAPL support is built in and the reader needs no special privilege.
- **msr** -- `/dev/cpu/0/msr`, the raw model-specific-register device node RAPL predates powercap
  with, gated by the `msr` kernel module and `CAP_SYS_RAWIO`.
- **perf** -- the `perf` binary plus a `power/energy-pkg/`-shaped event, gated by
  `/proc/sys/kernel/perf_event_paranoid`.
- **hwmon** -- `/sys/class/hwmon/hwmon*/power*_input` or `energy*_input`, a sensor-chip path some
  boards expose independent of RAPL.
- **nvidia** -- `nvidia-smi`, named for completeness: a GPU's own power draw in milliwatts, needing
  integration over time rather than standing in for a millijoule counter directly.

Each door carries its own reason -- absent, permission-denied, or no-binary -- rather than one
blanket verdict, so a later reader on a different host can tell which door might still open for
them.

## Reading one: every door reads no, and each for a different reason

Read `20260917.203312` on this cloud pier by `sh tools/fixtures/e/energy_readout_scan.sh`:

```
facility=powercap available=no reason=no_readable_energy_uj root=/sys/class/powercap
facility=msr      available=no reason=absent               path=/dev/cpu/0/msr
facility=perf     available=no reason=no_binary             bin=perf
facility=hwmon    available=no reason=no_power_or_energy_input root=/sys/class/hwmon
facility=nvidia   available=no reason=no_binary             bin=nvidia-smi
cpuinfo_hypervisor_flag=yes
facility_count=5
verdict=no_facility
```

`/proc/cpuinfo`'s own `hypervisor` flag reads `yes`, and `systemd-detect-virt` (present on this
host, run by hand outside the scan) names the hypervisor `microsoft`. The CPU underneath is a real
AMD EPYC-Rome, so the gap is a matter of which counters a hypervisor chooses to pass through to a
guest, and this one passes through zero of the five.

## Reading two: the assumption fails at the first door, plainly rather than partially

Row 6's assumption named RAPL specifically, and RAPL misses here two ways at once: `powercap`
lacks an `intel-rapl:*` directory carrying a readable counter, and `msr` -- RAPL's own elder
interface -- lacks a device node entirely. Widening the search to `perf`, `hwmon`, and `nvidia-smi`
leaves the row exactly where it stood; each carries its own independent gap, and each gap sits past
a permission this session's account could plausibly reach (`perf` is missing; the `msr` module is
unloaded; the hypervisor withholds the rest).

## What this closes, and what it leaves open

**Closed:** on this one pier, row 6's first witness stays unbuildable as specified. A hypervisor
that withholds the counter entirely stands past retrying, `sudo`, or a different reader -- this is
the platform's own boundary, standing rather than a permission waiting to be granted.

**Left open, and named rather than guessed:** this fleet runs on eight machines, and this scan reads
only the one it ran on. A bare-metal pier, a different cloud host, or a VM whose hypervisor chooses
to pass RAPL through could answer differently. The falsifier this reading actually fires stays
narrower than the row's own sentence: it names one host as deaf to its own joules, checked five
ways, and leaves the other seven for their own turn. Running
`sh tools/fixtures/e/energy_readout_scan.sh` on each of the other seven piers is the only way to
close the wider question, and every one of those seven readings is free -- run it rather than
assuming this pier's answer generalizes.

**Recommended re-aim for row 6, rather than a re-rank:** keep the row, and split its first witness
in two. The first half is now landed -- a bounded, five-door facility probe that reports
`no_facility` honestly rather than crashing or guessing -- and belongs to every pier in this fleet
as a standing guard, since a lap on any of the eight machines can ask the same question in one
line before spending a week on RAPL-specific code. The second half, an actual millijoule reading
riding beside bytes and wall time in a Meter row, waits on the first pier to answer
`verdict=facility_available` -- a question still open across all eight.

## Why this belongs to Caravan and Tally rather than to a single lap

**Caravan** supervises what runs; **Tally** bounds what is allocated. Both wait on a quantity the
deployed fleet has yet to show either of them. The honest move for the moonshot keeps the row alive
by making the probe itself a standing fleet instrument, so the day a pier answers "yes" arrives as
a green line in a roster pass rather than as a rediscovery.

## Falsifier, restated for the next reader

The row's own falsifier -- "two identical runs report millijoules that differ by more than the
effect any lap would try to measure" -- needs a millijoule reading to fire against, and this pier
produces none. The falsifier that fired instead sits one level up: *this platform exposes zero
energy-reading facilities a Grain lap can reach.* A future reader weighing whether row 6 still
lives should run the scan on their own machine first; the ladder's whole discipline holds a
falsifier proven on one host as testimony about that host alone.
