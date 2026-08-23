# When a Number Is Honest

**Stamp:** `20260823.173634` - **Style:** Gauge, Field setting - **Lens:** TAME - **Status:** Living

**What this is.** A short argument about a question most codebases answer twice and never notice:
**when may a name carry a counting number, and when may it not?** Written so you can apply the test
to your own issue numbers, migration numbers, ADR numbers, and version tags. The worked case is one
tree's own ledger, measured on `2026-08-23`.

## The rule most style guides land on, and why it is half right

A common and good rule says: **mark work by when it happened and what it was, rather than by where
it sits in a sequence.** A timestamp plus a name. The reasons are strong, and all four are real:

1. **A sequence label forecasts a length the work rarely keeps.** A plan announcing `f0` through
   `f63` reached `f3`. One announcing `u0` through `u127` paused at `u91`. The number was a
   prediction wearing a name's clothes, and a name cannot be corrected without breaking every
   citation of it.
2. **It implies a dependency that is often absent.** Step 35 reads as requiring step 34.
3. **It sorts wrong in every tool that sorts text.** `Z` precedes `AA` alphabetically and follows it
   chronologically; `%99` precedes `%100` the same way.
4. **It collides across sequences.** Two ladders both reach `A1`.

So far the rule looks universal. Applied universally, it costs something worth keeping.

## The distinction the rule is missing

**A number that predicts is a forecast. A number that counts is a census.** They look identical and
behave in opposite ways.

| | Forecast number | Census number |
|---|---|---|
| Names | work planned | work that happened |
| Tense | future | past |
| Holds up | rarely | always |
| What it promises | a length | completeness |
| Example | `f0-f63`, `Phase 3 of 5` | incident 174, invoice 8801 |

All four objections above are objections to the **forecast**. Read them again against a census and
three of them fall away: a census stays silent about length, leaves dependency to the work itself,
and belongs to one sequence by construction. The sorting objection alone survives, and it is cosmetic.

Meanwhile the census number buys something a timestamp cannot: **a gapless spine proves the record is whole.** An incident
ledger running 1 to 174 with no gaps makes a removed incident visible on sight. Marked only by
timestamps, the same removal closes over silently, and every tool reads the remainder as complete. In a ledger of faults that property outweighs tidiness anywhere else.

## The worked case

One tree seats a mark law that retires ascending marks, and its faults ledger has been minting
`%1` through `%174` the whole time. Read as a contradiction, that is a rule bent in the
tree's most-cited internal reference. Read with the distinction above, it is two different kinds of
number that happened to look alike.

Measured before deciding, on `2026-08-23`:

| Reading | Count |
|---|---|
| Citations of a row number across the tree | **2,519** |
| Of those, inside commit messages | **532** |
| Living files carrying at least one | **492** |
| Dated testimony files carrying at least one | **208** |
| Distinct rows cited by name | **109** |

Two of those rows matter to the decision more than the total. **532 citations sit in commit
messages**, which no rewrite reaches without rewriting history, and **208 sit in dated testimony**,
which the same tree's own law protects word for word. So a conversion could reach at most the
living remainder, and would leave the majority of citations pointing at a scheme that no longer
exists. **A migration that cannot finish costs more than the unevenness it set out to smooth**, since
afterwards a reader carries both schemes and the boundary between their eras.

And the chronology was never missing. Every row already opens
`**REDS %174 (`20260823.174500`) -- ...**`: number, stamp, and name, all three. The stamp orders it
and the name means it, exactly as the mark law asks. **The number is the only part carrying
information the other two cannot,** which inverts the usual finding, where the letter was the idle part.

## The test, stated for reuse

Before minting a counting number into a name, ask:

> **Could this number turn out to be wrong?**

For a sequence describing work you intend to do, the answer is yes, and a stamp and a name serve
better. For work that has already happened, the answer is no, and the number is a fact about the
past that also proves your record is whole.

A second question sharpens it: **would a gap in this sequence mean something?** In a ledger of
faults, an incident register, or a numbered set of decisions already taken, a gap means a record has
gone and you want to see it. In a plan, a gap means somebody changed their mind, which is ordinary.

## What to do with a rule that is silently violated

The finding worth carrying past this case has little to do with numbering. A rule written as universal,
with a real and reasonable exception running in plain sight, teaches every reader to read it as
approximate. **Write the exception into the rule, by name, with its reason.** The rule
gets stronger, the exception gets defensible, and the next person to notice the tension finds an answer
waiting.

## What this does not claim

This argues one distinction, and the boundary it draws is sharp only sometimes. A ticket number is
partly census and partly forecast -- issue 400 is filed in the past, and the tracker will keep
counting. The test above handles that: a filed ticket's number is already true and stays true, so it is safe. The case that stays genuinely hard is a numbered sequence covering work
partly done and partly planned; there the honest move is to split it into the part that happened and
the part that is intended, and mark each in its own way.

**A falsifier.** If a tree keeps a census number and, within a year, finds itself explaining that
number to newcomers more often than it uses it to find a missing record, then the completeness property was
theoretical and the number was tidiness after all.
