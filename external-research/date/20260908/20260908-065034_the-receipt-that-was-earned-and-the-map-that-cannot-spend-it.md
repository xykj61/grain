# The receipt that was earned, and the map that cannot spend it

**Stamp:** `20260908.065034`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- **research for understanding**: a measurement of why the fleet's cheaper
proving pass saves so little, read from records the tree already writes. Nothing here is bound by a
witness yet, so it sits in the proposed room ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Room:** research for understanding
**Kin:** [`20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md`](20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md)
(the cost half, which this does not repeat) -
[`../active-designing/20260825-173153_reprove-only-what-moved.md`](../active-designing/20260825-173153_reprove-only-what-moved.md)
(the design being measured) -
[`../construction/standing-equipment.kyri`](../construction/standing-equipment.kyri) -
[`../.claude/rules/docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md)

## Bounds, before any number

Every figure below was measured on the Dallas pier on `20260908` between `06:24` and `06:50`
America/New_York, at git nib `33717ea04f`, on the `grain-diffuser` checkout, `host=linux`. Three
sources: one cold roster pass I ran myself
(`sh tools/fixtures/s/standing_equipment_run.sh`, whose totals appear below verbatim); the
untracked per-pier records `construction/standing-equipment-receipt.kyri`,
`construction/standing-equipment-hitrate.kyri` and `construction/standing-equipment-runs.kyri`;
and `sh tools/fixtures/s/standing_equipment_scope_rank.sh`, read at `--window 120` commits. Seven
other ships sailed while my pass ran, so every wall figure carries contention. The
per-commit touch rates the rank scan reports are a floor, and the savings computed from them a
ceiling, for the reason that scan states about itself.

## Observation: the receipt exists, and three living surfaces say it cannot

`--scoped` is the fusion build's cheaper pass: it reproves only the guards a changed path reaches,
skipping the rest against a named basis. It needs one thing -- a receipt from a **fully green full
close** on this pier, carrying a commit this repository still holds.

The tree's own words place that receipt out of reach here. `tools/fixtures/s/standing_equipment_run.sh`
line 1037 reads, in the present tense:

> this pier carries two, pond_enclosure_door at gate %5 and rule_twin at gate %7, so no pass here
> can ever close fully green and the fusion build's cheaper pass can never be earned (REDS %374).

`construction/archive/REDS-the-guard-and-the-allocator-rows-388-389.md` says the same and draws the
consequence: *"`%374` is the multiplier: `--scoped` is unreachable on a tree carrying a
custody-gated red, so every rebase pays a full pass."*

**The file on disk answers otherwise.** `construction/standing-equipment-receipt.kyri`, this pier, read
`20260908.065034`:

```
format standing-equipment-receipt-v2
digest 6d4721cd82d4
head e334931cb25739101828274bb816177410406b55
scope full
guards 186
gated 3
gated_at rule_twin(%7) pond_enclosure_policy(%5) pond_enclosure_ephemeral(%5)
stamp 20260908.052552
```

A receipt was written six hours ago, from a full close carrying three gated guards and a red count of zero.
**The repair that made it possible sits 140 lines above the stale comment, in the same file.** At
line 897 the counter splits: a guard failing at a custody gate the card names books `gated`, and
only `red` refuses the receipt. That change landed on Keaton's word `20260904` under REDS `%374`,
and the comment describing the fault it repaired still stands beside it, speaking as now. This is the docs-implementation-sync shape at its smallest radius -- one file, two comment
blocks, opposite claims, and the evidence deciding between them written by the same script.

## Observation: the hit-rate meter reads zero, and is built to

`construction/standing-equipment-hitrate.kyri` holds one row per roster open on this pier: **89
rows, 53 `miss`, 36 `none`, and `match` exactly zero times.**

That reading is honest, and it carries no signal. `roster_receipt=match` is set only when the tree
digest at the open equals the digest the receipt recorded -- and that digest reads `git rev-parse
HEAD`, the porcelain, the full `git diff HEAD --binary`, and a hash of every untracked file. Any lap that commits moves it. So `match` holds only between two opens with **no work between them**, which is the one interval a
working fleet always fills.

**And `match` is not what `--scoped` consults.** The scoped filter, at line 707, asks three
different questions: is `receipt_scope` full, is `receipt_head` non-empty, and does this repository
still hold that commit. A reader taking the hit rate as the fusion build's readiness reads a
number answering a different question -- one meter, two questions, which is the single-strand
fault named in [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md).

## Observation: where the seconds actually are

My own cold pass, verbatim from its close:

```
guards_run=188  guards_seconds=1486  guards_green=183  guards_red=2  guards_gated=3
```

`sh tools/fixtures/s/standing_equipment_scope_rank.sh`, same tree, over a 120-commit window:

| Reading | Value |
|---|---|
| lap-tier cost | **1,454s over 186 guards** |
| guards carrying a scope-map row | **58** of 252 rostered |
| seconds those 58 own | **258s** -- 17.7% of the pass |
| seconds they actually save | **167s** -- 11.5% of the pass |
| seconds in guards the map cannot skip | **1,196s** -- **82.3%** |

Across 20 scoped passes recorded in `loom` lines across the fleet's session logs, `skipped_scope`
ran **14 to 33 guards**, median about 24, against roughly 186 run -- **8% to 18% by count**.

**Re-read after the rebase, `20260908.072800`, at nib `ef9ce7e74e`.** This page was written on one
tree and landed on another: a peer's commit *tools: the word the scope map never spelled* arrived in
the same window and moved these figures. Same 58 rows, and `static_saving_s` **167 -> 194**,
`unmapped_cost_share` **0.823 -> 0.789**, over `lap_cost_s` **1,456 across 188 guards**. Both
readings stand as measured and the second is the current one -- and it is the best evidence this
page carries for its own first door: **one better-spelled watch-set bought 27 seconds a pass**,
which is what writing map rows really pays, and how far from 79% it leaves the total.

## Inference: the binding constraint moved, and nothing said so

The receipt was the constraint until `20260904`. **Map coverage is the constraint now**, and 79% to
82% of the pass's seconds sit outside it, depending on which of the two readings above you take.

The obvious repair -- write more map rows -- reaches only a little of it, and the rank scan's own top
of the unmapped list shows why. Reading each of the twelve costliest unmapped guards' scans directly,
they fall into three kinds:

- **Census guards -- eight of twelve.** `standing_equipment` (81s), `declared_ceiling` (46s),
  `readme_metrics` (41s), `borrowed_number` (39s), `unshared_citation` (33s), `crushed_index` (32s),
  `rye_witness_walker` (26s), `living_card_ascii` (26s). Each walks the whole tree -- `git ls-files`
  with no pathspec, or `git grep ... -- .`. A census guard's honest watch-set **is the tree**, so
  its touch rate is 1.0 and `cost x (1 - touch)` is zero. A map row for it buys exactly nothing.
- **Build guards -- two of twelve.** `lantern_face` (35s) and `glow_preset_offset` (32s) spend their
  time in `rye build`. The design essay measured this class already: one witness spent 80-90% of its
  wall time in the compiler. A warm build cache is the right instrument here, where a skip is the wrong one.
- **Genuinely mappable -- two of twelve.** `topology_relaxed` (34s) and `topology_stretch` (28s)
  compute over their own fixtures and depend on almost nothing else. These two are the rows worth writing.

**So the 82.3% is structural rather than neglected.** This tree's roster is census-shaped by design,
because most of what it guards is a tree-wide property -- rooms named, links resolving, citations
shared, bytes ASCII, pins under bound. The instrument grew to match the thing it measures, and the
thing it measures is the whole tree.

## Projection: three doors, and which one this lane would take

**Horizon seven days. Assumptions:** the roster keeps growing at the rate my last census measured
(117 guards seated in four days), the fleet keeps eight seats, and no guard is retired.

- **Write map rows** -- recovers at most the two mappable guards near the top, about 62s of 1,454,
  and less as the census share grows. **Cheap, small, and already ranked** by the scan.
- **Cache the builds** -- the design essay's own Move 1, unbuilt. Bounded by how much of the pass is
  compilation, which this paper does not measure and names as unmeasured.
- **Make a census incremental** -- the one door that reaches the 82.3%. A census that folds a
  carried total forward over only the changed paths costs the diff rather than the tree. This is
  bounded accumulation over an append-only history, which is Tally's own shape and Caravan's own
  discipline, and it is the piece worth designing rather than merely scheduling.

**Falsifier, plainly.** Re-run `sh tools/fixtures/s/standing_equipment_scope_rank.sh` on
`20260915`. If `unmapped_cost_share` has fallen below 0.60 through map rows alone, the census claim
above is wrong and coverage was the constraint after all. If it holds above 0.75 while the roster
grows, the structural reading stands. **Confidence: moderate** for the census reading, which rests
on twelve guards read directly out of a population of 131 unmapped; **high** for the receipt and
hit-rate readings, which stand as files on disk quoted verbatim.

## What this hands the bench

Three things, smallest first.

**One comment is stale and one line fixes it** -- `standing_equipment_run.sh` line 1032-1038,
whose repair sits at line 897 of the same file. The claim also stands in a folded REDS shelf, which
is testimony and keeps every word.

**The hit-rate ledger wants a second reading beside `match`** -- whether a receipt with a
resolvable head was available at each open, since that is the question `--scoped` actually asks.
89 rows of a structurally-zero meter is a meter somebody will one day believe.

**The census-cost question is the one worth a design round**, and it is an engineering question rather than a scheduling one.
Everything cheaper already stands built.

## What this does not reach

Whether any guard is worth its seconds. This measures what proving costs and where the cost sits,
and stops there -- a slow guard that catches a real fault is a bargain, and every number here leaves
that judgment to a reader.
