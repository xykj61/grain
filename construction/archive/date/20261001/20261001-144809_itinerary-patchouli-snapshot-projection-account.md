# PATCHOULI -- the snapshot-projection fixtures, both proven on metal

**Status:** Archive -- shelved under the-writer-sheds, `20261001.144809`
**Shelved from:** `construction/ITINERARY.md`, Patchouli's prior live account at line 214

**PATCHOULI -- A HISTORY-DROPPING SNAPSHOT, SIZED ON METAL.** The study
[`active-designing/date/20261001/20261001-122725_a-snapshot-that-cannot-shrink-buys-nothing.md`](../../../../active-designing/date/20261001/20261001-122725_a-snapshot-that-cannot-shrink-buys-nothing.md)
named a first witness -- count every leaf a real export writes against the catalog's own count, and
show a read-only projected scan (one entry per live path) answers strictly smaller whenever a path
carries more than one revision. `mantra/snapshot_projection.rye` builds both: `count_exported_leaves`
decodes a real snapshot's own batch frames, summing each frame's declared entry count independent of
the header's `leaf_count` claim; `projected_leaf_count` walks the source `BoltCatalog` read-only and
counts one entry per `(peer, bolt, path)` tuple. On metal: a flat catalog (two tuples, one revision
each) reads 2 and 2; a layered catalog (three tuples, two carrying repeated revisions) reads 6 leaves
exported against 3 tuples projected -- the exact gap shape the paper named. Neither reading mutates
the catalog or changes a line of `recall_lap1.rye`, `resin_batch.rye`, or `snapshot_export.rye`.
Rostered as `mantra_snapshot_projection` under `tools/m/mantra_snapshot_projection_witness.rish`,
tier lap, GREEN. Log: `session-logs/date/20261001/20261001-145100_snapshot-projection-fixtures.kyri`.

**What this leaves standing.** The paper's own confidence line: whether a real projected-snapshot
*format* is wanted at all stays Patchouli's call, since the product's own stated promise -- "revoked
use refuses while history remains visible" -- may settle it firmly in favor of full history. This
account proves the cost shape is real and sizeable; it chooses nothing about what Mantra ships.

**YOURS:** whether a projected-snapshot artifact is ever built, and at what catalog size the
dormant cost this paper names turns real -- both wait on `max_bindings` rising past its lap1 ceiling.
