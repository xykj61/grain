# The denominator was the whole question

**Language:** EN
**Stamp:** `20260824.170904`
**Style:** Gauge, **Field** setting
**Voice:** Kyri
**Room:** Round note -- the answer to a scoped measurement
**Answers:** [`20260824-165130_measure-the-comment-histogram-first.md`](20260824-165130_measure-the-comment-histogram-first.md)
**Scan:** [`../tools/fixtures/comment_dial_scan.sh`](../tools/fixtures/comment_dial_scan.sh)

## The verdict, first

**Worth building -- two readings rather than one, and the ordering the design essay proposed is
wrong.** One of its three candidate readings is closed by the measurement, one survives and needed
a different denominator to show it, and the strongest reading of the three is one nobody proposed.

## What was measured

Every authored `.rye` module -- **1,891** of them, **728,122** lines, vendored and read-only
libraries left out -- with each comment line classified by the form the language itself gives it.
That is the first thing the scoping note did not know: Rye inherits Zig's three comment kinds, and
`//!` is accepted only at the top of a file, so **the Door setting is already written into the
grammar** rather than needing to be inferred from position.

| Reading | Count |
|---|---|
| Comment lines, all forms | **214,912** -- 29.5% of every line in the tree |
| `//!` module docs (Door) | 40,205 |
| `///` declaration docs | **108,992** |
| `//` beside a const, var, or assert (Meter) | 34,509 |
| `//` elsewhere (loose) | 22,810 |
| `//` trailing code on its line | 8,396 |

## Reading one: Door coverage is closed, and that is the cheap measurement working

**1,884 of 1,891 modules carry a module doc.** That is **99.6%**, and there is no coverage question
left to build a meter for. A Door-coverage reading would report a number that has already arrived
and stay green forever, which is the shape of a guard that guards nothing.

One of three candidate readings, closed for the price of one scan. This is exactly what taking the
measurement before writing the third piece was for.

## Reading two: the histogram lives, and the first denominator nearly buried it

Here is the finding worth carrying past this round.

**Against all comment lines**, the Meter share per module reads: min 0, p25 **3**, median **14**,
p75 **24**, max 100 -- with **77%** of modules at or under a 24% share and 24 modules above 50%.
Read that and you close the design: the mass sits in one band, the interquartile spread is 21
points, and most modules score alike.

**Against ordinary `//` comments alone**, the same modules read: min 0, p25 **31**, median **53**,
p75 **73**, max 100 -- with real mass in all five bands (86 / 196 / 379 / 489 / 370) and an
interquartile spread of **42 points**.

| Denominator | p25 | median | p75 | IQR | Verdict it supports |
|---|---|---|---|---|---|
| every comment line | 3 | 14 | 24 | 21 | concentrated -- close the design |
| ordinary `//` only | 31 | 53 | 73 | **42** | spread across the range -- build it |

**Same modules, same day, opposite answers.** The confound is plain once seen: `///` declaration
docs are **51% of every comment in the tree**, and a declaration doc is neither Door nor Meter. Put
them in the denominator and they dilute a share they have no stake in.

**The transferable rule, and it reaches past this round:** *a share is a claim about its
denominator, and the denominator is the part a reader cannot see.* Gauge already asks every figure
to carry its unit, its date, and its source. A share carries a fourth thing, and it is the one most
likely to be wrong.

## Reading three: the strongest number, and nobody proposed it

The seated code law asks that every assert be preceded by a `// invariant:` comment naming the
reason. Measured directly -- walking up from each assert through the comment block above it, rather
than dividing two line counts, since one invariant line can head a run of asserts:

| Reading | Count |
|---|---|
| Asserts standing in code | **32,769** |
| Standing under an invariant block | **19,534** -- 59.6% |
| **Standing with no stated reason** | **13,235** -- **40.4%** |
| Modules carrying an assert | 1,693 |
| Modules asserting with no invariant line anywhere | 492 |
| ...of which say nothing in **any** contract vocabulary | **485** |

**A seated law running at 59.6% compliance, with no meter anywhere in the tree.** The denominator
comes from the law rather than from taste, the reading needs no judgement at all, and the number is
large enough to matter.

The second vocabulary was checked rather than assumed: **8 modules** tree-wide write
`/// Precondition:` or `/// Postcondition:` instead, and **7** of them are among the 492. So the
gap is an absence rather than a dialect, and the caveat makes the finding stronger.

## What the essay got right, and what it got backwards

**Right:** that the dial is real, that the histogram needs no judgement, and that reason-quality
beside a bound resists counting.

**Backwards:** it ordered the histogram first *because* it needed no judgement, and put coverage
second. The measurement says invariant coverage needs no judgement **and** discriminates sharply,
while the histogram needs no judgement and discriminates only under the right denominator. The
ordering follows discrimination rather than judgement-cost:

1. **Invariant coverage** -- a seated law, a defined denominator, 13,235 asserts without a reason.
2. **The ordinary-comment setting histogram** -- a real spread, useful as a finder of the tails.
3. **Door coverage** -- closed. Never build it.

## What this round does not do

It seats no ratchet and sets no ceiling. **13,235 is a large number to seat a wall against without
Keaton seeing it**, and where the ceiling starts is a decision rather than a measurement. The scan
joins no standing roster; it answered its question and is kept so the next round can re-run it.
