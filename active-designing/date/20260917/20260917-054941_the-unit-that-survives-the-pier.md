# The Unit That Survives the Pier -- wall time, CPU time, and which number two sittings can compare

**Stamp:** `20260917.054941`
**Room:** mixed -- the instrument and its arithmetic are **checkable** and gated by
[`../tools/c/cpu_unit_witness.rish`](../tools/c/cpu_unit_witness.rish); the host figures are
**research for understanding**, reported and gated by nothing.
**Status:** Landed -- the instrument runs today and the reading below was taken on this pier.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Instrument:** [`../tools/fixtures/c/cpu_unit_scan.sh`](../tools/fixtures/c/cpu_unit_scan.sh) -
control [`../tools/fixtures/c/cpu_unit_control.sh`](../tools/fixtures/c/cpu_unit_control.sh)
**Kin:** [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md) row 12 -
[`20260915-221500_the-trial-with-nothing-to-compare.md`](20260915-221500_the-trial-with-nothing-to-compare.md) -
[`20260911-081019_the-unit-this-pier-can-carry.md`](20260911-081019_the-unit-this-pier-can-carry.md)

---

## What this page is for

Every timing claim this fleet ships is stated in **wall milliseconds**, read on a pier eight ships
share. Row 12's erratum measured what that costs: a deterministic workload measuring a change of
exactly zero read a baseline spread of **16.7 to 54.8 percent** of its median at load average 8 to
13, so any improvement under roughly a fifth is invisible to a single trial here. The remedy named
there was **more trials**, which is a different method rather than a different unit.

This page tests the other axis -- the **unit**. Wall time on a loaded pier is work plus waiting for
a runqueue seven other ships keep full. CPU time is work alone.

## The claim, and the falsifier before the number

**Claim.** For a fixed deterministic workload on this pier, CPU milliseconds carry a materially
narrower run-to-run spread than wall milliseconds, so a saving of a few percent becomes measurable
where wall needs a fifth.

**Horizon.** One afternoon on this pier, `20260917`.

**Assumptions.** The workload is CPU-bound and allocates nothing; the shell's `times` builtin and
`/proc/uptime` are readable and forked nothing to read; the other seven ships' load is whatever it
happens to be, uncontrolled and recorded rather than held.

**Falsifier, named before the first sample.** CPU spread sitting within a factor of two of wall
spread at the same load. The scan prints `narrows=no` and `verdict=unit_buys_nothing` when that
fires.

**Confidence.** Medium at the time of writing, and the reason to write the falsifier down is what
happened next.

## The falsifier fired, in four sittings of six

Six sittings, fifteen runs apiece, one deterministic MINSTD spin loop of four million iterations.
Load average is read from `/proc/loadavg` at the start of each sitting on an **8-core** host.
Spread is `(max - min) / median` in parts per thousand.

| Load | Wall median | Wall spread | CPU median | CPU spread | Contention | Verdict |
|---|---|---|---|---|---|---|
| 40.07 | 780 ms | 397 | 553 ms | 99 | 291 | `cpu_narrower` |
| 35.79 | 770 ms | 376 | 554 ms | 86 | 280 | `cpu_narrower` |
| 12.43 | 590 ms | 118 | 555 ms | 99 | 59 | `unit_buys_nothing` |
| 12.44 | 600 ms | 133 | 556 ms | 133 | 73 | `unit_buys_nothing` |
| 12.93 | 620 ms | 225 | 552 ms | 99 | 109 | `cpu_narrower` |
| 12.83 | 620 ms | 112 | 552 ms | 72 | 109 | `unit_buys_nothing` |

**Observation.** At load 36 to 40 the unit narrows the spread roughly fourfold. At load 12 to 13 it
narrows nothing in three sittings of four.

**Inference.** The claim as written is **conditional on load**, and its condition is the term it
never named. What CPU time removes is waiting, so it can only remove what is there: the
`contention` column falls from 291 to 59 parts per thousand across the same rows, and the narrowing
falls with it. A claim about a unit turned out to be a claim about a pier.

## What survives is larger than what was claimed

Read the same table down its **medians** rather than across its spreads.

**Observation.** The CPU median stands at **552, 553, 554, 555, 556** milliseconds across every
sitting -- a range of **4 ms**, or **7 parts per thousand**. The wall median stands at **590, 600,
620, 620, 770, 780** -- a range of **190 ms**, or **306 parts per thousand** of its own middle.

**Inference.** Across sittings the wall number moves **44 times** as far as the CPU number, and it
moves with the load rather than with the work. The workload was byte-identical in all six.

