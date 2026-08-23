# The Census Number Keeps Its Place

**Stamp:** `20260823.173634` - **Style:** Gauge, Field setting - **Voice:** Kyri - **Status:** Living - **Decision: seated**
**Question asked:** should the `%NNN` REDS row pattern be remodelled chronologically, in the shape of the mark law, as an immediate itinerary standfast?
**Answer:** the pattern **stands**, and the mark law gains the exemption in writing.
**Kin:** [`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md) - [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) - [`../external-research/20260823-173634_when-a-number-is-honest.md`](../external-research/20260823-173634_when-a-number-is-honest.md)

## The tension, stated fairly

[`stamp-and-name.md`](../.claude/rules/stamp-and-name.md) reads as universal:

> **Never mint an ascending mark.** No `Fold A -> Fold AH -> Fold AI`, no `f0-f63`, no `X0/X1`
> rungs for planned work. A sequence label is a forecast written where it can never be corrected.

[`construction/REDS.md`](../construction/REDS.md) has minted one every time a red is booked, and
stands at **174**. So the tree's most-cited internal reference has run against
its own naming law since that law was seated on `20260821.160050`. Fair to notice, and fair to ask
about.

## Why the pattern stands

### The law's own words already carve the line

Read the sentence again: *"no `X0/X1` rungs **for planned work**"*, and *"a sequence label is a
**forecast**."* The subject throughout is a number that **predicts**. Every example the law gives is a plan that
announced a length and stopped short -- `f0-f63` reached f3, `u0-u127` paused at u91, `i0-i15`
paused at i6.

A REDS row number stays silent about the future. It says *this is the 174th thing that went wrong*,
in the past tense, and it holds. The law was written against forecasts and REDS keeps a census, so
the exemption was always implied. The sentence saying so is what this adds.

### The stamp is already there

Every row opens with all three marks the law asks for:

```
**REDS %174 (`20260823.174500`) -- the roster ran on one tree and the commit shipped another.**
```

Number, stamp, name. So a conversion would **remove** the number rather than add a stamp, and the question becomes what
the number does that the other two cannot.

### The gapless spine is a property a stamp cannot give

[`tools/gen/season/reds_ledger_monotone_witness.rish`](../tools/gen/season/reds_ledger_monotone_witness.rish)
proves the spine accretes **1..N with no gaps**, reading N off disk across the living pin and every
fold archive. That guard exists to answer one question: **is every red still on the record?**

A stamp leaves it open. Take a stamped row away and the remainder still reads as a complete run of
stamps, since stamps carry no expectation of contiguity. Take `%118` away and the guard reds on the
next run. In a ledger whose whole purpose is that faults stay recorded, that property is the point.

### The citations cannot all be reached

Measured `20260823.173634`:

| Reading | Count |
|---|---|
| Citations of a row number, tree-wide | **2,519** |
| Inside commit messages | **532** |
| Living files carrying at least one | **492** |
| Dated testimony files carrying at least one | **208** |
| Distinct rows cited by name | **109** |

The 532 in commit messages are reachable only by a history rewrite, and the 208 in dated testimony
stand protected by the same accrete-never-break law that raised the question. So a conversion
reaches the living remainder and leaves the majority pointing at a retired scheme -- and every
reader afterwards carries both schemes plus the boundary between their eras. Against that cost, the
pattern today asks one sentence of explanation in `git-signing.md`, already written.

## What changes anyway

Three small things, because the question was worth asking and each answer is cheap:

1. **The exemption is written into the mark law by name**, with the forecast-versus-census
   distinction and the gapless-spine reason. A rule bent in plain sight teaches every reader to
   read it as approximate; a rule that names its exception stays sharp.
2. **The `%` sigil earns a second reason.** `git-signing.md` seats it as a way around GitHub's `#`
   linkification, which is true and reads as a workaround. The better reason is already in the
   Lexicon's own Glow grammar: **`%` marks a constant term, a value that is exactly itself and never
   varies** -- which is precisely what an immutable ledger row number is.
3. **The archive filenames sort by luck, and that is the one real cost.** `rows-96-100` files beside
   `rows-101-107` lands correctly by accident rather than by rule, and a future `rows-9-9` would
   land badly. Recorded here as a small known cost rather than repaired, since renaming archives
   trades inbound citations for alphabetical order in one directory listing.

## Against a standfast, plainly

A standfast stops other work. This question earns a paragraph in a rule, and stops there:

- **Everything here works.** The ledger is green by its own guard, the citations resolve, and the
  pattern is documented in two rules.
- **The Lindy reading points elsewhere.** A standfast here would spend the tree's best hours
  renumbering a record that already works, while the front-door crawl this same lap found **112
  broken links across 42 living documents**, and Caravan still wants a Door-setting front page.
  Newcomers read both of those; the ledger's own guard is what reads row numbers.
- **The crux is elsewhere.** Lindy-first, crux-first picks the hardest solvable move that opens the
  rest. Renumbering leaves the rest exactly where it stands.

## The falsifier

This decision turns out wrong if either of these holds:

- **A newcomer reading `construction/REDS.md` needs more than one screen to learn what `%174`
  means.** The test wants a real person rather than a guess. Should it come back that way, the
  answer is a sentence at the head of the ledger rather than a renumbering.
- **The gapless property stays quiet.** Should a year pass with the monotone guard having caught no
  dropped row, the completeness argument was theoretical and the number was tidiness wearing an
  invariant's clothes. Recorded here so a later reader can run the check rather than take a promise.
