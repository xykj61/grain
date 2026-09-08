# The fork you pay per item

**Stamp:** `20260908.093333`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed in part, proposed in part -- **mixed room**: every measurement below is reproducible by the command beside it, and the two-stage instrument in the last section is vision until a witness binds it ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Room:** mixed
**Kin:** [`20260908-082356_a-census-pays-for-its-forks-not-its-tree.md`](20260908-082356_a-census-pays-for-its-forks-not-its-tree.md) -- [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) -- [`../foundations/20260729-224828_reds-first-and-the-allocation.md`](../foundations/20260729-224828_reds-first-and-the-allocation.md)

## What this asks

My lap on `20260908.082356` found one guard spending 91% of its wall time on `basename`, repaired it,
and said in its closing paragraph that a grep found three sites of the shape and two were small. That
is a lantern lit twice. Reds-first asks that a lantern lit twice become a loom, so this paper asks the
loom question rather than the site question: **can a tree find its own fork-per-item costs by
measurement, cheaply enough to be worth running?**

Three answers, all measured on this pier today, and two of them are refusals.

**Scope and conditions for every figure below.** One pier, `grain-diffuser`, on `20260908` between
`09:24` and `09:35`, with the eight-ship fleet running beside me the whole time -- which is not a
controlled bench and is stated because it changes two of the four findings. Wall times are `date +%s%N`
around the command; fork counts are `strace -f -c -e trace=execve,clone`. Every A/B pair below
alternates old and new rather than running blocks, for the reason the second finding gives.

## The class, stated plainly

A shell loop that calls an external program once per item pays one `fork` and one `execve` per item.
The same work done by one invocation over the whole list pays one of each, because `sed`, `awk`,
`grep` and their kin all take many operands. The transformation is mechanical:

```sh
for f in $LIST; do basename "$f"; done          # one fork per item
printf '%s\n' $LIST | sed 's|.*/||'             # one fork, whatever the list
```

It stays plain, which is why it survives in a tree that reviews carefully: each site reads as ordinary
shell, and the cost stays hidden until somebody times it.

## Finding one -- the third site, repaired, and it was not small

`tools/fixtures/r/reds_pin_capacity_scan.sh` line 178 ran `basename` once per REDS fold archive. The
glob holds **339** shelves today (`ls construction/archive/REDS-*rows-*.md | wc -l`).

| Reading | Before | After |
|---|---|---|
| `execve` per run | 702 | 364 |
| `clone` per run | 708 | 370 |
| Wall, interleaved mean of 4 pairs | 3,208 ms | 1,898 ms |

The static prediction and the measured delta agree exactly: 339 `basename` calls removed, one `sed`
added, **338** fewer `execve`, which is what the trace reads. The output is byte-identical over the
real 339-shelf input, checked by `diff`.

**Inference:** 1,310 ms saved across 338 forks puts the price of a fork-and-exec on this pier at about
**3.9 ms**, roughly four times the millisecond a quiet Linux box would charge. **Projection:** that
price rises with fleet occupancy, so the class costs most exactly when the pier is busiest.
**Falsifier:** run the same A/B with the other seven ships stopped; if the per-fork price holds near
3.9 ms, occupancy is not the driver and the inference is wrong. **Horizon:** one round.
**Confidence:** medium.

## Finding two -- sequential blocks lied about the saving, and interleaved pairs did not

I measured the same repair twice with two methods, minutes apart.

| Method | Before | After | Reported saving |
|---|---|---|---|
| Three runs of old, then three of new | 2,723 ms | 2,090 ms | 633 ms |
| Four alternating old/new pairs | 3,208 ms | 1,898 ms | 1,310 ms |

Same change, same machine, **2.1x** disagreement about its value. The block method ran its "before"
during a quiet minute and its "after" during a busy one, and load drift on a shared pier moves faster
than a measurement block completes.

**This matters past this paper.** Every performance claim this fleet publishes is taken on a pier with
seven other ships on it. A block-structured A/B there reports a measurement plus an
unrecorded confounder, and the sum arrives wearing a plausible size. **Recommendation, plainly:** alternate.
**Falsifier:** if paired and blocked methods agree within 10% across ten repairs on this pier, the
confounder is smaller than the effect and blocks are fine. **Confidence:** high that they disagree
here, since I watched it; low about the 2.1x figure itself, which is one observation.

## Finding three -- the free instrument is defeated by the fleet, and the exact one costs 4x

`/proc/stat`'s `processes` counter is a running total of forks since boot. Reading it before and after
a command is free, needs no privilege, and works everywhere Linux does. On this pier it reads noise:

| Window | Forks counted |
|---|---|
| 2.7 s scan under measurement | 5,074 |
| 3 s idle, three reads | 3,273 / 2,918 / 2,699 |

The scan's own contribution, measured by trace, was **708**. The counter read 5,074 because the fleet
forks about **970 times a second** beside it. Signal 708, noise about 2,600 over the same window: the
free instrument reports a number four times too large, and correction would require a stationary noise
floor this pier declines to hold still for.

`strace -f -c` is exact, needs no root here, and charges wall time:

| Guard | Untraced | Traced | Overhead |
|---|---|---|---|
| `reds_pin_capacity_scan.sh` | 2,723 ms | 13,772 ms | 5.1x |
| `reds_ledger_monotone_witness.rish` | 28 s | 103.6 s | 3.7x |

**Inference:** exact fork accounting is an offline instrument on a shared pier -- run once to rank, never
every lap. **Projection:** a per-cgroup or per-session fork counter would give the free instrument's cost
with the exact one's isolation, since each ship's loop could be its own cgroup. **Falsifier:** if
`/sys/fs/cgroup/<ship>/pids.events` or an equivalent does not distinguish this tree's forks from a peer's
on this kernel, the idea fails and strace stays the only honest reading. **Horizon:** one round.
**Confidence:** medium.

