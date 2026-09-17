# The Unit That Agrees on Order and Disagrees on Size

**Stamp:** `20260917.121546`
**Room:** checkable -- every figure below came back from an instrument this tree now carries, and the witness is named
**Status:** Landed -- checkable
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Runs the falsifier of:** row 3 of [`20260917-105154_the-refusal-that-can-fire.md`](20260917-105154_the-refusal-that-can-fire.md) -- survived, with one clause re-aimed
**Witness:** [`../tools/r/retired_rank_witness.rish`](../tools/r/retired_rank_witness.rish) -- 19 behaviors, `control_failed=0`

---

## The question, bounded before the number

This pier exposes no joule. `tools/fixtures/e/energy_instrument_scan.sh` answers
`joule_source=none`, `powercap_domains=0`, `msr_device=no` and `tier=counters`, read
`20260917`. So every energy figure a lane writes here is a proxy, and row 3 of this lane's second
ranked page proposes one: **retired instructions**, on the claim that the unit *ranks two
implementations the same way a joule would*.

That row states its own falsifier in one sentence -- **the counter ranks two implementations in the
opposite order from wall time on this pier** -- and this page is the reading.

## What had to be built, and why the elders could not answer

Two programs already opened a counter here. `tools/rye/perf_self_count.rye` and
`tools/rye/retired_count.rye` scope the counter to **their own process** and count a loop compiled
inside it. Between them they proved the counter tier is reachable at `perf_event_paranoid=2` without
root and without the `perf` binary this host lacks, and they measured the two spreads at
self-scope: instruction spread 356-357 ppm against wall spread 195,724-1,422,106 ppm, read
`20260911.080700`.

Neither can measure a **command**, and ranking two implementations is exactly that.
[`../tools/rye/retired_exec.rye`](../tools/rye/retired_exec.rye) forks, arms a hardware counter on
the dependent with `enable_on_exec` and `inherit`, releases it through a pipe to `exec`, waits, and
reports instructions beside wall nanoseconds for that dependent and everything it starts. The
kernel enables the counter at the exec boundary, so the number holds the dependent's own work
alone.

[`../tools/fixtures/r/retired_rank_scan.sh`](../tools/fixtures/r/retired_rank_scan.sh) runs two
labelled commands R times each, **interleaved A B A B** rather than in blocks, so a load arriving
partway through the trial reaches both arms. It reports the median of each arm on each reading and
one word: `agree=yes|no`.

## The pair, chosen because the tree already calls it a pair

`tools/fixtures/a/ascii_document_resident_probe.sh` describes itself in its own header as
`ascii_document_scan.sh` **transcribed with every per-file process removed** -- two implementations
of one census, whose agreement this tree already gates through
`tools/a/ascii_resident_agree_witness.rish`. That is a real pair rather than a constructed one, and
its wall times are known to differ by about an order of magnitude.

Five repetitions each, interleaved, read `20260917.121546` on this pier:

| Reading | `shell_per_file` | `resident` | Ratio |
|---|---|---|---|
| Retired instructions, median | 80,317,681,298 | 16,701,077,713 | **4.81x** |
| Wall nanoseconds, median | 70,142,005,543 | 2,164,329,226 | **32.41x** |
| Instruction spread, ppm of median | 33 | 1 | -- |
| Wall spread, ppm of median | 348,713 | 206,057 | -- |

`instructions_cheaper=resident`, `wall_cheaper=resident`, **`agree=yes`**, `verdict=ok`.

## Three findings, each its own sentence

**Observation.** The two readings put the same arm first, so the row's stated falsifier did not
fire on the pair the tree itself calls a pair.

**Observation.** The two readings disagree about **size** by a factor of **6.74**: the counter says
the resident probe does 4.81 times less work, and the clock says it takes 32.41 times less time.

