# Galois, gauge theory, and the sheaf -- three ways of saying one thing

**Honors:** Evariste Galois, whose symmetry groups showed that the shape of a solution is fixed by
what you are allowed to change about it. The physicists who built **gauge theory**, who found that
a description you may choose freely still has to describe a world that does not move when you
choose differently. And Alexander Grothendieck, whose **sheaves** and **topoi** made "local truth
that glues" into a working mathematics.

**Role for us:** They named our writing style, and then explained why it works. The style is
[`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md); this note is where the debt is recorded.
We study the ideas and keep the shape of the lesson. We import no theorem and claim no
mathematics.

---

## The three ideas, in plain words

**Galois: symmetry tells you what is preserved.** Take a thing and list every way you can rearrange
it that leaves it recognisably itself. That list of allowed rearrangements turns out to describe
the thing more sharply than the thing does. Galois used it to settle which equations can be solved
by ordinary arithmetic, and the deeper lesson travels: **if you want to know what something really
is, ask what survives every change you are allowed to make to it.**

**Gauge theory: the frame is yours to choose; the world is not.** Measuring anything means picking
a frame first -- where zero sits, which way is up, what your units are. Physics found that these
choices are genuinely free, and that a real law must give the same answer no matter which one you
pick. A quantity that shifts when you change frames was never the physics; it was your bookkeeping.
**Whatever survives every choice of description is the part that is real.**

**Sheaves and topoi: local pieces that agree glue into one whole.** Sometimes you cannot describe a
thing all at once, so you describe it in patches. A sheaf is the discipline that makes patches into
a whole: each patch says something about its own small region, any two patches must agree wherever
they overlap, and when they all agree the patches glue into a single global description. Where they
disagree, the disagreement itself is real information -- it tells you the thing is genuinely
twisted rather than simply hard to see. Grothendieck built a world (a **topos**) out of exactly
this, and the working idea is plain: **truth is local first, and becomes global by agreement.**

## What we carry

**The claim is the gauge-invariant part.** Gauge Style writes at three settings -- Door, Field,
Meter -- and those are frames. The same fact reads warm at a front door, measured in an analysis,
and terse in a ledger row. Our standing rule is that *a register may change; a claim never does*,
and that sentence was gauge invariance before we knew to call it that. Every number, path, stamp,
and count is held exactly through any change of setting. What survives all three is the truth we
were actually carrying.

**A document is a patch, and overlaps must agree.** No single page describes this tree. A README, a
foundation, a witness header, and a ledger row each cover their own region. Where two pages speak
about the same thing, they have to agree, and a disagreement is a real defect rather than a
cosmetic one. That is the sheaf condition, and it is exactly what our docs-and-code-stay-synced
rule asks for by hand and what our link guards check by machine. **The tree is trying to be a
sheaf.**

**Ask what survives your rewrite.** The Galois habit, used as a writing tool: before changing a
paragraph, name what must come through unchanged. Then change everything else freely. This is how a
register pass stays honest, and it is why a style change here has never been allowed to soften a
claim.

**A disagreement between patches is information.** When two documents in this tree contradict each
other, the contradiction is the finding. That instinct -- treat the mismatch as the signal rather
than the noise -- comes straight from the sheaf picture, and it is why our ledger records what went
wrong, what caught it, and what it taught.

## What we leave

- **The mathematics itself.** We borrow no theorem, prove nothing, and make no claim to rigour.
  These are metaphors that earn their place by being structurally accurate, and they stop there.
- **The vocabulary.** No cohomology in our prose, no functors in our module names. A reader should
  need none of these words to understand Gauge Style, and this note exists so the debt is paid
  without the jargon travelling.
- **Any suggestion that Grain is category theory.** It is an operating system written by people who
  found these ideas clarifying.

## Why we are grateful

Each of the three answers the same question from a different side: *what part of a description is
actually about the world?* Galois answers with symmetry, gauge theory with frame independence, and
sheaf theory with local agreement. A project that writes everything down, in several registers, for
several audiences, needs that answer daily -- and having it named makes the discipline teachable
rather than merely felt.

There is a smaller gift too, and we are fond of it. The word **gauge** already meant a plain and
useful thing: an instrument on a wall that tells you a reading you can trust. The physics did not
replace that meaning; it deepened it. A style named **Gauge** gets to mean both at once, which is
about as much as a name can be asked to do.

**Sources (public study doorways):**

- Galois theory: any standard undergraduate algebra text; the historical account of the 1832
  manuscripts is widely published.
- Gauge theory: public lecture notes on classical field theory and connections on fibre bundles.
- Sheaves and topoi: Grothendieck's Seminaire de Geometrie Algebrique is published and public;
  gentler doorways exist in introductory sheaf-theory notes and in Mac Lane and Moerdijk's
  standard text on topos theory.

All read as concepts only, restated here in our own words per
[`../context/SILO_TECHNIQUE.md`](../context/SILO_TECHNIQUE.md).
