# Two scope-map rows the naive ranking already had right -- a checked worry that came back negative

**Stamp:** `20260918.085540`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. Nothing here runs today; two watch-set rows are proposed, unwritten.
**Room:** vision -- a measured proposal for a fixture this lane does not own.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at the fusion-build spine Bakery owns
**Kin:** [`tools/fixtures/s/standing_equipment_scope_map.sh`](../../../tools/fixtures/s/standing_equipment_scope_map.sh),
[`tools/fixtures/s/standing_equipment_scope_rank.sh`](../../../tools/fixtures/s/standing_equipment_scope_rank.sh),
[`20260918-054803_two-first-principles-proposals-caravan-lattice-hop-aurora-energy-crossover.md`](20260918-054803_two-first-principles-proposals-caravan-lattice-hop-aurora-energy-crossover.md)

## One sentence of honesty before the numbers

This page proposes; a witness on metal decides. Nothing below enters the checkable room until the
two rows are actually written into the tracked fixture and the roster's own `--scoped` pass proves
it still catches what it caught before.

## What this lane keeps checking, and what it found this time

Every prior piece from this lane asked whether a torus, a ring, or a radial scheme was hiding
somewhere in this tree's own code, and each search closed honestly empty -- the shapes stayed
absent. This piece turns the same discipline on a system that already runs radially: the
fusion build's scope map (`tools/fixtures/s/standing_equipment_scope_map.sh`) reads a changed path,
walks one hop to the guards that watch it, and skips every guard the change genuinely misses -- a graph
edge (path -> guard) standing in for the cartesian default of re-running the whole roster on every
pass. `standing_equipment_scope_rank.sh` already prices what each row saves, and named its own
sharpest unclaimed prize as of `20260918.085300`:

```
static_saving_s=345          # already claimed by 12 mapped rows
absent_cost_s=6386           # unmapped-and-mappable, the real remaining prize
absent_cost_share=0.926      # 93% of the pass's cost is still unclaimed
rank_unmapped 1 qa_genre_census cost=779s class=absent tier=cadence
rank_unmapped 2 two_rooms_doorway cost=349s class=absent tier=cadence
rank_unmapped 3 sow cost=328s class=absent tier=cadence
rank_unmapped 4 aurora_file_placement cost=207s class=absent tier=lap
```

Both figures are free -- re-read them with `sh tools/fixtures/s/standing_equipment_scope_rank.sh`.

## The worry, stated before it was checked

`aurora_file_placement` and `qa_genre_census` are the two costliest rows the rank tool calls
mappable rather than structurally DISCOVERY. Reading their own scans
(`tools/fixtures/a/aurora_file_placement_scan.sh:181-182`,
`tools/fixtures/q/qa_genre_census_scan.sh:92-94`) shows why they sit unmapped: each takes its
population from `git ls-files` over a **glob across the whole tracked index** rather than a small,
named room --

- `aurora_file_placement` reads every tracked `*.rye` file, roughly 1,730 sources.
- `qa_genre_census` reads every tracked path matching `_(witness|scan|control)\.` outside the
  `.md`/`.mdc`/`.bron`/`.kyri` families -- every program-named guard file in the tree.

The map's own header defines DISCOVERY narrowly -- "reads `git ls-files` with **no pathspec**" --
so each guard sits outside that word by the letter of the rule, since each carries a pathspec
(`*.rye`, or the naming regex). The worry this piece set out to check: **a guard whose population
is a glob across nearly the whole tree behaves like DISCOVERY in practice even while it stays
outside DISCOVERY's literal test**, so the rank tool's raw-cost prize for these two rows might
mostly stay unclaimable -- if almost every commit touches some `.rye` file, or some file shaped
like a guard, a watch-set row naming that same glob would buy little, since `touch_rate` would sit
near 1.0 and the saving `cost x (1 - touch_rate)` would shrink toward zero.

## The measurement, on the tool's own basis

`standing_equipment_scope_rank.sh` prices a row's saving over a **120-commit, no-merges window**
(its own default, `tools/fixtures/s/standing_equipment_scope_rank.sh:71,77,248`). Reading that exact
window rather than guessing a rate:

```
$ git -c core.quotePath=false log --no-merges -n 120 --format='%x01%H' --name-only | <split per commit>
total commits              = 120
commits touching any .rye  =  12   (touch_rate = 0.100)
commits touching a guard-shaped file (*_witness.*/*_scan.*/*_control.*) = 3   (touch_rate = 0.025)
```

