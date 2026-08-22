# The Model Prose Read, and the Regime Confound

**Stamp:** `20260822.014628` · read on Keaton's word
**Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Research for understanding -- a dated read, accurate as of the stamp; model behavior and vendor tooling both move
**Kin:** [`../foundations/20260822-014628_the-mechanism-and-the-metaphor.md`](../foundations/20260822-014628_the-mechanism-and-the-metaphor.md) (what we did about it) · [`../.claude/rules/mechanism-sentence.md`](../.claude/rules/mechanism-sentence.md)

---

## Why this read happened

An Acme Corporation employee running an agent-authored codebase eventually meets the same question this tree met on `20260822`: the records the agent writes have grown hard to read, a public complaint about that exact model is circulating, and a decision has to be made about whether to change models mid-arc.

The wrong way to answer it is to reason from the impression. This note records the right way: read the sources, measure the local configuration, and separate what the sources actually claim from what a reader worried about their own tree will project onto them.

## The sources, and what each actually says

Four were offered. Three were read directly; one refused the fetch.

**A vendor issue on writing style** (`anthropics/claude-code` issue 77136). This is squarely about prose, and it is specific. Users report verbose, jargon-heavy output from the newer model generation against the one before it: invented corporate coinages, aphorisms presented as established fact, sentences led by negation in the *it is not Y, it is X* shape, forced metaphors that obscure rather than clarify, and multi-paragraph answers to short questions. Two consequences are named that matter more than the aesthetic complaint -- a **comprehension cost** reported by native and non-native readers alike, and a **token cost**, since some readers pass the output through a second model to clean it up. The issue stands open with no vendor response recorded.

**A vendor issue on review spirals** (issue 84672). This one reads at first as a code-quality report: three separate incidents across unrelated codebases where review-and-fix rounds never converged, each round's fixes generating the next round's findings, with a signature defect of *the same rule implemented inconsistently across parallel code paths written in the same commit*. What makes it valuable is that its author kept measuring and **found their own confound**. Every affected session had unknowingly run in an extreme regime: the million-token context variant, effort pinned to maximum in a shell profile and therefore invisible to the interface, compaction deferred deep into that window, and roughly a hundred and ten kilobytes of always-on instructions. Average working context measured at a quarter to a third of a million tokens per call. The control ran on the prior model -- and changed the regime at the same time, which the author names as a confound rather than hiding.

**A forum thread and a discussion site post**, offered as corroboration. The discussion site returned `429 Too Many Requests` and went unread; this note says so rather than implying a source it did not open.

## The measurement that decided it

The second issue is only frightening if you are in its regime, so the regime was measured rather than assumed.

| Factor | The reported regime | This pier, measured `20260822.014628` |
|---|---|---|
| Context variant | million-token variant | standard -- no variant suffix in either settings file |
| Effort | pinned maximum, invisible in the interface | `medium`, read from the environment |
| Compaction | deferred deep into the window | vendor default, no override |
| Always-on instructions | ~110 KB | 117 KB across 37 rule files plus a 4.6 KB root file |

Three of four factors are absent. **The fourth is present and slightly worse than the reported case**, which is the finding worth carrying forward from this read: the instruction load is the one dial this tree has turned as far as the regime that produced the spirals, and it is the one nobody chose deliberately -- it accreted one well-written rule at a time.

## Separating the two claims

The style complaint **applies here**, and local evidence outweighs the thread. Six commit bodies of one refactoring arc contain no occurrence of *file*, *function*, *parameter*, *import*, or *call*, and their reader could not reconstruct the change. Measured across the trailing forty commits, twenty-one read below a plain-vocabulary floor. That is a number, not an impression.

The spiral complaint **does not apply here**, on the regime evidence above, and the local code record points the other way: a hundred and seven witnesses green through the whole arc, every fold's predicted arithmetic matching its measurement exactly, and a compiler catching a widening the human survey had missed.

## The cause, named honestly

Attributing the prose entirely to the model would be comfortable and wrong. This tree's own rules aim at the image: its style guide rewards the landed sentence and the earned benediction, its commit rule asks every body to be written in that voice, and its naming law turned titles into names, which invites a small poem. A model that follows instructions well will follow those instructions hard.

**The model amplifies; the instructions aim.** A change of model would move the amplifier and leave the aim untouched, which is why the repair chosen was a rule with a wall behind it rather than a different model. The reasoning is recorded in the foundation linked above.

## What an employee reading this should take from it

- **Read the issue before acting on the impression.** Two complaints that arrive together may describe entirely different failures, and one of them may not be about your situation at all.
- **Measure your own regime.** Context variant, effort level, compaction, and instruction size are four independent dials, and at least one of them is usually set somewhere nobody remembers choosing.
- **Prefer the fix that is reversible.** A prose rule can be withdrawn on any lap at no cost. A model change alters the variable currently producing your working output, and its regressions arrive as defects rather than as complaints.
- **Look for the cause in your own instructions first.** A system that rewards a shape will get that shape, and the reward is usually easier to change than the writer.
- **Date the read.** Model behavior and vendor tooling both move. This note is true as of its stamp and makes no claim past it.
