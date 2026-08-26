# The Instrument and the Artifact -- when a meter reports a fault it created

**Stamp:** `20260826.181924` - **Voice:** Kyri
**Kind:** Counsel - a pattern measured twice in one day, and what it asks of a reader
**Basis:** REDS %276, seated and closed this day - `docs/COMPASS.md` re-read at `meter` - the fold loom REDS %247 named and %270 booked
**Style:** New Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Room note:** the counsel room was closed `20260821.174047` on Keaton's word and this piece is written into it on his word of `20260826`. Its natural home under the seated filing test is `active-designing/`, one word away.

---

## The finding, in one sentence

**A meter pointed at a class of artifact it was never shaped for reports a fault in the artifact,
and the report wears exactly the shape a real one wears.**

Twice on `20260826`, hours apart, on two unrelated meters. That is the whole reason this is written
down: once is a bug, and twice in a day is a shape.

## The two readings

**The pointer card.** `docs/COMPASS.md` is a compressor -- a day-one rose whose entire job is to
point at other pages. Graded at the **door** setting it read **C**: reach **30**, from 8
cross-references per 100 words against a Door budget of **1**, over 49 words of prose. Graded at
**meter**, where cross-references are uncapped because refusal is the subject, it reads **A**, and so
do `docs/HAWM.md`, `docs/TUBE.md` and `docs/STOA.md`, which are the same kind of page.

**The program.** `tools/fixtures/qa_report_card.sh` skips every line whose first non-whitespace is
`#`. In Markdown that is a heading, and skipping it is right. In a shell, Rishi or Rye source `#`
and `//` open the **only** prose the file has, and every other line is code. Applied to a program
the rule inverted, discarding the comment head and grading the code. On
`tools/fixtures/reds_fold.sh`, whose head is plain English written for a first reader, Reach read
209 "words" of `[ -f "$PIN" ] || fail ...` and returned a **reading grade of 86** against a ceiling
of 9 -- flooring Reach at **0** and the card at **C**. After the repair the same file reads grade
**8**.

## Why this is dangerous rather than merely wrong

A meter that fails loudly gets fixed. A meter that reports a **plausible fault in the right shape**
gets obeyed -- and obeying it makes the artifact worse.

Follow the COMPASS reading honestly and the repair is *pad the page with prose*, which takes a card
built to be read in ten seconds and makes it slower. Follow the program reading honestly and the
repair is *simplify the comments*, which strips the explanation out of the one file whose whole
value is that it explains itself. **In both cases the meter instructs you to damage the thing it
measures, in the meter's own vocabulary, with a number attached.**

The card's own source already carries this warning, written for a different case: an index page
measured against a prose cross-reference budget is *"a meter instructing a repair -- pad the page
with prose -- which would make the artifact worse, and a meter that does that is the thing to fix."*
The warning was right, and it was scoped to one symptom where the class is wider.

## How each one was caught, and what caught them

The meter caught neither. Both were caught by **a reading that could not be true**.

COMPASS came back C on a page whose four siblings all pass and whose purpose a reader knows in one
glance. The program came back **C and B with `register=100`**, and that pair is impossible for real
prose: a page that leads perfectly with what is reads at plain length by construction. The two
numbers disagreed about what kind of thing they were reading, and that disagreement was the whole
signal.

So the practical test runs past *is this grade low* to **do these readings describe one artifact?**

## What to do with it

- **Match the setting to the class before reading the grade.** A pointer card reads `meter`. A
  program is graded on its comments rather than its code. Prose reads `door` or `field` by audience.
  This is now written into the tree's own grading habit on the living card.
- **Treat an impossible combination as an instrument fault until proven otherwise.** High register
  beside a huge reading grade; a C on a page four siblings pass; a zero where a healthy tree should
  read a number. REDS %169 named the confident wrong zero, and this is its cousin.
- **Grade-shopping is the trap on the other side.** Re-running until a setting flatters the page is
  the same failure wearing better manners. Choose the setting from **what the artifact is**, and
  write the reasoning where the next reader can disagree with it.
- **Repair the instrument in the lap that found it.** Both repairs took one lap each, and both cost
  less than the rounds of prose-mangling they would otherwise have licensed.

## The companion pattern, from the same day

The fold loom belongs beside this, because it is the same lesson from the other end. REDS %247 named
a fault, prescribed the fix, and closed by saying the next fold depends on whoever runs it
remembering the row. REDS %270 met the identical fault twenty-nine rows later. **A fix that ends in
"someone remembers" has forecast its own second firing**, and the ledger's own law answers it: a
lantern that fires twice becomes a loom. `tools/fixtures/reds_fold.sh` is now that loom.

Read together: **one pattern is a meter that measures the wrong thing, the other a rule that
measures nothing at all.** Both look like discipline from the outside. The difference is whether a
program holds the line, or a memory does.

## What this does not claim

**That the settings are right.** Three settings and a class-to-setting mapping are a design that has
now been wrong twice, and a later round may find the mapping itself is the fault.

**That a grade is a judgement.** Four proxies, two counted, and the second thing to read is always
the artifact. The card says so in its own comments, and this piece is one more reason to believe
it.

**That anything here was measured on a reader.** Both findings are readings about readings, and a
real newcomer meeting these pages remains the check still to be run.
