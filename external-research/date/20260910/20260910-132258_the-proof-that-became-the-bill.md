# The Falsifier Answered, and the Proof That Became the Bill

**Stamp:** `20260910.132258`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Living -- **mixed room**: the four measurements are checkable and reproducible by the
commands named beside each; the fleet projection is vision until its own falsifier runs
**Lens:** TAME priority -- safety, then performance, then the joy of the craft
**Kin:** [`20260910-113724_two-rankings-and-this-tree-was-reading-the-wrong-one.md`](20260910-113724_two-rankings-and-this-tree-was-reading-the-wrong-one.md) (the elder, whose falsifier this answers) -- [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) -- [`../context/TAME_CORE.md`](../context/TAME_CORE.md)

**Erratum, added at landing (`20260910.153001`).** This paper and its repair were written at the
stamp above, and the round that carried them died at its send -- the record sat in a round-open
stash that no branch carried, which `stash_record` reported the next lap. It lands here unchanged
except for this note. Two figures below are true of the tree it measured and are not the tree it
lands on: the control carried **43 legs** then and **52** now, since a peer's fourth strand added
eight between the two stamps, so the leg this paper adds reads **53** rather than 44. Every wall
time, process count and ratio was measured on the earlier tree and is left exactly as taken. The
recovery re-proved both census modes byte-identical against the merged head -- 11 counts, 23 list
rows -- and re-ran the control at 53 legs with `legs_fail=0`.

Yesterday's paper published a distribution and one falsifier. This one runs it, and the answer
arrives with a second boundary attached that the first measurement could not see.

---

## What was asked

The elder paper measured the roster's cost and found it diffuse: 236 guards, 2,556,664 ms, the
worst single guard holding 6.0% of the pass. It also found the roster **bimodal** -- thirteen of
sixteen traced guards spending 2.06 to 8.83 ms per process, three spending 57.17, 103.62 and
311.23, with a factor of six and a half standing empty between the families. The cheap
family is arithmetic on text: a guard that starts a program per item, where one resident pass over
every item would answer the same question.

One number stood unexplained. A prior repair in this tree took `rune_assert_sweep` from 47.4 s to
2.0 s by exactly that move, and the elder paper let that ratio stand for a plan without
establishing whether it was the roster's shape or that one guard's item count. So it wrote a
falsifier:

> Rebuild `convergence_census` resident and measure it -- **under 3x says the ratio was that
> guard's item count, not the shape.**

`convergence_census` was chosen because it is the roster's process champion, and because its
answer is *reported* rather than gated, so a repair that changed its counts would be visible
without breaking a wall.

## Observation one -- the rebuild reads 8.7x, and the two readings are identical

Three interleaved A/B pairs, measured `20260910.132258` on the Vultr Dallas pier (AMD, 4 cores, 8
threads, 180 GB) under the ordinary eight-ship load, `TZ=America/New_York`:

| Pair | Original | Resident | Ratio |
|---|---|---|---|
| 1 | 157,722 ms | 18,000 ms | 8.76x |
| 2 | 162,575 ms | 20,313 ms | 8.00x |
| 3 | 177,807 ms | 19,061 ms | 9.33x |
| **Pooled** | **498,104 ms** | **57,374 ms** | **8.68x** |

**The pairs are interleaved on purpose.** An unpaired reading taken an hour earlier said 10.1x --
164,402 ms against 16,288 ms -- and the 1.4x between the two figures is this pier's load drift
rather than anything about the code. Every figure this tree holds for guard wall time was read
under a load left unrecorded, so a ratio drawn from two unpaired readings carries that drift
undeclared. **8.7x is the figure; 10.1x is what the same repair looks like measured carelessly.**

Reproduce it -- the original is recoverable from git and reads the real tree through its own
`CONV_ROOT` override:

```sh
git show HEAD~1:tools/c/convergence_census.sh > .lap/orig.sh   # before the repair
CONV_ROOT="$PWD" sh .lap/orig.sh    # then
sh tools/c/convergence_census.sh    # now
```

