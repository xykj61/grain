# The Instruments That Were Never Pointed Inward

**Stamp:** `20260823.162138` - **Style:** Gauge, Field setting - **Lens:** TAME - **Status:** Living

**What this is.** A field report from one day of auditing a repository's own measuring
equipment, written so you can run the same audit on a codebase you maintain. Every number
below is measured on one tree on `2026-08-23` and stated with what produced it. Nothing here
is a benchmark against other projects, because no comparable measurement was taken.

## The finding, in one paragraph

A tree carrying **1,360 witnesses** and **31 standing guards** (counted `20260823.162138` by
`ls tools/*/*_witness.rish` and `grep -c '^guard ' construction/standing-equipment.kyri`) spent
sixteen hours auditing its own instruments. It booked **twenty-three ledger rows** in that
window, `%150` through `%172`. **Every single one lived in the measuring equipment or in the
tree's description of itself, and none lived in the code the equipment watches.** The software
was sound the whole time. What had drifted was everything the software said about itself.

That ratio is the finding. If you keep guards, the odds are good that your guards are the least
guarded thing you own.

## Six shapes, each earned by a distinct failure

These generalize past the tree that found them. Each one is stated as the rule first, then the
day's own case, so you can check yours against it.

### 1. A repository tracks more kinds of content than your guards read

Guards get written against **lines**, because a diff shows lines. A repository carries more
than that. This one carries **file mode**, and a rewrite that moved a temporary file over each
original dropped mode `100755` to `100644` on **thirty-nine tracked files** inside a commit that
`git show --stat` reported as `1 file changed, 0 insertions, 0 deletions`. One of the thirty-nine
was the script an unattended loop invokes as `./tools/ag/agent-jail.sh`, so the loop answered
`Permission denied` once every twenty seconds through a night. Every standing guard stayed green,
because every standing guard read lines.

Once that class was named, the same question found two more classes the same day: **emptiness**
(two tracked documents holding zero bytes for twenty-three days, both green to every link
checker, since a link to an empty file resolves perfectly) and **register** (see shape 5).

The general form: **list the kinds of content your repository tracks, then ask which of them any
guard reads.** Mode, emptiness, symlink target, file encoding, and generated-file freshness are
five that commonly go unread.

### 2. A freshness check proves agreement, never truth

A generated page is often guarded by re-rendering it and comparing. That proves the page agrees
with its generator. It says nothing at all about whether the generator is right.

The day's case is exact: a generated library index rendered a witness count of **zero for all
thirty-eight rooms**, and its freshness guard passed **green**, because the page and the fresh
render were computed by the same broken generator. The page's own header warned that a confident
wrong zero is worse than no number at all.

The general form: **a generated page wants at least one reading a human or a second, independently
written tool would notice going to zero.** Agreement between a thing and its own source is the
cheapest possible check, and it is worth roughly what it costs.

### 3. A structural move silently retires every rule keyed on structure

This tree moved **1,920 flat files** in `tools/` into 42 rooms by first letter, and repointed
**8,503 path literals** as it went. Text references were handled. Four other kinds of reference
were not, and each fails quietly rather than loudly:

| Reference kind | Behaviour after the move |
|---|---|
| Shell glob `tools/*.rish` | matched everything, then matched nothing |
| `find tools -maxdepth 1` | same |
| `$(dirname "$0")/..` root climb | resolved one directory short |
| Tracked symlink target | invisible to any text rewriter |

The general form: **a move that changes depth retires every rule keyed on depth**, and a text
rewriter sees none of them. Before a large move, enumerate the non-textual ways your tree refers
to a path.

### 4. A roster is a sample, and an undrawn sample is an unchecked claim

Thirty-one guards stand on a roster. Roughly 1,360 witnesses stand in the tree. That gap is fine
as an economy and misleading as a coverage claim.

Drawing three witnesses at random from each of 29 rooms and running all 86 produced **twelve
reds**, which read honestly as four different things: five correctly refuse on this machine
(device-gated or OS-gated), three want a binary this pier has never built, two passed on a second
run, and **two are genuine module drift over five weeks old**. So the honest yield of one random
draw was two real findings the curated roster was never going to look at.

The general form: **run a periodic random draw across your whole test surface, and read its output
in categories rather than as a pass rate.** A red that is correct to be red is information, not noise.

### 5. Prose carries a register, and a register drifts unmeasured

This one surprised the tree most. Its front page and its founding statement both claimed to follow
a house style whose own guide measured **29% negative sentences**. Counted with a fixed word list
over sentences of four words or more, the front page read **46%** and the founding statement read
**54%** -- one of them twice as negative as the guide it named. Reading grade sat inside target
throughout, which is exactly why nobody caught it: the available meter measured the wrong axis.

Both were rewritten to **13%** and **7%** with every claim, number, and link held byte-identical,
which is the useful part: **register is separable from content, so a style pass can be proven to
have changed nothing factual.**

The general form: **if you have a written style, express one axis of it as a number a script can
count**, and put your front door on the enforced tier. The counted axis will be a proxy rather
than the thing itself, and a proxy you run beats a standard you admire.

### 6. Running the instrument can manufacture the fault the instrument reports

The day's last red is the smallest and the most instructive. A guard that checks every path a tool
reads against the tracked index answered red on a sound tree. The path it named is a **symlink two
witnesses create while they run**, into a build cache, and `.gitignore` names it. So the roster's
own run produced the artifact, and the next run reported it.

The repair is the general form: the scan had two hand-written guesses about which rooms are
generated. It now **asks git** -- `git check-ignore -q` -- on the handful of paths that resolve
locally and stand untracked. A path the repository is told to ignore is a **declared absence**, so
a reader who clones is promised exactly what they get.

The general form: **an instrument with side effects wants those side effects on its own exemption
list**, derived from a declaration rather than guessed from a name.

## What to take away

The original intention behind all of this was one line: `chmod +x`, so a loop would run again.
Sixteen hours later the intention had a different and larger shape, and it is worth stating
plainly, because it is portable:

> **A claim a codebase makes about itself is worth what a machine can check.** Everything else is
> a belief with a timestamp on it.

Three practical moves follow, in the order they pay:

1. **Enumerate the kinds of content you track**, and mark which have a reader. Mode, emptiness,
   encoding, and symlink targets are the usual gaps.
2. **Make one guard whose failure you have actually seen on metal**, both directions -- the case it
   should catch, and the honest case it should let through. A guard proven only in the passing
   direction is a guard that may read nothing at all.
3. **Draw a random sample of your own tests and run it**, then sort the results into categories.
   The first draw is usually the informative one.

## What this does not claim

Twenty-three rows in sixteen hours is a **discovery rate**, and a discovery rate is high when an
area has gone long unexamined. It says nothing about defect density, and this report offers no
comparison to any other project, because none was measured. The forecast it does support is narrow
and falsifiable: **a second audit of the same instruments, run within a month, will find
substantially fewer than twenty-three, and the ones it finds will cluster in whatever class this
one failed to name.** If it finds twenty-three again in the same classes, the repairs described
here were cosmetic and this report is wrong.

## Sources

Measured on one tree, `2026-08-23`, in the range `00:23` to `16:21` America/New_York. Row numbers
refer to that tree's own reds ledger, rows `%150` through `%172`. Counts come from
`git ls-files`, `git log`, and the named scan scripts, each of which prints its own numbers.
