# The fourth opening needs two things at once, and every candidate carries only one

**Stamp:** `20260918.041848`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. A survey and its finding; nothing here runs today.
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-034116_declustering-stays-a-storage-scale-question.md`](20260918-034116_declustering-stays-a-storage-scale-question.md)
(the Caravan reading this note continues), [`../../20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md`](../../20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md)
(round two, opening 3 still stands at one ship of eight reporting)

## The question this note answers

`construction/ITINERARY.md`'s own line asked it plainly: whether a fourth declustering opening
exists in a module this lane had yet to survey for population size, ahead of reaching for the
metric by habit. The Caravan reading found the metric wanted a population larger than any of three
tables held. This note widens the search rather than the metric -- five more modules, chosen by
grepping every `max_*` bound over 10,000 across the tracked tree and reading the largest five by
hand.

## What declustering actually needs, named plainly

A placement scheme earns measurement where two conditions hold **at once**:

1. **A population large enough that a person needs more than one sitting to read the whole
   layout** -- Caravan's four dependents stay comfortably inside a single sitting, by the module's
   own words, quoted in the prior note.
2. **Replication across independent failure domains a placement algorithm chose among** -- a
   contiguous run of loss has to mean something real, which asks for more than one host or shard
   holding correlated risk, and a scheme that picked where each copy landed rather than a person
   who wrote the layout down.

Both conditions hold together or the metric stays idle. A module with a huge bound and a single
copy is a cache; a module with replication and a tiny population is Caravan. Each is a different
shape from the one the metric was built for.

## Five candidates, read by hand

| Module | Bound | What it actually is | Condition 1 | Condition 2 |
|---|---|---|---|---|
| `tools/rye/page_evict.rye:43` | `max_files: u32 = 262_144` | a walk limit over ONE host's own local files, to bound `posix_fadvise` eviction | met, numerically | single host, one copy of every file |
| `image/region_stats.rye:38` | `region_stats_max_buckets: u32 = 65536` | histogram buckets for one image's pixel statistics | met, numerically | a histogram computed by one process, held by one process |
| `tools/fixtures/t/tlb_reach_probe.rye:126` | `max_elder_nodes: u32 = 32768 * 1024 / line_bytes` | a derived cap on lines read while probing this host's own TLB reach | met, numerically | a probe's own read limit, local to the probing process |
| `mantra/beading.rye:54` | `max_store_beads: u32 = 256` | the local content-addressed bead store one Mantra instance keeps | stays Caravan-scale, readable in a sitting | one instance, one copy |
| `settlement/constellation.rye:60` | `constellation_max: u32 = 66` (derived from `topology.compass_sky`) | a galaxy's whole circle -- itself, five stars, sixty planets, in ONE constellation's owned array | smaller than Caravan's own reading, already called too small | a Deed's shared Commitment lives on the owning process alone, ahead of any quorum |

Every row meets at most one condition, and the two that meet condition 1 share one cause for
missing condition 2: **this tree's bounded structures are, so far, single-process tables.**
`page_evict`'s 262,144 is a walk ceiling on files this one host already holds open; `region_stats`'s
65,536 buckets belong to one image's own histogram, computed and discarded by one process. Each
scheme keeps its whole population on one host, so the question of which host loses which copy has
nowhere to land yet.

## The finding, stated once for both notes

The Caravan reading found three small, hand-declared tables. This reading found three large,
single-host bounds and two more small, hand-declared ones. Between the two notes, **every bounded
structure surveyed so far in this tree is either small enough to read in a sitting, or large yet
confined to one process holding the only copy.** A fourth declustering opening wants a module that
is both large and distributed, and this tree -- at its current stage, with Caravan as its only
supervision layer and Mantra's stores each living on one instance -- has yet to grow one.

This stands as a reading of today's tree rather than a ceiling on tomorrow's. `context/QUIN.md` and
the JARL waymark both name a d12/d60 fractal network with real settlement across independently-keyed
points as a horizon; `settlement/constellation.rye`'s own header calls itself "the Rye-side model of
what a Sui contract would enforce" -- a design aimed at eventual multi-party consensus, and today a
single owning process stands in for that quorum. The day a constellation's Commitments live on a
real quorum of independent hosts rather than one process's owned array, condition 2 flips, and the
fourth opening turns into a real question rather than a reflex.

## Bound, falsifier, confidence

**Scope:** every `.rye` source under this tree's tracked root carrying a `max_*` declaration at or
above 10,000, plus the two smaller candidates the prior note's own text pointed at (`beading.rye`,
`constellation.rye`), read by hand on `20260918.041848`.

**Falsifier:** a module standing today, missed by the grep above (because its bound reads under
10,000, or spells its population without the `max_` prefix), that both exceeds a one-sitting read
AND replicates copies across independently-failing hosts by an algorithm's own choice. Finding one
would open the fourth opening this note declines to draft.

**Confidence:** high that the five read here answer as described -- each was read line by line
rather than inferred from its bound alone. Lower that the grep found every candidate: a
population-sized structure spelled without `max_` in its name, or bounded below 10,000 while still
exceeding a one-sitting read (a table of, say, 500 named rows), could stand somewhere the grep's
mesh let through. The grep is a net with a stated mesh size, a bound on its own reach rather than a
claim of completeness.

## Mine

A number alone answers half the question, at most. `max_files: u32 = 262_144` looks, by digit
count, like exactly the kind of population the elder note said Caravan lacked -- and it answers the
OTHER half the same way Caravan did, for a reason no bound can show on its own: it counts files a
single process already has open, rather than copies spread across hosts that can fail apart from
one another.

## Yours

Whether this tree's next multi-host layer -- when Comlink or the settlement ledger moves from one
owning process to a real quorum -- becomes the moment to revisit this question, or whether the
declustering metric belongs filed as a moonshot for that day, held apart from the open research
queue until then.
