# The dial that runs through the code

**Language:** EN
**Stamp:** `20260824.165036`
**Style:** Gauge, **Field** setting
**Voice:** Kyri
**Room:** Design essay -- worth reading with the code deleted
**Kin:** [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md) - [`../.claude/rules/quality-assurance.md`](../.claude/rules/quality-assurance.md) - [`../external-research/`](../external-research/)

## The question

A style has two settings for a comment. **Door** at the head of a module, for whoever arrives with
no context. **Meter** beside a bound, where the comment says why the number is that number. The dial
is right, and it has never been read.

So: **what does it mean for a module to explain itself, and how much of that is a measurement?**

## The shape being proposed

Three readings, and they are deliberately ordered by how much judgement each needs.

**The histogram first, because it needs none.** For each module, count its comments by setting --
Door-shaped at the head, Meter-shaped beside a construct, and everything else. A module whose
distribution is entirely Meter is precise and hard to enter. A module whose distribution is entirely
Door is welcoming and unbounded. Neither is a fault by itself; the histogram simply makes the shape
visible, and a shape you can see is a shape you can choose.

**Door coverage second, because half of it counts.** Does the module open with a sentence a stranger
could use? Presence counts. Register counts, using the same reading that already grades prose.
Whether it names what the module is *for* rather than what it *contains* is judged, and that
judgement is small enough to make cheaply.

**Meter reason-quality last, because it may not count at all.** A bound carrying "// invariant: n is
at most 64" restates its own line. A bound carrying "// invariant: a supervisor that can spawn
without a ceiling is the failure it exists to prevent" carries a reason. The difference is enormous
to a reader and thin to a parser, and any proxy for it -- causal words present, the identifier
absent -- will be wrong often enough to be reported rather than gated.

## The alternative, given its best case

**Count nothing; keep the dial as taste.** This is a stronger position than it looks. The dial was
written for a person to apply while writing, and the comment that made someone say a body of code
felt like an obscure assembly was noticed by reading rather than by measuring. A meter can turn a
craft into a target, and a target attracts the cheapest satisfying move -- here, a Door sentence
written to pass rather than to welcome.

**The reason to build anyway, stated fairly against that.** A dial with no reading applies only in
the moment of writing, and a module is read a thousand times after it is written. The histogram
attracts no gaming because it names no good direction -- it reports a shape and leaves the choice
where it belongs. That is why it goes first, and why the gated tier stays empty until something
earns it.

## The trade-off accepted, and its bill

**Accepted:** the third reading is a proxy and will be wrong. A reason-word proxy will pass a
sentence that merely sounds causal and refuse one that carries its reason in plain nouns.

**The bill:** it is reported rather than gated, forever, unless a much better reading arrives. A
number that cannot refuse is worth less than one that can -- and a number that refuses wrongly is
worth less than nothing, because it teaches people to write for it.

## What has to be true first

**A measurement before a design.** Take the histogram across the modules this tree already has. If
the distribution is roughly uniform, the reading distinguishes nothing, this essay is wrong, and the
obscurity a reader felt lives in naming or structure rather than in comment balance. That is the
falsifier, it is cheap, and it comes first.

## Two rooms

Everything above is **proposed**. Nothing here is checkable until a witness binds it, and no witness
exists. The one thing already **proven** is the report card the dial would extend, and it grades
prose rather than code.
