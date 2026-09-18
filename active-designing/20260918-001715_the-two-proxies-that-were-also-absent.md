# The two proxies that were also absent

**Stamp:** `20260918.001715` -- **Status:** Landed -- **Room:** checkable -- every reading below is
emitted by one scan under one green witness.
**Language:** EN -- **Style:** Gauge, Field setting -- **Voice:** Kyri
**Grades:** row 6 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Kin:** [`20260917-203312_the-pier-that-cannot-hear-its-own-joules.md`](20260917-203312_the-pier-that-cannot-hear-its-own-joules.md)
(the five-door facility check this piece extends)
**Instrument:** [`../tools/fixtures/e/energy_readout_scan.sh`](../tools/fixtures/e/energy_readout_scan.sh),
proven by [`../tools/fixtures/e/energy_readout_control.sh`](../tools/fixtures/e/energy_readout_control.sh)
under [`../tools/e/energy_readout_witness.rish`](../tools/e/energy_readout_witness.rish).

---

## The sentence this answers

The kin piece named one open question and left it for a later turn: *what a hypervisor withholds
tells us nothing about hosts that pass RAPL through.* It closed the joule-bearing question on this
pier -- powercap, MSR, perf, hwmon, and nvidia-smi all absent -- and left a narrower one unasked: if
this pier cannot count its own joules, can it at least see a PROXY for them? Power draws roughly as
the cube of clock frequency on a fixed voltage curve, and heat is downstream of power dissipated,
so a reader locked out of the energy counters directly might still bound a coarse signal from
either DVFS state or a thermal zone. This piece asks that question and answers it.

## The method: two more doors, held apart from the first five

`energy_readout_scan.sh` now probes two further paths beside its original five:

- **cpufreq** -- `/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`, the kernel's own record
  of the CPU's current clock, in kilohertz.
- **thermal** -- `/sys/class/thermal/thermal_zone*/temp`, a millidegree-Celsius reading from
  whichever zone the kernel exposes first.

Neither is a joule count, and the scan says so out loud in the line it prints
(`note=proxy_not_energy`) and in how it scores them: a found proxy sets its own
`any_proxy_available` flag rather than the joule-bearing `any_available` flag row 6's
`verdict=facility_available` reads. Conflating a frequency reading with an energy counter would be
exactly the mistake row 6's own falsifier warns against, one door lower than where it was written
to catch it -- so the control asserts the isolation directly: a planted, readable proxy must read
`available=yes` on its own line and must NOT flip the scan's overall verdict.

## What this pier answers

```
facility=cpufreq available=no reason=absent path=/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
facility=thermal available=no reason=no_readable_temp root=/sys/class/thermal
cpuinfo_hypervisor_flag=yes
virt_detect_bin=systemd-detect-virt virt_name=microsoft
facility_count=7
proxy_verdict=no
verdict=no_facility
```

Both proxies read absent, for the same underlying reason powercap and hwmon do: the guest sees no
`cpufreq` sysfs tree at all (no directory, not merely an unreadable file), and the kernel exposes
zero thermal zones with a readable `temp` file, cooling-device nodes aside. **Every locally
observable signal touching power on this machine reads absent -- not only the direct counters, but
the two cheapest proxies a reader would reach for next.** The absence is total rather than partial.

## The second finding: the hypervisor now names itself

The kin piece read `cpuinfo_hypervisor_flag=yes` from `/proc/cpuinfo` and inferred the hypervisor's
identity from a separate, unscripted `systemd-detect-virt` call. That inference now rides inside
the scan itself: `virt_detect_bin=systemd-detect-virt virt_name=microsoft`. This is a small change
with one real consequence -- the finding that a Microsoft hypervisor is the layer withholding every
signal is now a **reproducible line in a green witness** rather than a fact a reader had to
re-derive by hand each time they wanted to cite it.

## Inference

**Observation.** Seven independent doors -- five joule-bearing, two proxy -- all read absent on
this pier, under one probe, in one run, at 1.13 seconds wall time.

**Inference.** The absence is a property of the hypervisor's passthrough policy rather than of any
one kernel feature this guest's kernel happens to lack. A guest denied RAPL and denied `cpufreq`
and denied thermal zones is not missing three unrelated drivers; it is behind one boundary drawn at
the virtualization layer, and `virt_name=microsoft` names which boundary.

**Projection.** A future reader asking "can THIS pier estimate its own power draw at all, by any
locally observable means" should expect the answer to stay no until either the hypervisor's
passthrough policy changes or the workload moves to bare metal. **Horizon:** unbounded, since
nothing in this tree controls the hypervisor's configuration. **Assumptions:** the seven doors
probed are the complete set of commonly available Linux power/frequency/thermal signals; a host
could in principle expose a ninth (an out-of-band IPMI sensor, a cloud provider's own metering API)
that this scan does not check. **Falsifier:** any one of the seven doors reading `available=yes` on
a future run of this same scan on this same pier -- or a ninth signal named and found available by
a later extension of the scan. **Confidence:** high for the seven doors actually probed, on this
one host; unmeasured for the other seven piers and for any signal outside the seven.

## What this changes for row 6, and what it does not

**What it changes.** The kin piece's recommended re-aim -- split the first witness in two, land the
facility probe as a standing fleet guard, and wait on the millijoule Meter row until some pier
answers `verdict=facility_available` -- needed no change; this piece widens the probe rather than
overturning the recommendation. What it adds is scope: the standing guard now also tells a future
lap whether a proxy-based estimate is worth building, before that lap spends time designing one.

**What it does not do.** It does not run the scan on the other seven piers -- that reading stays
free and open, exactly as the kin piece left it. It does not attempt a power estimate from any
other signal (process scheduling counters, `/proc/stat` idle time, disk or network I/O rates) --
those are weaker proxies still, several steps further from power than frequency or heat, and
opening that door is its own future piece rather than this one's job.

## Falsifier, restated for the next reader

*Any one of the seven doors probed here reads `available=yes` on a future run.* A reader six months
from now, on this pier or another, should run `sh tools/fixtures/e/energy_readout_scan.sh` before
trusting this piece's `no_facility` -- a kernel update, a changed hypervisor configuration, or a
migration to different hardware could each move the answer, and the scan is cheap enough to ask
again rather than to assume.
