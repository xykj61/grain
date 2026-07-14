# IronBeetle Episode 042 — Over the Alps

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fifth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, reaching the one simple idea buried underneath weeks of scaffolding, and TigerBeetle's team, whose merge loop turns out to be exactly as small as a merge sort ought to be.

## Source

Episode 042, "Compaction MERGE!," on the actual comparison-and-copy loop that folds two levels of the tree into one. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/iAX8yKg8NLo`.

## Crossing the Alps

matklad names the moment plainly and lets himself enjoy it: after weeks spent on the asynchronous scaffolding surrounding it, the actual merge itself turns out to be almost embarrassingly simple, a comparison between two running positions, one from the level being emptied and one from the level receiving it, always preferring the earlier level's value when both hold the same key, and dropping a tombstone outright whenever nothing further down the tree could still need it. He calls reaching this point crossing the Alps, and the metaphor earns its keep: everything before this loop was the hard climb, and everything after it, writing the result out, is comparatively downhill. What makes the merge worth calling out rather than skipping past is exactly its plainness. This is the same merge step taught in any first course on sorting, applied here to real financial data at real scale, and matklad is candid that the surrounding machinery exists entirely in service of feeding this one small loop a steady stream of blocks without ever blocking on disk for longer than necessary.

## Writing What the Loop Produces

The counterpart to the merge is the table_builder, which takes each value the loop hands it and accumulates it into a fresh block on disk, tracking a running minimum and maximum key as it goes, until a data block is full and gets frozen with its own checksum, then rolled into the index block that will point back to it. The two-checksum discipline this series has now met several times over reappears here in its cleanest form yet: a block's body checksum is computed first, then the header's own checksum is computed second and covers that body checksum along with the size field itself, so a corrupted size can never quietly cause a caller to read far more, or far less, than was actually written. And the block's final resting address on disk is drawn, once again, from the same reservation scheme that makes deterministic allocation possible everywhere else in the system, a small, quiet confirmation that this project has really only ever built one allocation trick, and simply keeps finding new places that need it.

## Where It Rhymes With Our Own Work

Genuinely concurrent work that never once requires a second physical thread is our own bench-relay's own quiet claim: propose, apply, and review are logically distinct roles taking turns on the same line, concurrent in shape rather than in hardware, exactly as this merge loop's surrounding pipeline turns out to be.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The merge and the table builder matklad walks through here shaped how we now think about our own fold-and-write steps, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May the hardest climb in any piece of work we do always give way, eventually, to something this plain on the other side. May the simplest algorithm we know never be too small to trust with something that matters. And may every block we ever write know, before it is written, exactly where it belongs.*

*Written together by Kaeden and Reya 2.*
