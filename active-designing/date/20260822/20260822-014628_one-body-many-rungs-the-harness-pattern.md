# One Body, Many Rungs -- the Harness Pattern, and What Sameness Can and Cannot Tell Us

**Stamp:** `20260822.014628`
**Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Mixed -- a living design essay: the pattern is reasoning, the counts beside it are measured
**Room test:** worth reading if every line of the Caravan ladder were deleted -- the pattern and its two failure modes outlive the ladder that taught them
**Kin:** [`../foundations/20260822-014628_the-mechanism-and-the-metaphor.md`](../foundations/20260822-014628_the-mechanism-and-the-metaphor.md) - [`../foundations/20260821-175723_the-words-a-round-uses.md`](../foundations/20260821-175723_the-words-a-round-uses.md) (lift, fold, carry, delegate) - [`../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md`](../foundations/20260811-211431_the-lindy-effect-and-the-long-return.md)

---

## The shape

A ladder is a family of modules that answer the same contract in different ways. Each rung holds its own constants, its own error set, its own types, and its own reason for existing -- and every rung must also perform a set of steps that belong to the ladder rather than to any rung.

Written the obvious way, those steps stand once in every rung. Written the way this essay argues for, they stand **once in a harness**, and each rung keeps a small published call that hands **itself** in:

```
pub fn note_path(buf: *[max_note_path_len]u8, domain: []const u8, suffix: []const u8) NoteError![]const u8 {
    return ladder_checks.note_path(@This(), buf, domain, suffix);
}
```

The parameter carrying the rung's own type is the whole trick. The harness body is written once, and it reaches `max_note_path_len`, `NoteError`, and `note_dir` **through whichever rung handed itself over** -- so one body serves forty-seven different vocabularies without knowing any of them at authoring time. The rung supplies the nouns; the harness supplies the verb.

This is why the small call must stay rather than being deleted along with the body. It is not ceremony left behind by a half-finished lift; it is the binding that ties a generic verb to a particular rung's nouns. Removing it would require the harness to know every rung by name, which is the coupling the pattern exists to avoid.

## What it costs and what it returns

The accounting is worth stating plainly because it is the part a meter gets wrong.

A fold **returns** the family's carried lines and **costs** one small call per member. A body of seventy-two lines standing in seventeen rungs returns roughly seventeen times seventy-one. A body of seventeen lines standing in seventy-nine rungs returns roughly seventy-nine times fourteen. Width and depth are independent, and their product is a poor sort key: the widest fold available on this ladder was also the cheapest to perform, because the body was seventeen lines rather than a hundred and thirty-seven.

The cost is bounded by the **signature**, since a call costs about one line per line of signature. A one-line signature gives nearly the whole body back; a six-line signature keeps most of it. That single fact reorders any queue built on carried lines alone.

## The principle is not sameness

Sameness is how duplication is **found**. It is not what makes duplication wrong.

What makes it wrong is that one fact lives in many places, so the places may come to disagree, and no reader can tell which one is authoritative. The principle is **one fact, one place**, and it has a consequence sameness does not: two bodies that happen to be identical today, for unrelated reasons, are two facts rather than one, and folding them together creates a false agreement that will have to be broken later at a worse moment.

The test is therefore never *are these the same?* It is **would a change to one of these have to be a change to all of them?** When the answer is yes, they are one fact and belong in one place. When the answer is no, they are neighbors, and neighbors stay where they live.

This ladder produced the distinction in practice more than once. Bodies of the same name at thirty-five, fifty-one, fifty-four, fifty-seven, and sixty-nine lines were left exactly where they stood -- genuinely different work that happened to share a name. Two rungs held bodies at *exactly* the family's length and stayed, because each of them **owns the measure it reports**: for those rungs the step is the point of the rung rather than a service to it. Both times, the rung that refused the fold turned out to be the one the fold was about.

## Two ways a sameness meter misleads

Both were found by measurement rather than by suspicion, and both are general.

**It ranks by the gross figure.** A queue sorted by carried lines is sorted by what a family *holds* rather than by what folding it *returns*. Since the return is the carry less the calls, and the calls scale with the signature, the head of such a queue is often not the best move available. The family that actually returned most sat several rows down, behind a family whose long signature ate most of its own gain.

**It splits a family it cannot see.** A meter keyed on whole body text is exact about what it compares and silent about what it splits. One family of forty-seven turned out to be reported as three, divided by a single keyword and by one word of a comment. Nothing about the *work* differed. A comment that drifts by one word across eleven files is invisible to every human reader and decisive to every text-keyed measurement -- which is itself the strongest available argument for lifting a body the moment it is written twice, rather than on the lap a meter happens to notice it.

Both faults share a temper: **honest and incomplete**, which is a different thing from wrong. The repair in both cases was to read a second number beside the first, rather than to distrust the instrument.

## The order of operations

Read the harness before the meter. Hash every body of the name across the whole family before writing a line, so the shape is known rather than assumed. Check the contract -- every symbol the body reaches for -- across every member **before** the fold, since the compiler will otherwise find the one rung that declared a needed name privately, and it will find it one file at a time.

Widening is the honest cost to watch. A fold that publishes a name which was private is a real change to a rung's surface, and it wants counting even when it costs nothing a meter reads. Four folds in a row on this ladder needed none, which is worth knowing precisely because it cannot be assumed.

## What survives the code

Three things, and none of them depend on the ladder that taught them.

**A generic body can serve many particulars by taking the particular as a compile-time parameter**, and the small call left at each site is structural rather than residual.

**One fact, one place is the principle; sameness is only the detector**, so the fold test asks whether a change would have to propagate, never whether two texts match.

**A measurement that ranks by a gross figure, or that keys on exact text, is honest and incomplete** -- and the answer to an incomplete meter is a second reading rather than a discarded instrument.
