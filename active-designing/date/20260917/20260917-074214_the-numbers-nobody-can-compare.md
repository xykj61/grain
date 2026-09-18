# The Numbers Nobody Can Compare

**Language:** EN
**Stamp:** `20260917.074214` (EDT)
**Voice:** Kyri
**Style:** Gauge, Field setting
**Status:** Living -- **mixed room**: every figure below is checkable by running the named scan, and
the recommendation at the end is a proposal for Keaton's word rather than a settled thing
**Seat:** diffuser -- moonshots and research
**Instrument:** [`../tools/fixtures/l/loom_sitting_scan.sh`](../tools/fixtures/l/loom_sitting_scan.sh),
bound by [`../tools/l/loom_sitting_witness.rish`](../tools/l/loom_sitting_witness.rish)
**Elder:** [`20260917-054941_the-unit-that-survives-the-pier.md`](20260917-054941_the-unit-that-survives-the-pier.md),
whose closing question this answers

---

## What this paper claims, and what would kill it

**The claim.** This fleet writes measurements into its session logs faithfully and cannot compare
most of them, because a key's values are scattered wider by the pier and by mixed workloads than by
any change a lap makes. Measured `20260917.074214` over the tracked journal: of the sixteen
most-written numeric `loom` keys, **one** is both a measurement and one population.

**The falsifier, named before the numbers.** If the within-sitting spread of the fleet's timing keys
came back small -- say under 50 parts per thousand, so a five percent improvement were readable --
then the journal's numbers are comparable as written, this instrument buys nothing but reassurance,
and the honest finding is that the elder paper's worry was local to one workload. Run
`sh tools/fixtures/l/loom_sitting_scan.sh wall_s` to try it.

**Horizon and confidence.** The reading describes this journal on this pier today. Every figure is
**free** -- the journal grows each lap and the numbers move with it -- so each is given with its
stamp and the command that re-reads it. Confidence in the census is high, since it is arithmetic
over tracked bytes. Confidence in the recommendation is moderate: it proposes a habit, and habits
are judged by whether anyone keeps them.

## The observation

`.claude/rules/session-logs.md` asks a lap to write what it measured on a `loom` line, and the fleet
obeys: **3,426 measurements across 1,577 logs**, read `20260907.222830` by the tool that first
opened them. `tools/l/loom_trend.sh` reads a key back across the whole journal and ends on one word.

```
LOOM_FAMILY=roster sh tools/l/loom_trend.sh seconds --summary
  values=171  min=5  max=9882  mean=2237.51  direction=rising
```

`direction=rising` is true and it is not a finding. The values run from 5 to 9,882 -- three orders
of magnitude -- because several different workloads write a key by that name. A slope across that
population describes which workload happened to run last.

## The inference

That one word is carrying two facts at once. It reports that the last value differs from the first,
and a reader takes it as evidence that **the work** changed. On a pier eight ships share, those come
apart. The elder paper measured how far: a wall-clock median of *identical* work moved **306 parts
per thousand** across six sittings while the same work's CPU median moved **7**. A wall number moves
forty-four times as far, with the load rather than with the work.

So a trend line cannot answer the question a reader actually has, and the question has a name:
**what is the smallest change this key could prove?**

## The instrument

`tools/fixtures/l/loom_sitting_scan.sh` groups a key's values by **sitting** -- the
`session-logs/date/YYYYMMDD/` shelf each log was born on -- takes each sitting's own median and
spread, and prints two numbers side by side, both in parts per thousand of a median:

| Reading | What it is |
|---|---|
| `within_ppt` | the median sitting's own spread -- how far this key wanders when nothing changed |
| `across_ppt` | how far the sitting medians themselves range, change and pier together |
| `resolution_ppt` | the same number as `within_ppt`, named for what a reader does with it |
| `scale` | the median of the sitting medians, so a ppt figure has a size beside it |

**`within_ppt` is the resolution floor.** A claimed improvement smaller than it cannot be told from
the noise of the sitting it was measured in, whatever the trend line says.

**Three things in the design are deliberate, and each is a boundary that could have been braided.**

**The day is a proxy, and its error has a direction.** A day holds many hours and the pier's load
moves inside one, so grouping by day makes `within_ppt` larger than true repeat-to-repeat noise.
That inflates the floor, so the reading refuses to call a small change readable *more* often than a
finer grouping would. A coarse proxy is acceptable exactly when its error runs toward refusal.

**A single-value sitting is unmeasured rather than noise-free.** Its spread is zero, and averaging
that zero into the floor would make every key look sharper than it is. Singletons are counted apart,
excluded from the floor, and kept for the across reading where one median is a legitimate point. A
key with no multi-value sitting prints `within_ppt=na` and refuses. That trap is this seat's own red
from `20260917.054941` -- one value wearing two conditions -- caught before it was written.

**The verdict is a comparison rather than a blessing.** `across_exceeds_noise` says the sitting
medians range wider than a sitting wanders. It does **not** say an improvement happened, and this
reading cannot tell a real improvement from a key merging workloads that were never one population.
`spread_class` stands as its own field for that reason.

## The census

