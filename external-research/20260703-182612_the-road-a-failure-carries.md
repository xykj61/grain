# The Road a Failure Carries — From Metalsmoke Toward a Trace

*Kaeden asked whether metalsmoke should expand into Rye's general debugging and
error-stacktrace organ. The recommendation keeps the word narrow and graduates the insight:
metalsmoke stays exactly what its definition note made it — the thin edge of
checks only the world can answer — while the insights beneath the question grow into a
designed organ of their own: the trace, the road a failure carries.*

**Stamp:** `20260703.182612` (supplied verbatim by Kaeden)
**Language:** EN · **Style:** Radiant · **Lens:** TAME
**Status:** External research — study and recommendation; the trace's functional spec waits
for the open Edit-5 slot on Kaeden's word
**Companions:** `../active-designing/20260703-013412_metalsmoke.md` · `../context/TAME_GUIDANCE.md` (named errors) · the second harvest's *every wait has a deadline*

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## Why the Word Stays Narrow

Metalsmoke names a *category of witness* — the few honest checks where only real metal, a real
compositor, a real drive can answer. A trace names a *property of failure* — what any error,
anywhere, carries out with it. Folding the second into the first would blur two clean edges
the tree just spent a season sharpening. One word, one meaning; the discipline that named
season and bench holds here too.

## Three Teachers, Siloed

A from-scratch functional OS lineage teaches that every crash should carry the whole road that
led there — a nested chain of causes, printable, honest about depth. A modern systems
language's ecosystem teaches errors as small named values first and captured backtraces
second, paid for only when wanted. And a Lisp-family contracts library teaches that a value
failing a shape at a seam deserves an explanation of *why* — which part, which expectation —
rather than a bare no. All three are thanked below; what crosses the doorway is the pattern.

## The Trace on Our Spine

Our stack adds the piece none of the teachers had: state is a pure fold over an append-only
log of signed facts. So a failure's road has two lanes. The **call road** — which scripts and
stages were in flight — rishi already whispers today (`at line N`); its first lap is a frame
stack of nested `run script` entries printed on any assert failure, oldest to newest. The
**fact road** — the last few events the fold consumed before the world went wrong — is the
lane only a log-shaped system can offer, and it turns a stack trace into a story: here are the
facts, here is the stage, here is the shape that refused. Shape refusals at seams speak the
contracts vocabulary: name the field, the bound, and the found value, exactly as the Brix
door-checks already fail with named errors. And riding along from the second harvest: **every
wait has a deadline** — an unbounded wait is unbounded allocation wearing a clock, so a trace
that ends in a timeout names the deadline that expired.

## The first lap, When Its Season Opens

Small on purpose: rishi keeps a bounded frame stack (script name, line) and prints it beneath
the existing assertion message; a named budget on depth; one witness proving a three-deep
doomed run reports all three frames. Fact-road, shape-diffs, and any Rye-side capture wait for
later laps. This study fills no spec slot tonight; the slot is open, and the word is yours.

## Gratitude

With thanks to the designers of the from-scratch OS lineage whose crashes carry their whole
road; to the systems-language community whose error values and optional backtraces taught the
zero-cost default; and to Rich Hickey, whose contracts work taught seams to explain their no.
Their names rest here; the pattern lives above in our voice.

---

*May every failure leave a road a stranger can walk back. May the no at every seam say why.
And may metalsmoke stay small, honest, and exactly one thing.*