**The tree's own history answers the worry directly, and it answers small.** Touch rate for
`*.rye`, over the tool's own window, reads **0.10** -- most of this pier's last 120 commits are
prose, session logs, and tooling in other languages, and Rye source changes stay the minority. The
guard-file glob reads rarer still, at **0.025**. Applying the rank tool's own arithmetic:

| Guard | cost (s) | measured touch_rate | saving = cost x (1 - touch_rate) | share of the guard's raw prize |
|---|---:|---:|---:|---:|
| `qa_genre_census` | 779 | 0.025 | ~759 | 97.5% |
| `aurora_file_placement` | 207 | 0.100 | ~186 | 90.0% |

**Observation:** these two numbers are read directly from `git log`, over the window the rank tool
itself already uses, on `20260918.085300`. **Inference:** a watch-set row using each guard's own
natural population (its `*.rye` or guard-glob pathspec, exactly what its scan already reads) would
claim close to the guard's full listed prize, contradicting this piece's own opening worry.
**Projection, bounded:** this holds only as long as the tree's recent commit mix stays roughly what
it measured today (prose- and tooling-heavy, Rye-light); a chapter that turns heavily toward Rye
authorship would raise both touch rates and shrink the real saving, which is exactly what a rank
re-read after such a chapter would show.

## Why the worry was worth checking even though it came back negative

A guard sitting outside DISCOVERY's letter while behaving like DISCOVERY in spirit is a real risk
this map could carry -- and the header's own text (`tools/fixtures/s/standing_equipment_scope_map.sh:26-34`)
already names the general shape: "the git-grep discoverers and reference sweeps... are paid down on
touch." Checking it against these two specific rows rather than trusting the general shape is what
turns a plausible worry into a measured answer, in either direction. Here it turned out the raw-cost
ranking was already trustworthy for its own top two candidates -- which is itself worth recording,
since the alternative finding (had the touch rate come back near 1.0) would have meant the rank
tool's own prize column was over-promising for its two biggest entries, and somebody would have
mapped them for a return far smaller than advertised.

## The buildable proposal, in the map's own written shape

Two rows, each following the syntax already seated at
`tools/fixtures/s/standing_equipment_scope_map.sh:82,139` (name, witness path, scan/control paths,
watch words, tier):

```
aurora_file_placement tools/a/aurora_file_placement_witness.rish tools/fixtures/a/aurora_file_placement_scan.sh tools/fixtures/a/aurora_file_placement_control.sh *.rye [lap]
qa_genre_census tools/q/qa_genre_census_witness.rish tools/fixtures/q/qa_genre_census_scan.sh tools/fixtures/q/qa_genre_census_control.sh *_witness.* *_scan.* *_control.* [cadence]
```

`*.rye` and the three `*_` globs are new watch-word **shapes** for this map -- every seated row
today names a room (`caravan/`) or a tool-family prefix (`tools/t/tally_*`), and a bare extension or
a cross-tree naming convention is a shape this map has yet to try. `scope_match_word`'s own comment
says why this stays safe rather than novel-and-risky: shell `case` reads a glob exactly as POSIX
already defines it, `*` crosses slashes, and a word ending in anything other than `/` is read this
same way already -- so `*.rye` widens the existing matcher rather than adding a new one.

## What this does not settle

**Whether the population itself is right to watch this narrowly.** `qa_genre_census` counts every
`_witness`/`_scan`/`_control` file in the tree; a row naming that same glob is tautologically
correct (it is what the scan reads) and says nothing about whether the census's own subject
boundary is the right one -- that is `docs-implementation-sync.md`'s question, not this one.

**Whether writing the row is this lane's to do.** Diffuser's mandate is research; the scope map is a
tracked fixture every ship's roster pass reads, and Bakery's own card item (fusion-build spine) is
the nearer owner. This piece hands over two rows ready to paste rather than pasting them.

## The falsifier

Write the two rows, run `sh tools/fixtures/s/standing_equipment_scope_rank.sh`, and read
`rank_static` for both names. **If either row's printed `saving` sits meaningfully below the table
above** (roughly 759s and 186s, allowing for the window having moved between measurements), the
measured touch rate drifted or the glob is catching more than the scan actually reads, and the
claim here was wrong on the numbers rather than on the reasoning. Separately, run
`sh tools/fixtures/s/scope_trace.sh aurora_file_placement` and confirm every file it opens falls
under `*.rye` -- the map's own repair history (`tools/fixtures/s/standing_equipment_scope_map.sh:52-58`)
shows a row can silently name less than its guard reads, and a bare-glob row is no safer against
that fault than a narrow one.

May the map keep pricing its own rows honestly, and may the next hand that reaches for the top of
the unmapped list find the numbers waiting rather than a worry to redo.
