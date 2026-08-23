# The Tic and the Meter

**Stamp:** `20260823.182512` - **Style:** Gauge, Field setting - **Lens:** TAME - **Status:** Living
**Source:** Claude Code issue **#77136**, *"Claude 4.7, 4.8, 5.0, and Fable increasingly default to repetitive rhetorical tics and often struggle to produce coherent prose despite explicit style instructions"* -- read `2026-08-23` at `github.com/anthropics/claude-code/issues/77136`.

**What this is.** A short note on a reported failure mode in language-model prose, and on why a
counted style ceiling is a reasonable answer to it. Written for anyone maintaining a house style
that a model is expected to write in.

## The report, as filed

The issue describes two things together. Models reach for the **same rhetorical shapes repeatedly**
-- a construction that lands once and grows tiresome by its fourth appearance in a page -- and they
**hold an explicit style instruction loosely**, drifting back toward the default register over the
length of a document even when the instruction stays in context.

This note takes the report as a description of observed behavior rather than as a settled
diagnosis, and it makes no claim about cause. What matters here is that the shape is
**recognizable** and, more to the point, **countable**.

## Why an instruction alone is a weak instrument

A style instruction is a request evaluated once per token and remembered imperfectly. It has three
properties that make it fragile on its own:

- **It has no feedback.** The writer never learns whether the instruction was followed, so drift
  compounds silently across a long document.
- **It is judged by the same writer that produced the text**, which is the weakest possible reviewer
  of that text.
- **It describes a quality rather than a quantity.** *Write warmly* admits any amount of compliance,
  and any amount reads as compliant from the inside.

## What a counted ceiling adds

Pick one axis of the style, express it as a number a script counts, and the three properties above
invert. The count is external, repeatable, and disagrees out loud.

This tree's own instrument is narrow on purpose: it counts the **share of sentences carrying a
negative word**, from a fixed list, across sentences of four words or more, skipping code fences,
tables, and headings. Door prose holds at or under 20%, Field at or under 30%, and ledger rows carry
no ceiling because refusal is their subject.

Three things it did that an instruction had failed to do, measured `2026-08-23`:

| Document | Before | After |
|---|---|---|
| Front page | **46%** | 13% |
| Founding statement | **54%** | 7% |
| Beginner tutorial | **51%** | 0% |

Every one of those had been written under an explicit instruction to follow a warm, affirmative
house style, and every one read as its opposite. The guide they all named measured **29%**. Reading
grade sat inside target throughout, which is why the drift survived: the meter that existed
measured a different axis.

## The honest limits, stated plainly

**A count is a proxy, and this one is narrow.** It measures negation density, which correlates with
the register the style asks for and is far from identical to it. A page can pass this meter and
still tire a reader, and the second number to read is always the prose itself.

**It can be gamed, and gaming it is easy.** Backtick a word and the scan reads it as code; move a
sentence into a bullet and it drops out of the count. That is worth knowing rather than worth
fixing, because the meter's audience is the author, and an author who games their own instrument has
already decided not to be helped by it.

**It says nothing about repetition**, which is the report's first complaint. Counting repeated
constructions is a genuinely harder measurement -- the same phrase is a tic on its fourth appearance
and a motif on its second -- and no instrument here attempts it yet. Named as an open question
rather than answered.

## What generalizes

**If you maintain a house style that a model writes in, express one axis of it as a number, and
check that number before you publish.** Choose the axis where your own drift actually shows: negation
density, sentence length variance, paragraph length, the ratio of concrete nouns to abstract ones.
The axis matters less than the existence of an external check, since the failure being guarded
against is precisely a writer's inability to audit its own register.

**A falsifier for this note.** If a year of counted passes produces prose that readers find no
better than the uncounted kind, the proxy was measuring the wrong axis and the count was ceremony.
The test is a reader, not the meter.
