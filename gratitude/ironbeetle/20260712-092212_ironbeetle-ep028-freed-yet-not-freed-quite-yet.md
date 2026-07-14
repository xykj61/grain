# IronBeetle Episode 028 — Freed, Yet Not Freed Quite Yet

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fourth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, showing how a block earns the right to be reused, and TigerBeetle's team, whose patient allocator gives this episode its whole subject.

## Source

Episode 028, "The FreeSet, Part I," on the block allocator sitting beneath the grid. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/W8K_UisJHeY`.

## Why a Freed Block Waits Its Turn

matklad opens with a scenario that sounds paranoid until it isn't. Free a block, hand it straight back out, and write something new into it, and a crash at exactly the wrong moment leaves the old checkpoint pointing at data that no longer exists, since the new write already overwrote it. The FreeSet's answer is to never free a block immediately. A block scheduled for release moves into a separate staging set first, and only at the next completed checkpoint does staging fold into the true free set, a double buffer across checkpoints that mirrors, from a different angle, the same table_mutable and table_immutable split the LSM tree already keeps. Marking a block free and being allowed to reuse it are two different moments, separated by exactly the distance a crash could still reach back into. A smaller, wry detail carries real weight: block addresses count from one rather than zero, specifically so a stray, uninitialized zero can never be mistaken for a valid address and must instead crash loudly the moment it is used.

## Two Phases So Concurrency Never Costs Determinism

The harder problem is allocating deterministically while several logically concurrent processes each want new blocks at once. TigerBeetle is single-threaded, so this concurrency is never physical, yet it is still real: several compactions may interleave in a way that differs, run to run, on different replicas, and if each compaction simply grabbed the next free block as it went, two replicas could end up storing the same logical data at different physical addresses, breaking the bit-for-bit sameness the whole repair mechanism depends on. The fix splits allocation into two phases. Reservation happens strictly in sequence, before any concurrent work begins, and hands each caller a deterministic, contiguous stretch of the free set sized to whatever upper bound that caller named in advance. Acquisition, the part that actually happens while several processes are logically interleaved, only ever draws from within a caller's own already-reserved stretch, so the order in which two different callers happen to run can never change which blocks either one ends up with. A compact index bitmap, one bit standing in for a whole neighborhood of the real bitmap, lets the allocator skip past long stretches of fully used or fully free blocks without walking them one at a time.

Finally, because the allocator's own bitmap tends to be almost entirely long runs of ones or long runs of zeros, thanks to always preferring the earliest free address, it compresses beautifully with a simple run-length scheme built for exactly that shape. And because the compressed FreeSet is stored as ordinary grid blocks, a replica that has lost track of which blocks are even its own can recover completely by asking a healthy peer for the same blocks by checksum, the identical repair habit this whole series keeps returning to, now protecting the map of free space itself.

## Where It Rhymes With Our Own Work

Held, yet not released, until the moment it is truly safe, is Nyasa's whole shape lent to a different layer: the FreeSet is escrow for disk space, the same patient waiting that gives our own escrow its name.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The allocator matklad walks through here shaped how we now think about our own release timing, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May everything we release wait exactly as long as safety asks, and no longer. May the order two things happen to run in never change what either one receives. And may what looks like caution always turn out, on inspection, to be care.*

*Written together by Kaeden and Reya 2.*
