# More instrument than thing -- the day the tree turned to measure itself, and the ratio since

**Stamp:** `20260908.054953`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- **mixed room**: the census is checkable and every figure below reproduces from the commands given; the reading of what it means, and the one thing it recommends, are inference and are labelled as such
**Room:** mixed
**Kin:** [`20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md`](20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md) -- the elder paper that held this number in a table and read past it -- [`../foundations/20260826-021733_fire-the-row-that-sees.md`](../foundations/20260826-021733_fire-the-row-that-sees.md) -- [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

## The question, and the one-line answer

This tree writes two kinds of code: **module source**, which is the thing being
built, and **instrument source** -- witnesses, scans, controls, roster machinery --
which is how the tree knows the thing is right. This paper asks what the ratio
between them has been, week by week, and whether it moved.

**It moved, sharply, on one datable day.** Over the seven days ending
`20260908`, the tree seated **117 new guards** and landed **32 commits touching
module source**. Three weeks earlier the same reading ran the other way by an
order of magnitude.

## Bounds, before any number

Every figure was read on the Dallas pier on `20260908` between `05:20` and
`05:49` America/New_York, from a clean checkout at git nib `e334931cb2`, on the
`main` branch as `xy` had it at that moment. Windows are commit dates, not author
dates, and a rebase re-dates nothing here because the fleet rebases rather than
merges.

**Two definitions carry the whole census, and both are mechanical.**

- **Module source** -- a commit touching at least one `.rye` or `.glow` file
  whose path does **not** begin `tools/`. That is authored program source living
  in a module room.
- **Instrument source** -- a commit touching any path under `tools/`. That room
  holds the witnesses, the scan and control fixtures, and the roster runner.

The split is a path test rather than a judgment, so anyone can rerun it and get
this table. It carries one named imperfection, addressed under *What the
definition gets wrong* below.

## The census

```
git log --since=2026-08-10 --date=short --format='C %H %ad' --name-only \
 | awk '/^C /{if(h!=""){print d,(m?1:0),(t?1:0)} h=$2; d=$3; m=0; t=0; next}
        /\.(rye|glow|rish)$/{if($0 ~ /^tools\//) t=1; else m=1}
        END{if(h!="")print d,(m?1:0),(t?1:0)}' \
 | awk '{n[$1]++; s[$1]+=$2; u[$1]+=$3}
        END{for(k in n) printf "%s total=%-4d module=%-4d tools=%d\n",k,n[k],s[k],u[k]}' | sort
```

**Observation.** Commits per day, and how many of them touched each kind of
source. Both counts are of commits, so a commit touching both is counted in
both columns.

| Day | Commits | Touching module source | Touching instrument source |
|---|---:|---:|---:|
| 2026-08-15 | 183 | 176 | -- |
| 2026-08-17 | 165 | 140 | -- |
| 2026-08-19 | 112 | 99 | -- |
| 2026-08-20 | 78 | 68 | 75 |
| 2026-08-21 | 85 | 45 | 71 |
| 2026-08-22 | 64 | 52 | 59 |
| **2026-08-23** | **44** | **7** | **25** |
| 2026-08-25 | 58 | 15 | 24 |
| 2026-08-28 | 95 | 13 | 51 |
| 2026-08-31 | 29 | 5 | 20 |
| 2026-09-05 | 61 | 1 | 17 |
| 2026-09-06 | 127 | 15 | 69 |
| 2026-09-07 | 112 | 10 | 69 |
| 2026-09-08 | 38 | 5 | 15 |

**Observation.** The turn falls between `2026-08-22` and `2026-08-23`. Module
commits go 52 to 7 while the day's total falls only 64 to 44, so the drop is a
change of subject rather than a quiet day.

**Observation, from the commit subjects themselves.** On `2026-08-21`, 46 of the
day's 85 subjects carry the `caravan:` prefix. On `2026-08-23`, none do; the
day's leading prefixes are `construction` (9), `tools` (6), and `context` (5).

## The instrument's own growth curve

The roster file records the stamp each guard was seated, so the instrument layer
counts itself.

```
grep -E '^seated ' construction/standing-equipment.kyri \
 | awk '{print substr($2,1,8)}' | sort | uniq -c
```

**Observation.** Guards standing, cumulative: **20** on `20260821`, **35** on
`20260823`, **133** on `20260901`, **250** on `20260908`. Per day over the last
four working days the roster gained 36, 43, 33, and 3.

**Observation.** These stamps mark new files rather than backfilled rows. Since
`20260905` the tree added **79** new `*_witness.rish` files and **226** new
witness, scan, and control files together, all under `tools/`.

**Observation.** Over the same three days (`20260905` through `20260907`), module
source was touched by **26** commits. The tree seated **112** guards in that
window, a ratio of **4.3 guards seated per module-source commit**.

**Observation.** A cold roster pass I ran this morning reports `guards_run=186`,
`guards_green=183`, `guards_red=0`, `guards_gated=3`, `guards_seconds=1411` --
**23.5 minutes**, and every ship runs it twice a lap.

## What the definition gets wrong, said plainly

**Some `tools/` code is a real library rather than an instrument.** `tools/rye/`
holds authored sources including crypto shims, and counting them as instrument
overstates the instrument side.

**Observation, which bounds that error.** Of file touches under `tools/` since
`20260905`, **283** were `.rish`, **528** were `.sh`, and **19** were `.rye`. The
library case is 2.3% of the touches, so it moves no conclusion here.

**A line count agrees with the commit count and should be trusted less.**
Measured the same way, module source took 86.8% of changed lines in
`2026-08-15..08-23`, 18.9% in `08-23..09-01`, and 5.4% in `09-01..09-09`. That
first figure is inflated: the largest contributors are Caravan ladder passes
applying one change across 47 rung files, so a single decision shows up as tens
of thousands of lines. The commit measure carries no such inflation, which is why
the tables above are commits.

## Three explanations tested

**"The fleet grew, so the denominator grew."** The fleet went from one ship to
eight over this period, and every lap commits a session log and the card, which
inflates the total. That holds, and the finding survives it, because the
**absolute** module count fell too -- 50 to 176 per day in mid-August, 5 to 15 per
day now. A share can be an artifact of its denominator; a count stands on its own.

**"The modules are finished."** The card answers this in its own words.
`construction/ITINERARY.md` carries **Caravan as a semi-standfast at raised
priority**, and records that of the equality arc's eight proofs, *"Aurora's three
and Caravan's one stay unheard."* Named, open, module-level work stands today.

**"The research had nothing buildable to offer."** This lane handed Caravan a
concrete, small, comptime-only item on three separate laps
(`20260908-005732`, `20260908-021719`, `20260908-025249`), each naming the file
and the constant. **Zero commits have touched `caravan/` since `2026-09-06`.**

## The inference, and it is one sentence

**Inference.** Since `20260823` this tree has been building the apparatus that
proves a program correct considerably faster than it has been building the
program, and the gap is widening rather than closing.

**Inference.** This follows from what the disciplines currently reward, rather
than from any lapse in following them. Lindy-first puts durable work ahead of ephemeral
work, and a guard genuinely is durable. Reds-first books the allocation to
defects, and a guard is how a defect class dies. Every lap that seats a guard has
followed the law exactly. **The law still wants a term for the case where the durable
work is durable apparatus around a thing that has gone quiet.**

**Observation supporting that reading.** The elder paper measured which files the
mapped guards actually watch, over 123 commits in one day: `tools/` 68.3%, any
`*.rye` 12.2%, `caravan/` **0.0%**. The instrument layer's busiest watch is the
layer that writes instruments.

## Projection

**Claim.** Absent a deliberate turn, module-source commits stay under 20 per day
through `20260922` while the roster passes 350 guards.

**Horizon.** Fourteen days, ending `20260922`.

**Assumptions.** The fleet stays at roughly eight ships; no chapter is seated
that names module work as its subject; the roster keeps its present tiering, so
a pass keeps costing about 24 minutes and each new guard adds to it.

**Falsifier, and it is a single command.** Re-run the census above on
`20260922`. If module-source commits over the trailing seven days exceed **80**
-- that is, better than double the 32 measured here -- while total commits stay
above 200, the claim is dead and the August turn was a chapter boundary rather
than a standing drift.

**Confidence, in plain words.** Moderate. The trend is 17 days long and monotone
across three independent measures (commits, lines, guards seated), which is what
makes it worth writing down. Intent stays invisible from here: a chapter whose
declared subject is the law would produce exactly this signature, and would be
entirely correct to.

## What is buildable, and what is not

**Buildable now, small, and it belongs to nobody's module.** A reading, not a
gate: add the module-versus-instrument ratio to whatever already reports the
tree's own vital signs, computed by the awk above over a trailing seven days.
The number costs one `git log` and takes seconds. It earns its place as the one
figure the tree currently leaves unprinted, and a ratio nobody prints is a ratio
nobody notices moving.

**Reported, never gated, for the reason this tree keeps re-learning.** A gate on
this ratio would red on a lap that legitimately spent its day on a guard, which
is honest work; a gate that refuses honest work is a gate somebody turns off.
The elder doorway ratchet published at its own reading and reddened eight ships
for one page, and that lesson is two days old.

**Not buildable from here, and it is the larger half.** Whether the ratio *should*
turn is a question about what chapter this tree is in, and that stays Keaton's
word rather than a lap's. This paper measures; scheduling belongs elsewhere.

**One thing a builder can take today without waiting on any of that.** The three
Caravan items already handed over are each a named constant, a comptime assert,
and an edge reading -- zero run-time cost, and a build that fails is the second
move working. They are the smallest available proof that the ratio can turn.

## What this paper does not reach

**Whether a guard was worth seating.** Every one of the 250 answers a real
question, and several closed defect classes that had fired more than once. The
census counts them and leaves the grading to a reader.

**Effort.** A commit stands for wildly varying hours. A single module commit may
carry a week of design, and a guard may be twenty minutes. The ratio gives a
direction rather than a budget.

**The other seven ships' intent.** I read the commits rather than the plans. Any ship
whose chapter genuinely names the law as its subject is doing exactly what it
should, and this paper is the reading it can hold that claim against.
