# Measure the comment histogram first

**Language:** EN
**Stamp:** `20260824.165130`
**Style:** Gauge, **Field** setting
**Voice:** Kyri
**Room:** Round note -- scoping, not an essay
**Opens:** the falsifier both comment-dial pieces named

## What this round does, and what it deliberately does not

Two pieces written on `20260824.165130` argue that a module's comments carry a dial with
two settings and no meter, and both name the same falsifier: **if the distribution of comment
settings across this tree's modules is roughly uniform, the reading distinguishes nothing.**

So this round takes that one measurement and stops. No witness is seated, no law is written, and no
tool joins the standing roster. The whole point is to learn whether the design is worth building
before building it.

## The measurement, defined precisely enough to run

For every authored `.rye` module in the tree, classify each comment line into one of three bins:

- **Door** -- a comment block at the head of the file, before the first declaration.
- **Meter** -- a comment line immediately preceding a `const`, an `assert`, or a declaration
  carrying a bound.
- **Loose** -- everything else: inside a function body, after code on the same line, or between
  declarations without preceding one.

Report per module: the three counts, the total, and the module's line count. Report per tree: the
distribution of the Door share and the Meter share across modules.

**The reading that answers the question:** the spread of the Meter share. If most modules sit in a
narrow band, the histogram tells a reader nothing they could act on. If the spread is wide, the
modules at the extremes are exactly the ones worth reading with a person's eyes.

## What counts as done

- One scan under `tools/fixtures/` printing the per-module and per-tree readings.
- The numbers written into a follow-up note, with the spread stated plainly.
- A one-line verdict: **worth building**, or **the design essay was wrong and here is the number**.

No ratchet, no ceiling, no roster entry. A measurement taken to answer a question is finished when
the question is answered.

## Why it is scoped this small

The report card seated this same day is useful because each of its readings was argued before it was
counted. The comment dial has now been argued twice. Taking the cheap measurement before writing the
third piece is what keeps the argument honest, and it costs one scan.

## Kin

- [`../external-research/20260824-165010_what-a-comment-is-worth-and-what-of-it-counts.md`](../external-research/20260824-165010_what-a-comment-is-worth-and-what-of-it-counts.md)
- [`../active-designing/20260824-165036_the-dial-that-runs-through-the-code.md`](../active-designing/20260824-165036_the-dial-that-runs-through-the-code.md)
- [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md) -> *Code comments*