**Both modes are byte-identical.** The default reading and `list` were diffed row for row against
the committed original: 11 counts and 22 list rows, agreeing in both, on all three pairs.
Two intermediate readings were diffed the same way as each strand landed, and one strand's
extraction was proven identical at the row level -- **1,562 rows over 237 files** -- before it
replaced the reading it was standing in for.

So the falsifier is answered in the direction that seats the pattern: **8.7x, not under 3x.** The
ratio is a property of the shape rather than of one guard's item count.

## Observation two -- what the processes were doing

Counted with `strace -f --seccomp-bpf -e trace=execve`, which the elder paper chose because a
process count is the one figure this pier's load cannot move:

| Program | Before | After |
|---|---|---|
| `sed` | 7,411 | 0 |
| `grep` | 5,880 | ~130 |
| `awk` | 3,404 | 251 |
| `cat` | 3,391 | 2 |
| `head` | 1,502 | ~110 |
| `git` | 95 | 95 |
| **Total execve** | **21,944** | **2,114** |

**`git` held steady, and it was always the smallest term.** The guard reads the tracked tree, so a reader
expects `git` at the head of its bill; it stands at 95 calls of 21,944, four tenths of one percent.
The bill was arithmetic on text, in five ordinary programs, started once per item.

Three strands account for it, and each fell to one pass:

- **The write reading**, once per tool: `59,296 ms -> 6,427 ms`, 3,391 `awk` and 3,391 `cat` to one
  `awk`.
- **The loop's own length.** Its first act was always to read a file and skip it, so **3,154 of
  3,391 iterations existed to be skipped** -- only 237 tracked tools write into the tree at all.
- **The target resolution**, a hop loop spending about five `sed`, one `grep` and one `head` per
  hop: `68,502 ms -> 143 ms`, **479x**, identical on all 1,158 (file, target) pairs.

## Observation three -- a shared library forked a process to rebuild a constant

`tools/fixtures/l/live_lines.sh` holds this tree's shell lexer, made a library five days ago
because the same fault had been met in two rooms. Its `live_lines()` function read one file, and it
built the awk program it needed by calling `live_lines_awk()`, which is a `cat` heredoc.

So every call forked a `cat` to re-emit a string that is the same every time: **3,391 `cat` processes, 15.5%
of the guard's execve, for one static program printed 3,391 times.** Caching it in a variable is
the whole repair, and it reaches every caller of the library rather than one.

**The library had already written down the better pattern, and one of its two callers took it.** Its own header
offers `live_lines_awk` "to embed in a multi-file pass," and documents that the walker's state
"lives in `ll_st` / `ll_hd` / `ll_strip`, which a multi-file caller resets on `FNR == 1`." That
sentence is the resident rebuild, written in the library the day it was made. One of its two
callers took it; this census was the other, and read one file at a time for five days beside a
docstring describing the alternative.

## Observation four -- the proof is now the bill

This is the finding the first measurement was blind to, and it changes the plan more than the
ratio does.

A rostered guard is a **witness**, and a witness runs two things: the scan, which reads the tree,
and the control, which proves the scan's predicate from both sides on planted repositories. The
repair reached the scan alone.

Measured the same stamp:

| Part | Wall | execve | Share of the guard's processes |
|---|---|---|---|
| Scan, after the repair | ~19,000 ms | 2,114 | 18% |
| Control, untouched | 31,334 ms | 9,416 | **82%** |
| Witness total | 55,493 ms | ~11,500 | 100% |

**So the guard's roster cost fell about 2.5x while its scan fell 8.7x**, and the control it always
carried is now four fifths of its processes. The control is in the same cheap family by the elder
paper's own measure -- 31,334 ms over 9,416 processes is **3.33 ms per process**, inside the 2.06
to 8.83 band -- yet its work is of a different kind. It plants **43 legs** in real git repositories,
and 608 of its processes are `git`. A pen's `git init` is work rather than arithmetic, and it is
what *proven from both sides* actually costs.

