# A snapshot that cannot shrink the history it carries buys nothing

**Stamp:** `20261001.122725`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. This stays design, waiting for its own first witness.
**Room:** vision -- one finding and one proposal, each waiting for its own first witness.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra and Tally
**Kin:** [`../20260918/20260918-060850_mantra-revision-counter-wants-a-declared-ceiling.md`](../20260918/20260918-060850_mantra-revision-counter-wants-a-declared-ceiling.md)
(the sibling reading of Mantra's four live counters), `mantra/snapshot_export.rye`,
`mantra/recall_lap1.rye`, `mantra/recall_catch_up.rye`

## Where this picks up

The kin paper read Mantra's `revision` counter and found it climbs and holds, the same rule
`caravan/dwell.rye` already names in a comment. Reading the module beside it --
`mantra/snapshot_export.rye`, the one place the word "replay" appears in `mantra/*.rye` outside its
own delivery shim -- surfaced a second, still-open question: **when the catalog this tree means to
hold "every valuable fact" in grows past what one peer can replay from genesis, what does a snapshot
actually buy?**

## Observation: what the code does today

`mantra/recall_lap1.rye`'s `BoltCatalog` holds leaves in one fixed array, `leaves: [max_bindings]LeafBinding`,
`max_bindings: u32 = 16` (`recall_lap1.rye:20`). A path already bound at a given revision keeps its
own leaf permanently: `append_leaf` reads `if (self.find_leaf(...)) |_| return error.RevisionImmutable;`
(`recall_lap1.rye:169`), and three further call sites assert that exact outcome
(`recall_lap1.rye:425,431,498`). **Every leaf stands exactly as written** -- each fact keeps its own
place beside the ones before it, for as long as the catalog itself lives. A catalog only grows, one
leaf per fact, until `CatalogFull` (`recall_lap1.rye:166`).

`mantra/snapshot_export.rye`'s `export_catalog` function's own comment states its job plainly:
*"Export every leaf in `src` as one or more resin-batch frames under a snapshot header"*
(`snapshot_export.rye:467`). `import_catalog` rebuilds a fresh catalog from those frames, and
`assert_catalog_replay` checks *"every leaf in `expect` recalls identically from `got`"*
(`snapshot_export.rye:589`) -- the witness that a round-tripped catalog is byte-for-byte the one
that left. Both functions walk **every leaf the catalog holds**, bounded per frame by
`max_batch_entries: u32 = 16` and `max_batch_bytes: u32 = 4096` (`resin_batch.rye:29-30`), chained
across frames by `stage_horizon_catalog` and `export_catalog_horizon` for a catalog bigger than one
frame holds. Grepping `mantra/*.rye` for "interval" or "cadence" turns up only
`recall_subscribe_poll.rye`'s polling clock (`default_poll_interval_ns`); `export_catalog` today
runs only when a hand calls it directly. A snapshot, as the code exists, is a manual, whole-catalog
operation.

## Inference: a snapshot here costs the same as a cold replay, since nothing ever shrinks

In a database or a log-structured store, a checkpoint is cheap relative to replay because it writes
only the *current* value of each key: the mutation history that produced it steps aside, and a cold
reader needs the checkpoint plus whatever mutations landed after it, a small remainder of the whole
log. **That saving rests on one precondition: the checkpoint is allowed to be smaller than the
history it summarizes.**

Mantra's catalog stands in a different shape. `RevisionImmutable` keeps a later revision of a path
as a *new* leaf beside the old one, always an addition rather than a replacement -- so "the current
state" and "the full history" stay the same object, by the ledger's own law
(`reds-first.md`'s neighbor, `accrete-never-break`, read here as a storage consequence rather than a
style rule). `export_catalog` walking every leaf is therefore a *re-encoding* of the identical set
of facts a cold `import_catalog` would otherwise receive by replay, rather than a compaction step.
Taking a "snapshot" today costs exactly what a full replay already costs, since the snapshot and the
replay read the same S leaves either way.

**This stands opposite the classic checkpoint-interval trade-off**, and naming the difference is the
finding. The standard argument (used to justify periodic database checkpointing) minimizes
`(checkpoint_cost / N) + (replay_cost * N / 2)` over snapshot spacing `N`, because `checkpoint_cost`
there is assumed small and roughly constant. Here `checkpoint_cost` is `c * S`, the same order as
`replay_cost * S`, because the "checkpoint" is a full re-statement of history rather than a summary
of it. Every spacing `N` leaves a Mantra snapshot costing as much as the replay it would spare a new
peer, as the format is defined today.

## The actual tension this surfaces

A snapshot could grow cheap the ordinary way: carry only the *latest* revision per `(peer, bolt,
path)` tuple, dropping the intermediate ones, the way a database checkpoint drops superseded row
versions. That shrinks a snapshot to one leaf per live path rather than one leaf per fact ever
written. **It also meets a promise this tree has already made about the product this storage
serves.** `construction/ITINERARY.md`'s own growth ladder names *"The consent you can change"*
milestone's completion signal as *"revoked use refuses while history remains visible"* -- history a
shrunk snapshot would leave behind for a peer who bootstraps from it rather than from genesis.

This reads as a product-meaning question wearing a performance costume. It is a real fork in what
"snapshot" is allowed to mean here: a **full-history snapshot** -- cheap to write, since it is just
another encoding of the log, yet costing a reader the same as replay -- or a **projected snapshot**
-- cheap for both writer and reader, at the price that a peer bootstrapping from one alone sees only
current state, with full history staying available from a peer that still holds the original log.
The product's own stated promise already answers which one the catalog format defaults to; a
projected snapshot, should it ever be wanted, would stand as a second, clearly-named artifact rather
than a cheaper `export_catalog`.

## First witness

A fixture that builds a `BoltCatalog` with `max_bindings` leaves across three or four distinct
`(peer, bolt, path)` tuples at varying revisions, calls `export_catalog`, and counts the leaves in
the resulting frames against the catalog's own `leaf_count`. The claim this proves: **every leaf
appears in the export, matching the catalog's own count exactly**. A second fixture constructs a
*projected* reader -- a separate scan, standing apart from `export_catalog` itself, that walks the
same catalog and keeps only the highest-revision leaf per tuple -- and shows its output stays
strictly smaller than the full export whenever any tuple carries more than one revision. The second
fixture proves the possible saving exists while leaving the first fixture's own path untouched; the
gap between the two numbers is what the product decision above is actually sizing.

## Horizon, assumptions, falsifier, confidence

**Horizon.** The first fixture (counting leaves through a real export) is a day's work, reading
`snapshot_export.rye`'s own test scaffolding (`init_witness_source_catalog`, `witness_horizon_plan`)
rather than inventing new fixtures. The second fixture (a read-only projected-view scan) is
comparably small and stays a report, reading state rather than changing it.

**Assumptions.** `max_bindings=16` is read here as a lap1-scale ceiling rather than a permanent one;
the finding concerns the *shape* of export cost relative to catalog size, which holds at any ceiling
this constant is later raised to. `export_catalog` genuinely walks every leaf, confirmed by reading
its own loop and comment directly rather than inferred, with deduplication by tuple absent from both
functions it calls.

**Falsifier.** A later revision of `export_catalog`, or a wrapping module, already deduplicates by
tuple before writing frames -- a case this reading would have missed by stopping at
`snapshot_export.rye` and `resin_batch.rye` alone. **Run this grep before trusting the claim above**:
a loop in `mantra/*.rye` that tracks "already exported for this path," or compares revisions before
appending a leaf to an export buffer, would falsify it.

```sh
grep -n "already.*export\|dedup\|latest.*revision.*only" mantra/snapshot_export.rye mantra/resin_batch.rye
```

Run on `20261001.122725`: the grep returns empty, confirming the two files implicated hold no such
loop. The remaining Mantra files whose names went unread this lap still await the same check.

**Confidence.** High that `export_catalog` walks every leaf and reads each one plainly, with
deduplication by tuple absent from both functions it calls, confirmed by reading rather than
inferred. Medium on whether a projected snapshot is wanted at all -- that choice belongs to
Patchouli, since it owns Mantra's replay horizon, and the product promise named above may settle it
firmly in favor of full history, leaving this paper's second fixture standing as a permanent finding
rather than a build.

## What this leaves standing

Every seated behavior -- `export_catalog`, `import_catalog` -- stays exactly as it runs today. This
page names a cost shape that stays dormant at `max_bindings=16` and turns real the day that ceiling
rises toward production scale -- the same "cheap to state before it is needed" posture the sibling
papers in this lane already take with Caravan's confer-chain bound and Aurora's energy-crossover
rule.

---

May the history that must stay visible always find a format that can still afford to carry it.