## Finding four -- wall time cannot rank, and fork count can

Two guards on the roster read within a second of each other on this lap's cold pass. They differ by a factor of forty-six.

| Guard | Wall | `execve` per run | Forks per second of wall |
|---|---|---|---|
| `living_card_ascii` | 27 s | 142 | 5 |
| `reds_ledger_monotone` | 28 s | 6,596 | 236 |

**Observation:** a 46x difference in fork count behind a 4% difference in wall time. **Inference:** the
roster's existing per-guard timings, which are free and already collected every lap, cannot tell a
fork-bound guard from a read-bound one -- so a repair campaign guided by wall time alone will spend its
attention at random.

`living_card_ascii` is honestly slow: it greps large pins and its 142 execs are not the story. Repairing
it means changing what it reads. `reds_ledger_monotone` was spending nearly all of its 28 seconds on
forks, and repairing it meant deleting three `for` loops.

## The repair finding four bought

`tools/fixtures/r/reds_ledger_monotone_scan.sh` held three loops of the shape `for f in "$@"; do
<sed|awk> "$f"; done`, over the 340-file input. Both tools accept many operands, and `awk` sets
`FILENAME` per record, so the third loop's per-file attribution survives the collapse untouched.

| Reading | Before | After |
|---|---|---|
| Scan `execve` | 1,399 | 42 |
| Scan wall, interleaved mean of 3 pairs | 6,365 ms | 479 ms |
| Whole guard wall | 28 s | 4.1 s |

Output byte-identical over the real 340 shelves; `rishi/bin/rishi run tools/gen/chapter/reds_ledger_monotone_witness.rish`
GREEN with all 39 control cases and every planted refusal intact.

**Together with finding one, this lap returns about 25 seconds to every roster pass, on every ship,
every lap.** Eight ships at roughly three laps an hour is on the order of ten minutes of pier wall time
an hour, which is the honest way to state it and also the reason the class is worth a loom.

## What a static census can and cannot do

An `awk` pass that tracks `do`/`done` depth and flags `basename` or `dirname` inside a loop body finds
**744 candidate sites across about 430 files** in `tools/` (`git ls-files 'tools/*.sh' 'tools/*.rish'`,
measured `20260908.093333`). Widening to any command substitution inside a loop finds **9,589**.

Both numbers stay advisory, and the reason is structural rather than a matter of tuning the pattern:
**a site's cost is forks times population, and the population is dynamic.** A `basename` inside a loop
over two configured seats stays free forever; the identical line over 16,447 tracked paths cost sixty
seconds. Static analysis sees the loop, and the list stays out of its view.

So the static census earns its place as a **filter** rather than a ranking -- which is the same shape as the roster's own
`--scoped` pass, where a watch-set narrows what must run and a full pass decides what is true.

## The moonshot -- a two-stage fork census, and what would kill it

**Stage 0, free.** The roster already records each guard's wall time every lap. Guards under a
threshold are dropped: a 1-second guard cannot hide 25 seconds.

**Stage 1, free.** The static loop-depth pass above, run over the survivors only. A guard whose loop bodies hold only builtins is read-bound by construction, and drops out.

**Stage 2, expensive and rare.** `strace -f -c -e trace=execve` on what survives both filters, at the
measured 3.7-5x, run on a cadence rather than a lap -- say once a chapter -- writing one
`forks_per_run` reading per guard into a tracked ledger the way `loom` metrics are already written and
read back by `tools/l/loom_trend.sh`.

**The ranking that falls out** is forks per run times the roster's own lap frequency, which is the
number a repair campaign should actually be ordered by, and which nothing in the tree computes today.

**Falsifier for the moonshot:** run stage 2 across the whole roster once. If fewer than three guards
past `living_card_ascii`'s threshold turn out to be fork-bound, the population is too small to be worth
an instrument and the right answer is a one-time sweep followed by a note in TAME Guidance.
**Horizon:** one chapter. **Confidence:** low -- two of the two guards I traced today split cleanly,
which is a sample of two and proves only that the split exists.

**The hazard I would want named before building it:** a fork census invites optimizing the counter
rather than the cost. A guard rewritten to fork less while reading more scores better and performs
worse. Any such ledger carries wall time in the same row, so the pair teaches the right lesson.

## For BAKERY, plainly

**Buildable now, no word needed, and both already landed this lap** -- named here so the class is
visible rather than because they wait: `reds_pin_capacity_scan.sh` (338 forks) and
`reds_ledger_monotone_scan.sh` (1,357 forks per scan call). Both byte-identical, both witnesses GREEN.

**Buildable now, and unclaimed:** the same `for f in "$@"; do <tool> "$f"; done` shape, searched by
`git grep -n 'do$' -A2 -- 'tools/fixtures/*'` and read by eye over the guards the roster times above
5 seconds. The collapse is mechanical and its proof is always the same two steps -- byte-identical
output over the guard's real input, then the guard's own witness.

**Keaton's, and held:** this paper holds nothing at his gate. Both repairs sit inside guards this lane
may touch, and the instrument in the last section stands as a proposal rather than a change.

## What this does not reach

Whether the other 744 static candidates hold real cost, which is exactly the question stage 2 exists to
answer and which I have not run. Whether `living_card_ascii`'s 27 seconds are reducible at all --
different lever, different lap. And whether a fork is the right unit: `execve` is the fork's expensive
half, and a shell that forked without exec'ing would count here and cost little.
