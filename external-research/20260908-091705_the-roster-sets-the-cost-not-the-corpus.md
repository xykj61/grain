# The Roster Sets the Cost, Not the Corpus

**Language:** EN
**Stamp:** see the filename -- one clock, `America/New_York`
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Living -- **mixed room**: every timing below is checkable by rerunning the named
command on this pier, and the generalization to Caravan, Tally, and Mantra is research for
understanding until a witness binds it
**Kin:** [`20260908-082356_a-census-pays-for-its-forks-not-its-tree.md`](20260908-082356_a-census-pays-for-its-forks-not-its-tree.md) -- the elder measurement this one continues and, in one place, corrects

---

## The question, bounded

The elder paper measured one guard, `tools/fixtures/d/dated_path_scan.sh`, and found that 91.4% of
its run was a `basename` process per tracked file. It repaired that and closed at 15,070 ms, then
left a moonshot open: **would a stored, incrementally updated index beat the full scan?**

This paper answers that question, and reaches a plainer finding on the way. **Scope:** one guard,
one tree state, one machine -- the Linux pier holding `grain-diffuser` at commit `820e600a48`,
16,447 tracked files, measured `20260908.091312`. **Every number below is wall-clock milliseconds
from `date +%s%3N` around the named stage**, single runs unless stated, on a warm page cache.
Single runs are honest for differences of this size, and a difference under 20% would want repeats.

## Observation: where the fifteen seconds actually went

The guard was re-profiled by inserting timestamp probes at eleven statement boundaries in a copy
placed beside its own exclusions file, so `dirname "$0"` still resolved. The copy's sixteen output
lines were `diff`-identical to the tracked guard's, which is what makes the profile a reading of
the guard rather than of the probe.

| Stage | ms | Share |
|---|---|---|
| the corpus grep -- every reference in every tracked document | 1,940 | 13.3% |
| the re-admit, worktree, and path-roster filters | 76 | 0.5% |
| the asserted-absent grep | 281 | 1.9% |
| **the fixture-name subtraction** | **8,976** | **61.4%** |
| the awk classifier | 766 | 5.2% |
| the on-disk re-check of doubtful rows | 790 | 5.4% |
| the declared-absence loop | 2,230 | 15.3% |
| counts and the soundness check | 22 | 0.2% |
| **whole guard** | **14,610** | |

The tree-reading stages -- the two greps and `git ls-files` -- are **2,232 ms of 14,610, or 15.3%**.
The rest is the guard's own arrangement of work.

## Observation: a subtraction that removed nothing, at 5,179 ms

The fixture-name subtraction exists for a good reason. A control plants a filename built to name
nothing; the session log explaining the control then quotes that name; and a census must not count
the quotation as a broken reference. The roster of such names stood at **219** on this tree.

The elder shape rewrote the whole pairs file once per name:

```sh
while IFS= read -r _fb; do
  grep -v ":.*${_fb}\$" "$work/pairs.txt" > "$work/pairs.nofix"
  mv "$work/pairs.nofix" "$work/pairs.txt"
done < "$work/fixtures.txt"
```

Isolated on the exact pre-loop file -- 28,396 pairs, 219 names, dumped from a probe run so both
forms read identical input -- that loop cost **5,179 ms and removed zero lines**. Zero is the
expected reading rather than a fault: a planted name is built to name nothing, so the corpus
rarely quotes one, and the subtraction earns its place by being ready when a quotation appears.

`grep -f` takes the whole roster in one file and answers the same question in **397 ms**, a
**13.0x** reduction, with output `diff`-identical.

**Identical because the patterns stay patterns.** A basename carries a `.` before its extension,
and a `.` in a basic regular expression matches any character -- so `...citation.md` also matches
`...citationXmd`. All 219 names carry at least one metacharacter. Rewriting the loop as a literal
suffix test would have been faster still and would have **quietly changed the reading**, which is
the trap worth naming: the fast form has to inherit the slow form's semantics, including the ones
nobody intended.

Proven on planted input as well as on the tree, because agreement on a subtraction that removes
nothing proves nothing. Thirty lines were planted across six names in five shapes -- exact suffix,
a `docs/` prefix, the regex-dot bite, a line carrying no colon, and a trailing tail. Both forms
removed the same **18 of 30**.

## Observation: the same fault one file over, at 4,329 ms

With the subtraction repaired the guard read 10,178 ms, and the new hot stage was building the
fixture roster itself -- `dp_discovered_fixture_basenames` in
[`../tools/fixtures/d/dated_path_exclusions.sh`](../tools/fixtures/d/dated_path_exclusions.sh), at
4,695 ms. Its two pipelines are cheap: the sprig index over 16,447 paths costs **57 ms** and emits
8,639 sprigs; the candidate extraction over the witness, control, and scan sources costs **565 ms**
and emits 365 names.

The remaining **4,329 ms** was a `while read` loop running a `printf` subshell, a `sed`, and a
`grep -qxF` for each of those 365 candidates -- up to 1,095 processes. One `awk` over the same two
files: **14 ms**, byte-identical over all 184 names both forms emit. A **309x** reduction.

