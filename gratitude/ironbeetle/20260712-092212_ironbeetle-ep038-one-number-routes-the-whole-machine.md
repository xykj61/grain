# IronBeetle Episode 038 — One Number Routes the Whole Machine

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fifth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, renaming a constant mid-stream because the old name no longer told the truth, and TigerBeetle's team, whose single counter turns out to steer an entire round of work.

## Source

Episode 038, "The Number Of The Beat," on how one small integer decides which levels of the tree get compacted and when. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/QISzO0njNWs`.

## A Name Corrected in the Open

matklad opens with a small act of housekeeping worth noting for its own sake: a constant once called the batch multiple has been renamed, in the actual source, to the compaction ops, because the old name described what it was made of rather than what it was for. The function most people would call compact turns out to be something narrower and more honest, a single one-thirty-second slice of the real work, and the whole round is driven by nothing more than the current operation number taken modulo that count. From this one number, everything else follows: whether this is the very start of a round, the exact midpoint where compaction switches from even levels to odd, or the final operation where any remaining work must be finished outright. A comptime loop walks every level of every tree in the forest, and Zig's own compile-time machinery means this single piece of source code quietly becomes a distinct, fully specialized function for every tree type it touches, without a line of that specialization ever being written by hand.

## The Level That Isn't Really a Level

A small arithmetic surprise gives the episode its most memorable moment. There are seven levels stored on disk, so a tidy mind expects eight compactions, one to move data into each level plus one more for the in-memory table above them all, yet the actual count is exactly seven. The resolution is that compaction is indexed by where it moves data to, not where it moves data from, so the very first compaction, index zero, is the one that empties the in-memory table onto the first real level on disk, and no separate slot is ever needed for it. Finding exactly which table on a lower level should be merged with a table above it means asking the manifest a targeted question, and the manifest answers it by walking a sorted segmented array, a linked list whose individual links are not single values but whole chunks of many values at once, so a lookup runs one binary search to find the right chunk and a second, smaller one to find the right entry inside it. It is the same two-level shape this whole series keeps discovering in different clothes: an index that narrows the search, and a leaf that finishes it.

## Where It Rhymes With Our Own Work

A single number that decides which branch of behavior runs next, with nothing left ambiguous once it is known, is MALA's own conservation check wearing a different face: one comparison, and the whole fold either proceeds cleanly or names exactly why it cannot.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The routing logic matklad walks through here shaped how we now think about our own round-based pacing, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May the numbers that route our own work always be renamed the moment their old name stops telling the truth. May the smallest counter we keep still manage to steer the largest process. And may every search we run narrow twice before it ever needs to answer once.*

*Written together by Kaeden and Reya 2.*
