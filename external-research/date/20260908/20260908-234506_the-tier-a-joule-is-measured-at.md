# The Tier a Joule Is Measured At

**Stamp:** `20260908.234506`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Landed, **checkable** -- every figure below is bound by a witness landing in this same
commit ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)); the one projection section says so at
its own head
**Instrument:** [`../tools/e/energy_instrument_witness.rish`](../tools/e/energy_instrument_witness.rish)
over [`../tools/fixtures/e/energy_instrument_scan.sh`](../tools/fixtures/e/energy_instrument_scan.sh),
[`../tools/fixtures/e/energy_instrument_agree.sh`](../tools/fixtures/e/energy_instrument_agree.sh),
and [`../tools/fixtures/e/energy_instrument_control.sh`](../tools/fixtures/e/energy_instrument_control.sh)
**Kin:** [`the bound that names a joule`](20260905-232224_the-bound-that-names-a-joule.md) -
[`the tier's clock reads the pier, not the guard`](20260908-230804_the-tiers-clock-reads-the-pier-not-the-guard.md)

---

## The fact at the door

This tree carries an energy argument several papers deep. Measured `20260908.234221` by
`git grep` over the flat pages of `external-research/`, `active-designing/`, and `foundations/`:
**18 living pages name a joule, a watt, or a kilowatt-hour, 63 times between them.** Every one of those figures rests on a CPU-second proxy, a vendor budget, or a datasheet number;
the count read from an actual counter stands at zero.

The question the arc never asked out loud is the cheap one: **does the machine we run on expose a
joule at all, and may this user read it?**

It answers `counters` -- work, rather than energy. Read `20260908.234221` on this pier -- a Vultr instance under a Microsoft hypervisor,
AMD EPYC-Rome, 8 visible cores, Linux 6.18.41:

| Reading | Value |
|---|---|
| `powercap_domains` / `powercap_readable` | 0 / 0 |
| `hwmon_energy` / `supply_power` | 0 / 0 |
| `rapl_perf_events` | 0 |
| `msr_device` | no |
| `hw_events`, `hw_cycles`, `hw_instructions` | 7, yes, yes |
| `perf_event_paranoid` | 2 |
| `joule_source` | none |
| `tier` | **counters** |

Observation: every joule family reads zero present. Observation: the `cpu` performance-monitoring
unit stands here, exposing cycles and retired instructions, at a paranoid setting that lets a
process count itself.

## Existence is not readability

The distinction the instrument is built around is worth naming plainly, because it is the one a
careless probe gets wrong in the dangerous direction.

Since the PLATYPUS disclosure (CVE-2020-8694, published 2020), Linux ships intel-rapl's `energy_uj`
at mode 0400 -- so the file stands in sysfs and answers an unprivileged
process with a permission error. A probe that **stats the path** would report a joule the caller
can never have, and a false instrument produces figures where an honest one stays silent.

So every reading here **opens** the counter and requires digits back. A counter that refuses is
counted separately, under `joule_present_unreadable`, since that case sits one permission away from
repair and earns its own column.

## The second wall: a declaration is not an open

Sysfs answers what a host **declares**; a syscall answers what it **hands over**. A kernel may
expose `instructions` under the `cpu` PMU and still refuse `perf_event_open`, and a guest may pass
the event names through while the counters behind them stay home.

So the tree carries a second fixture that asks the second question.
[`../tools/rye/perf_self_count.rye`](../tools/rye/perf_self_count.rye) opens a self-scoped hardware
counter, runs a bounded loop of a named size, and prints what came back. Running as an ordinary user, with the `perf` binary
absent, it reads **23,000,054 retired instructions over 1,000,000
iterations -- 23 per iteration** (`20260908.234221`; the figure moves by a few tens of thousands
between runs, which is the loop's own setup and teardown rather than noise in the counter). The
declared tier and the opened counter agree, and a disagreement between them is gated as a genuine
fault rather than reported as a host fact: it would mean the tree believed a tier beyond its reach.

## The ladder, and why the floor is not a fault

Three rungs, best instrument first:

- **`joules`** -- a counter answered in microjoules. Absolute energy, attributable to a domain.
- **`counters`** -- cycles and retired instructions answered. **Work**, not energy.
- **`cpu_seconds`** -- the floor. Time on a core, which is what
  [`../tools/fixtures/s/standing_equipment_run.sh`](../tools/fixtures/s/standing_equipment_run.sh)
  has recorded per guard since `20260908.230804`.

**A host is a fact, never a fault.** `tier=cpu_seconds` is a true reading, so the live pass reports
and passes free. What the control gates is the probe's own ability to say `joules` **when joules are
there** -- since a probe able only to say `none` proves exactly nothing by saying it. Twenty legs over planted sysfs pens prove it: three joule families each reached by
name, the counters rung reached and both its events required, the floor reached by a host holding
nothing, the ladder ordered, and six refusals bitten.

## What a counters-tier host may honestly say

Inference, from the readings above. At the `counters` rung, energy is a product of two terms and
this host measures exactly one of the two:

```
energy = work x energy_per_unit_work
         ^^^^   ^^^^^^^^^^^^^^^^^^^^
         read   unmeasured here
```

Retired instructions are a **work** figure. Turning work into joules needs an energy-per-instruction
term, and that term moves with frequency, voltage, cache behaviour, and the neighbours sharing the
socket -- on a shared virtual host, by an amount this instrument leaves unbounded.

So the honest reach of a counters-tier reading is **relative**: two implementations of the same
operation, measured on the same host in the same hour, may be compared by instructions retired, and
the comparison holds while every joule stays unnamed. Beyond that reach sit the absolute figure,
the cross-host comparison, and the per-tenant attribution, each of which wants the rung above.

That is a real result rather than a consolation. Most of this tree's energy questions -- is the
cached scrub cheaper than the full one, does a radial layout retire fewer instructions than the
cartesian default -- are comparisons on one host, and a comparison is exactly what a counters host
settles.

## Projection

**This section is projection, and nothing in it is bound by the witness.**

*Horizon:* the next host this fleet is asked to measure on.
*Assumptions:* bare metal or a hypervisor that passes RAPL through; an operator willing to relax
`energy_uj` from 0400, or to grant the `power` PMU.
*Claim:* on such a host the instrument reads `tier=joules` on its first run, code unchanged, since
the powercap leg already stands proven on planted pens.
*Falsifier:* a host whose `/sys/class/powercap/*/energy_uj` returns digits to this user while the
scan still reports `joule_source=none`. That would place the fault in the family glob or the digit
check, and one command settles it: `sh tools/fixtures/e/energy_instrument_scan.sh`.
*Confidence:* high for the reading, low for the availability -- of the hosts this fleet has run on,
the count exposing a readable joule stands at zero.

## What this does not reach

That a readable counter is **accurate**. That its domain covers the work you care about. That a
joule read on a shared virtual host could be attributed to one tenant. That an instruction retired
on one microarchitecture costs what it costs on another.

Only which instrument is available, and whether this user may read it.

## For BAKERY

**Buildable now:** an instructions-retired harness around any two candidate implementations, run on
one host in one sitting, reported as a ratio. The counter opens with no root and no `perf` binary;
`tools/rye/perf_self_count.rye` is the working shape to copy.

**Waiting on a better rung:** the absolute joule figure, and any claim that one design saves energy
in watts. Both want a host answering `tier=joules`, and the instrument announces that day the moment
it arrives.
