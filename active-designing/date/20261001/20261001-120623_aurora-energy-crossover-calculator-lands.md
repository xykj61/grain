# Proposal 2's own first witness lands -- a calculator, not a measurement

**Stamp:** `20261001.120623` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- vision. The calculator runs today; the crossover traffic volume it prints carries placeholder units until a pier can read a joule.
**Room:** mixed -- a witness binds the arithmetic (checkable); the energy-crossover claim itself stays vision until `e` and `s` are real.
**Lane:** Diffuser research
**Kin:** [Proposal 2, the piece this page builds](../../date/20260918/20260918-054803_two-first-principles-proposals-caravan-lattice-hop-aurora-energy-crossover.md), [row 6's two errata on why no pier can read a joule](../../date/20260917/20260917-203312_the-pier-that-cannot-hear-its-own-joules.md), [row 7's placement measurement](../../date/20260910/20260910-060204_the-bounded-torus-moonshots.md)

## What this page records

Proposal 2 of the `20260918-054803` page named a first witness and left it unbuilt: *"a small Rye
or Rishi tool that takes `Hm`, `Ht`, `L`, `e`, and `s` as named inputs... and prints the crossover
traffic volume `M*`."* That tool now exists --
[`tools/fixtures/a/aurora_energy_crossover_calc.sh`](../../../tools/fixtures/a/aurora_energy_crossover_calc.sh),
witnessed by
[`tools/a/aurora_energy_crossover_witness.rish`](../../../tools/a/aurora_energy_crossover_witness.rish),
proven against hand arithmetic and two planted mutations by
[`tools/fixtures/a/aurora_energy_crossover_control.sh`](../../../tools/fixtures/a/aurora_energy_crossover_control.sh)
(12 legs, 0 faults).

## Observation: what the calculator reads and computes

`Hm`, `Ht`, and `L` are read from `aurora_placement_scan.sh`'s own `grid k=...` lines rather than
retyped -- the mesh and torus mean hop counts and the count of extra wrap links the torus adds at
that grid. `e` (energy per hop) and `s` (static energy per link) are named CLI parameters,
`--e` and `--s`, defaulting to `1.0` each so the tool runs today and prints a dimensionless ratio
rather than refusing to run. The formula from the proposal:

```
M*  =  L * s / ((Hm - Ht) * e)
```

Run on `20261001.114903` at the default placeholder units:

| Grid | Hm | Ht | L | diff | M* |
|---|---|---|---|---|---|
| k=2 (4 cores) | 1.3333 | 1.3333 | 0 | 0.0000 | undefined -- no hop saving |
| k=3 (9 cores) | 2.0000 | 1.5000 | 6 | 0.5000 | 12.0000 |
| k=4 (16 cores) | 2.6667 | 2.1333 | 8 | 0.5334 | 14.9981 |
| k=8 (64 cores) | 5.3333 | 4.0635 | 16 | 1.2698 | 12.6004 |

**Units.** The table's `M*` column has units of messages-per-unit-time scaled by `e` and `s`'s own
(placeholder) units -- at `e=1, s=1` the number is a pure ratio rather than a real traffic volume,
exactly as the proposal's own text anticipated.

## Inference: what the k=2 row teaches about the formula's own domain

At `k=2`, `Hm` equals `Ht` -- the torus and mesh are one graph at that grid, per row 7's own
measurement. The calculator treats that case as a named domain boundary: `diff=0.0000` yields
`crossover_messages=undefined reason=no_hop_saving`, a plain answer where the raw formula would
divide by zero. A planted mutation (`m1` in the control) removed that guard and reproduced exactly
the division-by-zero this host's own `awk` raises, confirming the guard earns its place.

## Projection and falsifier

**The table above is a formula result, held apart from a measurement.** The four `M*` values
describe what the formula says at `e = s = 1.0`, an assumption stated plainly here rather than read
off any instrument. The proposal's own falsifier stands exactly as written: a board whose wrap
links run physically longer than its mesh links would make `e` topology-dependent
(`e_wrap > e_mesh`), a case this single-`e` model holds constant by assumption. A real board could
show that assumption's cost; this lap leaves that falsifier exactly as the proposal stated it.

**What this lap changes:** the horizon moves from "one to two weeks, buildable now" to **built, on
metal, GREEN**. The day any pier in this fleet answers `verdict=facility_available` for a joule
reading, `sh tools/fixtures/a/aurora_energy_crossover_calc.sh --e <real> --s <real>` prints a real
`M*`, with the code already standing. Confidence in the arithmetic is high, proven by hand-computed
legs and two bitten mutations. Confidence in today's `M*` as a production number stays at its
honest floor: the tool names its own inputs as placeholders, and this page repeats that naming
rather than letting the number speak alone.

**Handoff.** This lap's scope stays the calculator alone: it reads `aurora_placement_scan.sh`'s own
output rather than re-deriving it, and it stops precisely where the proposal's own text stopped --
at the two terms a joule-reading door would someday supply. Aurora's own module and Bakery's queue
stand untouched.

---

May the two missing terms find their door in good time, and may this calculator wait there,
printing its honest placeholder, until they arrive.
