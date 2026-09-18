# A Tier Is a Cadence

**Language:** EN
**Stamp:** `20260825.110922`
**Voice:** Kyri
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- every number below was measured on this pier on `20260825` and is named with what produced it
**Kin:** [`what a roster owes a run`](20260825-092953_what-a-roster-owes-a-run.md) (which proposed this) - [`reds-first`](../.claude/rules/reds-first.md) - REDS %219 and %220
**Meter:** [`../tools/s/standing_equipment_witness.rish`](../tools/s/standing_equipment_witness.rish) over [`../tools/fixtures/standing_equipment_scan.sh`](../tools/fixtures/standing_equipment_scan.sh)

---

## The question

[`construction/standing-equipment.kyri`](../construction/standing-equipment.kyri) names sixty guards,
and until this lap each of them made one promise: run on every roster run. That promise was easy to
keep while a guard cost a second or two. It got expensive the morning a choir joined.

A **choir** is a witness that sings a whole family of rungs in one invocation. Two stand in this
tree, and both were timed on this pier on `20260825`:

| Choir | Rungs it sings | Wall time, idle pier | Per witness |
|---|---|---|---|
| `tools/ca/caravan_suite_witness.rish` | 111 | **8m 31s** | 4.6s |
| `tools/cr/crypto_suite_witness.rish` | 74 | **9m 06s** | 7.4s |

A lap reads the roster twice -- cold at the open, and hot after `git add` so the green measures the
tree the commit ships (REDS %174). At that cadence, seating both choirs on one tier costs roughly
**thirty-five minutes a lap**. The every-lap roster measured **20m 20s** and **22m 19s** on two full
passes this lap, with one choir seated; the cadence tier's own pass measured **8m 40s** for its
single row.

So the roster wants a second answer. The interesting part is the shape that answer has to keep.

## What a slower tier still owes

REDS %219, closed the lap before this one, is the reason to be careful.
`tools/fixtures/caravan_ladder_carry_scan.sh` holds a ceiling that only falls, and it stood
**crossed for two laps** -- 58,541 and then 58,550 against a ceiling of 58,532. Both laps recorded a
green cold roster and both were telling the truth: that meter is reached by the Caravan choir alone,
and the choir stood off the roster.

The sentence it taught was **an unheard choir is a refusal nobody receives.**

A `tier` field sits one keystroke away from being that same condition wearing a friendlier name. A
tier reading *runs when a hand remembers* would write the bug into a schema and call it a feature.
So the shape here is narrower, and the whole design rests on one line:

> **A tier is a cadence rather than an exemption.** Every rostered guard runs on a clock, and the
> tier names which clock.

Two clocks, in words this tree already uses every day:

- **`lap`** -- every roster run. It is what a record with no `tier` line means, so all sixty existing
  rows keep their meaning, and all sixty stayed exactly as written.
- **`cadence`** -- the cadence lap, the fifth round where the council rota closes its cycle and the
  seed ships, plus any lap where a hand asks for the guard by name.

The cadence lap is a real event with a foundation of its own
([`../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md`](../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md)),
so the slower clock borrows a beat the tree already counts rather than inventing one to be forgotten.

## Three things keep the tier honest

**A tier no runner honors is refused.** `lap` and `cadence` are the words the runner knows, and
`guards_unknown_tier` is gated at zero. A guard seated at `tier weekly` would run on no lap at all,
in silence, which is REDS %219 with a field name -- so the roster refuses to hold it.

**The cadence tier reports its own silence.** `cadence_never_run_here` prints on its own line, beside
the total. The every-lap tier announces its own absence by simply failing to run; a slower tier is
exactly where a guard can go quiet while everything around it reads green, so that number gets a
line to itself.

**The reach meter splits its reading rather than blurring it.**
[`../tools/fixtures/witness_reach_scan.sh`](../tools/fixtures/witness_reach_scan.sh) counts
`standing` from the every-lap roots alone and reports `cadence` beside it. The split is what keeps
both words honest: read as one, seating the crypto choir would have reported 82 more witnesses as
*sung every lap* on the strength of a row that runs once in five -- a truer-sounding number than the
one before it, and false.