**A resident pass answers a reading, and a proof stays where it stood.**

## The repair is proven from both sides, and finding that out cost one leg

**A control a rewrite passes has yet to prove that rewrite.** The control's 43 legs were written
against the shell implementation, so the question is whether any of them can still bite on the awk
one. Two mutations were planted in a copy of the census under the ignored `.lap/` room -- outside
the tree digest, so no tracked byte moved -- and the control run against each:

| Mutation | Control |
|---|---|
| `MAX_HOPS` 3 -> 4 in the resident hop loop | **RED** -- `git_hop_bound_refuses_past_three`, wanted no, read yes |
| the multi-match loop emits only the first match per line | **green, `legs_fail=0`** |

The first is the answer a rewrite wants: the bound is proven on the new code, by a leg planting a
four-deep assignment chain that must not resolve.

**The second is the finding.** `grep -o` returns every non-overlapping match on a line and awk's
`match()` returns one, so the resident pass carries a loop taking them all -- and **nothing in this
tree exercises it.** Mutated to read only the first match, the census left all 11 counts and all 22
list rows unchanged, and left the control at `legs_fail=0`. The strand rewritten hardest was the
strand no leg could hear.

So a leg was added rather than coverage claimed: a plant carrying two writes on one line, the
pen-targeted one first, so reading only the first match refuses the file and reading them all
admits it. It reads **green at 44 legs** on the census as it stands and **RED** on the mutation, and
the mutation was run again to prove it, since a leg proven only in the passing direction cannot be
told from a leg that cannot fail.

**The cheap lesson.** A byte-identical diff proves two readings agree on the population in front of
them. Agreement on a population both have yet to meet stays unproven, and a resident rewrite changes
exactly the code that would meet one.

## The inference, stated apart from the observations

The resident pattern is a property of how this tree's scans are written rather than of any one
guard's item count. Two independent guards now carry a measured ratio -- `rune_assert_sweep` at
23.7x, `convergence_census` at 8.7x -- and the structural reading behind them agrees in direction:
250 of 313 tracked scan fixtures carry a loop whose body starts an external program.

**What that inference leaves open** is how much of a guard's wall is scan and how much is
control, and observation four is the reason it now matters. One guard's split stands for one guard.

## The projection

**Horizon:** the next full roster pass after a resident sweep of the cheap family's scans, whenever
one is undertaken.

**Assumptions:** the elder paper's triage holds -- the cheap family holds 57.3% of sampled wall; a
resident rebuild buys 8x on a scan; and this guard's scan-to-control split of roughly 1:1.6 by wall
is typical of a rostered witness.

**The projection:** rebuilding the cheap family's scans resident buys the whole pass **about 1.6x,
not about 8x.** Taking the split at face value, 57.3% of the pass is in the family, of which about
38% is scan and 62% control; dividing only the scan portion by 8 leaves roughly 62% of the pass
standing.

**Falsifier:** measure the scan-to-control wall split across a sample of ten rostered guards. **Scans
above 70% of witness wall put the ceiling nearer 3x and retire this projection.**
Controls above 70% put it nearer 1.3x, and a scan sweep then costs more laps than it returns.

**Confidence: low.** One guard's split, generalized to 236. The direction is better founded than
the magnitude: a witness carries a proof, a proof plants repositories, and planting is not
arithmetic, so the ceiling on a scan-only sweep is genuinely below the scan ratio. How far below is
one measurement away and this paper does not have it.

## What this leaves whole

**Whether a guard is worth its wall at all.** Every figure here is about cost, and none of it says
a guard reads anything worth reading.

**The control's own shape.** Whether a control's 43 legs want 9,416 processes stays open here; a pen reused across legs rather than rebuilt per leg is a different repair, unmeasured,
and it is the next thing this strand should ask.

**The three expensive guards.** The elder paper's other family -- 57.17 to 311.23 ms per process --
stands untouched by any of this, and a resident reader reaches none of it.

May the next measurement land as plainly as this one, and may the reading that corrects it be
welcome when it comes.