Sixteen most-written numeric keys, read `20260917.074214` at load average 17.35. Every figure is
free; the command above re-reads any row.

| Key | values | numeric | sittings | `within_ppt` | scale | class |
|---|---|---|---|---|---|---|
| `witness` | 1319 | 12 | 5 | 115.1 | 93 | suspect_mixed |
| `red` | 704 | 680 | 25 | 3000.0 | 2 | coarse_integer, suspect_mixed |
| `green` | 688 | 669 | 28 | 972.2 | 103.5 | suspect_mixed |
| `tree_moved` | 608 | 0 | -- | na | -- | a word, never a number |
| `wall_s` | 579 | 574 | 25 | **21086.9** | 51 | suspect_mixed |
| `gated` | 524 | 522 | 15 | 1000.0 | 2 | coarse_integer, suspect_mixed |
| `guards` | 440 | 438 | 25 | 432.8 | 113 | suspect_mixed |
| `guards_run` | 421 | 421 | 21 | 135.9 | 159 | suspect_mixed |
| `seconds` | 329 | 329 | 14 | 1372.4 | 2332.5 | suspect_mixed |
| `guards_red` | 307 | 307 | 20 | 2000.0 | 2.75 | coarse_integer, suspect_mixed |
| `ceiling` | 297 | 291 | 25 | 48301.9 | 165 | suspect_mixed |
| `legs` | 218 | 210 | 19 | 1748.6 | 16 | suspect_mixed |
| `bound` | 201 | 199 | 24 | 375.0 | 24576 | suspect_mixed |
| `composite` | 162 | 160 | 18 | **107.1** | 93.25 | **one_population** |
| `files` | 177 | 175 | 25 | 12708.9 | 46 | suspect_mixed |
| `rungs` | 156 | 156 | 10 | 1068.6 | 90.5 | suspect_mixed |

**Three readings stand out, and they are three different findings.**

**`wall_s` is the key this fleet times with, and its resolution floor is 21,087 ppt.** A twenty-one
fold change is the smallest one that key could prove. A lap claiming a halving, or a doubling, is
inside its own noise. This is the elder paper's projection arriving as a measurement.

**`composite` is the one key that is a measurement and one population.** It is the quality-assurance
grade, it runs on a bounded scale of nought to a hundred, and its floor is 107 ppt -- about eleven
points. The reason it reads cleanly is instructive: a grade is bounded, it is computed from bytes
rather than from a clock, and every lap that writes it ran the same tool over one file. None of
those three properties belongs to a timing key.

**Four keys are counts wearing a ratio.** `red`, `gated`, `guards_red` and `legs` read enormous
floors for a purely arithmetic reason -- one whole unit of a median of 2 is 500 ppt. The scan names
this rather than letting the spread speak for it, and the lesson is the same single-strandedness
everywhere else in this paper: **spread and scale are two facts and they need two fields.** The
first run of this instrument reported `red` as the noisiest thing in the journal, which was true and
meant nothing.

## What the instrument does not read

**Whether a key's values mean what their writer thought.** `witness` holds 1,319 values of which 12
are numeric; the rest are names. That is the convention working as intended and it is invisible to
any statistic.

**Any grouping but the day.** An hour grouping is a real question and wants its own run. The day was
chosen because it is what a log's own path carries, so no file is opened to find it.

**Whether a mixed key should be split.** `seconds` merges a cold roster pass, a hot one, and a
scoped one. Splitting it into three keys would probably make each one comparable, and that is a
habit rather than a reading.

## The recommendation, and its cost

**For Keaton's word.** Two moves, and the second is much cheaper than it looks.

**First: a timing claim carries its unit and its floor.** A `loom` line reporting a saving reads
better as `wall_s=41 floor_ppt=21087` than as `wall_s=41` alone, since a reader then sees at once
that the number cannot support the sentence around it. The instrument to derive that floor now
exists and costs 0.3 seconds.

**Second: a key that is one workload gets its own name.** `roster_cold_s` and `roster_hot_s` cost
nothing and would move `seconds` out of `suspect_mixed` by construction. This is the cheaper half
and it needs no tool at all.

**What neither move buys.** Neither makes this pier quieter. Eight ships share it, and the elder
paper already named the only unit that survives that: **CPU milliseconds**, whose median moved 7 ppt
across six sittings where wall moved 306. A fleet serious about comparing its own work would write
both, and this paper does not argue for that here -- it is a change to a law, and laws want a word.

## A note on this paper's own numbers

The extraction that made this reading possible also made the elder reader a hundred times faster,
and that claim is stated in the unit this fleet can defend. `tools/l/loom_trend.sh composite
--summary` read **83.7 seconds wall, 58.9 seconds CPU** before the value read moved into a sourced
sibling, and **0.305 wall, 0.211 CPU** after, both at load average 17 to 18 on `20260917`. The wall
ratio is 274, the CPU ratio 279, and it is the second one that would survive a quieter afternoon.
The move itself changed nothing a reader sees: six keys' summaries stand byte-identical across it,
proven in the control against the elder pipeline rather than claimed.

---

May every number this fleet writes down be one somebody can honestly compare, and may the ones that
cannot say so on their own face.
