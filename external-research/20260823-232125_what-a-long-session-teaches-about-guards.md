# What a Long Session Teaches About Guards

**Stamp:** `20260823.232125` - **Style:** Gauge, Field setting - **Lens:** TAME - **Status:** Living

**What this is.** A second field report from the same day as
[`20260823-162138_the-instruments-that-were-never-pointed-inward.md`](20260823-162138_the-instruments-that-were-never-pointed-inward.md),
written after eight further hours of the same work. The first report covered an audit of one tree's measuring
equipment. This one covers what happened when that equipment was **used continuously**, by an author
writing new guards while the old ones watched.

Every number is measured on one tree on `2026-08-23`. The finding is about instruments under
sustained use rather than about this project.

## The headline

**In roughly sixteen further hours, five more faults were booked. Three of the five came from the
author that same day, and an instrument caught every one of the three ahead of review.**

That ratio is the report. It shows something about guards a static audit leaves out: **their value
compounds when the person writing them is also moving fast enough to slip.**

## Five patterns, each earned by a fault

### 1. A guard measures the tree it was run against, and only that tree

The order was: stage three named files, run the full roster, read **31 of 31 green**, then
`git add -A`, then commit. A build cache directory holding two dangling symlinks stood untracked
during the run and tracked at the commit. **The green described a tree that had already changed by
the time it shipped.**

**The rule: stage first, then measure, then read what you staged.** Obvious once stated, and it went
unstated for a long while, because in ordinary use the two orders agree.

### 2. Running an instrument can manufacture the fault it reports

A guard that checks every path a tool reads against the tracked index reported a phantom. The path
was a symlink two other guards **create while they run**, and the ignore file named it -- so the
roster's own execution produced the artifact the next execution reported.

**The rule: an instrument with side effects wants those side effects on its own exemption list**,
taken from a declaration -- here, asking git which directories are generated rather than guessing.

### 3. A rule with an optional part gets implemented two ways

The tree's canonical test for *is this file a dated record* required a separator that the naming law
makes **optional**. **237 files were named without it**, so every one classified as a living file, and the tool that
rewrites living files built its writable set from exactly that test.

The author then reproduced the same reading independently, from memory, and rewrote two records
before a check caught it. **The slip and the canon shared one model**, which is what made the slip
worth reading rather than merely repairing.

**The rule: an optional part in a rule is a fork in the rule**, and the reader most likely to take
the far branch is the one working from memory.

### 4. A ceiling can measure the wrong quantity

A new guard held broken links in old records under a falling ceiling. Then one index page was added,
five more documents became reachable, their long-standing broken links came into view, and the guard
refused. **The ratchet punished the tree for opening a door.**

The count is a function of *reach* as much as of *repair*, so it moves for two reasons and falls
reliably for neither. The ceiling was removed rather than raised.

**The rule: before ratcheting a number, ask what else moves it.** A ratchet over a quantity with two
inputs reports on both and measures neither.

### 5. Two copies can match byte for byte while one of them is wrong

A mechanism was built to let one document live at several paths, with a guard proving the copies
match byte for byte. It worked. Three commits later the canonical gained relative links, and **eight of them broke in the
copy**, since a relative link is depth-dependent and the copies sat at different depths.

**The guard stayed green, and it was right to.** The bytes matched perfectly. A link's correctness is
a property of bytes *plus location*, and the second half had been asked of nothing.

**The rule: when you replicate a thing, enumerate everything its correctness rests on besides
content.** Position, permissions, timestamps, and neighbours are the usual four.

## The pattern behind the patterns

Four of the five are one shape:

> **An instrument encodes a model of its subject, and the model has an edge the instrument cannot
> see.**

The exemption list modelled paths and left out side effects. The dated test modelled a separator it
treated as required. The ceiling modelled repair and left out reach. The mirror modelled content and
left out depth.

**In every case the guard behaved exactly as written.** Each was a model's edge rather than a defect,
which is why review passed over them and use found them.

## The practical recommendation

**Use your guards while you are still writing them, on real work, at speed.** That is the whole
recommendation, and the rest of this section says why it works. A guard reviewed and shelved has been
checked against its author's model of the world, which is the same model that drew its edge. A guard
*used* meets cases the author never imagined, and meets them while the author is there to read the
result.

The corollary is worth saying out loud: **a stretch of moving fast and slipping often is a good time
to build instruments**, since the instruments get a dense supply of real faults to be tested
against.

## What this does not claim

**Five faults in sixteen hours is a discovery rate**, and a discovery rate runs high while an area is
new. This offers no comparison to any other project, since none was measured.

**The falsifier:** the same tree, audited the same way in a month, should book substantially fewer
faults in these five categories. Should it book the same number in the same categories, the rules above
were stated without being absorbed, and this report describes a habit rather than a finding.
