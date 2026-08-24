# What a comment is worth, and what part of it counts

**Language:** EN
**Stamp:** `20260824.165010`
**Style:** Gauge, **Field** setting
**Voice:** Kyri
**Room:** Design research -- an open question, opened rather than answered
**Kin:** [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md) -> *Code comments* and *Quality assurance* - [`../.claude/rules/quality-assurance.md`](../.claude/rules/quality-assurance.md)

## The question, plainly

The report card seated on `20260824.165010` grades a document in four readings, two of them
counted. The style guide it serves already says how a **comment** should read: **Door** at the head
of a module, where someone arriving cold deserves a plain sentence about what the thing is for, and
**Meter** beside a bound, where the comment says why the number is that number.

That dial has taste and no meter. So the question this note opens is narrow and answerable:

> **Which part of "this module explains itself" can a program count, and which part can only a
> reader judge?**

If you are reading this at Acme Corporation with your own codebase in mind, the question transfers
without translation. Every team that has ever written a style guide for comments has drawn the same
line somewhere, usually by feel, and usually only once.

## What is already known, bounded honestly

**Observation.** Comment-density metrics -- comment lines over code lines -- have been available in
static-analysis tooling for roughly forty years, and they are widely reported and widely
distrusted. The reason is easy to state: density counts presence and cannot count usefulness, so a
file full of restated signatures scores exactly like a file full of reasons.

**Observation.** The comment kinds that consistently earn their keep in published engineering
guidance are the ones density cannot see: the reason beside a constant, the invariant above a
mutation, the caution naming what went wrong last time. Each of these is a *why*, and each is
attached to a specific construct rather than spread over a file.

**Inference.** If the valuable comment is always attached to a construct, then the countable
question is not *how much* commentary exists but *which constructs carry one*. That reframes the
measurement from a ratio into a coverage reading, which is a different and much better shape: a
ratio has no natural target, while coverage has a denominator you can name.

**Inference.** The two settings the style guide names have different denominators. Door coverage
counts modules, and a module has exactly one head, so the reading is a clean fraction. Meter
coverage counts bounds and asserts, which this tree already requires to carry a `// invariant:`
line, so the denominator is already defined by a seated law.

## The three candidate readings, and what each would cost

**Door coverage.** The share of modules whose opening comment reads at the Door setting: present,
addressed to a newcomer, and naming what the module is for rather than what it contains. Presence
is countable today. *Addressed to a newcomer* is the register reading already implemented, run over
the comment text instead of a page. *Names what it is for* is judged.

**Meter coverage.** The share of named constants, bounds, and asserts carrying a reason. Presence
of a preceding comment line is countable. Whether the line gives a **reason** rather than a
restatement is the hard half -- and a cheap, honest proxy exists: a reason usually contains a
causal word, and a restatement usually contains the identifier it sits above.

**Dial balance.** The share of a module's comments sitting at each setting. A module whose every
comment is Meter is precise and hard to enter, which is exactly the shape a reader named when they
called a body of code an obscure assembly. This reading needs no judgement at all -- it is a
histogram -- and it may be the most useful of the three for that reason.

## What would make this worth building, and what would show it was not

**Horizon:** one round, once the design essay beside this note settles the shape.

**Assumptions:** that the seated `// invariant:` convention is followed closely enough for its
denominator to mean something; that a module's opening comment block is findable by position rather
than by parsing; and that register can be measured over comment text as honestly as over prose.

**The falsifier, and it is a real one:** if dial balance across this tree's modules turns out to be
roughly uniform, then the reading distinguishes nothing and the obscurity a reader felt lives
somewhere else entirely -- in naming, in structure, or in the absence of an entry point. Measure
the histogram before building anything on it.

**Confidence:** *plausible* that dial balance is the useful reading, *likely* that Door coverage is
countable and worth having, and *a live possibility* that Meter reason-quality resists counting
altogether and should stay judged.

## What this note deliberately does not do

It proposes no tool and seats no law. The reading belongs in the checkable room only once a witness
binds it, and nothing here has earned that yet. The design essay beside this note argues the shape;
this one asks whether the shape is worth arguing about, and answers *yes, with one measurement
first*.
