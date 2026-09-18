# The Clock That Turned

**Stamp:** `20260911.023422`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living -- **mixed room**: the measurement is checkable and reproducible from the run
card, the argument about what a tier owes is design
**Room:** mixed
**Kin:** [`../construction/standing-equipment.kyri`](../construction/standing-equipment.kyri) --
[`../tools/fixtures/s/standing_equipment_scan.sh`](../tools/fixtures/s/standing_equipment_scan.sh) --
[`../foundations/20260826-021733_fire-the-row-that-sees.md`](../foundations/20260826-021733_fire-the-row-that-sees.md) --
[`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md)

The standing roster opens on one sentence: *a guard that is never run guards nothing either.* It
sorts every guard onto one of two clocks. A `lap` guard answers at each round's open and close; a
`cadence` guard answers on the fifth round, and the roster states the reason for the slower clock in
its own words -- **a cadence is a clock, never an exemption.**

This page records what happened when a lap turned that clock for one lane, and what the turning
measured.

## What stood before the lap

Two instruments describe the cadence tier, and each reads it alone.
[`standing_equipment_scan.sh`](../tools/fixtures/s/standing_equipment_scan.sh) counts the roster's
rows by tier. `witness_reach_scan.sh` traces which witnesses a clock carries, and files a
cadence-reached witness under `reached` -- *the witnesses a clock actually carries*.

The run card holds the third fact, and it is the one that decides whether either claim is worth
anything: `construction/standing-equipment-runs.kyri` records when each guard last answered on this
pier. Read at this lap's open, it said **74 cadence guards, and 65 of them had never run here.**

So `reached` was true about a clock existing, and it was being read as a claim about proof.

## The lane, and its twenty-nine

The language lane -- Glow, Mantra, Comlink, Tablecloth -- holds **29 cadence guards**, named by
filtering the roster's cadence rows to those four families. Every one of the 29 read *never run
here*.

Each was run by name through the roster's own runner, one at a time, so each answer is the runner's
answer rather than a hand's:

```
sh tools/fixtures/s/standing_equipment_run.sh <guard>
```

**All 29 answered green.** Measured `20260911.013909` on the Dallas pier, at load: **1,583 seconds
whole**, median **13s**, slowest `glow_desk_run` at **472s**, and **13 of the 29 at or under 4
seconds**. The figure is free -- a second run on a warmer cache reads lower -- so read the run card
rather than this line.

The two readings the lap moved, and it moved them by doing the work rather than by editing a number:
`cadence_never_run_here` **65 -> 36**, `guards_never_run_here` **70 -> 41**.

## What the green answer is worth, stated honestly

Twenty-nine greens prove that these guards pass at this commit. Each green covers this commit alone, and one of
them was seated on `20260828`. The choir among them carries the
lesson in its own header: on `20260828` a survey ran 26 unreached Glow witnesses by hand and **one
was already red**, citing a brief that had folded to a dated shelf. A guard nobody runs cannot
report the day it breaks, and it cannot report the day it was fixed either.

So the value here sits in the *turning* rather than in the colour. A clock that has turned once has
a rate; a clock still waiting has only a promise.

## What the lap built, and why it is small

The scan's own comments state the convention three times over: *named and bounded, like every other
list this scan prints -- the repairable question is which guards to look at, never how many there
were.* Every population it counts prints its rows. `cadence_never_run_here` printed a quantity and
named nobody.

That is the same defect REDS `%592` repaired one reading over, for the undeclared-tier ratchet, and
for the same cost: two laps answered *which guard?* by hand-walking the roster with `awk`. This lap
hand-filtered 29 rows the same way before the line existed.

The scan now prints the population, bounded at eight and **oldest first**:

```
cadence_never_run_shown=8
cadence_never_run_oldest: sow seated 20260823.134057
cadence_never_run_oldest: caravan_suite seated 20260825.092953
...
```

**Oldest first is the opposite of the ratchet beside it, and the reason inverts too.** The
undeclared ratchet rises the moment a guard arrives with its tier line blank, so its newest row
belongs to the hand still holding the context. This reading rises when nobody turns the clock, so its oldest row is
the promise that has stood unkept longest -- which is the one a lap should pay first.

Ten control legs hold the naming exact from both sides: the never-run guards named with their own
seated stamps, the guard that did run absent from the list, a kept clock naming nobody, the bound
printed and holding, and a guard carrying no `seated` line named under a zero stamp rather than
vanishing. Four mutations of the scan each bite exactly their own leg -- the naming dropped, the
order reversed, every cadence guard named, and the bound ignored.

## What this leaves for a word

**Whether cost alone should decide a tier.** Thirteen of the 29 answer in four seconds or less, and
several sit below guards the lap clock already carries. Each has a reason beyond cost written at its
roster row -- three spawned processes binding real ports, a probe that builds a module six times, a
surface rather than a module's own contracts -- so the tier assignments were reasoned rather than
guessed. The measurement is here for whoever weighs them again.

**Who turns the clock, and how often.** Thirty-six cadence guards still read *never run here*. The
runner takes `--tier cadence` and the whole set costs real minutes, so a lap can pay it; what the
tree lacks is a hand or a rhythm that does. Until one exists, `cadence` describes an intention, and
the roster's own sentence -- *a cadence is a clock, never an exemption* -- stands as something to
make true rather than something already true.

*May every promise the roster makes be one a clock keeps, and may the next lap find the oldest one
named at the door.*