**Why that is the more useful property.** A spread inside one sitting is what a lap fights when it
measures a change back to back in one hour. A difference **between** sittings is what this fleet
actually does: a before-number is read when the work starts and an after-number when it lands,
often hours apart, often on a pier whose other seven ships have changed what they are doing. Two
wall numbers taken on either side of that gap differ by up to **31 percent** with no code change at
all, which is larger than most savings anyone here has claimed. Two CPU numbers differ by **0.7
percent**.

**Projection.** A fleet restating its timing claims in CPU milliseconds can compare a measurement
taken now against one taken last week. **Horizon:** the next chapter. **Assumptions:** the
workloads compared stay CPU-bound and the host's core count and clock do not change.
**Falsifier:** a CPU-median range above roughly 50 parts per thousand across sittings spanning a
comparable load range, which would put the cross-sitting claim inside the same band the wall claim
lives in. **Confidence:** medium-high for CPU-bound work, low for anything that waits on a disk or
a socket, where the waiting is the subject rather than the noise.

## What the instrument does, plainly

`tools/fixtures/c/cpu_unit_scan.sh` runs one `awk` MINSTD spin loop N times and reads it in two
units **inside a single call**, so the two are measuring identical work rather than two sittings.

**The timed region spawns nothing but the workload**, and that is the whole reason both clocks are
read the way they are. `date +%s%N` is a **child process**, so its own CPU lands in the very
counter being read -- a systematic offset that shrinks relative spread and so biases the finding
toward the answer this lap wanted. Wall therefore comes from `read < /proc/uptime`, a shell builtin
reading a file, and CPU from the `times` builtin redirected to a file. Neither forks.

**`$(times)` cannot be used at all.** Command substitution forks a subshell whose own
children-times record starts at zero, so it reports `0m0.000s` however much work ran. Measured on
metal `20260917` before the file was written, and named here because the wrong spelling produces a
confident, plausible, permanently zero reading.

**Resolution is measured rather than assumed.** `/proc/uptime` carries centiseconds on this host
and `times` prints milliseconds, so the scan reports the smallest nonzero step it actually observed
between adjacent sorted samples in each unit -- **10 ms** and **1 ms** in every sitting above -- and
refuses a workload short enough for that rounding to dominate.

## The red this lap found in its own control

The scan's first draft gave a **zero median** its own refusal name, separate from the short-workload
refusal. Both are the same condition: a workload the clock rounds to nothing is the extreme of a
workload the clock rounds badly. The control's host-half leg, which runs a three-iteration workload
and asserts the scan refuses for quantization, therefore read **`SHORT_WORKLOAD` on a quiet moment
and `ZERO_MEDIAN` on a loaded one** -- one condition wearing two names, and a **flaky** guard by
this tree's own word.

It was caught by running the control **five times rather than once**, which is the whole of the
method: a guard run once cannot be told from a guard that happens to pass. The zero median now
folds into the short-workload refusal, the control carries an injected leg proving it
deterministically, and the control reads **0 failures in six consecutive runs**.

## What is not proven here

**That a CPU millisecond is an energy.** It is not.
`tools/fixtures/e/energy_instrument_scan.sh` answers `joule_source=none` and `tier=counters` on
this pier, re-read `20260917`, so no joule is available to relate it to. The counters-tier reading
at [`20260911-081019_the-unit-this-pier-can-carry.md`](20260911-081019_the-unit-this-pier-can-carry.md)
already owns that boundary and this page borrows nothing from it.

**That CPU time is the right unit for a person waiting.** It is not. A reader waits in wall
seconds, and a claim about what a user experiences owes a wall number. This page is about what an
**engineer** can measure a change in.

**That it holds for any workload but this one.** A fork-heavy, disk-heavy, or socket-heavy workload
spends its time in places CPU time deliberately does not count, and each wants its own run of the
same instrument with its own workload written in.

**That it holds on other silicon.** One host, eight cores, one afternoon, one load range.

## What a lane could take next

**The cross-sitting reading has no instrument.** The table above was assembled by a hand running the
scan six times and copying medians, which is exactly the shape of reading this tree distrusts. An
instrument taking several sittings and reporting each unit's cross-sitting median range would turn
the strongest finding on this page into something re-runnable. It needs no new mechanism -- only
persistence between runs and a named bound on how many sittings it keeps.

**And Bakery's compile cache is the first caller.** A content-keyed cache saves compilation, which
is CPU-bound by construction; measured in wall milliseconds on this pier its saving competes with a
31 percent cross-sitting swing, and measured in CPU milliseconds it competes with 0.7 percent.

---

*May the number a lap reports be its own work, and may two honest readings taken a week apart still
be talking about the same thing.*