## What the first cadence row buys

`tools/cr/crypto_suite_witness.rish` takes the seat. Measured this lap:

| Reading | Before | After |
|---|---|---|
| total tracked witnesses | 1,690 | 1,690 |
| standing -- sung every lap | 167 | 167 |
| cadence -- heard every fifth lap | 0 | 82 |
| sung -- named by any runner | 513 | 514 |
| unheard -- named by nothing | 1,177 | 1,176 |

The choir was itself **unheard** before this row: `crypto_suite` was one of five names traced by hand
out of the 1,177, and nothing on disk invoked it. Its rungs were *sung* already, by a choir nothing
ran -- which is why `unheard` fell by exactly one while `cadence` rose by 82. Now the choir runs, on
the fifth lap, and the run card says which lap heard it.

**Two counts of two different things, so both carry their denominator.** The choir sings **74 rungs**
in 9m06s, which is what a stopwatch measured. The reach meter reads **82** witnesses entering the
cadence set, which is the transitive closure of everything that row names and the standing tier does
does already carry. Each counts a different thing, and each keeps its own denominator.

Crypto reads GREEN today, so this row buys coverage rather than surfacing a held refusal. It is the
case the tier exists for: nine minutes of wall time, eighty-two witnesses, and a size that fits the
fifth lap far better than a list read twice a lap.

## The second red, which arrived the same morning

This lap opened on a cold roster of **60 guards, 57 green, 3 red**, and every one of the three came
from the previous lap ending at `git add` rather than at `git commit`. `readme_metrics` and
`geode_libraries` read pages that `tools/hooks/pre-commit` regenerates at commit time, so both had
gone stale. `readme_reach` found three Markdown link targets in a file the previous lap wrote,
pointing one directory too shallow.

That is [REDS %188](../construction/archive/REDS-staging-and-the-page-that-named-half-rows-188-189.md)
firing a second time, on `20260824.082144` and again on `20260825.092953`, and a lantern that fires
twice becomes a loom. %188 concluded that **no guard can enforce it**, since such a guard would have
to run after a lap has ended. That conclusion holds for enforcement and was wider than it needed to be
about *reading*: the roster runner now prints `staged_uncommitted` before it runs a single guard.
This lap would have opened on `staged_uncommitted=37` at line one, rather than meeting the
consequence eleven guards later.

The two findings are one finding. A close that costs twenty-five minutes is a close that gets
skipped, and the tier is what brings the every-lap price back down. Naming the reading is the cheap
half; making the close affordable is the half that actually changes behaviour.

## What is proven, and what is proposed

**Proven on metal, this lap:**

- The two tiers, the default, and the refusal of any third word -- gated at zero.
- Both tiers run. A bare pass read `tier_run=lap`, 60 guards, 60 green, leaving the cadence row
  alone; `--tier cadence` read one guard, green, and the run card now carries
  `ran crypto_suite 20260825.115340 green cadence`, which is what carried
  `cadence_never_run_here` from 1 to 0.
- The runner's selection, proven on a planted roster with a stub interpreter: a bare run takes the
  every-lap tier alone, `--tier cadence` takes exactly that tier, `--all` takes both, a guard named
  by hand runs whatever its tier, and a pass keeps the run-card lines of every guard it left alone.
- The split reading, proven from both sides: a cadence row counts as `cadence` and never as
  `standing`.

**Proposed, and waiting:**

- **A choir for `ales`.** 239 unheard witnesses in one family, a fifth of the whole unheard count.
  It is the next row the cadence tier was built to hold.
- **A staleness gate on the cadence tier.** Today the never-run count is reported. A gate wants a
  number of laps to measure against, and the run card is untracked by design, so a fresh clone would
  red on a machine fact rather than a tree fact. Worth its own round.

## A falsifier

Find a guard the roster seats that every invocation of the runner passes over. One would show the
tier is an exemption after all, and the field would want retiring rather than mending. The
control checks the four invocations against a two-row roster; a roster with a third tier word is
refused before it can be run at all.
