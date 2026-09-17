# The name that scopes a number

**Stamp:** `20260917.081605`
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Landed -- **mixed room**: the readings below are bound by
[`tools/l/loom_name_witness.rish`](../tools/l/loom_name_witness.rish); the ruling this paper asks
for is vision until Keaton's word seats it
**Kin:** [`20260917-074214_the-numbers-nobody-can-compare.md`](20260917-074214_the-numbers-nobody-can-compare.md)
-- [`20260917-054941_the-unit-that-survives-the-pier.md`](20260917-054941_the-unit-that-survives-the-pier.md)
-- [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)

A measurement in this tree's journal wears a key: `wall_s`, `guards`, `red`. The key is how a
reader finds the number again months later, and it is the only thing standing between that reader
and a comparison the numbers cannot support. This paper measures how much of that work the key
actually does, and it finds the answer is close to none.

## What stood before this lap

The lap before this one built
[`tools/fixtures/l/loom_sitting_scan.sh`](../tools/fixtures/l/loom_sitting_scan.sh), which asks
whether a key can prove a change at all. It groups a key's values by the day shelf each log was
born on, takes each sitting's own spread as a resolution floor, and reads `spread_class`. When the
sitting medians range wider than their own median it answers `suspect_mixed`: several workloads are
sharing one key.

That reading names the condition and stops there, which was the right place for it to stop and
leaves one question open. A key can be mixed two ways, and the two want opposite repairs.

**Mixed across families.** Six ships write `wall_s`, each timing its own work. The populations are
genuinely separate, and a name separates them: `roster_cold_s` beside `roster_hot_s`, and a reader
meets two numbers that were never one.

**Mixed inside one family.** One roster pass runs long on a loaded pier and short on a quiet one.
The population is one, its variance is real, and no name reaches it.

`suspect_mixed` fires identically on both. So the card carried the question forward in the lane's
own words: *should a mixed key split at its NAME rather than be measured after?*

## The ground, taken at the door

The scoping mechanism the sitting reading already leans on is `LOOM_FAMILY`, an environment
variable holding a fixed string the whole journal line must contain. It works by convention: a
`loom` line is expected to declare its family in its first token.

Reading 6,574 tracked `loom` lines on `20260917` shows the convention runs in two forms, and the
tree's own laws name one:

| Form | Lines | Shape |
|---|---|---|
| pair | 4,112 | `loom witness=mandate_store_witness wall_ms=42` |
| bare | 2,035 | `loom molt files_working_tree=97 renames=6` |
| none | 427 | `loom files=99 v=40` -- the first token is already a measurement |

So 94 percent of lines declare a family, in two spellings, and 427 declare none at all. Those last
sit outside every `LOOM_FAMILY` value a reader could type. All three figures are **free** and move
with the journal; `sh tools/fixtures/l/loom_name_scan.sh <key>` reads them per key.

## The reading this lap adds

[`tools/fixtures/l/loom_name_scan.sh`](../tools/fixtures/l/loom_name_scan.sh) reads each occurrence
of a key beside the family its own line declares, and separates two facts that a single count would
braid:

- **kinds** -- distinct leading keys: `witness`, `roster`, `molt`. This is what `LOOM_FAMILY=<kind>`
  reaches.
- **scopes** -- distinct leading tokens: `witness=mandate_store_witness`. This is the finest
  population the line declares, and what a rename would have to separate.

Three verdicts follow. `name_scopes` when one scope writes the key, so its name already holds its
population. `kind_scopes` when one kind writes it under several instances, so a reader who types
`LOOM_FAMILY` is served and a reader who does not is misled. `name_shared` when several kinds write
it, where no single `LOOM_FAMILY` value reaches the key at all.

The read itself lives once. Both loom readers source
[`tools/fixtures/l/loom_values.sh`](../tools/fixtures/l/loom_values.sh), which this lap cut into two
named projections out of one `awk`, so the journal's grammar has one spelling and the two readings
stay in step. The elder reader's output is byte-identical either side of the change.

## The finding

Over the 60 keys `tools/l/loom_trend.sh --keys` lists, read `20260917`:

**`name_shared` 60 times. `kind_scopes` never. `name_scopes` never.**

Every key this fleet measures with is written by several families, and not one carries a name that
holds its own population. `wall_s`, the key the fleet times with, reads 580 occurrences across
**61 kinds and 340 scopes**, its largest kind holding 391 parts per thousand. A reader who scopes it
the one way the tooling offers still reads at most two values in five.

`name_scopes` does appear on the journal, on keys written once -- `blobs_targeted`,
`commits_resigned`. One occurrence has one scope by arithmetic rather than by naming, so the scan
prints `scope_evidence=unmeasured` beside that verdict. A key earns `name_shared` by being useful;
the well-named keys are the ones nobody has had a second use for.

## The falsifier, run rather than promised

A reader may reasonably answer that family multiplicity is a label on a page and the spread is the
real thing. If so, keys written by many kinds would carry spreads like keys written by few, the
rename would buy nothing, and this paper's argument would fall.

Crossing both readings over the 46 keys where each answers, `20260917`:

| Kinds writing the key | Keys | Median `within_ppt` |
|---|---|---|
| 20 or fewer | 21 | **1,069** |
| 50 or more | 10 | **7,449** |

Sevenfold. Family multiplicity travels with the noise floor, so a split at the name is aimed at
something the numbers already show.

**Held honestly:** this is association rather than cause, the high bucket holds ten keys, and a key
written by many families is also a key written often -- busyness alone could carry some of the gap.
The reading that would settle it is a split actually performed, with the two halves' floors read
after. Confidence: moderate, on a horizon of one lap's measurement.

## What `name_shared` does not mean

`wall_s` is a cross-cutting key on purpose. Every family times with it, and a reader wanting one
family's timing is expected to say which. `name_shared` there reports the shape working as
designed.

`composite` makes the case sharpest. It reads `one_population` on spread -- floor 107 ppt, the
tightest key in the journal -- and `name_shared` on name, across 27 kinds and 82 scopes. Both
readings are right: quality-assurance grades share one scale honestly, so 27 families writing them
is 27 families using one ruler. A name that scopes and a population that behaves are two properties,
and a key may hold either alone.

So the scan gates nothing, and the verdict is a fact about a name rather than a fault in a lane.

## What this asks for

The measurement is done and the ruling is Keaton's. Three doors stand, and they differ in price
rather than in principle.

**Leave it.** `LOOM_FAMILY` reaches the pair form, a reader who types it is served, and 6,574 lines
keep every word they wrote. The cost is that the reader who does not type it reads 61 workloads as
one, and nothing says so.

**Name the timing keys.** A timing key splits at its name -- `roster_cold_s`, `publish_copy_s` --
while count keys stay shared. Timing is where the fleet's claims of improvement actually live, and
where a sevenfold floor does the most damage.

**Carry the floor beside the number.** A claim of improvement cites its resolution floor from
`loom_sitting_scan.sh` in the same sentence as its figure. This is the lightest door and changes no
journal line; it changes what a session log may assert.

The third and the second compose. Naming a key repairs the reading forward, and quoting the floor
repairs the claim today -- which is the shape this tree already reaches for when a measurement and
a habit both want fixing.

## What this does not read

Whether two scopes measure the same work under two names, which is this reading turned around and
wants its own run. Whether a value means what its writer thought. Any grouping of a family finer
than its leading token. And the pier at any other moment: every figure here moves with the journal,
so the commands are given above rather than the numbers alone.

*May every number carry a name that says whose it is, so a reader years from now compares what was
truly alike and leaves apart what was never one thing.*
