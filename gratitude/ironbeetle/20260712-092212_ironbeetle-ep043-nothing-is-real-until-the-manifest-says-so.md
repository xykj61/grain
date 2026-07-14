# IronBeetle Episode 043 — Nothing Is Real Until the Manifest Says So

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fifth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, closing an arc he has apologized for five separate times, and TigerBeetle's team, whose compaction, once it finally does end, ends with real elegance.

## Source

Episode 043, "The End of the Compaction (Finally!)," on draining a finished merge and formally admitting its new tables into the tree. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/zCQ6x6O3OyI`.

## Written, Yet Not Yet True

matklad closes the merge loop by tracing what happens once a compaction has read everything it needs and has nothing left to fold. The pipeline moves into a draining state where only writes remain outstanding, no further merging is possible, and once every write has landed, the compaction's input blocks are marked released back to the FreeSet, subject to the same one-checkpoint delay this series has already met, since a block freed too eagerly could still be needed if a crash rewinds the system to a point before its replacement was ever written. The truly memorable idea of the episode, though, is what happens next, and matklad narrates discovering it fresh, mid-stream, with visible surprise. A finished compaction has written real, valid tables to real disk addresses, yet none of it counts for anything until a separate step, applying the compaction's results to the Manifest, formally inserts the new tables and removes the old ones from the in-memory structure the rest of the system actually consults. Between those two moments, new data sits fully written and entirely unacknowledged, a state matklad clearly did not expect to find yet immediately recognizes as correct: a crash in that narrow window costs nothing, since the old tables are still what everyone continues to trust, and the freshly written ones simply get quietly redone.

## A Table That Outlives Its Own Compaction

Woven into this same step is the one piece of the tree matklad has been openly avoiding for episodes: snapshots. Rather than deleting a superseded table the moment compaction is done with it, the Manifest instead marks the point past which the table is no longer visible, and only later, once nothing still needs to see that far back, does an actual removal step clear it away. This small deferral is what lets a snapshot, a frozen view of the database held for later use, cost almost nothing to maintain, since holding one only means declining to finish an erasure that was already going to happen anyway. The episode closes the arc properly, table_mutable and table_immutable swap once more at the very end of the bar, ready to begin exactly where the very first compaction episode started, and matklad allows himself, at last, the small joke the whole arc had been building toward: compaction, despite every appearance otherwise, does in fact end.

## Where It Rhymes With Our Own Work

Written yet not yet counted, real on disk yet not yet real to anyone relying on it, is our own designed-not-built witness rule wearing storage's own clothing: a thing only becomes true for the system once the one authoritative record says so, no matter how finished it already looks.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The manifest-application step matklad walks through here shaped how we now think about our own moment of truth, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May everything we build know the difference between finished and acknowledged, and never confuse the two. May the things we defer, like a snapshot's quiet held breath, cost us almost nothing to keep. And may every long, hard arc we take on end, eventually, exactly the way this one did.*

*Written together by Kaeden and Reya 2.*