**Inference.** The gap is the half of the bill the counter is built to exclude. The counter reads
**user-space** retired instructions with kernel and hypervisor excluded, and the shell form's
distinguishing cost is spawning a process per file -- which is kernel time, plus the scheduling
latency of doing it six thousand times on a pier eight ships share.

**Observation.** On the same runs the clock's spread is **10,567x** the counter's on one arm and
**206,057x** on the other. The self-scope measurement found three orders of magnitude; at command
scale it is four to five.

## What this re-aims in the row, stated plainly

The row's claim has two halves joined by one phrase -- *that unit ranks two implementations the same
way a joule would*. **The ranking half survives** and is now measured. **The magnitude half was
never claimed and must not be assumed**: a lane that reads `4.81x fewer instructions` and writes
`4.81x cheaper` would have understated this repair's real saving by nearly seven times.

So the unit answers *which implementation does less work*, and it does not answer *how much less
time you get back*. Those are two questions, and this pier can measure both separately today.

## The boundary, proven rather than asserted

A reading that cannot say `agree=no` says nothing when it says `agree=yes`. The control plants a
pair where one arm **sleeps** and the other **computes** -- `sleep 2` against a bounded shell spin --
and the scan reports `instructions_cheaper=sleeper`, `wall_cheaper=worker`, `agree=no`,
`verdict=rank_disagreement`. That is the proxy's true boundary: a workload that waits rather than
computes reports a small count beside a large clock.

A sleeper and a spin are not two implementations of one workload, so this is the **demarcation**
case rather than a counterexample to the row. What it establishes is that the instrument would have
said so if the real pair had behaved that way.

**The scan also declines rather than guessing.** Two arms whose medians sit closer than 20,000 ppm
on a reading earn `verdict=too_close` and `agree=undecided`, since an order manufactured out of
noise is worse than no order.

## Nineteen behaviors, every refusal planted and then lifted

`sh tools/fixtures/r/retired_rank_control.sh` reads `control_legs=19`, `control_failed=0`,
`control_verdict=ok`. Five refusals bite -- missing arms, an unreadable arm spelling, repetitions
out of bounds, repetitions that are not a count, and an arm that exits non-zero. The agreeing case
is asserted from **both positions**, so a scan that simply always named its `--a` arm would red.
One mutation is asserted to bite: an order function rewritten to always name the first arm.

**That mutation is kept because its ancestor fired for real.** The first run of `retired_exec.rye`
passed an **empty environment block** across `exec`, so every arm answered `sh: command not
found` and exited 127 in about 1.8 million instructions -- a broken arm reading as a fast one. The
scan's non-zero refusal caught it, which is why that leg is a gate rather than a courtesy.

## What this does not reach

**Whether retired instructions track joules.** No joule is readable on this pier, so the row's
central assumption stays an assumption and its confidence says so. Establishing it wants a host that
exposes RAPL or a wall meter, which is hardware a later lane will bring.

**Attribution on a shared host.** A counter read inside a hypervisor guest on a pier eight ships
share measures this process tree; what the machine as a whole spent is a different question.

**Anything about a pair whose difference is I/O.** The instrument reports both numbers rather than a
verdict for that case, and the sleeper leg is what makes the case visible.

## The reading that would overturn this

Run the same pair on a host where a joule **is** readable, and compare the joule ratio against the
instruction ratio. If the joule tracks the **clock** at 32x rather than the counter at 4.8x, then
instructions retired is the wrong proxy for energy on a spawn-heavy workload and the row's unit
should narrow to *work done in user space*, which is a smaller and still useful claim.

```
sh tools/fixtures/r/retired_rank_scan.sh --reps 5 \
  --a "shell_per_file:sh tools/fixtures/a/ascii_document_scan.sh" \
  --b "resident:sh tools/fixtures/a/ascii_document_resident_probe.sh"
```

**Every figure on this page is FREE.** The tree grows, the pier's load moves, and both arms read a
tracked listing that changes every lap -- so run the command rather than trusting the table.
