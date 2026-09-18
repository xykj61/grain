# The Unit This Pier Can Carry

**Stamp:** `20260911.081019`
**Room:** mixed -- the host readings and the counter's behavior are checkable and bound by a witness; the proposal that a Meter row should carry the unit is vision
**Status:** Landed -- the witness is green on metal
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Witness:** [`../tools/r/retired_count_witness.rish`](../tools/r/retired_count_witness.rish) over [`../tools/rye/retired_count.rye`](../tools/rye/retired_count.rye) and [`../tools/fixtures/r/retired_count_control.sh`](../tools/fixtures/r/retired_count_control.sh)
**Elder:** [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md), row 6

---

## The reading that was owed

Row 6 of the twelve moonshots asked for **millijoules beside bytes** in a Meter row, and its
ranking rested on one sentence: *one host read away*. Its assumptions section named the condition
plainly -- *this pier's CPU exposes RAPL counters to a reader with the permissions we have*. The
page went to the ranking table with that condition untested.

The read takes one line, and this tree already owns the instrument. Run
`sh tools/fixtures/e/energy_instrument_scan.sh` on this pier, `20260911.073000`:

| Reading | Value |
|---|---|
| `powercap_domains` | 0 |
| `hwmon_energy` | 0 |
| `supply_power` | 0 |
| `rapl_perf_events` | 0 |
| `msr_device` | no |
| `joule_source` | none |
| `tier` | counters |

**No joule is readable on this machine by anyone.** The CPU reads `AMD EPYC-Rome Processor` in a
guest, and the guest is handed no power domain at all. Row 6's first witness therefore cannot be
built here, and no further paper changes that.

These figures are **free**: they stand on this one reading, and a different host answers for
itself. Read them by running the scan rather than by trusting this table.

## What the same scan found instead

Two readings in that output point somewhere else: `hw_instructions=yes` and
`perf_event_paranoid=2`. Paranoid level 2 permits a process to count **its own user-space
execution**, which is a narrower permission than profiling the machine and exactly the one a
measurement of our own program needs. The `perf` binary is absent here; `perf_event_open(2)` is a
syscall and needs no binary.

So the tier this host offers is **counters** rather than joules, and it is reachable from Rye
directly. The question row 6 was really asking survives the substitution: *is there a quantity a
Meter row can carry that stays steady enough to compare two runs?*

## The claim, and the falsifier before the number

**Claim.** On a counters-tier host, **retired instructions** is a unit a Meter row can carry,
because it is stable where wall time is not.

**Falsifier.** If the instruction count's run-to-run spread is no smaller than wall time's, the
counter buys nothing a clock already gave, and the row closes rather than grows.

**Horizon.** The reading stands for this host class today; a different CPU answers for itself.

**Assumptions.** The counter counts user space only; the workload is fixed; the machine carries its
ordinary neighbours while the measurement runs.

## The measurement

`tools/rye/retired_count.rye` opens the hardware instruction counter on itself, runs a fixed
multiply-and-accumulate loop of 1,000,000 iterations sixteen times, and reports the spread of both
quantities in parts per million of their own mean. Read `20260911.080700`, five consecutive runs, at
a one-minute load average of **10.11** on an eight-ship pier:

| Run | Instruction spread | Wall spread | Ratio |
|---|---|---|---|
| 1 | 357 ppm | 603,114 ppm | 1,689x |
| 2 | 356 ppm | 195,724 ppm | 549x |
| 3 | 357 ppm | 1,422,106 ppm | 3,983x |
| 4 | 357 ppm | 932,607 ppm | 2,612x |
| 5 | 356 ppm | 1,018,451 ppm | 2,860x |

**The counter's spread is 0.036 percent. The clock's runs from 20 percent to 142 percent.**

The second column carries the sharper argument. The instruction spread moves by **one part per
million** across five runs; the wall spread moves by a factor of **7.3**. The noise is itself
noisy, so a lap comparing two wall times on this pier is comparing its neighbours as much as its
own work.

One figure settles the loop's own honesty: the count reads **24,009,111** for a million iterations,
which is 24.009 instructions each. Doubling the workload gives a ratio of **1,999,977 ppm** --
within 12 parts per million of exactly two, and identical to the last digit across every run taken.

**The falsifier was aimed, and the counter cleared it.** The counter runs roughly three orders of
magnitude steadier than the clock, measured rather than argued.

## Why a doubling leg exists at all

A counter that returned a constant would hold a spread of zero and mean nothing. So would one that
returned the loop bound it was handed. That is the trap moonshot 1 named in its own row, where an
index-only assert proves arithmetic and nothing about memory.

The doubling leg is what tells a counter from a constant: run the same loop at twice the size and
require the count to follow. `tools/fixtures/r/retired_count_control.sh` proves the leg can bite by
building a mutated copy whose workload ignores its scale, in a throwaway pen, and requiring exit 1
with the named refusal. The spread gate is mutated the same way, with its ceiling dropped to zero.
Twelve cases stand, and the unmutated copy is built and run beside them, because a control that
plants only refusals proves a program that refuses everything just as well as a correct one.

## A host is not a fault

The program takes one more branch, and it is the one that lets this guard travel. Where
`perf_event_open` refuses, it prints `counter=unavailable` and reaches GREEN.

The reason is seated in this tree already, at REDS `%646`: a witness that reds on an absent optional
capability reds on every machine that lacks it, and a guard nobody can keep green is a guard
somebody turns off. What the witness **does** gate is the distinction -- exactly one branch is
named, every run. A program that names one branch every run is a program still reading the host.

This matters beyond one file. The fleet sails eight ships across at least two machine classes, and
a Framework laptop with its own battery may well answer `joule_source=supply` where this guest
answers `none`. The right shape for an energy instrument in this tree is one that says which tier it
found, rather than one that assumes a tier and fails elsewhere.

## What this changes about the ranking

Row 6 sat third on the twelve-moonshot table, behind two rows that have since landed. Its
placement rested on the phrase *one host read away*, and the read has now been taken.

**Row 6 as written cannot proceed on this pier.** It proceeds on a host that exposes a joule, and
the elder page keeps every word it wrote, as dated testimony does. What this paper proposes in its
place is narrower and available today: a **counters-tier unit**, with joules kept as the horizon for
whichever machine offers them.

**What would change this recommendation.** A Framework pier answering `supply_readable=1` or
`powercap_readable>0` puts the original row back within reach on that machine, and the same Meter
row then carries two units on two hosts. The scan already answers that question in one line, so the
check costs one command when a hand is next at that keyboard.

## What is not proven here

**That an instruction is an energy.** It is not. Retired instructions is a *proxy*, and the
constant relating it to joules varies with the instruction mix, the clock, and the silicon. This
paper claims stability and nothing about watts, and any later claim that converts one to the other
owes its own measurement on a host that reads both.

**That the spread holds on other silicon.** One host, one CPU, one afternoon. The ceiling is set at
1,000 ppm, loose by nearly three times against what was measured, precisely so a different branch
predictor does not red a guard that has nothing to say about it.

**That a unit anybody keeps has been chosen.** Reading a counter is mechanical; choosing a ceiling
a lane will still keep in six months is the harder half, and the elder row said so in its own
confidence line. That half stays open.

---

*May the number a lap reports be its own work, rather than the weather on the machine beside it.*
