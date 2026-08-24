# Quality Assurance -- the report card and the stack

**Seated:** `20260824.161948` on Keaton's word - **Status:** Living
**Kin:** [`gauge-style`](gauge-style.md) (the four readings and the scale) - [`reds-first`](reds-first.md) (standfast, for what is wrong) - [`molt`](molt.md) - [`checkpoint`](checkpoint.md) - [`stamp-and-name`](stamp-and-name.md)
**Guide:** [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md) -> *Quality assurance -- the report card*
**Meter:** [`../../tools/q/qa_report_card_witness.rish`](../../tools/q/qa_report_card_witness.rish)

**Read every artifact you touch, grade it, and let the grade decide what happens next.** A document,
a module's comments, a design. One grade, four readings, a plain school scale, and a door at **B**.

```
sh tools/fixtures/qa_report_card.sh <path> [--setting door|field|meter] [--service N]
```

## The habit, in one line

> **Touch it, read it, grade it. B or better stands. Below B pushes a frame.**

The four readings -- **Register**, **Reach**, **Truth**, **Service** -- and the scale live in
[Gauge Style](gauge-style.md). This rule is what the tree *does* with the grade.

## Stack-driven, and why a stack rather than a queue

A sweep touches a document, the reading comes back below B, and there are two honest choices: finish
the sweep and write the repair down somewhere, or repair it now. A list written down grows faster
than anyone works it -- this tree has watched that happen to four ladders. So the reading **pushes a
frame** onto the round's stack, the frame is worked down, and the sweep resumes where it paused.
That is a call stack, and it is stack-driven for the same reason a call stack is: **the work most
recently discovered is the work whose context you are still holding.**

The rhythm has two parents and takes one thing from each. From **standfast**: discovery interrupts,
rather than being filed for later. From the **itinerary**: a frame that outlives the session becomes
a line on the living card, so nothing found is lost when the session closes.

**It is not a standfast.** Standfast stops the line for a **red** -- something that is *wrong*, which
books the whole remaining allocation until a witness on metal closes it. A grade below B is
something that could be **better**, which is a different weight and earns a lighter move. Calling a
C+ document a red would spend the word that stops the line on prose, and then the word stops
stopping anything.

## The stack is bounded at depth 2

Repairing a document touches documents, which get read, which push frames. Unbounded, a sweep
recurses until the day ends.

**Depth 1** is the sweep. **Depth 2** is a frame pushed by the sweep -- work it now. **Anything a
depth-2 frame would push is written as a line on `construction/ITINERARY.md` instead**, and the
stack unwinds. Bound everything; this is the bound, and depth 2 is where it sits because one level
of repair keeps the context you already hold while two levels have already lost it.

## What a frame does

A frame is a **molt**, and which molt depends on what the artifact is. Both shapes are already
seated in [`../../construction/SHRED_PREP.md`](../../construction/SHRED_PREP.md), and reaching for
the wrong one costs references.

**A dated writing molts into a mutant and leaves a fossil** -- the M1 shape, and the one Keaton named:

1. **Seat the mutant** at a fresh one-clock stamp -- `TZ=America/New_York date +%Y%m%d.%H%M%S` --
   under the one filing shape, `YYYYMMDD-HHMMSS_sprig.ext`.
2. **Repoint living citers** at the mutant. Dated testimony keeps every word it wrote.
3. **Banner the fossil** on its face, naming the living page and what changed.
4. **Write the row** in `SHRED_PREP.md` **Class M** with the measurement -- the grade before, the
   grade after, the citer counts. The cut stays **RED** until Keaton circles it, and it may never
   come; a well-prepped fossil costs a directory entry and keeps a season readable.

**A living path molts in place under a checkpoint** -- the W2 shape. A living path with inbound
references keeps its name, because seating a mutant at a fresh stamp would break every one of those
references to preserve a phrasing. Record the walk-back nib in
[`../../construction/CHECKPOINTS.md`](../../construction/CHECKPOINTS.md) first, then rewrite in
place. `context/KYRI.md` molted this way with 153 inbound references, and the row saying so is in
`SHRED_PREP.md` under **W2**.

The test is the same one the mark law uses: **a file whose own basename carries a one-clock stamp is
testimony** and molts into a mutant; everything else is living and molts in place.

## Measurement runs at molt time, and it is allowed to close the frame

**A frame is a question, and closing one with a number is a legitimate answer.** On `20260823` four
documents were queued for a Gauge molt and three of them needed nothing -- already inside their
target, measured at molt time rather than at queue time. Three cosmetic rewrites were avoided, two
of which would have spent a checkpoint and a set of citations to move a figure that was already
good.

So: take the reading when you open the frame, not when you push it. **Grade, then decide**, and
write the number down either way.

## What holds the grade honest

- **The register reading is cited, never copied.** `qa_report_card.sh` lifts `measure()` out of
  `prose_register_scan.sh`, so the 20% ceiling and the 80 door are one number. Losing that source
  makes the card refuse rather than guess.
- **Service is judged and stays judged.** The tool prints living citers, whether the live card names
  the artifact, and whether the seed manifest carries its room -- then stops. A number nobody
  measured is worth less than a blank.
- **Truth gates the card.** Below 60 the composite reads **F** whatever the rest say, because a page
  whose claims have gone false costs a reader more than an absent page.
- **A grade is not a gate.** The witness reports the door roster as a ratchet under a ceiling that
  only falls, rather than refusing the tree. A wall that reds on ordinary work is a wall somebody
  turns off.
- **A low grade is not a red**, and a red found while grading still books the allocation under
  [`reds-first`](reds-first.md). The two disciplines run beside each other; neither absorbs the other.

## What this does not reach

**Dated testimony is never rewritten to raise its grade.** Accrete-never-break holds by tier: a
dated writing molts by leaving a mutant beside it, and the elder keeps every word. This rule governs
what is written and touched from here forward.

**Whether an A page is a good page.** Four honest proxies, two of them counted, and the second thing
to read is always the artifact itself.

## Why the rule exists

A ceiling tells a writer what to stay under, and a grade tells them what to reach for. The same
measurement read the other way up turns a rule into a standard, and a standard is a thing a person
can carry into work nobody is watching. Keaton asked for the flip on `20260824`, and for the grade
to reach past prose into comments and design, where the tree has always had taste and never had a
number.

Canonical Cursor twin: [`../../.cursor/rules/quality-assurance.mdc`](../../.cursor/rules/quality-assurance.mdc).