**This is the loop the elder paper measured and set aside.** Mid-bisect it read 4,036 ms, and the
elder lap recorded it as a wrong guess and kept looking for the larger prize. The guess was right
and merely smaller -- and once the larger cost went, it was 63% of what remained. A stage
dismissed at one tree state is worth re-reading after the stage above it is repaired.

## Observation: what a process costs on this pier

Two loops, measured a day apart, gave the same per-process constant -- 61,714 ms over 16,447 forks
is **3.75 ms**, and the candidate loop's cost divides the same way. Measured directly rather than
inferred: a trivial `sed` in a pipe, 200 times, costs **3.4 ms** each; a `grep -qxF` against
`/dev/null`, 200 times, costs **5.1 ms** each; a command substitution running only a shell builtin
costs **0.8 ms**. A `mv` of a 28,396-line file costs **3.5 ms**, and a one-pattern `grep` over that
file costs **9.4 ms**.

Those five numbers reconstruct both loops within the measurement's own noise, which is what makes
them a model rather than a coincidence.

## Inference: count the roster, not the corpus

**A shell scan's cost is set by how many times it starts a process, and a scan's roster is usually
what decides that.** The corpus here is 16,447 files and 28,396 reference pairs; reading all of it
costs 2.2 seconds. The rosters are 219 names and 365 candidates, and iterating over them cost 13.3
seconds.

This inverts the intuition a slow scan invites. The instinct is to narrow *what is read* -- fewer
directories, a tighter `--include`, an exclusion list one entry longer. The measurement says to
count *how many times the loop starts something*, because a roster two orders of magnitude smaller
than the corpus can still dominate by three quarters.

**The shape has now been found three times in this one family** -- one basename per file, one grep
per roster name, three processes per candidate -- and two other scans in `tools/fixtures/` already
carry comments recording that they paid for it once. A comment repairs the file it sits in. What
this family wants is a check that reads for the shape, and the honest reason to hold it one more
round is that its false-positive rate stays unknown: plenty of small loops fork legitimately, and a
meter that reds on those is a meter someone turns off.

## The moonshot, answered against itself

The elder paper asked whether a stored inverted index, updated per commit, would beat the full
scan, and named its own falsifier: measure the update cost against a real day's diff.

**The scan moved before the index could be built.** Full-run readings on one tree, each `diff`-identical
in all sixteen output lines:

| State | ms |
|---|---|
| at the elder lap's head | 75,153 |
| after the basename repair (`20260908.074500`) | 14,610 |
| after the fixture-subtraction repair | 10,178 |
| after the candidate-filter repair | **6,879** |

**10.9x, and the reading never moved.**

The arithmetic against an index is now plain. A stored index could skip the corpus grep and the
classifier's first pass -- **2,706 ms of 6,879, or 39%**. The verdict pass must still run whole whatever the index
holds -- the doubt loop, the declared-absence loop, and the counts -- because a single deleted file
can break references anywhere in the corpus. The floor for an
incremental run is therefore about **4,200 ms against 6,879 ms**, before paying for the index's own
storage, its invalidation, and the class of fault where a stale index reports a clean tree.

**Verdict: the full scan wins, and the moonshot closes.** A 39% ceiling on savings buys stored
state only in a guard that gains something else by holding it, and this guard's whole value is that
it reads the tree standing in front of it.

**Falsifier, stated so this can be killed:** if the remaining 4,200 ms of verdict work is itself
reducible to under 1,000 ms -- the declared-absence loop is 2,230 ms over 192 rows and looks like
the same fork shape a third time -- then the index's share of a much smaller total rises, and the
question deserves reopening at that point rather than now. **Horizon:** one round.
**Confidence:** medium-high on the arithmetic, which is measured; low on the claim that nobody
finds a cheaper verdict pass, which is exactly what the last two laps found twice.

## For BAKERY, plainly

**Buildable now, no word needed.** The declared-absence loop at
`tools/fixtures/d/dated_path_scan.sh` runs two `grep` processes per lost row -- 192 rows, 2,230 ms,
the same shape a third time. Batching it is mechanical and the equivalence argument is the one this
paper gives twice: keep the pattern a pattern.

**Buildable, and it wants a word first.** `dated_path` stands at `tier cadence` in
`construction/standing-equipment.kyri`. At 6.9 seconds it is affordable every lap, and the elder
paper's reason to wait still holds -- its gate reds on a number no lap may lower.

**Not buildable -- it is Keaton's.** The gate move the scan's own comment proposes, `refs_lost` to
`lost_promised_living`. One new observation for that decision: the count read **100** yesterday at
`20260908.082356` and **101** today at `20260908.091312`, three hours later, with no lap having
touched a reference. It rises as ships write logs, and falls for nobody. That is the elder paper's
projection meeting its first observation, in the direction it predicted.

## What this does not reach

Whether the fork shape stands in the other seven DISCOVERY guards -- the elder paper's sweep looked
for one spelling of it, and this paper found two more spellings in the guard it already knew.
Whether the per-process constant holds on the Mac door or inside an enclosure, both of which change
process-start cost. And whether any of this reaches Caravan, which supervises real processes rather
than shell loops: the 3.4 ms floor measured here is a plain fact about this kernel and this pier,
and what a supervisor should do about it is a question this paper opens and leaves to measurement.
