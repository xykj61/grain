# The guard that reads its own control

**Stamp:** `20260916.200848`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **mixed room**: the census is checkable and bound by
[`../tools/c/control_in_population_witness.rish`](../tools/c/control_in_population_witness.rish);
the perturbation reading is a bounded sample and says so; the ruling between the two doors is
judgment and is named as judgment.
**Room:** mixed
**Kin:** [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) --
[`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) --
[`../foundations/20260826-021734_water-the-row-that-tastes.md`](../foundations/20260826-021734_water-the-row-that-tastes.md) --
[`20260916-112900_deterministic-and-degenerate.md`](20260916-112900_deterministic-and-degenerate.md)
**Instruments:** [`../tools/fixtures/c/control_in_population_scan.sh`](../tools/fixtures/c/control_in_population_scan.sh) --
[`../tools/fixtures/c/control_in_population_control.sh`](../tools/fixtures/c/control_in_population_control.sh)

## The defect lives in the pair

A **control** proves a refusal by containing the thing refused. A **scan** proves a tree clean by
reading a population. Both are ordinary, and both are right. Where the population includes the
control, the two correctnesses pull against each other: the control cannot carry its plant without
the live meter counting it.

What makes the class worth naming is that the pull is invisible from inside either file. Read the
scan and it is careful. Read the control and it is thorough. The fault appears only when you hold
the two together, which is a thing no guard in this tree was doing.

## What it cost, once, measured

On `20260916` this ship built `tools/fixtures/a/awk_lcg_exact_scan.sh`, which reads every tracked
`.sh` and `.rish` source for an awk generator whose arithmetic leaves the range a double holds
exactly, and gates the fed-back class at **zero**. Staging its own control took the live reading
from `overflowing=0 exact=7 unread=17` to **`5 / 8 / 18`** and reddened that gate -- on five
generators existing only to be refused inside a pen.

The author had already solved the identical class one step over: the scan reads past a `#` line so
its own header stays outside its own count. The question stood unasked of the **control**, whose
plants are code rather than prose. One file, two roles.

## How large the class is

Measured `20260916.200848`, this tree, at `352c17beb` with this family staged, by
`sh tools/fixtures/c/control_in_population_scan.sh`. Every figure below is **free** -- the tree
grows and each reading moves with it -- so run the command rather than reading the number.

The census reads each tracked `*_scan.sh`, extracts that scan's **own** `git ls-files` invocation
from its source, **runs** it, and asks whether any tracked file sharing the scan's basename stem
stands inside the population that comes back.

| Reading | Count | What it means |
|---|---|---|
| `scans_tracked` | 375 | every tracked `*_scan.sh` |
| `enumerating` | 120 | an invocation was extracted, admitted, and returned files -- **the measured denominator** |
| `membership_test` | 21 | the only call is `--error-unmatch <path>`, a predicate over one path rather than a population |
| `enumeration_refused` | 36 | a call stands and could not be run safely, almost always a glob held in a shell variable |
| `no_git_population` | 198 | the scan names no `git ls-files`; most read one module directory or run a built program |
| `self_reading` | 55 | of the 120, the population holds a tracked file of the scan's own family |
| `self_reading_control` | 39 | of those, the family file is a `_control.sh` |

**Thirty-nine of one hundred and twenty.** The founding case was ordinary: roughly a third of the
measured class.

**And of those thirty-nine, thirty-two gate at zero.** Read the same stamp by asking each family's
`*_witness.rish` whether it asserts a `contains "<field>=0"`: **32 gated, 5 ratchet, 2 whose witness
stands under another name.** A gate at zero is where the pull is sharpest, because a gate cannot hold
a control that must carry the refused shape. A ratchet absorbs it and reads **inflated** instead,
which is quieter, and quiet is the harder half to repair.

## The denominator had to be split four ways, and finding that out was the lap's own red

A first draft of this scan reported a single `enumeration_unread=269` against 374 scans -- 72
percent unmeasured, which is a number too weak to publish. Reading up close, as the water row's
own instruction asks, found that one word was carrying four different facts, and that **inside it
the scan was silently dropping every bare `git ls-files`**.

A bare `git ls-files` is the **whole tracked tree**: the broadest population a scan can read, and
by a wide margin the likeliest to hold a control. It was being discarded by a filter written to
drop prose mentions of the command. The instrument built to measure a class where one file carries
two roles had itself written one word carrying two meanings -- which is
[`single-stranded`](../foundations/20260823-204456_single-stranded.md) doing its ordinary work.
The control's leg `bare_ls_files_enumerates` is that fault's regression guard, and planting the
filter back fails **18 of 19 legs**.

## Whether the exposure actually bites

Structural exposure names a shape; a live fault is a separate reading. The exact question is
whether a scan's numbers **change**
when its control leaves the index, and that is answerable by doing: add a detached worktree, run
the scan, `git rm --cached` the control, run it again, compare.

**Measured over all 39**, in a detached worktree at `352c17beb`, `20260916`. Two carry no control
under their own stem, so 37 were probed; each probe costs roughly two to three minutes.

| Verdict | Count | What moved |
|---|---|---|
| `unmoved` | 24 | the scan reads its own control and finds nothing in it |
| `moved`, denominator only | 9 | `exec_bit`, `instrument_refusal`, `pen_entry`, `pen_release`, `process_reach`, `shell_comment_ascii`, `shell_written_ascii`, `tool_letter_room`, and one more -- a file count grows by one |
| `moved`, measured reading | 2 | `ignored_walk`, `plant_liveness` |
| `moved`, **verdict flips** | 2 | `tracked_link`, `phantom_path` |

**Thirteen of thirty-seven move, and two of them flip a verdict** -- so the exposure has a live
half, at roughly a third of the class. `awk_lcg_exact` itself reads `unmoved` today, which is the
repair from `%779` proving itself: its numerals became shell variables and its plant heredocs
unquoted, so the pen still receives literal arithmetic while the tracked bytes carry no refusable
shape.

**The sample was measured twice, and the two runs agree line for line.** The first probe ran in a
pen this author then entered by hand to read one candidate up close -- two writers in one checkout,
which is the law the fleet already holds and this lap broke inside its own workspace. The repair
was to discard that run, open a second detached worktree, and probe again with one writer. The 14
verdicts the two runs share came back identical, so the contamination left no mark, and that is a
measurement rather than an assurance.

## The bite has two directions, and only one was expected

**Inflation, the expected direction.** `tools/fixtures/i/ignored_walk_scan.sh` reads, with and
without its own control in the index:

```
sites=153             sites=137
walks_tree=48         walks_tree=35
unresolved_root=74    unresolved_root=73
off_tree=31           off_tree=29
ceiling=27            ceiling=27
verdict=over_ceiling  verdict=over_ceiling
```

The control contributes **13 of the 48** measured against a ceiling of 27 -- **27 percent of the
gated number** is the guard's own proof. The verdict holds either way, so nothing is presently
wrong; what is wrong is that a lane reading `48` as its work queue is reading 13 sites it can never
repair, because repairing them would break the control. `plant_liveness` shows the same shape more
mildly, its `plants_unresolved` reading 102 against 92.

**Dependence, the direction nobody was looking for.** Two guards go the other way: removing the
control makes the scan **red**.

```
tracked_link     living_links_outside_tree=0  ->  1     verdict=ok -> link_outside_tree
phantom_path     phantom_paths=0              ->  1     verdict=ok -> phantom_paths
```

In each, a living file cites the control by path -- `phantom_path`'s own witness names it, and a
folded REDS shelf names `tracked_link`'s -- so with the control untracked the citation points at
nothing. **The guard's green is partly a statement about its own instrument rather than about the
field.** Neither is a defect today: the control does exist and should. What it means is that a
rename of the control reds the guard for a reason that has nothing to do with the tree's health,
and a reader meeting that red would look in the wrong place first.

**Inflation was the hazard the founding case taught, and it is the less common of the two.**

## Two doors, both already seated in this tree

The census reports, and the ruling stays with the lane. It tells a reader there is a door to choose.

**Move the plant.** `%775`, `20260916`: keep the population whole and take the refusable shape out
of the tracked bytes -- numerals into shell variables, plant heredocs unquoted. Right where an
exclusion would blind the next control to the same lesson, and right where the plant can survive
the move.

**Read past the fixtures.** `tools/e/empty_document_witness.rish`: *instrument and never field --
a meter that reddens on its own proof is the lesson REDS %157 and %158 each paid for once.* Right
where the plant cannot leave without ceasing to be a plant.

The two are in genuine tension. `%774` warns that reading past `tools/fixtures/` is a wide
exclusion -- 18 of 24 sites in that family lived there -- so the second door can hide the very
population a guard exists to read. **Which door fits is a judgment about the particular guard**,
and this paper claims only that the judgment is currently being made by nobody, because nothing
was asking the question.

## The census is a member of the class it counts

This family's scan reads every tracked `*_scan.sh` with a bare `git ls-files`, so its own control
stands inside its own population. `--explain` on the scan names it, and staging the pair moved the
live reading from 374/119/54/38 to **375/120/55/39** -- the `+1` in each column is this instrument
entering its own census.

That stays free here, for two reasons worth stating rather than assuming. The scan **reports
rather than gating**, so every reading it prints is a count rather than a wall. And every plant this family writes is written
into a pen repository at run time by a heredoc, so no tracked file of the family carries a
`_scan.sh` basename except the scan itself -- which is `%775`'s ruling applied by the instrument
that measures `%775`'s own subject. The control's leg `plant_not_tracked` holds it there, and it
failed honestly until the pair was staged.

## What would kill this

**The claim:** 39 of 120 measured scans read a population holding their own control, 32 of those
gate at zero, and 13 of 37 probed families change their reading when the control leaves the index
-- two of them changing their verdict.

**The falsifier, in three parts, each checkable in one command each.** Re-derive the gated split by
asking each family's witness for a `contains "<field>=0"`; find far fewer than 32 of 39 and the
sharpest half of the finding goes. Re-run the perturbation probe at a later commit; a rate far
under 13 in 37 says this measured one afternoon's tree rather than a standing property. And read
`ignored_walk`'s 13 sites one at a time: if they are genuine tree walks the lane *should* repair,
the clearest inflation case is no defect and the live half rests on `plant_liveness` alone.

**What would NOT kill it,** named so the claim stays falsifiable rather than elastic: the two
verdict flips are real either way, since `tracked_link` and `phantom_path` each read `ok` with
their control tracked and red without it, and that is a fact about the pair rather than a judgment
about it.

**Confidence.** High that the counts are what the instruments say: 19 control legs on real git
repositories in a throwaway pen, three mutations proven to bite, and a perturbation probe run twice
with its overlapping 14 verdicts identical. Moderate on how much the class matters, since 11 of the
13 moves are denominators or unflipped numbers and a reader could fairly call those cosmetic. Low
on which door any given guard should take, which is why the census reports and leaves the gate to
its lane.

## What this does not reach

**Two bounds, stated because both stand beyond this instrument's reach.** Upper, on enumeration: a scan may
enumerate broadly and then filter with a `case` pattern, so membership in the enumeration is not
proof the scan READS the file -- the perturbation probe is the exact reading and it is expensive.
Lower, on family: the pairing is by **basename stem**, which is a naming convention, and this tree
names some controls for the FAMILY rather than for the tool. The water row's own cardinal seat
teaches that a measurement finding evidence by name reports the convention it was handed, so the
true count is at or above 39.

**A second population stands wholly unread.** Thirty-nine scans root a `find` rather than a
`git ls-files`, and **12 of them root it at the repository root or at `tools/`** -- which can reach
a control exactly as a tracked enumeration can. Those 12 are named here as the unread population, printed rather
than folded into a zero. Closing them needs the scan's own variable definitions, which means
sourcing it, which has side effects; the perturbation probe reaches them with no such cost and is
the honest next instrument.

**Whether a guard is worth having.** This proves that a guard and its proof can disagree about one
tree, and stops there.

*May every meter and its proof stay honest about each other, and may the question be asked while
the answer still costs one lap.*
